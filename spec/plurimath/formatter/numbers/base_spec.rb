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
    context "with alphanumeric sequence" do
      let(:symbols) { { base: 16 } }

      it "maps to next character in sequence" do
        expect(base.send(:next_mapping_char, "3")).to eq("4")
      end

      it "maps digit to hex letter" do
        expect(base.send(:next_mapping_char, "9")).to eq("a")
      end

      it "maps to next hex letter" do
        expect(base.send(:next_mapping_char, "c")).to eq("d")
      end

      it "returns nil for invalid character" do
        expect(base.send(:next_mapping_char, "f")).to be_nil
      end
    end
  end
end
