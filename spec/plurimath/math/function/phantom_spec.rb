require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Phantom do
  describe ".initialize" do
    it "returns instance of Phantom" do
      phantom = described_class.new("70")
      expect(phantom).to be_a(described_class)
    end

    it "initializes Phantom object" do
      phantom = described_class.new("70")
      expect(phantom.parameter_one).to eql("70")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-phantom-21-1"

    it_behaves_like "shared renderer fixture", "function-phantom-29-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-phantom-54-1"

    it_behaves_like "shared renderer fixture", "function-phantom-68-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    it_behaves_like "shared renderer fixture", "function-phantom-99-1"

    it_behaves_like "shared renderer fixture", "function-phantom-107-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html }

    it_behaves_like "shared renderer fixture", "function-phantom-126-1"

    it_behaves_like "shared renderer fixture", "function-phantom-134-1"
  end
end
