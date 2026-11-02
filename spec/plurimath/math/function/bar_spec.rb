require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Bar do
  describe ".initialize" do
    it "returns instance of Bar" do
      bar = described_class.new("70")
      expect(bar).to be_a(described_class)
    end

    it "initializes Bar object" do
      bar = described_class.new("70")
      expect(bar.parameter_one).to eql("70")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-bar-21-1"

    it_behaves_like "shared renderer fixture", "function-bar-29-1"

    it_behaves_like "shared renderer fixture", "function-bar-37-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-bar-62-1"

    it_behaves_like "shared renderer fixture", "function-bar-76-1"

    it_behaves_like "shared renderer fixture", "function-bar-90-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    it_behaves_like "shared renderer fixture", "function-bar-121-1"

    it_behaves_like "shared renderer fixture", "function-bar-129-1"

    it_behaves_like "shared renderer fixture", "function-bar-137-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    it_behaves_like "shared renderer fixture", "function-bar-156-1"

    it_behaves_like "shared renderer fixture", "function-bar-164-1"

    it_behaves_like "shared renderer fixture", "function-bar-172-1"
  end
end
