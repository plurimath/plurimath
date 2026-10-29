require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Fenced do
  describe ".initialize" do
    subject(:fenced) { described_class.new(first, second, third) }

    context "initialize fenced object" do
      let(:first) { "sum" }
      let(:second) { "theta" }
      let(:third) { "square" }

      it "returns instance of Fenced object" do
        expect(fenced).to be_a(described_class)
      end

      it "initialized Fenced object values" do
        expect(fenced.parameter_one).to eql("sum")
        expect(fenced.parameter_two).to eql("theta")
        expect(fenced.parameter_three).to eql("square")
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value,
                          third_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-fenced-30-1"

    it_behaves_like "shared renderer fixture", "function-fenced-40-1"

    it_behaves_like "shared renderer fixture", "function-fenced-50-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value, third_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-fenced-79-1"

    it_behaves_like "shared renderer fixture", "function-fenced-96-1"

    it_behaves_like "shared renderer fixture", "function-fenced-113-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value,
                          third_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-fenced-152-1"

    it_behaves_like "shared renderer fixture", "function-fenced-162-1"

    it_behaves_like "shared renderer fixture", "function-fenced-172-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value,
                          third_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-fenced-198-1"

    it_behaves_like "shared renderer fixture", "function-fenced-208-1"

    it_behaves_like "shared renderer fixture", "function-fenced-218-1"
  end

  describe ".==" do
    subject(:fenced) { described_class.new(first, second, third) }

    context "contains fenced object with default braces" do
      let(:first) { Plurimath::Math::Symbols::Paren::Lround.new }
      let(:second) { [Plurimath::Math::Function::Sum.new] }
      let(:third) { Plurimath::Math::Symbols::Paren::Rround.new }

      it "returns true" do
        expected_value = described_class.new(
          Plurimath::Math::Symbols::Paren::Lround.new,
          [Plurimath::Math::Function::Sum.new],
          Plurimath::Math::Symbols::Paren::Rround.new,
        )
        expect(fenced).to eq(expected_value)
      end
    end

    context "contains fenced object with curly braces" do
      let(:first) { Plurimath::Math::Symbols::Symbol.new("{") }
      let(:second) { [Plurimath::Math::Function::Sum.new] }
      let(:third) { Plurimath::Math::Symbols::Symbol.new("}") }

      it "returns false" do
        expected_value = described_class.new(
          Plurimath::Math::Symbols::Paren::Lround.new,
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Symbols::Paren::Rround.new,
        )
        expect(fenced).not_to eq(expected_value)
      end
    end
  end
end
