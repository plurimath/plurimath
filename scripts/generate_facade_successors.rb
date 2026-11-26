# frozen_string_literal: true

# Run with the candidate's bundle, against a clean pinned candidate checkout.
# Never writes corpus/, fixtures/, provenance/, stages/ or generations/.
require "digest"
require "json"
require "open3"
require "yaml"
require "plurimath"

candidate, destination, testsuite = ARGV
abort "usage: #{$PROGRAM_NAME} CANDIDATE OUTPUT.json [TESTSUITE]" unless candidate && destination && (2..3).cover?(ARGV.length)
root = File.realpath(testsuite || File.join(candidate, "submodules/plurimath-testsuite"))
git = lambda do |*args|
  output, error, status = Open3.capture3("git", "-C", candidate, *args)
  abort error unless status.success?
  output.strip
end
abort "candidate must be clean" unless git.call("status", "--porcelain", "--untracked-files=no").empty?
loaded = File.realpath($LOADED_FEATURES.find { |path| path.end_with?("/plurimath.rb") })
abort "bundle does not load the pinned candidate" unless loaded.start_with?("#{File.realpath(candidate)}/")
Plurimath.xml_engine = Plurimath::XmlEngine::OxEngine
profile = "writer-fidelity-v1"
groups = {
  "asciimath/colour" => %w[colour-named colour-in-sum],
  "latex/colour" => %w[latex-colour-named latex-colour-in-sum latex-colour-over-frac],
  "mathml/layout" => %w[mathml-layout-008 mathml-layout-009],
  "mathml/over-under" => %w[mathml-over-under-015],
  "mathml/text" => %w[mathml-text-008],
  "mathml/fences" => %w[mathml-fences-021],
  "mathml/elementary-math" => %w[mathml-elementary-math-006],
  "mathml/enclose" => %w[mathml-enclose-001],
  "mathml/fractions" => %w[mathml-fractions-011],
  "mathml/partial-render" => %w[mathml-partial-011],
  "mathml/scripts" => %w[mathml-scripts-018],
  "omml/boxes" => %w[omml-boxes-001],
  "omml/scripts" => %w[omml-scripts-016],
}
source = lambda do |path, id|
  { "path" => path, "id" => id, "sha256" => Digest::SHA256.file(File.join(root, path)).hexdigest }
end
cases = groups.flat_map do |group, ids|
  path = "corpus/#{group}.yaml"
  data = YAML.safe_load_file(File.join(root, path), aliases: false)
  ids.map do |id|
    matches = data.fetch("cases").select { |row| row.fetch("id") == id }
    abort "missing/duplicate #{id}" unless matches.length == 1
    row = matches.first
    formula = Plurimath::Math.parse(row.fetch("input").dup, row.fetch("input_format").to_sym)
    # Match the recorded sequence: one formula reused across every target.
    changes = {}
    data.fetch("targets").each do |target|
      previous = row.fetch("expected").fetch(target)
      begin
        measured = formula.public_send("to_#{target}")
        expected = previous.is_a?(String) ? measured : { "output" => measured }
      rescue Plurimath::Math::ParseError => e
        expected = if previous.is_a?(Hash) && previous.key?("error")
                     previous
                   else
                     { "error" => { "category" => "parse_error", "error_class" => e.class.name, "message" => e.message } }
                   end
      end
      changes[target] = expected unless expected == previous
    end
    abort "no observed change for #{id}" if changes.empty?
    { "id" => "#{id}-#{profile}", "source" => source.call(path, id), "expected" => changes }
  end
end
path = "fixtures/renderer-expectations.yaml"
id = "renderer-mathml-mathml-820-1"
row = YAML.safe_load_file(File.join(root, path), aliases: false).fetch("cases").find { |item| item.fetch("id") == id }
steps = row.fetch("program").fetch("steps")
input = steps.find { |step| step["save"] == "v4" }.fetch("recipe").fetch("value").fetch("value")
decode = steps.find { |step| step["kind"] == "decode" && step["save"] == "v5" }
abort "renderer source boundary changed" unless decode.values_at("boundary", "format", "source") == %w[wrapper mathml v4]
formula = Plurimath::Mathml.new(input.dup).to_formula
refusals = %w[v6 v8].map do |slot|
  index = steps.index { |step| step["save"] == slot }
  method = steps.fetch(index).fetch("operation").fetch("method")
  begin
    formula.public_send(method)
    abort "expected a measured refusal for #{method}"
  rescue Plurimath::Error => e
    { "render_slot" => slot, "assertion_line" => steps.fetch(index + 1).fetch("assertion_line"),
      "error_class" => e.class.name, "message" => e.message }
  end
end
cases << { "id" => "#{id}-#{profile}", "source" => source.call(path, id), "refusals" => refusals }
abort "expected eighteen successors" unless cases.length == 18
lockfile = "#{ENV.fetch('BUNDLE_GEMFILE', File.join(candidate, 'Gemfile'))}.lock"
data = { "schema" => "plurimath-facade/successors/1", "profile" => profile,
         "producer" => { "repository" => "https://github.com/plurimath/plurimath",
                         "commit" => git.call("rev-parse", "HEAD"), "ruby" => RUBY_DESCRIPTION,
                         "lockfile_sha256" => Digest::SHA256.file(lockfile).hexdigest,
                         "generator_sha256" => Digest::SHA256.file(__FILE__).hexdigest,
                         "dependencies" => Gem.loaded_specs.sort.to_h.transform_values { |spec| spec.version.to_s } },
         "cases" => cases }
File.write(destination, "#{JSON.pretty_generate(data)}\n")
puts "measured #{cases.length} successors from #{data.fetch('producer').fetch('commit')}"
