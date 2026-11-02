require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Power do
  describe ".initialize" do
    it "returns instance of Power" do
      power = described_class.new("sum", "theta")
      expect(power).to be_a(described_class)
    end

    it "initializes Power object" do
      power = described_class.new("sum", "theta")
      expect(power.parameter_one).to eql("sum")
      expect(power.parameter_two).to eql("theta")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-power-22-1"

    it_behaves_like "shared renderer fixture", "function-power-38-1"

    it_behaves_like "shared renderer fixture", "function-power-47-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-power-80-1"

    it_behaves_like "shared renderer fixture", "function-power-108-1"

    it_behaves_like "shared renderer fixture", "function-power-123-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-power-170-1"

    it_behaves_like "shared renderer fixture", "function-power-186-1"

    it_behaves_like "shared renderer fixture", "function-power-195-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-power-224-1"

    it_behaves_like "shared renderer fixture", "function-power-240-1"

    it_behaves_like "shared renderer fixture", "function-power-249-1"
  end
end
