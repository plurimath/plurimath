require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Underover do
  describe ".initialize" do
    it "returns instance of Underover" do
      underover = described_class.new("sum", "theta",
                                      "square")
      expect(underover).to be_a(described_class)
    end

    it "initializes Underover object" do
      underover = described_class.new("sum", "theta",
                                      "square")
      expect(underover.parameter_one).to eql("sum")
      expect(underover.parameter_two).to eql("theta")
      expect(underover.parameter_three).to eql("square")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value,
                          third_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-underover-26-1"

    it_behaves_like "shared renderer fixture", "function-underover-36-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value, third_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-underover-63-1"

    it_behaves_like "shared renderer fixture", "function-underover-80-1"

    it_behaves_like "shared renderer fixture", "function-underover-97-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value,
                          third_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-underover-134-1"

    it_behaves_like "shared renderer fixture", "function-underover-151-1"

    it_behaves_like "shared renderer fixture", "function-underover-161-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value,
                          third_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-underover-178-1"

    it_behaves_like "shared renderer fixture", "function-underover-188-1"

    it_behaves_like "shared renderer fixture", "function-underover-198-1"
  end
end
