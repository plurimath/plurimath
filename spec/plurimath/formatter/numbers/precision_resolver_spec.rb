# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::PrecisionResolver do
  subject(:resolver) { described_class.new }

  describe "#resolve" do
    it "uses explicit precision first" do
      precision = resolver.resolve(
        "0.12325e3",
        precision: 3,
        format: { base: 16, significant: 5 },
        notation: nil,
      )

      expect(precision).to eq(3)
    end

    it "infers decimal precision from plain decimal strings" do
      precision = resolver.resolve(
        "123.450",
        precision: nil,
        format: {},
        notation: :basic,
      )

      expect(precision).to eq(3)
    end

    it "infers notation precision from source characters" do
      precision = resolver.resolve(
        "0.00",
        precision: nil,
        format: {},
        notation: :scientific,
      )

      expect(precision).to eq(2)
    end

    it "infers target-base precision before notation defaults" do
      precision = resolver.resolve(
        "0.12325e3",
        precision: nil,
        format: { base: 16, significant: 5 },
        notation: nil,
      )

      expect(precision).to eq(3)
    end

    it "does not infer target-base precision for whole exponent values" do
      precision = resolver.resolve(
        "0.123e3",
        precision: nil,
        format: { base: 16, significant: 5 },
        notation: nil,
      )

      expect(precision).to eq(0)
    end
  end
end
