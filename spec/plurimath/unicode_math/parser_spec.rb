require "spec_helper"
require "plurimath/fixtures/formula_modules/unicode_math_transform_values"

RSpec.describe Plurimath::UnicodeMath::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    context "when parsing decimal markers" do
      context "when contains decimal full stop" do
        let(:string) { "1.2" }

        it "matches formula structure of UnicodeMath" do
          expected_value = Plurimath::Math::Formula.new([
                                                          Plurimath::Math::Number.new("1.2"),
                                                        ])
          expect(formula).to eq(expected_value)
        end
      end

      context "when contains decimal comma" do
        let(:string) { "1,2" }

        it "matches formula structure of UnicodeMath" do
          expected_value = Plurimath::Math::Formula.new([
                                                          Plurimath::Math::Number.new("1,2"),
                                                        ])
          expect(formula).to eq(expected_value)
        end
      end

      context "when contains leading decimal comma" do
        let(:string) { ",2" }

        it "matches formula structure of UnicodeMath" do
          expected_value = Plurimath::Math::Formula.new([
                                                          Plurimath::Math::Number.new(",2"),
                                                        ])
          expect(formula).to eq(expected_value)
        end
      end

      context "when contains leading decimal full stop" do
        let(:string) { ".2" }

        it "matches formula structure of UnicodeMath" do
          expected_value = Plurimath::Math::Formula.new([
                                                          Plurimath::Math::Number.new(".2"),
                                                        ])
          expect(formula).to eq(expected_value)
        end
      end

      context "when locale uses comma as the decimal separator" do
        around do |example|
          Plurimath.with_configuration do |config|
            config.locale = :fr
            example.run
          end
        end

        context "when contains decimal full stop" do
          let(:string) { "1.2" }

          it "matches formula structure of UnicodeMath" do
            expected_value = Plurimath::Math::Formula.new([
                                                            Plurimath::Math::Number.new("1.2"),
                                                          ])
            expect(formula).to eq(expected_value)
          end
        end
      end

      context "when locale uses Arabic decimal separator" do
        around do |example|
          Plurimath.with_configuration do |config|
            config.locale = :ar
            example.run
          end
        end

        context "when contains localized decimal marker" do
          let(:string) { "1٫2" }

          it "matches formula structure of UnicodeMath" do
            expected_value = Plurimath::Math::Formula.new([
                                                            Plurimath::Math::Number.new("1٫2"),
                                                          ])
            expect(formula).to eq(expected_value)
          end
        end
      end
    end

    context "contains n-ary function with mask value #1 #EXAMPLE_676" do
      let(:string) { "\\amalg13_d\\of d" }

      it "matches formula structure of UnicodeMath" do
        expect(formula).to eq(UnicodeMathTransformValues::EXAMPLE_676)
      end
    end

    context "contains n-ary function with mask value #2 #EXAMPLE_677" do
      let(:string) { "\\amalg13_dd\\of d" }

      it "matches formula structure of UnicodeMath" do
        expect(formula).to eq(UnicodeMathTransformValues::EXAMPLE_677)
      end
    end

    context "contains n-ary function with mask value #3 #EXAMPLE_678" do
      let(:string) { "\\amalg13_dd^d\\of d" }

      it "matches formula structure of UnicodeMath" do
        expect(formula).to eq(UnicodeMathTransformValues::EXAMPLE_678)
      end
    end

    context "contains n-ary function with compatibility wrapper values #EXAMPLE_679" do
      let(:string) do
        '\sum_"P{updownharpoonleftleft}"^"P{updownharpoonleftleft}" d'
      end

      it "matches formula structure of UnicodeMath" do
        expect(formula).to eq(UnicodeMathTransformValues::EXAMPLE_679)
      end
    end

    # Regression: "a" + combining circumflex + prime (U+0061 U+0302 U+2032)
    # reaches unicode_accents' prime branch. Before the fix the raw entity
    # string landed in the Power exponent and to_latex raised; now the prime
    # resolves to a Prime symbol and the conversion succeeds.
    context "with a combining accent followed by a prime" do
      let(:string) { [0x0061, 0x0302, 0x2032].pack("U*") }

      it "resolves the prime so to_latex renders without raising" do
        expect(formula.to_latex).to eq("\\overset{^}{a}^{\\prime}")
      end
    end

    # Multi-prime: updated_primes maps each entity, so the exponent is a
    # Formula of Prime symbols rather than a raw string — guards the
    # Formula-exponent branch the fix introduces.
    context "with a combining accent followed by two primes" do
      let(:string) { [0x0061, 0x0302, 0x2032, 0x2032].pack("U*") }

      it "resolves both primes into the Power exponent" do
        expect(formula.to_latex).to eq("\\overset{^}{a}^{\\prime \\prime}")
      end
    end

    # Regression: "a" + combining tilde (U+0061 U+0303). The combining tilde
    # had no symbols_class mapping and leaked the raw "&#x303;" entity into the
    # accent slot; it now resolves to the Tilde symbol.
    context "with a combining tilde accent" do
      let(:string) { [0x0061, 0x0303].pack("U*") }

      it "resolves the combining tilde to Tilde with no raw entity in to_latex" do
        expect(formula.to_latex).to eq("\\overset{\\tilde}{a}")
      end
    end
  end
end
