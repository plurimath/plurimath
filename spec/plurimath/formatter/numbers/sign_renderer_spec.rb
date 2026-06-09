# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::SignRenderer do
  describe "#apply" do
    it "leaves positive numbers unsigned by default" do
      renderer = described_class.new

      expect(renderer.apply(10, "10")).to eq("10")
    end

    it "adds a plus sign for positive numbers when requested" do
      renderer = described_class.new(:plus)

      expect(renderer.apply(10, "10")).to eq("+10")
    end

    it "keeps negative signs before rendered base notation" do
      renderer = described_class.new(:plus)

      expect(renderer.apply(-10, "0b10,10")).to eq("-0b10,10")
    end

    it "can apply signs from parsed parts" do
      renderer = described_class.new(:plus)
      parts = Plurimath::Formatter::Numbers::Parts.new(
        sign: -1,
        base: 10,
        integer_digits: "10",
        fraction_digits: "",
      )

      expect(renderer.apply(parts, "10")).to eq("-10")
    end
  end
end
