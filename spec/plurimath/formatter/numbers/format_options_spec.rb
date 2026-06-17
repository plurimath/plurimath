# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::FormatOptions do
  def build_source(number_string)
    Plurimath::Formatter::Numbers::Source.new(number_string)
  end

  describe "#initialize" do
    it "normalizes notation option values" do
      source = build_source("14000")
      symbols = {
        decimal: "@",
        group: "_",
        group_digits: 2,
        base: 16,
        base_prefix: "16#",
        number_sign: :plus,
        notation: "scientific",
        e: "E",
        times: "x",
        exponent_sign: "plus",
      }
      resolver = Plurimath::Formatter::Numbers::PrecisionResolver.new
      options = described_class.new(
        source,
        symbols: symbols,
        precision: nil,
        precision_resolver: resolver,
      )

      expect(options.notation).to eq(:scientific)
      expect(options.exponent_separator).to eq(:E)
      expect(options.times).to eq(:x)
      expect(options.exponent_sign).to eq(:plus)
    end

    it "uses merged symbols for renderer options" do
      options = described_class.new(
        symbols: {
          decimal: "@",
          group: "_",
          group_digits: 2,
          base: 16,
          base_prefix: "16#",
          number_sign: :plus,
        },
      )

      expect(options.decimal).to eq("@")
      expect(options.group).to eq("_")
      expect(options.group_digits).to eq(2)
      expect(options.base).to eq(16)
      expect(options.base_prefix).to eq("16#")
      expect(options).to be_base_prefix
      expect(options.number_sign).to eq(:plus)
    end

    it "normalizes hex_capital option values" do
      expectations = { true => true, false => nil, nil => nil, 1 => nil }
      string_forms = {
        "true" => true,
        "numbers_only" => :numbers_only,
        "false" => nil,
        "TRUE" => nil,
      }
      string_forms.each do |string, expected|
        expectations[string] = expected
        expectations[string.to_sym] = expected
      end

      expectations.each do |value, expected|
        options = described_class.new(symbols: { hex_capital: value })

        expect(options.hex_capital).to eq(expected),
                                       "expected hex_capital #{value.inspect} to normalize to #{expected.inspect}"
      end
    end

    it "normalizes numeric string and symbol forms for count options" do
      valid_forms = [4, "4", :"4"]
      valid_forms.each do |value|
        # padding_digits and padding_group_digits are mutually exclusive, so
        # the second instance carries the latter.
        options = described_class.new(
          symbols: {
            significant: value,
            digit_count: value,
            group_digits: value,
            fraction_group_digits: value,
            padding_digits: value,
          },
        )
        group_padded = described_class.new(symbols: { padding_group_digits: value })

        expect(options.significant).to eq(4)
        expect(options.digit_count).to eq(4)
        expect(options.group_digits).to eq(4)
        expect(options.fraction_group_digits).to eq(4)
        expect(options.padding_digits).to eq(4)
        expect(group_padded.padding_group_digits).to eq(4)
      end
    end

    it "rejects junk, boolean, float, and negative count values" do
      invalid_values = ["abc", true, 1.5, -1, ""]
      invalid_values.each do |value|
        expect { described_class.new(symbols: { significant: value }).significant }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :significant/),
              "expected significant to reject #{value.inspect}"
        expect { described_class.new(symbols: { digit_count: value }).digit_count }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :digit_count/),
              "expected digit_count to reject #{value.inspect}"
        expect { described_class.new(symbols: { group_digits: value }).group_digits }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :group_digits/),
              "expected group_digits to reject #{value.inspect}"
        expect { described_class.new(symbols: { fraction_group_digits: value }).fraction_group_digits }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :fraction_group_digits/),
              "expected fraction_group_digits to reject #{value.inspect}"
        expect { described_class.new(symbols: { padding_digits: value }).padding_digits }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :padding_digits/),
              "expected padding_digits to reject #{value.inspect}"
        expect { described_class.new(symbols: { padding_group_digits: value }).padding_group_digits }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :padding_group_digits/),
              "expected padding_group_digits to reject #{value.inspect}"
      end
    end

    it "rejects invalid precision values" do
      ["abc", true, false, 1.5, "", -1, "-2"].each do |value|
        expect do
          described_class.new(symbols: { precision: value })
        end.to raise_error(
          Plurimath::ConfigurationError,
          /formatter option :precision/,
        ), "expected precision to reject #{value.inspect}"
      end
    end

    it "treats an explicit nil decimal as disabled" do
      expect(described_class.new(symbols: { decimal: nil }).decimal).to be_nil
    end

    it "falls back to the default separator for an explicit nil group" do
      # Released 0.10.7 behavior; "" disables grouping instead.
      expect(described_class.new(symbols: { group: nil }).group).to eq(",")
      expect(described_class.new(symbols: { group: "" }).group).to eq("")
    end

    it "rejects boolean separator values" do
      booleans = [true, false]
      booleans.each do |value|
        expect { described_class.new(symbols: { decimal: value }).decimal }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :decimal/)
        expect { described_class.new(symbols: { group: value }).group }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :group/)
        expect { described_class.new(symbols: { fraction_group: value }).fraction_group }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :fraction_group/)
        expect { described_class.new(symbols: { padding: value }).padding }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :padding/)
        expect { described_class.new(symbols: { base_prefix: value }).base_prefix }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :base_prefix/)
        expect { described_class.new(symbols: { base_postfix: value }).base_postfix }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :base_postfix/)
      end
    end

    it "rejects boolean values for symbol-typed options" do
      booleans = [true, false]
      booleans.each do |value|
        # notation, e, times, and exponent_sign are read at construction.
        expect { described_class.new(symbols: { notation: value }) }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :notation/)
        expect { described_class.new(symbols: { e: value }) }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :e/)
        expect { described_class.new(symbols: { times: value }) }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :times/)
        expect { described_class.new(symbols: { exponent_sign: value }) }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :exponent_sign/)
        expect { described_class.new(symbols: { number_sign: value }).number_sign }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :number_sign/)
      end
    end

    it "rejects non-string, non-symbol values for symbol-typed options" do
      [5, 1.5, {}, []].each do |value|
        expect { described_class.new(symbols: { notation: value }) }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :notation/),
              "expected notation to reject #{value.inspect}"
        expect { described_class.new(symbols: { number_sign: value }).number_sign }
          .to raise_error(Plurimath::ConfigurationError, /formatter option :number_sign/),
              "expected number_sign to reject #{value.inspect}"
      end
    end

    it "accepts string and symbol values for symbol-typed options" do
      expect(described_class.new(symbols: { notation: "scientific" }).notation).to eq(:scientific)
      expect(described_class.new(symbols: { notation: :scientific }).notation).to eq(:scientific)
    end

    it "normalizes numeric base forms and leaves unsupported values raw" do
      expect(described_class.new(symbols: { base: "16" }).base).to eq(16)
      expect(described_class.new(symbols: { base: :"16" }).base).to eq(16)
      expect(described_class.new(symbols: { base: nil }).base).to eq(10)
      # Unsupported values stay raw so BaseNotation reports them.
      expect(described_class.new(symbols: { base: "abc" }).base).to eq("abc")
    end

    it "tracks whether precision was explicitly provided" do
      expect(described_class.new(symbols: { precision: 2 })).to be_explicit_precision
      expect(described_class.new(symbols: {})).not_to be_explicit_precision
    end

    it "resolves precision through PrecisionResolver with source metadata" do
      source = build_source("0.00")
      symbols = {}
      resolver = Plurimath::Formatter::Numbers::PrecisionResolver.new

      options = described_class.new(
        source,
        symbols: symbols,
        precision: nil,
        precision_resolver: resolver,
      )

      expect(options.exponent_separator).to eq(:e)
      expect(options.times).to eq("\u{d7}")
      expect(options.precision).to eq(2)
    end

    it "uses formatter defaults when symbols do not provide values" do
      options = described_class.new(symbols: {})

      expect(options.base).to eq(10)
      expect(options.decimal).to eq(".")
      expect(options.group).to eq(",")
      expect(options.group_digits).to eq(3)
      expect(options.digit_count).to eq(0)
      expect(options.significant).to eq(0)
      expect(options.padding).to eq("0")
      expect(options.padding_digits).to eq(0)
      expect(options.padding_group_digits).to eq(0)
    end

    it "uses configured integer padding options" do
      options = described_class.new(
        symbols: {
          padding: " ",
          padding_digits: 6,
        },
      )

      expect(options.padding).to eq(" ")
      expect(options.padding_digits).to eq(6)
      expect(options.padding_group_digits).to eq(0)
    end

    it "uses only the first configured padding character" do
      options = described_class.new(symbols: { padding: "xy", padding_digits: 4 })

      expect(options.padding).to eq("x")
    end

    it "falls back to zero padding when the configured padding is blank" do
      options = described_class.new(symbols: { padding: "", padding_digits: 4 })

      expect(options.padding).to eq("0")
    end

    it "allows a padding group width when fixed-width padding is absent" do
      options = described_class.new(
        symbols: {
          padding_group_digits: 4,
        },
      )

      expect(options.padding_digits).to eq(0)
      expect(options.padding_group_digits).to eq(4)
    end

    it "rejects padding width options that are used together" do
      expect do
        described_class.new(
          symbols: {
            padding_digits: 6,
            padding_group_digits: 4,
          },
        )
      end.to raise_error(
        Plurimath::ConfigurationError,
        "formatter options cannot be used together: choose either " \
        ":padding_digits or :padding_group_digits",
      )
    end

    it "rejects padding width options that are both provided with non-positive values" do
      expect do
        described_class.new(
          symbols: {
            padding_digits: -6,
            padding_group_digits: -4,
          },
        )
      end.to raise_error(
        Plurimath::ConfigurationError,
        "formatter options cannot be used together: choose either " \
        ":padding_digits or :padding_group_digits",
      )
    end
  end
end
