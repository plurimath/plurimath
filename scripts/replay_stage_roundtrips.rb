# frozen_string_literal: true

# Replays the plurimath-testsuite roundtrip generation pinned in
# spec/fixtures/roundtrip-pin.yml through this checkout of plurimath.
#
#   bundle exec ruby scripts/replay_stage_roundtrips.rb \
#     [--testsuite PATH] [--pin FILE] [--generation N]
#
# Before any case runs it checks the pin: its schema and fields, that the
# testsuite checkout is at the pinned commit, that the roundtrip ledger has
# the pinned generation with the pinned snapshot digest, and that the digest
# recomputed from the generation's files is the same. --generation, when
# given, must equal the pin's.
#
# Then every case of every payload is replayed on the Ox and the Oga XML
# engine. The input is parsed with Plurimath::Math.parse and the case's
# options. A case whose targets record a refusal must fail to parse. Any
# other case must parse to the recorded model, when one is recorded, and for
# each target Formula#to_<target> must write the recorded output byte for
# byte, and reading that output back must give the recorded lossless flag
# and, for a lossy target, the recorded loss.
#
# Prints the lossless, lossy, refused and differing counts. A pin failure,
# an empty generation or any differing case exits 1.

require "digest"
require "open3"
require "optparse"
require "yaml"
require_relative "roundtrip_cases"

module ReplayStageRoundtrips
  class Error < StandardError; end

  ROOT = File.expand_path("..", __dir__)
  DEFAULT_TESTSUITE = File.join(ROOT, "submodules", "plurimath-testsuite")
  DEFAULT_PIN = File.join(ROOT, "spec", "fixtures", "roundtrip-pin.yml")
  PIN_SCHEMA = "plurimath-stage/pin/1"
  PIN_KEYS = %w[schema repository commit language generation
                snapshot_digest].freeze
  REPOSITORY = "https://github.com/plurimath/plurimath-testsuite"
  LANGUAGE = "roundtrip"
  CASE_SCHEMA = "plurimath-stage/roundtrip/1"
  TARGETS = RoundtripCases::TARGETS

  Pin = Struct.new(:commit, :generation, :digest, keyword_init: true)

  module_function

  def load_pin(path)
    doc = YAML.safe_load_file(path, aliases: false)
    raise Error, "#{path}: not a mapping" unless doc.is_a?(Hash)

    missing = PIN_KEYS - doc.keys
    extra = doc.keys - PIN_KEYS
    raise Error, "#{path}: missing #{missing.join(', ')}" unless missing.empty?
    raise Error, "#{path}: unknown keys #{extra.join(', ')}" unless extra.empty?
    check(doc["schema"] == PIN_SCHEMA, "#{path}: schema is not #{PIN_SCHEMA}")
    check(doc["repository"] == REPOSITORY,
          "#{path}: repository is not #{REPOSITORY}")
    check(doc["commit"].is_a?(String) && doc["commit"].match?(/\A\h{40}\z/),
          "#{path}: commit is not a 40-hex commit")
    check(doc["language"] == LANGUAGE, "#{path}: language is not #{LANGUAGE}")
    check(doc["generation"].is_a?(Integer) && doc["generation"] >= 1,
          "#{path}: generation is not a positive integer")
    check(doc["snapshot_digest"].is_a?(String) &&
            doc["snapshot_digest"].match?(/\Asha256:\h{64}\z/),
          "#{path}: snapshot_digest is not sha256:<64 hex>")
    Pin.new(commit: doc["commit"], generation: doc["generation"],
            digest: doc["snapshot_digest"])
  rescue Psych::Exception, Errno::ENOENT => e
    raise Error, "#{path}: #{e.message}"
  end

  def check(condition, message)
    raise Error, message unless condition
  end

  def head(testsuite)
    out, status = Open3.capture2("git", "-C", testsuite, "rev-parse", "HEAD")
    raise Error, "#{testsuite}: not a git checkout" unless status.success?

    out.strip
  end

  # sha256 over `<sha256>  <path>\n` for every file of the generation, paths
  # relative to the generation directory, ordered by their bytes.
  def snapshot_digest(dir)
    paths = Dir.glob("**/*", File::FNM_DOTMATCH, base: dir)
      .select { |rel| File.file?(File.join(dir, rel)) }
    lines = paths.sort_by(&:b).map do |rel|
      "#{Digest::SHA256.file(File.join(dir, rel)).hexdigest}  #{rel}\n"
    end
    "sha256:#{Digest::SHA256.hexdigest(lines.join)}"
  end

  # The generation directory once the checkout matches +pin+.
  def verify(testsuite, pin)
    actual = head(testsuite)
    check(actual == pin.commit,
          "pin commit #{pin.commit} is not the checkout's HEAD #{actual}")
    ledger = YAML.safe_load_file(
      File.join(testsuite, "generations", "#{LANGUAGE}.yaml"), aliases: false
    )
    entry = ledger.fetch("entries").find do |e|
      e["generation"] == pin.generation
    end
    check(entry, "the #{LANGUAGE} ledger has no generation #{pin.generation}")
    check(entry["snapshot_digest"] == pin.digest,
          "pin digest #{pin.digest} is not the ledger's " \
          "#{entry['snapshot_digest']} for generation #{pin.generation}")
    dir = File.join(testsuite, entry.fetch("path"))
    computed = snapshot_digest(dir)
    check(computed == pin.digest,
          "generation #{pin.generation} files digest to #{computed}, " \
          "not the pinned #{pin.digest}")
    [dir, entry]
  end

  def cases(dir)
    Dir.glob(File.join(dir, "payloads", "*.yaml")).sort.flat_map do |path|
      doc = YAML.safe_load_file(path, aliases: false)
      check(doc["schema"] == CASE_SCHEMA,
            "#{path}: schema is not #{CASE_SCHEMA}")
      doc.fetch("cases")
    end
  end

  def refusal?(kase)
    kase["expected"].values.all? { |target| target.key?("refusal") }
  end

  def options(kase)
    kase.fetch("options", {}).to_h { |key, value| [key.to_sym, value] }
  end

  def parse(input, language, opts)
    Plurimath::Math.parse(input, language.to_sym, **opts)
  end

  # The differences between this checkout and the case; empty when it
  # reproduces.
  def differences(kase)
    source = kase.fetch("source")
    opts = options(kase)
    formula = begin
      parse(source.fetch("input"), source.fetch("language"), opts)
    rescue Plurimath::Math::ParseError => e
      return refusal?(kase) ? [] : ["input is refused: #{e.class.name}"]
    end
    return ["input parses, but the case records a refusal"] if refusal?(kase)

    diffs = []
    if kase.key?("model") && RoundtripCases.model(formula) != kase["model"]
      diffs << "model differs"
    end
    TARGETS.each do |name|
      diffs.concat(target_differences(formula, name, kase["expected"][name],
                                      opts))
    end
    diffs
  end

  def target_differences(formula, name, expected, opts)
    output = formula.public_send(RoundtripCases::WRITERS.fetch(name))
    return ["#{name}: output differs"] unless output == expected["output"]

    read = RoundtripCases::LOCALIZED.include?(name) ? opts : {}
    actual = begin
      back = parse(output, name, read)
      lossless = back == formula
      { "lossless" => lossless,
        "loss" => (RoundtripCases.loss(formula, back) unless lossless) }
    rescue Plurimath::Math::ParseError => e
      { "lossless" => false,
        "loss" => "reading the output back raises #{e.class.name}" }
    end
    wanted = { "lossless" => expected["lossless"], "loss" => expected["loss"] }
    actual == wanted ? [] : ["#{name}: #{actual.inspect} instead of #{wanted.inspect}"]
  end

  # Counts per target outcome, and the differing cases per engine.
  def replay(kases)
    counts = Hash.new(0)
    kases.each do |kase|
      if refusal?(kase)
        counts["refused"] += 1
      else
        kase["expected"].each_value do |target|
          counts[target["lossless"] ? "lossless" : "lossy"] += 1
        end
      end
    end
    differing = RoundtripCases::ENGINES.keys.flat_map do |engine|
      RoundtripCases.with_engine(engine) do
        kases.filter_map do |kase|
          diffs = differences(kase)
          { "engine" => engine, "id" => kase["id"], "differences" => diffs } \
            unless diffs.empty?
        end
      end
    end
    { "cases" => kases.size, "lossless" => counts["lossless"],
      "lossy" => counts["lossy"], "refused" => counts["refused"],
      "differing" => differing }
  end

  def run(testsuite: DEFAULT_TESTSUITE, pin: DEFAULT_PIN, generation: nil)
    pinned = load_pin(pin)
    if generation && generation != pinned.generation
      raise Error, "--generation #{generation} is not the pinned " \
                   "#{pinned.generation}"
    end
    dir, = verify(File.expand_path(testsuite), pinned)
    kases = cases(dir)
    raise Error, "generation #{pinned.generation} has no cases" if kases.empty?

    replay(kases)
  end

  def main(argv)
    opts = {}
    OptionParser.new do |o|
      o.on("--testsuite PATH") { |v| opts[:testsuite] = v }
      o.on("--pin FILE") { |v| opts[:pin] = v }
      o.on("--generation N", Integer) { |v| opts[:generation] = v }
    end.parse!(argv)
    result = run(**opts)
    result["differing"].each do |d|
      warn "#{d['engine']} #{d['id']}: #{d['differences'].join('; ')}"
    end
    puts "cases #{result['cases']}: targets lossless #{result['lossless']}, " \
         "lossy #{result['lossy']}; cases refused #{result['refused']}; " \
         "differing #{result['differing'].size}"
    result["differing"].empty? ? 0 : 1
  rescue Error => e
    warn "error: #{e.message}"
    1
  end
end

exit ReplayStageRoundtrips.main(ARGV) if $PROGRAM_NAME == __FILE__
