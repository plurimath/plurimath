require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Ul do
  describe ".initialize" do
    it "returns instance of Ul" do
      ul = described_class.new("70")
      expect(ul).to be_a(described_class)
    end

    it "initializes Ul object" do
      ul = described_class.new("70")
      expect(ul.parameter_one).to eql("70")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-ul-21-1"

    it_behaves_like "shared renderer fixture", "function-ul-29-1"

    it_behaves_like "shared renderer fixture", "function-ul-37-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-ul-62-1"

    it_behaves_like "shared renderer fixture", "function-ul-76-1"

    it_behaves_like "shared renderer fixture", "function-ul-90-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    it_behaves_like "shared renderer fixture", "function-ul-121-1"

    it_behaves_like "shared renderer fixture", "function-ul-129-1"

    it_behaves_like "shared renderer fixture", "function-ul-137-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    it_behaves_like "shared renderer fixture", "function-ul-156-1"

    it_behaves_like "shared renderer fixture", "function-ul-164-1"

    it_behaves_like "shared renderer fixture", "function-ul-172-1"
  end
end
