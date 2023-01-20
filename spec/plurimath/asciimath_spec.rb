require_relative '../../spec/spec_helper'

RSpec.describe Plurimath::Asciimath do
  describe ".initialize" do
    subject(:asciimath) { Plurimath::Asciimath.new(string) }

    context "contains simple cos function with numeric value" do
      let(:string) { "cos(2)" }

      it 'returns instance of Asciimath' do
        expect(asciimath).to be_a(Plurimath::Asciimath)
      end

      it 'initializes Plurimath::Asciimath object' do
        expect(asciimath.text).to eql('cos(2)')
      end
    end
  end

  describe ".to_latex, to_mathml, to_html" do
    subject(:formula) { Plurimath::Asciimath.new(string).to_formula }

    context "contains example #01" do
      let(:string) { 'cos(2)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\cos{ \left ( 2 \right ) }'
        asciimath = 'cos(2)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mi>cos</mi>
                <mrow>
                  <mo>(</mo>
                  <mn>2</mn>
                  <mo>)</mo>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains example #02" do
      let(:string) { 'sum_(i=1)^n i^3=((n(n+1))/2)^2' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\sum_{i = 1}^{n} i^{3} =  \left ( \frac{n  \left ( n + 1 \right ) }{2} \right ) ^{2}'
        asciimath = 'sum_(i = 1)^(n) i^(3) = (frac(n (n + 1))(2))^(2)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover>
                <mo>&#x2211;</mo>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mn>1</mn>
                </mrow>
                <mi>n</mi>
              </munderover>
              <msup>
                <mi>i</mi>
                <mn>3</mn>
              </msup>
              <mo>=</mo>
              <msup>
                <mrow>
                  <mo>(</mo>
                  <mfrac>
                    <mrow>
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
                  <mo>)</mo>
                </mrow>
                <mn>2</mn>
              </msup>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains example #03" do
      let(:string) { 'unitsml(V*s//A,symbol:V cdot s//A)' }

      it 'returns parsed Asciimath to Formula' do
        latex = 'u n i t s m l  \left ( V \\cdot s / A , s y m b o l : V \\cdot s / A \right ) '
        asciimath = 'u n i t s m l (V * s // A , s y m b o l : V * s // A)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>u</mi>
              <mi>n</mi>
              <mi>i</mi>
              <mi>t</mi>
              <mi>s</mi>
              <mi>m</mi>
              <mi>l</mi>
              <mrow>
                <mo>(</mo>
                <mi>V</mi>
                <mo>&#x22c5;</mo>
                <mi>s</mi>
                <mo>/</mo>
                <mi>A</mi>
                <mo>,</mo>
                <mi>s</mi>
                <mi>y</mi>
                <mi>m</mi>
                <mi>b</mi>
                <mi>o</mi>
                <mi>l</mi>
                <mo>&#x3a;</mo>
                <mi>V</mi>
                <mo>&#x22c5;</mo>
                <mi>s</mi>
                <mo>/</mo>
                <mi>A</mi>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #04" do
      let(:string) { 'sum_(i=frac{1}{3})^33' }

      it 'returns parsed Asciimath to Formula' do
        latex = "\\sum_{i = \\frac{1}{3}}^{33}"
        asciimath = "sum_(i = frac(1)(3))^(33)"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover>
                <mo>&#x2211;</mo>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mfrac>
                    <mn>1</mn>
                    <mn>3</mn>
                  </mfrac>
                </mrow>
                <mn>33</mn>
              </munderover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #05" do
      let(:string) { 'sum_(i=color{1}{3})^33' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\sum_{i = {\color{1} 3}}^{33}'
        asciimath = "sum_(i = color(1)(3))^(33)"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover>
                <mo>&#x2211;</mo>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mstyle mathcolor="1">
                    <mn>3</mn>
                  </mstyle>
                </mrow>
                <mn>33</mn>
              </munderover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #06" do
      let(:string) { 'int_0^1f(x)dx' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\int_{0}^{1} f \left ( x \right )  d x'
        asciimath = 'int_(0)^(1) f(x) d x'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mo>&#x222b;</mo>
                <mn>0</mn>
                <mn>1</mn>
              </msubsup>
              <mrow>
                <mi>f</mi>
                <mrow>
                  <mo>(</mo>
                  <mi>x</mi>
                  <mo>)</mo>
                </mrow>
              </mrow>
              <mrow>
                <mi>d</mi>
                <mi>x</mi>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #07" do
      let(:string) { 'obrace(1+2+3+4)^("4 terms")' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\overbrace{1 + 2 + 3 + 4}^{\text{4 terms}}'
        asciimath = 'obrace(1 + 2 + 3 + 4)^("4 terms")'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mover>
                  <mrow>
                    <mn>1</mn>
                    <mo>+</mo>
                    <mn>2</mn>
                    <mo>+</mo>
                    <mn>3</mn>
                    <mo>+</mo>
                    <mn>4</mn>
                  </mrow>
                  <mo>&#x23de;</mo>
                </mover>
                <mtext>4 terms</mtext>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #08" do
      let(:string) { 'obrace(1+2+3+4)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\\overbrace{1 + 2 + 3 + 4}'
        asciimath = 'obrace(1 + 2 + 3 + 4)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mrow>
                  <mn>1</mn>
                  <mo>+</mo>
                  <mn>2</mn>
                  <mo>+</mo>
                  <mn>3</mn>
                  <mo>+</mo>
                  <mn>4</mn>
                </mrow>
                <mo>&#x23de;</mo>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #09" do
      let(:string) { 'log_(1+2+3+4)^("4 terms")' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\log_{ \left ( 1 + 2 + 3 + 4 \right ) }^{\text{4 terms}}'
        asciimath = 'log_(1 + 2 + 3 + 4)^("4 terms")'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mi>log</mi>
                <mrow>
                  <mn>1</mn>
                  <mo>+</mo>
                  <mn>2</mn>
                  <mo>+</mo>
                  <mn>3</mn>
                  <mo>+</mo>
                  <mn>4</mn>
                </mrow>
                <mtext>4 terms</mtext>
              </msubsup>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #10" do
      let(:string) { 'root1234(i)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\sqrt[1234]{i}'
        asciimath = 'root(1234)(i)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mroot>
                <mi>i</mi>
                <mn>1234</mn>
              </mroot>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #11" do
      let(:string) { 'overset(1234)(i)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\overset{1234}{i}'
        asciimath = 'overset(1234)(i)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mi>i</mi>
                <mn>1234</mn>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #12" do
      let(:string) { 'underset(1234)(i)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\underset{1234}{i}'
        asciimath = 'underset(1234)(i)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mi>i</mi>
                <mn>1234</mn>
              </munder>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #13" do
      let(:string) { 'sum_a sum^a sum_3^d prod_a prod^a prod_3^d' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\sum_{a} \sum^{a} \sum_{3}^{d} \prod_{a} \prod^{a} \prod_{3}^{d}'
        asciimath = 'sum_(a) sum^(a) sum_(3)^(d) prod_(a) prod^(a) prod_(3)^(d)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mo>&#x2211;</mo>
                <mi>a</mi>
              </munder>
              <mover>
                <mo>&#x2211;</mo>
                <mi>a</mi>
              </mover>
              <munderover>
                <mo>&#x2211;</mo>
                <mn>3</mn>
                <mi>d</mi>
              </munderover>
              <munder>
                <mo>&#x220f;</mo>
                <mi>a</mi>
              </munder>
              <mover>
                <mo>&#x220f;</mo>
                <mi>a</mi>
              </mover>
              <munderover>
                <mo>&#x220f;</mo>
                <mn>3</mn>
                <mi>d</mi>
              </munderover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #14" do
      let(:string) { 'underset1234(i)^3' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\underset{1234}{i}^{3}'
        asciimath = 'underset(1234)(i)^(3)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msup>
                <munder>
                  <mi>i</mi>
                  <mn>1234</mn>
                </munder>
                <mn>3</mn>
              </msup>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #15" do
      let(:string) { '12mod1234(i)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '{12} \mod {1234}  \left ( i \right ) '
        asciimath = '12 mod 1234 (i)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mn>12</mn>
                <mi>mod</mi>
                <mn>1234</mn>
              </mrow>
              <mrow>
                <mo>(</mo>
                <mi>i</mi>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #16" do
      let(:string) { 'sum^(theta)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\sum^{\theta}'
        asciimath = 'sum^(theta)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mo>&#x2211;</mo>
                <mi>&#x3b8;</mi>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #17" do
      let(:string) { 'log(1+2+3+4)^text("theta")' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\log  \left ( 1 + 2 + 3 + 4 \right ) ^{\text{"theta"}}'
        asciimath = 'log (1 + 2 + 3 + 4)^(""theta"")'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>log</mi>
              <msup>
                <mrow>
                  <mo>(</mo>
                  <mn>1</mn>
                  <mo>+</mo>
                  <mn>2</mn>
                  <mo>+</mo>
                  <mn>3</mn>
                  <mo>+</mo>
                  <mn>4</mn>
                  <mo>)</mo>
                </mrow>
                <mtext>"theta"</mtext>
              </msup>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #18" do
      let(:string) { 'sum_(i=1)^ni^3=sin((n(n+1))/2)^2' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\sum_{i = 1}^{n} i^{3} = \sin{ \left ( \frac{n  \left ( n + 1 \right ) }{2} \right ) }^{2}'
        asciimath = 'sum_(i = 1)^(n) i^(3) = sin(frac(n (n + 1))(2))^(2)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover>
                <mo>&#x2211;</mo>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mn>1</mn>
                </mrow>
                <mi>n</mi>
              </munderover>
              <msup>
                <mi>i</mi>
                <mn>3</mn>
              </msup>
              <mo>=</mo>
              <msup>
                <mrow>
                  <mi>sin</mi>
                  <mrow>
                    <mo>(</mo>
                    <mfrac>
                      <mrow>
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
                    <mo>)</mo>
                  </mrow>
                </mrow>
                <mn>2</mn>
              </msup>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #19" do
      let(:string) { 'int_0^1 f(x)dx' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\int_{0}^{1} f \left ( x \right )  d x'
        asciimath = 'int_(0)^(1) f(x) d x'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mo>&#x222b;</mo>
                <mn>0</mn>
                <mn>1</mn>
              </msubsup>
              <mrow>
                <mi>f</mi>
                <mrow>
                  <mo>(</mo>
                  <mi>x</mi>
                  <mo>)</mo>
                </mrow>
              </mrow>
              <mrow>
                <mi>d</mi>
                <mi>x</mi>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #20" do
      let(:string) { 'mathfrak"theta" (i)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\mathfrak{\text{theta}}  \left ( i \right ) '
        asciimath = 'mathfrak("theta") (i)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathvariant="fraktur">
                <mtext>theta</mtext>
              </mstyle>
              <mrow>
                <mo>(</mo>
                <mi>i</mi>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #21" do
      let(:string) { 'mathbb("theta") (i)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\mathbb{\text{theta}}  \left ( i \right ) '
        asciimath = 'mathbb("theta") (i)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathvariant="double-struck">
                <mtext>theta</mtext>
              </mstyle>
              <mrow>
                <mo>(</mo>
                <mi>i</mi>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #22" do
      let(:string) { 'left[[1,3], [1,3], [1,3]right] left(sum_prod^sigmaright)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\left [\begin{matrix}1 & 3 \\\\ 1 & 3 \\\\ 1 & 3\end{matrix}\right ] \left ( \sum_{\prod}^{\sigma} \right )'
        asciimath = '[[1, 3], [1, 3], [1, 3]] left( sum_(prod)^(sigma) right)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfenced open="[" close="]">
                <mtable>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd>
                      <mn>3</mn>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd>
                      <mn>3</mn>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd>
                      <mn>3</mn>
                    </mtd>
                  </mtr>
                </mtable>
              </mfenced>
              <mrow>
                <mo>(</mo>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mo>&#x220f;</mo>
                  <mi>&#x3c3;</mi>
                </munderover>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #23" do
      let(:string) { '540 xx 10^(12) "unitsml(Hz)", " "ii(K)_("cd")' }

      it 'returns parsed Asciimath to Formula' do
        latex = '540 \times 10^{12} \text{unitsml(Hz)} ,  \text{ } \mathit{K}_{\text{cd}}'
        asciimath = '540 xx 10^(12) "unitsml(Hz)" ,  " " ii(K)_("cd")'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>540</mn>
              <mo>&#xd7;</mo>
              <msup>
                <mn>10</mn>
                <mn>12</mn>
              </msup>
              <mtext>unitsml(Hz)</mtext>
              <mo>, </mo>
              <mtext> </mtext>
              <msub>
                <mstyle mathvariant="italic">
                  <mi>K</mi>
                </mstyle>
                <mtext>cd</mtext>
              </msub>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #24" do
      let(:string) { 'm = (8 ii(V))/(a_0^3) (2ii(R)_(oo)h)/(c ii(alpha)^2) (m_("Si"))/(m_"e")' }

      it 'returns parsed Asciimath to Formula' do
        latex = 'm = \frac{8 \mathit{V}}{a_{0}^{3}} \frac{2 \mathit{R}_{\infty} h}{c \mathit{\alpha}^{2}} \frac{m_{\text{Si}}}{m_{\text{e}}}'
        asciimath = 'm = frac(8 ii(V))(a_(0)^(3)) frac(2 ii(R)_(oo) h)(c ii(alpha)^(2)) frac(m_("Si"))(m_("e"))'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>m</mi>
              <mo>=</mo>
              <mfrac>
                <mrow>
                  <mn>8</mn>
                  <mstyle mathvariant="italic">
                    <mi>V</mi>
                  </mstyle>
                </mrow>
                <msubsup>
                  <mi>a</mi>
                  <mn>0</mn>
                  <mn>3</mn>
                </msubsup>
              </mfrac>
              <mfrac>
                <mrow>
                  <mn>2</mn>
                  <msub>
                    <mstyle mathvariant="italic">
                      <mi>R</mi>
                    </mstyle>
                    <mo>&#x221e;</mo>
                  </msub>
                  <mi>h</mi>
                </mrow>
                <mrow>
                  <mi>c</mi>
                  <msup>
                    <mstyle mathvariant="italic">
                      <mi>&#x3b1;</mi>
                    </mstyle>
                    <mn>2</mn>
                  </msup>
                </mrow>
              </mfrac>
              <mfrac>
                <msub>
                  <mi>m</mi>
                  <mtext>Si</mtext>
                </msub>
                <msub>
                  <mi>m</mi>
                  <mtext>e</mtext>
                </msub>
              </mfrac>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #25" do
      let(:string) { 'underset(_)(hat A)(^) = hat A exp j vartheta_0' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\underset{\_}{\hat{A}}  \left ( ^ \right )  = \hat{A} \exp{j} \vartheta_{0}'
        asciimath = 'underset(_)(hat(A)) (^) = hat(A) expj vartheta_(0)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mover>
                  <mi>A</mi>
                  <mo>^</mo>
                </mover>
                <mo>_</mo>
              </munder>
              <mrow>
                <mo>(</mo>
                <mo>^</mo>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <mover>
                <mi>A</mi>
                <mo>^</mo>
              </mover>
              <mrow>
                <mi>exp</mi>
                <mi>j</mi>
              </mrow>
              <msub>
                <mi>&#x3d1;</mi>
                <mn>0</mn>
              </msub>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #26" do
      let(:string) { 'x+b/(2a)<+-sqrt((b^2)/(4a^2)-c/a)' }

      it 'returns parsed Asciimath to Formula' do
        latex = 'x + \frac{b}{2 a} < \pm \sqrt{\frac{b^{2}}{4 a^{2}} - \frac{c}{a}}'
        asciimath = 'x + frac(b)(2 a) lt pm sqrt(frac(b^(2))(4 a^(2)) - frac(c)(a))'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>x</mi>
              <mo>+</mo>
              <mfrac>
                <mi>b</mi>
                <mrow>
                  <mn>2</mn>
                  <mi>a</mi>
                </mrow>
              </mfrac>
              <mo>&#x3c;</mo>
              <mo>&#xb1;</mo>
              <msqrt>
                <mrow>
                  <mfrac>
                    <msup>
                      <mi>b</mi>
                      <mn>2</mn>
                    </msup>
                    <mrow>
                      <mn>4</mn>
                      <msup>
                        <mi>a</mi>
                        <mn>2</mn>
                      </msup>
                    </mrow>
                  </mfrac>
                  <mo>&#x2212;</mo>
                  <mfrac>
                    <mi>c</mi>
                    <mi>a</mi>
                  </mfrac>
                </mrow>
              </msqrt>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #27" do
      let(:string) { 'm = (y_2 - y_1)/(x_2 - x_1) = (Deltay)/(Deltax)' }

      it 'returns parsed Asciimath to Formula' do
        latex = 'm = \frac{y_{2} - y_{1}}{x_{2} - x_{1}} = \frac{\Delta y}{\Delta x}'
        asciimath = 'm = frac(y_(2) - y_(1))(x_(2) - x_(1)) = frac(Delta y)(Delta x)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>m</mi>
              <mo>=</mo>
              <mfrac>
                <mrow>
                  <msub>
                    <mi>y</mi>
                    <mn>2</mn>
                  </msub>
                  <mo>&#x2212;</mo>
                  <msub>
                    <mi>y</mi>
                    <mn>1</mn>
                  </msub>
                </mrow>
                <mrow>
                  <msub>
                    <mi>x</mi>
                    <mn>2</mn>
                  </msub>
                  <mo>&#x2212;</mo>
                  <msub>
                    <mi>x</mi>
                    <mn>1</mn>
                  </msub>
                </mrow>
              </mfrac>
              <mo>=</mo>
              <mfrac>
                <mrow>
                  <mi>&#x394;</mi>
                  <mi>y</mi>
                </mrow>
                <mrow>
                  <mi>&#x394;</mi>
                  <mi>x</mi>
                </mrow>
              </mfrac>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #28" do
      let(:string) { 'd/dx [x^n] = nx^(n - 1)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\frac{d}{d x}  \left [ x^{n} \right ]  = n x^{n - 1}'
        asciimath = 'frac(d)(d x) [x^(n)] = n x^(n - 1)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfrac>
                <mi>d</mi>
                <mrow>
                  <mi>d</mi>
                  <mi>x</mi>
                </mrow>
              </mfrac>
              <mrow>
                <mo>[</mo>
                <msup>
                  <mi>x</mi>
                  <mi>n</mi>
                </msup>
                <mo>]</mo>
              </mrow>
              <mo>=</mo>
              <mi>n</mi>
              <msup>
                <mi>x</mi>
                <mrow>
                  <mi>n</mi>
                  <mo>&#x2212;</mo>
                  <mn>1</mn>
                </mrow>
              </msup>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #29" do
      let(:string) { 'hat(ab) bar(xy) ul(A) vec(v)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\hat{a b} \overline{x y} \underline{A} \vec{v}'
        asciimath = 'hat(a b) bar(x y) underline(A) vec(v)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mrow>
                  <mi>a</mi>
                  <mi>b</mi>
                </mrow>
                <mo>^</mo>
              </mover>
              <mover>
                <mrow>
                  <mi>x</mi>
                  <mi>y</mi>
                </mrow>
                <mo>&#xaf;</mo>
              </mover>
              <munder>
                <mi>A</mi>
                <mo>&#xaf;</mo>
              </munder>
              <mover>
                <mi>v</mi>
                <mo>&#x2192;</mo>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #30" do
      let(:string) { '((1),(42))' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\left (\begin{matrix}1 \\\\ 42\end{matrix}\right )'
        asciimath = '([1], [42])'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfenced open="(" close=")">
                <mtable>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mn>42</mn>
                    </mtd>
                  </mtr>
                </mtable>
              </mfenced>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #31" do
      let(:string) { '|(a,b),(c,d)|=ad-bc' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\left |\begin{matrix}a & b \\\\ c & d\end{matrix}\right | = a d - b c'
        asciimath = '|[a, b], [c, d]| = a d - b c'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfenced open="|" close="|">
                <mtable>
                  <mtr>
                    <mtd>
                      <mi>a</mi>
                    </mtd>
                    <mtd>
                      <mi>b</mi>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mi>c</mi>
                    </mtd>
                    <mtd>
                      <mi>d</mi>
                    </mtd>
                  </mtr>
                </mtable>
              </mfenced>
              <mo>=</mo>
              <mi>a</mi>
              <mi>d</mi>
              <mo>&#x2212;</mo>
              <mi>b</mi>
              <mi>c</mi>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #33" do
      let(:string) { '((a_(11), cdots , a_(1n)),(vdots, ddots, vdots),(a_(m1), cdots , a_(mn)))' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\left (\begin{matrix}a_{11} & \cdots & a_{1 n} \\\\ \vdots & \ddots & \vdots \\\\ a_{m 1} & \cdots & a_{m n}\end{matrix}\right )'
        asciimath = '([a_(11), cdots, a_(1 n)], [vdots, ddots, vdots], [a_(m 1), cdots, a_(m n)])'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfenced open="(" close=")">
                <mtable>
                  <mtr>
                    <mtd>
                      <msub>
                        <mi>a</mi>
                        <mn>11</mn>
                      </msub>
                    </mtd>
                    <mtd>
                      <mo>&#x22ef;</mo>
                    </mtd>
                    <mtd>
                      <msub>
                        <mi>a</mi>
                        <mrow>
                          <mn>1</mn>
                          <mi>n</mi>
                        </mrow>
                      </msub>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mo>&#x22ee;</mo>
                    </mtd>
                    <mtd>
                      <mo>&#x22f1;</mo>
                    </mtd>
                    <mtd>
                      <mo>&#x22ee;</mo>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <msub>
                        <mi>a</mi>
                        <mrow>
                          <mi>m</mi>
                          <mn>1</mn>
                        </mrow>
                      </msub>
                    </mtd>
                    <mtd>
                      <mo>&#x22ef;</mo>
                    </mtd>
                    <mtd>
                      <msub>
                        <mi>a</mi>
                        <mrow>
                          <mi>m</mi>
                          <mi>n</mi>
                        </mrow>
                      </msub>
                    </mtd>
                  </mtr>
                </mtable>
              </mfenced>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #34" do
      let(:string) { '"Скорость"=("Расстояние")/("Время")' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\text{Скорость} = \frac{\text{Расстояние}}{\text{Время}}'
        asciimath = '"Скорость" = frac("Расстояние")("Время")'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtext>Скорость</mtext>
              <mo>=</mo>
              <mfrac>
                <mtext>Расстояние</mtext>
                <mtext>Время</mtext>
              </mfrac>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #35" do
      let(:string) { 'bb (a + b) + cc c = fr (d^n)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\mathbf{a + b} + \mathcal{c} = \mathfrak{d^{n}}'
        asciimath = 'mathbf(a + b) + mathcal(c) = mathfrak(d^(n))'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathvariant="bold">
                <mrow>
                  <mi>a</mi>
                  <mo>+</mo>
                  <mi>b</mi>
                </mrow>
              </mstyle>
              <mo>+</mo>
              <mstyle mathvariant="script">
                <mi>c</mi>
              </mstyle>
              <mo>=</mo>
              <mstyle mathvariant="fraktur">
                <msup>
                  <mi>d</mi>
                  <mi>n</mi>
                </msup>
              </mstyle>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #36" do
      let(:string) { 'text("foo")' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\text{"foo"}'
        asciimath = '""foo""'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtext>"foo"</mtext>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #37" do
      let(:string) { 'ubrace(1 + 2) obrace(3 + 4' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\underbrace{1 + 2} \overbrace{3 + 4}'
        asciimath = 'ubrace(1 + 2) obrace(3 + 4)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mrow>
                  <mn>1</mn>
                  <mo>+</mo>
                  <mn>2</mn>
                </mrow>
                <mo>&#x23df;</mo>
              </munder>
              <mover>
                <mrow>
                  <mn>3</mn>
                  <mo>+</mo>
                  <mn>4</mn>
                </mrow>
                <mo>&#x23de;</mo>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #38" do
      let(:string) { 's\'_i = {(- 1, if s_i > s_(i + 1)),( + 1, if s_i <= s_(i + 1)):}' }

      it 'returns parsed Asciimath to Formula' do
        latex = 's \'_{i} = \left \{\begin{matrix}- 1 & \operatorname{if} s_{i} > s_{i + 1} \\\\ + 1 & \operatorname{if} s_{i} \le s_{i + 1}\end{matrix}\right  .'
        asciimath = 's \'_(i) = {[- 1, if s_(i) gt s_(i + 1)], [+ 1, if s_(i) le s_(i + 1)]:}'
        mathml = <<~MATHML
          <math display="block" xmlns="http://www.w3.org/1998/Math/MathML">
            <mstyle displaystyle="true">
              <mi>s</mi>
              <msub>
                <mi>&#x27;</mi>
                <mi>i</mi>
              </msub>
              <mo>=</mo>
              <mfenced close="" open="{">
                <mtable>
                  <mtr>
                    <mtd>
                      <mo>&#x2212;</mo>
                      <mn>1</mn>
                    </mtd>
                    <mtd>
                      <mo>if</mo>
                      <msub>
                        <mi>s</mi>
                        <mi>i</mi>
                      </msub>
                      <mo>&#x3e;</mo>
                      <msub>
                        <mi>s</mi>
                        <mrow>
                          <mi>i</mi>
                          <mo>+</mo>
                          <mn>1</mn>
                        </mrow>
                      </msub>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mo>+</mo>
                      <mn>1</mn>
                    </mtd>
                    <mtd>
                      <mo>if</mo>
                      <msub>
                        <mi>s</mi>
                        <mi>i</mi>
                      </msub>
                      <mo>&#x2264;</mo>
                      <msub>
                        <mi>s</mi>
                        <mrow>
                          <mi>i</mi>
                          <mo>+</mo>
                          <mn>1</mn>
                        </mrow>
                      </msub>
                    </mtd>
                  </mtr>
                </mtable>
              </mfenced>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #39" do
      let(:string) { 'overset(a + b)(c + d)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\overset{ \left ( a + b \right ) }{ \left ( c + d \right ) }'
        asciimath = 'overset(a + b)(c + d)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mrow>
                  <mi>c</mi>
                  <mo>+</mo>
                  <mi>d</mi>
                </mrow>
                <mrow>
                  <mi>a</mi>
                  <mo>+</mo>
                  <mi>b</mi>
                </mrow>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #40" do
      let(:string) { 'underset a b' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\underset{a}{b}'
        asciimath = 'underset(a)(b)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mi>a</mi>
                <mi>b</mi>
              </munder>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #41" do
      let(:string) { 'cancel(a_b^c) cancel a_b^c' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\cancel{a_{b}^{c}} \cancel{a}_{b}^{c}'
        asciimath = 'cancel(a_(b)^(c)) cancel(a)_(b)^(c)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <menclose notation="updiagonalstrike">
                <msubsup>
                  <mi>a</mi>
                  <mi>b</mi>
                  <mi>c</mi>
                </msubsup>
              </menclose>
              <msubsup>
                <menclose notation="updiagonalstrike">
                  <mi>a</mi>
                </menclose>
                <mi>b</mi>
                <mi>c</mi>
              </msubsup>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #42" do
      let(:string) { 'color(red)(x) color(red)(y) color(blue)(z) colortext(blue)(a_b^c)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '{\color{red} x} {\color{red} y} {\color{blue} z} {\color{blue} a_{b}^{c}}'
        asciimath = 'color(red)(x) color(red)(y) color(blue)(z) color(blue)(a_(b)^(c))'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathcolor="red">
                <mi>x</mi>
              </mstyle>
              <mstyle mathcolor="red">
                <mi>y</mi>
              </mstyle>
              <mstyle mathcolor="blue">
                <mi>z</mi>
              </mstyle>
              <mstyle mathcolor="blue">
                <msubsup>
                  <mi>a</mi>
                  <mi>b</mi>
                  <mi>c</mi>
                </msubsup>
              </mstyle>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #43" do
      let(:string) { '{ x\ : \ x in A ^^ x in B }' }

      it 'returns parsed Asciimath to Formula' do
        latex = ' \left \{ x \  : \  x \in A \land x \in B \right \} '
        asciimath = '{x \  : \  x in A ^^ x in B}'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>{</mo>
                <mi>x</mi>
                <mi>&#xA0;</mi>
                <mo>&#x3a;</mo>
                <mi>&#xA0;</mi>
                <mi>x</mi>
                <mo>&#x2208;</mo>
                <mi>A</mi>
                <mo>&#x2227;</mo>
                <mi>x</mi>
                <mo>&#x2208;</mo>
                <mi>B</mi>
                <mo>}</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #44" do
      let(:string) { '[[a,b,|,c],[d,e,|,f]]' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\left [\begin{matrix}a & b & | & c \\\\ d & e & | & f\end{matrix}\right ]'
        asciimath = '[[a, b, |, c], [d, e, |, f]]'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfenced open="[" close="]">
                <mtable>
                  <mtr>
                    <mtd>
                      <mi>a</mi>
                    </mtd>
                    <mtd>
                      <mi>b</mi>
                    </mtd>
                    <mtd>
                      <mo>&#x7c;</mo>
                    </mtd>
                    <mtd>
                      <mi>c</mi>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mi>d</mi>
                    </mtd>
                    <mtd>
                      <mi>e</mi>
                    </mtd>
                    <mtd>
                      <mo>&#x7c;</mo>
                    </mtd>
                    <mtd>
                      <mrow>
                        <mi>f</mi>
                      </mrow>
                    </mtd>
                  </mtr>
                </mtable>
              </mfenced>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #45" do
      let(:string) { 'ubrace(((1, 0),(0, 1)))_("Adjustment to texture space")' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\underbrace{\left (\begin{matrix}1 & 0 \\\\ 0 & 1\end{matrix}\right )}_{\text{Adjustment to texture space}}'
        asciimath = 'ubrace(([1, 0], [0, 1]))_("Adjustment to texture space")'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <munder>
                  <mfenced open="(" close=")">
                    <mtable>
                      <mtr>
                        <mtd>
                          <mn>1</mn>
                        </mtd>
                        <mtd>
                          <mn>0</mn>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <mn>0</mn>
                        </mtd>
                        <mtd>
                          <mn>1</mn>
                        </mtd>
                      </mtr>
                    </mtable>
                  </mfenced>
                  <mo>&#x23df;</mo>
                </munder>
                <mtext>Adjustment to texture space</mtext>
              </munder>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #46" do
      let(:string) { 'ii(V)(ii(X)) = (b-a)^2/12 + d^2/9.' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\mathit{V}  \left ( \mathit{X} \right )  = \frac{ \left ( b - a \right ) ^{2}}{12} + \frac{d^{2}}{9} .'
        asciimath = 'ii(V) (ii(X)) = frac((b - a)^(2))(12) + frac(d^(2))(9) .'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathvariant="italic">
                <mi>V</mi>
              </mstyle>
              <mrow>
                <mo>(</mo>
                <mstyle mathvariant="italic">
                  <mi>X</mi>
                </mstyle>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <mfrac>
                <msup>
                  <mrow>
                    <mo>(</mo>
                    <mi>b</mi>
                    <mo>&#x2212;</mo>
                    <mi>a</mi>
                    <mo>)</mo>
                  </mrow>
                  <mn>2</mn>
                </msup>
                <mn>12</mn>
              </mfrac>
              <mo>+</mo>
              <mfrac>
                <msup>
                  <mi>d</mi>
                  <mn>2</mn>
                </msup>
                <mn>9</mn>
              </mfrac>
              <mo>&#xb7;</mo>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #47" do
      let(:string) { '"CO"_2" (aq.) "+ "H"_2"O" overset(larr)(rarr) "HCO"_3^(-) + "H"^(+) " log "ii(K) = -6.38 80_{0}^{+2}' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\text{CO}_{2} \text{ (aq.) } + \text{H}_{2} \text{O} \overset{\gets}{\to} \text{HCO}_{3}^{-} + \text{H}^{+} \text{ log } \mathit{K} = - 6.38 80_{0}^{+ 2}'
        asciimath = '"CO"_(2) " (aq.) " + "H"_(2) "O" overset(larr)(to) "HCO"_(3)^(-) + "H"^(+) " log " ii(K) = - 6.38 80_(0)^(+ 2)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mtext>CO</mtext>
                <mn>2</mn>
              </msub>
              <mtext> (aq.) </mtext>
              <mo>+</mo>
              <msub>
                <mtext>H</mtext>
                <mn>2</mn>
              </msub>
              <mtext>O</mtext>
              <mover>
                <mo>&#x2192;</mo>
                <mo>&#x2190;</mo>
              </mover>
              <msubsup>
                <mtext>HCO</mtext>
                <mn>3</mn>
                <mo>&#x2212;</mo>
              </msubsup>
              <mo>+</mo>
              <msup>
                <mtext>H</mtext>
                <mo>+</mo>
              </msup>
              <mtext> log </mtext>
              <mstyle mathvariant="italic">
                <mi>K</mi>
              </mstyle>
              <mo>=</mo>
              <mo>&#x2212;</mo>
              <mn>6.38</mn>
              <msubsup>
                <mn>80</mn>
                <mn>0</mn>
                <mrow>
                  <mo>+</mo>
                  <mn>2</mn>
                </mrow>
              </msubsup>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #48" do
      let(:string) { 'u(w_("cal")) = w_("cal") *sqrt([(u(m_("stock")))/m_("stock")]^2 +[(u(b_("stock")))/b_("stock")]^2 +[(u(w_("stock")))/w_("stock")]^2 +[(u(m_("sol")))/m_("sol")]^2 +[(u(b_("sol")))/b_("sol")]^2 +2*[(u(ii(V)))/ii(V)]^2)' }

      it 'returns parsed Asciimath to Formula' do
        latex = 'u  \left ( w_{\text{cal}} \right )  = w_{\text{cal}} \cdot \sqrt{ \left [ \frac{u  \left ( m_{\text{stock}} \right ) }{m_{\text{stock}}} \right ] ^{2} +  \left [ \frac{u  \left ( b_{\text{stock}} \right ) }{b_{\text{stock}}} \right ] ^{2} +  \left [ \frac{u  \left ( w_{\text{stock}} \right ) }{w_{\text{stock}}} \right ] ^{2} +  \left [ \frac{u  \left ( m_{\text{sol}} \right ) }{m_{\text{sol}}} \right ] ^{2} +  \left [ \frac{u  \left ( b_{\text{sol}} \right ) }{b_{\text{sol}}} \right ] ^{2} + 2 \cdot  \left [ \frac{u  \left ( \mathit{V} \right ) }{\mathit{V}} \right ] ^{2}}'
        asciimath = 'u (w_("cal")) = w_("cal") * sqrt([frac(u (m_("stock")))(m_("stock"))]^(2) + [frac(u (b_("stock")))(b_("stock"))]^(2) + [frac(u (w_("stock")))(w_("stock"))]^(2) + [frac(u (m_("sol")))(m_("sol"))]^(2) + [frac(u (b_("sol")))(b_("sol"))]^(2) + 2 * [frac(u (ii(V)))(ii(V))]^(2))'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>u</mi>
              <mrow>
                <mo>(</mo>
                <msub>
                  <mi>w</mi>
                  <mtext>cal</mtext>
                </msub>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <msub>
                <mi>w</mi>
                <mtext>cal</mtext>
              </msub>
              <mo>&#x22c5;</mo>
              <msqrt>
                <mrow>
                  <msup>
                    <mrow>
                      <mo>[</mo>
                      <mfrac>
                        <mrow>
                          <mi>u</mi>
                          <mrow>
                            <mo>(</mo>
                            <msub>
                              <mi>m</mi>
                              <mtext>stock</mtext>
                            </msub>
                            <mo>)</mo>
                          </mrow>
                        </mrow>
                        <msub>
                          <mi>m</mi>
                          <mtext>stock</mtext>
                        </msub>
                      </mfrac>
                      <mo>]</mo>
                    </mrow>
                    <mn>2</mn>
                  </msup>
                  <mo>+</mo>
                  <msup>
                    <mrow>
                      <mo>[</mo>
                      <mfrac>
                        <mrow>
                          <mi>u</mi>
                          <mrow>
                            <mo>(</mo>
                            <msub>
                              <mi>b</mi>
                              <mtext>stock</mtext>
                            </msub>
                            <mo>)</mo>
                          </mrow>
                        </mrow>
                        <msub>
                          <mi>b</mi>
                          <mtext>stock</mtext>
                        </msub>
                      </mfrac>
                      <mo>]</mo>
                    </mrow>
                    <mn>2</mn>
                  </msup>
                  <mo>+</mo>
                  <msup>
                    <mrow>
                      <mo>[</mo>
                      <mfrac>
                        <mrow>
                          <mi>u</mi>
                          <mrow>
                            <mo>(</mo>
                            <msub>
                              <mi>w</mi>
                              <mtext>stock</mtext>
                            </msub>
                            <mo>)</mo>
                          </mrow>
                        </mrow>
                        <msub>
                          <mi>w</mi>
                          <mtext>stock</mtext>
                        </msub>
                      </mfrac>
                      <mo>]</mo>
                    </mrow>
                    <mn>2</mn>
                  </msup>
                  <mo>+</mo>
                  <msup>
                    <mrow>
                      <mo>[</mo>
                      <mfrac>
                        <mrow>
                          <mi>u</mi>
                          <mrow>
                            <mo>(</mo>
                            <msub>
                              <mi>m</mi>
                              <mtext>sol</mtext>
                            </msub>
                            <mo>)</mo>
                          </mrow>
                        </mrow>
                        <msub>
                          <mi>m</mi>
                          <mtext>sol</mtext>
                        </msub>
                      </mfrac>
                      <mo>]</mo>
                    </mrow>
                    <mn>2</mn>
                  </msup>
                  <mo>+</mo>
                  <msup>
                    <mrow>
                      <mo>[</mo>
                      <mfrac>
                        <mrow>
                          <mi>u</mi>
                          <mrow>
                            <mo>(</mo>
                            <msub>
                              <mi>b</mi>
                              <mtext>sol</mtext>
                            </msub>
                            <mo>)</mo>
                          </mrow>
                        </mrow>
                        <msub>
                          <mi>b</mi>
                          <mtext>sol</mtext>
                        </msub>
                      </mfrac>
                      <mo>]</mo>
                    </mrow>
                    <mn>2</mn>
                  </msup>
                  <mo>+</mo>
                  <mn>2</mn>
                  <mo>&#x22c5;</mo>
                  <msup>
                    <mrow>
                      <mo>[</mo>
                      <mfrac>
                        <mrow>
                          <mi>u</mi>
                          <mrow>
                            <mo>(</mo>
                            <mstyle mathvariant="italic">
                              <mi>V</mi>
                            </mstyle>
                            <mo>)</mo>
                          </mrow>
                        </mrow>
                        <mstyle mathvariant="italic">
                          <mi>V</mi>
                        </mstyle>
                      </mfrac>
                      <mo>]</mo>
                    </mrow>
                    <mn>2</mn>
                  </msup>
                </mrow>
              </msqrt>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #49" do
      let(:string) { '1 "unitsml(A)" = ( ((4pi xx 10^(-7)))/((9192631770)(299792458)(1)) )^(1/2) ( (Delta ii(nu)_("Cs")cm_(cc K))/(ii(mu)_0) )^(1/2) = 6.789687... xx 10^(-13) ((Delta ii(nu)_("Cs")c m_(cc K))/(ii(mu)_0))^(1/2)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '1 \text{unitsml(A)} =  \left ( \frac{\left (\begin{matrix}4 \pi \times 10^{- 7}\end{matrix}\right )}{ \left ( 9192631770 \right )   \left ( 299792458 \right )   \left ( 1 \right ) } \right ) ^{\frac{1}{2}}  \left ( \frac{\Delta \mathit{\nu}_{\text{Cs}} c m_{\mathcal{K}}}{\mathit{\mu}_{0}} \right ) ^{\frac{1}{2}} = 6.789687 \ldots \times 10^{- 13}  \left ( \frac{\Delta \mathit{\nu}_{\text{Cs}} c m_{\mathcal{K}}}{\mathit{\mu}_{0}} \right ) ^{\frac{1}{2}}'
        asciimath = '1 "unitsml(A)" = (frac(([4 pi xx 10^(- 7)]))((9192631770) (299792458) (1)))^(frac(1)(2)) (frac(Delta ii(nu)_("Cs") c m_(mathcal(K)))(ii(mu)_(0)))^(frac(1)(2)) = 6.789687 ... xx 10^(- 13) (frac(Delta ii(nu)_("Cs") c m_(mathcal(K)))(ii(mu)_(0)))^(frac(1)(2))'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>1</mn>
              <mtext>unitsml(A)</mtext>
              <mo>=</mo>
              <msup>
                <mrow>
                  <mo>(</mo>
                  <mfrac>
                    <mfenced open="(" close=")">
                      <mtable>
                        <mtr>
                          <mtd>
                            <mn>4</mn>
                            <mi>&#x3c0;</mi>
                            <mo>&#xd7;</mo>
                            <msup>
                              <mn>10</mn>
                              <mrow>
                                <mo>&#x2212;</mo>
                                <mn>7</mn>
                              </mrow>
                            </msup>
                          </mtd>
                        </mtr>
                      </mtable>
                    </mfenced>
                    <mrow>
                      <mrow>
                        <mo>(</mo>
                        <mn>9192631770</mn>
                        <mo>)</mo>
                      </mrow>
                      <mrow>
                        <mo>(</mo>
                        <mn>299792458</mn>
                        <mo>)</mo>
                      </mrow>
                      <mrow>
                        <mo>(</mo>
                        <mn>1</mn>
                        <mo>)</mo>
                      </mrow>
                    </mrow>
                  </mfrac>
                  <mo>)</mo>
                </mrow>
                <mfrac>
                  <mn>1</mn>
                  <mn>2</mn>
                </mfrac>
              </msup>
              <msup>
                <mrow>
                  <mo>(</mo>
                  <mfrac>
                    <mrow>
                      <mi>&#x394;</mi>
                      <msub>
                        <mstyle mathvariant="italic">
                          <mi>&#x3bd;</mi>
                        </mstyle>
                        <mtext>Cs</mtext>
                      </msub>
                      <mi>c</mi>
                      <msub>
                        <mi>m</mi>
                        <mstyle mathvariant="script">
                          <mi>K</mi>
                        </mstyle>
                      </msub>
                    </mrow>
                    <msub>
                      <mstyle mathvariant="italic">
                        <mi>&#x3bc;</mi>
                      </mstyle>
                      <mn>0</mn>
                    </msub>
                  </mfrac>
                  <mo>)</mo>
                </mrow>
                <mfrac>
                  <mn>1</mn>
                  <mn>2</mn>
                </mfrac>
              </msup>
              <mo>=</mo>
              <mn>6.789687</mn>
              <mo>&#x2026;</mo>
              <mo>&#xd7;</mo>
              <msup>
                <mn>10</mn>
                <mrow>
                  <mo>&#x2212;</mo>
                  <mn>13</mn>
                </mrow>
              </msup>
              <msup>
                <mrow>
                  <mo>(</mo>
                  <mfrac>
                    <mrow>
                      <mi>&#x394;</mi>
                      <msub>
                        <mstyle mathvariant="italic">
                          <mi>&#x3bd;</mi>
                        </mstyle>
                        <mtext>Cs</mtext>
                      </msub>
                      <mi>c</mi>
                      <msub>
                        <mi>m</mi>
                        <mstyle mathvariant="script">
                          <mi>K</mi>
                        </mstyle>
                      </msub>
                    </mrow>
                    <msub>
                      <mstyle mathvariant="italic">
                        <mi>&#x3bc;</mi>
                      </mstyle>
                      <mn>0</mn>
                    </msub>
                  </mfrac>
                  <mo>)</mo>
                </mrow>
                <mfrac>
                  <mn>1</mn>
                  <mn>2</mn>
                </mfrac>
              </msup>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #50" do
      let(:string) { '""_rZZ_n = sum_(j=1)^n (-1)^j j^r, " with " r = 1,2,...,' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\text{}_{r} \mathbb{Z}_{n} = \sum_{j = 1}^{n}  \left ( - 1 \right ) ^{j} j^{r} ,  \text{ with } r = 1 , 2 , \ldots ,'
        asciimath = '""_(r) mathbb(Z)_(n) = sum_(j = 1)^(n) (- 1)^(j) j^(r) ,  " with " r = 1 , 2 , ... ,'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mtext></mtext>
                <mi>r</mi>
              </msub>
              <msub>
                <mstyle mathvariant="double-struck">
                  <mi>Z</mi>
                </mstyle>
                <mi>n</mi>
              </msub>
              <mo>=</mo>
              <munderover>
                <mo>&#x2211;</mo>
                <mrow>
                  <mi>j</mi>
                  <mo>=</mo>
                  <mn>1</mn>
                </mrow>
                <mi>n</mi>
              </munderover>
              <msup>
                <mrow>
                  <mo>(</mo>
                  <mo>&#x2212;</mo>
                  <mn>1</mn>
                  <mo>)</mo>
                </mrow>
                <mi>j</mi>
              </msup>
              <msup>
                <mi>j</mi>
                <mi>r</mi>
              </msup>
              <mo>, </mo>
              <mtext> with </mtext>
              <mi>r</mi>
              <mo>=</mo>
              <mn>1</mn>
              <mo>,</mo>
              <mn>2</mn>
              <mo>,</mo>
              <mo>&#x2026;</mo>
              <mo>,</mo>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #51" do
      let(:string) { '(ii(T)_1+ii(T)_2-a_1-a_2)*f(t) = {(0,pour,{(0&#x3c;t&#x3c;a_(-)),("ou "t&#x3e;ii(T)_(-)+a_2):}),(1,"''",{(a_(-)&#x3c;t&#x3c;a_+","),(ii(T)_1-a_1&#x3c;t&#x3c;ii(T)_(-)),("ou "ii(T)_1&#x3c;t&#x3c;ii(T)_(-)+a_2):}),(2,"''",a_+&#x3c;t&#x3c;ii(T)_1-a_1),((ii(T)_3-ii(T)_(-)+a_1)*delta(t-ii(T)_1),pour,t=ii(T)_1),((ii(T)_1-ii(T)_4)*delta(t-ii(T)_2),"''",t=ii(T)_2","):}' }

      it 'returns parsed Asciimath to Formula' do
        latex = ' \left ( \mathit{T}_{1} + \mathit{T}_{2} - a_{1} - a_{2} \right )  \cdot f \left ( t \right )  = \left \{\begin{matrix}0 & p o u r & \left \{\begin{matrix}0 \& \# x 3 c ; t \& \# x 3 c ; a_{-} \\\\ \text{ou } t \& \# x 3 e ; \mathit{T}_{-} + a_{2}\end{matrix}\right  . \\\\ 1 & \text{} & \left \{\begin{matrix}a_{-} \& \# x 3 c ; t \& \# x 3 c ; a_{+} \text{,} \\\\ \mathit{T}_{1} - a_{1} \& \# x 3 c ; t \& \# x 3 c ; \mathit{T}_{-} \\\\ \text{ou } \mathit{T}_{1} \& \# x 3 c ; t \& \# x 3 c ; \mathit{T}_{-} + a_{2}\end{matrix}\right  . \\\\ 2 & \text{} & a_{+} \& \# x 3 c ; t \& \# x 3 c ; \mathit{T}_{1} - a_{1} \\\\  \left ( \mathit{T}_{3} - \mathit{T}_{-} + a_{1} \right )  \cdot \delta  \left ( t - \mathit{T}_{1} \right )  & p o u r & t = \mathit{T}_{1} \\\\  \left ( \mathit{T}_{1} - \mathit{T}_{4} \right )  \cdot \delta  \left ( t - \mathit{T}_{2} \right )  & \text{} & t = \mathit{T}_{2} \text{,}\end{matrix}\right  .'
        asciimath = '(ii(T)_(1) + ii(T)_(2) - a_(1) - a_(2)) * f(t) = {[0, p o u r, {[0 & # x 3 c ; t & # x 3 c ; a_(-)], ["ou " t & # x 3 e ; ii(T)_(-) + a_(2)]:}], [1, "", {[a_(-) & # x 3 c ; t & # x 3 c ; a_(+) ","], [ii(T)_(1) - a_(1) & # x 3 c ; t & # x 3 c ; ii(T)_(-)], ["ou " ii(T)_(1) & # x 3 c ; t & # x 3 c ; ii(T)_(-) + a_(2)]:}], [2, "", a_(+) & # x 3 c ; t & # x 3 c ; ii(T)_(1) - a_(1)], [(ii(T)_(3) - ii(T)_(-) + a_(1)) * delta (t - ii(T)_(1)), p o u r, t = ii(T)_(1)], [(ii(T)_(1) - ii(T)_(4)) * delta (t - ii(T)_(2)), "", t = ii(T)_(2) ","]:}'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>(</mo>
                <msub>
                  <mstyle mathvariant="italic">
                    <mi>T</mi>
                  </mstyle>
                  <mn>1</mn>
                </msub>
                <mo>+</mo>
                <msub>
                  <mstyle mathvariant="italic">
                    <mi>T</mi>
                  </mstyle>
                  <mn>2</mn>
                </msub>
                <mo>&#x2212;</mo>
                <msub>
                  <mi>a</mi>
                  <mn>1</mn>
                </msub>
                <mo>&#x2212;</mo>
                <msub>
                  <mi>a</mi>
                  <mn>2</mn>
                </msub>
                <mo>)</mo>
              </mrow>
              <mo>&#x22c5;</mo>
              <mrow>
                <mi>f</mi>
                <mrow>
                  <mo>(</mo>
                  <mi>t</mi>
                  <mo>)</mo>
                </mrow>
              </mrow>
              <mo>=</mo>
              <mfenced open="{" close="">
                <mtable>
                  <mtr>
                    <mtd>
                      <mn>0</mn>
                    </mtd>
                    <mtd>
                      <mi>p</mi>
                      <mi>o</mi>
                      <mi>u</mi>
                      <mi>r</mi>
                    </mtd>
                    <mtd>
                      <mfenced open="{" close="">
                        <mtable>
                          <mtr>
                            <mtd>
                              <mn>0</mn>
                              <mo>&#x26;</mo>
                              <mi>&#x23;</mi>
                              <mi>x</mi>
                              <mn>3</mn>
                              <mi>c</mi>
                              <mo>&#x3b;</mo>
                              <mi>t</mi>
                              <mo>&#x26;</mo>
                              <mi>&#x23;</mi>
                              <mi>x</mi>
                              <mn>3</mn>
                              <mi>c</mi>
                              <mo>&#x3b;</mo>
                              <msub>
                                <mi>a</mi>
                                <mo>&#x2212;</mo>
                              </msub>
                            </mtd>
                          </mtr>
                          <mtr>
                            <mtd>
                              <mtext>ou </mtext>
                              <mi>t</mi>
                              <mo>&#x26;</mo>
                              <mi>&#x23;</mi>
                              <mi>x</mi>
                              <mn>3</mn>
                              <mi>e</mi>
                              <mo>&#x3b;</mo>
                              <msub>
                                <mstyle mathvariant="italic">
                                  <mi>T</mi>
                                </mstyle>
                                <mo>&#x2212;</mo>
                              </msub>
                              <mo>+</mo>
                              <msub>
                                <mi>a</mi>
                                <mn>2</mn>
                              </msub>
                            </mtd>
                          </mtr>
                        </mtable>
                      </mfenced>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd>
                      <mtext></mtext>
                    </mtd>
                    <mtd>
                      <mfenced open="{" close="">
                        <mtable>
                          <mtr>
                            <mtd>
                              <msub>
                                <mi>a</mi>
                                <mo>&#x2212;</mo>
                              </msub>
                              <mo>&#x26;</mo>
                              <mi>&#x23;</mi>
                              <mi>x</mi>
                              <mn>3</mn>
                              <mi>c</mi>
                              <mo>&#x3b;</mo>
                              <mi>t</mi>
                              <mo>&#x26;</mo>
                              <mi>&#x23;</mi>
                              <mi>x</mi>
                              <mn>3</mn>
                              <mi>c</mi>
                              <mo>&#x3b;</mo>
                              <msub>
                                <mi>a</mi>
                                <mo>+</mo>
                              </msub>
                              <mtext>,</mtext>
                            </mtd>
                          </mtr>
                          <mtr>
                            <mtd>
                              <msub>
                                <mstyle mathvariant="italic">
                                  <mi>T</mi>
                                </mstyle>
                                <mn>1</mn>
                              </msub>
                              <mo>&#x2212;</mo>
                              <msub>
                                <mi>a</mi>
                                <mn>1</mn>
                              </msub>
                              <mo>&#x26;</mo>
                              <mi>&#x23;</mi>
                              <mi>x</mi>
                              <mn>3</mn>
                              <mi>c</mi>
                              <mo>&#x3b;</mo>
                              <mi>t</mi>
                              <mo>&#x26;</mo>
                              <mi>&#x23;</mi>
                              <mi>x</mi>
                              <mn>3</mn>
                              <mi>c</mi>
                              <mo>&#x3b;</mo>
                              <msub>
                                <mstyle mathvariant="italic">
                                  <mi>T</mi>
                                </mstyle>
                                <mo>&#x2212;</mo>
                              </msub>
                            </mtd>
                          </mtr>
                          <mtr>
                            <mtd>
                              <mtext>ou </mtext>
                              <msub>
                                <mstyle mathvariant="italic">
                                  <mi>T</mi>
                                </mstyle>
                                <mn>1</mn>
                              </msub>
                              <mo>&#x26;</mo>
                              <mi>&#x23;</mi>
                              <mi>x</mi>
                              <mn>3</mn>
                              <mi>c</mi>
                              <mo>&#x3b;</mo>
                              <mi>t</mi>
                              <mo>&#x26;</mo>
                              <mi>&#x23;</mi>
                              <mi>x</mi>
                              <mn>3</mn>
                              <mi>c</mi>
                              <mo>&#x3b;</mo>
                              <msub>
                                <mstyle mathvariant="italic">
                                  <mi>T</mi>
                                </mstyle>
                                <mo>&#x2212;</mo>
                              </msub>
                              <mo>+</mo>
                              <msub>
                                <mi>a</mi>
                                <mn>2</mn>
                              </msub>
                            </mtd>
                          </mtr>
                        </mtable>
                      </mfenced>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mn>2</mn>
                    </mtd>
                    <mtd>
                      <mtext></mtext>
                    </mtd>
                    <mtd>
                      <msub>
                        <mi>a</mi>
                        <mo>+</mo>
                      </msub>
                      <mo>&#x26;</mo>
                      <mi>&#x23;</mi>
                      <mi>x</mi>
                      <mn>3</mn>
                      <mi>c</mi>
                      <mo>&#x3b;</mo>
                      <mi>t</mi>
                      <mo>&#x26;</mo>
                      <mi>&#x23;</mi>
                      <mi>x</mi>
                      <mn>3</mn>
                      <mi>c</mi>
                      <mo>&#x3b;</mo>
                      <msub>
                        <mstyle mathvariant="italic">
                          <mi>T</mi>
                        </mstyle>
                        <mn>1</mn>
                      </msub>
                      <mo>&#x2212;</mo>
                      <msub>
                        <mi>a</mi>
                        <mn>1</mn>
                      </msub>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mrow>
                        <mo>(</mo>
                        <msub>
                          <mstyle mathvariant="italic">
                            <mi>T</mi>
                          </mstyle>
                          <mn>3</mn>
                        </msub>
                        <mo>&#x2212;</mo>
                        <msub>
                          <mstyle mathvariant="italic">
                            <mi>T</mi>
                          </mstyle>
                          <mo>&#x2212;</mo>
                        </msub>
                        <mo>+</mo>
                        <msub>
                          <mi>a</mi>
                          <mn>1</mn>
                        </msub>
                        <mo>)</mo>
                      </mrow>
                      <mo>&#x22c5;</mo>
                      <mi>&#x3b4;</mi>
                      <mrow>
                        <mo>(</mo>
                        <mi>t</mi>
                        <mo>&#x2212;</mo>
                        <msub>
                          <mstyle mathvariant="italic">
                            <mi>T</mi>
                          </mstyle>
                          <mn>1</mn>
                        </msub>
                        <mo>)</mo>
                      </mrow>
                    </mtd>
                    <mtd>
                      <mi>p</mi>
                      <mi>o</mi>
                      <mi>u</mi>
                      <mi>r</mi>
                    </mtd>
                    <mtd>
                      <mi>t</mi>
                      <mo>=</mo>
                      <msub>
                        <mstyle mathvariant="italic">
                          <mi>T</mi>
                        </mstyle>
                        <mn>1</mn>
                      </msub>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mrow>
                        <mo>(</mo>
                        <msub>
                          <mstyle mathvariant="italic">
                            <mi>T</mi>
                          </mstyle>
                          <mn>1</mn>
                        </msub>
                        <mo>&#x2212;</mo>
                        <msub>
                          <mstyle mathvariant="italic">
                            <mi>T</mi>
                          </mstyle>
                          <mn>4</mn>
                        </msub>
                        <mo>)</mo>
                      </mrow>
                      <mo>&#x22c5;</mo>
                      <mi>&#x3b4;</mi>
                      <mrow>
                        <mo>(</mo>
                        <mi>t</mi>
                        <mo>&#x2212;</mo>
                        <msub>
                          <mstyle mathvariant="italic">
                            <mi>T</mi>
                          </mstyle>
                          <mn>2</mn>
                        </msub>
                        <mo>)</mo>
                      </mrow>
                    </mtd>
                    <mtd>
                      <mtext></mtext>
                    </mtd>
                    <mtd>
                      <mi>t</mi>
                      <mo>=</mo>
                      <msub>
                        <mstyle mathvariant="italic">
                          <mi>T</mi>
                        </mstyle>
                        <mn>2</mn>
                      </msub>
                      <mtext>,</mtext>
                    </mtd>
                  </mtr>
                </mtable>
              </mfenced>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #52" do
      let(:string) { 'ul (ii(B)) = [[1,,,,], [1,1,,,], [1,2,1,,], [color(red)(1),color(red)(3),color(red)(3),color(red)(1),], [1,4,6,4,1], [,,...,,]]' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\underline{\mathit{B}} = \left [\begin{matrix}1 &  &  &  &  \\\\ 1 & 1 &  &  &  \\\\ 1 & 2 & 1 &  &  \\\\ {\color{red} 1} & {\color{red} 3} & {\color{red} 3} & {\color{red} 1} &  \\\\ 1 & 4 & 6 & 4 & 1 \\\\  &  & \ldots &  & \end{matrix}\right ]'
        asciimath = 'underline(ii(B)) = [[1, , , , ], [1, 1, , , ], [1, 2, 1, , ], [color(red)(1), color(red)(3), color(red)(3), color(red)(1), ], [1, 4, 6, 4, 1], [, , ..., , ]]'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mstyle mathvariant="italic">
                  <mi>B</mi>
                </mstyle>
                <mo>&#xaf;</mo>
              </munder>
              <mo>=</mo>
              <mfenced open="[" close="]">
                <mtable>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd/>
                    <mtd/>
                    <mtd/>
                    <mtd/>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd/>
                    <mtd/>
                    <mtd/>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd>
                      <mn>2</mn>
                    </mtd>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd/>
                    <mtd/>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mstyle mathcolor="red">
                        <mn>1</mn>
                      </mstyle>
                    </mtd>
                    <mtd>
                      <mstyle mathcolor="red">
                        <mn>3</mn>
                      </mstyle>
                    </mtd>
                    <mtd>
                      <mstyle mathcolor="red">
                        <mn>3</mn>
                      </mstyle>
                    </mtd>
                    <mtd>
                      <mstyle mathcolor="red">
                        <mn>1</mn>
                      </mstyle>
                    </mtd>
                    <mtd/>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd>
                      <mn>4</mn>
                    </mtd>
                    <mtd>
                      <mn>6</mn>
                    </mtd>
                    <mtd>
                      <mn>4</mn>
                    </mtd>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd/>
                    <mtd/>
                    <mtd>
                      <mo>&#x2026;</mo>
                    </mtd>
                    <mtd/>
                    <mtd/>
                  </mtr>
                </mtable>
              </mfenced>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #53" do
      let(:string) { 'H_s(z)=(1-A(ztext(/)overset(~)(gamma)))/(1-A(ztext(/)overset(~)(gamma)))(1+mu z^(-1)), text( with ) 0&#x3c;overset(~)(gamma)_1&#x3c;overset(~)(gamma)_2&#x3c;=1' }

      it 'returns parsed Asciimath to Formula' do
        latex = 'H_{s}  \left ( z \right )  = \frac{1 - A  \left ( z \text{/} \overset{\sptilde}{\gamma} \right ) }{1 - A  \left ( z \text{/} \overset{\sptilde}{\gamma} \right ) }  \left ( 1 + \mu z^{- 1} \right )  ,  \text{ with } 0 \& \# x 3 c ; \overset{\sptilde}{\gamma}_{1} \& \# x 3 c ; \overset{\sptilde}{\gamma}_{2} \& \# x 3 c ; = 1'
        asciimath = 'H_(s) (z) = frac(1 - A (z "/" overset(~)(gamma)))(1 - A (z "/" overset(~)(gamma))) (1 + mu z^(- 1)) ,  " with " 0 & # x 3 c ; overset(~)(gamma)_(1) & # x 3 c ; overset(~)(gamma)_(2) & # x 3 c ; = 1'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mi>H</mi>
                <mi>s</mi>
              </msub>
              <mrow>
                <mo>(</mo>
                <mi>z</mi>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <mfrac>
                <mrow>
                  <mn>1</mn>
                  <mo>&#x2212;</mo>
                  <mi>A</mi>
                  <mrow>
                    <mo>(</mo>
                    <mi>z</mi>
                    <mtext>/</mtext>
                    <mover>
                      <mi>&#x3b3;</mi>
                      <mi>&#x7e;</mi>
                    </mover>
                    <mo>)</mo>
                  </mrow>
                </mrow>
                <mrow>
                  <mn>1</mn>
                  <mo>&#x2212;</mo>
                  <mi>A</mi>
                  <mrow>
                    <mo>(</mo>
                    <mi>z</mi>
                    <mtext>/</mtext>
                    <mover>
                      <mi>&#x3b3;</mi>
                      <mi>&#x7e;</mi>
                    </mover>
                    <mo>)</mo>
                  </mrow>
                </mrow>
              </mfrac>
              <mrow>
                <mo>(</mo>
                <mn>1</mn>
                <mo>+</mo>
                <mi>&#x3bc;</mi>
                <msup>
                  <mi>z</mi>
                  <mrow>
                    <mo>&#x2212;</mo>
                    <mn>1</mn>
                  </mrow>
                </msup>
                <mo>)</mo>
              </mrow>
              <mo>, </mo>
              <mtext> with </mtext>
              <mn>0</mn>
              <mo>&#x26;</mo>
              <mi>#</mi>
              <mi>x</mi>
              <mn>3</mn>
              <mi>c</mi>
              <mo>&#x3b;</mo>
              <mrow>
                <msub>
                  <mover>
                    <mi>&#x3b3;</mi>
                    <mi>&#x7e;</mi>
                  </mover>
                  <mn>1</mn>
                </msub>
                <mo>&#x26;</mo>
                <mi>#</mi>
                <mi>x</mi>
                <mn>3</mn>
                <mi>c</mi>
                <mo>&#x3b;</mo>
                <mrow>
                  <msub>
                    <mover>
                      <mi>&#x3b3;</mi>
                      <mi>&#x7e;</mi>
                    </mover>
                    <mn>2</mn>
                  </msub>
                  <mo>&#x26;</mo>
                  <mi>#</mi>
                  <mi>x</mi>
                  <mn>3</mn>
                  <mi>c</mi>
                  <mo>&#x3b;</mo>
                  <mo>=</mo>
                  <mn>1</mn>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #54" do
      let(:string) { '&lt; &lt; mode, &lt; s(ag) &gt; &gt;, s' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\& < ; \& < {;} \mod {e} ,  \& < ; s  \left ( a g \right )  \& > ; \& > ; ,  s'
        asciimath = '& lt ; & lt ; mod e ,  & lt ; s (a g) & gt ; & gt ; ,  s'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mo>&#x26;</mo>
              <mo>&#x3c;</mo>
              <mo>&#x3b;</mo>
              <mo>&#x26;</mo>
              <mo>&#x3c;</mo>
              <mrow>
                <mo>&#x3b;</mo>
                <mi>mod</mi>
                <mi>e</mi>
              </mrow>
              <mo>, </mo>
              <mo>&#x26;</mo>
              <mo>&#x3c;</mo>
              <mo>&#x3b;</mo>
              <mi>s</mi>
              <mrow>
                <mo>(</mo>
                <mi>a</mi>
                <mrow>
                  <mi>g</mi>
                </mrow>
                <mo>)</mo>
              </mrow>
              <mo>&#x26;</mo>
              <mo>&#x3e;</mo>
              <mo>&#x3b;</mo>
              <mo>&#x26;</mo>
              <mo>&#x3e;</mo>
              <mo>&#x3b;</mo>
              <mo>, </mo>
              <mi>s</mi>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #55" do
      let(:string) { '{:(u^2(delta y), = {:[({partial f}/{partial ii(X)_1})^2 u^2(x_1) +({partial f}/{partial ii(X)_2})^2 u^2(x_2) +2 {partial f}/{partial ii(X)_1} {partial f}/{partial ii(X)_2} r(x_1,x_2)u(x_1)u(x_2)]|_{bb(X)=bb(x)}),(" ",= 4x_1^2 u^2 (x_1) + 4x_2^2 u^2 (x_2) + 8r(x_1,x_2) x_1 x_2 u(x_1) u(x_2).):}' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\left . \left ( u^{2}  \left ( \delta y \right )  ,  = \left . \left [  \left ( \frac{\partial f}{\partial \mathit{X}_{1}} \right ) ^{2} u^{2}  \left ( x_{1} \right )  +  \left ( \frac{\partial f}{\partial \mathit{X}_{2}} \right ) ^{2} u^{2}  \left ( x_{2} \right )  + 2 \frac{\partial f}{\partial \mathit{X}_{1}} \frac{\partial f}{\partial \mathit{X}_{2}} r  \left ( x_{1 ,} x_{2} \right )  u  \left ( x_{1} \right )  u  \left ( x_{2} \right )  \right ]  |_{\mathbf{X} = \mathbf{x}} \right )  ,  \left ( \text{ } , = 4 x_{1}^{2} u^{2}  \left ( x_{1} \right )  + 4 x_{2}^{2} u^{2}  \left ( x_{2} \right )  + 8 r  \left ( x_{1 ,} x_{2} \right )  x_{1} x_{2} u  \left ( x_{1} \right )  u  \left ( x_{2} \right )  . \right )   \right   \right  '
        asciimath = '{:(u^(2) (delta y) ,  = {:[(frac(del f)(del ii(X)_(1)))^(2) u^(2) (x_(1)) + (frac(del f)(del ii(X)_(2)))^(2) u^(2) (x_(2)) + 2 frac(del f)(del ii(X)_(1)) frac(del f)(del ii(X)_(2)) r (x_(1 ,) x_(2)) u (x_(1)) u (x_(2))] |_(mathbf(X) = mathbf(x))) , (" " , = 4 x_(1)^(2) u^(2) (x_(1)) + 4 x_(2)^(2) u^(2) (x_(2)) + 8 r (x_(1 ,) x_(2)) x_(1) x_(2) u (x_(1)) u (x_(2)) .) :}'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo></mo>
                <mrow>
                  <mo>(</mo>
                  <msup>
                    <mi>u</mi>
                    <mn>2</mn>
                  </msup>
                  <mrow>
                    <mo>(</mo>
                    <mi>&#x3b4;</mi>
                    <mi>y</mi>
                    <mo>)</mo>
                  </mrow>
                  <mo>, </mo>
                  <mo>=</mo>
                  <mrow>
                    <mo></mo>
                    <mrow>
                      <mo>[</mo>
                      <msup>
                        <mrow>
                          <mo>(</mo>
                          <mfrac>
                            <mrow>
                              <mo>&#x2202;</mo>
                              <mrow>
                                <mi>f</mi>
                              </mrow>
                            </mrow>
                            <mrow>
                              <mo>&#x2202;</mo>
                              <msub>
                                <mstyle mathvariant="italic">
                                  <mi>X</mi>
                                </mstyle>
                                <mn>1</mn>
                              </msub>
                            </mrow>
                          </mfrac>
                          <mo>)</mo>
                        </mrow>
                        <mn>2</mn>
                      </msup>
                      <msup>
                        <mi>u</mi>
                        <mn>2</mn>
                      </msup>
                      <mrow>
                        <mo>(</mo>
                        <msub>
                          <mi>x</mi>
                          <mn>1</mn>
                        </msub>
                        <mo>)</mo>
                      </mrow>
                      <mo>+</mo>
                      <msup>
                        <mrow>
                          <mo>(</mo>
                          <mfrac>
                            <mrow>
                              <mo>&#x2202;</mo>
                              <mrow>
                                <mi>f</mi>
                              </mrow>
                            </mrow>
                            <mrow>
                              <mo>&#x2202;</mo>
                              <msub>
                                <mstyle mathvariant="italic">
                                  <mi>X</mi>
                                </mstyle>
                                <mn>2</mn>
                              </msub>
                            </mrow>
                          </mfrac>
                          <mo>)</mo>
                        </mrow>
                        <mn>2</mn>
                      </msup>
                      <msup>
                        <mi>u</mi>
                        <mn>2</mn>
                      </msup>
                      <mrow>
                        <mo>(</mo>
                        <msub>
                          <mi>x</mi>
                          <mn>2</mn>
                        </msub>
                        <mo>)</mo>
                      </mrow>
                      <mo>+</mo>
                      <mn>2</mn>
                      <mfrac>
                        <mrow>
                          <mo>&#x2202;</mo>
                          <mrow>
                            <mi>f</mi>
                          </mrow>
                        </mrow>
                        <mrow>
                          <mo>&#x2202;</mo>
                          <msub>
                            <mstyle mathvariant="italic">
                              <mi>X</mi>
                            </mstyle>
                            <mn>1</mn>
                          </msub>
                        </mrow>
                      </mfrac>
                      <mfrac>
                        <mrow>
                          <mo>&#x2202;</mo>
                          <mrow>
                            <mi>f</mi>
                          </mrow>
                        </mrow>
                        <mrow>
                          <mo>&#x2202;</mo>
                          <msub>
                            <mstyle mathvariant="italic">
                              <mi>X</mi>
                            </mstyle>
                            <mn>2</mn>
                          </msub>
                        </mrow>
                      </mfrac>
                      <mi>r</mi>
                      <mrow>
                        <mo>(</mo>
                        <msub>
                          <mi>x</mi>
                          <mrow>
                            <mn>1</mn>
                            <mo>,</mo>
                          </mrow>
                        </msub>
                        <msub>
                          <mi>x</mi>
                          <mn>2</mn>
                        </msub>
                        <mo>)</mo>
                      </mrow>
                      <mi>u</mi>
                      <mrow>
                        <mo>(</mo>
                        <msub>
                          <mi>x</mi>
                          <mn>1</mn>
                        </msub>
                        <mo>)</mo>
                      </mrow>
                      <mi>u</mi>
                      <mrow>
                        <mo>(</mo>
                        <msub>
                          <mi>x</mi>
                          <mn>2</mn>
                        </msub>
                        <mo>)</mo>
                      </mrow>
                      <mo>]</mo>
                    </mrow>
                    <msub>
                      <mo>&#x7c;</mo>
                      <mrow>
                        <mstyle mathvariant="bold">
                          <mi>X</mi>
                        </mstyle>
                        <mo>=</mo>
                        <mstyle mathvariant="bold">
                          <mi>x</mi>
                        </mstyle>
                      </mrow>
                    </msub>
                    <mo>)</mo>
                  </mrow>
                  <mo>,</mo>
                  <mrow>
                    <mo>(</mo>
                    <mtext> </mtext>
                    <mo>,</mo>
                    <mo>=</mo>
                    <mn>4</mn>
                    <msubsup>
                      <mi>x</mi>
                      <mn>1</mn>
                      <mn>2</mn>
                    </msubsup>
                    <msup>
                      <mi>u</mi>
                      <mn>2</mn>
                    </msup>
                    <mrow>
                      <mo>(</mo>
                      <msub>
                        <mi>x</mi>
                        <mn>1</mn>
                      </msub>
                      <mo>)</mo>
                    </mrow>
                    <mo>+</mo>
                    <mn>4</mn>
                    <msubsup>
                      <mi>x</mi>
                      <mn>2</mn>
                      <mn>2</mn>
                    </msubsup>
                    <msup>
                      <mi>u</mi>
                      <mn>2</mn>
                    </msup>
                    <mrow>
                      <mo>(</mo>
                      <msub>
                        <mi>x</mi>
                        <mn>2</mn>
                      </msub>
                      <mo>)</mo>
                    </mrow>
                    <mo>+</mo>
                    <mn>8</mn>
                    <mi>r</mi>
                    <mrow>
                      <mo>(</mo>
                      <msub>
                        <mi>x</mi>
                        <mrow>
                          <mn>1</mn>
                          <mo>,</mo>
                        </mrow>
                      </msub>
                      <msub>
                        <mi>x</mi>
                        <mn>2</mn>
                      </msub>
                      <mo>)</mo>
                    </mrow>
                    <msub>
                      <mi>x</mi>
                      <mn>1</mn>
                    </msub>
                    <msub>
                      <mi>x</mi>
                      <mn>2</mn>
                    </msub>
                    <mi>u</mi>
                    <mrow>
                      <mo>(</mo>
                      <msub>
                        <mi>x</mi>
                        <mn>1</mn>
                      </msub>
                      <mo>)</mo>
                    </mrow>
                    <mi>u</mi>
                    <mrow>
                      <mo>(</mo>
                      <msub>
                        <mi>x</mi>
                        <mn>2</mn>
                      </msub>
                      <mo>)</mo>
                    </mrow>
                    <mo>&#xb7;</mo>
                    <mo>)</mo>
                  </mrow>
                  <mi/>
                  <mo></mo>
                </mrow>
                <mo></mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #56" do
      let(:string) { 'u^2(delta y) = {:[({partial f}/{partial ii(X)_1})^2 u^2(x_1) + ({partial f}/{partial ii(X)_2})^2]|_{bb(X)=bb(x)} = 4 x_1^2 u^2 (x_1) + 4 x_2^2 u^2 (x_2),' }

      it 'returns parsed Asciimath to Formula' do
        latex = 'u^{2}  \left ( \delta y \right )  = \left . \left [  \left ( \frac{\partial f}{\partial \mathit{X}_{1}} \right ) ^{2} u^{2}  \left ( x_{1} \right )  +  \left ( \frac{\partial f}{\partial \mathit{X}_{2}} \right ) ^{2} \right ]  |_{\mathbf{X} = \mathbf{x}} = 4 x_{1}^{2} u^{2}  \left ( x_{1} \right )  + 4 x_{2}^{2} u^{2}  \left ( x_{2} \right )  , \right  '
        asciimath = 'u^(2) (delta y) = {:[(frac(del f)(del ii(X)_(1)))^(2) u^(2) (x_(1)) + (frac(del f)(del ii(X)_(2)))^(2)] |_(mathbf(X) = mathbf(x)) = 4 x_(1)^(2) u^(2) (x_(1)) + 4 x_(2)^(2) u^(2) (x_(2)) ,'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msup>
                <mi>u</mi>
                <mn>2</mn>
              </msup>
              <mrow>
                <mo>(</mo>
                <mi>&#x3b4;</mi>
                <mi>y</mi>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <mrow>
                <mo></mo>
                <mrow>
                  <mo>[</mo>
                  <msup>
                    <mrow>
                      <mo>(</mo>
                      <mfrac>
                        <mrow>
                          <mo>&#x2202;</mo>
                          <mrow>
                            <mi>f</mi>
                          </mrow>
                        </mrow>
                        <mrow>
                          <mo>&#x2202;</mo>
                          <msub>
                            <mstyle mathvariant="italic">
                              <mi>X</mi>
                            </mstyle>
                            <mn>1</mn>
                          </msub>
                        </mrow>
                      </mfrac>
                      <mo>)</mo>
                    </mrow>
                    <mn>2</mn>
                  </msup>
                  <msup>
                    <mi>u</mi>
                    <mn>2</mn>
                  </msup>
                  <mrow>
                    <mo>(</mo>
                    <msub>
                      <mi>x</mi>
                      <mn>1</mn>
                    </msub>
                    <mo>)</mo>
                  </mrow>
                  <mo>+</mo>
                  <msup>
                    <mrow>
                      <mo>(</mo>
                      <mfrac>
                        <mrow>
                          <mo>&#x2202;</mo>
                          <mrow>
                            <mi>f</mi>
                          </mrow>
                        </mrow>
                        <mrow>
                          <mo>&#x2202;</mo>
                          <msub>
                            <mstyle mathvariant="italic">
                              <mi>X</mi>
                            </mstyle>
                            <mn>2</mn>
                          </msub>
                        </mrow>
                      </mfrac>
                      <mo>)</mo>
                    </mrow>
                    <mn>2</mn>
                  </msup>
                  <mo>]</mo>
                </mrow>
                <msub>
                  <mo>&#x7c;</mo>
                  <mrow>
                    <mstyle mathvariant="bold">
                      <mi>X</mi>
                    </mstyle>
                    <mo>=</mo>
                    <mstyle mathvariant="bold">
                      <mi>x</mi>
                    </mstyle>
                  </mrow>
                </msub>
                <mo>=</mo>
                <mn>4</mn>
                <msubsup>
                  <mi>x</mi>
                  <mn>1</mn>
                  <mn>2</mn>
                </msubsup>
                <msup>
                  <mi>u</mi>
                  <mn>2</mn>
                </msup>
                <mrow>
                  <mo>(</mo>
                  <msub>
                    <mi>x</mi>
                    <mn>1</mn>
                  </msub>
                  <mo>)</mo>
                </mrow>
                <mo>+</mo>
                <mn>4</mn>
                <msubsup>
                  <mi>x</mi>
                  <mn>2</mn>
                  <mn>2</mn>
                </msubsup>
                <msup>
                  <mi>u</mi>
                  <mn>2</mn>
                </msup>
                <mrow>
                  <mo>(</mo>
                  <msub>
                    <mi>x</mi>
                    <mn>2</mn>
                  </msub>
                  <mo>)</mo>
                </mrow>
                <mo>,</mo>
                <mo></mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #57" do
      let(:string) { 'lambda_1 = {|:(b_1 - a_1) - (b_2 - a_2):|}/2, " " " " lambda_2 = {b - a}/2,' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\lambda_{1} = \frac{|  \left ( b_{1} - a_{1} \right )  -  \left ( b_{2} - a_{2} \right )  |}{2} ,  \text{ } \text{ } \lambda_{2} = \frac{b - a}{2} ,'
        asciimath = 'lambda_(1) = frac(| (b_(1) - a_(1)) - (b_(2) - a_(2)) |)(2) ,  " " " " lambda_(2) = frac(b - a)(2) ,'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mi>&#x3bb;</mi>
                <mn>1</mn>
              </msub>
              <mo>=</mo>
              <mrow>
                <mfrac>
                  <mrow>
                    <mo>&#x7c;</mo>
                    <mrow>
                      <mo>(</mo>
                      <msub>
                        <mi>b</mi>
                        <mn>1</mn>
                      </msub>
                      <mo>&#x2212;</mo>
                      <msub>
                        <mi>a</mi>
                        <mn>1</mn>
                      </msub>
                      <mo>)</mo>
                    </mrow>
                    <mo>&#x2212;</mo>
                    <mrow>
                      <mo>(</mo>
                      <msub>
                        <mi>b</mi>
                        <mn>2</mn>
                      </msub>
                      <mo>&#x2212;</mo>
                      <msub>
                        <mi>a</mi>
                        <mn>2</mn>
                      </msub>
                      <mo>)</mo>
                    </mrow>
                    <mo>&#x7c;</mo>
                  </mrow>
                  <mn>2</mn>
                </mfrac>
                <mo>, </mo>
              </mrow>
              <mtext> </mtext>
              <mtext> </mtext>
              <msub>
                <mi>&#x3bb;</mi>
                <mn>2</mn>
              </msub>
              <mo>=</mo>
              <mrow>
                <mfrac>
                  <mrow>
                    <mi>b</mi>
                    <mo>&#x2212;</mo>
                    <mi>a</mi>
                  </mrow>
                  <mn>2</mn>
                </mfrac>
                <mo>,</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #58" do
      let(:string) { 'ii(E)(ii(X)) = {a + b}/2, "    " ii(V)(ii(X)) = {(b - a)^2}/12' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\mathit{E}  \left ( \mathit{X} \right )  = \frac{a + b}{2} ,  \text{    } \mathit{V}  \left ( \mathit{X} \right )  = \frac{ \left ( b - a \right ) ^{2}}{12}'
        asciimath = 'ii(E) (ii(X)) = frac(a + b)(2) ,  "    " ii(V) (ii(X)) = frac((b - a)^(2))(12)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathvariant="italic">
                <mi>E</mi>
              </mstyle>
              <mrow>
                <mo>(</mo>
                <mstyle mathvariant="italic">
                  <mi>X</mi>
                </mstyle>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <mrow>
                <mfrac>
                  <mrow>
                    <mi>a</mi>
                    <mo>+</mo>
                    <mi>b</mi>
                  </mrow>
                  <mn>2</mn>
                </mfrac>
                <mo>, </mo>
              </mrow>
              <mtext>    </mtext>
              <mstyle mathvariant="italic">
                <mi>V</mi>
              </mstyle>
              <mrow>
                <mo>(</mo>
                <mstyle mathvariant="italic">
                  <mi>X</mi>
                </mstyle>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <mfrac>
                <msup>
                  <mrow>
                    <mo>(</mo>
                    <mi>b</mi>
                    <mo>&#x2212;</mo>
                    <mi>a</mi>
                    <mo>)</mo>
                  </mrow>
                  <mn>2</mn>
                </msup>
                <mn>12</mn>
              </mfrac>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #59" do
      let(:string) { 'i_j = (a_j xx i_j) mod d_j' }

      it 'returns parsed Asciimath to Formula' do
        latex = 'i_{j} = { \left ( a_{j} \times i_{j} \right ) } \mod {d_{j}}'
        asciimath = 'i_(j) = (a_(j) xx i_(j)) mod d_(j)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mi>i</mi>
                <mi>j</mi>
              </msub>
              <mo>=</mo>
              <mrow>
                <mrow>
                  <mo>(</mo>
                  <msub>
                    <mi>a</mi>
                    <mi>j</mi>
                  </msub>
                  <mo>&#xd7;</mo>
                  <msub>
                    <mi>i</mi>
                    <mi>j</mi>
                  </msub>
                  <mo>)</mo>
                </mrow>
                <mi>mod</mi>
                <msub>
                  <mi>d</mi>
                  <mi>j</mi>
                </msub>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #60" do
      let(:string) { 'i_j = a_j xx (i_j mod b_j) - c_j xx floor(i_j//b_j)' }

      it 'returns parsed Asciimath to Formula' do
        latex = 'i_{j} = a_{j} \times  \left ( {i_{j}} \mod {b_{j}} \right )  - c_{j} \times \lfloor i_{j} / b_{j} \rfloor'
        asciimath = 'i_(j) = a_(j) xx (i_(j) mod b_(j)) - c_(j) xx floor(i_(j) // b_(j))'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mi>i</mi>
                <mi>j</mi>
              </msub>
              <mo>=</mo>
              <msub>
                <mi>a</mi>
                <mi>j</mi>
              </msub>
              <mo>&#xd7;</mo>
              <mrow>
                <mo>(</mo>
                <mrow>
                  <msub>
                    <mi>i</mi>
                    <mi>j</mi>
                  </msub>
                  <mi>mod</mi>
                  <msub>
                    <mi>b</mi>
                    <mi>j</mi>
                  </msub>
                </mrow>
                <mo>)</mo>
              </mrow>
              <mo>&#x2212;</mo>
              <msub>
                <mi>c</mi>
                <mi>j</mi>
              </msub>
              <mo>&#xd7;</mo>
              <mrow>
                <mo>&#x230a;</mo>
                <mrow>
                  <msub>
                    <mi>i</mi>
                    <mi>j</mi>
                  </msub>
                  <mo>/</mo>
                  <msub>
                    <mi>b</mi>
                    <mi>j</mi>
                  </msub>
                </mrow>
                <mo>&#x230b;</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #61" do
      let(:string) { '[(x_1),(x_2)], " " [(u^2(x_1),ru(x_1)u(x_2)),(ru(x_1)u(x_2),u^2(x_2))].' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\left [\begin{matrix}x_{1} \\\\ x_{2}\end{matrix}\right ] ,  \text{ } \left [\begin{matrix}u^{2}  \left ( x_{1} \right )  & r u  \left ( x_{1} \right )  u  \left ( x_{2} \right )  \\\\ r u  \left ( x_{1} \right )  u  \left ( x_{2} \right )  & u^{2}  \left ( x_{2} \right ) \end{matrix}\right ] .'
        asciimath = '[[x_(1)], [x_(2)]] ,  " " [[u^(2) (x_(1)), r u (x_(1)) u (x_(2))], [r u (x_(1)) u (x_(2)), u^(2) (x_(2))]] .'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfenced open="[" close="]">
                <mtable>
                  <mtr>
                    <mtd>
                      <msub>
                        <mi>x</mi>
                        <mn>1</mn>
                      </msub>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <msub>
                        <mi>x</mi>
                        <mn>2</mn>
                      </msub>
                    </mtd>
                  </mtr>
                </mtable>
              </mfenced>
              <mo>, </mo>
              <mtext> </mtext>
              <mrow>
                <mfenced open="[" close="]">
                  <mtable>
                    <mtr>
                      <mtd>
                        <msup>
                          <mi>u</mi>
                          <mn>2</mn>
                        </msup>
                        <mrow>
                          <mo>(</mo>
                          <msub>
                            <mi>x</mi>
                            <mn>1</mn>
                          </msub>
                          <mo>)</mo>
                        </mrow>
                      </mtd>
                      <mtd>
                        <mi>r</mi>
                        <mi>u</mi>
                        <mrow>
                          <mo>(</mo>
                          <msub>
                            <mi>x</mi>
                            <mn>1</mn>
                          </msub>
                          <mo>)</mo>
                        </mrow>
                        <mi>u</mi>
                        <mrow>
                          <mo>(</mo>
                          <msub>
                            <mi>x</mi>
                            <mn>2</mn>
                          </msub>
                          <mo>)</mo>
                        </mrow>
                      </mtd>
                    </mtr>
                    <mtr>
                      <mtd>
                        <mi>r</mi>
                        <mi>u</mi>
                        <mrow>
                          <mo>(</mo>
                          <msub>
                            <mi>x</mi>
                            <mn>1</mn>
                          </msub>
                          <mo>)</mo>
                        </mrow>
                        <mi>u</mi>
                        <mrow>
                          <mo>(</mo>
                          <msub>
                            <mi>x</mi>
                            <mn>2</mn>
                          </msub>
                          <mo>)</mo>
                        </mrow>
                      </mtd>
                      <mtd>
                        <msup>
                          <mi>u</mi>
                          <mn>2</mn>
                        </msup>
                        <mrow>
                          <mo>(</mo>
                          <msub>
                            <mi>x</mi>
                            <mn>2</mn>
                          </msub>
                          <mo>)</mo>
                        </mrow>
                      </mtd>
                    </mtr>
                  </mtable>
                </mfenced>
                <mo>&#xb7;</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #62" do
      let(:string) { '1 + (ii(rho)_a - ii(rho)_a_0 )(1//ii(rho)_W - 1//ii(rho)_R)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '1 +  \left ( \mathit{\rho}_{a} - \mathit{\rho}_{a}_{0} \right )   \left ( 1 / \mathit{\rho}_{W} - 1 / \mathit{\rho}_{R} \right ) '
        asciimath = '1 + (ii(rho)_(a) - ii(rho)_(a)_(0)) (1 // ii(rho)_(W) - 1 // ii(rho)_(R))'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>1</mn>
              <mo>+</mo>
              <mrow>
                <mo>(</mo>
                <msub>
                  <mstyle mathvariant="italic">
                    <mi>&#x3c1;</mi>
                  </mstyle>
                  <mi>a</mi>
                </msub>
                <mo>&#x2212;</mo>
                <msub>
                  <msub>
                    <mstyle mathvariant="italic">
                      <mi>&#x3c1;</mi>
                    </mstyle>
                    <mi>a</mi>
                  </msub>
                  <mn>0</mn>
                </msub>
                <mo>)</mo>
              </mrow>
              <mrow>
                <mo>(</mo>
                <mn>1</mn>
                <mo>/</mo>
                <msub>
                  <mstyle mathvariant="italic">
                    <mi>&#x3c1;</mi>
                  </mstyle>
                  <mi>W</mi>
                </msub>
                <mo>&#x2212;</mo>
                <mn>1</mn>
                <mo>/</mo>
                <msub>
                  <mstyle mathvariant="italic">
                    <mi>&#x3c1;</mi>
                  </mstyle>
                  <mi>R</mi>
                </msub>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end
  end
end
