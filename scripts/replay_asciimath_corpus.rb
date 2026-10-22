# frozen_string_literal: true

# Replays the pinned plurimath-testsuite AsciiMath corpus against the
# Plurimath code loaded by this process, and fails unless every recorded
# outcome is reproduced byte for byte.
#
# Usage:
#   bundle exec ruby scripts/replay_asciimath_corpus.rb \
#     --testsuite-checkout DIR [--group NAME]... \
#     [--expected-provenance-sha256 HEX]
#
#   --testsuite-checkout DIR   a plurimath-testsuite tree (git checkout or
#                              `git archive` extract) whose corpus/ is read.
#   --group NAME               replay only corpus/asciimath/NAME.yaml; may be
#                              repeated. Default: every AsciiMath payload.
#   --expected-provenance-sha256 HEX
#                              SHA-256 the testsuite's corpus/provenance.yaml
#                              must have. Defaults to the pinned testsuite
#                              commit's file; override only for failure
#                              controls run against a deliberately edited copy.
#
# Exit status: 0 when every selected case reproduces; 1 when any case
# mismatches; 2 on a usage, provenance, integrity or payload-structure error
# (including an unknown schema, a missing expectation or zero selected cases).
#
# Before any expectation is used, corpus/provenance.yaml is checked against
# the pins below, and every payload it lists (all input formats, not only
# AsciiMath) is checked against its recorded SHA-256 and byte count.
#
# Dispatch is by each payload's `schema`; an unrecognized schema is an error,
# never a skip:
#   plurimath-corpus/asciimath/1  `expected[target]` is the rendered string.
#   plurimath-corpus/asciimath/2  `expected[target]` is {output:} or
#                                 {error: {category: parse_error}}.
#   plurimath-corpus/calls/1      as /2, rendered with the recorded
#                                 `number_formatter` call.
#   plurimath-corpus/calls/2      adds the `unitsml` call
#                                 (`to_mathml(unitsml: {xml: true})`).
#   plurimath-corpus/rejections/1 `Math.parse` must raise Math::ParseError and
#                                 the grammar's deepest failure offset into the
#                                 preprocessed text must equal `error.index`.
# Every case's `preprocessed` text is also checked. `parse_tree` and `model`
# are not replayed here: they are the A1 tree baseline's concern.

require "digest"
require "optparse"
require "yaml"
require "plurimath"

module AsciimathCorpusReplay
  class Error < StandardError; end

  # plurimath-testsuite e9e2403b2714219fa8ed80ad863460a9c5c7db0e
  TESTSUITE_COMMIT = "e9e2403b2714219fa8ed80ad863460a9c5c7db0e"
  PROVENANCE_SHA256 =
    "4a212fd1e5cdb0223e19b573ed22dbadd28f8d6fd1ef730c678b1d449248019a"
  PROVENANCE_SCHEMA = "plurimath-corpus/provenance/3"
  GENERATOR_COMMIT = "53b9c5b5fc6e26fdf56c4d31e5882fbd631e41da"
  GENERATOR_SHA256 =
    "f2ff26da538f90070d44077af2f60f475eb69bc3ff64424a1096e7a0b8e1af66"
  ORACLE_COMMIT = "ae20be111a26fdd988c58be0bfb2b7f6fe6e352f"
  ORACLE_VERSION = "0.11.12"
  XML_ENGINE = "Plurimath::XmlEngine::OxEngine"

  INPUT_FORMAT = "asciimath"
  TARGETS = %w[asciimath latex mathml unicodemath omml html].freeze
  ERROR_CATEGORIES = %w[parse_error].freeze
  NUMBER_FORMATTER_ARGS = %w[locale options precision string_format].freeze

  CASE_KEYS = %w[id input input_format preprocessed expected parse_tree
                 model].freeze
  CALL_CASE_KEYS = (CASE_KEYS + %w[call]).freeze
  REJECTION_CASE_KEYS = %w[id input input_format preprocessed error].freeze
  PAYLOAD_KEYS = %w[schema group description input_format targets
                    cases].freeze
  REJECTION_PAYLOAD_KEYS = %w[schema group description input_format
                              cases].freeze

  # schema => [payload keys, case keys, outcome shape, call methods allowed]
  SCHEMAS = {
    "plurimath-corpus/asciimath/1" => [PAYLOAD_KEYS, CASE_KEYS, :string, []],
    "plurimath-corpus/asciimath/2" => [PAYLOAD_KEYS, CASE_KEYS, :outcome, []],
    "plurimath-corpus/calls/1" =>
      [PAYLOAD_KEYS, CALL_CASE_KEYS, :outcome, %w[number_formatter]],
    "plurimath-corpus/calls/2" =>
      [PAYLOAD_KEYS, CALL_CASE_KEYS, :outcome, %w[number_formatter unitsml]],
    "plurimath-corpus/rejections/1" =>
      [REJECTION_PAYLOAD_KEYS, REJECTION_CASE_KEYS, :rejection, []],
  }.freeze

  # Counts and failures of one run.
  class Report
    attr_reader :cases, :outcomes, :failures, :payloads

    def initialize
      @cases = Hash.new(0)
      @outcomes = Hash.new { |h, k| h[k] = Hash.new(0) }
      @failures = []
      @payloads = Hash.new(0)
    end

    def outcome(schema, kind)
      @outcomes[schema][kind] += 1
    end

    def fail!(schema, location, message)
      @outcomes[schema]["mismatch"] += 1
      @failures << "#{location}: #{message}"
    end

    def total_cases
      @cases.values.sum
    end

    def lines
      out = ["schema                         payloads cases  checks"]
      @cases.keys.sort.each do |schema|
        checks = @outcomes[schema].sort.map { |k, v| "#{k}=#{v}" }.join(" ")
        out << format("%<schema>-30s %<payloads>8d %<cases>5d  %<checks>s",
                      schema: schema, payloads: @payloads[schema],
                      cases: @cases[schema], checks: checks)
      end
      out << "total: #{@payloads.values.sum} payloads, #{total_cases} cases, " \
             "#{@failures.size} failures"
      out
    end
  end

  module_function

  # --- provenance and integrity ---------------------------------------------

  def sha256(bytes)
    Digest::SHA256.hexdigest(bytes)
  end

  def load_yaml(path)
    YAML.safe_load(File.binread(path).force_encoding(Encoding::UTF_8),
                   aliases: false)
  rescue Psych::Exception => e
    raise Error, "#{path}: not loadable YAML (#{e.class}: #{e.message})"
  end

  def check_equal!(label, actual, expected)
    return if actual == expected

    raise Error,
          "provenance #{label} is #{actual.inspect}, expected #{expected.inspect}"
  end

  # Returns the provenance document after checking it against the pins, the
  # running process and the bytes of every payload it lists.
  def verify_provenance!(corpus_dir, expected_sha256)
    path = File.join(corpus_dir, "provenance.yaml")
    raise Error, "#{path} does not exist" unless File.file?(path)

    actual_sha = sha256(File.binread(path))
    unless actual_sha == expected_sha256
      raise Error, "#{path} sha256 is #{actual_sha}, expected " \
                   "#{expected_sha256} (testsuite #{TESTSUITE_COMMIT})"
    end

    prov = load_yaml(path)
    raise Error, "#{path}: not a mapping" unless prov.is_a?(Hash)

    check_equal!("schema", prov["schema"], PROVENANCE_SCHEMA)
    check_equal!("committable", prov["committable"], true)
    check_equal!("warnings", prov["warnings"], [])
    check_equal!("generator.repository.commit",
                 prov.dig("generator", "repository", "commit"), GENERATOR_COMMIT)
    check_equal!("generator.repository.clean",
                 prov.dig("generator", "repository", "clean"), true)
    check_equal!("generator.sha256", prov.dig("generator", "sha256"),
                 GENERATOR_SHA256)
    check_equal!("oracle.gem", prov.dig("oracle", "gem"), "plurimath")
    check_equal!("oracle.commit", prov.dig("oracle", "commit"), ORACLE_COMMIT)
    check_equal!("oracle.version", prov.dig("oracle", "version"), ORACLE_VERSION)
    check_equal!("oracle.clean", prov.dig("oracle", "clean"), true)
    check_equal!("xml_engine", prov["xml_engine"], XML_ENGINE)
    check_equal!("configuration", prov["configuration"], {})

    verify_payloads!(corpus_dir, prov["payloads"])
    prov
  end

  def verify_payloads!(corpus_dir, payloads)
    unless payloads.is_a?(Array) && !payloads.empty?
      raise Error, "provenance lists no payloads"
    end

    payloads.each do |entry|
      rel = entry["path"]
      if !rel.is_a?(String) || rel.start_with?("/") || rel.split("/").include?("..")
        raise Error, "provenance payload path #{rel.inspect} is not a safe " \
                     "relative path"
      end

      file = File.join(corpus_dir, rel)
      raise Error, "payload #{rel} listed in provenance is missing" unless File.file?(file)

      bytes = File.binread(file)
      unless bytes.bytesize == entry["bytes"]
        raise Error, "payload #{rel} is #{bytes.bytesize} bytes, provenance " \
                     "records #{entry['bytes'].inspect}"
      end
      unless sha256(bytes) == entry["sha256"]
        raise Error, "payload #{rel} sha256 #{sha256(bytes)} does not match " \
                     "provenance #{entry['sha256'].inspect}"
      end
    end

    listed = payloads.map { |e| e["path"] }
    on_disk = Dir.glob(File.join(corpus_dir, "*", "*.yaml"))
      .map { |f| f.delete_prefix("#{corpus_dir}/") }
    unlisted = on_disk - listed
    return if unlisted.empty?

    raise Error, "payloads not covered by provenance: #{unlisted.sort.join(', ')}"
  end

  # The process must match the conditions the corpus was generated under.
  def verify_runtime!
    engine = Plurimath.xml_engine.to_s
    unless engine == XML_ENGINE
      raise Error, "this process uses XML engine #{engine}; the corpus was " \
                   "generated with #{XML_ENGINE} (unset PLURIMATH_OGA)"
    end

    config = Plurimath.configuration
    non_default = {
      "locale" => config.locale,
      "number_formatter" => config.number_formatter,
      "decimal" => (config.decimal unless config.decimal ==
                    Plurimath::Configuration::DEFAULT_DECIMAL),
      "evaluation_max_iterations" =>
        (config.evaluation_max_iterations unless
          config.evaluation_max_iterations ==
          Plurimath::Configuration::DEFAULT_MAX_ITERATIONS),
    }.compact
    return if non_default.empty?

    raise Error, "Plurimath configuration is not the default the corpus " \
                 "was generated with: #{non_default.inspect}"
  end

  # --- selection ---------------------------------------------------------------

  def select_payloads(corpus_dir, provenance, groups)
    paths = provenance["payloads"].map { |e| e["path"] }
      .select { |p| p.start_with?("#{INPUT_FORMAT}/") }.sort
    available = paths.map { |p| File.basename(p, ".yaml") }
    unless groups.empty?
      unknown = groups - available
      raise Error, "unknown --group #{unknown.join(', ')}" unless unknown.empty?

      paths = paths.select { |p| groups.include?(File.basename(p, ".yaml")) }
    end
    raise Error, "zero AsciiMath payloads selected" if paths.empty?

    paths.map { |p| File.join(corpus_dir, p) }
  end

  # --- replay -------------------------------------------------------------------

  def replay_file(path, report)
    payload = load_yaml(path)
    replay_payload(payload, File.basename(path, ".yaml"), report)
  end

  # Replays one parsed payload. Structural problems raise Error; a behavior
  # difference is recorded in the report as a failure.
  def replay_payload(payload, group, report)
    raise Error, "#{group}: payload is not a mapping" unless payload.is_a?(Hash)

    schema = payload["schema"]
    spec = SCHEMAS[schema]
    raise Error, "#{group}: unknown schema #{schema.inspect}" unless spec

    payload_keys, case_keys, shape, call_methods = spec
    check_keys!(payload, payload_keys, "#{group}: payload")
    unless payload["group"] == group
      raise Error, "#{group}: payload group is #{payload['group'].inspect}"
    end
    unless payload["input_format"] == INPUT_FORMAT
      raise Error, "#{group}: input_format is #{payload['input_format'].inspect}"
    end

    targets = payload_targets(payload, shape, group)
    cases = payload["cases"]
    unless cases.is_a?(Array) && !cases.empty?
      raise Error, "#{group}: payload has no cases"
    end

    ids = cases.map { |c| c.is_a?(Hash) ? c["id"] : nil }
    dupes = ids.tally.select { |_, n| n > 1 }.keys
    raise Error, "#{group}: duplicate case ids #{dupes.inspect}" unless dupes.empty?

    report.payloads[schema] += 1
    cases.each do |kase|
      raise Error, "#{group}: case is not a mapping" unless kase.is_a?(Hash)

      location = "#{group}/#{kase['id']}"
      check_keys!(kase, case_keys, location)
      unless kase["input"].is_a?(String) && kase["input_format"] == INPUT_FORMAT
        raise Error, "#{location}: input must be a String with input_format " \
                     "#{INPUT_FORMAT}"
      end

      report.cases[schema] += 1
      check_preprocessed(kase, schema, location, report)
      if shape == :rejection
        replay_rejection(kase, schema, location, report)
      else
        layout = { shape: shape, targets: targets, call_methods: call_methods }
        replay_case(kase, schema, layout, location, report)
      end
    end
  end

  def check_keys!(hash, allowed, location)
    missing = allowed - hash.keys
    extra = hash.keys - allowed
    return if missing.empty? && extra.empty?

    raise Error, "#{location}: missing keys #{missing.inspect}, unexpected " \
                 "keys #{extra.inspect}"
  end

  def payload_targets(payload, shape, group)
    return [] if shape == :rejection

    targets = payload["targets"]
    unless targets.is_a?(Array) && !targets.empty? && targets.uniq == targets
      raise Error, "#{group}: targets must be a non-empty list without repeats"
    end

    unknown = targets - TARGETS
    raise Error, "#{group}: unknown targets #{unknown.inspect}" unless unknown.empty?

    targets
  end

  def check_preprocessed(kase, schema, location, report)
    actual = Plurimath::Asciimath::Parser.new(kase["input"]).text
    if actual == kase["preprocessed"]
      report.outcome(schema, "preprocessed_match")
    else
      report.fail!(schema, location, "preprocessed #{actual.inspect}, " \
                                     "expected #{kase['preprocessed'].inspect}")
    end
  end

  def replay_case(kase, schema, layout, location, report)
    shape, targets, call_methods = layout.values_at(:shape, :targets, :call_methods)
    expected = kase["expected"]
    raise Error, "#{location}: expected is not a mapping" unless expected.is_a?(Hash)

    missing = targets - expected.keys
    extra = expected.keys - targets
    unless missing.empty? && extra.empty?
      raise Error, "#{location}: expectations missing for #{missing.inspect}, " \
                   "undeclared targets #{extra.inspect}"
    end

    call = build_call(kase["call"], call_methods, location)
    formula = parse(kase["input"], schema, location, report)
    return unless formula

    targets.each do |target|
      want = normalize_outcome(expected[target], shape, "#{location}.#{target}")
      got = render(formula, target, call)
      compare(schema, "#{location}.#{target}", want, got, report)
    end
  end

  def parse(input, schema, location, report)
    Plurimath::Math.parse(input, :asciimath)
  rescue StandardError => e
    report.fail!(schema, location, "parse raised #{e.class}: #{e.message}")
    nil
  end

  # Returns [:output, String] or [:error, category].
  def normalize_outcome(value, shape, location)
    if shape == :string
      raise Error, "#{location}: expectation is not a String" unless value.is_a?(String)

      return [:output, value]
    end

    unless value.is_a?(Hash) && value.size == 1
      raise Error, "#{location}: outcome must have exactly one of output/error"
    end

    if value.key?("output")
      raise Error, "#{location}: output is not a String" unless value["output"].is_a?(String)

      [:output, value["output"]]
    elsif value.key?("error")
      error = value["error"]
      unless error.is_a?(Hash) && error.keys == ["category"] &&
          ERROR_CATEGORIES.include?(error["category"])
        raise Error, "#{location}: unknown error outcome #{error.inspect}"
      end

      [:error, error["category"]]
    else
      raise Error, "#{location}: outcome has neither output nor error"
    end
  end

  # Returns a lambda rendering one target, or nil for a plain render.
  def build_call(call, call_methods, location)
    if call_methods.empty?
      raise Error, "#{location}: unexpected call" unless call.nil?

      return nil
    end

    unless call.is_a?(Hash) && call.keys.sort == %w[args method]
      raise Error, "#{location}: call must have exactly method and args"
    end

    method = call["method"]
    args = call["args"]
    unless call_methods.include?(method)
      raise Error, "#{location}: unknown call method #{method.inspect}"
    end

    case method
    when "number_formatter" then number_formatter_call(args, location)
    when "unitsml" then unitsml_call(args, location)
    end
  end

  # `call.args` are Formatter::Standard.new's keyword arguments. YAML carries
  # option keys as strings; the formatter reads them as symbols. Enumerated
  # option values recorded from Ruby symbols are coerced by the formatter
  # itself (FormatOptions#symbol_option), so values are passed as recorded.
  def number_formatter_call(args, location)
    unless args.is_a?(Hash) && args.keys.sort == NUMBER_FORMATTER_ARGS
      raise Error, "#{location}: number_formatter args must be exactly " \
                   "#{NUMBER_FORMATTER_ARGS.inspect}, got #{args.inspect}"
    end
    raise Error, "#{location}: options is not a mapping" unless args["options"].is_a?(Hash)

    kwargs = {
      locale: args["locale"],
      string_format: args["string_format"],
      precision: args["precision"],
      options: args["options"].transform_keys(&:to_sym),
    }
    formatter = Plurimath::Formatter::Standard.new(**kwargs)
    { kind: "number_formatter",
      render: ->(formula, target) { formula.public_send("to_#{target}", formatter: formatter) } }
  end

  def unitsml_call(args, location)
    unless args == { "xml" => true }
      raise Error, "#{location}: unitsml args #{args.inspect} are not the " \
                   "recorded {xml: true}"
    end

    { kind: "unitsml",
      render: lambda { |formula, target|
        unless target == "mathml"
          raise Error, "#{location}: unitsml call declared for #{target}"
        end

        formula.to_mathml(unitsml: { xml: true })
      } }
  end

  # Returns [:output, String], [:error, "parse_error"] or [:raised, message].
  def render(formula, target, call)
    output = if call
               call[:render].call(formula, target)
             else
               formula.public_send("to_#{target}")
             end
    [:output, output]
  rescue Error
    raise
  rescue Plurimath::Math::ParseError
    [:error, "parse_error"]
  rescue StandardError => e
    [:raised, "#{e.class}: #{e.message}"]
  end

  def compare(schema, location, want, got, report)
    if want == got
      report.outcome(schema, want.first == :output ? "output_match" : "render_error_match")
      return
    end

    report.fail!(schema, location, describe_mismatch(want, got))
  end

  def describe_mismatch(want, got)
    if want.first == :output && got.first == :output
      a = want.last
      b = got.last
      at = (0...[a.size, b.size].min).find { |i| a[i] != b[i] } || [a.size, b.size].min
      "output differs at character #{at}: expected " \
        "#{a[at, 40].inspect}, got #{b[at, 40].inspect}"
    else
      "expected #{want.inspect[0, 120]}, got #{got.inspect[0, 120]}"
    end
  end

  def replay_rejection(kase, schema, location, report)
    error = kase["error"]
    unless error.is_a?(Hash) && ERROR_CATEGORIES.include?(error["category"]) &&
        (error.keys - %w[category index]).empty? &&
        (!error.key?("index") || error["index"].is_a?(Integer))
      raise Error, "#{location}: unknown rejection error #{error.inspect}"
    end

    begin
      Plurimath::Math.parse(kase["input"], :asciimath)
      report.fail!(schema, location, "input was ACCEPTED; expected parse_error")
      return
    rescue Plurimath::Math::ParseError
      report.outcome(schema, "rejection_match")
    rescue StandardError => e
      report.fail!(schema, location, "raised #{e.class} instead of " \
                                     "Plurimath::Math::ParseError")
      return
    end

    actual_index = grammar_failure_index(kase["preprocessed"])
    if actual_index == error["index"]
      report.outcome(schema, error.key?("index") ? "rejection_index_match" : "rejection_no_index_match")
    else
      report.fail!(schema, location, "failure index #{actual_index.inspect}, " \
                                     "expected #{error['index'].inspect}")
    end
  end

  # The deepest Parslet failure offset in the preprocessed text, the way the
  # corpus generator recorded it; nil when the grammar does not fail.
  def grammar_failure_index(preprocessed)
    Plurimath::Asciimath::Parse.new.parse(preprocessed)
    nil
  rescue Parslet::ParseFailed => e
    deepest_position(e.parse_failure_cause)
  end

  def deepest_position(cause)
    children = cause.children || []
    return cause.pos.charpos if children.empty?

    children.map { |child| deepest_position(child) }.max
  end

  # --- CLI ------------------------------------------------------------------

  def parse_options(argv)
    options = { groups: [], provenance_sha256: PROVENANCE_SHA256 }
    parser = OptionParser.new do |o|
      o.banner = "Usage: ruby scripts/replay_asciimath_corpus.rb " \
                 "--testsuite-checkout DIR [--group NAME]... " \
                 "[--expected-provenance-sha256 HEX]"
      o.on("--testsuite-checkout DIR") { |v| options[:checkout] = v }
      o.on("--group NAME") { |v| options[:groups] << v }
      o.on("--expected-provenance-sha256 HEX") { |v| options[:provenance_sha256] = v }
      o.on("-h", "--help") { options[:help] = o.help }
    end
    parser.parse!(argv.dup)
    options[:usage] = parser.help
    options
  rescue OptionParser::ParseError => e
    raise Error, e.message
  end

  def run(argv, out: $stdout)
    options = parse_options(argv)
    if options[:help]
      out.puts options[:help]
      return 0
    end
    raise Error, "--testsuite-checkout is required\n#{options[:usage]}" unless options[:checkout]

    corpus_dir = File.join(File.expand_path(options[:checkout]), "corpus")
    provenance = verify_provenance!(corpus_dir, options[:provenance_sha256])
    verify_runtime!
    out.puts "testsuite: #{corpus_dir} (provenance sha256 " \
             "#{options[:provenance_sha256]}; pinned commit #{TESTSUITE_COMMIT})"
    out.puts "oracle: plurimath #{ORACLE_VERSION} @ #{ORACLE_COMMIT}; " \
             "#{provenance['payloads'].size} payload checksums verified"
    out.puts "running: plurimath #{Plurimath::VERSION}, ruby #{RUBY_VERSION}, " \
             "#{Plurimath.xml_engine}"
    if Plurimath::VERSION != ORACLE_VERSION
      out.puts "note: running Plurimath version differs from the oracle's"
    end

    report = Report.new
    select_payloads(corpus_dir, provenance, options[:groups]).each do |path|
      replay_file(path, report)
    end
    raise Error, "zero cases selected" if report.total_cases.zero?

    report.lines.each { |line| out.puts line }
    report.failures.each { |failure| out.puts "MISMATCH #{failure}" }
    report.failures.empty? ? 0 : 1
  end
end

if $PROGRAM_NAME == __FILE__
  begin
    exit AsciimathCorpusReplay.run(ARGV)
  rescue AsciimathCorpusReplay::Error => e
    warn "replay_asciimath_corpus: #{e.message}"
    exit 2
  end
end
