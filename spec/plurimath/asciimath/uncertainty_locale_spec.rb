# frozen_string_literal: true

require "spec_helper"

# The quoted channel (amath#17) is locale-independent: a quoted
# uncertainty call's "." decimals and "," separators are the string
# literal's, never the locale's; a quoted string that is not a
# well-formed call stays a literal string; and a bareword call reads
# as letters exactly as in standard asciimath, under every locale.
module AsciimathUncertaintyLocale
  QUOTED_CALLS = [
    '"ustd(1,5)"',
    '"ustd(1.230, 0.004)"',
    '"ustd(1.230(4))"',
    '"uexp(10.0, 0.3, 2)"',
    '"ucov(1.024, 0.983, 1.088, 0.95, shortest)"',
  ].freeze

  QUOTED_NON_CALLS = [
    '"ustd(1, 5, 6)"',
    '"uexp(10,0, 0,3, 2)"',
    '"ustd(1,230, 0,004)"',
    '"uexp(x)"',
    '"plain text"',
  ].freeze

  BAREWORDS = [
    "ustd(1,5)",
    "uexp(10,0, 0,3, 2)",
    "x + ustd(1,5)",
  ].freeze

  # What non-uncertainty input read back as before this check, per locale.
  PLAIN = {
    fr: {
      "1,5" => "1,5", "f(1,5)" => "f (1,5)", "[1,5]" => "[1,5]",
      "1,5,6" => "1,5 , 6", "1,5 + x" => "1,5 + x",
    },
    ar: {
      "1,5" => "1 , 5", "f(1,5)" => "f (1 , 5)", "[1,5]" => "[1 , 5]",
      "1,5,6" => "1 , 5 , 6", "1,5 + x" => "1 , 5 + x",
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

  { fr: ",", ar: "٫", en: "." }.each do |locale, decimal|
    context "with locale #{locale} (decimal #{decimal})" do
      AsciimathUncertaintyLocale::QUOTED_CALLS.each do |input|
        it "reads the quoted call #{input} as an uncertainty, locale-independently" do
          formula = read(input, locale: locale)
          expect(formula.value.first)
            .to be_a(Plurimath::Math::Function::Uncertainty)
        end
      end

      AsciimathUncertaintyLocale::QUOTED_CALLS.each do |input|
        it "roundtrips the quoted call #{input} canonically" do
          canonical = input.gsub(/,\s*/, ", ")
          expect(read(input, locale: locale).to_asciimath).to eq(canonical)
        end
      end

      AsciimathUncertaintyLocale::QUOTED_NON_CALLS.each do |input|
        it "keeps the quoted non-call #{input} a literal string" do
          expect(read(input, locale: locale).to_asciimath).to eq(input)
          expect(read(input, locale: locale).value.first)
            .not_to be_a(Plurimath::Math::Function::Uncertainty)
        end
      end

      AsciimathUncertaintyLocale::BAREWORDS.each do |input|
        it "reads the bareword #{input} as letters, without an uncertainty" do
          formula = read(input, locale: locale)
          expect(formula.value.grep(Plurimath::Math::Function::Uncertainty))
            .to be_empty
        end
      end

      AsciimathUncertaintyLocale::PLAIN.fetch(locale, {}).each do |input, output|
        it "reads non-uncertainty input #{input} as before" do
          expect(read(input, locale: locale).to_asciimath).to eq(output)
        end
      end
    end
  end

  it "never raises AmbiguousDecimalError from the asciimath parser" do
    expect { read('"ustd(1,5)"', locale: "fr") }
      .not_to raise_error
  end
end
