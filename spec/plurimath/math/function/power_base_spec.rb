require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::PowerBase do
  describe ".initialize" do
    subject(:power_base) { described_class.new(first, second, third) }

    context "initialize PowerBase object" do
      let(:first) { Plurimath::Math::Function::Sum.new }
      let(:second) { Plurimath::Math::Symbols::Symbol.new("Theta") }
      let(:third) { Plurimath::Math::Symbols::Symbol.new("square") }

      it "returns instance of PowerBase" do
        expect(power_base).to be_a(described_class)
      end

      it "initializes PowerBase object" do
        expect(power_base.parameter_one).to eq(Plurimath::Math::Function::Sum.new)
        expect(power_base.parameter_two).to eq(Plurimath::Math::Symbols::Symbol.new("Theta"))
        expect(power_base.parameter_three).to eq(Plurimath::Math::Symbols::Symbol.new("square"))
      end
    end
  end

  describe ".==" do
    subject(:power_base) { described_class.new(first, second, third) }

    context "contains PowerBase object" do
      let(:first) { Plurimath::Math::Function::Sum.new }
      let(:second) { Plurimath::Math::Symbols::Symbol.new("Theta") }
      let(:third) { Plurimath::Math::Symbols::Symbol.new("square") }

      it "matches epxected value" do
        expected_value = described_class.new(
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Symbols::Symbol.new("Theta"),
          Plurimath::Math::Symbols::Symbol.new("square"),
        )
        expect(power_base).to eq(expected_value)
      end

      it "matches epxected value" do
        expected_value = described_class.new(
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Symbols::Symbol.new("theta"),
          Plurimath::Math::Symbols::Symbol.new("square"),
        )
        expect(power_base).not_to eq(expected_value)
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value,
                          third_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-power_base-58-1"

    it_behaves_like "shared renderer fixture", "function-power_base-75-1"

    it_behaves_like "shared renderer fixture", "function-power_base-85-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value, third_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-power_base-119-1"

    it_behaves_like "shared renderer fixture", "function-power_base-149-1"

    it_behaves_like "shared renderer fixture", "function-power_base-179-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value,
                          third_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-power_base-229-1"

    it_behaves_like "shared renderer fixture", "function-power_base-253-1"

    it_behaves_like "shared renderer fixture", "function-power_base-263-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value,
                          third_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-power_base-301-1"

    it_behaves_like "shared renderer fixture", "function-power_base-338-1"

    it_behaves_like "shared renderer fixture", "function-power_base-355-1"
  end
end
