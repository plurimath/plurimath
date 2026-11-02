# frozen_string_literal: true

require "spec_helper"
require_relative "support/shared_model_recipes"

RSpec.describe SharedModelRecipes do
  def literal(value)
    { "kind" => "literal", "value" => value }
  end

  def memo(value)
    { "kind" => "memo", "id" => "shared", "value" => value }
  end

  it "preserves typed map keys and explicit false and nil values" do
    recipe = { "kind" => "map", "entries" => [
      { "key" => { "kind" => "symbol", "value" => "x" }, "value" => literal(false) },
      { "key" => literal("x"), "value" => literal(nil) },
    ] }
    expect(described_class.build(recipe)).to eq({ x: false, "x" => nil })
  end

  it "shares memoized values within an example and isolates successive builds" do
    value = memo({ "kind" => "array", "items" => [literal("x")] })
    recipe = { "kind" => "array", "items" => [value, value] }
    first = described_class.build(recipe)
    second = described_class.build(recipe)
    expect(first[0]).to equal(first[1])
    expect(first[0]).not_to equal(second[0])
    first[0][0].replace("changed")
    expect(second).to eq([["x"], ["x"]])
  end

  it "spreads references in order without copying their elements" do
    element = memo(literal("x"))
    recipe = { "kind" => "array", "items" => [element,
      { "kind" => "spread", "value" => { "kind" => "array", "items" => [element] } }] }
    result = described_class.build(recipe)
    expect(result).to eq(["x", "x"])
    expect(result[0]).to equal(result[1])
  end

  it "rejects conflicting memo definitions" do
    cache = {}
    described_class.build(memo(literal(1)), cache)
    expect { described_class.build(memo(literal(2)), cache) }
      .to raise_error(SharedModelRecipes::Error, /conflicting memo/)
  end

  it "rejects standalone spread, unknown fields and classes outside Core" do
    expect { described_class.build("kind" => "spread", "value" => literal(1)) }
      .to raise_error(SharedModelRecipes::Error, /unknown model recipe/)
    expect { described_class.build(literal(1).merge("call" => "eval")) }
      .to raise_error(SharedModelRecipes::Error, /unexpected model recipe fields/)
    expect { described_class.build("kind" => "class", "name" => "Math::ParseError") }
      .to raise_error(SharedModelRecipes::Error, /inherit Math::Core/)
  end

  it "constructs real model nodes from positional arguments and typed kwargs" do
    recipe = { "kind" => "constructor", "class" => "Math::Number",
      "args" => [literal("12")], "kwargs" => { "kind" => "map", "entries" => [] } }
    expect(described_class.build(recipe)).to eq(Plurimath::Math::Number.new("12"))
    expect { described_class.build(recipe.merge("kwargs" => literal(nil))) }
      .to raise_error(SharedModelRecipes::Error, /typed map/)
  end
end
