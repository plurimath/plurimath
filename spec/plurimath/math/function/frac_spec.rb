require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Frac do
  describe ".initialize" do
    it "returns instance of Frac" do
      frac = described_class.new(7, 3)
      expect(frac).to be_a(described_class)
    end

    it "initializes Frac object" do
      frac = described_class.new(7, 4)
      expect(frac.parameter_one).to be(7)
      expect(frac.parameter_two).to be(4)
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-frac-22-1"

    it_behaves_like "shared renderer fixture", "function-frac-38-1"

    it_behaves_like "shared renderer fixture", "function-frac-47-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-frac-80-1"

    it_behaves_like "shared renderer fixture", "function-frac-108-1"

    it_behaves_like "shared renderer fixture", "function-frac-123-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-frac-170-1"

    it_behaves_like "shared renderer fixture", "function-frac-186-1"

    it_behaves_like "shared renderer fixture", "function-frac-195-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-frac-224-1"

    it_behaves_like "shared renderer fixture", "function-frac-240-1"

    it_behaves_like "shared renderer fixture", "function-frac-249-1"
  end

  describe ".to_unicodemath" do
    it "renders each part of a displaystyle fraction once" do
      inner = described_class.new(
        Plurimath::Math::Symbols::Symbol.new("a"),
        Plurimath::Math::Symbols::Symbol.new("b"),
        { displaystyle: true },
      )
      frac = described_class.new(inner, Plurimath::Math::Symbols::Symbol.new("c"), { displaystyle: true })
      calls = 0
      inner.define_singleton_method(:to_unicodemath) do |**kwargs|
        calls += 1
        super(**kwargs)
      end

      expect(frac.to_unicodemath(options: {})).to eq("a⊘b⊘c")
      expect(calls).to eq(1)
    end
  end
end
