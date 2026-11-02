require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Ddot do
  describe ".initialize" do
    it "returns instance of Ddot" do
      ddot = described_class.new("70")
      expect(ddot).to be_a(described_class)
    end

    it "initializes Ddot object" do
      ddot = described_class.new("70")
      expect(ddot.parameter_one).to eql("70")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-ddot-21-1"

    it_behaves_like "shared renderer fixture", "function-ddot-29-1"

    it_behaves_like "shared renderer fixture", "function-ddot-37-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-ddot-62-1"

    it_behaves_like "shared renderer fixture", "function-ddot-76-1"

    it_behaves_like "shared renderer fixture", "function-ddot-90-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    it_behaves_like "shared renderer fixture", "function-ddot-121-1"

    it_behaves_like "shared renderer fixture", "function-ddot-129-1"

    it_behaves_like "shared renderer fixture", "function-ddot-137-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    it_behaves_like "shared renderer fixture", "function-ddot-156-1"

    it_behaves_like "shared renderer fixture", "function-ddot-164-1"

    it_behaves_like "shared renderer fixture", "function-ddot-172-1"
  end
end
