require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Symbols::Symbol do
  describe ".initialize" do
    it "returns instance of Symbol" do
      symbol = described_class.new("theta")
      expect(symbol).to be_a(described_class)
    end

    it "initializes Symbol object" do
      symbol = described_class.new("theta")
      expect(symbol.value).to eql("theta")
    end
  end

  describe ".==" do
    subject(:symbol) { described_class.new(value) }

    context "contains a symbol string" do
      let(:value) { "gamma" }

      expected_value = described_class.new("gamma")

      it "returns string" do
        expect(symbol == expected_value).to be_truthy
      end
    end

    context "contains a nil string" do
      let(:value) { "" }

      expected_value = described_class.new("Gamma")

      it "returns string" do
        expect(symbol == expected_value).to be_falsey
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value).to_asciimath }

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-43-1"

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-51-1"

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-59-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-77-1"

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-85-1"

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-93-1"
  end

  describe ".to_mathml with token options" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, options: options)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    # `rspace` is an operator attribute: MathML 4 admits it on `mo`, never on
    # `mi`, so a generic token carrying one must serialize as an operator.
    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-113-1"

    # Guards the condition above against being widened to "any option present":
    # spacing symbols carry options too and must stay identifiers.
    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-126-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex }

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-139-1"

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-147-1"

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-155-1"
  end

  describe ".to_omml" do
    subject(:formula) do
      described_class.new(first_value).to_omml_without_math_tag(true).gsub("&amp;",
                                                                           "&")
    end

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-170-1"

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-178-1"

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-186-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html }

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-198-1"

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-206-1"

    it_behaves_like "shared renderer fixture", "renderer-math-symbols-symbol-symbol-214-1"
  end

  describe ".validate_function_formula" do
    subject(:formula) do
      described_class.new(first_value).validate_function_formula
    end

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "expects false in return" do
        expect(formula).to be(false)
      end
    end

    context "contains Symbol as value" do
      let(:first_value) { "a" }

      it "does not return true" do
        expect(formula).not_to eql(true)
      end
    end
  end
end
