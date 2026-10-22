require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Lim do
  describe ".initialize" do
    subject(:lim) { described_class.new(parameter_one, parameter_two) }

    context "initializes object" do
      let(:parameter_one) { "70" }
      let(:parameter_two) { "20" }

      it "returns instance of Lim" do
        expect(lim).to be_a(described_class)
      end

      it "initializes Lim object" do
        expect(lim.parameter_one).to eql("70")
        expect(lim.parameter_two).to eql("20")
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-lim-27-1"

    it_behaves_like "shared renderer fixture", "function-lim-43-1"

    it_behaves_like "shared renderer fixture", "function-lim-52-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-lim-85-1"

    it_behaves_like "shared renderer fixture", "function-lim-114-1"

    it_behaves_like "shared renderer fixture", "function-lim-130-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-lim-178-1"

    it_behaves_like "shared renderer fixture", "function-lim-194-1"

    it_behaves_like "shared renderer fixture", "function-lim-203-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-lim-232-1"

    it_behaves_like "shared renderer fixture", "function-lim-241-1"

    it_behaves_like "shared renderer fixture", "function-lim-257-1"

    it_behaves_like "shared renderer fixture", "function-lim-266-1"
  end
end
