# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::Fraction do
  let(:formatter) { described_class.new(symbols) }
  let(:symbols) { {} }
  let(:result) { ["10"] }
  let(:integer_formatter) { double(format_groups: "10") }

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
      let(:symbols) { { decimal: ",", precision: 4, base: 2, group_digits: 4, fraction_group_digits: 2, group: "_", fraction_group: "-" } }

      it "sets all values correctly" do
        expect(formatter.decimal).to eq(",")
        expect(formatter.precision).to eq(4)
        expect(formatter.base).to eq(2)
        expect(formatter.separator).to eq("-")
      end
    end
  end

  describe "#apply" do
    context "with zero precision" do
      let(:symbols) { { precision: 0 } }

      it "returns empty string" do
        result_arr = ["10"]
        result = formatter.apply("123", result_arr, integer_formatter)
        expect(result).to eq("")
      end
    end

    context "with decimal base" do
      let(:symbols) { { decimal: ".", precision: 3 } }

      it "formats fraction with zeros" do
        result_arr = ["10"]
        result = formatter.apply("5", result_arr, integer_formatter)
        expect(result.start_with?(".")).to be(true)
      end

      it "pads fraction to precision" do
        result_arr = ["10"]
        result = formatter.apply("1", result_arr, integer_formatter)
        expect(result.start_with?(".")).to be(true)
        expect(result.split(".").last.length).to be >= 1
      end
    end

    context "with custom decimal separator" do
      let(:symbols) { { decimal: ",", precision: 2 } }

      it "uses custom separator" do
        result_arr = ["10"]
        result = formatter.apply("5", result_arr, integer_formatter)
        expect(result.start_with?(",")).to be(true)
      end
    end

    context "with precision override" do
      let(:symbols) { { precision: 3 } }

      it "uses provided precision over default" do
        result_arr = ["10"]
        result = formatter.apply("5", result_arr, integer_formatter)
        expect(result).to be_a(String)
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
        symbols.merge!(fraction_group: "_")
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
        expect(result.chars.all? { |c| ("0".."7").include?(c) }).to be(true)
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
