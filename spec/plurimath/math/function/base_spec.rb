require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Base do
  it "returns instance of Base" do
    base = described_class.new("sum", "theta")
    expect(base).to be_a(described_class)
  end

  it "initializes Base object" do
    base = described_class.new("sum", "theta")
    expect(base.parameter_one).to eql("sum")
    expect(base.parameter_two).to eql("theta")
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-base-20-1"

    it_behaves_like "shared renderer fixture", "function-base-29-1"

    it_behaves_like "shared renderer fixture", "function-base-38-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-base-64-1"

    it_behaves_like "shared renderer fixture", "function-base-80-1"

    it_behaves_like "shared renderer fixture", "function-base-95-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-base-129-1"

    it_behaves_like "shared renderer fixture", "function-base-138-1"

    it_behaves_like "shared renderer fixture", "function-base-154-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-base-183-1"

    it_behaves_like "shared renderer fixture", "function-base-192-1"

    it_behaves_like "shared renderer fixture", "function-base-208-1"
  end
end
