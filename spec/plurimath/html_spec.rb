require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Html do
  describe ".initialize" do
    subject(:formula) { described_class.new(string.gsub(/\s/, "")) }

    context "matches class name and text" do
      let(:string) { "<h4> 1 + 3 </h4>" }

      it "matches the class object" do
        expect(formula).to be_a(described_class)
      end

      it "contains passed html string" do
        expect(formula.text).to eq(string.gsub(/\s/, ""))
      end
    end
  end

  describe ".to_formula" do
    subject(:formula) { described_class.new(string.gsub(/\s/, "")).to_formula }

    it_behaves_like "shared renderer fixture", "renderer-html-html-23-1"
  end
end
