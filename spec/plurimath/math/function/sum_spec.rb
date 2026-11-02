require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Sum do
  describe ".initialize" do
    it "returns instance of Sum" do
      sum = described_class.new("70", "20")
      expect(sum).to be_a(described_class)
    end

    it "initializes Sum object" do
      sum = described_class.new("70", "20")
      expect(sum.parameter_one).to eql("70")
      expect(sum.parameter_two).to eql("20")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-sum-22-1"

    it_behaves_like "shared renderer fixture", "function-sum-31-1"

    it_behaves_like "shared renderer fixture", "function-sum-47-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-sum-80-1"

    it_behaves_like "shared renderer fixture", "function-sum-109-1"

    it_behaves_like "shared renderer fixture", "function-sum-125-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-sum-173-1"

    it_behaves_like "shared renderer fixture", "function-sum-189-1"

    it_behaves_like "shared renderer fixture", "function-sum-198-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-sum-227-1"

    it_behaves_like "shared renderer fixture", "function-sum-243-1"

    it_behaves_like "shared renderer fixture", "function-sum-252-1"
  end
end
