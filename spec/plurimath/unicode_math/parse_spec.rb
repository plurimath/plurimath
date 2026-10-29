require "spec_helper"
require_relative "../../support/shared_grammar_examples"

RSpec.describe Plurimath::UnicodeMath::Parse do
  it_behaves_like "shared grammar expectations", %w[
    grammar-unicode-098
  ]
end
