require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Text do
  describe ".initialize" do
    it "returns instance of Text" do
      text = described_class.new("Hello")
      expect(text).to be_a(described_class)
    end

    it "initializes Text object" do
      text = described_class.new("Hello")
      expect(text.parameter_one).to eql("Hello")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value).to_asciimath }

    it_behaves_like "shared renderer fixture", "function-text-19-1"

    it_behaves_like "shared renderer fixture", "function-text-27-1"

    it_behaves_like "shared renderer fixture", "function-text-35-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-text-53-1"

    it_behaves_like "shared renderer fixture", "function-text-61-1"

    it_behaves_like "shared renderer fixture", "function-text-69-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex }

    it_behaves_like "shared renderer fixture", "function-text-81-1"

    it_behaves_like "shared renderer fixture", "function-text-89-1"

    it_behaves_like "shared renderer fixture", "function-text-97-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html }

    it_behaves_like "shared renderer fixture", "function-text-109-1"

    it_behaves_like "shared renderer fixture", "function-text-117-1"

    it_behaves_like "shared renderer fixture", "function-text-125-1"
  end

  describe ".validate_function_formula" do
    subject(:formula) do
      described_class.new(first_value).validate_function_formula
    end

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "expects false in return" do
        expect(formula).to be(false)
      end
    end

    context "contains Symbol as value" do
      let(:first_value) { "a" }

      it "does not return true" do
        expect(formula).not_to eql(true)
      end
    end
  end
end
