require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Abs do
  describe ".initialize" do
    subject(:formula) { described_class.new(first_value) }

    context "contains symbol value" do
      let(:first_value) { Plurimath::Math::Symbols::Ampersand.new }

      it "returns instance of Abs" do
        expect(formula).to be_a(described_class)
      end
    end

    context "contains Symbol value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "initializes Abs object" do
        expected_value = Plurimath::Math::Number.new("70")
        expect(formula.parameter_one).to eq(expected_value)
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-abs-30-1"

    it_behaves_like "shared renderer fixture", "function-abs-38-1"

    it_behaves_like "shared renderer fixture", "function-abs-46-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-abs-71-1"

    it_behaves_like "shared renderer fixture", "function-abs-86-1"

    it_behaves_like "shared renderer fixture", "function-abs-101-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    it_behaves_like "shared renderer fixture", "function-abs-133-1"

    it_behaves_like "shared renderer fixture", "function-abs-141-1"

    it_behaves_like "shared renderer fixture", "function-abs-149-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    it_behaves_like "shared renderer fixture", "function-abs-168-1"

    it_behaves_like "shared renderer fixture", "function-abs-176-1"

    it_behaves_like "shared renderer fixture", "function-abs-184-1"
  end
end
