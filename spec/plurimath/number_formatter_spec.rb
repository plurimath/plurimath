require "spec_helper"

RSpec.describe Plurimath::NumberFormatter do

  describe ".initialize" do
    subject(:formatter) { described_class.new(locale, localize_number: localize_number, localizer_symbols: localizer_symbols) }

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
    subject(:formatter) { described_class.new(locale, localize_number: localize_number, localizer_symbols: localizer_symbols) }

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
        format = { decimal: "*", notation: :basic }
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
        format = { fraction_group_digits: 4, fraction_group: ",", decimal: "@" }
        output_string = formatter.localized_number(number, locale: locale, format: format)
        expect(output_string).to eql("1'42'36@3923,9")
      end
    end

    context "testing digit counts" do
      let(:locale) { :en }
      let(:number) { "14236.39239" }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it "matches locale: kk with minimum digit_count" do
        output_string = formatter.localized_number(number, locale: :kk, format: { digit_count: 6 })
        expect(output_string).to eql("14 236,4")
      end

      it "matches locale: kk with maximum digit_count" do
        output_string = formatter.localized_number(number, locale: :kk, format: { digit_count: 16, fraction_group: " ", fraction_group_digits: 3 })
        expect(output_string).to eql("14 236,392 390 000 00")
      end
    end

    context "testing precision with es locale" do
      let(:locale) { :en }
      let(:number) { "14236.39239" }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it "matches locale: kk with precision" do
        output_string = formatter.localized_number(number, locale: :es, precision: 20, format: { fraction_group: " ", fraction_group_digits: 3 })
        expect(output_string).to eql("14.236,392 390 000 000 000 000 00")
      end
    end

    context "testing plurimath#262 example with de locale" do
      let(:locale) { :de }
      let(:number) { "327428.000878432992" }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it "matches locale: de with precision" do
        output_string = formatter.localized_number(number, format: { digit_count: 18 })
        expect(output_string).to eql("327.428,000878432992")
        output_string = formatter.localized_number(number, format: { digit_count: 19 })
        expect(output_string).to eql("327.428,0008784329920")
        output_string = formatter.localized_number(number, format: { digit_count: 20 })
        expect(output_string).to eql("327.428,00087843299200")
        output_string = formatter.localized_number(number, format: { digit_count: 18, notation: :scientific })
        expect(output_string).to eql("3,27428000878432998 × 10^5")
        output_string = formatter.localized_number(number, format: { digit_count: 19, notation: :scientific })
        expect(output_string).to eql("3,274280008784329980 × 10^5")
        output_string = formatter.localized_number(number, format: { digit_count: 20, notation: :scientific })
        expect(output_string).to eql("3,2742800087843299800 × 10^5")
      end
    end
  end
end
