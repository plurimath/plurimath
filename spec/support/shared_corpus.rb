# frozen_string_literal: true

require "stringio"
require "yaml"

# Read the shared snapshots; never regenerate them while running the suite.
module SharedCorpus
  ROOT = File.expand_path("../../submodules/plurimath-testsuite", __dir__)
  CORPUS_ROOT = File.join(ROOT, "corpus")
  SCHEMA_DIR = File.join(ROOT, "schema")
  TARGETS = %w[asciimath latex mathml unicodemath omml html].freeze
  CALL_METHODS = %w[number_formatter unitsml].freeze

  class Error < StandardError; end

  unless File.file?(File.join(ROOT, "scripts/validate.rb")) &&
      File.file?(File.join(ROOT, "scripts/generate-corpus.rb"))
    raise Error, "shared testsuite is missing; run git submodule update --init --recursive"
  end

  require File.join(ROOT, "scripts/validate")
  # The generator's driver is guarded by $PROGRAM_NAME == __FILE__. Reuse its
  # portable projections and parser adapters without generating any fixtures.
  require File.join(ROOT, "scripts/generate-corpus")

  module_function

  def validate!(corpus_root)
    output = StringIO.new
    original_stdout = $stdout
    begin
      $stdout = output
      status = Testsuite::Runner.new(
        corpus_root: corpus_root, schema_dir: SCHEMA_DIR,
        integrity: true, allow_empty: false
      ).run
    rescue Testsuite::Failure, Errno::ENOENT => e
      raise Error, "#{corpus_root}: #{e.message}\n#{output.string}"
    ensure
      $stdout = original_stdout
    end
    raise Error, "shared corpus validation failed:\n#{output.string}" unless status.zero?
  end

  def load(corpus_root: CORPUS_ROOT)
    validate!(corpus_root)
    rows = Dir.glob(File.join(corpus_root, "*", "*.yaml")).flat_map do |path|
      # Only provenance may contain Time. It is validated above, and is never
      # loaded as executable cases here. No aliases or Ruby objects are allowed.
      payload = YAML.safe_load_file(path, aliases: false)
      kind = schema_kind(payload.fetch("schema"), path)
      payload.fetch("cases").map do |kase|
        format = CorpusGenerator::FORMATS.find { |entry| entry.name == kase.fetch("input_format") }
        raise Error, "#{path}: unsupported input format #{kase['input_format'].inspect}" unless format

        targets = payload.fetch("targets", [])
        unknown = targets - TARGETS
        raise Error, "#{path}: unsupported targets #{unknown.inspect}" unless unknown.empty?

        if kase.key?("call") && !CALL_METHODS.include?(kase.fetch("call").fetch("method"))
          raise Error, "#{path}: unsupported call #{kase['call'].inspect}"
        end

        { path: path, kind: kind, format: format, targets: targets, case: kase }
      end
    end
    raise Error, "#{corpus_root}: no conformance cases" if rows.empty?

    rows
  end

  def schema_kind(schema, path)
    case schema
    when "plurimath-corpus/rejections/1" then :rejection
    when %r{\Aplurimath-corpus/(asciimath|html|latex|mathml|omml|unicode|unitsml)/1\z} then :strings
    when "plurimath-corpus/calls/1", "plurimath-corpus/calls/2",
         %r{\Aplurimath-corpus/(asciimath|html|latex|mathml|omml|unicode|unitsml)/2\z}
      :outcomes
    else raise Error, "#{path}: unsupported schema #{schema.inspect}"
    end
  end

  def symbolize_keys(value)
    case value
    when Hash then value.to_h { |key, item| [key.to_sym, symbolize_keys(item)] }
    when Array then value.map { |item| symbolize_keys(item) }
    else value
    end
  end

  def call_options(call)
    return {} unless call

    args = symbolize_keys(call.fetch("args"))
    case call.fetch("method")
    when "number_formatter"
      formatter = Plurimath::Formatter::Standard.new(**args)
      { formatter: formatter }
    when "unitsml"
      { unitsml: args }
    else
      raise Error, "unsupported call #{call.inspect}"
    end
  end

  def render(formula, target, options)
    if options.key?(:unitsml) && target != "mathml"
      raise Error, "UnitsML XML calls require the mathml target"
    end

    formula.public_send("to_#{target}", **options)
  end

  def rejection_error(format, input)
    # Public parsing intentionally discards the parser cause. Check the public
    # refusal separately in the spec and recover the optional index here.
    error = { "category" => "parse_error" }
    begin
      format.parse_tree.call(CorpusGenerator.preprocessed_text(format, input))
    rescue Parslet::ParseFailed, Parsanol::ParseFailed => e
      error["index"] = failure_position(e.parse_failure_cause)
    end
    error
  end

  def serialize_tree(tree, path)
    CorpusGenerator.serialize_tree(normalize_slices(tree), path)
  end

  def failure_position(cause)
    return CorpusGenerator.failure_position(cause) unless cause.is_a?(Parsanol::Cause)

    children = cause.children || []
    return children.map { |child| failure_position(child) }.max unless children.empty?

    cause.source.input.byteslice(0, cause.position).length
  end

  def normalize_slices(value)
    case value
    when Parsanol::Slice then value.to_s
    when Hash then value.transform_values { |child| normalize_slices(child) }
    when Array then value.map { |child| normalize_slices(child) }
    else value
    end
  end
end
