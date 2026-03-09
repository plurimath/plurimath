# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::Integer do
  let(:formatter) { described_class.new(symbols) }
  let(:symbols) { {} }

  describe "#initialize" do
    context "with default symbols" do
      let(:symbols) { {} }

      it "initializes with default grouping" do
        expect(formatter.groups).to eq(3)
      end

      it "initializes with default separator" do
        expect(formatter.separator).to eq(",")
      end

      it "initializes with default base 10" do
        expect(formatter.base).to eq(10)
      end
    end

    context "with custom group digits" do
      let(:symbols) { { group_digits: 2 } }

      it "sets groups to custom value" do
        expect(formatter.groups).to eq(2)
      end
    end

    context "with custom separator" do
      let(:symbols) { { group: "." } }

      it "sets separator to custom value" do
        expect(formatter.separator).to eq(".")
      end
    end

    context "with custom base and all options" do
      let(:symbols) { { base: 16, group_digits: 4, group: ":" } }

      it "sets all values correctly" do
        expect(formatter.base).to eq(16)
        expect(formatter.groups).to eq(4)
        expect(formatter.separator).to eq(":")
      end
    end
  end

  describe "#apply" do
    context "with decimal base" do
      let(:symbols) { { base: 10 } }

      it "returns formatted decimal number" do
        result = formatter.apply("1000")
        expect(result).to eq("1,000")
      end

      it "formats large numbers" do
        result = formatter.apply("1000000")
        expect(result).to eq("1,000,000")
      end

      it "handles zero" do
        result = formatter.apply("0")
        expect(result).to eq("0")
      end

      it "handles single digit" do
        result = formatter.apply("5")
        expect(result).to eq("5")
      end

      it "handles numbers smaller than group size" do
        result = formatter.apply("99")
        expect(result).to eq("99")
      end
    end

    context "with hexadecimal base" do
      let(:symbols) { { base: 16 } }

      it "converts decimal to hex and formats" do
        result = formatter.apply("255")
        expect(result).to eq("ff")
      end

      it "converts and lowercases by default" do
        result = formatter.apply("4095")
        expect(result).to eq("fff")
      end

      it "converts and groups hex" do
        result = formatter.apply("16777215")
        expect(result).to eq("fff,fff")
      end
    end

    context "with hexadecimal base (default lowercase)" do
      let(:symbols) { { base: 16 } }

      it "converts to lowercase hex letters by default" do
        result = formatter.apply("255")
        expect(result).to eq("ff")
      end

      it "converts large hex to lowercase by default" do
        result = formatter.apply("4095")
        expect(result).to eq("fff")
      end
    end

    context "with binary base" do
      let(:symbols) { { base: 2 } }

      it "converts to binary and formats" do
        result = formatter.apply("8")
        expect(result).to eq("1,000")
      end

      it "converts larger binary with grouping" do
        result = formatter.apply("255")
        expect(result).to eq("11,111,111")
      end
    end

    context "with octal base" do
      let(:symbols) { { base: 8 } }

      it "converts to octal and formats" do
        result = formatter.apply("64")
        expect(result).to eq("100")
      end

      it "converts and groups octal" do
        result = formatter.apply("4096")
        expect(result).to eq("10,000")
      end
    end

    context "with custom grouping" do
      let(:symbols) { { base: 10, group_digits: 2 } }

      it "groups by custom size" do
        result = formatter.apply("123456")
        expect(result).to eq("12,34,56")
      end
    end

    context "with custom separator" do
      let(:symbols) { { base: 10, group: "." } }

      it "uses custom separator" do
        result = formatter.apply("1000000")
        expect(result).to eq("1.000.000")
      end
    end

    context "with different base and separator" do
      let(:symbols) { { base: 16, group: "_", hex_capital: true } }

      it "applies both base conversion and custom formatting" do
        result = formatter.apply("4095")
        expect(result).to eq("fff")
      end
    end
  end

  describe "#format_groups" do
    context "with default grouping" do
      let(:symbols) { { group_digits: 3 } }

      it "groups string of 6 digits" do
        result = formatter.format_groups("123456")
        expect(result).to eq("123,456")
      end

      it "groups string of 9 digits" do
        result = formatter.format_groups("123456789")
        expect(result).to eq("123,456,789")
      end

      it "groups string less than group size" do
        result = formatter.format_groups("99")
        expect(result).to eq("99")
      end

      it "groups string exactly group size" do
        result = formatter.format_groups("123")
        expect(result).to eq("123")
      end
    end

    context "with custom grouping" do
      let(:symbols) { { group_digits: 2, group: "-" } }

      it "groups by 2" do
        result = formatter.format_groups("123456")
        expect(result).to eq("12-34-56")
      end
    end

    context "with single character" do
      let(:symbols) { { group_digits: 3 } }

      it "returns same character" do
        result = formatter.format_groups("5")
        expect(result).to eq("5")
      end
    end

    context "with empty string" do
      let(:symbols) { { group_digits: 3 } }

      it "returns empty string" do
        result = formatter.format_groups("")
        expect(result).to eq("")
      end
    end
  end

  describe "#chop_group" do
    context "with default group size" do
      let(:symbols) { { group_digits: 3 } }

      it "chops last 3 digits from string" do
        result = formatter.chop_group("123456", 3)
        expect(result).to eq("456")
      end

      it "chops from string longer than group size" do
        result = formatter.chop_group("12345678", 3)
        expect(result).to eq("678")
      end

      it "returns entire string if smaller than group size" do
        result = formatter.chop_group("12", 3)
        expect(result).to eq("12")
      end
    end

    context "with custom group size" do
      let(:symbols) { {} }

      it "chops last n characters" do
        result = formatter.chop_group("123456789", 2)
        expect(result).to eq("89")
      end

      it "chops single character" do
        result = formatter.chop_group("12345", 1)
        expect(result).to eq("5")
      end
    end

    context "with edge cases" do
      let(:symbols) { {} }

      it "handles empty string" do
        result = formatter.chop_group("", 3)
        expect(result).to eq("")
      end

      it "handles single character" do
        result = formatter.chop_group("5", 3)
        expect(result).to eq("5")
      end
    end
  end

  describe "#number_to_base" do
    context "with default base 10" do
      let(:symbols) { { base: 10 } }

      it "returns number as string unchanged" do
        result = formatter.number_to_base("12345")
        expect(result).to eq("12345")
      end
    end

    context "with hexadecimal base" do
      let(:symbols) { { base: 16 } }

      it "converts to hexadecimal" do
        result = formatter.number_to_base("255")
        expect(result).to eq("ff")
      end

      it "converts larger numbers to hex" do
        result = formatter.number_to_base("4095")
        expect(result).to eq("fff")
      end

      it "converts zero to hex" do
        result = formatter.number_to_base("0")
        expect(result).to eq("0")
      end
    end

    context "with binary base" do
      let(:symbols) { { base: 2 } }

      it "converts to binary" do
        result = formatter.number_to_base("8")
        expect(result).to eq("1000")
      end

      it "converts decimal to binary" do
        result = formatter.number_to_base("255")
        expect(result).to eq("11111111")
      end
    end

    context "with octal base" do
      let(:symbols) { { base: 8 } }

      it "converts to octal" do
        result = formatter.number_to_base("64")
        expect(result).to eq("100")
      end

      it "converts larger numbers to octal" do
        result = formatter.number_to_base("512")
        expect(result).to eq("1000")
      end
    end
  end
end
