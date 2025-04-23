require "spec_helper"

RSpec.describe Plurimath::Math::Formula do
  describe "unicodemath examples" do
    subject(:formula) { Plurimath::Math.parse(string, :unicode) }
    subject(:mathml) { formula.to_mathml(intent: true) }

    SKIPABLE_INDEXES = [16]
    intent_examples = unicodemath_tests.find_all { |record| record["mathml"].match?(/intent=\"/) }
    intent_examples.each.with_index(1) do |example_hash, index|
      next if SKIPABLE_INDEXES.include?(index)

      context "processing unicode example(#{index})" do
        let(:string) { remove_prefix(example_hash["unicodemath"].to_s) }

        it "matches example's MathML with Plurimath MathML(#{index})" do
          expect(unicodemath_examples_intents(mathml)).to eql(unicodemath_examples_intents(example_hash["mathml"]))
        end
      end
    end
  end

  describe ".to_mathml(intent: true, unary_function_spacing: false)" do
    subject(:formula) { Plurimath::Math.parse(string, lang).to_mathml(intent: true, unary_function_spacing: false) }

    context "contains prod AsciiMath string" do
      let(:lang) { :asciimath }
      let(:string) { "prod_(i=1)^n i^3" }

      it "matches MathML string containing Intent attribute" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow intent=":product($l,n,$naryand)">
                <munderover>
                  <mo>&#x220f;</mo>
                  <mrow arg="l">
                    <mi>i</mi>
                    <mo>=</mo>
                    <mn>1</mn>
                  </mrow>
                  <mi>n</mi>
                </munderover>
                <mrow arg="naryand">
                  <msup>
                    <mi>i</mi>
                    <mn>3</mn>
                  </msup>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(mathml)
      end
    end

    context "contains sum AsciiMath string" do
      let(:lang) { :asciimath }
      let(:string) { "sum_(i=1)^n i^3" }

      it "matches MathML string containing Intent attribute" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow intent=":sum($l,n,$naryand)">
                <munderover>
                  <mo>&#x2211;</mo>
                  <mrow arg="l">
                    <mi>i</mi>
                    <mo>=</mo>
                    <mn>1</mn>
                  </mrow>
                  <mi>n</mi>
                </munderover>
                <mrow arg="naryand">
                  <msup>
                    <mi>i</mi>
                    <mn>3</mn>
                  </msup>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(mathml)
      end
    end

    context "contains cos AsciiMath string" do
      let(:lang) { :asciimath }
      let(:string) { "cos(tan(1))" }

      it "matches MathML string containing Intent attribute" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow intent=":function">
                <mi>cos</mi>
                <mrow intent=":fenced">
                  <mo>(</mo>
                  <mrow intent=":function">
                    <mi>tan</mi>
                    <mrow intent=":fenced">
                      <mo>(</mo>
                      <mn>1</mn>
                      <mo>)</mo>
                    </mrow>
                  </mrow>
                  <mo>)</mo>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(mathml)
      end
    end

    context "contains oiiint LaTeX string" do
      let(:lang) { :latex }
      let(:string) { "\\oiiint_{i=1}^n 1^3" }

      it "matches MathML string containing Intent attribute" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow intent=":volume integral($l,n,$naryand)">
                <msubsup>
                  <mo>&#x2230;</mo>
                  <mrow arg="l">
                    <mi>i</mi>
                    <mo>=</mo>
                    <mn>1</mn>
                  </mrow>
                  <mi>n</mi>
                </msubsup>
                <mrow arg="naryand">
                  <msup>
                    <mn>1</mn>
                    <mn>3</mn>
                  </msup>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(mathml)
      end
    end

    context "contains oiint LaTeX string" do
      let(:lang) { :latex }
      let(:string) { "\\oiint_{i=1}^n 1^3" }

      it "matches MathML string containing Intent attribute" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow intent=":surface integral($l,n,$naryand)">
                <msubsup>
                  <mo>&#x222f;</mo>
                  <mrow arg="l">
                    <mi>i</mi>
                    <mo>=</mo>
                    <mn>1</mn>
                  </mrow>
                  <mi>n</mi>
                </msubsup>
                <mrow arg="naryand">
                  <msup>
                    <mn>1</mn>
                    <mn>3</mn>
                  </msup>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(mathml)
      end
    end

    context "contains inf LaTeX string" do
      let(:lang) { :latex }
      let(:string) { "\\inf_{i=1}^n" }

      it "matches MathML string containing Intent attribute" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover intent=":function">
                <mo>inf</mo>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mn>1</mn>
                </mrow>
                <mi>n</mi>
              </munderover>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(mathml)
      end
    end

    context "contains lim LaTeX string" do
      let(:lang) { :latex }
      let(:string) { "\\lim_{i=1}^n" }

      it "matches MathML string containing Intent attribute" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover intent=":function">
                <mo>lim</mo>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mn>1</mn>
                </mrow>
                <mi>n</mi>
              </munderover>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(mathml)
      end
    end

    context "contains log LaTeX string" do
      let(:lang) { :latex }
      let(:string) { "\\log_{i=1}^n" }

      it "matches MathML string containing Intent attribute" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mi>log</mi>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mn>1</mn>
                </mrow>
                <mi>n</mi>
              </msubsup>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(mathml)
      end
    end
  end
end

def unicodemath_examples_intents(array)
  array.scan(/intent="([^"]+)"/).sort.flatten.join.
    gsub("$n)", "$naryand)").
    gsub("𝐴", "A").
    gsub("𝑎", "a").
    gsub("𝛼", "a").
    gsub("𝑏", "b").
    gsub("𝑆", "S").
    gsub("𝑛", "n").
    gsub("𝑘", "k").
    gsub("𝑡", "t").
    gsub("𝑥", "x").
    gsub("𝑦", "y").
    gsub("𝑁", "N").
    gsub("α", "a").
    gsub("𝜋", "π")
end
