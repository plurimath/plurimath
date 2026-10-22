require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Overset do
  it_behaves_like "shared renderer fixture", "function-overset-display"
  it_behaves_like "shared renderer fixture", "function-overset-inline"
  it_behaves_like "shared renderer fixture", "function-overset-omml-roundtrip"

  describe ".initialize" do
    it "returns instance of Overset" do
      overset = described_class.new("70", "=")
      expect(overset).to be_a(described_class)
    end

    it "initializes Overset object" do
      overset = described_class.new("70", "=")
      expect(overset.parameter_one).to eql("70")
      expect(overset.parameter_two).to eql("=")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-overset-47-1"

    it_behaves_like "shared renderer fixture", "function-overset-63-1"

    it_behaves_like "shared renderer fixture", "function-overset-79-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-overset-112-1"

    it_behaves_like "shared renderer fixture", "function-overset-141-1"

    it_behaves_like "shared renderer fixture", "function-overset-169-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-overset-216-1"

    it_behaves_like "shared renderer fixture", "function-overset-232-1"

    it_behaves_like "shared renderer fixture", "function-overset-248-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-overset-277-1"

    it_behaves_like "shared renderer fixture", "function-overset-293-1"

    it_behaves_like "shared renderer fixture", "function-overset-302-1"
  end
end
