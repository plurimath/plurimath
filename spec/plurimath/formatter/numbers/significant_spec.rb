# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::Significant do
  let(:symbols) { { decimal: ".", significant: 2 } }
  let(:options) { Plurimath::Formatter::Numbers::FormatOptions.new(symbols: symbols) }
  let(:formatter) { described_class.new(options) }

  describe "#initialize" do
    it "stores significant digits" do
      expect(formatter.significant).to eq(2)
    end

    it "initializes with default base 10" do
      expect(formatter.base).to eq(10)
    end

    context "with custom significant" do
      let(:symbols) { { decimal: ".", significant: 3 } }

      it "sets significant to 3" do
        expect(formatter.significant).to eq(3)
      end
    end
  end

  describe "#active?" do
    it "is active when significant digits are configured" do
      expect(formatter).to be_active
    end

    context "without significant digits" do
      let(:symbols) { { decimal: ".", significant: 0 } }

      it "is inactive" do
        expect(formatter).not_to be_active
      end
    end
  end

  describe "#apply_parts" do
    let(:symbols) { { significant: 9 } }
    let(:parts) do
      Plurimath::Formatter::Numbers::Source
        .new("327428.7432878432992")
        .to_parts
    end

    it "returns structured parts with significant digits applied" do
      result = formatter.apply_parts(parts)

      expect(result.integer_digits).to eq("327428")
      expect(result.fraction_digits).to eq("743")
    end

    context "with boundary rounding" do
      let(:symbols) do
        { decimal: ".", group: "", group_digits: 10, significant: 2 }
      end

      it "rounds fractional values across leading zeros" do
        parts = Plurimath::Formatter::Numbers::Source.new("0.0999").to_parts

        expect(formatter.apply_parts(parts).to_s).to eq("0.10")
      end

      it "rounds across the integer boundary" do
        parts = Plurimath::Formatter::Numbers::Source.new("9.99").to_parts

        expect(formatter.apply_parts(parts).to_s).to eq("10")
      end

      it "removes trailing fraction when rounding produces an integer" do
        parts = Plurimath::Formatter::Numbers::Source.new("1.99").to_parts

        expect(formatter.apply_parts(parts).to_s).to eq("2")
      end
    end

    context "when the significant count is already met" do
      let(:symbols) do
        { decimal: ".", group: "", group_digits: 10, significant: 4 }
      end

      it "keeps the rounded significant digits" do
        parts = Plurimath::Formatter::Numbers::Source.new("123.456").to_parts

        expect(formatter.apply_parts(parts).to_s).to eq("123.5")
      end
    end
  end
end
