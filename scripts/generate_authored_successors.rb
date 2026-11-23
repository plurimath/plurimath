# frozen_string_literal: true

# Measures only the six authored rows identified by writer-fidelity CI.
require "digest"
require "json"
require "open3"
require "yaml"
require "plurimath"
candidate, destination, testsuite = ARGV
abort "usage: #{$PROGRAM_NAME} CANDIDATE OUTPUT.json [TESTSUITE]" unless candidate && destination && (2..3).cover?(ARGV.length)
candidate = File.realpath(candidate)
$LOAD_PATH.unshift(File.join(candidate, "spec"))
require File.join(candidate, "spec/support/shared_renderer_fixtures")
root = File.realpath(testsuite || File.join(candidate, "submodules/plurimath-testsuite"))
loaded = File.realpath($LOADED_FEATURES.find { |path| path.end_with?("/plurimath.rb") })
abort "bundle does not load candidate" unless loaded.start_with?("#{candidate}/")
commit, status = Open3.capture2("git", "-C", candidate, "rev-parse", "HEAD")
abort "candidate has no commit" unless status.success?
changes, status = Open3.capture2("git", "-C", candidate, "diff", "--name-only", "HEAD", "--", "lib", "spec/support")
abort "candidate source must be committed" unless status.success? && changes.empty?
Plurimath.xml_engine = Plurimath::XmlEngine::OxEngine
Mml::V4::Configuration.adapter = :ox
profile = "writer-authored-v1"
path = "fixtures/renderer-expectations.yaml"
ids = %w[renderer-asciimath-asciimath-8025-1 renderer-math_zone-math_zone-2578-1 renderer-math_zone-math_zone-3453-1 renderer-math_zone-math_zone-4491-1 renderer-pretty-mathml-396 renderer-omml-line_breaks-line_breaks-537-1]
rows = YAML.safe_load_file(File.join(root, path), aliases: false).fetch("cases").select { |row| ids.include?(row.fetch("id")) }
abort "missing/duplicate row" unless rows.map { |row| row.fetch("id") }.sort == ids.sort
cases = rows.map do |row|
  entry = { "id" => "#{row.fetch('id')}-#{profile}", "source" => { "path" => path, "id" => row.fetch("id"), "sha256" => Digest::SHA256.file(File.join(root, path)).hexdigest } }
  if row.fetch("id") == "renderer-pretty-mathml-396"
    steps = row.fetch("program").fetch("steps")
    formula = Plurimath::Mathml.new(steps.first.fetch("recipe").fetch("value").dup).to_formula
    formulas = [formula, Plurimath::Mathml.new(formula.to_mathml).to_formula]
    entry["refusals"] = %w[v3 v6].zip(formulas).map do |slot, model|
      index = steps.index { |step| step["save"] == slot }
      begin
        model.to_asciimath
        abort "expected AsciiMath refusal"
      rescue Plurimath::Math::ParseError => error
        { "render_slot" => slot, "assertion_line" => steps.fetch(index + 1).fetch("assertion_line"), "error_class" => error.class.name, "message" => error.message }
      end
    end
  else
    replacements = []
    if row.key?("program")
      assertions = row.fetch("program").fetch("steps").select { |step| step["kind"] == "assert" }
      index = 0
      SharedRendererFixtures.run_program(row) do |actual, expected, _comparison|
        line = assertions.fetch(index).fetch("assertion_line")
        index += 1
        replacements << { "assertion_line" => line, "expected" => actual } unless actual == expected
      end
    else
      actual = SharedRendererFixtures.render(row)
      replacements << { "assertion_line" => row.fetch("source").fetch("assertion_line"), "expected" => actual } unless actual == row.fetch("expected")
    end
    abort "expected exactly one changed color assertion in #{row.fetch('id')}" unless replacements.length == 1
    abort "expected color fidelity output" unless replacements.first.fetch("expected").include?("FF0000")
    entry["renderer_assertions"] = replacements
  end
  entry
end
lockfile = "#{ENV.fetch('BUNDLE_GEMFILE', File.join(candidate, 'Gemfile'))}.lock"
data = { "schema" => "plurimath-facade/successors/1", "profile" => profile,
         "producer" => { "repository" => "https://github.com/plurimath/plurimath", "commit" => commit.strip,
                         "ruby" => RUBY_DESCRIPTION, "lockfile_sha256" => Digest::SHA256.file(lockfile).hexdigest,
                         "generator_sha256" => Digest::SHA256.file(__FILE__).hexdigest,
                         "dependencies" => Gem.loaded_specs.sort.to_h.transform_values { |spec| spec.version.to_s } }, "cases" => cases }
File.write(destination, "#{JSON.pretty_generate(data)}\n")
puts "measured #{cases.length} authored successors from #{commit.strip}"
