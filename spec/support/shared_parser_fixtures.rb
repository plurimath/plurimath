# frozen_string_literal: true

require_relative "shared_model_recipes"
require "yaml"

module SharedParserFixtures
  ROOT = if RUBY_ENGINE == "opal"
           File.expand_path("submodules/plurimath-testsuite")
         else
           File.expand_path("../../submodules/plurimath-testsuite", __dir__)
         end
  class Error < StandardError; end

  module_function

  def case_data(id, family = "parser-expectations")
    matches = document(family).fetch("cases").select { |row| row.fetch("id") == id }
    raise Error, "expected one shared parser recipe #{id}" unless matches.length == 1

    matches.first
  end

  def parser_input(row)
    input = row.fetch("input")
    raise Error, "parser input must be text" unless input.is_a?(String)

    case row.fetch("input_transform")
    when "identity" then input.dup
    when "strip_whitespace" then input.gsub(/\s/, "")
    else raise Error, "unsupported parser input transform"
    end
  end

  def document(family = "parser-expectations")
    unless %w[parser-expectations xml-parser-expectations].include?(family)
      raise Error, "unsupported shared parser fixture family"
    end
    @documents ||= {}
    @documents[family] ||= begin
      text = File.read(File.join(ROOT, "fixtures/#{family}.yaml"))
      data = RUBY_ENGINE == "opal" ? YAML.load(text) : YAML.safe_load(text) # rubocop:disable Security/YAMLLoad
      unless data.is_a?(Hash) && data["schema"] == "plurimath-fixtures/#{family}/1" &&
          data["cases"].is_a?(Array) && !data["cases"].empty?
        raise Error, "invalid or empty shared parser expectations"
      end
      ids = data.fetch("cases").map { |row| row.fetch("id") }
      raise Error, "duplicate shared parser IDs" unless ids.uniq.length == ids.length

      data
    end
  end
end
