# frozen_string_literal: true

# Decode authored constructor data; never evaluate source from a fixture.
module SharedModelRecipes
  class Error < StandardError; end

  module_function

  def build(recipe, memo = {})
    raise Error, "memo context must be a mapping" unless memo.is_a?(Hash)
    raise Error, "model recipe must be a mapping" unless recipe.is_a?(Hash)

    case recipe["kind"]
    when "memo"
      keys!(recipe, %w[kind id value])
      id = string!(recipe.fetch("id"))
      raise Error, "memo ID must not be empty" if id.empty?

      definition = recipe.fetch("value")
      if memo.key?(id)
        entry = memo.fetch(id)
        raise Error, "cyclic memo #{id}" if entry.fetch(:building)
        raise Error, "conflicting memo #{id}" unless entry.fetch(:recipe) == definition

        return entry.fetch(:value)
      end
      memo[id] = { recipe: definition, building: true }
      begin
        value = build(definition, memo)
        memo[id] = { recipe: definition, building: false, value: value }
        value
      rescue StandardError
        memo.delete(id)
        raise
      end
    when "literal"
      keys!(recipe, %w[kind value])
      value = recipe.fetch("value")
      unless [String, Integer, Float, TrueClass, FalseClass, NilClass].any? { |type| value.is_a?(type) }
        raise Error, "unsupported literal type"
      end
      raise Error, "non-finite literal" if value.is_a?(Float) && !value.finite?

      value.is_a?(String) ? value.dup : value
    when "symbol"
      keys!(recipe, %w[kind value])
      string!(recipe.fetch("value")).to_sym
    when "array"
      keys!(recipe, %w[kind items])
      build_list(recipe.fetch("items"), memo)
    when "map"
      keys!(recipe, %w[kind entries])
      array!(recipe.fetch("entries")).each_with_object({}) do |entry, result|
        keys!(entry, %w[key value])
        result[build(entry.fetch("key"), memo)] = build(entry.fetch("value"), memo)
      end
    when "class"
      keys!(recipe, %w[kind name])
      model_class(recipe.fetch("name"))
    when "unitsml_formula"
      keys!(recipe, %w[kind text])
      Plurimath::Unitsml.new(string!(recipe.fetch("text")).dup).to_formula
    when "standard_formatter", "legacy_number_formatter"
      keys!(recipe, %w[kind args kwargs])
      args = build_list(recipe.fetch("args"), memo)
      if recipe.fetch("kind") == "standard_formatter" && !args.empty? || args.length > 1
        raise Error, "unsupported formatter positional arguments"
      end
      keywords = recipe.fetch("kwargs")
      raise Error, "formatter kwargs must be a typed map" unless keywords.is_a?(Hash) && keywords["kind"] == "map"

      kwargs = build(keywords, memo)
      if recipe.fetch("kind") == "standard_formatter"
        Plurimath::Formatter::Standard.new(**kwargs)
      else
        Plurimath::NumberFormatter.new(*args, **kwargs)
      end
    when "constructor"
      keys!(recipe, %w[kind class args kwargs])
      klass = model_class(recipe.fetch("class"))
      args = build_list(recipe.fetch("args"), memo)
      keywords = recipe.fetch("kwargs")
      raise Error, "constructor kwargs must be a typed map" unless keywords.is_a?(Hash) && keywords["kind"] == "map"

      klass.new(*args, **build(keywords, memo))
    else
      raise Error, "unknown model recipe kind #{recipe['kind'].inspect}"
    end
  end

  def build_list(items, memo)
    array!(items).each_with_object([]) do |item, result|
      if item.is_a?(Hash) && item["kind"] == "spread"
        keys!(item, %w[kind value])
        values = build(item.fetch("value"), memo)
        raise Error, "spread value must be an array" unless values.is_a?(Array)

        result.concat(values)
      else
        result << build(item, memo)
      end
    end
  end

  def model_class(name)
    unless name.is_a?(String) && /\AMath(?:::[A-Z]\w*)+\z/.match?(name)
      raise Error, "unsupported model class #{name.inspect}"
    end

    klass = name.split("::").inject(Plurimath) { |scope, part| scope.const_get(part, false) }
    raise Error, "recipe class must inherit Math::Core" unless klass.is_a?(Class) && klass < Plurimath::Math::Core

    klass
  end

  def keys!(mapping, keys)
    unless mapping.is_a?(Hash) && mapping.keys.all? { |key| key.is_a?(String) } && mapping.keys.sort == keys.sort
      raise Error, "unexpected model recipe fields"
    end
  end

  def string!(value)
    raise Error, "recipe value must be a string" unless value.is_a?(String)

    value
  end

  def array!(value)
    raise Error, "recipe value must be an array" unless value.is_a?(Array)

    value
  end
end
