# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::BaseNotation do
  def options(symbols)
    Plurimath::Formatter::Numbers::FormatOptions.new(symbols: symbols)
  end

  describe "#apply" do
    it "does not add notation for base 10" do
      notation = described_class.new(options(base: 10, base_postfix: "_10"))

      expect(notation.apply("123")).to eq("123")
    end

    it "adds the default prefix for non-decimal bases" do
      notation = described_class.new(options(base: 16))

      expect(notation.apply("ff")).to eq("0xff")
    end

    it "honors explicit base_prefix values" do
      notation = described_class.new(options(base: 16, base_prefix: "16#"))

      expect(notation.apply("ff")).to eq("16#ff")
    end

    it "uses base_postfix without the default prefix when provided alone" do
      notation = described_class.new(options(base: 16, base_postfix: "h"))

      expect(notation.apply("ff")).to eq("ffh")
    end

    it "uses base_postfix nil without the default prefix when provided" do
      notation = described_class.new(options(base: 16, base_postfix: nil))

      expect(notation.apply("ff")).to eq("ff")
    end

    it "uses an empty base_postfix without the default prefix when provided" do
      notation = described_class.new(options(base: 16, base_postfix: ""))

      expect(notation.apply("ff")).to eq("ff")
    end

    it "combines explicit base_prefix and base_postfix when both are provided" do
      notation = described_class.new(options(base: 16, base_prefix: "0x", base_postfix: "h"))

      expect(notation.apply("ff")).to eq("0xffh")
    end

    it "keeps the existing whole-rendered-string hex capitalization behavior" do
      notation = described_class.new(options(base: 16, hex_capital: true))

      expect(notation.apply("a.d'f")).to eq("0xA.D'F")
    end

    it "does not apply whole-rendered-string capitalization for numbers_only mode" do
      notation = described_class.new(options(base: 16, hex_capital: :numbers_only))

      expect(notation.apply("a.d'f")).to eq("0xa.d'f")
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
        described_class.new(options(base: 5))
      end.to raise_error(Plurimath::Formatter::UnsupportedBase)
    end
  end
end
