require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Lcm do
  describe ".initialize" do
    it "returns instance of Lcm" do
      lcm = described_class.new([70, 45])
      expect(lcm).to be_a(described_class)
    end

    it "initializes Lcm object" do
      lcm = described_class.new([70, 45])
      expect(lcm.parameter_one).to eql([70, 45])
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-lcm-21-1"

    it_behaves_like "shared renderer fixture", "function-lcm-29-1"

    it_behaves_like "shared renderer fixture", "function-lcm-37-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-lcm-62-1"

    it_behaves_like "shared renderer fixture", "function-lcm-77-1"

    it_behaves_like "shared renderer fixture", "function-lcm-91-1"
  end

  # The immutable renderer fixtures record the previous plain-letter output.
  describe ".to_latex", engine_loop: :always do
    {
      Plurimath::Math::Symbols::Symbol.new("x") => "x",
      Plurimath::Math::Number.new("70") => "70",
      Plurimath::Math::Formula.new([
        Plurimath::Math::Symbols::Symbol.new("x"),
        Plurimath::Math::Number.new("2"),
      ]) => "x 2",
    }.each do |argument, latex|
      it "writes an upright lcm operator with #{latex}" do
        node = described_class.new(argument)
        output = node.to_latex(options: {})
        expect(output).to eq("\\operatorname{lcm}{#{latex}}")
        reread = Plurimath::Math.parse(output, :latex)
        expect(reread.to_mathml).to include("<mi>lcm</mi>")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    it_behaves_like "shared renderer fixture", "function-lcm-157-1"

    it_behaves_like "shared renderer fixture", "function-lcm-165-1"

    it_behaves_like "shared renderer fixture", "function-lcm-173-1"
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
