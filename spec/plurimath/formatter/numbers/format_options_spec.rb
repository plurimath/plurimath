# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::FormatOptions do
  describe "#initialize" do
    it "normalizes notation option values" do
      precision_resolver = double(resolve: 4)
      options = described_class.new(
        "14000",
        format: {
          notation: "scientific",
          e: "E",
          times: "x",
          exponent_sign: "plus",
        },
        precision: nil,
        precision_resolver: precision_resolver,
      )

      expect(options.notation).to eq(:scientific)
      expect(options.exponent_separator).to eq(:E)
      expect(options.times).to eq(:x)
      expect(options.exponent_sign).to eq(:plus)
      expect(options.precision).to eq(4)
    end

    it "uses notation defaults and delegates precision resolution" do
      precision_resolver = double(resolve: 2)
      format = {}

      options = described_class.new(
        "0.00",
        format: format,
        precision: nil,
        precision_resolver: precision_resolver,
      )

      expect(precision_resolver).to have_received(:resolve).with(
        "0.00",
        precision: nil,
        format: format,
        notation: nil,
      )
      expect(options.exponent_separator).to eq(:e)
      expect(options.times).to eq("\u{d7}")
      expect(options.precision).to eq(2)
    end
  end
end
