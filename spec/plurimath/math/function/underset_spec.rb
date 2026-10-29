require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Underset do
  it_behaves_like "shared renderer fixture", "function-underset-display"
  it_behaves_like "shared renderer fixture", "function-underset-inline"
  it_behaves_like "shared renderer fixture", "function-underset-omml-roundtrip"

  describe ".initialize" do
    it "returns instance of Underset" do
      underset = described_class.new("70", "=")
      expect(underset).to be_a(described_class)
    end

    it "initializes Underset object" do
      underset = described_class.new("70", "=")
      expect(underset.parameter_one).to eql("70")
      expect(underset.parameter_two).to eql("=")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-underset-47-1"

    it_behaves_like "shared renderer fixture", "function-underset-56-1"

    it_behaves_like "shared renderer fixture", "function-underset-65-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-underset-91-1"

    it_behaves_like "shared renderer fixture", "function-underset-107-1"

    it_behaves_like "shared renderer fixture", "function-underset-122-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-underset-156-1"

    it_behaves_like "shared renderer fixture", "function-underset-165-1"

    it_behaves_like "shared renderer fixture", "function-underset-174-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-underset-196-1"

    it_behaves_like "shared renderer fixture", "function-underset-205-1"

    it_behaves_like "shared renderer fixture", "function-underset-214-1"
  end
end
