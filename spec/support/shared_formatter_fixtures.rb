# frozen_string_literal: true

require "yaml"

# Finite number-component recipes, separate from the public mathematical model.
# Constructors and calls are closed here; fixture text cannot name arbitrary Ruby.
module SharedFormatterFixtures
  SCHEMA = "plurimath-fixtures/formatter-expectations/1"
  COMPONENTS = %w[BaseNotation FormatOptions FormattedNotation FormattedNumber Fraction Integer NotationRenderer Parts SignRenderer Significant Source].freeze
  MAP_KEY_KINDS = %w[literal symbol].freeze
  OPERATIONS = {
    "BaseNotation" => %w[wrap], "FormattedNotation" => %w[to_s formatted_exponent coefficient],
    "FormattedNumber" => %w[to_s sign_text digits_string], "Fraction" => %w[format format_groups change_base],
    "Integer" => %w[apply format_groups chop_group number_to_base], "NotationRenderer" => %w[render],
    "SignRenderer" => %w[apply], "Significant" => %w[apply_parts], "Source" => %w[to_parts], "Parts" => %w[to_s]
  }.freeze
  FIXTURE_PATH = if RUBY_ENGINE == "opal"
                   File.expand_path("submodules/plurimath-testsuite/fixtures/formatter-expectations.yaml")
                 else
                   File.expand_path("../../submodules/plurimath-testsuite/fixtures/formatter-expectations.yaml", __dir__)
                 end

  class Error < StandardError; end

  module_function

  def fetch(id, described_class)
    row = records[id]
    raise Error, "missing shared formatter case #{id.inspect}" unless row
    unless described_class.name == "Plurimath::Formatter::Numbers::#{row.fetch('component')}"
      raise Error, "shared formatter component differs for #{id.inspect}"
    end

    copy(row)
  end

  def rows
    records.values.map { |row| copy(row) }
  end

  def records
    @datasets ||= {}
    @datasets[FIXTURE_PATH] ||= load_fixture(FIXTURE_PATH)
  end
  private_class_method :records

  def load_fixture(path)
    text = File.read(path)
    # Opal 1.8's nodejs/yaml load delegates to js-yaml safeLoad.
    data = RUBY_ENGINE == "opal" ? YAML.load(text) : YAML.safe_load(text) # rubocop:disable Security/YAMLLoad
    validate(data)
    data.fetch("cases").to_h { |row| [row.fetch("id"), row] }
  end

  def exact_keys?(value, keys)
    value.is_a?(Hash) && value.keys.all?(String) && value.keys.sort == keys.sort
  end

  def validate(data)
    unless exact_keys?(data, %w[schema provenance cases]) && data["schema"] == SCHEMA &&
        data["cases"].is_a?(Array) && !data["cases"].empty?
      raise Error, "unsupported or empty shared formatter fixture"
    end

    provenance = data["provenance"]
    unless exact_keys?(provenance, %w[repository ruby_commit]) &&
        provenance["repository"] == "https://github.com/plurimath/plurimath" &&
        provenance["ruby_commit"].is_a?(String) && /\A[0-9a-f]{40}\z/.match?(provenance["ruby_commit"])
      raise Error, "unsupported shared formatter provenance"
    end

    ids = []
    locations = []
    data["cases"].each do |row|
      validate_case(row)
      ids << row.fetch("id")
      locations << [row.fetch("source").fetch("path"), row.fetch("source").fetch("line")]
    end
    raise Error, "duplicate shared formatter case" unless ids.uniq.length == ids.length && locations.uniq.length == locations.length
  end

  def validate_case(row)
    unless exact_keys?(row, %w[id component input comparison expected source]) &&
        row["id"].is_a?(String) && /\A[a-z][a-z-]+-[0-9]+\z/.match?(row["id"]) && COMPONENTS.include?(row["component"])
      raise Error, "unsupported shared formatter case"
    end

    source = row["source"]
    name = row.fetch("component").gsub(/([a-z])([A-Z])/, '\\1_\\2').downcase
    unless exact_keys?(source, %w[path sha256 line contexts]) &&
        source["path"] == "spec/plurimath/formatter/numbers/#{name}_spec.rb" &&
        source["sha256"].is_a?(String) && /\A[0-9a-f]{64}\z/.match?(source["sha256"]) &&
        source["line"].is_a?(Integer) && source["line"].positive? &&
        source["contexts"].is_a?(Array) && source["contexts"].all?(String) &&
        row["id"] == "#{name.tr('_', '-')}-#{source['line'].to_s.rjust(3, '0')}"
      raise Error, "unsupported shared formatter source"
    end

    recipe = row["input"]
    unless recipe.is_a?(Hash) && recipe["kind"] == "operation" && validate_recipe(recipe) == "value"
      raise Error, "shared formatter input is not an output operation"
    end

    expected = row["expected"]
    valid = case row["comparison"]
            when "eq" then expected.is_a?(String)
            when "nil" then expected.nil?
            when "text_kind" then expected == "text"
            when "alphabet" then expected.is_a?(Array) && !expected.empty? && expected.uniq.length == expected.length && expected.all? { |value| value.is_a?(String) && value.length == 1 }
            when "max_length" then expected.is_a?(Integer) && expected >= 0
            else false
            end
    raise Error, "unsupported shared formatter comparison" unless valid
    return unless %w[alphabet max_length].include?(row["comparison"])

    unless recipe["method"] == "change_base" && result_type(recipe["receiver"]) == "Fraction"
      raise Error, "formatter property requires Fraction change_base output"
    end
  end

  def validate_recipe(recipe, depth = 0)
    raise Error, "formatter recipe too deep" if depth > 64
    raise Error, "unsupported formatter recipe" unless recipe.is_a?(Hash)

    kind = recipe["kind"]
    case kind
    when "literal"
      unless exact_keys?(recipe, %w[kind value]) && [String, Numeric, TrueClass, FalseClass, NilClass].any? { |type| recipe["value"].is_a?(type) }
        raise Error, "unsupported formatter literal"
      end
      raise Error, "nonfinite formatter literal" if recipe["value"].is_a?(Float) && !recipe["value"].finite?
    when "symbol"
      raise Error, "unsupported formatter symbol" unless exact_keys?(recipe, %w[kind value]) && recipe["value"].is_a?(String) && !recipe["value"].empty?
    when "array"
      raise Error, "unsupported formatter array" unless exact_keys?(recipe, %w[kind items]) && recipe["items"].is_a?(Array)

      recipe["items"].each { |entry| validate_recipe(entry, depth + 1) }
    when "map"
      raise Error, "unsupported formatter map" unless exact_keys?(recipe, %w[kind entries]) && recipe["entries"].is_a?(Array)

      keys = recipe["entries"].map do |entry|
        unless exact_keys?(entry, %w[key value]) && entry["key"].is_a?(Hash) && MAP_KEY_KINDS.include?(entry["key"]["kind"])
          raise Error, "unsupported formatter map entry"
        end

        validate_recipe(entry["key"], depth + 1)
        validate_recipe(entry["value"], depth + 1)
        build(entry["key"])
      end
      raise Error, "duplicate typed formatter map key" unless keys.uniq.length == keys.length
    when "component", "operation"
      keys = kind == "component" ? %w[kind name args kwargs] : %w[kind receiver method args kwargs]
      unless exact_keys?(recipe, keys) && recipe["args"].is_a?(Array) && recipe["kwargs"].is_a?(Hash) && recipe["kwargs"]["kind"] == "map"
        raise Error, "unsupported formatter invocation"
      end

      recipe["args"].each { |entry| validate_recipe(entry, depth + 1) }
      validate_recipe(recipe["kwargs"], depth + 1)
      unless recipe["kwargs"]["entries"].all? { |entry| entry["key"]["kind"] == "symbol" }
        raise Error, "formatter keyword key must be a symbol"
      end

      if kind == "component"
        raise Error, "unknown formatter component" unless COMPONENTS.include?(recipe["name"])
      else
        receiver_type = validate_recipe(recipe["receiver"], depth + 1)
        raise Error, "unsupported formatter operation" unless OPERATIONS.fetch(receiver_type, []).include?(recipe["method"])
      end
    else raise Error, "unknown formatter recipe kind"
    end
    result_type(recipe)
  end

  def result_type(recipe)
    return recipe.fetch("name") if recipe["kind"] == "component"
    return "value" unless recipe["kind"] == "operation"

    case recipe["method"]
    when "render" then "FormattedNotation"
    when "coefficient" then "FormattedNumber"
    when "to_parts", "apply_parts" then "Parts"
    else "value"
    end
  end

  # Optional adapter for consumers executing the complete portable input recipe.
  # Native examples pass their original actual expression to the assertion helper
  # so mixed state/type assertions still observe precisely the original object.
  def actual(row)
    validate_case(row)
    build(row.fetch("input"))
  end

  def build(recipe)
    case recipe.fetch("kind")
    when "literal" then copy(recipe.fetch("value"))
    when "symbol" then recipe.fetch("value").to_sym
    when "array" then recipe.fetch("items").map { |entry| build(entry) }
    when "map" then recipe.fetch("entries").to_h { |entry| [build(entry.fetch("key")), build(entry.fetch("value"))] }
    when "component"
      classes = {
        "BaseNotation" => Plurimath::Formatter::Numbers::BaseNotation, "FormatOptions" => Plurimath::Formatter::Numbers::FormatOptions,
        "FormattedNotation" => Plurimath::Formatter::Numbers::FormattedNotation, "FormattedNumber" => Plurimath::Formatter::Numbers::FormattedNumber,
        "Fraction" => Plurimath::Formatter::Numbers::Fraction, "Integer" => Plurimath::Formatter::Numbers::Integer,
        "NotationRenderer" => Plurimath::Formatter::Numbers::NotationRenderer, "Parts" => Plurimath::Formatter::Numbers::Parts,
        "SignRenderer" => Plurimath::Formatter::Numbers::SignRenderer, "Significant" => Plurimath::Formatter::Numbers::Significant,
        "Source" => Plurimath::Formatter::Numbers::Source
      }
      args = recipe.fetch("args").map { |entry| build(entry) }
      kwargs = build(recipe.fetch("kwargs"))
      classes.fetch(recipe.fetch("name")).new(*args, **kwargs)
    when "operation"
      receiver = build(recipe.fetch("receiver"))
      args = recipe.fetch("args").map { |entry| build(entry) }
      kwargs = build(recipe.fetch("kwargs"))
      method = recipe.fetch("method")
      if method == "change_base"
        receiver.send(:change_base, *args, **kwargs)
      else
        receiver.public_send(method, *args, **kwargs)
      end
    else raise Error, "unknown formatter recipe kind"
    end
  end
  private_class_method :build

  def copy(value)
    case value
    when Hash then value.to_h { |key, entry| [key.dup, copy(entry)] }
    when Array then value.map { |entry| copy(entry) }
    when String then value.dup
    else value
    end
  end
end
