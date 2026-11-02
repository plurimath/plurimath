require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Floor do
  describe ".initialize" do
    it "returns instance of Floor" do
      floor = described_class.new(70.3)
      expect(floor).to be_a(described_class)
    end

    it "initializes Floor object" do
      floor = described_class.new(70.3)
      expect(floor.parameter_one).to be(70.3)
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-floor-21-1"

    it_behaves_like "shared renderer fixture", "function-floor-29-1"

    it_behaves_like "shared renderer fixture", "function-floor-37-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-floor-62-1"

    it_behaves_like "shared renderer fixture", "function-floor-78-1"

    it_behaves_like "shared renderer fixture", "function-floor-93-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    it_behaves_like "shared renderer fixture", "function-floor-125-1"

    it_behaves_like "shared renderer fixture", "function-floor-133-1"

    it_behaves_like "shared renderer fixture", "function-floor-141-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    it_behaves_like "shared renderer fixture", "function-floor-160-1"

    it_behaves_like "shared renderer fixture", "function-floor-168-1"

    it_behaves_like "shared renderer fixture", "function-floor-176-1"
  end
end
