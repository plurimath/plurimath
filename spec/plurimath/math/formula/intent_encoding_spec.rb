require "spec_helper"

RSpec.describe Plurimath::Math::Formula do
  describe ".to_mathml(intent: true)" do
    subject(:formula) { Plurimath::Math.parse(string, lang).to_mathml(intent: true) }

    context "contains frac AsciiMath string" do
      let(:lang) { :asciimath }
      let(:string) { "(n(n+1))/2" }

      it "matches MathML string containing Intent attribute" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfrac intent=":divide($num, 2)">
                <mrow arg="num">
                  <mi>n</mi>
                  <mrow>
                    <mo>(</mo>
                    <mi>n</mi>
                    <mo>+</mo>
                    <mn>1</mn>
                    <mo>)</mo>
                  </mrow>
                </mrow>
                <mn>2</mn>
              </mfrac>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(mathml)
      end
    end

    context "contains prod AsciiMath string" do
      let(:lang) { :asciimath }
      let(:string) { "prod_(i=1)^n i^3" }

      it "matches MathML string containing Intent attribute" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow intent=":product($l, n, $naryand)">
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
              <mrow intent=":sum($l, n, $naryand)">
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
                <mrow>
                  <mo>(</mo>
                  <mrow intent=":function">
                    <mi>tan</mi>
                    <mrow>
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

    context "contains oiint LaTeX string" do
      let(:lang) { :latex }
      let(:string) { "\\oiint_{i=1}^n 1^3" }

      it "matches MathML string containing Intent attribute" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow intent=":surface integral($l, n, $naryand)">
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

    context "contains oiiint LaTeX string" do
      let(:lang) { :latex }
      let(:string) { "\\oiiint_{i=1}^n 1^3" }

      it "matches MathML string containing Intent attribute" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow intent=":surface integral($l, n, $naryand)">
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
              <msubsup intent=":function">
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
