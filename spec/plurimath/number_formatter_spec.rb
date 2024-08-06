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
        output_string = formatter.localized_number(number, precision: 5, format: { digit_count: 6, notation: :scientific, group_digits: 3 })
        expect(output_string).to eql("1,00000 × 10^-3")
        output_string = formatter.localized_number(number, format: { significant: 3, group_digits: 3 })
        expect(output_string).to eql("0,00100")
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
  end
end
