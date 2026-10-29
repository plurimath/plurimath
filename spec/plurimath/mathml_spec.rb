require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Mathml do
  describe ".initialize" do
    subject(:formula) { described_class.new(mathml) }

    context "initialize Mathml object" do
      let(:mathml) { "<mrow><mn>2</mn></mrow>" }

      it "returns instance of Mathml" do
        expect(formula).to be_a(described_class)
      end

      it "returns Mathml instance" do
        expect(formula.text).to eql("<mrow><mn>2</mn></mrow>")
      end
    end
  end

  describe ".to_formula" do
    subject(:formula) { described_class.new(string).to_formula }

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-23-1"
    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-23-2"
  end

  it_behaves_like "shared renderer fixture", "renderer-large-operator-bigwedge"
  it_behaves_like "shared renderer fixture", "renderer-large-operator-bigoplus"
  it_behaves_like "shared renderer fixture", "renderer-large-operator-bigotimes"
  it_behaves_like "shared renderer fixture", "renderer-large-operator-bigodot"
  it_behaves_like "shared renderer fixture", "renderer-large-operator-coprod"
  it_behaves_like "shared renderer fixture", "renderer-large-operator-biguplus"
  it_behaves_like "shared renderer fixture", "renderer-large-operator-bigsqcup"
  it_behaves_like "shared renderer fixture", "renderer-nary-limit-order"

  describe "MathML round-tripping" do


    shared_examples "pretty MathML round-tripping" do |adapter_name|


      around do |example|
        adapter = Mml::V4::Configuration.adapter
        Mml::V4::Configuration.adapter = adapter_name
        example.run
      ensure
        Mml::V4::Configuration.adapter = adapter
      end

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-100"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-131"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-149"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-166"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-183"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-201"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-222"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-247"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-266"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-290"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-311"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-328"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-345"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-363"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-380"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-396"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-412"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-428"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-444"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-475"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-496"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-515"

      it_behaves_like "shared renderer fixture", "renderer-pretty-mathml-533"
    end

    %i[ox oga nokogiri].each do |adapter_name|
      context "with #{adapter_name} adapter" do
        it_behaves_like "pretty MathML round-tripping", adapter_name
      end
    end
  end

  describe ".to_asciimath .to_latex .to_mathml" do
    subject(:formula) { described_class.new(string).to_formula }

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-560-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-685-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-775-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-820-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-859-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-900-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-1689-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-1738-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-1769-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-1807-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-1864-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-1903-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-1938-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-1991-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-2122-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-2337-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-2396-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-2519-1"
  end

  describe ".to_omml" do
    subject(:formula) { described_class.new(string).to_formula.to_omml }

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-2586-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-2789-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-2961-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3028-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3068-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3172-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3299-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3399-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3470-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3527-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3573-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3607-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3687-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3739-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3795-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3851-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3903-1"

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-3959-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(string).to_formula.to_html }

    it_behaves_like "shared renderer fixture", "renderer-mathml-mathml-4069-1"
  end

  # An operator with no dedicated Plurimath symbol class used to round-trip as
  # `<mi rspace="...">`. Among token elements `rspace` is valid on `mo`, never
  # on `mi`. plurimath/plurimath#476
  it_behaves_like "shared renderer fixture", "renderer-spaced-operator-1"
  it_behaves_like "shared renderer fixture", "renderer-spaced-operator-2"
  it_behaves_like "shared renderer fixture", "renderer-spaced-operator-3"
end
