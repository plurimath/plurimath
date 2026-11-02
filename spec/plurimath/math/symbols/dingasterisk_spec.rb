require "spec_helper"
require_relative "../../../support/shared_symbol_examples"

RSpec.describe Plurimath::Math::Symbols::Dingasterisk do
  describe ".initialize" do
    it "returns instance of Symbol Dingasterisk" do
      klass = described_class.new
      expect(klass).to be_a(described_class)
    end
  end

  it_behaves_like "shared symbol renderings", "dingasterisk"
end
