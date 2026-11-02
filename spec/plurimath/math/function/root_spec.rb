require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Root do
  describe ".initialize" do
    it "returns instance of Root" do
      root = described_class.new(70, 3)
      expect(root).to be_a(described_class)
    end

    it "initializes Root object" do
      root = described_class.new(70, 3)
      expect(root.parameter_one).to be(70)
      expect(root.parameter_two).to be(3)
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-root-22-1"

    it_behaves_like "shared renderer fixture", "function-root-38-1"

    it_behaves_like "shared renderer fixture", "function-root-47-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-root-80-1"

    it_behaves_like "shared renderer fixture", "function-root-108-1"

    it_behaves_like "shared renderer fixture", "function-root-123-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-root-170-1"

    it_behaves_like "shared renderer fixture", "function-root-186-1"

    it_behaves_like "shared renderer fixture", "function-root-195-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-root-224-1"

    it_behaves_like "shared renderer fixture", "function-root-240-1"

    it_behaves_like "shared renderer fixture", "function-root-249-1"
  end
end
