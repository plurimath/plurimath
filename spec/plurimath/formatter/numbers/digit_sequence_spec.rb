# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::DigitSequence do
  describe "#next_digit" do
    it "returns the next digit for the configured base alphabet" do
      sequence = described_class.new(base: 16)

      expect(sequence.next_digit("9")).to eq("a")
      expect(sequence.next_digit("e")).to eq("f")
    end

    it "returns nil for an unsupported digit" do
      expect(described_class.new(base: 10).next_digit("x")).to be_nil
    end
  end

  describe "#round_up?" do
    it "uses half the base as the rounding threshold" do
      sequence = described_class.new(base: 16)

      expect(sequence).not_to be_round_up("7")
      expect(sequence).to be_round_up("8")
    end
  end

  describe "#digit_count" do
    it "counts digits in a character sequence" do
      sequence = described_class.new(base: 10)

      expect(sequence.digit_count("123.45".chars)).to eq(5)
    end

    it "stops counting at the requested character" do
      sequence = described_class.new(base: 10)

      expect(sequence.digit_count("123.45".chars, stop_at: ".")).to eq(3)
    end
  end

  describe "#significant_digit_count" do
    it "counts digits after the first non-zero digit" do
      sequence = described_class.new(base: 10)

      expect(sequence.significant_digit_count("0.01230".chars)).to eq(4)
    end

    it "returns zero when the sequence has no significant digits" do
      sequence = described_class.new(base: 10)

      expect(sequence.significant_digit_count("0.000".chars)).to eq(0)
    end
  end

  describe "#increment_reversed" do
    it "increments the first available reversed digit" do
      sequence = described_class.new(base: 10)

      digits, carry = sequence.increment_reversed(%w[3 2 1])

      expect(digits).to eq(%w[4 2 1])
      expect(carry).to eq(0)
    end

    it "carries across max digits" do
      sequence = described_class.new(base: 16)

      digits, carry = sequence.increment_reversed(%w[f f])

      expect(digits).to eq(%w[0 0])
      expect(carry).to eq(1)
    end

    it "skips separators while carrying" do
      sequence = described_class.new(base: 10)

      digits, carry = sequence.increment_reversed(["9", ",", "1"], skip: [","])

      expect(digits).to eq(["0", ",", "2"])
      expect(carry).to eq(0)
    end
  end
end
