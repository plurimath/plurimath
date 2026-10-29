require "spec_helper"
require_relative "../../../support/shared_unicode_examples"

# This file contains examples from unicodemath-tests repo
# https://github.com/plurimath/unicodemath-tests
RSpec.describe Plurimath::UnicodeMath::Parse do
  describe ".parse" do
    subject(:formula) do
      post_processing(
        described_class.new.parse(unicode_encode_entities(string.to_s)),
      )
    end

    it_behaves_like "shared Unicode external expectations", "raw"
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
