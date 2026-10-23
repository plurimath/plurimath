require "spec_helper"
require_relative "../support/shared_facade_examples"

RSpec.describe Plurimath::NumberFormatter do
  subject(:formatter) do
    described_class.new(locale, localize_number: localize_number,
                                localizer_symbols: localizer_symbols)
  end

  describe ".initialize" do
    context "class variables" do
      let(:locale) { :de }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it "matches class to be correct" do
        expect(formatter).to be_a(described_class)
      end

      it "matches instance variables values" do
        expect(formatter.locale).to be(:de)
        expect(formatter.localize_number).to be_nil
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

      it_behaves_like "shared facade expectation", "facade-number-formatter-34"

      it_behaves_like "shared facade expectation", "facade-number-formatter-39"

      it_behaves_like "shared facade expectation", "facade-number-formatter-44"

      it_behaves_like "shared facade expectation", "facade-number-formatter-52"

      it_behaves_like "shared facade expectation", "facade-number-formatter-66"

      it_behaves_like "shared facade expectation", "facade-number-formatter-81"

      it_behaves_like "shared facade expectation", "facade-number-formatter-94"

      it_behaves_like "shared facade expectation", "facade-number-formatter-101"

      it_behaves_like "shared facade expectation", "facade-number-formatter-108"

      it_behaves_like "shared facade expectation", "facade-number-formatter-115"

      it_behaves_like "shared facade expectation", "facade-number-formatter-122"

      it_behaves_like "shared facade expectation", "facade-number-formatter-128"

      it_behaves_like "shared facade expectation", "facade-number-formatter-134"

      it_behaves_like "shared facade expectation", "facade-number-formatter-140"

      it_behaves_like "shared facade expectation", "facade-number-formatter-146"

      it_behaves_like "shared facade expectation", "facade-number-formatter-152"
    end

    context "testing digit grouping and decimal symbol" do
      let(:locale) { :en }
      let(:number) { "14236.39239" }
      let(:localize_number) { "#,##0.### #" }
      let(:localizer_symbols) { {} }

      it_behaves_like "shared facade expectation", "facade-number-formatter-164"
    end

    context "testing fraction digit group and decimal symbol" do
      let(:locale) { :en }
      let(:number) { "14236.39239" }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it_behaves_like "shared facade expectation", "facade-number-formatter-178"
    end

    context "testing digit counts" do
      let(:locale) { :en }
      let(:number) { "14236.39239" }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it_behaves_like "shared facade expectation", "facade-number-formatter-193"

      it_behaves_like "shared facade expectation", "facade-number-formatter-199"

      it_behaves_like "shared facade expectation", "facade-number-formatter-205"
    end

    context "testing precision with es locale" do
      let(:locale) { :en }
      let(:number) { "14236.39239" }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it_behaves_like "shared facade expectation", "facade-number-formatter-222"
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

      it_behaves_like "shared facade expectation", "facade-number-formatter-239"
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

      it_behaves_like "shared facade expectation", "facade-number-formatter-277"
    end

    context "testing examples with de locale and significant option" do
      # :de locale default values used
      # group => "."
      # decimal => ","
      # group_digits => 3
      let(:locale) { :de }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it_behaves_like "shared facade expectation", "facade-number-formatter-314"

      it_behaves_like "shared facade expectation", "facade-number-formatter-321"

      it_behaves_like "shared facade expectation", "facade-number-formatter-328"

      it_behaves_like "shared facade expectation", "facade-number-formatter-335"

      it_behaves_like "shared facade expectation", "facade-number-formatter-342"

      it_behaves_like "shared facade expectation", "facade-number-formatter-349"

      it_behaves_like "shared facade expectation", "facade-number-formatter-356"
    end

    context "testing with de locale PR plurimath#268 for locale configuration" do
      # :de locale default values used
      # group => "."
      # decimal => ","
      # group_digits => 3
      let(:locale) { :de }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      it_behaves_like "shared facade expectation", "facade-number-formatter-373"

      it_behaves_like "shared facade expectation", "facade-number-formatter-387"

      it_behaves_like "shared facade expectation", "facade-number-formatter-395"

      it_behaves_like "shared facade expectation", "facade-number-formatter-403"

      it_behaves_like "shared facade expectation", "facade-number-formatter-411"

      it_behaves_like "shared facade expectation", "facade-number-formatter-429"
    end

    context "testing number_sign with different notations" do
      let(:locale) { :en }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      context "testing number_sign with and notations for positive number" do
        let(:number) { "14236.39239" }

        it_behaves_like "shared facade expectation", "facade-number-formatter-454"

        it_behaves_like "shared facade expectation", "facade-number-formatter-462"

        it_behaves_like "shared facade expectation", "facade-number-formatter-470"

        it_behaves_like "shared facade expectation", "facade-number-formatter-478"
      end

      context "testing number_sign with notations for negative number" do
        let(:number) { "-14236.39239" }

        it_behaves_like "shared facade expectation", "facade-number-formatter-490"

        it_behaves_like "shared facade expectation", "facade-number-formatter-498"

        it_behaves_like "shared facade expectation", "facade-number-formatter-506"

        it_behaves_like "shared facade expectation", "facade-number-formatter-514"
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
            digit_count: 6,
          }
        end

        it_behaves_like "shared facade expectation", "facade-number-formatter-538"

        it_behaves_like "shared facade expectation", "facade-number-formatter-544"
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
            decimal: ",",
          }
        end

        it_behaves_like "shared facade expectation", "facade-number-formatter-566"
      end
    end

    context "testing base conversion arguments" do
      let(:locale) { :en }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      # Use a small group size by default to exercise separators; override in individual tests when needed.
      let(:base_format_defaults) do
        { group_digits: 2, group: ",", decimal: "." }
      end

      context "base conversion (integers)" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-585"

        it_behaves_like "shared facade expectation", "facade-number-formatter-593"

        it_behaves_like "shared facade expectation", "facade-number-formatter-599"
      end

      context "hex_capital option" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-607"

        it_behaves_like "shared facade expectation", "facade-number-formatter-615"

        it_behaves_like "shared facade expectation", "facade-number-formatter-629"

        it_behaves_like "shared facade expectation", "facade-number-formatter-639"

        it_behaves_like "shared facade expectation", "facade-number-formatter-651"

        it_behaves_like "shared facade expectation", "facade-number-formatter-665"

        it_behaves_like "shared facade expectation", "facade-number-formatter-673"

        it_behaves_like "shared facade expectation", "facade-number-formatter-688"

        it_behaves_like "shared facade expectation", "facade-number-formatter-700"

        it_behaves_like "shared facade expectation", "facade-number-formatter-715"

        it_behaves_like "shared facade expectation", "facade-number-formatter-730"
      end

      context "base_prefix option" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-743"

        it_behaves_like "shared facade expectation", "facade-number-formatter-751"

        it_behaves_like "shared facade expectation", "facade-number-formatter-759"
      end

      context "base_postfix option" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-769"

        it_behaves_like "shared facade expectation", "facade-number-formatter-777"

        it_behaves_like "shared facade expectation", "facade-number-formatter-785"

        it_behaves_like "shared facade expectation", "facade-number-formatter-793"

        it_behaves_like "shared facade expectation", "facade-number-formatter-800"
      end

      context "non-integer numeric inputs with non-decimal base" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-809"

        it_behaves_like "shared facade expectation", "facade-number-formatter-815"
      end

      context "base 10 interactions (sanity)" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-825"

        it_behaves_like "shared facade expectation", "facade-number-formatter-831"
      end

      context "base conversion with digit_count" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-840"

        it_behaves_like "shared facade expectation", "facade-number-formatter-848"

        it_behaves_like "shared facade expectation", "facade-number-formatter-856"

        it_behaves_like "shared facade expectation", "facade-number-formatter-864"

        it_behaves_like "shared facade expectation", "facade-number-formatter-870"

        it_behaves_like "shared facade expectation", "facade-number-formatter-882"

        it_behaves_like "shared facade expectation", "facade-number-formatter-894"

        it_behaves_like "shared facade expectation", "facade-number-formatter-905"

        it_behaves_like "shared facade expectation", "facade-number-formatter-916"

        it_behaves_like "shared facade expectation", "facade-number-formatter-927"

        it_behaves_like "shared facade expectation", "facade-number-formatter-942"
      end

      context "integer padding" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-959"

        it_behaves_like "shared facade expectation", "facade-number-formatter-972"

        it_behaves_like "shared facade expectation", "facade-number-formatter-985"

        it_behaves_like "shared facade expectation", "facade-number-formatter-997"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1010"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1023"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1035"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1048"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1061"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1075"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1090"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1107"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1122"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1139"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1157"
      end

      context "base conversion digit_count rounding edge cases" do
        # These specs intentionally use argument combinations that force
        # digit_count-based rounding of non-decimal fractional parts in
        # bases 2, 8, and 16. They are meant to exercise the internal
        # Fraction#round_base_string edge paths.

        context "base 16 with small digit_count and long fractional part" do
          it_behaves_like "shared facade expectation", "facade-number-formatter-1181"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1196"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1213"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1231"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1246"
        end

        context "base 16 with digit_count and significant digits combined" do
          it_behaves_like "shared facade expectation", "facade-number-formatter-1263"
        end

        context "base 8 with dense fractional digits and digit_count" do
          it_behaves_like "shared facade expectation", "facade-number-formatter-1281"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1296"
        end

        context "base 2 with dense fractional bits and digit_count" do
          it_behaves_like "shared facade expectation", "facade-number-formatter-1313"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1328"
        end

        context "digit_count rounding with fraction_group and fraction_group_digits" do
          it_behaves_like "shared facade expectation", "facade-number-formatter-1345"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1360"
        end

        context "digit_count rounding with number_sign and non-decimal base" do
          it_behaves_like "shared facade expectation", "facade-number-formatter-1377"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1393"
        end

        context "fractional rounding to zero" do
          it_behaves_like "shared facade expectation", "facade-number-formatter-1411"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1426"
        end
      end

      context "base conversion option edge cases" do
        context "other supported bases (2, 8, 16)" do
          it_behaves_like "shared facade expectation", "facade-number-formatter-1445"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1451"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1457"
        end

        context "hex_capital with negative numbers" do
          it_behaves_like "shared facade expectation", "facade-number-formatter-1465"
        end

        context "base_prefix for negative numbers and nil/empty variants" do
          it_behaves_like "shared facade expectation", "facade-number-formatter-1475"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1483"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1491"
        end

        context "base_postfix with negative numbers and optional base_prefix" do
          it_behaves_like "shared facade expectation", "facade-number-formatter-1501"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1509"
        end

        context "number_sign with non-decimal base" do
          it_behaves_like "shared facade expectation", "facade-number-formatter-1518"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1526"
        end

        context "significant digits with non-default base" do
          it_behaves_like "shared facade expectation", "facade-number-formatter-1536"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1544"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1552"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1563"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1575"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1587"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1599"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1611"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1623"

          it_behaves_like "shared facade expectation", "facade-number-formatter-1635"
        end
      end

      context "base conversion with precision" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-1650"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1656"
      end

      context "base conversion with fraction_group and fraction_group_digits" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-1664"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1674"
      end

      context "base conversion with significant digits" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-1686"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1694"
      end

      context "base conversion with significant digits and inferred precision" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-1704"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1716"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1728"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1747"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1759"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1771"
      end

      context "base conversion with notation :basic" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-1785"
      end

      context "zero handling across different bases" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-1795"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1801"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1807"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1813"
      end

      context "large number handling" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-1823"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1831"
      end

      context "invalid base configuration" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-1841"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1851"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1861"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1871"
      end
    end

    context "testing option and input hardening" do
      let(:locale) { :en }
      let(:localize_number) { nil }
      let(:localizer_symbols) { {} }

      context "with invalid number input" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-1888"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1898"
      end

      context "with grouping edge values" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-1908"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1914"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1920"
      end

      context "with explicit nil separators" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-1932"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1939"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1946"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1952"
      end

      context "with base conversion precision" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-1963"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1974"

        it_behaves_like "shared facade expectation", "facade-number-formatter-1980"
      end

      context "with digit_count budgets on zero-heavy fractions" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-1991"
      end

      context "with notation coefficients" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-2000"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2006"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2012"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2018"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2031"
      end

      context "with malformed call arguments" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-2046"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2051"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2060"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2065"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2072"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2088"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2100"
      end

      context "with enumerated option type rejection" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-2111"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2121"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2130"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2139"
      end

      context "with post-construction writers" do
        it "validates localizer_symbols and localize_number when used" do
          [5, "x", []].each do |value|
            formatter = described_class.new(:en)
            formatter.localizer_symbols = value
            expect { formatter.localized_number("1234") }
              .to raise_error(Plurimath::ConfigurationError,
                              /formatter option :localizer_symbols/),
                  "expected localizer_symbols= #{value.inspect} to raise"
          end
          [5, true, []].each do |value|
            formatter = described_class.new(:en)
            formatter.localize_number = value
            expect { formatter.localized_number("1234") }
              .to raise_error(Plurimath::ConfigurationError,
                              /formatter option :localize_number/),
                  "expected localize_number= #{value.inspect} to raise"
          end
        end
      end

      context "with zero-source engineering notation" do
        it_behaves_like "shared facade expectation", "facade-number-formatter-2178"

        it_behaves_like "shared facade expectation", "facade-number-formatter-2189"
      end
    end

    context "Standard formatter argument validation" do
      it_behaves_like "shared facade expectation", "facade-number-formatter-2199"

      it_behaves_like "shared facade expectation", "facade-number-formatter-2208"
    end
  end

  describe ".formatted_number" do
    let(:locale) { :en }
    let(:localize_number) { nil }
    let(:localizer_symbols) { {} }

    it_behaves_like "shared facade expectation", "facade-number-formatter-2220"

    it_behaves_like "shared facade expectation", "facade-number-formatter-2227"

    it_behaves_like "shared facade expectation", "facade-number-formatter-2239"

    it_behaves_like "shared facade expectation", "facade-number-formatter-2247"

    it_behaves_like "shared facade expectation", "facade-number-formatter-2256"
  end
end
