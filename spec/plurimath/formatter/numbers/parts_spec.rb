# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::Parts do
  let(:source) { Plurimath::Formatter::Numbers::Source.new("-001.230") }

  describe "#with_digits" do
    it "returns updated parts while preserving numeric metadata" do
      parts = source.to_parts(base: 16)
      updated = parts.with_digits(integer_digits: "00f", fraction_digits: "40")

      expect(updated).not_to equal(parts)
      expect(updated.sign).to eq(-1)
      expect(updated.base).to eq(16)
      expect(updated.integer_digits).to eq("f")
      expect(updated.fraction_digits).to eq("40")
    end
  end
end
