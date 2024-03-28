require "spec_helper"
require "yaml"
require "plurimath/fixtures/formula_modules/unicode_math_transform_values"

# This file contains examples from unicodemath-tests repo
# https://github.com/plurimath/unicodemath-tests
RSpec.describe Plurimath::UnicodeMath::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    SKIPABLE_EXAMPLES = [33, 179, 210, 211, 598, 599, 600, 601].freeze
    unicodemath_tests_file = File.read("submodules/unicodemath-tests/unicodemath_tests.yaml")
    unicodemath_tests = YAML.safe_load(unicodemath_tests_file, permitted_classes: [Time])["tests"]
    unicodemath_tests.each.with_index(1) do |unicode_hash, index|
      constant = :"EXAMPLE_#{index}"
      break unless UnicodeMathTransformValues.constants.any?(constant)

      context "contains unicdemath-tests example ##{index}" do
        let(:string) { remove_prefix(unicode_hash["unicodemath"].to_s) }

        it "matches formula structure of UnicodeMath" do
          if SKIPABLE_EXAMPLES.include?(index)
            expect{formula}.to raise_error(Parslet::ParseFailed, Regexp.compile("Expected one of \\["))
          else
            expect(formula).to eq(UnicodeMathTransformValues.const_get(constant))
          end
        end
      end
    end
  end
end

def post_processing(tree)
  if tree && @splitted
    {
      labeled_tr_value: tree,
      labeled_tr_id: @splitted
    }
  else
    tree
  end
end
