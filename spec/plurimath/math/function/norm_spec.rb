require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Norm do
  describe ".initialize" do
    it "returns instance of Norm" do
      norm = described_class.new("70")
      expect(norm).to be_a(described_class)
    end

    it "initializes Norm object" do
      norm = described_class.new("70")
      expect(norm.parameter_one).to eql("70")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-norm-21-1"

    it_behaves_like "shared renderer fixture", "function-norm-29-1"

    it_behaves_like "shared renderer fixture", "function-norm-37-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-norm-62-1"

    it_behaves_like "shared renderer fixture", "function-norm-77-1"

    it_behaves_like "shared renderer fixture", "function-norm-92-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    it_behaves_like "shared renderer fixture", "function-norm-124-1"

    it_behaves_like "shared renderer fixture", "function-norm-134-1"

    it_behaves_like "shared renderer fixture", "function-norm-142-1"

    it_behaves_like "shared renderer fixture", "function-norm-150-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    it_behaves_like "shared renderer fixture", "function-norm-169-1"

    it_behaves_like "shared renderer fixture", "function-norm-177-1"

    it_behaves_like "shared renderer fixture", "function-norm-185-1"
  end
end
