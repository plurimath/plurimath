require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Latex do
  describe ".initialize" do
    subject(:latex) { described_class.new(string) }

    context "contains simple cos function with numeric value" do
      let(:string) { "\\cos_{45}" }

      it "matches instance of Latex" do
        expect(latex).to be_a(described_class)
      end

      it "matches text from Latex instance" do
        expect(latex.text).to eq('\\cos_{45}')
      end
    end
  end

  describe ".to_formula" do
    subject(:formula) { described_class.new(string).to_formula }

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-23-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-36-1"
  end

  describe ".to_mathml" do
    subject(:formula) { described_class.new(string).to_formula }

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-130-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-150-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-174-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-205-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-223-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-257-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-337-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-371-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-405-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-442-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-465-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-513-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-547-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-697-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-727-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-759-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-810-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-860-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-910-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-933-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-983-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1013-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1033-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1055-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1074-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1095-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1116-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1203-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1298-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1319-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1339-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1368-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1413-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1431-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1462-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1492-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1526-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1562-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1598-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1619-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1656-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1678-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1710-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-1960-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2168-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2252-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2352-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2451-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2478-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2504-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2536-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2561-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2585-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2618-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2653-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2687-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2738-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2760-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2818-1"
  end

  describe ".to_asciimath" do
    subject(:asciimath) { described_class.new(string).to_formula.to_asciimath }

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2843-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2852-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2861-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2870-1"
  end

  describe ".to_html" do
    subject(:html) { described_class.new(string).to_formula.to_html }

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2883-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2892-1"
  end

  describe ".to_omml" do
    subject(:formula) { described_class.new(string).to_formula.to_omml }

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2905-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2927-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-2947-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-3019-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-3053-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-3113-1"

    it_behaves_like "shared renderer fixture", "renderer-latex-latex-3196-1"
  end
end
