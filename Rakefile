require "erb"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "opal/rspec/rake_task"
require_relative "lib/plurimath"

RSpec::Core::RakeTask.new(:spec)

# Opal testing support
begin
  Opal::RSpec::RakeTask.new(:"spec-opal")
rescue LoadError
  # Likely the dependencies haven't been upstreamed yet. Ensure you
  # run those tests via the `plurimath-js` repo's `env/plurimath`
  # script.
end

DOC_FILES = {
  "supported_parens_list.adoc" => :paren,
  "supported_symbols_list.adoc" => :symbols,
  "intent_supported_classes.adoc" => :intent,
}.freeze

DOC_FILES.each do |file_name, type|
  file file_name => [] do
    write_doc_file(file_name, type: type)
  end
end

def write_doc_file(doc_file, type:)
  File.open(doc_file, "a") do |file|
    case type
    when :intent
      write_intent_doc_file(file)
    else
      paren_symbols_doc(file, type)
    end
  end
end

def paren_symbols_doc(file, type)
  file.write(file_header)

  Plurimath::Utility.send(:"#{type}_files").each do |klass|
    next if klass::INPUT.empty?

    file_name = File.basename(klass.const_source_location(:INPUT).first, ".rb")
    file.write(documentation_content(file_name, klass))
  end

  file.write("|===")
end

def documentation_content(file_name, klass)
  <<~DOCUMENTATION
    | #{Plurimath::Utility.capitalize(file_name)}
    | `#{Plurimath::Utility.hexcode_in_input(klass) || klass.input(:asciimath).first}`
    #{input_for_formats(klass)}
  DOCUMENTATION
end

def file_header
  <<~HEADER
    |===
    | Math symbol name | Unicode character | AsciiMath | LaTeX | MathML | OMML | UnicodeMath

  HEADER
end

def input_for_formats(klass)
  %i[asciimath latex mathml omml unicodemath].map do |format|
    <<~ROW
      | #{format_input(format, klass)}
    ROW
  end.join
end

def format_input(format, klass)
  klass.input(format).flatten.map do |s|
    if %i[latex unicodemath].include?(format)
      "`\\#{s}`"
    else
      "`#{s}`"
    end
  end.join(", ").gsub("|", "\\|")
end

def write_intent_doc_file(file)
  file.write("= List of classes supporting `intent` encoding with relevant values\n")

  intent_classes.each do |klass|
    intents = klass.new.intent_names.values.map do |intent|
      "`#{intent}`"
    end

    file.write(
      <<~INTENT,

        * `#{klass.name.gsub('Plurimath::Math::', '')}`
        ** #{intents.join("\n** ")}
      INTENT
    )
  end

  file.write("\nIntent for unary classes like, sin, cos, tan, etc. will be `Function`.\n")
end

namespace :render do
  desc "A/B the shared mathml corpus through the render engines " \
       "(rake render:ab[CORPUS_DIR,OUT_DIR]; logifos via LOGIFOS_LIBRARY_PATH/LOGIFOS_FONT)"
  task :ab, [:corpus, :out] do |_task, args|
    require "yaml"
    require "json"
    require "fileutils"

    corpus = args[:corpus] || ENV["LOGIFOS_CORPUS"] ||
      File.expand_path("../plurimath-testsuite/stages/mathml", __dir__)
    out = args[:out] || "tmp/render-ab"
    raise "corpus not found: #{corpus}" unless File.directory?(corpus)

    FileUtils.mkdir_p(out)
    engines = { lasem: {} }
    if ENV["LOGIFOS_LIBRARY_PATH"] && ENV["LOGIFOS_FONT"]
      require "logifos"
      engines[:logifos] = {
        library_path: ENV["LOGIFOS_LIBRARY_PATH"],
        fonts: [Logifos::NativeRuntime.font(id: "stix", bytes: File.binread(ENV["LOGIFOS_FONT"]))],
      }
    end

    cases = render_ab_cases(corpus)
    raise "no corpus cases under #{corpus}" if cases.empty?

    cases.each do |id, input|
      flattened = id.tr("/", "__")
      outcomes = engines.to_h do |engine, opts|
        outcome = render_ab_one(input, engine, opts)
        outcome["record"] = render_ab_record(outcome["svg"]) if outcome["svg"]
        File.binwrite(File.join(out, "#{engine}__#{flattened}.svg"), outcome["svg"]) if outcome["svg"]
        [engine.to_s, outcome]
      end
      rendered = outcomes.values.all? { |outcome| outcome["record"] }
      match = rendered && outcomes.values.map { |outcome| outcome["record"].except("bytes") }.uniq.one?
      outcomes.each_value do |outcome|
        outcome["match"] = match if rendered
        outcome.delete("svg")
      end
      File.write(File.join(out, "#{flattened}.json"),
                 "#{JSON.pretty_generate({ 'id' => id, 'engines' => outcomes })}\n")
    end

    tally = render_ab_tally(out)
    File.write(File.join(out, "report.json"),
               "#{JSON.pretty_generate(
                 { 'corpus' => corpus, 'cases' => cases.size,
                   'engines' => engines.keys.map(&:to_s), 'tally' => tally },
               )}\n")
    puts JSON.pretty_generate({ corpus: corpus, cases: cases.size }.merge(tally))
  end
end

def render_ab_cases(corpus)
  Dir.glob(File.join(corpus, "generations", "*", "payloads", "*.yaml")).flat_map do |payload|
    document = YAML.safe_load_file(payload)
    generation = payload.split(File::SEPARATOR)[-3]
    stem = File.basename(payload, ".yaml")
    document["cases"].map do |row|
      # Model-roundtrip rows wrap the MathML in a {str:} mapping.
      input = row["input"]
      input = input["str"] if input.is_a?(Hash)
      ["#{generation}/#{stem}/#{row['id']}", input]
    end
  end
end

def render_ab_one(input, engine, opts)
  Plurimath::Math.render(input, :mathml, format: :svg, engine: engine, **opts)
    .then { |svg| { "svg" => svg } }
rescue StandardError => e
  { "error" => e.message[0, 200] }
end

def render_ab_record(svg)
  {
    "bytes" => svg.bytesize,
    "path" => svg.scan("<path").size,
    "rect" => svg.scan("<rect").size,
    "use" => svg.scan("<use").size,
    "g" => svg.scan("<g").size,
    "defs" => svg.scan("<defs").size,
    "view_box" => svg.include?("viewBox"),
  }
end

def render_ab_tally(out)
  tally = Hash.new(0)
  Dir.glob(File.join(out, "*.json")).each do |path|
    report = JSON.parse(File.read(path))
    states = report["engines"].values
      .map { |outcome| outcome["record"] ? "render" : "refusal" }
      .sort.uniq
    tally[states.join("+")] += 1
    tally["structural_match"] += 1 if report["engines"].values.all? { |outcome| outcome["match"] }
  end
  tally
end

def require_math_function_files
  (
    Dir.glob(File.join(__dir__, "lib/plurimath/math/function", "*.rb")) +
    Dir.glob(File.join(__dir__, "lib/plurimath/math/function", "*", "*.rb"))
  ).each do |file|
    require file
  end
end

def intent_classes
  require_math_function_files
  # Symbol classes load on demand; load them all so descendants is complete.
  Plurimath::Math::Symbols.eager_load!

  intent_classes = [
    Plurimath::Math::Function::TernaryFunction.descendants,
    Plurimath::Math::Function::BinaryFunction.descendants,
    Plurimath::Math::Function::UnaryFunction.descendants,
    Plurimath::Math::Function::Table.descendants,
    Plurimath::Math::Symbols::Symbol.descendants,
    Plurimath::Math::Function::UnaryFunction,
    Plurimath::Math::Function::Table,
    Plurimath::Math::Function::Nary,
    Plurimath::Math::Formula,
  ].flatten
  intent_classes.select do |klass|
    klass.method_defined?(:intent_names, false)
  end
end

task default: :spec
