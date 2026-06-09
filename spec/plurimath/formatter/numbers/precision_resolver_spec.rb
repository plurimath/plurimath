# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::PrecisionResolver do
  subject(:resolver) { described_class.new }

  def source(number_string)
    Plurimath::Formatter::Numbers::Source.new(number_string)
  end

  describe "#resolve" do
    it "uses explicit precision first" do
      precision = resolver.resolve(
        source("0.12325e3"),
        precision: 3,
        base: 16,
        significant: 5,
        notation_supported: false,
      )

      expect(precision).to eq(3)
    end

    it "infers decimal precision from plain decimal strings" do
      precision = resolver.resolve(
        source("123.450"),
        precision: nil,
        base: 10,
        significant: 0,
        notation_supported: false,
      )

      expect(precision).to eq(3)
    end

    it "preserves zero fractional scale for notation precision" do
      precision = resolver.resolve(
        source("0.00"),
        precision: nil,
        base: 10,
        significant: 0,
        notation_supported: true,
      )

      expect(precision).to eq(2)
    end

    it "infers notation precision without counting exponent text" do
      precision = resolver.resolve(
        source("1.23e4"),
        precision: nil,
        base: 10,
        significant: 0,
        notation_supported: true,
      )

      expect(precision).to eq(2)
    end

    it "infers decimal precision from normalized source parts" do
      precision = resolver.resolve(
        source("1.230e2"),
        precision: nil,
        base: 10,
        significant: 0,
        notation_supported: false,
      )

      expect(precision).to eq(1)
    end

    it "infers target-base precision before notation defaults" do
      precision = resolver.resolve(
        source("0.12325e3"),
        precision: nil,
        base: 16,
        significant: 5,
        notation_supported: false,
      )

      expect(precision).to eq(3)
    end

    it "does not infer target-base precision for whole exponent values" do
      precision = resolver.resolve(
        source("0.123e3"),
        precision: nil,
        base: 16,
        significant: 5,
        notation_supported: false,
      )

      expect(precision).to eq(0)
    end
  end
end
