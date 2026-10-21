require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Sqrt do
  describe ".initialize" do
    it "returns instance of Sqrt" do
      sqrt = described_class.new(70)
      expect(sqrt).to be_a(described_class)
    end

    it "initializes Sqrt object" do
      sqrt = described_class.new(70)
      expect(sqrt.parameter_one).to be(70)
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-sqrt-21-1"

    it_behaves_like "shared renderer fixture", "function-sqrt-29-1"

    it_behaves_like "shared renderer fixture", "function-sqrt-37-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-sqrt-62-1"

    it_behaves_like "shared renderer fixture", "function-sqrt-76-1"

    it_behaves_like "shared renderer fixture", "function-sqrt-89-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    it_behaves_like "shared renderer fixture", "function-sqrt-119-1"

    it_behaves_like "shared renderer fixture", "function-sqrt-127-1"

    it_behaves_like "shared renderer fixture", "function-sqrt-135-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    it_behaves_like "shared renderer fixture", "function-sqrt-154-1"

    it_behaves_like "shared renderer fixture", "function-sqrt-162-1"

    it_behaves_like "shared renderer fixture", "function-sqrt-170-1"
  end
end
