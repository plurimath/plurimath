require "spec_helper"
require_relative "../../../support/shared_symbol_examples"

RSpec.describe Plurimath::Math::Symbols::Pi do
  describe ".initialize" do
    it "returns instance of Symbol Pi" do
      klass = described_class.new
      expect(klass).to be_a(described_class)
    end
  end

  it_behaves_like "shared symbol renderings", "pi"

  describe "constant style signal (plurimath#129)" do
    def mathml(symbol)
      dump_ox_nodes(symbol.to_mathml_without_math_tag(true)).strip
    end

    it "keeps pi unstyled without a signal" do
      expect(mathml(described_class.new)).to eq("<mi>&#x3c0;</mi>")
    end

    it "renders pi upright when marked as a constant" do
      symbol = described_class.new(options: { constant: true })
      expect(mathml(symbol)).to eq('<mi mathvariant="normal">&#x3c0;</mi>')
    end

    it "leaves an ordinary variable unstyled" do
      expect(mathml(Plurimath::Math::Symbols::Symbol.new("x"))).to eq("<mi>x</mi>")
    end

    it "uprights an ordinary token only when marked as a constant" do
      symbol = Plurimath::Math::Symbols::Symbol.new("e", options: { constant: true })
      expect(mathml(symbol)).to eq('<mi mathvariant="normal">e</mi>')
    end

    it "preserves an explicit caller style over the constant signal" do
      symbol = described_class.new(options: { constant: true, mathvariant: "italic" })
      expect(mathml(symbol)).to eq('<mi mathvariant="italic">&#x3c0;</mi>')
    end
  end
end
