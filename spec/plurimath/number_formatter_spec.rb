require "spec_helper"

RSpec.describe Plurimath::NumberFormatter do
  subject(:formatter) { described_class.new(locale, localize_number: localize_number, localizer_symbols: localizer_symbols) }

  describe ".initialize" do
    context "class variables" do
      let(:locale) { :de }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it "matches class to be correct" do
        expect(formatter).to be_a(described_class)
      end

      it "matches instance variables values" do
        expect(formatter.locale).to eql(:de)
        expect(formatter.localize_number).to eql(nil)
        expect(formatter.localizer_symbols).to eql({})
      end
    end
  end

  describe ".localized_number" do
    context "testing notations with notation related arguments(times, exponent_sign, e sign), decimal, locale, and precision" do
      let(:locale) { :en }
      let(:number) { "14000" }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it "exposes symbols: :basic with en locale" do
        output_string = formatter.twitter_cldr_reader(locale: locale)
        expect(output_string[:decimal]).to eql(".")
      end

      it "exposes symbols: :basic with fr locale" do
        output_string = formatter.twitter_cldr_reader(locale: :fr)
        expect(output_string[:decimal]).to eql(",")
      end

      it "matches notation: :basic with de locale localized without precision string" do
        format = { decimal: "*", notation: :basic, group_digits: 3 }
        output_string = formatter.localized_number(number, locale: locale, format: format)
        expect(output_string).to eql("14,000")
      end

      it "matches localized string with notation: :e, e: :E and precision" do
        format = { decimal: "@", notation: :e, e: :E }
        output_string = formatter.localized_number(number, precision: 1, format: format)
        expect(output_string).to eql("1@4E4")
      end

      it "matches localized string notation: :scientific with en locale and exponent sign" do
        format = { decimal: ".", notation: :scientific, exponent_sign: :plus, fraction_group: " ", fraction_group_digits: 3 }
        output_string = formatter.localized_number(number, format: format)
        expect(output_string).to eql("1.400 0 × 10^+4")
      end

      it "matches localized string with notation: :engineering and times initialized locale" do
        format = { decimal: ",", notation: :engineering, times: "x" }
        output_string = formatter.localized_number(number, locale: locale, precision: 2, format: format)
        expect(output_string).to eql("14,00 x 10^3")
      end
    end

    context "testing digit grouping and decimal symbol" do
      let(:locale) { :en }
      let(:number) { "14236.39239" }
      let(:localize_number) { "#,##0.### #" }
      let(:localizer_symbols) { {} }

      it "matches group_digits:, group:, and decimal" do
        format = { group_digits: 2, group: "'", decimal: "*" }
        output_string = formatter.localized_number(number, locale: locale, format: format)
        expect(output_string).to eql("1'42'36*392 39")
      end
    end

    context "testing fraction digit group and decimal symbol" do
      let(:locale) { :en }
      let(:number) { "14236.39239" }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it "matches fraction_group_digits:, fraction_group:, and decimal" do
        format = { fraction_group_digits: 4, fraction_group: ",", decimal: "@", group_digits: 3 }
        output_string = formatter.localized_number(number, locale: locale, format: format)
        expect(output_string).to eql("14,236@3923,9")
      end
    end

    context "testing digit counts" do
      let(:locale) { :en }
      let(:number) { "14236.39239" }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it "matches locale: kk with minimum digit_count" do
        output_string = formatter.localized_number(number, locale: :kk, format: { digit_count: 6, group_digits: 3 })
        expect(output_string).to eql("14 236,4")
      end

      it "matches locale: kk with maximum digit_count" do
        output_string = formatter.localized_number(number, locale: :kk, format: { digit_count: 16, fraction_group: " ", fraction_group_digits: 3, group_digits: 3 })
        expect(output_string).to eql("14 236,392 390 000 00")
      end
    end

    context "testing precision with es locale" do
      let(:locale) { :en }
      let(:number) { "14236.39239" }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it "matches locale: kk with precision" do
        output_string = formatter.localized_number(number, locale: :es, precision: 20, format: { fraction_group: " ", fraction_group_digits: 3, group_digits: 3 })
        expect(output_string).to eql("14.236,392 390 000 000 000 000 00")
      end
    end

    context "testing plurimath#262 example with de locale" do
      # :de locale default values used
      # group => "."
      # decimal => ","
      # group_digits => 3
      let(:locale) { :de }
      let(:number) { "327428.000878432992" }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it "matches locale: de with precision" do
        output_string = formatter.localized_number(number, format: { digit_count: 18, group_digits: 3 })
        expect(output_string).to eql("327.428,000878432992")
        output_string = formatter.localized_number(number, format: { digit_count: 19, group_digits: 3 })
        expect(output_string).to eql("327.428,0008784329920")
        output_string = formatter.localized_number(number, format: { digit_count: 20, group_digits: 3 })
        expect(output_string).to eql("327.428,00087843299200")
        output_string = formatter.localized_number(number, format: { digit_count: 18, notation: :scientific, group_digits: 3 })
        expect(output_string).to eql("3,27428000878432992 × 10^5")
        output_string = formatter.localized_number(number, format: { digit_count: 19, notation: :scientific, group_digits: 3 })
        expect(output_string).to eql("3,274280008784329920 × 10^5")
        output_string = formatter.localized_number(number, format: { digit_count: 20, notation: :scientific, group_digits: 3 })
        expect(output_string).to eql("3,2742800087843299200 × 10^5")
      end
    end

    context "testing plurimath#264 example with de locale and significant option" do
      # :de locale default values used
      # group => "."
      # decimal => ","
      # group_digits => 3
      let(:locale) { :de }
      let(:number) { "0.001" }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it "matches locale: de with digit count and significant" do
        output_string = formatter.localized_number(number, format: { digit_count: 3, group_digits: 3 })
        expect(output_string).to eql("0,00")
        output_string = formatter.localized_number(number, format: { digit_count: 6, notation: :scientific, group_digits: 3 })
        expect(output_string).to eql("1,00000 × 10^-3")
        output_string = formatter.localized_number(number, format: { significant: 3, group_digits: 3 })
        expect(output_string).to eql("0,001")
        output_string = formatter.localized_number(number, format: { significant: 3, notation: :e, group_digits: 3 })
        expect(output_string).to eql("1,00e-3")
        output_string = formatter.localized_number(number, format: { significant: 3, notation: :scientific, group_digits: 3 })
        expect(output_string).to eql("1,00 × 10^-3")
        output_string = formatter.localized_number(number, format: { significant: 4, notation: :engineering, group_digits: 3 })
        expect(output_string).to eql("1,000 × 10^-3")
      end
    end

    context "testing examples with de locale and significant option" do
      # :de locale default values used
      # group => "."
      # decimal => ","
      # group_digits => 3
      let(:locale) { :de }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it "matches locale: de with 2 significant" do
        output_string = formatter.localized_number("112", format: { significant: 2, group_digits: 3 })
        expect(output_string).to eql("110")
      end

      it "matches locale: de with 2 significant for multiple 9's in number" do
        output_string = formatter.localized_number("1999", format: { significant: 2, group_digits: 3 })
        expect(output_string).to eql("2.000")
      end

      it "matches locale: de with 4 significant for float number" do
        output_string = formatter.localized_number("1999.9", format: { significant: 4, group_digits: 3 })
        expect(output_string).to eql("2.000")
      end

      it "matches locale: de with 5 significant" do
        output_string = formatter.localized_number("112436", format: { significant: 5, group_digits: 3 })
        expect(output_string).to eql("112.440")
      end

      it "matches locale: de with 5 significant" do
        output_string = formatter.localized_number("1234567", format: { significant: 5, group_digits: 3 })
        expect(output_string).to eql("1.234.600")
      end

      it "matches locale: de with 3 significant" do
        output_string = formatter.localized_number("0.1999", format: { significant: 3, group_digits: 3 })
        expect(output_string).to eql("0,200")
      end

      it "matches locale: de with 5 significant with engineering notation" do
        output_string = formatter.localized_number("112436", format: { significant: 5, notation: :engineering, group_digits: 3 })
        expect(output_string).to eql("112,44 × 10^3")
      end
    end

    context "testing with de locale PR plurimath#268 for locale configuration" do
      # :de locale default values used
      # group => "."
      # decimal => ","
      # group_digits => 3
      let(:locale) { :de }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it "matches locale: de with digit count and significant" do
        number = "31564.346"
        # passing group and decimal to the formatter instance
        output_string = formatter.localized_number(number, format: { decimal: "x", group: "|", group_digits: 3 })
        expect(output_string).to eql("31|564x346")
        # Not passing group and decimal to the same formatter instance
        output_string = formatter.localized_number(number, format: { group: ".", group_digits: 3 })
        expect(output_string).to eql("31.564,346")
      end

      it "matches locale: de with large number and format options, trimming trailing non-significant zeros" do
        format_hash = { fraction_group_digits: 2, fraction_group: "'", significant: 9, group_digits: 3 }
        output_string = formatter.localized_number("327428.7432878432992", precision: nil, format: format_hash)
        expect(output_string).to eql("327.428,74'3")
      end

      it "matches false output due to ambiguity between decimal and group values" do
        format_hash = { fraction_group_digits: 2, fraction_group: "'", decimal: ",", notation: :basic, significant: 9, group_digits: 3 }
        output_string = formatter.localized_number("327428.7432878432992", locale: :en, precision: nil, format: format_hash)
        expect(output_string).to eql("327,42'8")
      end

      it "matches precision nil, significant and other format options" do
        format_hash = { fraction_group_digits: 2, fraction_group: "'", decimal: ",", notation: :e, significant: 9 }
        output_string = formatter.localized_number("327428.7432878432992", precision: nil, format: format_hash)
        expect(output_string).to eql("3,27'42'87'43e5")
      end

      it "matches notation e with significant and other format options" do
        format_hash = { fraction_group_digits: 2, fraction_group: "'", decimal: ",", group: " ", notation: :e, significant: 1 }
        format_hash2 = format_hash.merge(significant: 2)
        # very large number
        output_string = formatter.localized_number("1000000000000000000000.0", locale: :en, precision: nil, format: format_hash)
        expect(output_string).to eql("1e21")
        # very large number
        output_string = formatter.localized_number("10000000000000000000.0", locale: :en, precision: nil, format: format_hash2)
        expect(output_string).to eql("1,0e19")
        # very small number
        output_string = formatter.localized_number("0.0000000000000000001", locale: :en, precision: nil, format: format_hash2)
        expect(output_string).to eql("1,0e-19")
      end

      it "matches notation scientific with nil significant, digit_count and precision from plurimath/268#issuecomment-2228479160" do
        format_hash = {
          fraction_group_digits: 4,
          notation: :scientific,
          fraction_group: "y",
          significant: nil,
          group_digits: 3,
          digit_count: 7,
          decimal: ",",
          group: "x",
        }
        output_string = formatter.localized_number('642121496772645156.4515', precision: 7, format: format_hash)
        expect(output_string).to eql("6,4212y15 × 10^17")
      end
    end

    context "testing number_sign with different notations" do
      let(:locale) { :en }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      context "testing number_sign with and notations for positive number" do
        let(:number) { "14236.39239" }

        it "does add number_sign with notation: basic" do
          output_string = formatter.localized_number(number, format: { number_sign: :plus, notation: :basic })
          expect(output_string).to eql("+14,236.39239")
        end

        it "does add number_sign with notation: e" do
          output_string = formatter.localized_number("14236.39239", format: { number_sign: :plus, notation: :e })
          expect(output_string).to eql("+1.423639239e4")
        end

        it "does add number_sign with notation: scientific" do
          output_string = formatter.localized_number("14236.39239", format: { number_sign: :plus, notation: :scientific })
          expect(output_string).to eql("+1.423639239 × 10^4")
        end

        it "does add number_sign with notation: engineering" do
          output_string = formatter.localized_number("14236.39239", format: { number_sign: :plus, notation: :engineering })
          expect(output_string).to eql("+14.236392390 × 10^3")
        end
      end

      context "testing number_sign with notations for negative number" do
        let(:number) { "-14236.39239" }

        it "does not add number_sign with notation: basic" do
          output_string = formatter.localized_number(number, format: { number_sign: :plus, notation: :basic })
          expect(output_string).to eql("-14,236.39239")
        end

        it "does not add number_sign with notation: e" do
          output_string = formatter.localized_number(number, format: { number_sign: :plus, notation: :e })
          expect(output_string).to eql("-1.4236392390e4")
        end

        it "does not add number_sign with notation: scientific" do
          output_string = formatter.localized_number(number, format: { number_sign: :plus, notation: :scientific })
          expect(output_string).to eql("-1.4236392390 × 10^4")
        end

        it "does not add number_sign with notation: engineering" do
          output_string = formatter.localized_number(number, format: { number_sign: :plus, notation: :engineering })
          expect(output_string).to eql("-1.4236392390 × 10^3")
        end
      end

      context "testing digit_count with custom format options from plurimath/plurimath#360" do
        let(:locale) { :en }
        let(:localize_number) { nil }
        let(:localizer_symbols) { {} }
        let(:format_options) do
          {
            decimal: ",",
            group_digits: 3,
            group: "'",
            fraction_group_digits: 3,
            fraction_group: " ",
            digit_count: 6
          }
        end

        it "formats number with trailing zeros" do
          output_string = formatter.localized_number("283.180", format: format_options)
          expect(output_string).to eql("283,180")
        end

        it "formats number with extra trailing zeros" do
          output_string = formatter.localized_number("283.180000000000", format: format_options)
          expect(output_string).to eql("283,180")
        end
      end

      context "testing digit_count with e notation from plurimath/plurimath#360" do
        let(:locale) { :en }
        let(:localize_number) { nil }
        let(:localizer_symbols) { {} }
        let(:format_options) do
          {
            notation: :e,
            e: " ",
            digit_count: 6,
            fraction_group_digits: 3,
            fraction_group: " ",
            decimal: ","
          }
        end

        it "formats number with e notation" do
          output_string = formatter.localized_number("0.000568096", format: format_options)
          expect(output_string).to eql("5,680 96 -4")
        end
      end
    end

    context "testing base conversion arguments" do
      let(:locale) { :en }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      # Use a small group size by default to exercise separators; override in individual tests when needed.
      let(:base_format_defaults) { { group_digits: 2, group: ",", decimal: "." } }

      context "base conversion (integers)" do
        it "formats base 2 with default prefix" do
          output_string = formatter.localized_number("1910", format: base_format_defaults.merge(base: 2, group_digits: 8, group: " "))
          expect(output_string).to eql("0b111 01110110")
        end

        it "formats zero in base 16 with default prefix" do
          output_string = formatter.localized_number("0", format: base_format_defaults.merge(base: 16))
          expect(output_string).to eql("0x0")
        end

        it "keeps the negative sign before the prefix" do
          output_string = formatter.localized_number("-255", format: base_format_defaults.merge(base: 16))
          expect(output_string).to eql("-0xff")
        end
      end

      context "hex_capital option" do
        it "uppercases hex digits (not prefix) when base 16" do
          output_string = formatter.localized_number("48879", format: base_format_defaults.merge(base: 16, hex_capital: true))
          expect(output_string).to eql("0xBE,EF")
        end

        it "does not affect non-hex bases" do
          output_string = formatter.localized_number("10", format: base_format_defaults.merge(base: 2, hex_capital: true))
          expect(output_string).to eql("0b10,10")
        end
      end

      context "base_prefix option" do
        it "allows overriding the default prefix" do
          output_string = formatter.localized_number("255", format: base_format_defaults.merge(base: 16, base_prefix: "16#"))
          expect(output_string).to eql("16#ff")
        end

        it "allows removing the prefix by passing an empty string" do
          output_string = formatter.localized_number("255", format: base_format_defaults.merge(base: 16, base_prefix: ""))
          expect(output_string).to eql("ff")
        end

        it "treats base_prefix: nil as no prefix" do
          output_string = formatter.localized_number("255", format: base_format_defaults.merge(base: 16, base_prefix: nil))
          expect(output_string).to eql("ff")
        end
      end

      context "base_postfix option" do
        it "uses base_postfix instead of prefix when provided" do
          output_string = formatter.localized_number("255", format: base_format_defaults.merge(base: 16, base_postfix: "_16"))
          expect(output_string).to eql("ff_16")
        end

        it "uppercases hex digits even when base_postfix is used" do
          output_string = formatter.localized_number("48879", format: base_format_defaults.merge(base: 16, base_postfix: "_h", hex_capital: true))
          expect(output_string).to eql("BE,EF_h")
        end

        it "base_postfix takes precedence even if base_prefix is also provided" do
          output_string = formatter.localized_number("255", format: base_format_defaults.merge(base: 16, base_prefix: "0x", base_postfix: "h"))
          expect(output_string).to eql("ffh")
        end
      end

      context "non-integer numeric inputs with non-decimal base" do
        it "converts base of the fractional part when base is 2" do
          output_string = formatter.localized_number("10.75", format: base_format_defaults.merge(base: 2))
          expect(output_string).to eql("0b10,10.11")
        end

        it "converts base of the fractional part for negative values as well with custom prefix" do
          output_string = formatter.localized_number("-10.75", format: base_format_defaults.merge(base: 2, base_prefix: " 0B"))
          expect(output_string).to eql("- 0B10,10.11") # space is included in the "base_prefix"
        end
      end

      context "base 10 interactions (sanity)" do
        it "does not add a prefix when base is 10" do
          output_string = formatter.localized_number("255", format: base_format_defaults.merge(base: 10))
          expect(output_string).to eql("2,55")
        end

        it "base_postfix takes precedence even if base_prefix is also provided" do
          output_string = formatter.localized_number("255", format: base_format_defaults.merge(base: 10, base_prefix: "y^", base_postfix: "_x"))
          expect(output_string).to eql("2,55")
        end
      end

      context "base conversion with digit_count" do
        it "applies digit_count with base 10 (total digits including fractional)" do
          output_string = formatter.localized_number("14236.39239", format: base_format_defaults.merge(base: 10, digit_count: 6, group_digits: 3))
          expect(output_string).to eql("14,236.4")
        end

        it "applies digit_count with base 2 and fractional input" do
          output_string = formatter.localized_number("10.75", format: base_format_defaults.merge(base: 2, digit_count: 5, group_digits: 10))
          expect(output_string).to eql("0b1010.110")
        end
      end

      context "base conversion with precision" do
        it "pads fractional digits in base 2 when precision exceeds converted length" do
          output_string = formatter.localized_number("10.75", format: base_format_defaults.merge(base: 2), precision: 4)
          expect(output_string).to eql("0b10,10.1100")
        end

        it "pads fractional part in base 16 when precision exceeds converted length" do
          output_string = formatter.localized_number("0.5", format: base_format_defaults.merge(base: 16, group_digits: 10), precision: 6)
          expect(output_string).to eql("0x0.800000")
        end
      end

      context "base conversion with fraction_group and fraction_group_digits" do
        it "groups fractional digits in base 2 with fraction_group options" do
          output_string = formatter.localized_number("10.75", format: base_format_defaults.merge(
            base: 2,
            fraction_group_digits: 1,
            fraction_group: " ",
            group_digits: 10
          ))
          expect(output_string).to eql("0b1010.1 1")
        end

        it "does not group (and does not loop) when fraction_group_digits is 0" do
          output_string = formatter.localized_number("10.75", format: base_format_defaults.merge(
            base: 2,
            fraction_group_digits: 0,
            fraction_group: " ",
            group_digits: 10
          ))
          expect(output_string).to eql("0b1010.11")
        end
      end

      context "base conversion with significant digits" do
        it "applies significant to base 10 output" do
          output_string = formatter.localized_number("1234.56", format: base_format_defaults.merge(base: 10, significant: 4, group_digits: 3))
          expect(output_string).to eql("1,235")
        end

        it "applies significant with base 10 and engineering-style rounding" do
          output_string = formatter.localized_number("1999", format: base_format_defaults.merge(base: 10, significant: 2, group_digits: 3))
          expect(output_string).to eql("2,000")
        end
      end

      context "base conversion with notation :basic" do
        it "applies base conversion when notation is explicitly :basic" do
          output_string = formatter.localized_number("255", format: base_format_defaults.merge(base: 16, notation: :basic))
          expect(output_string).to eql("0xff")
        end
      end

      context "invalid base configuration" do
        it "raises an error for unsupported bases" do
          expect do
            formatter.localized_number("10", format: base_format_defaults.merge(base: 3))
          end.to raise_error(
            Plurimath::Math::InvalidFormatterBaseError,
            /Unsupported base: 3\. Supported bases are 2, 8, 10, 16\./
          )
        end
      end
    end
  end
end
