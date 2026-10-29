# frozen_string_literal: true

require "spec_helper"

# AsciiMath uncertainty arguments use "." as the decimal mark and "," between
# arguments. Under a locale whose decimal mark is not ".", a separator comma
# directly followed by a digit is ambiguous (ustd(1,5) would otherwise be read
# as value 1, uncertainty 5) and raises; everything else reads as before.
module AsciimathUncertaintyLocale
  AMBIGUOUS = [
    "ustd(1,5)",
    "uexp(10,0, 0,3, 2)",
    "ustd(1,230, 0,004)",
    "ustd(1.230,0.004)",
    "x + ustd(1,5)",
  ].freeze

  UNAMBIGUOUS = [
    "ustd(1.230, 0.004)",
    "ustd(1.230(4))",
    "uexp(10.0, 0.3, 2)",
    "ucov(1.024, 0.983, 1.088, 0.95, shortest)",
  ].freeze

  # What non-uncertainty input read back as before this check, per locale.
  PLAIN = {
    fr: {
      "1,5" => "1,5", "f(1,5)" => "f (1,5)", "[1,5]" => "[1,5]",
      "1,5,6" => "1,5 , 6", "1,5 + x" => "1,5 + x",
      "\"ustd(1,5)\"" => "\"ustd(1,5)\""
    },
    ar: {
      "1,5" => "1 , 5", "f(1,5)" => "f (1 , 5)", "[1,5]" => "[1 , 5]",
      "1,5,6" => "1 , 5 , 6", "1,5 + x" => "1 , 5 + x",
      "\"ustd(1,5)\"" => "\"ustd(1,5)\""
    },
  }.freeze
end

RSpec.describe Plurimath::Asciimath::Parser do
  def read(input, **options)
    Plurimath::Math.parse(input, :asciimath, **options)
  end

  def parse_under(locale, input)
    Plurimath.with_configuration do |config|
      config.locale = locale
      Plurimath::Asciimath.new(input).to_formula
    end
  end

  { fr: ",", ar: "٫" }.each do |locale, decimal|
    context "with locale #{locale} (decimal #{decimal})" do
      AsciimathUncertaintyLocale::AMBIGUOUS.each do |input|
        it "raises AmbiguousDecimalError for #{input}" do
          call = input.delete_prefix("x + ")
          expect { parse_under(locale, input) }
            .to raise_error(
              Plurimath::Math::AmbiguousDecimalError,
              "[plurimath] uncertainty forms use '.' " \
              "as the decimal mark; the comma before a digit in #{call} is " \
              "ambiguous with decimal '#{decimal}' (locale #{locale}), " \
              "write the value with '.' and separate arguments with ', '",
            )
        end

        it "keeps the message through Math.parse for #{input}" do
          expect { read(input, locale: locale) }
            .to raise_error(Plurimath::Math::AmbiguousDecimalError, /ambiguous with decimal/)
        end
      end

      AsciimathUncertaintyLocale::UNAMBIGUOUS.each do |input|
        it "reads #{input} as an uncertainty" do
          formula = read(input, locale: locale)
          expect(formula.value.first)
            .to be_a(Plurimath::Math::Function::Uncertainty)
          expect(formula.to_asciimath).to eq(input)
        end
      end

      AsciimathUncertaintyLocale::PLAIN.fetch(locale).each do |input, output|
        it "reads non-uncertainty input #{input} as before" do
          expect(read(input, locale: locale).to_asciimath).to eq(output)
        end
      end
    end
  end

  [nil, :en].each do |locale|
    it "reads ustd(1,5) as value 1, uncertainty 5 with locale #{locale.inspect}" do
      options = locale ? { locale: locale } : {}
      expect(read("ustd(1,5)", **options).to_asciimath).to eq("ustd(1, 5)")
    end
  end
end
