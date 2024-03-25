require "spec_helper"
require "plurimath/fixtures/formula_modules/unicode_math_string_values"
require "plurimath/fixtures/formula_modules/unicode_math_transform_values"

RSpec.describe Plurimath::Math::Formula do
  describe ".to_unicodemath" do
    subject(:formula) { UnicodeMathTransformValues.const_get(constant) }
    let(:string) { formula.to_unicodemath }

    transform_consts = UnicodeMathTransformValues.constants.sort_by do |constant|
      constant.to_s.match(/EXAMPLE_(\d+)/)[1].to_i
    end

    transform_consts.each.with_index(1) do |constant, index|
      break unless UnicodeMathTransformValues.const_get(constant)

      context "converts formula to Unicodemath string ##{index}" do
        let(:constant) { constant }

        it "returns boolean for UnicodeMath string ##{index}" do
          expect(string).to eq(UnicodeMathStringValues.const_get(constant))
        end
      end
    end
  end
end
