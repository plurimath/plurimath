require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Ceil do
  describe ".initialize" do
    it "returns instance of Ceil" do
      ceil = described_class.new(70.3)
      expect(ceil).to be_a(described_class)
    end

    it "initializes Ceil object" do
      ceil = described_class.new(70.4)
      expect(ceil.parameter_one).to be(70.4)
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-ceil-21-1"

    it_behaves_like "shared renderer fixture", "function-ceil-29-1"

    it_behaves_like "shared renderer fixture", "function-ceil-37-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-ceil-62-1"

    it_behaves_like "shared renderer fixture", "function-ceil-77-1"

    it_behaves_like "shared renderer fixture", "function-ceil-92-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    it_behaves_like "shared renderer fixture", "function-ceil-124-1"

    it_behaves_like "shared renderer fixture", "function-ceil-132-1"

    it_behaves_like "shared renderer fixture", "function-ceil-140-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    it_behaves_like "shared renderer fixture", "function-ceil-159-1"

    it_behaves_like "shared renderer fixture", "function-ceil-167-1"

    it_behaves_like "shared renderer fixture", "function-ceil-175-1"
  end
end
