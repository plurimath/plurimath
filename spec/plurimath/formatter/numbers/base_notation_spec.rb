# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::BaseNotation do
  def options(symbols)
    Plurimath::Formatter::Numbers::FormatOptions.new(symbols: symbols)
  end

  describe ".from_options" do
    it "builds a default-prefix notation for non-decimal bases" do
      notation = described_class.from_options(options(base: 16))

      expect(notation.prefix).to eq("0x")
      expect(notation.postfix).to eq("")
    end

    it "builds a default-notation for base 10" do
      notation = described_class.from_options(options(base: 10))

      expect(notation).to be_default
    end

    it "uses an explicit base_prefix" do
      notation = described_class.from_options(options(base: 16,
                                                      base_prefix: "16#"))

      expect(notation.prefix).to eq("16#")
      expect(notation.postfix).to eq("")
    end

    it "suppresses the default prefix when base_postfix is provided alone" do
      notation = described_class.from_options(options(base: 16,
                                                      base_postfix: "h"))

      expect(notation.prefix).to eq("")
      expect(notation.postfix).to eq("h")
    end

    it "suppresses the default prefix when base_postfix is nil" do
      notation = described_class.from_options(options(base: 16,
                                                      base_postfix: nil))

      expect(notation.prefix).to eq("")
      expect(notation.postfix).to eq("")
    end

    it "suppresses the default prefix when base_postfix is empty" do
      notation = described_class.from_options(options(base: 16,
                                                      base_postfix: ""))

      expect(notation.prefix).to eq("")
      expect(notation.postfix).to eq("")
    end

    it "combines explicit base_prefix and base_postfix" do
      notation = described_class.from_options(options(base: 16,
                                                      base_prefix: "0x", base_postfix: "h"))

      expect(notation.prefix).to eq("0x")
      expect(notation.postfix).to eq("h")
    end

    it "preserves hex_capital option" do
      notation = described_class.from_options(options(base: 16,
                                                      hex_capital: true))

      expect(notation).to be_upcase_hex
    end

    it "raises for unsupported bases" do
      expect do
        described_class.from_options(options(base: 5))
      end.to raise_error(Plurimath::Errors::UnsupportedBase)
    end
  end

  describe "#default?" do
    it "returns true for base 10" do
      notation = described_class.new(base: 10)

      expect(notation).to be_default
    end

    it "returns false for non-decimal bases" do
      notation = described_class.new(base: 16)

      expect(notation).not_to be_default
    end
  end

  describe "#literal? and #semantic?" do
    it "is semantic for a non-decimal base without explicit prefix/postfix" do
      notation = described_class.from_options(options(base: 16))

      expect(notation).to be_semantic
      expect(notation).not_to be_literal
    end

    it "is literal when base_prefix is explicitly set" do
      notation = described_class.from_options(options(base: 16,
                                                      base_prefix: "U+"))

      expect(notation).to be_literal
      expect(notation).not_to be_semantic
    end

    it "is literal when base_postfix is explicitly set" do
      notation = described_class.from_options(options(base: 16,
                                                      base_postfix: "h"))

      expect(notation).to be_literal
      expect(notation).not_to be_semantic
    end

    it "is neither literal nor semantic for base 10" do
      notation = described_class.from_options(options(base: 10))

      expect(notation).not_to be_literal
      expect(notation).not_to be_semantic
    end
  end

  describe "#wrap" do
    it "prepends prefix and appends postfix around digits" do
      notation = described_class.new(base: 16, prefix: "0x", postfix: "h")

      expect(notation.wrap("ff")).to eq("0xffh")
    end

    it "returns bare digits with empty prefix and postfix" do
      notation = described_class.new(base: 16)

      expect(notation.wrap("ff")).to eq("ff")
    end
  end

  describe ".supported?" do
    it "reports supported formatter bases" do
      expect(described_class.supported?(16)).to be(true)
      expect(described_class.supported?(5)).to be(false)
    end
  end
end
