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
  end
end
