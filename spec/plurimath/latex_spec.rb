require_relative '../../spec/spec_helper'

RSpec.describe Plurimath::Latex do

  describe ".initialize" do
    subject(:latex) { described_class.new(string.gsub(/\s/, "")) }

    context "contains simple cos function with numeric value" do
      let(:string) { "\\cos_{45}" }
      it 'matches instance of Latex' do
        expect(latex).to be_a(Plurimath::Latex)
      end

      it 'matches text from Latex instance' do
        expect(latex.text).to eq('\\cos_{45}')
      end
    end
  end

  describe ".to_formula" do
    subject(:formula) { described_class.new(string.gsub(/\s/, "")).to_formula }

    context "contains basic simple Latex equation cos and numeric value" do
      let(:string) { '\\cos{45}' }
      it 'returns parsed Latex to Formula' do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Cos.new(
            Plurimath::Math::Number.new("45"),
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) { described_class.new(string.gsub(/\s/, "")).to_formula }

    context "contains example #01" do
      let(:string) { '\\cos{45}' }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mi>cos</mi>
                <mn>45</mn>
              </mrow>
            </mstyle>
          </math>
        MATHML
        latex = "\\cos{45}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #02" do
      let(:string) { '1 \\over 2' }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfrac>
                <mrow>
                  <mn>1</mn>
                </mrow>
                <mrow>
                  <mn>2</mn>
                </mrow>
              </mfrac>
            </mstyle>
          </math>
        MATHML
        latex = "{1 \\over 2}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #03" do
      let(:string) { "L' \\over {1\\over2}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfrac>
                <mrow>
                  <mi>L</mi>
                  <mo>&#x27;</mo>
                </mrow>
                <mrow>
                  <mfrac>
                    <mrow>
                      <mn>1</mn>
                    </mrow>
                    <mrow>
                      <mn>2</mn>
                    </mrow>
                  </mfrac>
                </mrow>
              </mfrac>
            </mstyle>
          </math>
        MATHML
        latex = "L{' \\over {1 \\over 2}}"
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #04" do
      let(:string) { '\\left\\{\\right.' }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mo>{</mo>
              <mo/>
            </mstyle>
          </math>
        MATHML
        latex = "\\left \\{ \\right ."
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #05" do
      let(:string) { '\\begin{matrix}a & b \\\\ c & d \\end{matrix}' }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
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
            </mstyle>
          </math>
        MATHML
        latex = "\\begin{matrix}a & b \\\\ c & d\\end{matrix}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #06" do
      let(:string) do
        <<~LATEX
          \\left\\{
            \\begin{array}{ l|cr }{ 3x - 5y + 4z = 0} & d \\\\ { x - y + 8z = 0} & e \\\\{ 2x - 6y + z = 0} & c \\end{array}
          \\right\\}
        LATEX
      end

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mo>{</mo>
              <mtable columnlines="solid none">
                <mtr>
                  <mtd columnalign="left">
                    <mrow>
                      <mn>3</mn>
                      <mi>x</mi>
                      <mo>&#x2212;</mo>
                      <mn>5</mn>
                      <mi>y</mi>
                      <mo>+</mo>
                      <mn>4</mn>
                      <mi>z</mi>
                      <mo>=</mo>
                      <mn>0</mn>
                    </mrow>
                  </mtd>
                  <mtd columnalign="center">
                    <mi>d</mi>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd columnalign="left">
                    <mrow>
                      <mi>x</mi>
                      <mo>&#x2212;</mo>
                      <mi>y</mi>
                      <mo>+</mo>
                      <mn>8</mn>
                      <mi>z</mi>
                      <mo>=</mo>
                      <mn>0</mn>
                    </mrow>
                  </mtd>
                  <mtd columnalign="center">
                    <mi>e</mi>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd columnalign="left">
                    <mrow>
                      <mn>2</mn>
                      <mi>x</mi>
                      <mo>&#x2212;</mo>
                      <mn>6</mn>
                      <mi>y</mi>
                      <mo>+</mo>
                      <mi>z</mi>
                      <mo>=</mo>
                      <mn>0</mn>
                    </mrow>
                  </mtd>
                  <mtd columnalign="center">
                    <mi>c</mi>
                  </mtd>
                </mtr>
              </mtable>
              <mo>}</mo>
            </mstyle>
          </math>
        MATHML
        latex = "\\left \\{ \\begin{array}{l|c}3 x - 5 y + 4 z = 0 & d \\\\ x - y + 8 z = 0 & e \\\\ 2 x - 6 y + z = 0 & c\\end{array} \\right \\}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #07" do
      let(:string) { "\\begin{matrix*}[r]a & b \\\\ c & d \\end{matrix*}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable>
                <mtr>
                  <mtd columnalign="right">
                    <mi>a</mi>
                  </mtd>
                  <mtd columnalign="right">
                    <mi>b</mi>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd columnalign="right">
                    <mi>c</mi>
                  </mtd>
                  <mtd columnalign="right">
                    <mi>d</mi>
                  </mtd>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
        latex = "\\begin{matrix*}[r]a & b \\\\ c & d\\end{matrix*}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #08" do
      let(:string) { "\\begin{matrix*}[r]a & b \\\\ c & d \\end{matrix*}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable>
                <mtr>
                  <mtd columnalign="right">
                    <mi>a</mi>
                  </mtd>
                  <mtd columnalign="right">
                    <mi>b</mi>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd columnalign="right">
                    <mi>c</mi>
                  </mtd>
                  <mtd columnalign="right">
                    <mi>d</mi>
                  </mtd>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
        latex = "\\begin{matrix*}[r]a & b \\\\ c & d\\end{matrix*}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #09" do
      let(:string) { "\\begin{matrix}-a & b \\\\ c & d \\end{matrix}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable>
                <mtr>
                  <mtd>
                    <mrow>
                      <mo>&#x2212;</mo>
                      <mi>a</mi>
                    </mrow>
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
            </mstyle>
          </math>
        MATHML
        latex = "\\begin{matrix}- a & b \\\\ c & d\\end{matrix}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #10" do
      let(:string) { "\\begin{matrix}-\\end{matrix}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable>
                <mtr>
                  <mtd>
                    <mo>&#x2212;</mo>
                  </mtd>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
        latex = "\\begin{matrix}-\\end{matrix}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #11" do
      let(:string) { "\\begin{matrix}a_{1} & b_{2} \\\\ c_{3} & d_{4} \\end{matrix}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable>
                <mtr>
                  <mtd>
                    <msub>
                      <mi>a</mi>
                      <mn>1</mn>
                    </msub>
                  </mtd>
                  <mtd>
                    <msub>
                      <mi>b</mi>
                      <mn>2</mn>
                    </msub>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd>
                    <msub>
                      <mi>c</mi>
                      <mn>3</mn>
                    </msub>
                  </mtd>
                  <mtd>
                    <msub>
                      <mi>d</mi>
                      <mn>4</mn>
                    </msub>
                  </mtd>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
        latex = "\\begin{matrix}a_{1} & b_{2} \\\\ c_{3} & d_{4}\\end{matrix}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #12" do
      let(:string) { "\\begin{array}{cc} 1 & 2 \\\\ 3 & 4 \\end{array}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable>
                <mtr>
                  <mtd columnalign="center">
                    <mn>1</mn>
                  </mtd>
                  <mtd columnalign="center">
                    <mn>2</mn>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd columnalign="center">
                    <mn>3</mn>
                  </mtd>
                  <mtd columnalign="center">
                    <mn>4</mn>
                  </mtd>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
        latex = "\\begin{array}{cc}1 & 2 \\\\ 3 & 4\\end{array}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #13" do
      let(:string) do
        <<~LATEX
          \\begin{bmatrix}
            a_{1,1} & a_{1,2} & \\cdots & a_{1,n} \\\\
            a_{2,1} & a_{2,2} & \\cdots & a_{2,n} \\\\
            \\vdots & \\vdots & \\ddots & \\vdots \\\\
            a_{m,1} & a_{m,2} & \\cdots & a_{m,n}
          \\end{bmatrix}
        LATEX
      end

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfenced open="[" close="]">
                <mtable>
                  <mtr>
                    <mtd>
                      <msub>
                        <mi>a</mi>
                        <mrow>
                          <mn>1</mn>
                          <mo>,</mo>
                          <mn>1</mn>
                        </mrow>
                      </msub>
                    </mtd>
                    <mtd>
                      <msub>
                        <mi>a</mi>
                        <mrow>
                          <mn>1</mn>
                          <mo>,</mo>
                          <mn>2</mn>
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
                          <mn>1</mn>
                          <mo>,</mo>
                          <mi>n</mi>
                        </mrow>
                      </msub>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <msub>
                        <mi>a</mi>
                        <mrow>
                          <mn>2</mn>
                          <mo>,</mo>
                          <mn>1</mn>
                        </mrow>
                      </msub>
                    </mtd>
                    <mtd>
                      <msub>
                        <mi>a</mi>
                        <mrow>
                          <mn>2</mn>
                          <mo>,</mo>
                          <mn>2</mn>
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
                          <mn>2</mn>
                          <mo>,</mo>
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
                          <mo>,</mo>
                          <mn>1</mn>
                        </mrow>
                      </msub>
                    </mtd>
                    <mtd>
                      <msub>
                        <mi>a</mi>
                        <mrow>
                          <mi>m</mi>
                          <mo>,</mo>
                          <mn>2</mn>
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
                          <mo>,</mo>
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
        latex = "\\begin{bmatrix}a_{1 , 1} & a_{1 , 2} & \\cdots & a_{1 , n} \\\\ a_{2 , 1} & a_{2 , 2} & \\cdots & a_{2 , n} \\\\ \\vdots & \\vdots & \\ddots & \\vdots \\\\ a_{m , 1} & a_{m , 2} & \\cdots & a_{m , n}\\end{bmatrix}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #14" do
      let(:string) { "\\sqrt { ( - 25 ) ^ { 2 } } = \\pm 25" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msqrt>
                <msup>
                  <mrow>
                    <mo>(</mo>
                    <mo>&#x2212;</mo>
                    <mn>25</mn>
                    <mo>)</mo>
                  </mrow>
                  <mn>2</mn>
                </msup>
              </msqrt>
              <mo>=</mo>
              <mo>&#xb1;</mo>
              <mn>25</mn>
            </mstyle>
          </math>
        MATHML
        latex = "\\sqrt{( - 25 )^{2}} = \\pm 25"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #15" do
      let(:string) { "\\left(- x^{3} + 5\\right)^{5}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msup>
                <mrow>
                  <mo>(</mo>
                  <mrow>
                    <mo>&#x2212;</mo>
                    <msup>
                      <mi>x</mi>
                      <mn>3</mn>
                    </msup>
                    <mo>+</mo>
                    <mn>5</mn>
                  </mrow>
                  <mo>)</mo>
                </mrow>
                <mn>5</mn>
              </msup>
            </mstyle>
          </math>
        MATHML
        latex = "\\left ( - x^{3} + 5 \\right )^{5}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #16" do
      let(:string) do
        <<~LATEX
          \\begin{array}{rcl}
            ABC&=&a\\\\
            A&=&abc
          \\end{array}
        LATEX
      end

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable>
                <mtr>
                  <mtd columnalign="right">
                    <mi>A</mi>
                    <mi>B</mi>
                    <mi>C</mi>
                  </mtd>
                  <mtd columnalign="center">
                    <mo>=</mo>
                  </mtd>
                  <mtd columnalign="left">
                    <mi>a</mi>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd columnalign="right">
                    <mi>A</mi>
                  </mtd>
                  <mtd columnalign="center">
                    <mo>=</mo>
                  </mtd>
                  <mtd columnalign="left">
                    <mi>a</mi>
                    <mi>b</mi>
                    <mi>c</mi>
                  </mtd>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
        latex = "\\begin{array}{rcl}A B C & = & a \\\\ A & = & a b c\\end{array}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #17" do
      let(:string) do
        <<~LATEX
          \\begin{array}{c|r}
            1 & 2 \\\\
            3 & 4 \\\\
            \\hline 5 & 6
          \\end{array}
        LATEX
      end

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable rowline="none none solid" columnlines="solid none">
                <mtr>
                  <mtd columnalign="center">
                    <mn>1</mn>
                  </mtd>
                  <mtd columnalign="right">
                    <mn>2</mn>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd columnalign="center">
                    <mn>3</mn>
                  </mtd>
                  <mtd columnalign="right">
                    <mn>4</mn>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd columnalign="center">
                    <mn>5</mn>
                  </mtd>
                  <mtd columnalign="right">
                    <mn>6</mn>
                  </mtd>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
        latex = "\\begin{array}{c|r}1 & 2 \\\\ 3 & 4 \\\\ \\hline 5 & 6\\end{array}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #18" do
      let(:string) do
        <<~LATEX
          \\begin{array}{cr}
            1 & 2 \\\\
            \\hline 3 & 4 \\\\
            \\hline 5 & 6
          \\end{array}
        LATEX
      end

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable rowline="none solid solid">
                <mtr>
                  <mtd columnalign="center">
                    <mn>1</mn>
                  </mtd>
                  <mtd columnalign="right">
                    <mn>2</mn>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd columnalign="center">
                    <mn>3</mn>
                  </mtd>
                  <mtd columnalign="right">
                    <mn>4</mn>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd columnalign="center">
                    <mn>5</mn>
                  </mtd>
                  <mtd columnalign="right">
                    <mn>6</mn>
                  </mtd>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
        latex = "\\begin{array}{cr}1 & 2 \\\\ \\hline 3 & 4 \\\\ \\hline 5 & 6\\end{array}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #19" do
      let(:string) { "\\mathrm{...}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathvariant="normal">
                <mrow>
                  <mo>&#x2e;</mo>
                  <mo>&#x2e;</mo>
                  <mo>&#x2e;</mo>
                </mrow>
              </mstyle>
            </mstyle>
          </math>
        MATHML
        latex = "\\mathrm{. . .}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #20" do
      let(:string) { "\\frac{x + 4}{x + \\frac{123 \\left(\\sqrt{x} + 5\\right)}{x + 4} - 8}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfrac>
                <mrow>
                  <mi>x</mi>
                  <mo>+</mo>
                  <mn>4</mn>
                </mrow>
                <mrow>
                  <mi>x</mi>
                  <mo>+</mo>
                  <mfrac>
                    <mrow>
                      <mn>123</mn>
                      <mo>(</mo>
                      <mrow>
                        <msqrt>
                          <mi>x</mi>
                        </msqrt>
                        <mo>+</mo>
                        <mn>5</mn>
                      </mrow>
                      <mo>)</mo>
                    </mrow>
                    <mrow>
                      <mi>x</mi>
                      <mo>+</mo>
                      <mn>4</mn>
                    </mrow>
                  </mfrac>
                  <mo>&#x2212;</mo>
                  <mn>8</mn>
                </mrow>
              </mfrac>
            </mstyle>
          </math>
        MATHML
        latex = "\\frac{x + 4}{x + \\frac{123 \\left ( \\sqrt{x} + 5 \\right )}{x + 4} - 8}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #21" do
      let(:string) { "\\sqrt {\\sqrt {\\left( x^{3}\\right) + v}}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msqrt>
                <msqrt>
                  <mrow>
                    <mo>(</mo>
                    <msup>
                      <mi>x</mi>
                      <mn>3</mn>
                    </msup>
                    <mo>)</mo>
                    <mo>+</mo>
                    <mi>v</mi>
                  </mrow>
                </msqrt>
              </msqrt>
            </mstyle>
          </math>
        MATHML
        latex = "\\sqrt{\\sqrt{\\left ( x^{3} \\right ) + v}}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #22" do
      let(:string) { "\\left(x\\right){5}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mo>(</mo>
              <mi>x</mi>
              <mo>)</mo>
              <mn>5</mn>
            </mstyle>
          </math>
        MATHML
        latex = "\\left ( x \\right ) 5"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #23" do
      let(:string) { "\\sqrt[3]{}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mroot>
                <mrow/>
                <mrow>
                  <mn>3</mn>
                </mrow>
              </mroot>
            </mstyle>
          </math>
        MATHML
        latex = "\\sqrt[3]{}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #24" do
      let(:string) { "1_{}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mn>1</mn>
              </msub>
            </mstyle>
          </math>
        MATHML
        latex = "1_{}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #25" do
      let(:string) { "\\array{}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable>
                <mtr>
                  <mtd/>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
        latex = "\\begin{array}\\end{array}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #26" do
      let(:string) { "\\array{{}}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable>
                <mtr>
                  <mtd/>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
        latex = "\\begin{array}\\end{array}"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #27" do
      let(:string) do
        <<~LATEX
          \\left[
            \\begin{matrix}
              1 & 0 & 0 & 0\\\\
              0 & 1 & 0 & 0\\\\
              0 & 0 & 1 & 0\\\\
              0 & 0 & 0 & 1
            \\end{matrix}
          \\right]
        LATEX
      end

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mo>[</mo>
              <mtable>
                <mtr>
                  <mtd>
                    <mn>1</mn>
                  </mtd>
                  <mtd>
                    <mn>0</mn>
                  </mtd>
                  <mtd>
                    <mn>0</mn>
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
                  <mtd>
                    <mn>0</mn>
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
                    <mn>0</mn>
                  </mtd>
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
                    <mn>0</mn>
                  </mtd>
                  <mtd>
                    <mn>0</mn>
                  </mtd>
                  <mtd>
                    <mn>1</mn>
                  </mtd>
                </mtr>
              </mtable>
              <mo>]</mo>
            </mstyle>
          </math>
        MATHML
        latex = "\\left [ \\begin{matrix}1 & 0 & 0 & 0 \\\\ 0 & 1 & 0 & 0 \\\\ 0 & 0 & 1 & 0 \\\\ 0 & 0 & 0 & 1\\end{matrix} \\right ]"
        expect(formula.to_latex).to be_equivalent_to(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #28" do
      let(:string) do
        <<~LATEX
          x^{x^{x^{x}}}
          \\left(
            x^{x^{x}}
            \\left(
              x^{x}
              \\left(
                \\log{\\left(x \\right)} + 1
              \\right) \\log{\\left(x \\right)} + \\frac{x^{x}}{x}
            \\right) \\log{\\left(x \\right)} + \\frac{x^{x^{x}}}{x}
          \\right)
        LATEX
      end

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msup>
                <mi>x</mi>
                <msup>
                  <mi>x</mi>
                  <msup>
                    <mi>x</mi>
                    <mi>x</mi>
                  </msup>
                </msup>
              </msup>
              <mo>(</mo>
              <mrow>
                <msup>
                  <mi>x</mi>
                  <msup>
                    <mi>x</mi>
                    <mi>x</mi>
                  </msup>
                </msup>
                <mo>(</mo>
                <mrow>
                  <msup>
                    <mi>x</mi>
                    <mi>x</mi>
                  </msup>
                  <mo>(</mo>
                  <mrow>
                    <mi>log</mi>
                    <mo>(</mo>
                    <mi>x</mi>
                    <mo>)</mo>
                    <mo>+</mo>
                    <mn>1</mn>
                  </mrow>
                  <mo>)</mo>
                  <mi>log</mi>
                  <mo>(</mo>
                  <mi>x</mi>
                  <mo>)</mo>
                  <mo>+</mo>
                  <mfrac>
                    <msup>
                      <mi>x</mi>
                      <mi>x</mi>
                    </msup>
                    <mi>x</mi>
                  </mfrac>
                </mrow>
                <mo>)</mo>
                <mi>log</mi>
                <mo>(</mo>
                <mi>x</mi>
                <mo>)</mo>
                <mo>+</mo>
                <mfrac>
                  <msup>
                    <mi>x</mi>
                    <msup>
                      <mi>x</mi>
                      <mi>x</mi>
                    </msup>
                  </msup>
                  <mi>x</mi>
                </mfrac>
              </mrow>
              <mo>)</mo>
            </mstyle>
          </math>
        MATHML
        latex = "x^{x^{x^{x}}} \\left ( x^{x^{x}} \\left ( x^{x} \\left ( \\log \\left ( x \\right ) + 1 \\right ) \\log \\left ( x \\right ) + \\frac{x^{x}}{x} \\right ) \\log \\left ( x \\right ) + \\frac{x^{x^{x}}}{x} \\right )"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #29" do
      let(:string) { "\\log_2{x}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mi>log</mi>
                <mn>2</mn>
              </msubsup>
              <mi>x</mi>
            </mstyle>
          </math>
        MATHML
        latex = "\\log_{2} x"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #30" do
      let(:string) { "\\sqrt[]{3}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mroot>
                <mn>3</mn>
                <mrow/>
              </mroot>
            </mstyle>
          </math>
        MATHML
        latex = "\\sqrt[]{3}"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #31" do
      let(:string) { "\\frac{3}{\\frac{1}{2}{x}^{2}}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfrac>
                <mn>3</mn>
                <mrow>
                  <mfrac>
                    <mn>1</mn>
                    <mn>2</mn>
                  </mfrac>
                  <msup>
                    <mi>x</mi>
                    <mn>2</mn>
                  </msup>
                </mrow>
              </mfrac>
            </mstyle>
          </math>
        MATHML
        latex = "\\frac{3}{\\frac{1}{2} x^{2}}"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #32" do
      let(:string) { "\\frac{3}{\\frac{1}{2}{x}^{2}-\\frac{3\\sqrt[]{3}}{2}x+3}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfrac>
                <mn>3</mn>
                <mrow>
                  <mfrac>
                    <mn>1</mn>
                    <mn>2</mn>
                  </mfrac>
                  <msup>
                    <mi>x</mi>
                    <mn>2</mn>
                  </msup>
                  <mo>&#x2212;</mo>
                  <mfrac>
                    <mrow>
                      <mn>3</mn>
                      <mroot>
                        <mn>3</mn>
                        <mrow/>
                      </mroot>
                    </mrow>
                    <mn>2</mn>
                  </mfrac>
                  <mi>x</mi>
                  <mo>+</mo>
                  <mn>3</mn>
                </mrow>
              </mfrac>
            </mstyle>
          </math>
        MATHML
        latex = "\\frac{3}{\\frac{1}{2} x^{2} - \\frac{3 \\sqrt[]{3}}{2} x + 3}"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #33" do
      let(:string) { "^3" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mo>^</mo>
              <mn>3</mn>
            </mstyle>
          </math>
        MATHML
        latex = "^ 3"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #34" do
      let(:string) { "\\lim_{x \\to +\\infty} f(x)" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mo>lim</mo>
                <mrow>
                  <mi>x</mi>
                  <mo>&#x2192;</mo>
                  <mo>+</mo>
                  <mo>&#x221e;</mo>
                </mrow>
              </munder>
              <mi>f</mi>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        latex = "\\lim_{x \\to + \\infty} f ( x )"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #35" do
      let(:string) { "\\inf_{x > s}f(x)" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mo>inf</mo>
                <mrow>
                  <mi>x</mi>
                  <mo>&#x3e;</mo>
                  <mi>s</mi>
                </mrow>
              </munder>
              <mi>f</mi>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        latex = "\\inf_{x > s} f ( x )"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #36" do
      let(:string) { "\\sup_{x \\in \\mathbb{R}}f(x)" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mo>sup</mo>
                <mrow>
                  <mi>x</mi>
                  <mo>&#x2208;</mo>
                  <mstyle mathvariant="double-struck">
                    <mi>R</mi>
                  </mstyle>
                </mrow>
              </msub>
              <mi>f</mi>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        latex = "\\sup_{x \\in \\mathbb{R}} f ( x )"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #37" do
      let(:string) { "\\max_{x \\in \\[a,b\\]}f(x)" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mrow>
                  <mi>max</mi>
                </mrow>
                <mrow>
                  <mi>x</mi>
                  <mo>&#x2208;</mo>
                  <mrow>
                    <mo>\\[</mo>
                    <mi>a</mi>
                    <mo>,</mo>
                    <mi>b</mi>
                    <mo>\\]</mo>
                  </mrow>
                </mrow>
              </munder>
              <mi>f</mi>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        latex = "\\max_{x \\in \\[ a , b \\]} f ( x )"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #38" do
      let(:string) { "\\min_{x \\in \\[\\alpha,\\beta\\]}f(x)" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mrow>
                  <mi>min</mi>
                </mrow>
                <mrow>
                  <mi>x</mi>
                  <mo>&#x2208;</mo>
                  <mrow>
                    <mo>\\[</mo>
                    <mi>&#x3b1;</mi>
                    <mo>,</mo>
                    <mi>&#x3b2;</mi>
                    <mo>\\]</mo>
                  </mrow>
                </mrow>
              </munder>
              <mi>f</mi>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        latex = "\\min_{x \\in \\[ \\alpha , \\beta \\]} f ( x )"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #39" do
      let(:string) { "\\int\\limits_{0}^{\\pi}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover>
                <mo>&#x222b;</mo>
                <mn>0</mn>
                <mi>&#x3c0;</mi>
              </munderover>
            </mstyle>
          </math>
        MATHML
        latex = "\\int\\limits_{0}^{\\pi}"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #40" do
      let(:string) { "\\sum_{\\substack{1\\le i\\le n\\\\ i\\ne j}}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mo>&#x2211;</mo>
                <mtable>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                      <mo>&#x2264;</mo>
                      <mi>i</mi>
                      <mo>&#x2264;</mo>
                      <mi>n</mi>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mi>i</mi>
                      <mo>&#x2260;</mo>
                      <mi>j</mi>
                    </mtd>
                  </mtr>
                </mtable>
              </munder>
            </mstyle>
          </math>
        MATHML
        latex = "\\sum_{\\substack{1 \\le i \\le n\\\\i \\ne j}}"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #41" do
      let(:string) { "\\mathrm{AA}" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathvariant="normal">
                <mrow>
                  <mi>A</mi>
                  <mi>A</mi>
                </mrow>
              </mstyle>
            </mstyle>
          </math>
        MATHML
        latex = "\\mathrm{A A}"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #42" do
      let(:string) { "(1+(x-y)^{2})" }

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>(</mo>
                <mn>1</mn>
                <mo>+</mo>
                <msup>
                  <mrow>
                    <mo>(</mo>
                    <mi>x</mi>
                    <mo>&#x2212;</mo>
                    <mi>y</mi>
                    <mo>)</mo>
                  </mrow>
                  <mn>2</mn>
                </msup>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        latex = "( 1 + ( x - y )^{2} )"
        expect(formula.to_latex).to eql(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #43" do
      let(:string) do
        <<~LATEX
          \\begin{array}{cc}
            \\left(
              \\begin{array}{ccccccc}
                & & & & & & \\\\
                & +k & & & & -k  \\\\
                & & & & & & \\\\
                & & & & & & \\\\
                & & & & & & \\\\
                & -k & & & & +k
              \\end{array}
            \\right) &
            \\begin{array}{cc}
              & \\\\
              \\cdots & \\mbox{degree of freedom 1, node 1} \\\\
              & \\\\
              & \\\\
              & \\\\
              \\cdots & \\mbox{degree of freedom 2, node 2}
            \\end{array} \\\\ & \\\\
            \\begin{array}{cccccc}
              \\vdots & & & & & \\vdots
            \\end{array} & \\\\
            \\begin{array}{cccc}
              & \\mbox{degree of}  & \\mbox{degree of}  & \\\\
              & \\mbox{freedom 1,} & \\mbox{freedom 2,} & \\\\
              & \\mbox{node 1} & \\mbox{node 2}  &
            \\end{array}    &
          \\end{array}
        LATEX
      end

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable>
                <mtr>
                  <mtd columnalign="center">
                    <mo>(</mo>
                    <mtable>
                      <mtr>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                      </mtr>
                      <mtr>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center">
                          <mo>+</mo>
                          <mi>k</mi>
                        </mtd>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center">
                          <mrow>
                            <mo>&#x2212;</mo>
                            <mi>k</mi>
                          </mrow>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                      </mtr>
                      <mtr>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                      </mtr>
                      <mtr>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                      </mtr>
                      <mtr>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center">
                          <mrow>
                            <mo>&#x2212;</mo>
                            <mi>k</mi>
                          </mrow>
                        </mtd>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center">
                          <mo>+</mo>
                          <mi>k</mi>
                        </mtd>
                      </mtr>
                    </mtable>
                    <mo>)</mo>
                  </mtd>
                  <mtd columnalign="center">
                    <mtable>
                      <mtr>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                      </mtr>
                      <mtr>
                        <mtd columnalign="center">
                          <mo>&#x22ef;</mo>
                        </mtd>
                        <mtd columnalign="center">
                          <mtext>
                            <mrow>
                              <mi>d</mi>
                              <mi>e</mi>
                              <mi>g</mi>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>e</mi>
                              <mi>o</mi>
                              <mi>f</mi>
                              <mi>f</mi>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>e</mi>
                              <mi>d</mi>
                              <mi>o</mi>
                              <mi>m</mi>
                              <mn>1</mn>
                              <mo>,</mo>
                              <mi>n</mi>
                              <mi>o</mi>
                              <mi>d</mi>
                              <mi>e</mi>
                              <mn>1</mn>
                            </mrow>
                          </mtext>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                      </mtr>
                      <mtr>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                      </mtr>
                      <mtr>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                      </mtr>
                      <mtr>
                        <mtd columnalign="center">
                          <mo>&#x22ef;</mo>
                        </mtd>
                        <mtd columnalign="center">
                          <mtext>
                            <mrow>
                              <mi>d</mi>
                              <mi>e</mi>
                              <mi>g</mi>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>e</mi>
                              <mi>o</mi>
                              <mi>f</mi>
                              <mi>f</mi>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>e</mi>
                              <mi>d</mi>
                              <mi>o</mi>
                              <mi>m</mi>
                              <mn>2</mn>
                              <mo>,</mo>
                              <mi>n</mi>
                              <mi>o</mi>
                              <mi>d</mi>
                              <mi>e</mi>
                              <mn>2</mn>
                            </mrow>
                          </mtext>
                        </mtd>
                      </mtr>
                    </mtable>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd columnalign="center"/>
                  <mtd columnalign="center"/>
                </mtr>
                <mtr>
                  <mtd columnalign="center">
                    <mtable>
                      <mtr>
                        <mtd columnalign="center">
                          <mo>&#x22ee;</mo>
                        </mtd>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center">
                          <mo>&#x22ee;</mo>
                        </mtd>
                      </mtr>
                    </mtable>
                  </mtd>
                  <mtd columnalign="center"/>
                </mtr>
                <mtr>
                  <mtd columnalign="center">
                    <mtable>
                      <mtr>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center">
                          <mtext>
                            <mrow>
                              <mi>d</mi>
                              <mi>e</mi>
                              <mi>g</mi>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>e</mi>
                              <mi>o</mi>
                              <mi>f</mi>
                            </mrow>
                          </mtext>
                        </mtd>
                        <mtd columnalign="center">
                          <mtext>
                            <mrow>
                              <mi>d</mi>
                              <mi>e</mi>
                              <mi>g</mi>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>e</mi>
                              <mi>o</mi>
                              <mi>f</mi>
                            </mrow>
                          </mtext>
                        </mtd>
                        <mtd columnalign="center"/>
                      </mtr>
                      <mtr>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center">
                          <mtext>
                            <mrow>
                              <mi>f</mi>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>e</mi>
                              <mi>d</mi>
                              <mi>o</mi>
                              <mi>m</mi>
                              <mn>1</mn>
                              <mo>,</mo>
                            </mrow>
                          </mtext>
                        </mtd>
                        <mtd columnalign="center">
                          <mtext>
                            <mrow>
                              <mi>f</mi>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>e</mi>
                              <mi>d</mi>
                              <mi>o</mi>
                              <mi>m</mi>
                              <mn>2</mn>
                              <mo>,</mo>
                            </mrow>
                          </mtext>
                        </mtd>
                        <mtd columnalign="center"/>
                      </mtr>
                      <mtr>
                        <mtd columnalign="center"/>
                        <mtd columnalign="center">
                          <mtext>
                            <mrow>
                              <mi>n</mi>
                              <mi>o</mi>
                              <mi>d</mi>
                              <mi>e</mi>
                              <mn>1</mn>
                            </mrow>
                          </mtext>
                        </mtd>
                        <mtd columnalign="center">
                          <mtext>
                            <mrow>
                              <mi>n</mi>
                              <mi>o</mi>
                              <mi>d</mi>
                              <mi>e</mi>
                              <mn>2</mn>
                            </mrow>
                          </mtext>
                        </mtd>
                        <mtd columnalign="center"/>
                      </mtr>
                    </mtable>
                  </mtd>
                  <mtd columnalign="center"/>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
        latex = <<~LATEX
          \\begin{array}{cc}
            \\left(
              \\begin{array}{ccccccc}
                & & & & & & \\\\
                & +k & & & & -k  \\\\
                & & & & & & \\\\
                & & & & & & \\\\
                & & & & & & \\\\
                & -k & & & & +k
              \\end{array}
            \\right)  &
            \\begin{array}{cc}
              & \\\\
              \\cdots & \\mbox{degree of freedom 1, node 1} \\\\
              & \\\\
              & \\\\
              & \\\\
              \\cdots & \\mbox{degree of freedom 2, node 2}
            \\end{array} \\\\ & \\\\
            \\begin{array}{cccccc}
              \\vdots & & & & & \\vdots
            \\end{array} & \\\\
            \\begin{array}{cccc}
                & \\mbox{degree of}  & \\mbox{degree of}  & \\\\
                & \\mbox{freedom 1,} & \\mbox{freedom 2,} & \\\\
                & \\mbox{node 1} & \\mbox{node 2}  &
            \\end{array}    &
          \\end{array}
        LATEX
        expect(formula.to_latex.gsub(/\s+/, "")).to eql(latex.gsub(/\s+/, ""))
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #44" do
      let(:string) do
        <<~LATEX
          \\begin{split}
            C_L &= {L \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 S} \\\\ \\\\
            C_D &= {D \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 S} \\\\ \\\\
            \\vec{C}_M &= {\\vec{M} \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 c_\\textrm{ref} S_\\textrm{ref}},
          \\end{split}
        LATEX
      end

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable>
                <mtr>
                  <mtd>
                    <msub>
                      <mi>C</mi>
                      <mi>L</mi>
                    </msub>
                  </mtd>
                  <mtd>
                    <mo>=</mo>
                    <mfrac>
                      <mrow>
                        <mi>L</mi>
                      </mrow>
                      <mrow>
                        <mfrac>
                          <mrow>
                            <mn>1</mn>
                          </mrow>
                          <mrow>
                            <mn>2</mn>
                          </mrow>
                        </mfrac>
                        <msub>
                          <mi>&#x3c1;</mi>
                          <mstyle mathvariant="normal">
                            <mrow>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>f</mi>
                            </mrow>
                          </mstyle>
                        </msub>
                        <msubsup>
                          <mi>q</mi>
                          <mstyle mathvariant="normal">
                            <mrow>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>f</mi>
                            </mrow>
                          </mstyle>
                          <mn>2</mn>
                        </msubsup>
                        <mi>S</mi>
                      </mrow>
                    </mfrac>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd/>
                </mtr>
                <mtr>
                  <mtd>
                    <msub>
                      <mi>C</mi>
                      <mi>D</mi>
                    </msub>
                  </mtd>
                  <mtd>
                    <mo>=</mo>
                    <mfrac>
                      <mrow>
                        <mi>D</mi>
                      </mrow>
                      <mrow>
                        <mfrac>
                          <mrow>
                            <mn>1</mn>
                          </mrow>
                          <mrow>
                            <mn>2</mn>
                          </mrow>
                        </mfrac>
                        <msub>
                          <mi>&#x3c1;</mi>
                          <mstyle mathvariant="normal">
                            <mrow>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>f</mi>
                            </mrow>
                          </mstyle>
                        </msub>
                        <msubsup>
                          <mi>q</mi>
                          <mstyle mathvariant="normal">
                            <mrow>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>f</mi>
                            </mrow>
                          </mstyle>
                          <mn>2</mn>
                        </msubsup>
                        <mi>S</mi>
                      </mrow>
                    </mfrac>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd/>
                </mtr>
                <mtr>
                  <mtd>
                    <msub>
                      <mover>
                        <mi>C</mi>
                        <mo>&#x2192;</mo>
                      </mover>
                      <mi>M</mi>
                    </msub>
                  </mtd>
                  <mtd>
                    <mo>=</mo>
                    <mfrac>
                      <mrow>
                        <mover>
                          <mi>M</mi>
                          <mo>&#x2192;</mo>
                        </mover>
                      </mrow>
                      <mrow>
                        <mfrac>
                          <mrow>
                            <mn>1</mn>
                          </mrow>
                          <mrow>
                            <mn>2</mn>
                          </mrow>
                        </mfrac>
                        <msub>
                          <mi>&#x3c1;</mi>
                          <mstyle mathvariant="normal">
                            <mrow>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>f</mi>
                            </mrow>
                          </mstyle>
                        </msub>
                        <msubsup>
                          <mi>q</mi>
                          <mstyle mathvariant="normal">
                            <mrow>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>f</mi>
                            </mrow>
                          </mstyle>
                          <mn>2</mn>
                        </msubsup>
                        <msub>
                          <mi>c</mi>
                          <mstyle mathvariant="normal">
                            <mrow>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>f</mi>
                            </mrow>
                          </mstyle>
                        </msub>
                        <msub>
                          <mi>S</mi>
                          <mstyle mathvariant="normal">
                            <mrow>
                              <mi>r</mi>
                              <mi>e</mi>
                              <mi>f</mi>
                            </mrow>
                          </mstyle>
                        </msub>
                      </mrow>
                    </mfrac>
                    <mo>,</mo>
                  </mtd>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
        latex = <<~LATEX
          \\begin{split}
            C_{L} &= {L \\over {1 \\over 2} \\rho_{\\mathrm{ref}} q_{\\mathrm{ref}}^{2} S} \\\\ \\\\
            C_{D} &= {D \\over {1 \\over 2} \\rho_{\\mathrm{ref}} q_{\\mathrm{ref}}^{2} S} \\\\ \\\\
            \\vec{C}_{M} &= {\\vec{M} \\over {1 \\over 2} \\rho_{\\mathrm{ref}} q_{\\mathrm{ref}}^{2} c_{\\mathrm{ref}} S_{\\mathrm{ref}}},
          \\end{split}
        LATEX
        expect(formula.to_latex.gsub(/\s+/, "")).to eql(latex.gsub(/\s+/, ""))
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #44" do
      let(:string) do
        <<~LATEX
          V = \\frac{1}{2} \\: {\\bf u}^t \\:
            \\int_{\\text{surface}} \\: \\int_{thickness} \\: B^t \\: D \\: B \\: dt \\: ds
               \\; {\\bf u}
        LATEX
      end

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>V</mi>
              <mo>=</mo>
              <mfrac>
                <mn>1</mn>
                <mn>2</mn>
              </mfrac>
              <mo>&#x3a;</mo>
              <msup>
                <mstyle mathvariant="bold">
                  <mi>u</mi>
                </mstyle>
                <mi>t</mi>
              </msup>
              <mo>&#x3a;</mo>
              <msub>
                <mo>&#x222b;</mo>
                <mtext>surface</mtext>
              </msub>
              <mo>&#x3a;</mo>
              <msub>
                <mo>&#x222b;</mo>
                <mrow>
                  <mi>t</mi>
                  <mi>h</mi>
                  <mi>i</mi>
                  <mi>c</mi>
                  <mi>k</mi>
                  <mi>n</mi>
                  <mi>e</mi>
                  <mi>s</mi>
                  <mi>s</mi>
                </mrow>
              </msub>
              <mo>&#x3a;</mo>
              <msup>
                <mi>B</mi>
                <mi>t</mi>
              </msup>
              <mo>&#x3a;</mo>
              <mi>D</mi>
              <mo>&#x3a;</mo>
              <mi>B</mi>
              <mo>&#x3a;</mo>
              <mi>d</mi>
              <mi>t</mi>
              <mo>&#x3a;</mo>
              <mi>d</mi>
              <mi>s</mi>
              <mo>&#x3b;</mo>
              <mstyle mathvariant="bold">
                <mi>u</mi>
              </mstyle>
            </mstyle>
          </math>
        MATHML
        latex = <<~LATEX
          V = \\frac{1}{2} : \\mathbf{u}^{t} :
            \\int_{\\text{surface}} : \\int_{t h i c k n e s s} : B^{t} : D : B : d t : d s
            ; \\mathbf{u}
        LATEX
        expect(formula.to_latex.gsub(/\s+/, "")).to eql(latex.gsub(/\s+/, ""))
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #45" do
      let(:string) do
        <<~LATEX
            \\[out_k = \\frac{1}{s}\\left(k == 0 ? 1 : \\sqrt{2}\\right)\\sum_{n = 0}^{s - 1}{in_{n} \\cdot \\cos\\left( \\frac{\\pi k}{s}\\left( n + \\frac{1}{2} \\right) \\right)}\\]
        LATEX
      end

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>\\[</mo>
                <mi>o</mi>
                <mi>u</mi>
                <msub>
                  <mi>t</mi>
                  <mi>k</mi>
                </msub>
                <mo>=</mo>
                <mfrac>
                  <mn>1</mn>
                  <mi>s</mi>
                </mfrac>
                <mo>(</mo>
                <mrow>
                  <mi>k</mi>
                  <mo>=</mo>
                  <mo>=</mo>
                  <mn>0</mn>
                  <mi>?</mi>
                  <mn>1</mn>
                  <mo>:</mo>
                  <msqrt>
                    <mn>2</mn>
                  </msqrt>
                </mrow>
                <mo>)</mo>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mrow>
                    <mi>n</mi>
                    <mo>=</mo>
                    <mn>0</mn>
                  </mrow>
                  <mrow>
                    <mi>s</mi>
                    <mo>&#x2212;</mo>
                    <mn>1</mn>
                  </mrow>
                </munderover>
                <mrow>
                  <mi>i</mi>
                  <msub>
                    <mi>n</mi>
                    <mi>n</mi>
                  </msub>
                  <mo>&#x22c5;</mo>
                  <mrow>
                    <mi>cos</mi>
                    <mrow>
                      <mo>(</mo>
                      <mrow>
                        <mfrac>
                          <mrow>
                            <mi>&#x3c0;</mi>
                            <mi>k</mi>
                          </mrow>
                          <mi>s</mi>
                        </mfrac>
                        <mo>(</mo>
                        <mrow>
                          <mi>n</mi>
                          <mo>+</mo>
                          <mfrac>
                            <mn>1</mn>
                            <mn>2</mn>
                          </mfrac>
                        </mrow>
                        <mo>)</mo>
                      </mrow>
                      <mo>)</mo>
                    </mrow>
                  </mrow>
                </mrow>
                <mo>\\]</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        latex = <<~LATEX
          \\[out_{k} = \\frac{1}{s}\\left(k == 0 ? 1 : \\sqrt{2}\\right)\\sum_{n = 0}^{s - 1}in_{n} \\cdot \\cos{\\left( \\frac{\\pi k}{s}\\left( n + \\frac{1}{2} \\right) \\right)}\\]
        LATEX
        expect(formula.to_latex.gsub(/\s+/, "")).to eql(latex.gsub(/\s+/, ""))
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end

    context "contains example #46" do
      let(:string) do
        <<~LATEX
          \\[out_k = \\frac{1}{s} (k == 0 ? 1 : \\sqrt{2}) \\sum_{n = 0}^{s - 1}{in_{n} \\cdot
            \\cos( \\frac{\\pi k}{s} ( n + \\frac{1}{2} ) )}\\]
        LATEX
      end

      it 'returns parsed Latex to MathML' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>\\[</mo>
                <mi>o</mi>
                <mi>u</mi>
                <msub>
                  <mi>t</mi>
                  <mi>k</mi>
                </msub>
                <mo>=</mo>
                <mfrac>
                  <mn>1</mn>
                  <mi>s</mi>
                </mfrac>
                <mrow>
                  <mo>(</mo>
                  <mi>k</mi>
                  <mo>=</mo>
                  <mo>=</mo>
                  <mn>0</mn>
                  <mi>?</mi>
                  <mn>1</mn>
                  <mo>:</mo>
                  <msqrt>
                    <mn>2</mn>
                  </msqrt>
                  <mo>)</mo>
                </mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mrow>
                    <mi>n</mi>
                    <mo>=</mo>
                    <mn>0</mn>
                  </mrow>
                  <mrow>
                    <mi>s</mi>
                    <mo>&#x2212;</mo>
                    <mn>1</mn>
                  </mrow>
                </munderover>
                <mrow>
                  <mi>i</mi>
                  <msub>
                    <mi>n</mi>
                    <mi>n</mi>
                  </msub>
                  <mo>&#x22c5;</mo>
                  <mrow>
                    <mi>cos</mi>
                    <mrow>
                      <mo>(</mo>
                      <mfrac>
                        <mrow>
                          <mi>&#x3c0;</mi>
                          <mi>k</mi>
                        </mrow>
                        <mi>s</mi>
                      </mfrac>
                      <mrow>
                        <mo>(</mo>
                        <mi>n</mi>
                        <mo>+</mo>
                        <mfrac>
                          <mn>1</mn>
                          <mn>2</mn>
                        </mfrac>
                        <mo>)</mo>
                      </mrow>
                      <mo>)</mo>
                    </mrow>
                  </mrow>
                </mrow>
                <mo>\\]</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        latex = <<~LATEX
          \\[out_{k} = \\frac{1}{s}(k == 0 ? 1 : \\sqrt{2})\\sum_{n = 0}^{s - 1}in_{n} \\cdot \\cos{( \\frac{\\pi k}{s}( n + \\frac{1}{2} ) )}\\]
        LATEX
        expect(formula.to_latex.gsub(/\s+/, "")).to eql(latex.gsub(/\s+/, ""))
        expect(formula.to_mathml).to be_equivalent_to(mathml)
      end
    end
  end
end
