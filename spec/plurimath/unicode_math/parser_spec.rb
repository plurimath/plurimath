require "spec_helper"
require "plurimath/fixtures/formula_modules/unicode_math_transform_values"

RSpec.describe Plurimath::UnicodeMath::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

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
  end
end
