# frozen_string_literal: true

require "spec_helper"

# Node fields that hold an array mixing Strings and nodes, and hashes whose
# keys are Strings rather than Symbols, survive a hash and a JSON round trip.
RSpec.describe Plurimath::Math::Core, ".node_fields" do
  let(:math) { Plurimath::Math }
  let(:function) { Plurimath::Math::Function }
  let(:one) { math::Number.new("1") }
  let(:x) { math::Symbols::Symbol.new("x") }

  def round_trip(node)
    [node.class.from_hash(node.to_hash), node.class.from_json(node.to_json)]
  end

  describe "a mixed array of Strings and nodes" do
    it "is kept in a single-node field" do
      node = function::Sin.new(["a", x, "b"])
      round_trip(node).each do |copy|
        expect(copy.parameter_one).to eq(["a", x, "b"])
        expect(copy).to eq(node)
      end
    end

    it "is kept in a collection field, with nested nodes" do
      node = math::Formula.new([function::Frac.new(x, one), "text"])
      round_trip(node).each do |copy|
        expect(copy.value).to eq([function::Frac.new(x, one), "text"])
        expect(copy.value.first).to be_a(function::Frac)
      end
    end

    it "is kept in an array of Strings only" do
      node = function::Fenced.new(math::Symbols::Paren::Lround.new, %w[a b],
                                  math::Symbols::Paren::Rround.new)
      round_trip(node).each { |copy| expect(copy.parameter_two).to eq(%w[a b]) }
    end

    it "is tagged per element and adds no key otherwise" do
      expect(function::Sin.new(["a", x]).to_hash["parameter_one_mixed"])
        .to eq([{ "text" => "a" },
                { "class" => x.class.name, "node" => x.to_hash }])
      expect(function::Sin.new([x, one]).to_hash).not_to have_key("parameter_one_mixed")
      expect(function::Sin.new("a").to_hash).not_to have_key("parameter_one_mixed")
    end

    it "does not change writer output" do
      node = math::Formula.new([function::Text.new("ab"), x])
      round_trip(node).each do |copy|
        expect(copy.to_latex).to eq(node.to_latex)
        expect(copy.to_mathml).to eq(node.to_mathml)
      end
    end
  end

  describe "hash keys" do
    it "keep String keys apart from Symbol keys in node hashes" do
      node = function::Frac.new(x, one, { bevelled: "true", "linethickness" => "0" })
      round_trip(node).each do |copy|
        expect(copy.options).to eq(bevelled: "true", "linethickness" => "0")
        expect(copy.options.keys.map(&:class)).to eq([Symbol, String])
      end
    end

    it "keep their types at any depth and in Td's attribute hash" do
      td = function::Td.new([x], { columnalign: "center", "data" => { "a" => [{ b: 1 }] } })
      round_trip(td).each do |copy|
        expect(copy.parameter_two)
          .to eq(columnalign: "center", "data" => { "a" => [{ b: 1 }] })
      end
    end

    it "keep their types in symbol options" do
      symbol = math::Symbols::Symbol.new("x", options: { rspace: "0em", "lspace" => "1em" })
      round_trip(symbol).each do |copy|
        expect(copy.options).to eq(rspace: "0em", "lspace" => "1em")
        expect(copy).to eq(symbol)
      end
    end

    it "keep their types as Semantics annotation tags" do
      node = function::Semantics.new(x, [{ "annotation-xml": [one] }, { "annotation" => [x] }])
      round_trip(node).each do |copy|
        expect(copy.parameter_two).to eq([{ "annotation-xml": [one] }, { "annotation" => [x] }])
        expect(copy).to eq(node)
      end
    end

    it "keep a String apart from a Symbol in symbol fields" do
      [:omml, "en"].each do |lang|
        text = function::Text.new("abc", lang: lang)
        round_trip(text).each { |copy| expect(copy.instance_variable_get(:@lang)).to eq(lang) }
      end
    end

    it "add nothing for hashes with Symbol keys only" do
      hash = function::Frac.new(x, one, { bevelled: "true" }).to_hash
      expect(hash["options"]).to eq("bevelled" => "true")
    end
  end
end
