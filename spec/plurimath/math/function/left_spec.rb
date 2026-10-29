require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Left do
  describe ".initialize" do
    subject(:left) { described_class.new(string)  }

    context "contains simple text to match Object and field value" do
      it "returns instance of Left" do
        left = described_class.new("70")
        expect(left).to be_a(described_class)
      end

      it "initializes Left object" do
        left = described_class.new("70")
        expect(left.parameter_one).to eql("70")
      end
    end
  end

  describe ".to_asciimath" do
    subject(:left) { described_class.new(string).to_asciimath }

    it_behaves_like "shared renderer fixture", "function-left-23-1"
  end

  describe ".to_latex" do
    subject(:left) { described_class.new(string).to_latex }

    it_behaves_like "shared renderer fixture", "function-left-35-1"

    it_behaves_like "shared renderer fixture", "function-left-43-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-left-61-1"

    it_behaves_like "shared renderer fixture", "function-left-69-1"

    it_behaves_like "shared renderer fixture", "function-left-77-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html }

    it_behaves_like "shared renderer fixture", "function-left-89-1"

    it_behaves_like "shared renderer fixture", "function-left-97-1"

    it_behaves_like "shared renderer fixture", "function-left-105-1"
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
