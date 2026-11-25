# frozen_string_literal: true

# Internal staging probe, not a public component loader. Each scenario runs in
# a cold process with the selected XML engine. JSON records loaded files and
# pending entrypoints so later extraction PRs can compare the same operations.
# Usage: bundle exec ruby scripts/measure_optional_stages.rb
#          [--engine ox|oga] [--scenario NAME] [--output FILE]
# Exit: 0 = boundaries hold; 1 = eager dependency; 2 = usage/child failure.
require "json"
require "open3"
require "optparse"
require "rbconfig"
require_relative "measure_require"

module MeasureOptionalStages
  ROOT = File.expand_path("..", __dir__)
  SCENARIOS = {
    "require" => 'nil',
    "conversion" => <<~'RUBY',
      formula = Plurimath::Math.parse("x^2 + 3.14", :asciimath)
      %i[to_asciimath to_latex to_mathml to_omml to_html to_unicodemath]
        .to_h { |writer| [writer, formula.public_send(writer)] }
    RUBY
    "catalog_examples" => <<~'RUBY',
      {
        "symbol" => Plurimath::Math::Symbols::Alpha.catalog_entry,
        "function" => Plurimath::Math::Function::Sin.catalog_entry,
      }
    RUBY
    "catalog_metadata" => <<~'RUBY',
      Plurimath::Catalog::Validation.validate_metadata!(
        "name" => "alpha", "kind" => "symbol", "type" => "symbol", "arity" => nil
      )
    RUBY
    "number_formatting" => <<~'RUBY',
      Plurimath::NumberFormatter.new("en", localize_number: "#,##0.### ###")
        .localized_number("1234567.891")
    RUBY
    # Exercise the bridge without probing native availability or rendering.
    "renderer_dispatch" => 'Plurimath::Math::Renderer.normalize_format("SVG")',
    "intent_mathml" => <<~'RUBY',
      formula = Plurimath::Math.parse("ⅆf/ⅆx", :unicode)
      formula.to_mathml(intent: true)
    RUBY
  }.freeze
  GROUPS = {
    "catalog" => %r{/plurimath/catalog(?:/|\.rb$)},
    "catalog_documentation" => %r{/plurimath/(?:documentation|symbol_documentation)/catalog_methods\.rb$},
    "formatter" => %r{/plurimath/(?:formatter(?:/|\.rb$)|number_formatter\.rb$)},
    "renderer" => %r{/plurimath/math/renderer\.rb$},
    "native_backend" => %r{/(?:lasem\.rb|lasem/[^/]+\.(?:so|bundle|dll))$},
    "intent_processing" => %r{/plurimath/math/formula/intent_processing\.rb$},
  }.freeze
  ALLOWED = {
    "require" => [],
    "conversion" => [],
    "catalog_examples" => %w[catalog catalog_documentation],
    "catalog_metadata" => %w[catalog],
    "number_formatting" => %w[formatter],
    "renderer_dispatch" => %w[renderer],
    "intent_mathml" => %w[intent_processing],
  }.freeze
  CHILD = <<~'RUBY'
    require "json"
    require "plurimath"
    result = eval(ARGV.fetch(0), TOPLEVEL_BINDING)
    lib = ARGV.fetch(1)
    puts JSON.generate(
      result: result,
      files: $LOADED_FEATURES.select { |f| f.start_with?(lib + "/") }.map { |f| f.delete_prefix(lib + "/") }.sort,
      features: $LOADED_FEATURES.sort,
      pending: %i[Catalog Formatter Math NumberFormatter].to_h { |name| [name, Plurimath.autoload?(name)] }
    )
  RUBY

  module_function

  def probe(name, engine)
    env = { "PLURIMATH_OGA" => nil, "PLURIMATH_LEPTRIS" => nil }
      .merge(MeasureRequire::ENGINES.fetch(engine))
    lib = File.join(ROOT, "lib")
    out, err, status = Open3.capture3(env, RbConfig.ruby, "-I", lib, "-e", CHILD,
                                    SCENARIOS.fetch(name), lib, chdir: ROOT)
    raise "#{name} child failed (#{status}): #{err}" unless status.success?

    data = JSON.parse(out)
    features = data.delete("features")
    data["loaded_groups"] = GROUPS.to_h { |group, pattern| [group, features.any? { |f| f.match?(pattern) }] }
    data["violations"] = data["loaded_groups"].filter_map do |group, loaded|
      group if loaded && !ALLOWED.fetch(name).include?(group)
    end
    data
  end

  def call(argv)
    engine = "ox"
    output = nil
    names = SCENARIOS.keys
    OptionParser.new do |opts|
      opts.on("--engine NAME", %w[ox oga]) { |v| engine = v }
      opts.on("--scenario NAME", SCENARIOS.keys) { |v| names = [v] }
      opts.on("--output FILE") { |v| output = v }
    end.parse!(argv)
    raise OptionParser::InvalidArgument, argv.join(" ") unless argv.empty?

    scenarios = names.to_h { |name| [name, probe(name, engine)] }
    report = MeasureRequire.deep_sort(
      schema: "plurimath-perf/optional-stages/1", engine: engine,
      source: MeasureRequire.source_identity, ruby: RUBY_DESCRIPTION,
      scenarios: scenarios,
    )
    json = JSON.pretty_generate(report) + "\n"
    output ? File.write(output, json) : $stdout.write(json)
    scenarios.values.any? { |s| s.fetch("violations").any? } ? 1 : 0
  rescue OptionParser::ParseError, RuntimeError, JSON::ParserError, SystemCallError => e
    warn "measure_optional_stages: #{e.message}"
    2
  end
end

exit MeasureOptionalStages.call(ARGV) if $PROGRAM_NAME == __FILE__
