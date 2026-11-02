# frozen_string_literal: true

require_relative "shared_model_recipes"
require "yaml"

module SharedUnicodeFixtures
  ROOT = if RUBY_ENGINE == "opal"
           File.expand_path("submodules/plurimath-testsuite")
         else
           File.expand_path("../../submodules/plurimath-testsuite", __dir__)
         end
  BOUNDARIES = {
    "raw" => { "class" => "UnicodeMath::Parse", "input" => "unicode_encode_entities", "output" => "post_processing" },
    "model" => { "class" => "UnicodeMath::Parser", "input" => "remove_prefix", "output" => "identity" },
  }.freeze
  class Error < StandardError; end

  module_function

  def document
    @document ||= begin
      text = File.read(File.join(ROOT, "fixtures/unicode-expectations.yaml"))
      data = RUBY_ENGINE == "opal" ? YAML.load(text) : YAML.safe_load(text) # rubocop:disable Security/YAMLLoad
      unless data.is_a?(Hash) && data["schema"] == "plurimath-fixtures/unicode-expectations/1" &&
          data["boundaries"] == BOUNDARIES && data["cases"].is_a?(Array) && data["cases"].length == 675
        raise Error, "invalid shared Unicode expectations"
      end
      ids = data.fetch("cases").map { |row| row.fetch("id") }
      indices = data.fetch("cases").map { |row| row.fetch("index") }
      unless ids.uniq.length == ids.length && indices == (1..675).to_a
        raise Error, "duplicate or incomplete Unicode expectation indices"
      end
      data
    end
  end

  def cases(boundary)
    raise Error, "unsupported Unicode boundary" unless BOUNDARIES.key?(boundary)

    document.fetch("cases")
  end

  def input(row)
    text = row.fetch("input")
    raise Error, "Unicode input must be text or number" unless text.is_a?(String) || text.is_a?(Integer) || text.is_a?(Float) && text.finite?

    text.is_a?(String) ? text.dup : text
  end

  def expectation(row, boundary)
    value = SharedModelRecipes.build(row.fetch("expected").fetch(boundary))
    valid = boundary == "raw" ? value.is_a?(Hash) : value.is_a?(Plurimath::Math::Core)
    raise Error, "Unicode expected value has wrong boundary type" unless valid

    value
  end

  def refusal_pattern(outcome)
    unless outcome.keys.sort == %w[category kind message_pattern] && outcome["kind"] == "parse_error" &&
        outcome["category"] == "parse_error" && outcome["message_pattern"] == { "source" => "Expected one of \\[", "options" => [] }
      raise Error, "unsupported Unicode refusal"
    end

    Regexp.new(outcome.fetch("message_pattern").fetch("source"))
  end
end
