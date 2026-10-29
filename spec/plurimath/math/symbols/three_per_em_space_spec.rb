require "spec_helper"
require_relative "../../../support/shared_symbol_examples"

RSpec.describe Plurimath::Math::Symbols::ThreePerEmSpace do
  describe ".initialize" do
    it "returns instance of Symbol ThreePerEmSpace" do
      klass = described_class.new
      expect(klass).to be_a(described_class)
    end
  end

  it_behaves_like "shared symbol renderings", "three_per_em_space"
end
