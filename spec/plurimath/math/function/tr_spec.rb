require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Tr do
  describe ".initialize" do
    subject(:tr) { described_class.new([first]) }

    context "initialize Tr object" do
      let(:first) { "70" }

      it "returns instance of Tr" do
        expect(tr).to be_a(described_class)
      end

      it "initialize Tr object" do
        expect(tr.parameter_one).to eql(["70"])
      end
    end
  end

  describe ".to_asciimath" do
    subject(:tr) { described_class.new([first]).to_asciimath(options: {}) }

    it_behaves_like "shared renderer fixture", "function-tr-23-1"
    it_behaves_like "shared renderer fixture", "function-tr-23-2"
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new([first_value]).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-tr-41-1"

    it_behaves_like "shared renderer fixture", "function-tr-49-1"

    it_behaves_like "shared renderer fixture", "function-tr-57-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new([first_value])
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-tr-82-1"

    it_behaves_like "shared renderer fixture", "function-tr-101-1"

    it_behaves_like "shared renderer fixture", "function-tr-120-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new([first_value]).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-tr-156-1"

    it_behaves_like "shared renderer fixture", "function-tr-168-1"

    it_behaves_like "shared renderer fixture", "function-tr-181-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new([first_value]).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-tr-204-1"

    it_behaves_like "shared renderer fixture", "function-tr-212-1"

    it_behaves_like "shared renderer fixture", "function-tr-220-1"
  end
end
