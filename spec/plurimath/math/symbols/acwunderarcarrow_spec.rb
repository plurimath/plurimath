require "spec_helper"
require_relative "../../../support/shared_symbol_examples"

RSpec.describe Plurimath::Math::Symbols::Acwunderarcarrow do
  describe ".initialize" do
    it "returns instance of Symbol Acwunderarcarrow" do
      klass = described_class.new
      expect(klass).to be_a(described_class)
    end
  end

  it_behaves_like "shared symbol renderings", "acwunderarcarrow"
end
