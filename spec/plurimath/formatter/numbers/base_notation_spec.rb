# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::BaseNotation do
  describe "#apply" do
    it "does not add notation for base 10" do
      notation = described_class.new(base: 10, base_postfix: "_10")

      expect(notation.apply("123")).to eq("123")
    end

    it "adds the default prefix for non-decimal bases" do
      notation = described_class.new(base: 16)

      expect(notation.apply("ff")).to eq("0xff")
    end

    it "honors explicit base_prefix values" do
      notation = described_class.new(base: 16, base_prefix: "16#")

      expect(notation.apply("ff")).to eq("16#ff")
    end

    it "uses base_postfix before prefix when present" do
      notation = described_class.new(base: 16, base_prefix: "0x", base_postfix: "h")

      expect(notation.apply("ff")).to eq("ffh")
    end

    it "keeps the existing whole-rendered-string hex capitalization behavior" do
      notation = described_class.new(base: 16, hex_capital: true)

      expect(notation.apply("a.d'f")).to eq("0xA.D'F")
    end
  end

  describe ".supported?" do
    it "reports supported formatter bases" do
      expect(described_class.supported?(16)).to be(true)
      expect(described_class.supported?(5)).to be(false)
    end
  end

  describe "#initialize" do
    it "raises for unsupported bases" do
      expect do
        described_class.new(base: 5)
      end.to raise_error(Plurimath::Formatter::UnsupportedBase)
    end
  end
end
