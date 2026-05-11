# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::NotationRenderer do
  describe ".supported?" do
    it "reports supported notation values" do
      expect(described_class.supported?(:scientific)).to be(true)
      expect(described_class.supported?(:basic)).to be(false)
    end
  end

  describe "#render" do
    it "renders e notation with a custom exponent separator" do
      renderer = described_class.new(
        { decimal: "@" },
        precision: 1,
        exponent_sign: nil,
        exponent_separator: :E,
        times: "x",
      )

      expect(renderer.render("14000", :e)).to eq("1@4E4")
    end

    it "renders scientific notation with explicit plus exponents" do
      renderer = described_class.new(
        { decimal: ".", fraction_group: " ", fraction_group_digits: 3 },
        precision: 4,
        exponent_sign: :plus,
        exponent_separator: :e,
        times: "\u{d7}",
      )

      expect(renderer.render("14000", :scientific)).to eq("1.400 0 × 10^+4")
    end

    it "renders engineering notation" do
      renderer = described_class.new(
        { decimal: "," },
        precision: 2,
        exponent_sign: nil,
        exponent_separator: :e,
        times: :x,
      )

      expect(renderer.render("14000", :engineering)).to eq("14,00 x 10^3")
    end

    it "preserves zero precision in scientific notation" do
      renderer = described_class.new(
        {},
        precision: 2,
        exponent_sign: nil,
        exponent_separator: :e,
        times: "\u{d7}",
      )

      expect(renderer.render("0.00", :scientific)).to eq("0.00 × 10^0")
    end
  end
end
