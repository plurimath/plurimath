# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::Significant do
  let(:symbols) { { decimal: ".", significant: 2 } }
  let(:formatter) { described_class.new(symbols) }

  describe "#initialize" do
    it "stores decimal symbol" do
      expect(formatter.decimal).to eq(".")
    end

    it "stores significant digits" do
      expect(formatter.significant).to eq(2)
    end

    it "initializes with default base 10" do
      expect(formatter.base).to eq(10)
    end

    context "with custom significant" do
      let(:symbols) { { decimal: ".", significant: 3 } }

      it "sets significant to 3" do
        expect(formatter.significant).to eq(3)
      end
    end

    context "with custom decimal" do
      let(:symbols) { { decimal: ",", significant: 2 } }

      it "sets decimal separator" do
        expect(formatter.decimal).to eq(",")
      end
    end
  end

  describe "#apply" do
    context "with zero significant digits" do
      let(:symbols) { { decimal: ".", significant: 0 } }

      it "returns the string unchanged" do
        int_fmt = double(separator: ",", format_groups: "123")
        frac_fmt = double(separator: ",", format_groups: "456")
        expect(formatter.apply("123.456", int_fmt, frac_fmt)).to eq("123.456")
      end
    end

    context "with string containing no significant digits" do
      it "returns the string unchanged" do
        int_fmt = double(separator: ",", format_groups: "0")
        frac_fmt = double(separator: ",", format_groups: "000")
        expect(formatter.apply("0.000", int_fmt, frac_fmt)).to eq("0.000")
      end
    end

    context "rounding with boundary condition" do
      let(:symbols) { { decimal: ".", significant: 2 } }

      it "should round 0.0999 to 0.10" do
        int_format = double(separator: ",")
        frac_format = double(separator: ",")
        allow(int_format).to receive(:format_groups) { |x| x }
        allow(frac_format).to receive(:format_groups) { |x| x }
        expect(formatter.apply("0.0999", int_format, frac_format)).to eq("0.10")
      end

      it "should round 9.99 to 10" do
        int_format = double(separator: ",")
        frac_format = double(separator: ",")
        allow(int_format).to receive(:format_groups) { |x| x }
        allow(frac_format).to receive(:format_groups) { |x| x }
        expect(formatter.apply("9.99", int_format, frac_format)).to eq("10")
      end

      it "should round 1.99 to 2" do
        int_format = double(separator: ",")
        frac_format = double(separator: ",")
        allow(int_format).to receive(:format_groups) { |x| x }
        allow(frac_format).to receive(:format_groups) { |x| x }
        expect(formatter.apply("1.99", int_format, frac_format)).to eq("2")
      end
    end

    context "with significant digit count met" do
      let(:symbols) { { decimal: ".", significant: 4 } }

      it "returns string when significant digits match" do
        int_format = double(separator: ",", format_groups: "123")
        frac_format = double(separator: ",", format_groups: "5")
        result = formatter.apply("123.456", int_format, frac_format)
        expect(result).to eq("123.5")
      end
    end
  end

  describe "#count_chars" do
    context "with integer part" do
      let(:symbols) { { decimal: ".", significant: 2 } }

      it "counts significant digits in integer" do
        chars = "123".chars
        result = formatter.send(:count_chars, chars, false)
        expect(result).to eq(3)
      end
    end

    context "with fractional part" do
      let(:symbols) { { decimal: ".", significant: 2 } }

      it "counts fractional digits" do
        chars = "123".chars
        result = formatter.send(:count_chars, chars, true)
        expect(result).to eq(3)
      end
    end

    context "with decimal point" do
      let(:symbols) { { decimal: ".", significant: 2 } }

      it "stops counting at decimal for integer" do
        chars = "123.456".chars
        result = formatter.send(:count_chars, chars, false)
        expect(result).to eq(3)
      end

      it "counts past decimal for fraction" do
        chars = "123.456".chars
        result = formatter.send(:count_chars, chars, true)
        expect(result).to eq(6)
      end
    end

    context "with zero values" do
      let(:symbols) { { decimal: ".", significant: 2 } }

      it "counts zeros as significant digits" do
        chars = "102".chars
        result = formatter.send(:count_chars, chars, false)
        expect(result).to eq(3)
      end
    end
  end

  describe "#process_chars" do
    context "with integer digits" do
      let(:symbols) { { decimal: ".", significant: 2 } }

      it "returns chars and significant count" do
        chars = "123".chars
        new_chars, frac_part, sig_count = formatter.send(:process_chars, chars)
        expect(new_chars.length).to be > 0
        expect(sig_count).to be >= 0
      end
    end

    context "with decimal point" do
      let(:symbols) { { decimal: ".", significant: 2 } }

      it "sets frac_part when decimal is encountered" do
        chars = "1.23".chars
        new_chars, frac_part, sig_count = formatter.send(:process_chars, chars)
        expect(frac_part).to be(true)
      end
    end

    context "with leading zeros" do
      let(:symbols) { { decimal: ".", significant: 2 } }

      it "processes leading zeros" do
        chars = "0.0123".chars
        new_chars, frac_part, sig_count = formatter.send(:process_chars, chars)
        expect(new_chars).to be_a(Array)
      end
    end
  end

  describe "#round_str" do
    context "boundary condition test" do
      let(:symbols) { { decimal: ".", significant: 2 } }

      it "should round 99.9 to 100" do
        int_format = double(separator: ",")
        frac_format = double(separator: ",")
        allow(int_format).to receive(:format_groups) { |x| x }
        allow(frac_format).to receive(:format_groups) { |x| x }
        expect(formatter.apply("99.9", int_format, frac_format)).to eq("100")
      end
    end

    context "with rounding up" do
      let(:symbols) { { decimal: ".", significant: 2 } }

      it "should round 19.5 to 20" do
        int_format = double(separator: ",")
        frac_format = double(separator: ",")
        allow(int_format).to receive(:format_groups) { |x| x }
        allow(frac_format).to receive(:format_groups) { |x| x }
        expect(formatter.apply("19.5", int_format, frac_format)).to eq("20")
      end
    end
  end

  describe "#sig_char_count?" do
    context "with correct significant count" do
      let(:symbols) { { decimal: ".", significant: 3 } }

      it "returns true when count matches" do
        chars = "123".chars
        result = formatter.send(:sig_char_count?, chars)
        expect(result).to be(true)
      end
    end

    context "with incorrect significant count" do
      let(:symbols) { { decimal: ".", significant: 2 } }

      it "returns false when count does not match" do
        chars = "123".chars
        result = formatter.send(:sig_char_count?, chars)
        expect(result).to be(false)
      end
    end

    context "with leading zeros" do
      let(:symbols) { { decimal: ".", significant: 2 } }

      it "does not count leading zeros" do
        chars = "0.0123".chars
        result = formatter.send(:sig_char_count?, chars)
        expect(result).to be(false)
      end
    end
  end
end
