# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::Fraction do
  let(:formatter) { described_class.new(symbols) }
  let(:symbols) { {} }

  describe "#initialize" do
    context "with default symbols" do
      let(:symbols) { {} }

      it "initializes with default decimal point" do
        expect(formatter.decimal).to eq(".")
      end

      it "initializes with default precision" do
        expect(formatter.precision).to eq(3)
      end

      it "initializes with default base" do
        expect(formatter.base).to eq(10)
      end

      it "initializes with zero digit count" do
        expect(formatter.instance_variable_get(:@digit_count)).to eq(0)
      end
    end

    context "with custom decimal" do
      let(:symbols) { { decimal: "," } }

      it "sets custom decimal separator" do
        expect(formatter.decimal).to eq(",")
      end
    end

    context "with custom precision" do
      let(:symbols) { { precision: 5 } }

      it "sets custom precision" do
        expect(formatter.precision).to eq(5)
      end
    end

    context "with custom base" do
      let(:symbols) { { base: 16 } }

      it "sets custom base" do
        expect(formatter.base).to eq(16)
      end
    end

    context "with all custom options" do
      let(:symbols) do
        { decimal: ",", precision: 4, base: 2, group_digits: 4,
          fraction_group_digits: 2, group: "_", fraction_group: "-" }
      end

      it "sets all values correctly" do
        expect(formatter.decimal).to eq(",")
        expect(formatter.precision).to eq(4)
        expect(formatter.base).to eq(2)
        expect(formatter.separator).to eq("-")
      end
    end
  end

  describe "#apply_parts" do
    let(:parts) { Plurimath::Formatter::Numbers::Source.new(number).to_parts }
    let(:number) { "10.5" }

    context "with zero precision" do
      let(:symbols) { { precision: 0 } }

      it "removes the fraction digits" do
        result = formatter.apply_parts(parts)

        expect(result.fraction_digits).to eq("")
      end
    end

    context "with decimal base" do
      let(:symbols) { { decimal: ".", precision: 3 } }

      it "pads fraction to precision" do
        result = formatter.apply_parts(parts)

        expect(result.fraction_digits).to eq("500")
      end
    end

    context "with non-decimal base" do
      let(:symbols) { { base: 2, precision: 4 } }

      it "converts the fraction digits to the target base" do
        result = formatter.apply_parts(parts)

        expect(result.fraction_digits).to eq("1000")
      end
    end

    context "with digit count rounding" do
      let(:symbols) { { precision: 1, digit_count: 3 } }
      let(:number) { "999.9" }

      it "returns rounded integer digits without rendering groups" do
        result = formatter.apply_parts(parts)

        expect(result.integer_digits).to eq("1000")
        expect(result.fraction_digits).to eq("")
      end
    end
  end

  describe "#format" do
    context "with shorter number than precision" do
      let(:symbols) { { precision: 3 } }

      it "pads with zeros" do
        result = formatter.format("5", 3)
        expect(result).to eq("500")
      end

      it "pads single digit" do
        result = formatter.format("1", 3)
        expect(result).to eq("100")
      end
    end

    context "with longer number than precision" do
      let(:symbols) { { precision: 2 } }

      it "returns number unchanged" do
        result = formatter.format("123", 2)
        expect(result).to eq("123")
      end
    end

    context "with equal length" do
      let(:symbols) { { precision: 3 } }

      it "returns number unchanged" do
        result = formatter.format("123", 3)
        expect(result).to eq("123")
      end
    end

    context "with zero precision" do
      let(:symbols) { { precision: 0 } }

      it "returns number unchanged" do
        result = formatter.format("5", 0)
        expect(result).to eq("5")
      end
    end
  end

  describe "#format_groups" do
    context "with default group size" do
      let(:symbols) { { fraction_group_digits: 2, fraction_group: "-" } }

      it "groups by specified size" do
        result = formatter.format_groups("123456")
        expect(result).to eq("12-34-56")
      end

      it "groups with custom separator" do
        symbols[:fraction_group] = "_"
        result = formatter.format_groups("123456")
        expect(result).to eq("12_34_56")
      end
    end

    context "with zero group digits" do
      let(:symbols) { { fraction_group_digits: 0 } }

      it "returns string unchanged" do
        result = formatter.format_groups("123456")
        expect(result).to eq("123456")
      end
    end

    context "with string shorter than group size" do
      let(:symbols) { { fraction_group_digits: 3 } }

      it "returns string unchanged" do
        result = formatter.format_groups("12")
        expect(result).to eq("12")
      end
    end

    context "with numbers-only hex capitalization" do
      let(:symbols) { { base: 16, fraction_group_digits: 1, fraction_group: "f", hex_capital: :numbers_only } }

      it "capitalizes generated hex digits without changing separators" do
        result = formatter.format_groups("af0")
        expect(result).to eq("AfFf0")
      end
    end
  end

  describe "#change_base" do
    context "with binary base" do
      let(:symbols) { { base: 2, precision: 4 } }

      it "converts fractional part to binary" do
        result = formatter.send(:change_base, "5")
        expect(result).to be_a(String)
        expect(result.chars.all? { |c| ["0", "1"].include?(c) }).to be(true)
      end
    end

    context "with hexadecimal base" do
      let(:symbols) { { base: 16, precision: 3 } }

      it "converts to hex digits" do
        result = formatter.send(:change_base, "10")
        expect(result).to be_a(String)
        expect(result.length).to be <= 3
      end
    end

    context "with octal base" do
      let(:symbols) { { base: 8, precision: 3 } }

      it "converts to octal digits" do
        result = formatter.send(:change_base, "5")
        expect(result).to be_a(String)
        expect(result.chars.all? { |c| ("0".."7").cover?(c) }).to be(true)
      end
    end

    context "with uppercase hex" do
      let(:symbols) { { base: 16, hex_capital: true, precision: 3 } }

      it "returns uppercase hex digits" do
        result = formatter.send(:change_base, "15")
        expect(result).to be_a(String)
      end
    end

    context "with zero" do
      let(:symbols) { { base: 2, precision: 3 } }

      it "handles zero" do
        result = formatter.send(:change_base, "0")
        expect(result).to be_a(String)
      end
    end
  end
end
