require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Cot do
  describe ".initialize" do
    it "returns instance of Cot" do
      cot = described_class.new("70")
      expect(cot).to be_a(described_class)
    end

    it "initializes Cot object" do
      cot = described_class.new("70")
      expect(cot.parameter_one).to eql("70")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-cot-21-1"

    it_behaves_like "shared renderer fixture", "function-cot-29-1"

    it_behaves_like "shared renderer fixture", "function-cot-37-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-cot-62-1"

    it_behaves_like "shared renderer fixture", "function-cot-76-1"

    it_behaves_like "shared renderer fixture", "function-cot-90-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    it_behaves_like "shared renderer fixture", "function-cot-121-1"

    it_behaves_like "shared renderer fixture", "function-cot-129-1"

    it_behaves_like "shared renderer fixture", "function-cot-137-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    it_behaves_like "shared renderer fixture", "function-cot-156-1"

    it_behaves_like "shared renderer fixture", "function-cot-164-1"

    it_behaves_like "shared renderer fixture", "function-cot-172-1"
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
