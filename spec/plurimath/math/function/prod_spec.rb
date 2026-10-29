require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Prod do
  describe ".initialize" do
    it "returns instance of Prod" do
      prod = described_class.new("70", "20")
      expect(prod).to be_a(described_class)
    end

    it "initializes Prod object" do
      prod = described_class.new("70", "20")
      expect(prod.parameter_one).to eql("70")
      expect(prod.parameter_two).to eql("20")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-prod-22-1"

    it_behaves_like "shared renderer fixture", "function-prod-38-1"

    it_behaves_like "shared renderer fixture", "function-prod-47-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-prod-80-1"

    it_behaves_like "shared renderer fixture", "function-prod-109-1"

    it_behaves_like "shared renderer fixture", "function-prod-125-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-prod-173-1"

    it_behaves_like "shared renderer fixture", "function-prod-189-1"

    it_behaves_like "shared renderer fixture", "function-prod-198-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-prod-227-1"

    it_behaves_like "shared renderer fixture", "function-prod-243-1"

    it_behaves_like "shared renderer fixture", "function-prod-252-1"
  end
end
