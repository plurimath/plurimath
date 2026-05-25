require "spec_helper"

RSpec.describe Plurimath::Math do
  describe ".initialize" do
    subject(:formula) { described_class.parse(input, type) }

    context "when persistent configuration sets a locale" do
      let(:input) { "1,2" }
      let(:type) { "asciimath" }

      around do |example|
        previous_locale = Plurimath.configuration.locale
        Plurimath.configure do |config|
          config.locale = :fr
        end
        example.run
      ensure
        Plurimath.configuration.locale = previous_locale
      end

      it "uses the configured locale while parsing through the facade" do
        expected_value = Plurimath::Math::Formula.new([
                                                        Plurimath::Math::Number.new("1,2"),
                                                      ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains incorrect type with parseable input of asciimath" do
      let(:input) { "sin(d)" }
      let(:type) { "wrong_type" }

      it "raises error on wrong type" do
        expect { formula }.to raise_error(Plurimath::Math::InvalidTypeError)
      end
    end

    context "contains correct type with incomplete input of latex" do
      let(:input) { '{\sin{d}' }
      let(:type) { "latex" }

      it "raises error on wrong text input" do
        message = "Failed to parse the following formula with type `#{type}`"
        expect { formula }.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end

    context "contains correct input string and custom invalid formula" do
      it "raises error on wrong text input" do
        formula = Plurimath::Math::Formula.new([
                                                 Plurimath::Math::Function::Sin.new("d"),
                                               ])
        expect { formula.to_html }.to raise_error(Plurimath::Math::ParseError)
        expect { formula.to_omml }.to raise_error(Plurimath::Math::ParseError)
        expect { formula.to_latex }.to raise_error(Plurimath::Math::ParseError)
        expect { formula.to_mathml }.to raise_error(Plurimath::Math::ParseError)
        expect { formula.to_asciimath }.to raise_error(Plurimath::Math::ParseError)
        expect { formula.to_unicodemath }.to raise_error(Plurimath::Math::ParseError)
      end
    end

    context "preserves specialized error types from lower layers" do
      let(:input) { "mm^(b)" }
      let(:type) { "unitsml" }

      it "raises error with specialized unitsml error message" do
        message = "The use of a variable as an exponent is not valid."
        expect { formula }.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end
  end
end
