# frozen_string_literal: true

require "spec_helper"
require_relative "../../../support/shared_formatter_examples"

RSpec.describe Plurimath::Formatter::Numbers::Integer do
  let(:formatter) { described_class.new(options) }
  let(:options) { Plurimath::Formatter::Numbers::FormatOptions.new(symbols: symbols) }
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

    context "with integer padding" do
      let(:symbols) { { padding: " ", padding_digits: 6 } }

      it "sets padding options" do
        expect(formatter.padding).to eq(" ")
        expect(formatter.padding_digits).to eq(6)
        expect(formatter.padding_group_digits).to eq(0)
      end
    end
  end

  describe "#apply" do
    context "with decimal base" do
      let(:symbols) { { base: 10 } }

      it "returns formatted decimal number" do
        result = formatter.apply("1000")
        expect_shared_formatter_output("integer-070", result)
      end

      it "formats large numbers" do
        result = formatter.apply("1000000")
        expect_shared_formatter_output("integer-075", result)
      end

      it "handles zero" do
        result = formatter.apply("0")
        expect_shared_formatter_output("integer-080", result)
      end

      it "handles single digit" do
        result = formatter.apply("5")
        expect_shared_formatter_output("integer-085", result)
      end

      it "handles numbers smaller than group size" do
        result = formatter.apply("99")
        expect_shared_formatter_output("integer-090", result)
      end
    end

    context "with hexadecimal base" do
      let(:symbols) { { base: 16 } }

      it "converts decimal to hex and formats" do
        result = formatter.apply("255")
        expect_shared_formatter_output("integer-099", result)
      end

      it "converts and lowercases by default" do
        result = formatter.apply("4095")
        expect_shared_formatter_output("integer-104", result)
      end

      it "converts and groups hex" do
        result = formatter.apply("16777215")
        expect_shared_formatter_output("integer-109", result)
      end
    end

    context "with hexadecimal base (default lowercase)" do
      let(:symbols) { { base: 16 } }

      it "converts to lowercase hex letters by default" do
        result = formatter.apply("255")
        expect_shared_formatter_output("integer-118", result)
      end

      it "converts large hex to lowercase by default" do
        result = formatter.apply("4095")
        expect_shared_formatter_output("integer-123", result)
      end
    end

    context "with binary base" do
      let(:symbols) { { base: 2 } }

      it "converts to binary and formats" do
        result = formatter.apply("8")
        expect_shared_formatter_output("integer-132", result)
      end

      it "converts larger binary with grouping" do
        result = formatter.apply("255")
        expect_shared_formatter_output("integer-137", result)
      end
    end

    context "with octal base" do
      let(:symbols) { { base: 8 } }

      it "converts to octal and formats" do
        result = formatter.apply("64")
        expect_shared_formatter_output("integer-146", result)
      end

      it "converts and groups octal" do
        result = formatter.apply("4096")
        expect_shared_formatter_output("integer-151", result)
      end
    end

    context "with custom grouping" do
      let(:symbols) { { base: 10, group_digits: 2 } }

      it "groups by custom size" do
        result = formatter.apply("123456")
        expect_shared_formatter_output("integer-160", result)
      end
    end

    context "with custom separator" do
      let(:symbols) { { base: 10, group: "." } }

      it "uses custom separator" do
        result = formatter.apply("1000000")
        expect_shared_formatter_output("integer-169", result)
      end
    end

    context "with different base and separator" do
      let(:symbols) { { base: 16, group: "_", hex_capital: true } }

      it "applies both base conversion and custom formatting" do
        result = formatter.apply("4095")
        expect_shared_formatter_output("integer-178", result)
      end
    end

    context "with numbers-only hex capitalization" do
      let(:symbols) do
        { base: 16, group_digits: 2, group: "e", hex_capital: :numbers_only }
      end

      it "capitalizes generated hex digits without changing separators" do
        result = formatter.apply("48879")
        expect_shared_formatter_output("integer-189", result)
      end
    end
  end

  describe "#format_groups" do
    context "with default grouping" do
      let(:symbols) { { group_digits: 3 } }

      it "groups string of 6 digits" do
        result = formatter.format_groups("123456")
        expect_shared_formatter_output("integer-200", result)
      end

      it "groups string of 9 digits" do
        result = formatter.format_groups("123456789")
        expect_shared_formatter_output("integer-205", result)
      end

      it "groups string less than group size" do
        result = formatter.format_groups("99")
        expect_shared_formatter_output("integer-210", result)
      end

      it "groups string exactly group size" do
        result = formatter.format_groups("123")
        expect_shared_formatter_output("integer-215", result)
      end
    end

    context "with custom grouping" do
      let(:symbols) { { group_digits: 2, group: "-" } }

      it "groups by 2" do
        result = formatter.format_groups("123456")
        expect_shared_formatter_output("integer-224", result)
      end
    end

    context "with single character" do
      let(:symbols) { { group_digits: 3 } }

      it "returns same character" do
        result = formatter.format_groups("5")
        expect_shared_formatter_output("integer-233", result)
      end
    end

    context "with empty string" do
      let(:symbols) { { group_digits: 3 } }

      it "returns empty string" do
        result = formatter.format_groups("")
        expect_shared_formatter_output("integer-242", result)
      end
    end

    context "with explicit padding digits" do
      let(:symbols) { { group_digits: 3, group: " ", padding_digits: 6 } }

      it "pads before applying integer grouping" do
        result = formatter.format_groups("32")

        expect_shared_formatter_output("integer-252", result)
      end
    end

    context "with custom padding" do
      let(:symbols) { { group_digits: 10, padding_digits: 6, padding: " " } }

      it "uses the configured padding character" do
        result = formatter.format_groups("32")

        expect_shared_formatter_output("integer-262", result)
      end
    end

    context "with padding group digits" do
      let(:symbols) { { group_digits: 10, padding_group_digits: 4 } }

      it "pads to the next configured multiple" do
        result = formatter.format_groups("32123")

        expect_shared_formatter_output("integer-272", result)
      end

      it "keeps strings that already match the configured multiple" do
        result = formatter.format_groups("1234")

        expect_shared_formatter_output("integer-278", result)
      end
    end

    context "with fixed-width padding that is not needed" do
      let(:symbols) { { group_digits: 10, padding_digits: 3 } }

      it "keeps wider integer strings unchanged" do
        result = formatter.format_groups("12345")

        expect_shared_formatter_output("integer-288", result)
      end
    end

    context "with zero and padding group digits" do
      let(:symbols) { { group_digits: 10, padding_group_digits: 4 } }

      it "pads zero to the configured multiple" do
        result = formatter.format_groups("0")

        expect_shared_formatter_output("integer-298", result)
      end
    end

    context "with numbers-only hex capitalization and custom padding" do
      let(:symbols) do
        {
          base: 16,
          group_digits: 10,
          hex_capital: :numbers_only,
          padding: "f",
          padding_digits: 5,
        }
      end

      it "does not uppercase the custom padding character" do
        result = formatter.format_groups("beef")

        expect_shared_formatter_output("integer-316", result)
      end
    end
  end

  describe "#chop_group" do
    context "with default group size" do
      let(:symbols) { { group_digits: 3 } }

      it "chops last 3 digits from string" do
        result = formatter.chop_group("123456", 3)
        expect_shared_formatter_output("integer-327", result)
      end

      it "chops from string longer than group size" do
        result = formatter.chop_group("12345678", 3)
        expect_shared_formatter_output("integer-332", result)
      end

      it "returns entire string if smaller than group size" do
        result = formatter.chop_group("12", 3)
        expect_shared_formatter_output("integer-337", result)
      end
    end

    context "with custom group size" do
      let(:symbols) { {} }

      it "chops last n characters" do
        result = formatter.chop_group("123456789", 2)
        expect_shared_formatter_output("integer-346", result)
      end

      it "chops single character" do
        result = formatter.chop_group("12345", 1)
        expect_shared_formatter_output("integer-351", result)
      end
    end

    context "with edge cases" do
      let(:symbols) { {} }

      it "handles empty string" do
        result = formatter.chop_group("", 3)
        expect_shared_formatter_output("integer-360", result)
      end

      it "handles single character" do
        result = formatter.chop_group("5", 3)
        expect_shared_formatter_output("integer-365", result)
      end
    end
  end

  describe "#number_to_base" do
    context "with default base 10" do
      let(:symbols) { { base: 10 } }

      it "returns number as string unchanged" do
        result = formatter.number_to_base("12345")
        expect_shared_formatter_output("integer-376", result)
      end
    end

    context "with hexadecimal base" do
      let(:symbols) { { base: 16 } }

      it "converts to hexadecimal" do
        result = formatter.number_to_base("255")
        expect_shared_formatter_output("integer-385", result)
      end

      it "converts larger numbers to hex" do
        result = formatter.number_to_base("4095")
        expect_shared_formatter_output("integer-390", result)
      end

      it "converts zero to hex" do
        result = formatter.number_to_base("0")
        expect_shared_formatter_output("integer-395", result)
      end
    end

    context "with binary base" do
      let(:symbols) { { base: 2 } }

      it "converts to binary" do
        result = formatter.number_to_base("8")
        expect_shared_formatter_output("integer-404", result)
      end

      it "converts decimal to binary" do
        result = formatter.number_to_base("255")
        expect_shared_formatter_output("integer-409", result)
      end
    end

    context "with octal base" do
      let(:symbols) { { base: 8 } }

      it "converts to octal" do
        result = formatter.number_to_base("64")
        expect_shared_formatter_output("integer-418", result)
      end

      it "converts larger numbers to octal" do
        result = formatter.number_to_base("512")
        expect_shared_formatter_output("integer-423", result)
      end
    end
  end
end
