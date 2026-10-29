# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Asciimath do
  [["x", 750], ["x", 800], ["sqrt x", 800]].each do |term, count|
    it "transforms a sum of #{count} #{term.inspect} terms without overflowing" do
      formula = described_class.new(Array.new(count, term).join(" + ")).to_formula

      expect(formula).to be_a(Plurimath::Math::Formula)
      expect(formula.value.length).to eq((count * 2) - 1)
    end
  end
end
