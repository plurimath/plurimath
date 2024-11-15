require "spec_helper"

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

  describe ".to_latex, to_mathml, to_asciimath" do
    subject(:formula) { Plurimath::Asciimath.new(string).to_formula }

    context "contains example #01" do
      let(:string) { 'cos(2)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\cos{( 2 )}'
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
        latex = '\sum_{i = 1}^{n} i^{3} = ( \frac{n ( n + 1 )}{2} )^{2}'
        asciimath = 'sum_(i = 1)^(n) i^(3) = (frac(n (n + 1))(2))^(2)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
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
              </mrow>
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
      let(:string) { '"unitsml(V*s//A,symbol:V cdot s//A)"' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\\mathrm{V} \\cdot \\mathrm{s} \\cdot \\mathrm{A}^{- 1}'
        asciimath = 'rm(V) * rm(s) * rm(A)^(- 1)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathvariant="normal">
                <mi>V</mi>
              </mstyle>
              <mo>&#x22c5;</mo>
              <mstyle mathvariant="normal">
                <mi>s</mi>
              </mstyle>
              <mo>&#x22c5;</mo>
              <msup>
                <mstyle mathvariant="normal">
                  <mi>A</mi>
                </mstyle>
                <mrow>
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
      let(:string) { 'int_0^(sin)f(x)dx' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\int_{0}^{\sin{}} f ( x ) d x'
        asciimath = 'int_(0)^(sin) f (x) d x'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <msubsup>
                  <mo>&#x222b;</mo>
                  <mn>0</mn>
                  <mi>sin</mi>
                </msubsup>
                <mi>f</mi>
              </mrow>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>)</mo>
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
              <mrow>
                <munder>
                  <mo>&#x2211;</mo>
                  <mi>a</mi>
                </munder>
                <mrow>
                  <mover>
                    <mo>&#x2211;</mo>
                    <mi>a</mi>
                  </mover>
                  <mrow>
                    <munderover>
                      <mo>&#x2211;</mo>
                      <mn>3</mn>
                      <mi>d</mi>
                    </munderover>
                    <mrow>
                      <munder>
                        <mo>&#x220f;</mo>
                        <mi>a</mi>
                      </munder>
                      <mrow>
                        <mover>
                          <mo>&#x220f;</mo>
                          <mi>a</mi>
                        </mover>
                        <munderover>
                          <mo>&#x220f;</mo>
                          <mn>3</mn>
                          <mi>d</mi>
                        </munderover>
                      </mrow>
                    </mrow>
                  </mrow>
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
        latex = '{12} \mod {1234} ( i )'
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
        latex = '\log ( 1 + 2 + 3 + 4 )^{\text{"theta"}}'
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
        latex = '\sum_{i = 1}^{n} i^{3} = \sin{( \frac{n ( n + 1 )}{2} )}^{2}'
        asciimath = 'sum_(i = 1)^(n) i^(3) = sin(frac(n (n + 1))(2))^(2)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
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
              </mrow>
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
      let(:string) { 'int_(thetasin)^(mathbb(gamma)) f(x)dx' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\int_{\theta \sin{}}^{\mathbb{\gamma}} f ( x ) d x'
        asciimath = 'int_(theta sin)^(mathbb(gamma)) f (x) d x'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <msubsup>
                  <mo>&#x222b;</mo>
                  <mrow>
                    <mi>&#x3b8;</mi>
                    <mi>sin</mi>
                  </mrow>
                  <mstyle mathvariant="double-struck">
                    <mi>&#x3b3;</mi>
                  </mstyle>
                </msubsup>
                <mi>f</mi>
              </mrow>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>)</mo>
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
        latex = '\mathfrak{\text{theta}} ( i )'
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
        latex = '\mathbb{\text{theta}} ( i )'
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
              <mrow>
                <mo>[</mo>
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
                <mo>]</mo>
              </mrow>
              <mo>(</mo>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&#x220f;</mo>
                <mi>&#x3c3;</mi>
              </munderover>
              <mo>)</mo>
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
        latex = '540 \times 10^{12} \mathrm{Hz} , \text{ } \mathit{K}_{\text{cd}}'
        asciimath = '540 xx 10^(12) rm(Hz) , " " ii(K)_("cd")'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>540</mn>
              <mo>&#xd7;</mo>
              <msup>
                <mn>10</mn>
                <mn>12</mn>
              </msup>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>Hz</mi>
                </mstyle>
              </mrow>
              <mo>,</mo>
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
        latex = '\underset{\_}{\hat{A}} ( ^ ) = \hat{A} \exp{j} \\upvartheta_{0}'
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
        latex = '\frac{d}{d x} [ x^{n} ] = n x^{n - 1}'
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
                <mo>&#x332;</mo>
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
              <mrow>
                <mo>(</mo>
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

    context "contains example #31" do
      let(:string) { '|(a,b),(c,d)|=ad-bc' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\left |\begin{matrix}a & b \\\\ c & d\end{matrix}\right | = a d - b c'
        asciimath = '|[a, b], [c, d]| = a d - b c'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>|</mo>
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
                <mo>|</mo>
              </mrow>
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

    context "contains example #32" do
      let(:string) { '[(a,b),(((c), (d)),e)]' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\left [\begin{matrix}a & b \\\\ \left (\begin{matrix}c \\\\ d\end{matrix}\right ) & e\end{matrix}\right ]'
        asciimath = '[[a, b], [([c], [d]), e]]'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>[</mo>
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
                      <mrow>
                        <mo>(</mo>
                        <mtable>
                          <mtr>
                            <mtd>
                              <mi>c</mi>
                            </mtd>
                          </mtr>
                          <mtr>
                            <mtd>
                              <mi>d</mi>
                            </mtd>
                          </mtr>
                        </mtable>
                        <mo>)</mo>
                      </mrow>
                    </mtd>
                    <mtd>
                      <mi>e</mi>
                    </mtd>
                  </mtr>
                </mtable>
                <mo>]</mo>
              </mrow>
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
              <mrow>
                <mo>(</mo>
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
        latex = 's \\prime_{i} = \left \{\begin{matrix}- 1 & \operatorname{if} s_{i} > s_{i + 1} \\\\ + 1 & \operatorname{if} s_{i} \le s_{i + 1}\end{matrix}\right .'
        asciimath = 's prime_(i) = {[- 1, if s_(i) gt s_(i + 1)], [+ 1, if s_(i) le s_(i + 1)]:}'
        mathml = <<~MATHML
          <math display="block" xmlns="http://www.w3.org/1998/Math/MathML">
            <mstyle displaystyle="true">
              <mi>s</mi>
              <msub>
                <mo>&#x2032;</mo>
                <mi>i</mi>
              </msub>
              <mo>=</mo>
              <mrow>
                <mo>{</mo>
                <mtable columnalign="left">
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
        latex = '\\{ x \\  : \\  x \\in A \\land x \\in B \\}'
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
        latex = '\left [\begin{matrix}a & b & c \\\\ d & e & f\end{matrix}\right ]'
        asciimath = '[[a, b, |, c], [d, e, |, f]]'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>[</mo>
                <mtable columnlines="none solid none">
                  <mtr>
                    <mtd>
                      <mi>a</mi>
                    </mtd>
                    <mtd>
                      <mi>b</mi>
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
                      <mi>f</mi>
                    </mtd>
                  </mtr>
                </mtable>
                <mo>]</mo>
              </mrow>
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
                  <mrow>
                    <mo>(</mo>
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
                    <mo>)</mo>
                  </mrow>
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
        latex = '\mathit{V} ( \mathit{X} ) = \frac{( b - a )^{2}}{12} + \frac{d^{2}}{9} .'
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
              <mo>&#x2e;</mo>
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
        latex = 'u ( w_{\text{cal}} ) = w_{\text{cal}} \cdot \sqrt{[ \frac{u ( m_{\text{stock}} )}{m_{\text{stock}}} ]^{2} + [ \frac{u ( b_{\text{stock}} )}{b_{\text{stock}}} ]^{2} + [ \frac{u ( w_{\text{stock}} )}{w_{\text{stock}}} ]^{2} + [ \frac{u ( m_{\text{sol}} )}{m_{\text{sol}}} ]^{2} + [ \frac{u ( b_{\text{sol}} )}{b_{\text{sol}}} ]^{2} + 2 \cdot [ \frac{u ( \mathit{V} )}{\mathit{V}} ]^{2}}'
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
        latex = '1 \mathrm{A} = ( \frac{\left (\begin{matrix}4 \pi \times 10^{- 7}\end{matrix}\right )}{( 9192631770 ) ( 299792458 ) ( 1 )} )^{\frac{1}{2}} ( \frac{\Delta \mathit{\nu}_{\text{Cs}} c m_{\mathcal{K}}}{\mathit{\mu}_{0}} )^{\frac{1}{2}} = 6.789687 \ldots \times 10^{- 13} ( \frac{\Delta \mathit{\nu}_{\text{Cs}} c m_{\mathcal{K}}}{\mathit{\mu}_{0}} )^{\frac{1}{2}}'
        asciimath = '1 rm(A) = (frac(([4 pi xx 10^(- 7)]))((9192631770) (299792458) (1)))^(frac(1)(2)) (frac(Delta ii(nu)_("Cs") c m_(mathcal(K)))(ii(mu)_(0)))^(frac(1)(2)) = 6.789687 ... xx 10^(- 13) (frac(Delta ii(nu)_("Cs") c m_(mathcal(K)))(ii(mu)_(0)))^(frac(1)(2))'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>1</mn>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>A</mi>
                </mstyle>
              </mrow>
              <mo>=</mo>
              <msup>
                <mrow>
                  <mo>(</mo>
                  <mfrac>
                    <mrow>
                      <mo>(</mo>
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
                      <mo>)</mo>
                    </mrow>
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
        latex = '\text{}_{r} \mathbb{Z}_{n} = \sum_{j = 1}^{n} ( - 1 )^{j} j^{r} , \text{ with } r = 1 , 2 , \ldots ,'
        asciimath = '""_(r) mathbb(Z)_(n) = sum_(j = 1)^(n) (- 1)^(j) j^(r) , " with " r = 1 , 2 , ... ,'
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
              <mrow>
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
              </mrow>
              <msup>
                <mi>j</mi>
                <mi>r</mi>
              </msup>
              <mo>,</mo>
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
        latex = '( \mathit{T}_{1} + \mathit{T}_{2} - a_{1} - a_{2} ) \cdot f ( t ) = \left \{\begin{matrix}0 & p o u r & \left \{\begin{matrix}0 < t < a_{-} \\\\ \text{ou } t > \mathit{T}_{-} + a_{2}\end{matrix}\right . \\\\ 1 & \text{} & \left \{\begin{matrix}a_{-} < t < a_{+} \text{,} \\\\ \mathit{T}_{1} - a_{1} < t < \mathit{T}_{-} \\\\ \text{ou } \mathit{T}_{1} < t < \mathit{T}_{-} + a_{2}\end{matrix}\right . \\\\ 2 & \text{} & a_{+} < t < \mathit{T}_{1} - a_{1} \\\\ ( \mathit{T}_{3} - \mathit{T}_{-} + a_{1} ) \cdot \delta ( t - \mathit{T}_{1} ) & p o u r & t = \mathit{T}_{1} \\\\ ( \mathit{T}_{1} - \mathit{T}_{4} ) \cdot \delta ( t - \mathit{T}_{2} ) & \text{} & t = \mathit{T}_{2} \text{,}\end{matrix}\right .'
        asciimath = '(ii(T)_(1) + ii(T)_(2) - a_(1) - a_(2)) * f (t) = {[0, p o u r, {[0 lt t lt a_(-)], ["ou " t gt ii(T)_(-) + a_(2)]:}], [1, "", {[a_(-) lt t lt a_(+) ","], [ii(T)_(1) - a_(1) lt t lt ii(T)_(-)], ["ou " ii(T)_(1) lt t lt ii(T)_(-) + a_(2)]:}], [2, "", a_(+) lt t lt ii(T)_(1) - a_(1)], [(ii(T)_(3) - ii(T)_(-) + a_(1)) * delta (t - ii(T)_(1)), p o u r, t = ii(T)_(1)], [(ii(T)_(1) - ii(T)_(4)) * delta (t - ii(T)_(2)), "", t = ii(T)_(2) ","]:}'
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
              <mi>f</mi>
              <mrow>
                <mo>(</mo>
                <mi>t</mi>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <mrow>
                <mo>{</mo>
                <mtable columnalign="left">
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
                      <mrow>
                        <mo>{</mo>
                        <mtable columnalign="left">
                          <mtr>
                            <mtd>
                              <mn>0</mn>
                              <mo>&lt;</mo>
                              <mi>t</mi>
                              <mo>&lt;</mo>
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
                              <mo>&gt;</mo>
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
                        <mo></mo>
                      </mrow>
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
                      <mrow>
                        <mo>{</mo>
                        <mtable columnalign="left">
                          <mtr>
                            <mtd>
                              <msub>
                                <mi>a</mi>
                                <mo>&#x2212;</mo>
                              </msub>
                              <mo>&lt;</mo>
                              <mi>t</mi>
                              <mo>&lt;</mo>
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
                              <mo>&lt;</mo>
                              <mi>t</mi>
                              <mo>&lt;</mo>
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
                              <mo>&lt;</mo>
                              <mi>t</mi>
                              <mo>&lt;</mo>
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
                        <mo></mo>
                      </mrow>
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
                      <mo>&lt;</mo>
                      <mi>t</mi>
                      <mo>&lt;</mo>
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
                <mo>&#x332;</mo>
              </munder>
              <mo>=</mo>
              <mrow>
                <mo>[</mo>
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
                <mo>]</mo>
              </mrow>
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
        latex = 'H_{s} ( z ) = \frac{1 - A ( z \text{/} \overset{\sptilde}{\gamma} )}{1 - A ( z \text{/} \overset{\sptilde}{\gamma} )} ( 1 + \mu z^{- 1} ) , \text{ with } 0 < \overset{\sptilde}{\gamma}_{1} < \overset{\sptilde}{\gamma}_{2} < = 1'
        asciimath = 'H_(s) (z) = frac(1 - A (z "/" overset(~)(gamma)))(1 - A (z "/" overset(~)(gamma))) (1 + mu z^(- 1)) , " with " 0 lt overset(~)(gamma)_(1) lt overset(~)(gamma)_(2) lt = 1'
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
              <mo>,</mo>
              <mtext> with </mtext>
              <mn>0</mn>
              <mo>&lt;</mo>
              <mrow>
                <msub>
                  <mover>
                    <mi>&#x3b3;</mi>
                    <mi>&#x7e;</mi>
                  </mover>
                  <mn>1</mn>
                </msub>
                <mo>&lt;</mo>
                <mrow>
                  <msub>
                    <mover>
                      <mi>&#x3b3;</mi>
                      <mi>&#x7e;</mi>
                    </mover>
                    <mn>2</mn>
                  </msub>
                  <mo>&lt;</mo>
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
        latex = '< {<} \mod {e} , < s ( a g ) > > , s'
        asciimath = 'lt lt mod e , lt s (a g) gt gt , s'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mo>&#x3c;</mo>
              <mrow>
                <mo>&#x3c;</mo>
                <mi>mod</mi>
                <mi>e</mi>
              </mrow>
              <mo>,</mo>
              <mo>&#x3c;</mo>
              <mi>s</mi>
              <mrow>
                <mo>(</mo>
                <mi>a</mi>
                <mi>g</mi>
                <mo>)</mo>
              </mrow>
              <mo>&#x3e;</mo>
              <mo>&#x3e;</mo>
              <mo>,</mo>
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
        latex = '\\left. ( u^{2} ( \delta y ) , = \\left. [ ( \frac{\partial f}{\partial \mathit{X}_{1}} )^{2} u^{2} ( x_{1} ) + ( \frac{\partial f}{\partial \mathit{X}_{2}} )^{2} u^{2} ( x_{2} ) + 2 \frac{\partial f}{\partial \mathit{X}_{1}} \frac{\partial f}{\partial \mathit{X}_{2}} r ( x_{1} , x_{2} ) u ( x_{1} ) u ( x_{2} ) ] |_{\mathbf{X} = \mathbf{x}} ) , ( \text{ } , = 4 x_{1}^{2} u^{2} ( x_{1} ) + 4 x_{2}^{2} u^{2} ( x_{2} ) + 8 r ( x_{1} , x_{2} ) x_{1} x_{2} u ( x_{1} ) u ( x_{2} ) . ) \\right. '
        asciimath = '{:(u^(2) (delta y) , = {:[(frac(del f)(del ii(X)_(1)))^(2) u^(2) (x_(1)) + (frac(del f)(del ii(X)_(2)))^(2) u^(2) (x_(2)) + 2 frac(del f)(del ii(X)_(1)) frac(del f)(del ii(X)_(2)) r (x_(1) , x_(2)) u (x_(1)) u (x_(2))] |_(mathbf(X) = mathbf(x))) , (" " , = 4 x_(1)^(2) u^(2) (x_(1)) + 4 x_(2)^(2) u^(2) (x_(2)) + 8 r (x_(1) , x_(2)) x_(1) x_(2) u (x_(1)) u (x_(2)) .):})'
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
                  <mo>,</mo>
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
                              <mi>f</mi>
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
                              <mi>f</mi>
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
                          <mi>f</mi>
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
                          <mi>f</mi>
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
                          <mn>1</mn>
                        </msub>
                        <mo>,</mo>
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
                        <mn>1</mn>
                      </msub>
                      <mo>,</mo>
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
                    <mo>&#x2e;</mo>
                    <mo>)</mo>
                  </mrow>
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
        latex = 'u^{2} ( \delta y ) = \\left. [ ( \frac{\partial f}{\partial \mathit{X}_{1}} )^{2} u^{2} ( x_{1} ) + ( \frac{\partial f}{\partial \mathit{X}_{2}} )^{2} ] |_{\mathbf{X} = \mathbf{x}} = 4 x_{1}^{2} u^{2} ( x_{1} ) + 4 x_{2}^{2} u^{2} ( x_{2} ) , '
        asciimath = 'u^(2) (delta y) = {:[(frac(del f)(del ii(X)_(1)))^(2) u^(2) (x_(1)) + (frac(del f)(del ii(X)_(2)))^(2)] |_(mathbf(X) = mathbf(x)) = 4 x_(1)^(2) u^(2) (x_(1)) + 4 x_(2)^(2) u^(2) (x_(2)) ,)'
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
                          <mi>f</mi>
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
                          <mi>f</mi>
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
        latex = '\lambda_{1} = \frac{| ( b_{1} - a_{1} ) - ( b_{2} - a_{2} ) |}{2} , \text{ } \text{ } \lambda_{2} = \frac{b - a}{2} ,'
        asciimath = 'lambda_(1) = frac(| (b_(1) - a_(1)) - (b_(2) - a_(2)) |)(2) , " " " " lambda_(2) = frac(b - a)(2) ,'
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
                <mo>,</mo>
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
        latex = '\mathit{E} ( \mathit{X} ) = \frac{a + b}{2} , \text{    } \mathit{V} ( \mathit{X} ) = \frac{( b - a )^{2}}{12}'
        asciimath = 'ii(E) (ii(X)) = frac(a + b)(2) , "    " ii(V) (ii(X)) = frac((b - a)^(2))(12)'
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
                <mo>,</mo>
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
        latex = 'i_{j} = {( a_{j} \times i_{j} )} \mod {d_{j}}'
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
        latex = 'i_{j} = a_{j} \times ( {i_{j}} \mod {b_{j}} ) - c_{j} \times {\lfloor i_{j} / b_{j} \rfloor}'
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
        latex = '\left [\begin{matrix}x_{1} \\\\ x_{2}\end{matrix}\right ] , \text{ } \left [\begin{matrix}u^{2} ( x_{1} ) & r u ( x_{1} ) u ( x_{2} ) \\\\ r u ( x_{1} ) u ( x_{2} ) & u^{2} ( x_{2} )\end{matrix}\right ] .'
        asciimath = '[[x_(1)], [x_(2)]] , " " [[u^(2) (x_(1)), r u (x_(1)) u (x_(2))], [r u (x_(1)) u (x_(2)), u^(2) (x_(2))]] .'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>[</mo>
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
                <mo>]</mo>
              </mrow>
              <mo>,</mo>
              <mtext> </mtext>
              <mrow>
                <mrow>
                  <mo>[</mo>
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
                  <mo>]</mo>
                </mrow>
                <mo>&#x2e;</mo>
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
        latex = '1 + ( \mathit{\rho}_{a} - \mathit{\rho}_{a}_{0} ) ( 1 / \mathit{\rho}_{W} - 1 / \mathit{\rho}_{R} )'
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

    context "contains example #63" do
      let(:string) { "f'(x) = dy/dx" }

      it 'returns parsed Asciimath to Formula' do
        latex = "f \\prime ( x ) = d \\frac{y}{d x}"
        asciimath = "f prime (x) = d frac(y)(d x)"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>f</mi>
              <mo>&#x2032;</mo>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <mi>d</mi>
              <mfrac>
                <mi>y</mi>
                <mrow>
                  <mi>d</mi>
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

    context "contains example #64" do
      let(:string) { "bar X' \\ \n theta" }

      it 'returns parsed Asciimath to Formula' do
        latex = "\\overline{X} \\prime \\\\  \\theta"
        asciimath = <<~ASCIIMATH.strip
          bar(X) prime \\
            theta
        ASCIIMATH
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mi>X</mi>
                <mo>&#xaf;</mo>
              </mover>
              <mo>&#x2032;</mo>
            </mstyle>
          </math>
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>&#x3b8;</mi>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml(split_on_linebreak: true)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #65" do
      let(:string) { "y\"a" }

      it 'returns parsed Asciimath to Formula' do
        latex = "y \\text{} a"
        asciimath = "y \"\" a"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>y</mi>
              <mtext></mtext>
              <mi>a</mi>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #66" do
      let(:string) { 'text()^2"S"_(1//2)' }

      it 'returns parsed Asciimath to Formula' do
        latex = "\\text{}^{2} \\text{S}_{1 / 2}"
        asciimath = '""^(2) "S"_(1 // 2)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msup>
                <mtext></mtext>
                <mn>2</mn>
              </msup>
              <msub>
                <mtext>S</mtext>
                <mrow>
                  <mn>1</mn>
                  <mo>/</mo>
                  <mn>2</mn>
                </mrow>
              </msub>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #67" do
      let(:string) { 'bb(ii(A)) + bb(ii(B)) = bb(ii())' }

      it 'returns parsed Asciimath to Formula' do
        latex = "\\mathbf{\\mathit{A}} + \\mathbf{\\mathit{B}} = \\mathbf{\\mathit{}}"
        asciimath = 'mathbf(ii(A)) + mathbf(ii(B)) = mathbf(ii())'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathvariant="bold">
                <mstyle mathvariant="italic">
                  <mi>A</mi>
                </mstyle>
              </mstyle>
              <mo>+</mo>
              <mstyle mathvariant="bold">
                <mstyle mathvariant="italic">
                  <mi>B</mi>
                </mstyle>
              </mstyle>
              <mo>=</mo>
              <mstyle mathvariant="bold">
                <mstyle mathvariant="italic"/>
              </mstyle>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #68" do
      let(:string) { 'bb(ii(A)) + bb(ii(B)) = bb(ii()' }

      it 'returns parsed Asciimath to Formula' do
        latex = "\\mathbf{\\mathit{A}} + \\mathbf{\\mathit{B}} = \\mathbf{\\mathit{}}"
        asciimath = 'mathbf(ii(A)) + mathbf(ii(B)) = mathbf(ii())'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathvariant="bold">
                <mstyle mathvariant="italic">
                  <mi>A</mi>
                </mstyle>
              </mstyle>
              <mo>+</mo>
              <mstyle mathvariant="bold">
                <mstyle mathvariant="italic">
                  <mi>B</mi>
                </mstyle>
              </mstyle>
              <mo>=</mo>
              <mstyle mathvariant="bold">
                <mstyle mathvariant="italic"/>
              </mstyle>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #69" do
      let(:string) { 'f_(199"Hg") = 1128575290808154.8 "unitsml(Hz)"' }

      it 'returns parsed Asciimath to Formula' do
        latex = 'f_{199 \\text{Hg}} = 1128575290808154.8 \\mathrm{Hz}'
        asciimath = 'f_(199 "Hg") = 1128575290808154.8 rm(Hz)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mi>f</mi>
                <mrow>
                  <mn>199</mn>
                  <mtext>Hg</mtext>
                </mrow>
              </msub>
              <mo>=</mo>
              <mn>1128575290808154.8</mn>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>Hz</mi>
                </mstyle>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #70" do
      let(:string) { 'n_"S"("X") = m_"S" // ii(M)("X"), " and " ii(M)(""X"") = ii(A)_"r"("X") "unitsml(g/mol)"' }

      it 'returns parsed Asciimath to Formula' do
        latex = 'n_{\text{S}} ( \text{X} ) = m_{\text{S}} / \mathit{M} ( \text{X} ) , \text{ and } \mathit{M} ( \text{} X \text{} ) = \mathit{A}_{\text{r}} ( \text{X} ) \mathrm{g} \cdot \mathrm{mol}^{- 1}'
        asciimath = 'n_("S") ("X") = m_("S") // ii(M) ("X") , " and " ii(M) ("" X "") = ii(A)_("r") ("X") rm(g) * rm(mol)^(- 1)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mi>n</mi>
                <mtext>S</mtext>
              </msub>
              <mrow>
                <mo>(</mo>
                <mtext>X</mtext>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <msub>
                <mi>m</mi>
                <mtext>S</mtext>
              </msub>
              <mo>/</mo>
              <mstyle mathvariant="italic">
                <mi>M</mi>
              </mstyle>
              <mrow>
                <mo>(</mo>
                <mtext>X</mtext>
                <mo>)</mo>
              </mrow>
              <mo>,</mo>
              <mtext> and </mtext>
              <mstyle mathvariant="italic">
                <mi>M</mi>
              </mstyle>
              <mrow>
                <mo>(</mo>
                <mtext></mtext>
                <mi>X</mi>
                <mtext></mtext>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <msub>
                <mstyle mathvariant="italic">
                  <mi>A</mi>
                </mstyle>
                <mtext>r</mtext>
              </msub>
              <mrow>
                <mo>(</mo>
                <mtext>X</mtext>
                <mo>)</mo>
              </mrow>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>g</mi>
                </mstyle>
                <mo>&#x22c5;</mo>
                <msup>
                  <mstyle mathvariant="normal">
                    <mi>mol</mi>
                  </mstyle>
                  <mrow>
                    <mo>&#x2212;</mo>
                    <mn>1</mn>
                  </mrow>
                </msup>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #71" do
      let(:string) { 'abs(e) @ ceil(x) circ ddot(m)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\abs{e} \circ {\lceil x \rceil} \circ \ddot{m}'
        asciimath = 'abs(e) @ ceil(x) @ ddot(m)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>|</mo>
                <mi>e</mi>
                <mo>|</mo>
              </mrow>
              <mi>&#x2218;</mi>
              <mrow>
                <mo>&#x2308;</mo>
                <mi>x</mi>
                <mo>&#x2309;</mo>
              </mrow>
              <mi>&#x2218;</mi>
              <mover accent="true">
                <mi>m</mi>
                <mo>..</mo>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #72" do
      let(:string) { 'g @ f' }

      it 'returns parsed Asciimath to Formula' do
        latex = 'g \circ f'
        asciimath = 'g @ f'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>g</mi>
              <mi>&#x2218;</mi>
              <mi>f</mi>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #73" do
      let(:string) { 'abs(A)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\abs{A}'
        asciimath = 'abs(A)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>|</mo>
                <mi>A</mi>
                <mo>|</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #74" do
      let(:string) { 'ceil(x)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '{\lceil x \rceil}'
        asciimath = 'ceil(x)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>&#x2308;</mo>
                <mi>x</mi>
                <mo>&#x2309;</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #75" do
      let(:string) { 'ddot x' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\ddot{x}'
        asciimath = 'ddot(x)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover accent="true">
                <mi>x</mi>
                <mo>..</mo>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #76" do
      let(:string) { '{x_i | i in I}' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\{ x_{i} | i \in I \}'
        asciimath = '{x_(i) | i in I}'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>{</mo>
                <msub>
                  <mi>x</mi>
                  <mi>i</mi>
                </msub>
                <mo>&#x7c;</mo>
                <mi>i</mi>
                <mo>&#x2208;</mo>
                <mi>I</mi>
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

    context "contains example #77" do
      let(:string) { '"H"_nu^((1))(z)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\text{H}_{\nu}^{( 1 )} ( z )'
        asciimath = '"H"_(nu)^((1)) (z)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mtext>H</mtext>
                <mi>&#x3bd;</mi>
                <mrow>
                  <mo>(</mo>
                  <mn>1</mn>
                  <mo>)</mo>
                </mrow>
              </msubsup>
              <mrow>
                <mo>(</mo>
                <mi>z</mi>
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

    context "contains example #78" do
      let(:string) { '(a)_n' }

      it 'returns parsed Asciimath to Formula' do
        latex = '( a )_{n}'
        asciimath = '(a)_(n)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mrow>
                  <mo>(</mo>
                  <mi>a</mi>
                  <mo>)</mo>
                </mrow>
                <mi>n</mi>
              </msub>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example #79" do
      let(:string) { 'tilde(x)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\tilde{x}'
        asciimath = 'tilde(x)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mi>x</mi>
                <mo>~</mo>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains ubrace only example #80" do
      let(:string) { 'ubrace' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\underbrace'
        asciimath = 'ubrace'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mo>&#x23df;</mo>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains obrace only example #81" do
      let(:string) { 'obrace' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\overbrace'
        asciimath = 'obrace'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mo>&#x23de;</mo>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains SanSerif and Monospace font styles example #82" do
      let(:string) { 'mathtt(d)mathsf(e)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\mathtt{d} \mathsf{e}'
        asciimath = 'mathtt(d) mathsf(e)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathvariant="monospace">
                <mi>d</mi>
              </mstyle>
              <mstyle mathvariant="sans-serif">
                <mi>e</mi>
              </mstyle>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains right paren power and single expression example #83" do
      let(:string) { ')^e v' }

      it 'returns parsed Asciimath to Formula' do
        latex = ')^{e} v'
        asciimath = ')^(e) v'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msup>
                <mo>)</mo>
                <mi>e</mi>
              </msup>
              <mi>v</mi>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains right paren power comma and single expression example #84" do
      let(:string) { ')^e,v' }

      it 'returns parsed Asciimath to Formula' do
        latex = ')^{e} , v'
        asciimath = ')^(e) , v'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msup>
                <mo>)</mo>
                <mi>e</mi>
              </msup>
              <mo>,</mo>
              <mi>v</mi>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains right paren power comma and sequence of expression example #85" do
      let(:string) { ')^e dv' }

      it 'returns parsed Asciimath to Formula' do
        latex = ')^{e} d v'
        asciimath = ')^(e) d v'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msup>
                <mo>)</mo>
                <mi>e</mi>
              </msup>
              <mi>d</mi>
              <mi>v</mi>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains right power base binary class and expression(sequence and simple) example #86" do
      let(:string) { 'sum_(d)^(3) prod_(dd)^(dd)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\sum_{d}^{3} \prod_{d d}^{d d}'
        asciimath = 'sum_(d)^(3) prod_(d d)^(d d)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mi>d</mi>
                  <mn>3</mn>
                </munderover>
                <munderover>
                  <mo>&#x220f;</mo>
                  <mrow>
                    <mi>d</mi>
                    <mi>d</mi>
                  </mrow>
                  <mrow>
                    <mi>d</mi>
                    <mi>d</mi>
                  </mrow>
                </munderover>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains dot with random value example #87" do
      let(:string) { 'dot(x)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\dot{x}'
        asciimath = 'dot(x)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mi>x</mi>
                <mo>.</mo>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains dot with random value example #88" do
      let(:string) do
        <<~ASCIIMATH
          bb(C_X)^{(1)} =
          [(1 + A theta_1 + B theta_1^2, R_0 theta_1,R_0 theta_1^2,-r_1),
          (vdots,vdots,vdots,vdots),
          (1 + A theta_{10} + B theta_{10}^2, R_0 theta_{10}, R_0 theta_{10}^2, -r_{10})]
        ASCIIMATH
      end

      it 'returns parsed Asciimath to Formula' do
        latex = '\mathbf{C_{X}}^{( 1 )} = \left [\begin{matrix}1 + A \theta_{1} + B \theta_{1}^{2} & R_{0} \theta_{1} & R_{0} \theta_{1}^{2} & - r_{1} \\\\ \vdots & \vdots & \vdots & \vdots \\\\ 1 + A \theta_{10} + B \theta_{10}^{2} & R_{0} \theta_{10} & R_{0} \theta_{10}^{2} & - r_{10}\end{matrix}\right ]'
        asciimath = 'mathbf(C_(X))^((1)) = [[1 + A theta_(1) + B theta_(1)^(2), R_(0) theta_(1), R_(0) theta_(1)^(2), - r_(1)], [vdots, vdots, vdots, vdots], [1 + A theta_(10) + B theta_(10)^(2), R_(0) theta_(10), R_(0) theta_(10)^(2), - r_(10)]]'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msup>
                <mstyle mathvariant="bold">
                  <msub>
                    <mi>C</mi>
                    <mi>X</mi>
                  </msub>
                </mstyle>
                <mrow>
                  <mo>(</mo>
                  <mn>1</mn>
                  <mo>)</mo>
                </mrow>
              </msup>
              <mo>=</mo>
              <mrow>
                <mrow>
                  <mo>[</mo>
                  <mtable>
                    <mtr>
                      <mtd>
                        <mn>1</mn>
                        <mo>+</mo>
                        <mi>A</mi>
                        <msub>
                          <mi>&#x3b8;</mi>
                          <mn>1</mn>
                        </msub>
                        <mo>+</mo>
                        <mi>B</mi>
                        <msubsup>
                          <mi>&#x3b8;</mi>
                          <mn>1</mn>
                          <mn>2</mn>
                        </msubsup>
                      </mtd>
                      <mtd>
                        <msub>
                          <mi>R</mi>
                          <mn>0</mn>
                        </msub>
                        <msub>
                          <mi>&#x3b8;</mi>
                          <mn>1</mn>
                        </msub>
                      </mtd>
                      <mtd>
                        <msub>
                          <mi>R</mi>
                          <mn>0</mn>
                        </msub>
                        <msubsup>
                          <mi>&#x3b8;</mi>
                          <mn>1</mn>
                          <mn>2</mn>
                        </msubsup>
                      </mtd>
                      <mtd>
                        <mo>&#x2212;</mo>
                        <msub>
                          <mi>r</mi>
                          <mn>1</mn>
                        </msub>
                      </mtd>
                    </mtr>
                    <mtr>
                      <mtd>
                        <mo>&#x22ee;</mo>
                      </mtd>
                      <mtd>
                        <mo>&#x22ee;</mo>
                      </mtd>
                      <mtd>
                        <mo>&#x22ee;</mo>
                      </mtd>
                      <mtd>
                        <mo>&#x22ee;</mo>
                      </mtd>
                    </mtr>
                    <mtr>
                      <mtd>
                        <mn>1</mn>
                        <mo>+</mo>
                        <mi>A</mi>
                        <msub>
                          <mi>&#x3b8;</mi>
                          <mn>10</mn>
                        </msub>
                        <mo>+</mo>
                        <mi>B</mi>
                        <msubsup>
                          <mi>&#x3b8;</mi>
                          <mn>10</mn>
                          <mn>2</mn>
                        </msubsup>
                      </mtd>
                      <mtd>
                        <msub>
                          <mi>R</mi>
                          <mn>0</mn>
                        </msub>
                        <msub>
                          <mi>&#x3b8;</mi>
                          <mn>10</mn>
                        </msub>
                      </mtd>
                      <mtd>
                        <msub>
                          <mi>R</mi>
                          <mn>0</mn>
                        </msub>
                        <msubsup>
                          <mi>&#x3b8;</mi>
                          <mn>10</mn>
                          <mn>2</mn>
                        </msubsup>
                      </mtd>
                      <mtd>
                        <mo>&#x2212;</mo>
                        <msub>
                          <mi>r</mi>
                          <mn>10</mn>
                        </msub>
                      </mtd>
                    </mtr>
                  </mtable>
                  <mo>]</mo>
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

    context "contains dot with random value example #89" do
      let(:string) { '[(cos{:y_2:},sin y_2),(-(sin y_2)//y_1,(cos y_2)//y_1)] .' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\left [\begin{matrix}\cos{\\left. y_{2} \\right.} & \sin{y}_{2} \\\\ - ( \sin{y}_{2} ) / y_{1} & ( \cos{y}_{2} ) / y_{1}\end{matrix}\right ] .'
        asciimath = '[[cos{:y_(2):}, siny_(2)], [- (siny_(2)) // y_(1), (cosy_(2)) // y_(1)]] .'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>[</mo>
                <mtable>
                  <mtr>
                    <mtd>
                      <mrow>
                        <mi>cos</mi>
                        <mrow>
                          <mo></mo>
                          <msub>
                            <mi>y</mi>
                            <mn>2</mn>
                          </msub>
                          <mo></mo>
                        </mrow>
                      </mrow>
                    </mtd>
                    <mtd>
                      <msub>
                        <mrow>
                          <mi>sin</mi>
                          <mi>y</mi>
                        </mrow>
                        <mn>2</mn>
                      </msub>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mo>&#x2212;</mo>
                      <mrow>
                        <mo>(</mo>
                        <msub>
                          <mrow>
                            <mi>sin</mi>
                            <mi>y</mi>
                          </mrow>
                          <mn>2</mn>
                        </msub>
                        <mo>)</mo>
                      </mrow>
                      <mo>/</mo>
                      <msub>
                        <mi>y</mi>
                        <mn>1</mn>
                      </msub>
                    </mtd>
                    <mtd>
                      <mrow>
                        <mo>(</mo>
                        <msub>
                          <mrow>
                            <mi>cos</mi>
                            <mi>y</mi>
                          </mrow>
                          <mn>2</mn>
                        </msub>
                        <mo>)</mo>
                      </mrow>
                      <mo>/</mo>
                      <msub>
                        <mi>y</mi>
                        <mn>1</mn>
                      </msub>
                    </mtd>
                  </mtr>
                </mtable>
                <mo>]</mo>
              </mrow>
              <mo>&#x2e;</mo>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains dot with random value example #90" do
      let(:string) { "f (\"a\"_{28},\" P(54) 8-4\") - f (\"a\"_{16},\" R(127) 11-5\"{^(127)ii(I)_2}) = -42.99(4) \"unitsml(MHz)\"" }

      it 'returns parsed Asciimath to Formula' do
        latex = 'f ( \text{a}_{28} , \text{ P(54) 8-4} ) - f ( \text{a}_{16} , \text{ R(127) 11-5} \{ ^ ( 127 ) \mathit{I}_{2} \} ) = - 42.99 ( 4 ) \mathrm{MHz}'
        asciimath = "f (\"a\"_(28) , \" P(54) 8-4\") - f (\"a\"_(16) , \" R(127) 11-5\" {^ (127) ii(I)_(2)}) = - 42.99 (4) rm(MHz)"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>f</mi>
              <mrow>
                <mo>(</mo>
                <msub>
                  <mtext>a</mtext>
                  <mn>28</mn>
                </msub>
                <mo>,</mo>
                <mtext> P(54) 8-4</mtext>
                <mo>)</mo>
              </mrow>
              <mo>&#x2212;</mo>
              <mi>f</mi>
              <mrow>
                <mo>(</mo>
                <msub>
                  <mtext>a</mtext>
                  <mn>16</mn>
                </msub>
                <mo>,</mo>
                <mtext> R(127) 11-5</mtext>
                <mrow>
                  <mo>{</mo>
                  <mo>^</mo>
                  <mrow>
                    <mo>(</mo>
                    <mn>127</mn>
                    <mo>)</mo>
                  </mrow>
                  <msub>
                    <mstyle mathvariant="italic">
                      <mi>I</mi>
                    </mstyle>
                    <mn>2</mn>
                  </msub>
                  <mo>}</mo>
                </mrow>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <mo>&#x2212;</mo>
              <mn>42.99</mn>
              <mrow>
                <mo>(</mo>
                <mn>4</mn>
                <mo>)</mo>
              </mrow>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>MHz</mi>
                </mstyle>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains matrix rendering example #91" do
      let(:string) { "T_m = T_{lm} = [(a,b,0),(c,d,0),(e,f,1)]" }

      it 'returns parsed Asciimath to Formula' do
        latex = 'T_{m} = T_{l m} = \left [\begin{matrix}a & b & 0 \\\\ c & d & 0 \\\\ e & f & 1\end{matrix}\right ]'
        asciimath = "T_(m) = T_(l m) = [[a, b, 0], [c, d, 0], [e, f, 1]]"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mi>T</mi>
                <mi>m</mi>
              </msub>
              <mo>=</mo>
              <msub>
                <mi>T</mi>
                <mrow>
                  <mi>l</mi>
                  <mi>m</mi>
                </mrow>
              </msub>
              <mo>=</mo>
              <mrow>
                <mo>[</mo>
                <mtable>
                  <mtr>
                    <mtd>
                      <mi>a</mi>
                    </mtd>
                    <mtd>
                      <mi>b</mi>
                    </mtd>
                    <mtd>
                      <mn>0</mn>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mi>c</mi>
                    </mtd>
                    <mtd>
                      <mi>d</mi>
                    </mtd>
                    <mtd>
                      <mn>0</mn>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mi>e</mi>
                    </mtd>
                    <mtd>
                      <mi>f</mi>
                    </mtd>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                  </mtr>
                </mtable>
                <mo>]</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains matrix rendering and f class fix example #92" do
      let(:string) do
        <<~ASCIIMATH
          << C_{s_i}, f_{j_i}, alpha_{j_i} >> =
          { ("Composite"(C_{i-1},alpha_{i-1},E_i),"if " E_i " is a group"),
          ("intrinsic color, shape, and "("shape" xx "opacity") " of " E_i, "otherwise") :}
        ASCIIMATH
      end

      it 'returns parsed Asciimath to Formula' do
        latex = '\langle C_{s_{i}} , f_{j_{i}} , \alpha_{j_{i}} \rangle = \left \{\begin{matrix}\text{Composite} ( C_{i - 1} , \alpha_{i - 1} , E_{i} ) & \text{if } E_{i} \text{ is a group} \\\\ \text{intrinsic color, shape, and } ( \text{shape} \times \text{opacity} ) \text{ of } E_{i} & \text{otherwise}\end{matrix}\right .'
        asciimath = '<< C_(s_(i)) , f_(j_(i)) , alpha_(j_(i)) >> = {["Composite" (C_(i - 1) , alpha_(i - 1) , E_(i)), "if " E_(i) " is a group"], ["intrinsic color, shape, and " ("shape" xx "opacity") " of " E_(i), "otherwise"]:}'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>&#x2329;</mi>
              <msub>
                <mi>C</mi>
                <msub>
                  <mi>s</mi>
                  <mi>i</mi>
                </msub>
              </msub>
              <mo>,</mo>
              <msub>
                <mi>f</mi>
                <msub>
                  <mi>j</mi>
                  <mi>i</mi>
                </msub>
              </msub>
              <mo>,</mo>
              <msub>
                <mi>&#x3b1;</mi>
                <msub>
                  <mi>j</mi>
                  <mi>i</mi>
                </msub>
              </msub>
              <mi>&#x232a;</mi>
              <mo>=</mo>
              <mrow>
                <mrow>
                  <mo>{</mo>
                  <mtable columnalign="left">
                    <mtr>
                      <mtd>
                        <mtext>Composite</mtext>
                        <mrow>
                          <mo>(</mo>
                          <msub>
                            <mi>C</mi>
                            <mrow>
                              <mi>i</mi>
                              <mo>&#x2212;</mo>
                              <mn>1</mn>
                            </mrow>
                          </msub>
                          <mo>,</mo>
                          <msub>
                            <mi>&#x3b1;</mi>
                            <mrow>
                              <mi>i</mi>
                              <mo>&#x2212;</mo>
                              <mn>1</mn>
                            </mrow>
                          </msub>
                          <mo>,</mo>
                          <msub>
                            <mi>E</mi>
                            <mi>i</mi>
                          </msub>
                          <mo>)</mo>
                        </mrow>
                      </mtd>
                      <mtd>
                        <mtext>if </mtext>
                        <msub>
                          <mi>E</mi>
                          <mi>i</mi>
                        </msub>
                        <mtext> is a group</mtext>
                      </mtd>
                    </mtr>
                    <mtr>
                      <mtd>
                        <mtext>intrinsic color, shape, and </mtext>
                        <mrow>
                          <mo>(</mo>
                          <mtext>shape</mtext>
                          <mo>&#xd7;</mo>
                          <mtext>opacity</mtext>
                          <mo>)</mo>
                        </mrow>
                        <mtext> of </mtext>
                        <msub>
                          <mi>E</mi>
                          <mi>i</mi>
                        </msub>
                      </mtd>
                      <mtd>
                        <mtext>otherwise</mtext>
                      </mtd>
                    </mtr>
                  </mtable>
                  <mo></mo>
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

    context "contains matrix rendering example #93" do
      let(:string) { '<< C_g, f_g, alpha_g >> = "Composite"(U,0,P)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\langle C_{g} , f_{g} , \alpha_{g} \rangle = \text{Composite} ( U , 0 , P )'
        asciimath = '<< C_(g) , f_(g) , alpha_(g) >> = "Composite" (U , 0 , P)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>&#x2329;</mi>
              <msub>
                <mi>C</mi>
                <mi>g</mi>
              </msub>
              <mo>,</mo>
              <msub>
                <mi>f</mi>
                <mi>g</mi>
              </msub>
              <mo>,</mo>
              <msub>
                <mi>&#x3b1;</mi>
                <mi>g</mi>
              </msub>
              <mi>&#x232a;</mi>
              <mo>=</mo>
              <mtext>Composite</mtext>
              <mrow>
                <mo>(</mo>
                <mi>U</mi>
                <mo>,</mo>
                <mn>0</mn>
                <mo>,</mo>
                <mi>P</mi>
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

    context "contains matrix rendering example #94" do
      let(:string) { '(: C,f,alpha :) = "Composite"(C_0,alpha_0,G)' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\langle C , f , \alpha \rangle = \text{Composite} ( C_{0} , \alpha_{0} , G )'
        asciimath = '<<C , f , alpha>> = "Composite" (C_(0) , alpha_(0) , G)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>&#x2329;</mo>
                <mi>C</mi>
                <mo>,</mo>
                <mi>f</mi>
                <mo>,</mo>
                <mi>&#x3b1;</mi>
                <mo>&#x232a;</mo>
              </mrow>
              <mo>=</mo>
              <mtext>Composite</mtext>
              <mrow>
                <mo>(</mo>
                <msub>
                  <mi>C</mi>
                  <mn>0</mn>
                </msub>
                <mo>,</mo>
                <msub>
                  <mi>&#x3b1;</mi>
                  <mn>0</mn>
                </msub>
                <mo>,</mo>
                <mi>G</mi>
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

    context "contains oint example #95" do
      let(:string) { 'oint_(sum)^d prod' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\oint_{ \left ( \sum \right ) }^{d} \prod'
        asciimath = 'oint_(sum)^(d) prod'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <msubsup>
                  <mo>&#x222e;</mo>
                  <mo>&#x2211;</mo>
                  <mi>d</mi>
                </msubsup>
                <mo>&#x220f;</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains concatenated expressions example 1 example #96" do
      let(:string) { 'ii(M)_(12) = 11 - sum_(j=2)^(10) 2^j ((12),(j)) ii(B)_j = ... = -2" "073' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\mathit{M}_{12} = 11 - \sum_{j = 2}^{10} 2^{j} \left (\begin{matrix}12 \\\\ j\end{matrix}\right ) \mathit{B}_{j} = \ldots = - 2 \text{ } 073'
        asciimath = 'ii(M)_(12) = 11 - sum_(j = 2)^(10) 2^(j) ([12], [j]) ii(B)_(j) = ... = - 2 " " 073'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mstyle mathvariant="italic">
                  <mi>M</mi>
                </mstyle>
                <mn>12</mn>
              </msub>
              <mo>=</mo>
              <mn>11</mn>
              <mo>&#x2212;</mo>
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mrow>
                    <mi>j</mi>
                    <mo>=</mo>
                    <mn>2</mn>
                  </mrow>
                  <mn>10</mn>
                </munderover>
                <msup>
                  <mn>2</mn>
                  <mi>j</mi>
                </msup>
              </mrow>
              <mrow>
                <mrow>
                  <mo>(</mo>
                  <mtable>
                    <mtr>
                      <mtd>
                        <mn>12</mn>
                      </mtd>
                    </mtr>
                    <mtr>
                      <mtd>
                        <mi>j</mi>
                      </mtd>
                    </mtr>
                  </mtable>
                  <mo>)</mo>
                </mrow>
                <msub>
                  <mstyle mathvariant="italic">
                    <mi>B</mi>
                  </mstyle>
                  <mi>j</mi>
                </msub>
                <mo>=</mo>
                <mo>&#x2026;</mo>
                <mo>=</mo>
                <mo>&#x2212;</mo>
                <mn>2</mn>
                <mtext> </mtext>
                <mn>073</mn>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains concatenated expressions example 2 example #97" do
      let(:string) { 'bar(x) = 1/n sum_{i=1}^n x_i, " " s^2 = 1/{n - 1} sum_{i=1}^n (x_i - bar(x))^2,' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\overline{x} = \frac{1}{n} \sum_{i = 1}^{n} x_{i} , \text{ } s^{2} = \frac{1}{n - 1} \sum_{i = 1}^{n} ( x_{i} - \overline{x} )^{2} ,'
        asciimath = 'bar(x) = frac(1)(n) sum_(i = 1)^(n) x_(i) , " " s^(2) = frac(1)(n - 1) sum_(i = 1)^(n) (x_(i) - bar(x))^(2) ,'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mi>x</mi>
                <mo>&#xaf;</mo>
              </mover>
              <mo>=</mo>
              <mfrac>
                <mn>1</mn>
                <mi>n</mi>
              </mfrac>
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mrow>
                    <mi>i</mi>
                    <mo>=</mo>
                    <mn>1</mn>
                  </mrow>
                  <mi>n</mi>
                </munderover>
                <msub>
                  <mi>x</mi>
                  <mi>i</mi>
                </msub>
              </mrow>
              <mo>,</mo>
              <mtext> </mtext>
              <msup>
                <mi>s</mi>
                <mn>2</mn>
              </msup>
              <mo>=</mo>
              <mfrac>
                <mn>1</mn>
                <mrow>
                  <mi>n</mi>
                  <mo>&#x2212;</mo>
                  <mn>1</mn>
                </mrow>
              </mfrac>
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mrow>
                    <mi>i</mi>
                    <mo>=</mo>
                    <mn>1</mn>
                  </mrow>
                  <mi>n</mi>
                </munderover>
                <mrow>
                  <msup>
                    <mrow>
                      <mo>(</mo>
                      <msub>
                        <mi>x</mi>
                        <mi>i</mi>
                      </msub>
                      <mo>&#x2212;</mo>
                      <mover>
                        <mi>x</mi>
                        <mo>&#xaf;</mo>
                      </mover>
                      <mo>)</mo>
                    </mrow>
                    <mn>2</mn>
                  </msup>
                  <mo>,</mo>
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

    context "contains contains jcgm#35 GUM 6:2020 document plurimath#195 equation #1 example #98" do
      let(:string) { "x = ((I_x + varepsilon_x))/I_\"ref\" x_\"ref\"" }

      it 'returns parsed Asciimath to Formula' do
        latex = "x = \\frac{\\left (\\begin{matrix}I_{x} + \\varepsilon_{x}\\end{matrix}\\right )}{I_{\\text{ref}}} x_{\\text{ref}}"
        asciimath = "x = frac(([I_(x) + varepsilon_(x)]))(I_(\"ref\")) x_(\"ref\")"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>x</mi>
              <mo>=</mo>
              <mfrac>
                <mrow>
                  <mo>(</mo>
                  <mtable>
                    <mtr>
                      <mtd>
                        <msub>
                          <mi>I</mi>
                          <mi>x</mi>
                        </msub>
                        <mo>+</mo>
                        <msub>
                          <mi>&#x25b;</mi>
                          <mi>x</mi>
                        </msub>
                      </mtd>
                    </mtr>
                  </mtable>
                  <mo>)</mo>
                </mrow>
                <msub>
                  <mi>I</mi>
                  <mtext>ref</mtext>
                </msub>
              </mfrac>
              <msub>
                <mi>x</mi>
                <mtext>ref</mtext>
              </msub>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains contains jcgm#35 GUM 6:2020 document plurimath#195 equation #2 example #99" do
      let(:string) { "(u(r)//r)//" }

      it 'returns parsed Asciimath to Formula' do
        latex = "( u ( r ) / r ) /"
        asciimath = "(u (r) // r) //"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>(</mo>
                <mi>u</mi>
                <mrow>
                  <mo>(</mo>
                  <mi>r</mi>
                  <mo>)</mo>
                </mrow>
                <mo>/</mo>
                <mi>r</mi>
                <mo>)</mo>
              </mrow>
              <mo>/</mo>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains contains jcgm#35 GUM 6:2020 document plurimath#195 equation #3 example #100" do
      let(:string) { "u(x)//" }

      it 'returns parsed Asciimath to Formula' do
        latex = "u ( x ) /"
        asciimath = "u (x) //"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>u</mi>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>)</mo>
              </mrow>
              <mo>/</mo>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains contains jcgm#35 GUM 6:2020 document plurimath#195 equation #4 example #101" do
      let(:string) { "x//" }

      it 'returns parsed Asciimath to Formula' do
        latex = "x /"
        asciimath = "x //"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>x</mi>
              <mo>/</mo>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains nested table with new line example #102" do
      let(:string) { "[[1,((2\\\n4),(7))], [3,4]]" }

      it 'returns parsed Asciimath to Formula' do
        latex = "\\left [\\begin{matrix}1 & \\left (\\begin{matrix}2 \\\\  4 \\\\ 7\\end{matrix}\\right ) \\\\ 3 & 4\\end{matrix}\\right ]"
        asciimath = "[[1, ([2 \\\n  4], [7])], [3, 4]]"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>[</mo>
                <mtable>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd>
                      <mrow>
                        <mo>(</mo>
                        <mtable>
                          <mtr>
                            <mtd>
                              <mn>2</mn>
                              <mo linebreak="newline"/>
                              <mn>4</mn>
                            </mtd>
                          </mtr>
                          <mtr>
                            <mtd>
                              <mn>7</mn>
                            </mtd>
                          </mtr>
                        </mtable>
                        <mo>)</mo>
                      </mrow>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mn>3</mn>
                    </mtd>
                    <mtd>
                      <mn>4</mn>
                    </mtd>
                  </mtr>
                </mtable>
                <mo>]</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains unitsml example as unary function value example #99" do
      let(:string) { 'sin "unitsml(mm*s^-2)"' }

      it 'returns parsed Asciimath to Formula' do
        latex = '\sin{\mathrm{mm} \cdot \mathrm{s}^{- 2}}'
        asciimath = 'sinrm(mm) * rm(s)^(- 2)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mi>sin</mi>
                <mo rspace="thickmathspace">&#x2062;</mo>
                <mrow>
                  <mstyle mathvariant="normal">
                    <mi>mm</mi>
                  </mstyle>
                  <mo>&#x22c5;</mo>
                  <msup>
                    <mstyle mathvariant="normal">
                      <mi>s</mi>
                    </mstyle>
                    <mrow>
                      <mo>&#x2212;</mo>
                      <mn>2</mn>
                    </mrow>
                  </msup>
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

    context "contains unitsml example #1 plurimath/asciimath2unitsml example #100" do
      let(:string) { '1 "unitsml(mm*s^-2)"' }

      it 'returns parsed Asciimath to Formula' do
        latex = '1 \\mathrm{mm} \\cdot \\mathrm{s}^{- 2}'
        asciimath = '1 rm(mm) * rm(s)^(- 2)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>1</mn>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>mm</mi>
                </mstyle>
                <mo>&#x22c5;</mo>
                <msup>
                  <mstyle mathvariant="normal">
                    <mi>s</mi>
                  </mstyle>
                  <mrow>
                    <mo>&#x2212;</mo>
                    <mn>2</mn>
                  </mrow>
                </msup>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains unitsml example #2 plurimath/asciimath2unitsml example #101" do
      let(:string) { '1 "unitsml(um)"' }

      it 'returns parsed Asciimath to Formula' do
        latex = '1 \\mathrm{&#xb5;m}'
        asciimath = '1 rm(&#xb5;m)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>1</mn>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>&#xb5;m</mi>
                </mstyle>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains unitsml example #3 plurimath/asciimath2unitsml example #102" do
      let(:string) { '1 "unitsml(degK)" + 1 "unitsml(prime)" + ii(theta) = s//r "unitsml(rad)" + 10^(12) "unitsml(Hz)"' }

      it 'returns parsed Asciimath to Formula' do
        latex = '1 \\mathrm{&#xb0;K} + 1 \\mathrm{\\prime} + \\mathit{\\theta} = s / r \\mathrm{rad} + 10^{12} \\mathrm{Hz}'
        asciimath = "1 rm(&#xb0;K) + 1 rm(prime) + ii(theta) = s // r rm(rad) + 10^(12) rm(Hz)"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>1</mn>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>&#xb0;K</mi>
                </mstyle>
              </mrow>
              <mo>+</mo>
              <mn>1</mn>
              <mo>&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mo>&#x2032;</mo>
                </mstyle>
              </mrow>
              <mo>+</mo>
              <mstyle mathvariant="italic">
                <mi>&#x3b8;</mi>
              </mstyle>
              <mo>=</mo>
              <mi>s</mi>
              <mo>/</mo>
              <mi>r</mi>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>rad</mi>
                </mstyle>
              </mrow>
              <mo>+</mo>
              <msup>
                <mn>10</mn>
                <mn>12</mn>
              </msup>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>Hz</mi>
                </mstyle>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains unitsml example #4 plurimath/asciimath2unitsml example #103" do
      let(:string) { '8 "unitsml(kg)" cdot "unitsml(m)"' }

      it 'returns parsed Asciimath to Formula' do
        latex = '8 \\mathrm{kg} \\cdot \\mathrm{m}'
        asciimath = "8 rm(kg) * rm(m)"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>8</mn>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>kg</mi>
                </mstyle>
              </mrow>
              <mo>&#x22c5;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>m</mi>
                </mstyle>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains unitsml example #5 plurimath/asciimath2unitsml example #104" do
      let(:string) { '1 "unitsml(sqrt(Hz))"' }

      it 'returns parsed Asciimath to Formula' do
        latex = '1 \\mathrm{Hz}^{0.5}'
        asciimath = "1 rm(Hz)^(0.5)"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>1</mn>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <msup>
                  <mstyle mathvariant="normal">
                    <mi>Hz</mi>
                  </mstyle>
                  <mn>0.5</mn>
                </msup>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains unitsml example #6 plurimath/asciimath2unitsml example #105" do
      let(:string) { '1 "unitsml(kg)" + 1 "unitsml(g)"' }

      it 'returns parsed Asciimath to Formula' do
        latex = '1 \mathrm{kg} + 1 \mathrm{g}'
        asciimath = "1 rm(kg) + 1 rm(g)"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>1</mn>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>kg</mi>
                </mstyle>
              </mrow>
              <mo>+</mo>
              <mn>1</mn>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>g</mi>
                </mstyle>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains unitsml example #7 plurimath/asciimath2unitsml example #106" do
      let(:string) { '"unitsml(u-)" + "unitsml(um)"' }

      it 'returns parsed Asciimath to Formula' do
        latex = 'u + \mathrm{&#xb5;m}'
        asciimath = "u + rm(&#xb5;m)"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mi>u</mi>
              </mrow>
              <mo>+</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>&#xb5;m</mi>
                </mstyle>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains unitsml example #1 plurimath/plurimath/pull/221 example #107" do
      let(:string) { '1 "unitsml(Aring)"' }

      it 'returns parsed Asciimath to Formula' do
        latex = '1 \mathrm{&#xc5;}'
        asciimath = "1 rm(&#xc5;)"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>1</mn>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>&#xc5;</mi>
                </mstyle>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains unitsml example #2 plurimath/plurimath/pull/221 example #108" do
      let(:string) { '1 "unitsml(deg)"' }

      it 'returns parsed Asciimath to Formula' do
        latex = '1 \mathrm{\\text{P[degree]}}'
        asciimath = "1 rm(\"P{degree}\")"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>1</mn>
              <mo>&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>&#xb0;</mi>
                </mstyle>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example from plurimath/pull/238 example #109" do
      let(:string) { 's_{"p"}^2 = {sum_{i=1}^{ii(N)} ii(nu)_i s_i^2}/{sum_{i=1}^{ii(N)} ii(nu)_i}' }

      it 'prevention of conversion from ternary functions to nary-and function' do
        latex = 's_{\text{p}}^{2} = \frac{\sum_{i = 1}^{\mathit{N}} \mathit{\nu}_{i} s_{i}^{2}}{\sum_{i = 1}^{\mathit{N}} \mathit{\nu}_{i}}'
        asciimath = 's_("p")^(2) = frac(sum_(i = 1)^(ii(N)) ii(nu)_(i) s_(i)^(2))(sum_(i = 1)^(ii(N)) ii(nu)_(i))'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mi>s</mi>
                <mtext>p</mtext>
                <mn>2</mn>
              </msubsup>
              <mo>=</mo>
              <mfrac>
                <mrow>
                  <mrow>
                    <munderover>
                      <mo>&#x2211;</mo>
                      <mrow>
                        <mi>i</mi>
                        <mo>=</mo>
                        <mn>1</mn>
                      </mrow>
                      <mstyle mathvariant="italic">
                        <mi>N</mi>
                      </mstyle>
                    </munderover>
                    <msub>
                      <mstyle mathvariant="italic">
                        <mi>&#x3bd;</mi>
                      </mstyle>
                      <mi>i</mi>
                    </msub>
                  </mrow>
                  <msubsup>
                    <mi>s</mi>
                    <mi>i</mi>
                    <mn>2</mn>
                  </msubsup>
                </mrow>
                <mrow>
                  <munderover>
                    <mo>&#x2211;</mo>
                    <mrow>
                      <mi>i</mi>
                      <mo>=</mo>
                      <mn>1</mn>
                    </mrow>
                    <mstyle mathvariant="italic">
                      <mi>N</mi>
                    </mstyle>
                  </munderover>
                  <msub>
                    <mstyle mathvariant="italic">
                      <mi>&#x3bd;</mi>
                    </mstyle>
                    <mi>i</mi>
                  </msub>
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

    context "contains example from plurimath/pull/240 example #110" do
      let(:string) { '1 "unitsml(A)" = (e/(1.602176634 xx 10^(-19))) "unitsml(s^(-1))"' }

      it 'returns parsed Asciimath to Formula' do
        latex = '1 \mathrm{A} = ( \frac{e}{1.602176634 \times 10^{- 19}} ) \mathrm{s}^{- 1}'
        asciimath = '1 rm(A) = (frac(e)(1.602176634 xx 10^(- 19))) rm(s)^(- 1)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>1</mn>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <mstyle mathvariant="normal">
                  <mi>A</mi>
                </mstyle>
              </mrow>
              <mo>=</mo>
              <mrow>
                <mo>(</mo>
                <mfrac>
                  <mi>e</mi>
                  <mrow>
                    <mn>1.602176634</mn>
                    <mo>&#xd7;</mo>
                    <msup>
                      <mn>10</mn>
                      <mrow>
                        <mo>&#x2212;</mo>
                        <mn>19</mn>
                      </mrow>
                    </msup>
                  </mrow>
                </mfrac>
                <mo>)</mo>
              </mrow>
              <mo rspace="thickmathspace">&#x2062;</mo>
              <mrow>
                <msup>
                  <mstyle mathvariant="normal">
                    <mi>s</mi>
                  </mstyle>
                  <mrow>
                    <mo>&#x2212;</mo>
                    <mn>1</mn>
                  </mrow>
                </msup>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example from plurimath/issues/232 example #111" do
      let(:string) { '((E_H^s),(E_V^s)) = e^(jkR)/R ([S_(HH),S_(HV)], [S_(VH), S_(VV)])((E_H^j), (E_V^j))' }

      it 'matches LaTeX, AsciiMath, and MathML' do
        latex = '\left (\begin{matrix}E_{H}^{s} \\\\ E_{V}^{s}\end{matrix}\right ) = \frac{e^{j k R}}{R} \left (\begin{matrix}S_{H H} & S_{H V} \\\\ S_{V H} & S_{V V}\end{matrix}\right ) \left (\begin{matrix}E_{H}^{j} \\\\ E_{V}^{j}\end{matrix}\right )'
        asciimath = '([E_(H)^(s)], [E_(V)^(s)]) = frac(e^(j k R))(R) ([S_(H H), S_(H V)], [S_(V H), S_(V V)]) ([E_(H)^(j)], [E_(V)^(j)])'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>(</mo>
                <mtable>
                  <mtr>
                    <mtd>
                      <msubsup>
                        <mi>E</mi>
                        <mi>H</mi>
                        <mi>s</mi>
                      </msubsup>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <msubsup>
                        <mi>E</mi>
                        <mi>V</mi>
                        <mi>s</mi>
                      </msubsup>
                    </mtd>
                  </mtr>
                </mtable>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <mfrac>
                <msup>
                  <mi>e</mi>
                  <mrow>
                    <mi>j</mi>
                    <mi>k</mi>
                    <mi>R</mi>
                  </mrow>
                </msup>
                <mi>R</mi>
              </mfrac>
              <mrow>
                <mrow>
                  <mo>(</mo>
                  <mtable>
                    <mtr>
                      <mtd>
                        <msub>
                          <mi>S</mi>
                          <mrow>
                            <mi>H</mi>
                            <mi>H</mi>
                          </mrow>
                        </msub>
                      </mtd>
                      <mtd>
                        <msub>
                          <mi>S</mi>
                          <mrow>
                            <mi>H</mi>
                            <mi>V</mi>
                          </mrow>
                        </msub>
                      </mtd>
                    </mtr>
                    <mtr>
                      <mtd>
                        <msub>
                          <mi>S</mi>
                          <mrow>
                            <mi>V</mi>
                            <mi>H</mi>
                          </mrow>
                        </msub>
                      </mtd>
                      <mtd>
                        <msub>
                          <mi>S</mi>
                          <mrow>
                            <mi>V</mi>
                            <mi>V</mi>
                          </mrow>
                        </msub>
                      </mtd>
                    </mtr>
                  </mtable>
                  <mo>)</mo>
                </mrow>
                <mrow>
                  <mo>(</mo>
                  <mtable>
                    <mtr>
                      <mtd>
                        <msubsup>
                          <mi>E</mi>
                          <mi>H</mi>
                          <mi>j</mi>
                        </msubsup>
                      </mtd>
                    </mtr>
                    <mtr>
                      <mtd>
                        <msubsup>
                          <mi>E</mi>
                          <mi>V</mi>
                          <mi>j</mi>
                        </msubsup>
                      </mtd>
                    </mtr>
                  </mtable>
                  <mo>)</mo>
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

    context "contains example from metanorma/metanorma-cli/pull/329 example #1 example #112" do
      let(:string) { '{ii(L)_{ii(lambda)} (ii(T)_{90})}/{ii(L)_{ii(lambda)} (ii(T)_{90} (ii(X)))} = {exp(c_2 / {ii(lambda) ii(T)_{90} (ii(X))}) - 1} / {exp (c_2 / {ii(lambda) ii(T)_{90}}) - 1} ,' }

      it 'matches LaTeX, AsciiMath, and MathML' do
        latex = '\frac{\mathit{L}_{\mathit{\lambda}} ( \mathit{T}_{90} )}{\mathit{L}_{\mathit{\lambda}} ( \mathit{T}_{90} ( \mathit{X} ) )} = \frac{\exp{( \frac{c_{2}}{\mathit{\lambda} \mathit{T}_{90} ( \mathit{X} )} )} - 1}{\exp{( \frac{c_{2}}{\mathit{\lambda} \mathit{T}_{90}} )} - 1} ,'
        asciimath = 'frac(ii(L)_(ii(lambda)) (ii(T)_(90)))(ii(L)_(ii(lambda)) (ii(T)_(90) (ii(X)))) = frac(exp(frac(c_(2))(ii(lambda) ii(T)_(90) (ii(X)))) - 1)(exp(frac(c_(2))(ii(lambda) ii(T)_(90))) - 1) ,'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfrac>
                <mrow>
                  <msub>
                    <mstyle mathvariant="italic">
                      <mi>L</mi>
                    </mstyle>
                    <mstyle mathvariant="italic">
                      <mi>&#x3bb;</mi>
                    </mstyle>
                  </msub>
                  <mrow>
                    <mo>(</mo>
                    <msub>
                      <mstyle mathvariant="italic">
                        <mi>T</mi>
                      </mstyle>
                      <mn>90</mn>
                    </msub>
                    <mo>)</mo>
                  </mrow>
                </mrow>
                <mrow>
                  <msub>
                    <mstyle mathvariant="italic">
                      <mi>L</mi>
                    </mstyle>
                    <mstyle mathvariant="italic">
                      <mi>&#x3bb;</mi>
                    </mstyle>
                  </msub>
                  <mrow>
                    <mo>(</mo>
                    <msub>
                      <mstyle mathvariant="italic">
                        <mi>T</mi>
                      </mstyle>
                      <mn>90</mn>
                    </msub>
                    <mrow>
                      <mo>(</mo>
                      <mstyle mathvariant="italic">
                        <mi>X</mi>
                      </mstyle>
                      <mo>)</mo>
                    </mrow>
                    <mo>)</mo>
                  </mrow>
                </mrow>
              </mfrac>
              <mo>=</mo>
              <mfrac>
                <mrow>
                  <mrow>
                    <mi>exp</mi>
                    <mrow>
                      <mo>(</mo>
                      <mfrac>
                        <msub>
                          <mi>c</mi>
                          <mn>2</mn>
                        </msub>
                        <mrow>
                          <mstyle mathvariant="italic">
                            <mi>&#x3bb;</mi>
                          </mstyle>
                          <msub>
                            <mstyle mathvariant="italic">
                              <mi>T</mi>
                            </mstyle>
                            <mn>90</mn>
                          </msub>
                          <mrow>
                            <mo>(</mo>
                            <mstyle mathvariant="italic">
                              <mi>X</mi>
                            </mstyle>
                            <mo>)</mo>
                          </mrow>
                        </mrow>
                      </mfrac>
                      <mo>)</mo>
                    </mrow>
                  </mrow>
                  <mo>&#x2212;</mo>
                  <mn>1</mn>
                </mrow>
                <mrow>
                  <mrow>
                    <mi>exp</mi>
                    <mrow>
                      <mo>(</mo>
                      <mfrac>
                        <msub>
                          <mi>c</mi>
                          <mn>2</mn>
                        </msub>
                        <mrow>
                          <mstyle mathvariant="italic">
                            <mi>&#x3bb;</mi>
                          </mstyle>
                          <msub>
                            <mstyle mathvariant="italic">
                              <mi>T</mi>
                            </mstyle>
                            <mn>90</mn>
                          </msub>
                        </mrow>
                      </mfrac>
                      <mo>)</mo>
                    </mrow>
                  </mrow>
                  <mo>&#x2212;</mo>
                  <mn>1</mn>
                </mrow>
              </mfrac>
              <mo>,</mo>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example from metanorma/metanorma-cli/pull/329 example #2 example #113" do
      let(:string) { 'ii(L)_{ii(lambda)} (ii(T)_{90}) = c_1 / {n_{ii(lambda)}^2 ii(lambda)^5} [exp(c_2 / {n_{ii(lambda)} ii(lambda) ii(T)_{90}}) - 1]^{-1}' }

      it 'matches LaTeX, AsciiMath, and MathML' do
        latex = '\mathit{L}_{\mathit{\lambda}} ( \mathit{T}_{90} ) = \frac{c_{1}}{n_{\mathit{\lambda}}^{2} \mathit{\lambda}^{5}} [ \exp{( \frac{c_{2}}{n_{\mathit{\lambda}} \mathit{\lambda} \mathit{T}_{90}} )} - 1 ]^{- 1}'
        asciimath = 'ii(L)_(ii(lambda)) (ii(T)_(90)) = frac(c_(1))(n_(ii(lambda))^(2) ii(lambda)^(5)) [exp(frac(c_(2))(n_(ii(lambda)) ii(lambda) ii(T)_(90))) - 1]^(- 1)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mstyle mathvariant="italic">
                  <mi>L</mi>
                </mstyle>
                <mstyle mathvariant="italic">
                  <mi>&#x3bb;</mi>
                </mstyle>
              </msub>
              <mrow>
                <mo>(</mo>
                <msub>
                  <mstyle mathvariant="italic">
                    <mi>T</mi>
                  </mstyle>
                  <mn>90</mn>
                </msub>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <mfrac>
                <msub>
                  <mi>c</mi>
                  <mn>1</mn>
                </msub>
                <mrow>
                  <msubsup>
                    <mi>n</mi>
                    <mstyle mathvariant="italic">
                      <mi>&#x3bb;</mi>
                    </mstyle>
                    <mn>2</mn>
                  </msubsup>
                  <msup>
                    <mstyle mathvariant="italic">
                      <mi>&#x3bb;</mi>
                    </mstyle>
                    <mn>5</mn>
                  </msup>
                </mrow>
              </mfrac>
              <msup>
                <mrow>
                  <mo>[</mo>
                  <mrow>
                    <mi>exp</mi>
                    <mrow>
                      <mo>(</mo>
                      <mfrac>
                        <msub>
                          <mi>c</mi>
                          <mn>2</mn>
                        </msub>
                        <mrow>
                          <msub>
                            <mi>n</mi>
                            <mstyle mathvariant="italic">
                              <mi>&#x3bb;</mi>
                            </mstyle>
                          </msub>
                          <mstyle mathvariant="italic">
                            <mi>&#x3bb;</mi>
                          </mstyle>
                          <msub>
                            <mstyle mathvariant="italic">
                              <mi>T</mi>
                            </mstyle>
                            <mn>90</mn>
                          </msub>
                        </mrow>
                      </mfrac>
                      <mo>)</mo>
                    </mrow>
                  </mrow>
                  <mo>&#x2212;</mo>
                  <mn>1</mn>
                  <mo>]</mo>
                </mrow>
                <mrow>
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

    context "contains example from plurimath/pull/244 example #114" do
      let(:string) { '[u_0, u_1, u_2, u_3, ... , u_n] "P{backepsilon}" [[0 leq u_i leq 1] wedge sum u_i = 1.0]' }

      it 'matches LaTeX, AsciiMath, and MathML' do
        latex = '[ u_{0} , u_{1} , u_{2} , u_{3} , \ldots , u_{n} ] \backepsilon [ [ 0 \le q u_{i} \le q 1 ] \land \sum u_{i} = 1.0 ]'
        asciimath = '[u_(0) , u_(1) , u_(2) , u_(3) , ... , u_(n)] "P{backepsilon}" [[0 le q u_(i) le q 1] ^^ sum u_(i) = 1.0]'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>[</mo>
                <msub>
                  <mi>u</mi>
                  <mn>0</mn>
                </msub>
                <mo>,</mo>
                <msub>
                  <mi>u</mi>
                  <mn>1</mn>
                </msub>
                <mo>,</mo>
                <msub>
                  <mi>u</mi>
                  <mn>2</mn>
                </msub>
                <mo>,</mo>
                <msub>
                  <mi>u</mi>
                  <mn>3</mn>
                </msub>
                <mo>,</mo>
                <mo>&#x2026;</mo>
                <mo>,</mo>
                <msub>
                  <mi>u</mi>
                  <mi>n</mi>
                </msub>
                <mo>]</mo>
              </mrow>
              <mi>&#x3f6;</mi>
              <mrow>
                <mo>[</mo>
                <mrow>
                  <mo>[</mo>
                  <mn>0</mn>
                  <mo>&#x2264;</mo>
                  <mi>q</mi>
                  <msub>
                    <mi>u</mi>
                    <mi>i</mi>
                  </msub>
                  <mo>&#x2264;</mo>
                  <mi>q</mi>
                  <mn>1</mn>
                  <mo>]</mo>
                </mrow>
                <mo>&#x2227;</mo>
                <mo>&#x2211;</mo>
                <msub>
                  <mi>u</mi>
                  <mi>i</mi>
                </msub>
                <mo>=</mo>
                <mn>1.0</mn>
                <mo>]</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example from metanorma-standoc specs #1 example #115" do
      let(:string) { "bar X' = (1)/(v) sum_(i = 1)^(v) t_(i)" }

      it 'matches LaTeX, AsciiMath, and MathML' do
        latex = '\overline{X} \prime = \frac{1}{v} \sum_{i = 1}^{v} t_{i}'
        asciimath = 'bar(X) prime = frac(1)(v) sum_(i = 1)^(v) t_(i)'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mi>X</mi>
                <mo>&#xaf;</mo>
              </mover>
              <mo>&#x2032;</mo>
              <mo>=</mo>
              <mfrac>
                <mn>1</mn>
                <mi>v</mi>
              </mfrac>
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mrow>
                    <mi>i</mi>
                    <mo>=</mo>
                    <mn>1</mn>
                  </mrow>
                  <mi>v</mi>
                </munderover>
                <msub>
                  <mi>t</mi>
                  <mi>i</mi>
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

    context "contains example from metanorma-standoc specs #2 example #116" do
      let(:string) { "|~ x ~|" }

      it 'matches LaTeX, AsciiMath, and MathML' do
        latex = '\lceil x \rceil'
        asciimath = '|~ x ~|'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mo>⌈</mo>
              <mi>x</mi>
              <mo>⌉</mo>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example from metanorma-standoc specs #3 example #117" do
      let(:string) { "|__ x __|" }

      it 'matches LaTeX, AsciiMath, and MathML' do
        latex = '\lfloor x \rfloor'
        asciimath = '|__ x __|'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mo>⌊</mo>
              <mi>x</mi>
              <mo>⌋</mo>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example from iso-10303 #1 example #118" do
      let(:string) { "λ(u) = C(u) + d \\< v × t \\>)," }

      it 'matches LaTeX, AsciiMath, and MathML' do
        latex = 'λ ( u ) = C ( u ) + d \backslash < v × t \backslash > ) ,'
        asciimath = 'λ (u) = C (u) + d \ lt v × t \ gt ) ,'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>λ</mi>
              <mrow>
                <mo>(</mo>
                <mi>u</mi>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <mi>C</mi>
              <mrow>
                <mo>(</mo>
                <mi>u</mi>
                <mo>)</mo>
              </mrow>
              <mo>+</mo>
              <mi>d</mi>
              <mo>\\</mo>
              <mo>&#x3c;</mo>
              <mi>v</mi>
              <mi>×</mi>
              <mi>t</mi>
              <mo>\\</mo>
              <mo>&#x3e;</mo>
              <mo>)</mo>
              <mo>,</mo>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains example from plrimath/issue#265 example #119" do
      let(:string) { '"ISLR"=10log_10 {(P_("total")-P_("main"))/P_("main") }' }

      it 'matches LaTeX, AsciiMath, and MathML' do
        latex = '\text{ISLR} = 10 \log_{10} \{ \frac{P_{\text{total}} - P_{\text{main}}}{P_{\text{main}}} \}'
        asciimath = '"ISLR" = 10 log_(10) {frac(P_("total") - P_("main"))(P_("main"))}'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtext>ISLR</mtext>
              <mo>=</mo>
              <mn>10</mn>
              <msub>
                <mi>log</mi>
                <mn>10</mn>
              </msub>
              <mrow>
                <mo>{</mo>
                <mfrac>
                  <mrow>
                    <msub>
                      <mi>P</mi>
                      <mtext>total</mtext>
                    </msub>
                    <mo>&#x2212;</mo>
                    <msub>
                      <mi>P</mi>
                      <mtext>main</mtext>
                    </msub>
                  </mrow>
                  <msub>
                    <mi>P</mi>
                    <mtext>main</mtext>
                  </msub>
                </mfrac>
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

    context "contains example from plrimath/issue#276 example #120" do
      let(:string) { '"Pr"[]' }

      it 'matches LaTeX, AsciiMath, and MathML' do
        latex = '\text{Pr} [  ]'
        asciimath = '"Pr" []'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtext>Pr</mtext>
              <mrow>
                <mo>[</mo>
                <mo>]</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end

    context "contains much less and greater than request example from plrimath/issue#308 example #121" do
      let(:string) { 'll or mlt & gg or mgt' }

      it 'matches LaTeX, AsciiMath, and MathML' do
        latex = "\\ll o r \\ll \\& \\gg o r \\gg"
        asciimath = "ll o r ll & gg o r gg"
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>&#x226a;</mi>
              <mi>o</mi>
              <mi>r</mi>
              <mi>&#x226a;</mi>
              <mo>&</mo>
              <mi>&#x226b;</mi>
              <mi>o</mi>
              <mi>r</mi>
              <mi>&#x226b;</mi>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eql(asciimath)
      end
    end
  end

  describe ".to_omml" do
    subject(:formula) { Plurimath::Asciimath.new(string).to_formula.to_omml(display_style: display_style) }
    let(:display_style) { true }

    context "contains simple fenced example #01" do
      let(:string) { 'left ( d2 right )' }

      it 'returns OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:r>
                <m:t>(</m:t>
              </m:r>
              <m:r>
                <m:t>d</m:t>
              </m:r>
              <m:r>
                <m:t>2</m:t>
              </m:r>
              <m:r>
                <m:t>)</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains simple log power base valued example #02" do
      let(:string) { 'log_(d)^(d)log_(100)^(dd)log^(dd)' }

      it 'returns OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:sSubSup>
                <m:sSubSupPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:sSubSupPr>
                <m:e>
                  <m:r>
                    <m:rPr>
                      <m:sty m:val="p"/>
                    </m:rPr>
                    <m:t>log</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:sup>
              </m:sSubSup>
              <m:sSubSup>
                <m:sSubSupPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:sSubSupPr>
                <m:e>
                  <m:r>
                    <m:rPr>
                      <m:sty m:val="p"/>
                    </m:rPr>
                    <m:t>log</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>100</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:sup>
              </m:sSubSup>
              <m:sSubSup>
                <m:sSubSupPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:sSubSupPr>
                <m:e>
                  <m:r>
                    <m:rPr>
                      <m:sty m:val="p"/>
                    </m:rPr>
                    <m:t>log</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>&#8203;</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:sup>
              </m:sSubSup>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains simple table example #03" do
      let(:string) { '[(a,b,0),(c,d,0),(e,f,1)]' }

      it 'returns OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="["/>
                  <m:endChr m:val="]"/>
                  <m:sepChr m:val=""/>
                  <m:grow/>
                </m:dPr>
                <m:e>
                  <m:m>
                    <m:mPr>
                      <m:mcs>
                        <m:mc>
                          <m:mcPr>
                            <m:count m:val="3"/>
                            <m:mcJc m:val="center"/>
                          </m:mcPr>
                        </m:mc>
                      </m:mcs>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:mPr>
                    <m:mr>
                      <m:e>
                        <m:r>
                          <m:t>a</m:t>
                        </m:r>
                      </m:e>
                      <m:e>
                        <m:r>
                          <m:t>b</m:t>
                        </m:r>
                      </m:e>
                      <m:e>
                        <m:r>
                          <m:t>0</m:t>
                        </m:r>
                      </m:e>
                    </m:mr>
                    <m:mr>
                      <m:e>
                        <m:r>
                          <m:t>c</m:t>
                        </m:r>
                      </m:e>
                      <m:e>
                        <m:r>
                          <m:t>d</m:t>
                        </m:r>
                      </m:e>
                      <m:e>
                        <m:r>
                          <m:t>0</m:t>
                        </m:r>
                      </m:e>
                    </m:mr>
                    <m:mr>
                      <m:e>
                        <m:r>
                          <m:t>e</m:t>
                        </m:r>
                      </m:e>
                      <m:e>
                        <m:r>
                          <m:t>f</m:t>
                        </m:r>
                      </m:e>
                      <m:e>
                        <m:r>
                          <m:t>1</m:t>
                        </m:r>
                      </m:e>
                    </m:mr>
                  </m:m>
                </m:e>
              </m:d>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains simple ddot as value in abs function example #04" do
      let(:string) { 'abs(ddot(sum))' }

      it 'returns OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:d>
                <m:dPr>
                  <w:rPr>
                    <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                  </w:rPr>
                  <m:begChr m:val="|"/>
                  <m:endChr m:val="|"/>
                  <m:sepChr m:val=""/>
                  <m:grow/>
                </m:dPr>
                <m:e>
                  <m:limUpp>
                    <m:limUppPr>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:limUppPr>
                    <m:e>
                      <m:r>
                        <m:t>&#x2211;</m:t>
                      </m:r>
                    </m:e>
                    <m:lim>
                      <m:r>
                        <m:t>..</m:t>
                      </m:r>
                    </m:lim>
                  </m:limUpp>
                </m:e>
              </m:d>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains simple font style and sqrt functions example #05" do
      let(:string) { 'ii(E)[ii(S)//sqrt(n)\ ' }

      it 'returns OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:r>
                <m:rPr>
                  <m:sty m:val="i"/>
                </m:rPr>
                <m:t>E</m:t>
              </m:r>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="["/>
                  <m:sepChr m:val=""/>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:rPr>
                      <m:sty m:val="i"/>
                    </m:rPr>
                    <m:t>S</m:t>
                  </m:r>
                  <m:r>
                    <m:t>/</m:t>
                  </m:r>
                  <m:rad>
                    <m:radPr>
                      <m:degHide m:val="on"/>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:radPr>
                    <m:deg/>
                    <m:e>
                      <m:r>
                        <m:t>n</m:t>
                      </m:r>
                    </m:e>
                  </m:rad>
                  <m:r>
                    <m:t>&#xa0;</m:t>
                  </m:r>
                </m:e>
              </m:d>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains simple lim example #06" do
      let(:string) { 'lim_2^d' }

      it 'returns OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:limLow>
                <m:limLowPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:limLowPr>
                <m:e>
                  <m:limUpp>
                    <m:limUppPr>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:limUppPr>
                    <m:e>
                      <m:r>
                        <m:t>lim</m:t>
                      </m:r>
                    </m:e>
                    <m:lim>
                      <m:r>
                        <m:t>d</m:t>
                      </m:r>
                    </m:lim>
                  </m:limUpp>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>2</m:t>
                  </m:r>
                </m:lim>
              </m:limLow>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains simple cancel example #08" do
      let(:string) { 'cancel(2)' }

      it 'returns OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:r>
                <m:t>2</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains simple ceil example #09" do
      let(:string) { 'ceil(2)' }

      it 'returns OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="⌈"/>
                  <m:sepChr m:val=""/>
                  <m:endChr m:val="⌉"/>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>2</m:t>
                  </m:r>
                </m:e>
              </m:d>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains simple color example #10" do
      let(:string) { "color(red)(2 \\ \n e)" }

      it 'returns OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:r>
                <m:t>2</m:t>
              </m:r>
              <m:r>
                <m:t>e</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains simple det dim dot example #11" do
      let(:string) { 'det(theta)dim(3)dot(sigma)' }

      it 'returns OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:r>
                <m:t>det</m:t>
              </m:r>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="("/>
                  <m:sepChr m:val=""/>
                  <m:endChr m:val=")"/>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>&#x3b8;</m:t>
                  </m:r>
                </m:e>
              </m:d>
              <m:r>
                <m:t>dim</m:t>
              </m:r>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="("/>
                  <m:sepChr m:val=""/>
                  <m:endChr m:val=")"/>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>3</m:t>
                  </m:r>
                </m:e>
              </m:d>
              <m:limUpp>
                <m:limUppPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:limUppPr>
                <m:e>
                  <m:r>
                    <m:t>&#x3c3;</m:t>
                  </m:r>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>.</m:t>
                  </m:r>
                </m:lim>
              </m:limUpp>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains oint example #12" do
      let(:string) { 'oint_(sum)^d oint' }

      it 'returns Oint OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:nary>
                <m:naryPr>
                  <m:chr m:val="∮"/>
                  <m:limLoc m:val="subSup"/>
                  <m:subHide m:val="0"/>
                  <m:supHide m:val="0"/>
                </m:naryPr>
                <m:sub>
                  <m:r>
                    <m:t>&#x2211;</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:sup>
                <m:e>
                  <m:r>
                    <m:t>&#x222e;</m:t>
                  </m:r>
                </m:e>
              </m:nary>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to eql(omml)
      end
    end

    context "contains multiple unary classes example #13" do
      let(:string) { 'hat(ab) bar(xy) ul(A) vec(v)' }

      it 'returns parsed Asciimath to Formula' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:limUpp>
                <m:limUppPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:limUppPr>
                <m:e>
                  <m:r>
                    <m:t>a</m:t>
                  </m:r>
                  <m:r>
                    <m:t>b</m:t>
                  </m:r>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>&#x302;</m:t>
                  </m:r>
                </m:lim>
              </m:limUpp>
              <m:bar>
                <m:barPr>
                  <m:pos m:val="top"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:barPr>
                <m:e>
                  <m:r>
                    <m:t>x</m:t>
                  </m:r>
                  <m:r>
                    <m:t>y</m:t>
                  </m:r>
                </m:e>
              </m:bar>
              <m:limLow>
                <m:limLowPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:limLowPr>
                <m:e>
                  <m:r>
                    <m:t>A</m:t>
                  </m:r>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>&#x332;</m:t>
                  </m:r>
                </m:lim>
              </m:limLow>
              <m:limUpp>
                <m:limUppPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:limUppPr>
                <m:e>
                  <m:r>
                    <m:t>v</m:t>
                  </m:r>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>→</m:t>
                  </m:r>
                </m:lim>
              </m:limUpp>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains obrace, ubrace, tilde, mod, and stackrel examples #14" do
      let(:string) { 'obrace(sum) ubrace(sum) tilde(d) 1 mod theta stackrel(as)(d)' }

      it 'returns parsed Asciimath to Formula' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:limUpp>
                <m:limUppPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:limUppPr>
                <m:e>
                  <m:r>
                    <m:t>&#x2211;</m:t>
                  </m:r>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>⏞</m:t>
                  </m:r>
                </m:lim>
              </m:limUpp>
              <m:limLow>
                <m:limLowPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:limLowPr>
                <m:e>
                  <m:r>
                    <m:t>&#x2211;</m:t>
                  </m:r>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>⏟</m:t>
                  </m:r>
                </m:lim>
              </m:limLow>
              <m:limUpp>
                <m:limUppPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:limUppPr>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>~</m:t>
                  </m:r>
                </m:lim>
              </m:limUpp>
              <m:r>
                <m:t>1</m:t>
              </m:r>
              <m:r>
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>mod</m:t>
              </m:r>
              <m:r>
                <m:t>&#x3b8;</m:t>
              </m:r>
              <m:limUpp>
                <m:limUppPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:limUppPr>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>a</m:t>
                  </m:r>
                  <m:r>
                    <m:t>s</m:t>
                  </m:r>
                </m:lim>
              </m:limUpp>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains lcm, exp, gcd, glb, ln, lub, max, min, floor, and norm examples #15" do
      let(:string) { 'lcm(d) exp(d) gcd(d) glb(d) ln(d) lub(d) max(d) min(d) floor(d) norm(d)' }

      it 'returns parsed Asciimath to Formula' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:r>
                <m:t>lcm</m:t>
              </m:r>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="("/>
                  <m:sepChr m:val=""/>
                  <m:endChr m:val=")"/>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
              </m:d>
              <m:r>
                <m:t>exp</m:t>
              </m:r>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="("/>
                  <m:sepChr m:val=""/>
                  <m:endChr m:val=")"/>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
              </m:d>
              <m:r>
                <m:t>gcd</m:t>
              </m:r>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="("/>
                  <m:sepChr m:val=""/>
                  <m:endChr m:val=")"/>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
              </m:d>
              <m:r>
                <m:t>glb</m:t>
              </m:r>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="("/>
                  <m:sepChr m:val=""/>
                  <m:endChr m:val=")"/>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
              </m:d>
              <m:r>
                <m:t>ln</m:t>
              </m:r>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="("/>
                  <m:sepChr m:val=""/>
                  <m:endChr m:val=")"/>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
              </m:d>
              <m:r>
                <m:t>lub</m:t>
              </m:r>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="("/>
                  <m:sepChr m:val=""/>
                  <m:endChr m:val=")"/>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
              </m:d>
              <m:r>
                <m:t>max</m:t>
              </m:r>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="("/>
                  <m:sepChr m:val=""/>
                  <m:endChr m:val=")"/>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
              </m:d>
              <m:r>
                <m:t>min</m:t>
              </m:r>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="("/>
                  <m:sepChr m:val=""/>
                  <m:endChr m:val=")"/>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
              </m:d>
              <m:r>
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>⌊</m:t>
              </m:r>
              <m:r>
                <m:t>d</m:t>
              </m:r>
              <m:r>
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>⌋</m:t>
              </m:r>
              <m:r>
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>∥</m:t>
              </m:r>
              <m:r>
                <m:t>d</m:t>
              </m:r>
              <m:r>
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>∥</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains ubrace and bigwedge power base values examples #16" do
      let(:string) { 'ubrace_d^2 bigwedge_2^d' }

      it 'returns parsed Asciimath to Formula' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:limLow>
                <m:limLowPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:limLowPr>
                <m:e>
                  <m:r>
                    <m:t>_</m:t>
                  </m:r>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>⏟</m:t>
                  </m:r>
                </m:lim>
              </m:limLow>
              <m:sSup>
                <m:sSupPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:sSupPr>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
                <m:sup>
                  <m:r>
                    <m:t>2</m:t>
                  </m:r>
                </m:sup>
              </m:sSup>
              <m:sSubSup>
                <m:sSubSupPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:sSubSupPr>
                <m:e>
                  <m:r>
                    <m:t>&#x22c0;</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>2</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:sup>
              </m:sSubSup>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains simple lim example #17" do
      let(:string) { 'lim_2^d' }
      let(:display_style) { false }

      it 'returns OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:sSubSup>
                <m:sSubSupPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:sSubSupPr>
                <m:e>
                  <m:r>
                    <m:t>lim</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>2</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:sup>
              </m:sSubSup>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end

    context "contains power and fenced example #18" do
      let(:string) { "ii(rho)_{ij} = ii(nu)(w_i, w_j)//(ii(sigma)_i^2 ii(sigma)_j^2)^{1//2} \"unitsml(mm*s^-2)\"" }
      let(:display_style) { false }

      it 'returns OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:sSub>
                <m:sSubPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:sSubPr>
                <m:e>
                  <m:r>
                    <m:rPr>
                      <m:sty m:val="i"/>
                    </m:rPr>
                    <m:t>&#x3c1;</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>i</m:t>
                  </m:r>
                  <m:r>
                    <m:t>j</m:t>
                  </m:r>
                </m:sub>
              </m:sSub>
              <m:r>
                <m:t>=</m:t>
              </m:r>
              <m:r>
                <m:rPr>
                  <m:sty m:val="i"/>
                </m:rPr>
                <m:t>&#x3bd;</m:t>
              </m:r>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="("/>
                  <m:sepChr m:val=""/>
                  <m:endChr m:val=")"/>
                </m:dPr>
                <m:e>
                  <m:sSub>
                    <m:sSubPr>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:sSubPr>
                    <m:e>
                      <m:r>
                        <m:t>w</m:t>
                      </m:r>
                    </m:e>
                    <m:sub>
                      <m:r>
                        <m:t>i</m:t>
                      </m:r>
                    </m:sub>
                  </m:sSub>
                  <m:r>
                    <m:t>,</m:t>
                  </m:r>
                  <m:sSub>
                    <m:sSubPr>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:sSubPr>
                    <m:e>
                      <m:r>
                        <m:t>w</m:t>
                      </m:r>
                    </m:e>
                    <m:sub>
                      <m:r>
                        <m:t>j</m:t>
                      </m:r>
                    </m:sub>
                  </m:sSub>
                </m:e>
              </m:d>
              <m:r>
                <m:t>/</m:t>
              </m:r>
              <m:sSup>
                <m:sSupPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:sSupPr>
                <m:e>
                  <m:d>
                    <m:dPr>
                      <m:begChr m:val="("/>
                      <m:sepChr m:val=""/>
                      <m:endChr m:val=")"/>
                    </m:dPr>
                    <m:e>
                      <m:sSubSup>
                        <m:sSubSupPr>
                          <m:ctrlPr>
                            <w:rPr>
                              <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                              <w:i/>
                            </w:rPr>
                          </m:ctrlPr>
                        </m:sSubSupPr>
                        <m:e>
                          <m:r>
                            <m:rPr>
                              <m:sty m:val="i"/>
                            </m:rPr>
                            <m:t>&#x3c3;</m:t>
                          </m:r>
                        </m:e>
                        <m:sub>
                          <m:r>
                            <m:t>i</m:t>
                          </m:r>
                        </m:sub>
                        <m:sup>
                          <m:r>
                            <m:t>2</m:t>
                          </m:r>
                        </m:sup>
                      </m:sSubSup>
                      <m:sSubSup>
                        <m:sSubSupPr>
                          <m:ctrlPr>
                            <w:rPr>
                              <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                              <w:i/>
                            </w:rPr>
                          </m:ctrlPr>
                        </m:sSubSupPr>
                        <m:e>
                          <m:r>
                            <m:rPr>
                              <m:sty m:val="i"/>
                            </m:rPr>
                            <m:t>&#x3c3;</m:t>
                          </m:r>
                        </m:e>
                        <m:sub>
                          <m:r>
                            <m:t>j</m:t>
                          </m:r>
                        </m:sub>
                        <m:sup>
                          <m:r>
                            <m:t>2</m:t>
                          </m:r>
                        </m:sup>
                      </m:sSubSup>
                    </m:e>
                  </m:d>
                </m:e>
                <m:sup>
                  <m:r>
                    <m:t>1</m:t>
                  </m:r>
                  <m:r>
                    <m:t>/</m:t>
                  </m:r>
                  <m:r>
                    <m:t>2</m:t>
                  </m:r>
                </m:sup>
              </m:sSup>
              <m:r>
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>mm</m:t>
              </m:r>
              <m:r>
                <m:t>&#x22c5;</m:t>
              </m:r>
              <m:sSup>
                <m:sSupPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:sSupPr>
                <m:e>
                  <m:r>
                    <m:rPr>
                      <m:sty m:val="p"/>
                    </m:rPr>
                    <m:t>s</m:t>
                  </m:r>
                </m:e>
                <m:sup>
                  <m:r>
                    <m:t>&#x2212;</m:t>
                  </m:r>
                  <m:r>
                    <m:t>2</m:t>
                  </m:r>
                </m:sup>
              </m:sSup>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to be_equivalent_to(omml)
      end
    end
  end
end
