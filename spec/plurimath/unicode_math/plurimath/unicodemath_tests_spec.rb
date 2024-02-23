require "spec_helper"
require "yaml"
require "plurimath/fixtures/formula_modules/unicode_math_parse_values"

# This file contains examples from unicodemath-tests repo
# https://github.com/plurimath/unicodemath-tests
RSpec.describe Plurimath::UnicodeMath::Parse do
  describe ".parse" do
    subject(:formula) do
      post_processing(
        described_class.new.parse(
          unicode_encode_entities(string.to_s, delete_prefix_suffix: !delete_prefix_suffix, delete_suffix_only: delete_suffix_only)
        )
      )
    end

    SKIPABLE_EXAMPLES = [33, 179, 210, 211, 598, 599, 600, 601].freeze

    unicodemath_tests_file = File.read("submodules/unicodemath-tests/unicodemath_tests.yaml")
    unicodemath_tests = YAML.safe_load(unicodemath_tests_file, permitted_classes: [Time])["tests"]
    unicodemath_tests.each.with_index(1) do |unicode_hash, index|
      constant = :"EXAMPLE_#{index}"
      break unless UnicodeMathParseValues.constants.any?(constant)

      context "contains unicdemath-tests example ##{index}" do
        let(:string) { unicode_hash["unicodemath"] }
        let(:delete_prefix_suffix) { [359, 373, 445, 627, 633, 651].include?(index) }
        let(:delete_suffix_only) { [359, 373, 445, 627, 633, 651].include?(index) }

        it "matches tree structure of UnicodeMath" do
          if SKIPABLE_EXAMPLES.include?(index)
            expect{formula}.to raise_error(Parslet::ParseFailed, Regexp.compile("Expected one of \\["))
          else
            expect(formula).to eq(UnicodeMathParseValues.const_get(constant))
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
