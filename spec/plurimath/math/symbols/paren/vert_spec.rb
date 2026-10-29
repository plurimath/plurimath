require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Symbols::Paren::Vert do
  describe ".initialize" do
    it "returns instance of paren symbol Vert" do
      klass = described_class.new
      expect(klass).to be_a(described_class)
    end
  end

  describe ".open?, .close?, .opening" do
    subject(:klass) { described_class.new }

    context "matches if open paren for the Symbol Plurimath::Math::Symbols::Paren::Vert" do
      it "matches if paren is open" do
        expect(klass.open?).to be(true)
      end

      it "checks if paren is closing paren" do
        expect(klass.close?).to be(true)
      end

      it "checks if paren is open" do
        expect(klass.closing).to eq(described_class)
      end
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-paren-vert-vert-32-1"
    it_behaves_like "shared renderer fixture", "renderer-math-symbols-paren-vert-vert-32-2"
    it_behaves_like "shared renderer fixture", "renderer-math-symbols-paren-vert-vert-32-3"
    it_behaves_like "shared renderer fixture", "renderer-math-symbols-paren-vert-vert-32-4"
    it_behaves_like "shared renderer fixture", "renderer-math-symbols-paren-vert-vert-32-5"
    it_behaves_like "shared renderer fixture", "renderer-math-symbols-paren-vert-vert-32-6"
  end
end
