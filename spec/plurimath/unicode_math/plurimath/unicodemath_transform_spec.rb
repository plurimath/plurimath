require "spec_helper"
require_relative "../../../support/shared_unicode_examples"

# This file contains examples from unicodemath-tests repo
# https://github.com/plurimath/unicodemath-tests
RSpec.describe Plurimath::UnicodeMath::Parser do
  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    it_behaves_like "shared Unicode external expectations", "model"
  end
end

def post_processing(tree)
  if tree && @splitted
    {
      labeled_tr_value: tree,
      labeled_tr_id: @splitted,
    }
  else
    tree
  end
end
