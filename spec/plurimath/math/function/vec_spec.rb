require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Vec do
  describe ".initialize" do
    it "returns instance of Vec" do
      vec = described_class.new("70")
      expect(vec).to be_a(described_class)
    end

    it "initializes Vec object" do
      vec = described_class.new("70")
      expect(vec.parameter_one).to eql("70")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-vec-21-1"

    it_behaves_like "shared renderer fixture", "function-vec-29-1"

    it_behaves_like "shared renderer fixture", "function-vec-37-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-vec-62-1"

    it_behaves_like "shared renderer fixture", "function-vec-77-1"

    it_behaves_like "shared renderer fixture", "function-vec-91-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    it_behaves_like "shared renderer fixture", "function-vec-122-1"

    it_behaves_like "shared renderer fixture", "function-vec-130-1"

    it_behaves_like "shared renderer fixture", "function-vec-138-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    it_behaves_like "shared renderer fixture", "function-vec-157-1"

    it_behaves_like "shared renderer fixture", "function-vec-165-1"

    it_behaves_like "shared renderer fixture", "function-vec-173-1"
  end
end
