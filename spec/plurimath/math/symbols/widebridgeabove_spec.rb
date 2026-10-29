require "spec_helper"
require_relative "../../../support/shared_symbol_examples"

RSpec.describe Plurimath::Math::Symbols::Widebridgeabove do
  describe ".initialize" do
    it "returns instance of Symbol Widebridgeabove" do
      klass = described_class.new
      expect(klass).to be_a(described_class)
    end
  end

  it_behaves_like "shared symbol renderings", "widebridgeabove"
end
