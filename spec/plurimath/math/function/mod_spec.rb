require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Mod do
  describe ".initialize" do
    it "returns instance of Mod" do
      mod = described_class.new(70, 3)
      expect(mod).to be_a(described_class)
    end

    it "initializes Mod object" do
      mod = described_class.new(70, 3)
      expect(mod.parameter_one).to be(70)
      expect(mod.parameter_two).to be(3)
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-mod-22-1"

    it_behaves_like "shared renderer fixture", "function-mod-38-1"

    it_behaves_like "shared renderer fixture", "function-mod-47-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-mod-80-1"

    it_behaves_like "shared renderer fixture", "function-mod-96-1"

    it_behaves_like "shared renderer fixture", "function-mod-125-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-mod-173-1"

    it_behaves_like "shared renderer fixture", "function-mod-189-1"

    it_behaves_like "shared renderer fixture", "function-mod-198-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-mod-227-1"

    it_behaves_like "shared renderer fixture", "function-mod-243-1"

    it_behaves_like "shared renderer fixture", "function-mod-252-1"
  end
end
