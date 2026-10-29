require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::FontStyle do
  describe ".initialize" do
    it "returns instance of FontStyle" do
      font_style = described_class.new("AaBbCc")
      expect(font_style).to be_a(described_class)
    end

    it "initializes FontStyle object" do
      font_style = described_class.new("AaBbCc")
      expect(font_style.parameter_one).to eql("AaBbCc")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-font_style-21-1"

    it_behaves_like "shared renderer fixture", "function-font_style-30-1"

    it_behaves_like "shared renderer fixture", "function-font_style-39-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-font_style-65-1"

    it_behaves_like "shared renderer fixture", "function-font_style-79-1"

    it_behaves_like "shared renderer fixture", "function-font_style-93-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-font_style-126-1"

    it_behaves_like "shared renderer fixture", "function-font_style-135-1"

    it_behaves_like "shared renderer fixture", "function-font_style-144-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-font_style-166-1"

    it_behaves_like "shared renderer fixture", "function-font_style-175-1"

    it_behaves_like "shared renderer fixture", "function-font_style-184-1"
  end

  describe ".validate_function_formula" do
    subject(:formula) do
      described_class.new(first_value).validate_function_formula
    end

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "expects true in return" do
        expect(formula).to be(true)
      end
    end

    context "contains Symbol as value" do
      let(:first_value) { "a" }

      it "does not return false" do
        expect(formula).not_to eql(false)
      end
    end
  end
end
