# frozen_string_literal: true

require "spec_helper"

# Core is the lutaml-model root of the node tree. Number and the symbol
# classes declare their fields. None of them hold other nodes, so their
# hash round trip is safe to run here.
RSpec.describe Plurimath::Math::Core do
  it "is a lutaml-model class" do
    expect(described_class.ancestors).to include(Lutaml::Model::Serializable)
  end

  shared_examples "a declared leaf node" do |hash|
    it "keeps the constructor fields" do
      expect(node.to_hash).to eq(hash)
    end

    it "round-trips through a hash" do
      expect(node.class.from_hash(node.to_hash)).to eq(node)
    end

    it "keeps the instance variables set by the constructor" do
      expect(node.variables)
        .to eq((hash.keys - ["__class"]).map { |key| :"@#{key}" })
    end
  end

  describe Plurimath::Math::Number do
    it_behaves_like "a declared leaf node",
                    { "__class" => "Plurimath::Math::Number",
                      "value" => "12", "mini_sub_sized" => false,
                      "mini_sup_sized" => false, "base" => 16 } do
      let(:node) { described_class.new("12", base: 16) }
    end

    it "declares its fields" do
      expect(described_class.attributes.keys)
        .to eq(%i[__class value mini_sub_sized mini_sup_sized base])
    end
  end

  describe Plurimath::Math::Symbols::Symbol do
    it_behaves_like "a declared leaf node",
                    { "__class" => "Plurimath::Math::Symbols::Symbol",
                      "value" => "x", "slashed" => true, "options" => { a: 1 } } do
      let(:node) { described_class.new("x", true, options: { a: 1 }) }
    end

    it "declares its fields" do
      expect(described_class.attributes.keys)
        .to eq(%i[__class value slashed mini_sub_sized mini_sup_sized options])
    end

    it "still joins an array value" do
      expect(described_class.new(%w[a b]).value).to eq("ab")
    end
  end

  describe Plurimath::Math::Symbols::Paren do
    it_behaves_like "a declared leaf node",
                    { "__class" => "Plurimath::Math::Symbols::Paren",
                      "value" => "(" } do
      let(:node) { described_class.new("(") }
    end
  end
end
