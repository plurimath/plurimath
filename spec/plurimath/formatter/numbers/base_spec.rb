# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::Base do
  let(:base) { described_class.new(symbols) }
  let(:symbols) { {} }

  describe "#initialize" do
    context "with default symbols" do
      let(:symbols) { {} }

      it "initializes with default base 10" do
        expect(base.base).to eq(10)
      end

      it "stores symbols" do
        expect(base.symbols).to eq({})
      end
    end

    context "with custom base" do
      let(:symbols) { { base: 16 } }

      it "initializes with specified base" do
        expect(base.base).to eq(16)
      end
    end

    context "with binary base" do
      let(:symbols) { { base: 2 } }

      it "initializes with binary base" do
        expect(base.base).to eq(2)
      end
    end

    context "with octal base" do
      let(:symbols) { { base: 8 } }

      it "initializes with octal base" do
        expect(base.base).to eq(8)
      end
    end
  end

  describe "#threshold" do
    context "with default base 10" do
      let(:symbols) { {} }

      it "returns threshold as half of base" do
        expect(base.send(:threshold)).to eq(5)
      end
    end

    context "with base 2" do
      let(:symbols) { { base: 2 } }

      it "returns threshold for binary" do
        expect(base.send(:threshold)).to eq(1)
      end
    end

    context "with base 16" do
      let(:symbols) { { base: 16 } }

      it "returns threshold for hexadecimal" do
        expect(base.send(:threshold)).to eq(8)
      end
    end

    context "threshold is memoized" do
      let(:symbols) { { base: 10 } }

      it "returns same object on multiple calls" do
        threshold1 = base.send(:threshold)
        threshold2 = base.send(:threshold)
        expect(threshold1).to equal(threshold2)
      end
    end
  end

  describe "#base_default?" do
    context "with default base 10" do
      let(:symbols) { {} }

      it "returns true" do
        expect(base.send(:base_default?)).to be(true)
      end
    end

    context "with custom base" do
      let(:symbols) { { base: 16 } }

      it "returns false" do
        expect(base.send(:base_default?)).to be(false)
      end
    end

    context "with base 2" do
      let(:symbols) { { base: 2 } }

      it "returns false" do
        expect(base.send(:base_default?)).to be(false)
      end
    end

    context "with base 8" do
      let(:symbols) { { base: 8 } }

      it "returns false" do
        expect(base.send(:base_default?)).to be(false)
      end
    end
  end

  describe "#next_mapping_char" do
    context "with default base and lowercase" do
      let(:symbols) { { base: 10 } }

      it "increments digit" do
        expect(base.send(:next_mapping_char, "5")).to eq("6")
      end

      it "increments to hex letter" do
        expect(base.send(:next_mapping_char, "9")).to eq("a")
      end
    end

    context "with hex base and lowercase" do
      let(:symbols) { { base: 16 } }

      it "increments digit" do
        expect(base.send(:next_mapping_char, "3")).to eq("4")
      end

      it "increments to hex letter lowercase" do
        expect(base.send(:next_mapping_char, "9")).to eq("a")
      end

      it "increments hex letter" do
        expect(base.send(:next_mapping_char, "c")).to eq("d")
      end
    end

    context "with hex base and uppercase" do
      let(:symbols) { { base: 16, hex_capital: true } }

      it "increments digit" do
        expect(base.send(:next_mapping_char, "3")).to eq("4")
      end

      it "increments to hex letter uppercase" do
        expect(base.send(:next_mapping_char, "9")).to eq("a")
      end

      it "increments hex letter uppercase" do
        expect(base.send(:next_mapping_char, "C")).to eq("D")
      end
    end

    context "with non-hex base" do
      let(:symbols) { { base: 10, hex_capital: true } }

      it "does not uppercase" do
        expect(base.send(:next_mapping_char, "9")).to eq("a")
      end
    end

    context "with base 2" do
      let(:symbols) { { base: 2 } }

      it "increments 0 to 1" do
        expect(base.send(:next_mapping_char, "0")).to eq("1")
      end
    end

    context "with base 8" do
      let(:symbols) { { base: 8 } }

      it "increments digit in octal" do
        expect(base.send(:next_mapping_char, "7")).to eq("8")
      end
    end
  end
end
