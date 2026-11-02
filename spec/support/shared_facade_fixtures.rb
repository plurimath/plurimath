# frozen_string_literal: true

require "yaml"
require_relative "shared_renderer_fixtures"

module SharedFacadeFixtures
  ROOT = if RUBY_ENGINE == "opal"
           File.expand_path("submodules/plurimath-testsuite")
         else
           File.expand_path("../../submodules/plurimath-testsuite", __dir__)
         end
  METHODS = %w[localized_number twitter_cldr_reader formatted_number].freeze
  PROJECTIONS = %w[value base integer_part fraction_part decimal_separator digits_string base_notation prefix to_s].freeze
  STEP_FIELDS = {
    "build" => %w[kind save recipe], "facade_array" => %w[kind save items],
    "facade_map" => %w[kind save entries], "facade_merge" => %w[kind save source other],
    "facade_to_sym" => %w[kind save source], "facade_construct" => %w[kind save class args kwargs],
    "facade_format" => %w[kind save source method args kwargs], "facade_parse" => %w[kind save args kwargs],
    "facade_base" => %w[kind save operation args kwargs], "facade_project" => %w[kind save source property],
    "facade_index" => %w[kind save source key], "render" => %w[kind save source operation],
    "transform" => %w[kind save source normalization],
    "facade_error" => %w[kind steps error assertion_line], "facade_no_error" => %w[kind steps assertion_line],
  }.freeze
  class Error < StandardError; end

  module_function

  def rows
    @rows ||= begin
      text = File.read(File.join(ROOT, "fixtures/facade-expectations.yaml"))
      data = RUBY_ENGINE == "opal" ? YAML.load(text) : YAML.safe_load(text) # rubocop:disable Security/YAMLLoad
      raise Error, "unsupported facade schema" unless data.is_a?(Hash) && data["schema"] == "plurimath-fixtures/facade-expectations/1"

      cases = data.fetch("cases")
      raise Error, "empty facade expectations" unless cases.is_a?(Array) && !cases.empty?

      ids = cases.map { |entry| entry.fetch("id") }
      raise Error, "duplicate facade expectations" unless ids.uniq.length == ids.length

      cases
    end
  end

  def row(id)
    matches = rows.select { |entry| entry.fetch("id") == id }
    raise Error, "unknown facade expectation" unless matches.length == 1

    matches.first
  end

  def run(row, scope, &check)
    program = row.fetch("program").fetch("steps")
    raise Error, "facade program must be an array" unless program.is_a?(Array)

    program.each { |step| validate_step!(step) }
    unless program.any? { |step| %w[assert facade_error facade_no_error].include?(step.fetch("kind")) }
      raise Error, "facade program must contain a meaningful observation"
    end

    row.fetch("configuration").each do |key, value|
      raise Error, "unsupported facade configuration" unless key == "locale" && value.is_a?(String)
      raise Error, "native facade configuration differs" unless Plurimath.configuration.locale.to_s == value
    end
    steps(program, {}, {}, scope, &check)
  end

  def steps(program, slots, memo, scope, &check)
    raise Error, "facade program must be an array" unless program.is_a?(Array)
    program.each do |step|
      validate_step!(step)
      actual = case step.fetch("kind")
               when "build" then SharedModelRecipes.build(step.fetch("recipe"), memo)
               when "facade_array" then step.fetch("items").map { |id| slots.fetch(id) }
               when "facade_map"
                 step.fetch("entries").each_with_object({}) do |entry, result|
                   if entry.key?("spread")
                     value = slots.fetch(entry.fetch("spread"))
                     raise Error, "keyword spread must be a map" unless value.is_a?(Hash)
                     result.merge!(value)
                   else
                     result[slots.fetch(entry.fetch("key"))] = slots.fetch(entry.fetch("value"))
                   end
                 end
               when "facade_merge"
                 source, other = slots.fetch(step.fetch("source")), slots.fetch(step.fetch("other"))
                 raise Error, "map merge requires maps" unless source.is_a?(Hash) && other.is_a?(Hash)
                 source.merge(other)
               when "facade_to_sym"
                 value = slots.fetch(step.fetch("source"))
                 raise Error, "symbol conversion requires text" unless value.is_a?(String)
                 value.to_sym
               when "facade_construct"
                 args, kwargs = arguments(step, slots)
                 wanted = { "NumberFormatter" => (0..1), "Formatter::Standard" => (0..0), "Unitsml" => (1..1) }.fetch(step.fetch("class")) { raise Error, "unsupported facade constructor" }
                 raise Error, "facade constructor arity differs" unless wanted.include?(args.length)
                 case step.fetch("class")
                 when "NumberFormatter" then Plurimath::NumberFormatter.new(*args, **kwargs)
                 when "Formatter::Standard" then Plurimath::Formatter::Standard.new(*args, **kwargs)
                 when "Unitsml" then Plurimath::Unitsml.new(*args, **kwargs)
                 else raise Error, "unsupported facade constructor"
                 end
               when "facade_format"
                 method = step.fetch("method")
                 receiver = slots.fetch(step.fetch("source"))
                 unless METHODS.include?(method) && (receiver.instance_of?(Plurimath::NumberFormatter) || receiver.instance_of?(Plurimath::Formatter::Standard))
                   raise Error, "unsupported facade formatter call"
                 end
                 args, kwargs = arguments(step, slots)
                 wanted = method == "twitter_cldr_reader" ? 0 : 1
                 raise Error, "facade formatter arity differs" unless args.length == wanted
                 receiver.public_send(method, *args, **kwargs)
               when "facade_parse"
                 args, kwargs = arguments(step, slots)
                 raise Error, "facade parse expects input and type" unless args.length == 2
                 Plurimath::Math.parse(*args, **kwargs)
               when "facade_base"
                 args, kwargs = arguments(step, slots)
                 case step.fetch("operation")
                 when "parse"
                   klass = scope.__send__(:parser_class)
                   raise Error, "base prefix parser class differs" unless klass.is_a?(Class) && klass < Parslet::Parser
                   klass.new.parse(*args, **kwargs)
                 when "apply"
                   klass = scope.__send__(:transform_class)
                   raise Error, "base prefix transform class differs" unless klass.is_a?(Class) && klass < Parslet::Transform
                   klass.new.apply(*args, **kwargs)
                 else raise Error, "unsupported base prefix boundary"
                 end
               when "facade_project"
                 property = step.fetch("property")
                 raise Error, "unsupported facade projection" unless PROJECTIONS.include?(property)
                 slots.fetch(step.fetch("source")).public_send(property)
               when "facade_index"
                 receiver = slots.fetch(step.fetch("source"))
                 raise Error, "facade index requires map or array" unless receiver.is_a?(Hash) || receiver.is_a?(Array)
                 receiver[slots.fetch(step.fetch("key"))]
               when "render" then SharedRendererFixtures.render_model(slots.fetch(step.fetch("source")), step.fetch("operation"), memo)
               when "decode" then SharedRendererFixtures.decode(slots.fetch(step.fetch("source")), step, memo)
               when "transform" then SharedRendererFixtures.transform(slots.fetch(step.fetch("source")), step.fetch("normalization"))
               when "observe" then SharedRendererFixtures.observe(slots.fetch(step.fetch("source")), step.fetch("observation"), step.fetch("arguments", {}))
               when "assert"
                 expected = step.key?("expected_slot") ? slots.fetch(step.fetch("expected_slot")) : step["expected"]
                 check.call(step, slots.fetch(step.fetch("source")), expected)
                 nil
               when "facade_error", "facade_no_error"
                 operation = lambda { steps(step.fetch("steps"), slots, memo, scope, &check) }
                 check.call(step, operation, step["error"])
                 nil
               else raise Error, "unsupported facade step #{step['kind'].inspect}"
               end
      if step.key?("save")
        raise Error, "facade slot reused" if slots.key?(step.fetch("save"))
        slots[step.fetch("save")] = actual
      end
    end
    slots
  end

  def validate_step!(step)
    raise Error, "facade step must be a mapping" unless step.is_a?(Hash)
    kind = step.fetch("kind")
    fields = if kind == "assert"
               base = %w[kind source comparison assertion_line]
               case step.fetch("comparison")
               when "eq", "eql", "be_xml_equivalent_to" then base + ["expected_slot"]
               when "model_kind" then base + ["expected_kind"]
               when "be_nil", "be_base_notation", "be_negative", "be_fractional" then base
               else raise Error, "unsupported facade comparison"
               end
             elsif kind == "observe"
               %w[kind save source observation] + (step.key?("arguments") ? ["arguments"] : [])
             elsif kind == "decode"
               %w[kind save source boundary format] + (step.key?("format_argument") ? ["format_argument"] : [])
             else
               STEP_FIELDS.fetch(kind) { raise Error, "unsupported facade step" }
             end
    SharedModelRecipes.keys!(step, fields)
  rescue SharedModelRecipes::Error => error
    raise Error, error.message
  end

  def arguments(step, slots)
    args, kwargs = slots.fetch(step.fetch("args")), slots.fetch(step.fetch("kwargs"))
    raise Error, "facade arguments must be array/map" unless args.is_a?(Array) && kwargs.is_a?(Hash)
    [args, kwargs]
  end

  def error_class(category)
    case category
    when "parse_failure" then Parslet::ParseFailed
    when "configuration_error" then Plurimath::ConfigurationError
    when "invalid_number" then Plurimath::Errors::InvalidNumber
    when "unsupported_base" then Plurimath::Errors::UnsupportedBase
    when "unsupported_locale" then Plurimath::Errors::UnsupportedLocale
    when "parse_option_error" then Plurimath::Math::ParseOptionError
    when "invalid_type" then Plurimath::Math::InvalidTypeError
    when "parse_error" then Plurimath::Math::ParseError
    else raise Error, "unsupported facade error category"
    end
  end

  def error_message(message)
    case message.fetch("kind")
    when "string"
      SharedModelRecipes.keys!(message, %w[kind value])
      SharedModelRecipes.string!(message.fetch("value")).dup
    when "regex"
      SharedModelRecipes.keys!(message, %w[kind source options])
      raise Error, "unsupported error regexp options" unless message.fetch("options") == 0
      Regexp.new(SharedModelRecipes.string!(message.fetch("source")))
    else raise Error, "unsupported facade error message"
    end
  end
end
