require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Color do
  describe ".initialize" do
    it "returns instance of Color" do
      color = described_class.new("red", "70")
      expect(color).to be_a(described_class)
    end

    it "initializes Color object" do
      color = described_class.new("red", "70")
      expect(color.parameter_one).to eql("red")
      expect(color.parameter_two).to eql("70")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-color-22-1"

    it_behaves_like "shared renderer fixture", "function-color-31-1"

    it_behaves_like "shared renderer fixture", "function-color-40-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-color-66-1"

    it_behaves_like "shared renderer fixture", "function-color-80-1"

    it_behaves_like "shared renderer fixture", "function-color-94-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-color-127-1"

    it_behaves_like "shared renderer fixture", "function-color-136-1"

    it_behaves_like "shared renderer fixture", "function-color-145-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-color-167-1"

    it_behaves_like "shared renderer fixture", "function-color-176-1"

    it_behaves_like "shared renderer fixture", "function-color-185-1"
  end
end
