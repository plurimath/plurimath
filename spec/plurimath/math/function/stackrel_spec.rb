require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Stackrel do
  describe ".initialize" do
    it "returns instance of Stackrel" do
      stackrel = described_class.new(7, 70)
      expect(stackrel).to be_a(described_class)
    end

    it "initializes Stackrel object" do
      stackrel = described_class.new(70, 7)
      expect(stackrel.parameter_one).to be(70)
      expect(stackrel.parameter_two).to be(7)
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-stackrel-22-1"

    it_behaves_like "shared renderer fixture", "function-stackrel-38-1"

    it_behaves_like "shared renderer fixture", "function-stackrel-47-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-stackrel-80-1"

    it_behaves_like "shared renderer fixture", "function-stackrel-112-1"

    it_behaves_like "shared renderer fixture", "function-stackrel-131-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-stackrel-182-1"

    it_behaves_like "shared renderer fixture", "function-stackrel-198-1"

    it_behaves_like "shared renderer fixture", "function-stackrel-207-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-stackrel-236-1"

    it_behaves_like "shared renderer fixture", "function-stackrel-252-1"

    it_behaves_like "shared renderer fixture", "function-stackrel-261-1"
  end
end
