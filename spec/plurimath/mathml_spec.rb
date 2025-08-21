require "spec_helper"

RSpec.describe Plurimath::Mathml do

  describe ".initialize" do
    subject(:formula) { described_class.new(mathml) }

    context "initialize Mathml object" do
      let(:mathml) { '<mrow><mn>2</mn></mrow>' }

      it 'returns instance of Mathml' do
        expect(formula).to be_a(Plurimath::Mathml)
      end

      it 'returns Mathml instance' do
        expect(formula.text).to eql('<mrow><mn>2</mn></mrow>')
      end
    end
  end

  describe ".to_formula" do
    subject(:formula) { described_class.new(string).to_formula }

    context "contains Mathml object" do
      let(:string)  { "<mrow><mn>2</mn></mrow>" }

      it 'returns Mathml string' do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("2")
        ])
        expect(formula).to eq(expected_value)
      end

      it 'not returns Mathml string' do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1")
          ])
        ])
        expect(formula).not_to eq(expected_value)
      end
    end
  end

  describe ".to_asciimath .to_latex .to_mathml" do
    subject(:formula) { described_class.new(string).to_formula }

    context "contains Mathml object" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>h</mi>
              <mi>a</mi>
              <mi>n</mi>
              <mi>n</mi>
              <mi>i</mi>
              <mi>n</mi>
              <mi>g</mi>
              <mo>(</mo>
              <mi>k</mi>
              <mo>)</mo>
              <mo>=</mo>
              <mn>0</mn>
              <mo>&#x2e;</mo>
              <mn>5</mn>
              <mo>&#x22c5;</mo>
              <mo>[</mo>
              <mn>1</mn>
              <mo>&#x2212;</mo>
              <mrow>
                <mi>cos</mi>
                <mo>(</mo>
              </mrow>
              <mn>2</mn>
              <mi>&#x3c0;</mi>
              <mo>&#x22c5;</mo>
              <mfrac>
                <mrow>
                  <mi>k</mi>
                  <mo>+</mo>
                  <mn>1</mn>
                </mrow>
                <mrow>
                  <mi>n</mi>
                  <mo>+</mo>
                  <mn>1</mn>
                </mrow>
              </mfrac>
              <mo>)</mo>
              <mo>]</mo>
              <mtext>
                <mi/>
              </mtext>
              <mo>(</mo>
              <mn>0</mn>
              <mo>&#x2264;</mo>
              <mi>k</mi>
              <mo>&#x2264;</mo>
              <mi>n</mi>
              <mo>&#x2212;</mo>
              <mn>1</mn>
              <mo>)</mo>
            </mstyle>
          </math>
        MATHML
      end

      it 'returns Mathml string' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>h</mi>
              <mi>a</mi>
              <mi>n</mi>
              <mi>n</mi>
              <mi>i</mi>
              <mi>n</mi>
              <mi>g</mi>
              <mo>(</mo>
              <mi>k</mi>
              <mo>)</mo>
              <mo>=</mo>
              <mn>0</mn>
              <mo>&#x2e;</mo>
              <mn>5</mn>
              <mo>&#x22c5;</mo>
              <mo>[</mo>
              <mn>1</mn>
              <mo>&#x2212;</mo>
              <mrow>
                <mi>cos</mi>
                <mo>(</mo>
              </mrow>
              <mn>2</mn>
              <mi>&#x3c0;</mi>
              <mo>&#x22c5;</mo>
              <mfrac>
                <mrow>
                  <mi>k</mi>
                  <mo>+</mo>
                  <mn>1</mn>
                </mrow>
                <mrow>
                  <mi>n</mi>
                  <mo>+</mo>
                  <mn>1</mn>
                </mrow>
              </mfrac>
              <mo>)</mo>
              <mo>]</mo>
              <mtext></mtext>
              <mo>(</mo>
              <mn>0</mn>
              <mo>&#x2264;</mo>
              <mi>k</mi>
              <mo>&#x2264;</mo>
              <mi>n</mi>
              <mo>&#x2212;</mo>
              <mn>1</mn>
              <mo>)</mo>
            </mstyle>
          </math>
        MATHML
        latex = "h a n n i n g ( k ) = 0 . 5 \\cdot [ 1 - \\cos{(} 2 \\pi \\cdot \\frac{k + 1}{n + 1} ) ] \\text{} ( 0 \\le k \\le n - 1 )"
        asciimath = 'h a n n i n g ( k ) = 0 . 5 * [ 1 - cos( 2 pi * frac(k + 1)(n + 1) ) ] "" ( 0 le k le n - 1 )'
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains Mathml object" do
      let(:string)  do
        <<~MATHML
          <math>
            <semantics>
              <mrow>
                <mstyle displaystyle='true'>
                  <mrow>
                    <msubsup>
                      <mo>∫</mo>
                      <mrow>
                        <msub>
                          <mi>t</mi>
                          <mn>2</mn>
                        </msub>
                      </mrow>
                      <mrow>
                        <msub>
                          <mi>t</mi>
                          <mn>1</mn>
                        </msub>
                      </mrow>
                    </msubsup>
                    <mrow>
                      <mi>f</mi>
                      <mo stretchy='false'>(</mo>
                      <mi>t</mi>
                      <mo stretchy='false'>)</mo>
                      <mo linebreak="newline">d</mo>
                      <mi>t</mi>
                    </mrow>
                  </mrow>
                </mstyle>
              </mrow>
              <annotation encoding='MathType-MTEF'>MathType@MTEF@5@5@+= feaagKart1ev2aaatCvAUfeBSjuyZL2yd9gzLbvyNv2CaerbbjxAHX garuavP1wzZbItLDhis9wBH5garmWu51MyVXgarqqtubsr4rNCHbGe aGqipG0dh9qqWrVepG0dbbL8F4rqqrVepeea0xe9LqFf0xc9q8qqaq Fn0lXdHiVcFbIOFHK8Feea0dXdar=Jb9hs0dXdHuk9fr=xfr=xfrpe WZqaaeaaciWacmGadaGadeaabaGaaqaaaOqaamaapedabaGaamOzai aacIcacaWG0bGaaiykaKqzaeGaaiizaOGaamiDaaWcbaGaamiDamaa BaaameaacaaIYaaabeaaaSqaaiaadshadaWgaaadbaGaaGymaaqaba aaniabgUIiYdaaaa@40DD@ </annotation>
            </semantics>
          </math>
        MATHML
      end

      it 'returns Mathml string' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <semantics>
                <mrow>
                  <msubsup>
                    <mo>&#x222b;</mo>
                    <msub>
                      <mi>t</mi>
                      <mn>2</mn>
                    </msub>
                    <msub>
                      <mi>t</mi>
                      <mn>1</mn>
                    </msub>
                  </msubsup>
                  <mrow>
                    <mi>f</mi>
                    <mo>(</mo>
                    <mi>t</mi>
                    <mo>)</mo>
                  </mrow>
                </mrow>
              </semantics>
            </mstyle>
          </math>
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <semantics>
                <mrow>
                  <mi>d</mi>
                  <mi>t</mi>
                </mrow>
                <annotation>
                  <mi>MathType@MTEF@5@5@+= feaagKart1ev2aaatCvAUfeBSjuyZL2yd9gzLbvyNv2CaerbbjxAHX garuavP1wzZbItLDhis9wBH5garmWu51MyVXgarqqtubsr4rNCHbGe aGqipG0dh9qqWrVepG0dbbL8F4rqqrVepeea0xe9LqFf0xc9q8qqaq Fn0lXdHiVcFbIOFHK8Feea0dXdar=Jb9hs0dXdHuk9fr=xfr=xfrpe WZqaaeaaciWacmGadaGadeaabaGaaqaaaOqaamaapedabaGaamOzai aacIcacaWG0bGaaiykaKqzaeGaaiizaOGaamiDaaWcbaGaamiDamaa BaaameaacaaIYaaabeaaaSqaaiaadshadaWgaaadbaGaaGymaaqaba aaniabgUIiYdaaaa@40DD@ </mi>
                </annotation>
              </semantics>
            </mstyle>
          </math>
        MATHML
        latex = "\\int_{t_{2}}^{t_{1}} f ( t ) \\\\ d t"
        asciimath = "int_(t_(2))^(t_(1)) f ( t ) \\\n d t"
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(split_on_linebreak: true, unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains Mathml phantom tag's example" do
      let(:string)  do
        <<~MATHML
          <math>
             <mrow>
                <mi> x </mi>
                <mphantom>
                   <mo> + </mo>
                </mphantom>
                <mphantom>
                   <mi> y </mi>
                </mphantom>
                <mo> + </mo>
                <mi> z </mi>
             </mrow>
          </math>
        MATHML
      end

      it 'returns Mathml string' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mi> x </mi>
                <mphantom>
                  <mo>+</mo>
                </mphantom>
                <mphantom>
                  <mi> y </mi>
                </mphantom>
                <mo> + </mo>
                <mi> z </mi>
              </mrow>
            </mstyle>
          </math>
        MATHML
        latex = " x  \\phantom{+} \\phantom{ y } +  z "
        asciimath = ' x  \  \ \ \  +  z '
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains menclose tags in Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <menclose notation="updiagonalstrike">
                <msubsup>
                  <mi>a</mi>
                  <mi>b</mi>
                  <mi>c</mi>
                </msubsup>
              </menclose>
            </mstyle>
          </math>
        MATHML
      end

      it 'returns Mathml string' do
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
              </mstyle>
            </math>
        MATHML
        latex = "a_{b}^{c}"
        asciimath = 'a_(b)^(c)'
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains msgroup tags in Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msgroup>
                <munderover>
                  <mn>100</mn>
                  <mi>&#x3b1;</mi>
                  <mrow>
                    <mi>&#x3b2;</mi>
                  </mrow>
                </munderover>
              </msgroup>
            </mstyle>
          </math>
        MATHML
      end

      it 'returns Mathml string' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msgroup>
                <munderover>
                  <mn>100</mn>
                  <mi>&#x3b1;</mi>
                  <mi>&#x3b2;</mi>
                </munderover>
              </msgroup>
            </mstyle>
          </math>
        MATHML
        latex = "100_{\\alpha}^{\\beta}"
        asciimath = '100_(alpha)^(beta)'
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains table with surrounding parentheses(metanorma example) and sqrt tag Mathml" do
      let(:string)  do
        <<~MATHML
          <math>
            <mstyle displaystyle="true">
              <mtext>Convert</mtext>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>,</mo>
                <mi>y</mi>
                <mo>,</mo>
                <mi>z</mi>
                <mo>,</mo>
                <msub>
                  <mi>p</mi>
                  <mi>a</mi>
                </msub>
                <mo>,</mo>
                <msub>
                  <mi>p</mi>
                  <mi>o</mi>
                </msub>
                <mo>,</mo>
                <mi>R</mi>
                <mo>,</mo>
                <mi>S</mi>
                <mo>,</mo>
                <mi>T</mi>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <msub>
                <mi>R</mi>
                <mi>z</mi>
              </msub>
              <mrow>
                <mo>(</mo>
                <mi>&#945;</mi>
                <mo>)</mo>
              </mrow>
              <msub>
                <mi>R</mi>
                <mi>y</mi>
              </msub>
              <mrow>
                <mo>(</mo>
                <mi>&#946;</mi>
                <mo>)</mo>
              </mrow>
              <msub>
                <mi>R</mi>
                <mi>x</mi>
              </msub>
              <mrow>
                <mo>(</mo>
                <mi>&#947;</mi>
                <mo>)</mo>
              </mrow>
              <mi>S</mi>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>&#8722;</mo>
                <msub>
                  <mi>a</mi>
                  <mi>x</mi>
                </msub>
                <mo>, </mo>
                <mi>y</mi>
                <mo>&#8722;</mo>
                <msub>
                  <mi>a</mi>
                  <mi>y</mi>
                </msub>
                <mo>, </mo>
                <mi>z</mi>
                <mo>&#8722;</mo>
                <msub>
                  <mi>a</mi>
                  <mi>z</mi>
                </msub>
                <mo>)</mo>
              </mrow>
              <mo>+</mo>
              <msub>
                <mi>p</mi>
                <mi>o</mi>
              </msub>
              <mo>+</mo>
              <mi>T</mi>
              <mo linebreak="newline" linebreakstyle="after">=</mo>
              <mrow>
                <mrow>
                  <mo>[</mo>
                  <mtable>
                    <mtr>
                      <mtd>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#945;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#946;</mi>
                        </mrow>
                      </mtd>
                      <mtd>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#945;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#946;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#947;</mi>
                        <mo>&#8722;</mo>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#945;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#947;</mi>
                        </mrow>
                      </mtd>
                      <mtd>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#945;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#946;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#947;</mi>
                        <mo>+</mo>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#945;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#947;</mi>
                      </mtd>
                    </mtr>
                    <mtr>
                      <mtd>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#945;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#946;</mi>
                      </mtd>
                      <mtd>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#945;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#946;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#947;</mi>
                        <mo>+</mo>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#945;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#947;</mi>
                      </mtd>
                      <mtd>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#945;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#946;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#947;</mi>
                        <mo>&#8722;</mo>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#945;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#947;</mi>
                      </mtd>
                    </mtr>
                    <mtr>
                      <mtd>
                        <mo>&#8722;</mo>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#946;</mi>
                      </mtd>
                      <mtd>
                        <ms>
                          <mi>cos</mi>
                          <mi>&#8289;</mi>
                        </ms>
                        <mi>&#946;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#947;</mi>
                      </mtd>
                      <mtd>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#946;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#8289;</mi>
                        </mrow>
                        <mi>&#947;</mi>
                      </mtd>
                    </mtr>
                  </mtable>
                  <mo>]</mo>
                </mrow>
                <mrow>
                  <mrow>
                    <mo>[</mo>
                    <mtable>
                      <mtr>
                        <mtd>
                          <msub>
                            <mi>s</mi>
                            <mi>x</mi>
                          </msub>
                          <mi>&#8727;</mi>
                          <mrow>
                            <mo>(</mo>
                            <mi>x</mi>
                            <mo>&#8722;</mo>
                            <msub>
                              <mi>a</mi>
                              <mi>x</mi>
                            </msub>
                            <mo>)</mo>
                          </mrow>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <msub>
                            <mi>s</mi>
                            <mi>y</mi>
                          </msub>
                          <mi>&#8727;</mi>
                          <mrow>
                            <mo>(</mo>
                            <mi>y</mi>
                            <mo>&#8722;</mo>
                            <msub>
                              <mi>a</mi>
                              <mi>y</mi>
                            </msub>
                            <mo>)</mo>
                          </mrow>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <msub>
                            <mi>s</mi>
                            <mi>z</mi>
                          </msub>
                          <mi>&#8727;</mi>
                          <mrow>
                            <mo>(</mo>
                            <mi>z</mi>
                            <mo>&#8722;</mo>
                            <msub>
                              <mi>a</mi>
                              <mi>z</mi>
                            </msub>
                            <mo>)</mo>
                          </mrow>
                        </mtd>
                      </mtr>
                    </mtable>
                    <mo>]</mo>
                  </mrow>
                  <mo>+</mo>
                  <mrow>
                    <mo>[</mo>
                    <mtable>
                      <mtr>
                        <mtd>
                          <msub>
                            <mi>x</mi>
                            <mn>0</mn>
                          </msub>
                          <mo>+</mo>
                          <msub>
                            <mi>t</mi>
                            <mi>x</mi>
                          </msub>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <msub>
                            <mi>y</mi>
                            <mn>0</mn>
                          </msub>
                          <mo>+</mo>
                          <msub>
                            <mi>t</mi>
                            <mi>y</mi>
                          </msub>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <msub>
                            <mi>z</mi>
                            <mn>0</mn>
                          </msub>
                          <mo>+</mo>
                          <msub>
                            <mi>t</mi>
                            <mi>z</mi>
                          </msub>
                        </mtd>
                      </mtr>
                    </mtable>
                    <mo>]</mo>
                  </mrow>
                </mrow>
              </mrow>
              <msqrt>
                <mi>d</mi>
              </msqrt>
            </mstyle>
          </math>
        MATHML
      end

      it 'returns Mathml string' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtext>Convert</mtext>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>,</mo>
                <mi>y</mi>
                <mo>,</mo>
                <mi>z</mi>
                <mo>,</mo>
                <msub>
                  <mi>p</mi>
                  <mi>a</mi>
                </msub>
                <mo>,</mo>
                <msub>
                  <mi>p</mi>
                  <mi>o</mi>
                </msub>
                <mo>,</mo>
                <mi>R</mi>
                <mo>,</mo>
                <mi>S</mi>
                <mo>,</mo>
                <mi>T</mi>
                <mo>)</mo>
              </mrow>
              <mo>=</mo>
              <msub>
                <mi>R</mi>
                <mi>z</mi>
              </msub>
              <mrow>
                <mo>(</mo>
                <mi>&#x3b1;</mi>
                <mo>)</mo>
              </mrow>
              <msub>
                <mi>R</mi>
                <mi>y</mi>
              </msub>
              <mrow>
                <mo>(</mo>
                <mi>&#x3b2;</mi>
                <mo>)</mo>
              </mrow>
              <msub>
                <mi>R</mi>
                <mi>x</mi>
              </msub>
              <mrow>
                <mo>(</mo>
                <mi>&#x3b3;</mi>
                <mo>)</mo>
              </mrow>
              <mi>S</mi>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>&#x2212;</mo>
                <msub>
                  <mi>a</mi>
                  <mi>x</mi>
                </msub>
                <mo>, </mo>
                <mi>y</mi>
                <mo>&#x2212;</mo>
                <msub>
                  <mi>a</mi>
                  <mi>y</mi>
                </msub>
                <mo>, </mo>
                <mi>z</mi>
                <mo>&#x2212;</mo>
                <msub>
                  <mi>a</mi>
                  <mi>z</mi>
                </msub>
                <mo>)</mo>
              </mrow>
              <mo>+</mo>
              <msub>
                <mi>p</mi>
                <mi>o</mi>
              </msub>
              <mo>+</mo>
              <mi>T</mi>
              <mo>=</mo>
            </mstyle>
          </math>
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mrow>
                  <mo>[</mo>
                  <mtable>
                    <mtr>
                      <mtd>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b1;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#x3b2;</mi>
                        </mrow>
                      </mtd>
                      <mtd>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b1;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b2;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b3;</mi>
                        <mo>&#x2212;</mo>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b1;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#x3b3;</mi>
                        </mrow>
                      </mtd>
                      <mtd>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b1;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b2;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b3;</mi>
                        <mo>+</mo>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b1;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b3;</mi>
                      </mtd>
                    </mtr>
                    <mtr>
                      <mtd>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b1;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b2;</mi>
                      </mtd>
                      <mtd>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b1;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b2;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b3;</mi>
                        <mo>+</mo>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b1;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b3;</mi>
                      </mtd>
                      <mtd>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b1;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b2;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b3;</mi>
                        <mo>&#x2212;</mo>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b1;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b3;</mi>
                      </mtd>
                    </mtr>
                    <mtr>
                      <mtd>
                        <mo>&#x2212;</mo>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b2;</mi>
                      </mtd>
                      <mtd>
                        <ms>cos ⁡</ms>
                        <mi>&#x3b2;</mi>
                        <mrow>
                          <mi>sin</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b3;</mi>
                      </mtd>
                      <mtd>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b2;</mi>
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#x2061;</mi>
                        </mrow>
                        <mi>&#x3b3;</mi>
                      </mtd>
                    </mtr>
                  </mtable>
                  <mo>]</mo>
                </mrow>
                <mrow>
                  <mrow>
                    <mo>[</mo>
                    <mtable>
                      <mtr>
                        <mtd>
                          <msub>
                            <mi>s</mi>
                            <mi>x</mi>
                          </msub>
                          <mi>&#x2217;</mi>
                          <mrow>
                            <mo>(</mo>
                            <mi>x</mi>
                            <mo>&#x2212;</mo>
                            <msub>
                              <mi>a</mi>
                              <mi>x</mi>
                            </msub>
                            <mo>)</mo>
                          </mrow>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <msub>
                            <mi>s</mi>
                            <mi>y</mi>
                          </msub>
                          <mi>&#x2217;</mi>
                          <mrow>
                            <mo>(</mo>
                            <mi>y</mi>
                            <mo>&#x2212;</mo>
                            <msub>
                              <mi>a</mi>
                              <mi>y</mi>
                            </msub>
                            <mo>)</mo>
                          </mrow>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <msub>
                            <mi>s</mi>
                            <mi>z</mi>
                          </msub>
                          <mi>&#x2217;</mi>
                          <mrow>
                            <mo>(</mo>
                            <mi>z</mi>
                            <mo>&#x2212;</mo>
                            <msub>
                              <mi>a</mi>
                              <mi>z</mi>
                            </msub>
                            <mo>)</mo>
                          </mrow>
                        </mtd>
                      </mtr>
                    </mtable>
                    <mo>]</mo>
                  </mrow>
                  <mo>+</mo>
                  <mrow>
                    <mo>[</mo>
                    <mtable>
                      <mtr>
                        <mtd>
                          <msub>
                            <mi>x</mi>
                            <mn>0</mn>
                          </msub>
                          <mo>+</mo>
                          <msub>
                            <mi>t</mi>
                            <mi>x</mi>
                          </msub>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <msub>
                            <mi>y</mi>
                            <mn>0</mn>
                          </msub>
                          <mo>+</mo>
                          <msub>
                            <mi>t</mi>
                            <mi>y</mi>
                          </msub>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <msub>
                            <mi>z</mi>
                            <mn>0</mn>
                          </msub>
                          <mo>+</mo>
                          <msub>
                            <mi>t</mi>
                            <mi>z</mi>
                          </msub>
                        </mtd>
                      </mtr>
                    </mtable>
                    <mo>]</mo>
                  </mrow>
                </mrow>
              </mrow>
              <msqrt>
                <mi>d</mi>
              </msqrt>
            </mstyle>
          </math>
        MATHML
        latex = "\\text{Convert} ( x , y , z , p_{a} , p_{o} , R , S , T ) = R_{z} ( \\alpha ) R_{y} ( \\beta ) R_{x} ( \\gamma ) S ( x - a_{x} , y - a_{y} , z - a_{z} ) + p_{o} + T =\\\\  \\left [\\begin{matrix}\\cos{\\text{P[funcapply]}} \\alpha \\cos{\\beta} & \\cos{\\text{P[funcapply]}} \\alpha \\sin{\\text{P[funcapply]}} \\beta \\sin{\\text{P[funcapply]}} \\gamma - \\sin{\\text{P[funcapply]}} \\alpha \\cos{\\gamma} & \\cos{\\text{P[funcapply]}} \\alpha \\sin{\\text{P[funcapply]}} \\beta \\cos{\\text{P[funcapply]}} \\gamma + \\sin{\\text{P[funcapply]}} \\alpha \\sin{\\text{P[funcapply]}} \\gamma \\\\ \\sin{\\text{P[funcapply]}} \\alpha \\cos{\\text{P[funcapply]}} \\beta & \\sin{\\text{P[funcapply]}} \\alpha \\sin{\\text{P[funcapply]}} \\beta \\sin{\\text{P[funcapply]}} \\gamma + \\cos{\\text{P[funcapply]}} \\alpha \\cos{\\text{P[funcapply]}} \\gamma & \\sin{\\text{P[funcapply]}} \\alpha \\sin{\\text{P[funcapply]}} \\beta \\cos{\\text{P[funcapply]}} \\gamma - \\cos{\\text{P[funcapply]}} \\alpha \\sin{\\text{P[funcapply]}} \\gamma \\\\ - \\sin{\\text{P[funcapply]}} \\beta & \\text{“cos ⁡”} \\beta \\sin{\\text{P[funcapply]}} \\gamma & \\cos{\\text{P[funcapply]}} \\beta \\cos{\\text{P[funcapply]}} \\gamma\\end{matrix}\\right ] \\left [\\begin{matrix}s_{x} \\ast ( x - a_{x} ) \\\\ s_{y} \\ast ( y - a_{y} ) \\\\ s_{z} \\ast ( z - a_{z} )\\end{matrix}\\right ] + \\left [\\begin{matrix}x_{0} + t_{x} \\\\ y_{0} + t_{y} \\\\ z_{0} + t_{z}\\end{matrix}\\right ] \\sqrt{d}"
        asciimath = "\"Convert\" (x , y , z , p_(a) , p_(o) , R , S , T) = R_(z) (alpha) R_(y) (beta) R_(x) (gamma) S (x - a_(x) , y - a_(y) , z - a_(z)) + p_(o) + T =\\\n  [[cos\"P{funcapply}\" alpha cosbeta, cos\"P{funcapply}\" alpha sin\"P{funcapply}\" beta sin\"P{funcapply}\" gamma - sin\"P{funcapply}\" alpha cosgamma, cos\"P{funcapply}\" alpha sin\"P{funcapply}\" beta cos\"P{funcapply}\" gamma + sin\"P{funcapply}\" alpha sin\"P{funcapply}\" gamma], [sin\"P{funcapply}\" alpha cos\"P{funcapply}\" beta, sin\"P{funcapply}\" alpha sin\"P{funcapply}\" beta sin\"P{funcapply}\" gamma + cos\"P{funcapply}\" alpha cos\"P{funcapply}\" gamma, sin\"P{funcapply}\" alpha sin\"P{funcapply}\" beta cos\"P{funcapply}\" gamma - cos\"P{funcapply}\" alpha sin\"P{funcapply}\" gamma], [- sin\"P{funcapply}\" beta, \"“cos ⁡”\" beta sin\"P{funcapply}\" gamma, cos\"P{funcapply}\" beta cos\"P{funcapply}\" gamma]] [[s_(x) ast (x - a_(x))], [s_(y) ast (y - a_(y))], [s_(z) ast (z - a_(z))]] + [[x_(0) + t_(x)], [y_(0) + t_(y)], [z_(0) + t_(z)]] sqrt(d)"
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(split_on_linebreak: true, unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains longidv tag Mathml" do
      let(:string)  do
        <<~MATHML
          <math>
            <mstyle displaystyle="true">
              <mscarries crossout='updiagonalstrike'>
                <mlongdiv longdivstyle="lefttop">
                  <mn>12</mn>
                  <msline length="2"/>
                  <mi>i</mi>
                </mlongdiv>
                <merror>
                  <mrow>
                    <mi>failed</mi>
                  </mrow>
                </merror>
              </mscarries>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares MathML, LaTeX, and AsciiMath string' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mscarries>
                <mrow>
                  <mlongdiv>
                    <mn>12</mn>
                    <msline/>
                    <mi>i</mi>
                  </mlongdiv>
                  <merror>
                    <mi>failed</mi>
                  </merror>
                </mrow>
              </mscarries>
            </mstyle>
          </math>
        MATHML
        latex = "12  i "
        asciimath = "12i "
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains mglyph with options/attributes index, src, and alt Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mglyph src="image.png" alt="Alternate Text" index="65534"/>
              <mglyph src="image.png" alt="Alternate Text 1" index="34"/>
              <mglyph src="image.png" alt="Alternate Text 2" index="0"/>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares MathML, LaTeX, and AsciiMath string' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mglyph src="image.png" alt="Alternate Text" index="65534"/>
              <mglyph src="image.png" alt="Alternate Text 1" index="34"/>
              <mglyph src="image.png" alt="Alternate Text 2" index="0"/>
            </mstyle>
          </math>
        MATHML
        latex = "Alternate Text Alternate Text 1 Alternate Text 2"
        asciimath = "Alternate Text Alternate Text 1 Alternate Text 2"
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains mpadded with attributes width, height, and depth Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mpadded height="100" width="100" depth="100">
                <mi>F</mi>
              </mpadded>
              <mpadded height="0%" width="0%" depth="00%">
                <mi>F</mi>
              </mpadded>
              <none/>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares MathML, LaTeX, and AsciiMath string' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mpadded height="100" width="100" depth="100">
                <mi>F</mi>
              </mpadded>
              <mpadded height="0%" width="0%" depth="00%">
                <mi>F</mi>
              </mpadded>
            </mstyle>
          </math>
        MATHML
        latex = "F F"
        asciimath = "F F"
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains mmultiscript containing none tag Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mmultiscripts>
                <mo>&#x2211;</mo>
                <mi>F</mi>
                <mi>A</mi>
                <mprescripts/>
                <none/>
                <mi/>
              </mmultiscripts>
              <mmultiscripts>
                <mo>&#x2211;</mo>
                <mi>F</mi>
                <mi>B</mi>
                <mprescripts/>
                <mn>4</mn>
                <mi>E</mi>
              </mmultiscripts>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares MathML, LaTeX, and AsciiMath string' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mmultiscripts>
                <mo>&#x2211;</mo>
                <mi>F</mi>
                <mi>A</mi>
                <mprescripts/>
                <none/>
                <none/>
              </mmultiscripts>
              <mmultiscripts>
                <mo>&#x2211;</mo>
                <mi>F</mi>
                <mi>B</mi>
                <mprescripts/>
                <mn>4</mn>
                <mi>E</mi>
              </mmultiscripts>
            </mstyle>
          </math>
        MATHML
        latex = "{}_{}^{}\\sum_{F}^{A} {}_{4}^{E}\\sum_{F}^{B}"
        asciimath = "\\ _()^()sum_(F)^(A) \\ _(4)^(E)sum_(F)^(B)"
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains mstyle containing nary oint value in msubsup tag Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mo>&#x222e;</mo>
                <mi>F</mi>
                <mi>A</mi>
              </msubsup>
              <mi>C</mi>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares MathML, LaTeX, and AsciiMath string' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <msubsup>
                  <mo>&#x222e;</mo>
                  <mi>F</mi>
                  <mi>A</mi>
                </msubsup>
                <mi>C</mi>
              </mrow>
            </mstyle>
          </math>
        MATHML
        latex = "\\oint_{F}^{A} C"
        asciimath = "oint_(F)^(A) C"
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains mstyle containing nary oint value in msub tag Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mo>&#x222e;</mo>
                <mi>F</mi>
              </msub>
              <mi>C</mi>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares MathML, LaTeX, and AsciiMath string' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mo>&#x222e;</mo>
                <mi>F</mi>
              </msub>
              <mi>C</mi>
            </mstyle>
          </math>
        MATHML
        latex = "\\oint_{F} C"
        asciimath = "oint_(F) C"
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains mtable containing frame, rowlines, and columnlines Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable frame="none" rowlines="solid" columnlines="dashed">
                <mtr>
                  <mtd>
                    <mo>&#x222a;</mo>
                    <mi>F</mi>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd>
                    <mo>&#x222a;</mo>
                    <mi>E</mi>
                  </mtd>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares MathML, LaTeX, and AsciiMath string' do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtable frame="none" rowlines="solid" columnlines="dashed">
                <mtr>
                  <mtd>
                    <mo>&#x222a;</mo>
                    <mi>F</mi>
                  </mtd>
                </mtr>
                <mtr>
                  <mtd>
                    <mo>&#x222a;</mo>
                    <mi>E</mi>
                  </mtd>
                </mtr>
              </mtable>
            </mstyle>
          </math>
        MATHML
        latex = "\\left .\\begin{matrix}{a}\\cup F \\\\ \\cup E\\end{matrix}\\right ."
        asciimath = "[[uu F], [uu E]]"
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains string from plurimath/issue#238" do
      let(:string)  do
        <<~MATHML
          <math>
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
                      <mo>&#8721;</mo>
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
                        <mi>&#957;</mi>
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
                    <mo>&#8721;</mo>
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
                      <mi>&#957;</mi>
                    </mstyle>
                    <mi>i</mi>
                  </msub>
                </mrow>
              </mfrac>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares MathML, LaTeX, and AsciiMath string' do
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
        latex = 's_{\text{p}}^{2} = \frac{\sum_{i = 1}^{\mathit{N}} \mathit{\nu}_{i} s_{i}^{2}}{\sum_{i = 1}^{\mathit{N}} \mathit{\nu}_{i}}'
        asciimath = 's_("p")^(2) = frac(sum_(i = 1)^(ii(N)) ii(nu)_(i) s_(i)^(2))(sum_(i = 1)^(ii(N)) ii(nu)_(i))'
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains input from metanorma-cli-actions-mn-bipm run" do
      let(:string) do
        <<~MATHML
          <math>
            <mstyle displaystyle="true">
              <munder>
                <mstyle mathvariant="italic">
                  <mi>B</mi>
                </mstyle>
                <mo>&#818;</mo>
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
                      <mo>&#8230;</mo>
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
      end

      it "compares MathML, LaTeX, and AsciiMath string" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mrow>
                  <mstyle mathvariant="italic">
                    <mi>B</mi>
                  </mstyle>
                </mrow>
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
                      <mrow>
                        <mstyle mathcolor="red">
                          <mn>1</mn>
                        </mstyle>
                      </mrow>
                    </mtd>
                    <mtd>
                      <mrow>
                        <mstyle mathcolor="red">
                          <mn>3</mn>
                        </mstyle>
                      </mrow>
                    </mtd>
                    <mtd>
                      <mrow>
                        <mstyle mathcolor="red">
                          <mn>3</mn>
                        </mstyle>
                      </mrow>
                    </mtd>
                    <mtd>
                      <mrow>
                        <mstyle mathcolor="red">
                          <mn>1</mn>
                        </mstyle>
                      </mrow>
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
        latex = '\underline{\mathit{B}} = \left [\begin{matrix}1 &  &  &  &  \\\\ 1 & 1 &  &  &  \\\\ 1 & 2 & 1 &  &  \\\\ {\color{"red"} 1} & {\color{"red"} 3} & {\color{"red"} 3} & {\color{"red"} 1} &  \\\\ 1 & 4 & 6 & 4 & 1 \\\\  &  & \ldots &  & \end{matrix}\right ]'
        asciimath = 'underline(ii(B)) = [[1, , , , ], [1, 1, , , ], [1, 2, 1, , ], [color("red")(1), color("red")(3), color("red")(3), color("red")(1), ], [1, 4, 6, 4, 1], [, , ..., , ]]'
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains input from metanorma-cli-actions-mn-itu run" do
      let(:string) do
        <<~MATHML
          <math>
            <mstyle displaystyle="true">
              <msub>
                <mi>y</mi>
                <mi>k</mi>
              </msub>
              <mo>=</mo>
              <mrow>
                <mo>(</mo>
                <msub>
                  <mi>x</mi>
                  <mi>k</mi>
                </msub>
                <mo>&#177;</mo>
                <mi>h</mi>
                <mo>)</mo>
              </mrow>
              <mo/>
              <mi>m</mi>
            </mstyle>
          </math>
        MATHML
      end

      it "compares MathML, LaTeX, annd AsciiMath string" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mi>y</mi>
                <mi>k</mi>
              </msub>
              <mo>=</mo>
              <mrow>
                <mo>(</mo>
                <msub>
                  <mi>x</mi>
                  <mi>k</mi>
                </msub>
                <mo>&#xb1;</mo>
                <mi>h</mi>
                <mo>)</mo>
              </mrow>
              <mi/>
              <mi>m</mi>
            </mstyle>
          </math>
        MATHML
        latex = "y_{k} = ( x_{k} \\pm h )  m"
        asciimath = "y_(k) = (x_(k) pm h)  m"
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains input from metanorma-cli-actions-mn-jcgm run" do
      let(:string) do
        <<~MATHML
          <math>
            <mstyle displaystyle="true">
              <mrow>
                <msubsup>
                  <mo>&#8747;</mo>
                  <mi>o</mi>
                  <mn>1</mn>
                </msubsup>
                <msub>
                  <mi mathvariant="normal">B</mi>
                  <mn>4</mn>
                </msub>
              </mrow>
              <mrow>
                <mo>(</mo>
                <mstyle mathvariant="italic">
                  <mi>&#961;</mi>
                </mstyle>
                <mo>)</mo>
              </mrow>
              <mtext>d</mtext>
              <mstyle mathvariant="italic">
                <mi>&#961;</mi>
              </mstyle>
              <mo>=</mo>
              <msubsup>
                <mrow>
                  <mo>[</mo>
                  <mfrac>
                    <mn>1</mn>
                    <mn>24</mn>
                  </mfrac>
                  <msup>
                    <mstyle mathvariant="italic">
                      <mi>&#961;</mi>
                    </mstyle>
                    <mn>4</mn>
                  </msup>
                  <mo>]</mo>
                </mrow>
                <mn>0</mn>
                <mn>1</mn>
              </msubsup>
              <mo>=</mo>
              <mfrac>
                <mn>1</mn>
                <mn>24</mn>
              </mfrac>
              <mi>&#8776;</mi>
              <mn>0.0417</mn>
            </mstyle>
          </math>
        MATHML
      end

      it "compares MathML, LaTeX, and AsciiMath string" do
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <msubsup>
                  <mo>&#x222b;</mo>
                  <mi>o</mi>
                  <mn>1</mn>
                </msubsup>
                <msub>
                  <mi>B</mi>
                  <mn>4</mn>
                </msub>
              </mrow>
              <mrow>
                <mo>(</mo>
                <mstyle mathvariant="italic">
                  <mi>&#x3c1;</mi>
                </mstyle>
                <mo>)</mo>
              </mrow>
              <mtext>d</mtext>
              <mstyle mathvariant="italic">
                <mi>&#x3c1;</mi>
              </mstyle>
              <mo>=</mo>
              <msubsup>
                <mrow>
                  <mo>[</mo>
                  <mfrac>
                    <mn>1</mn>
                    <mn>24</mn>
                  </mfrac>
                  <msup>
                    <mstyle mathvariant="italic">
                      <mi>&#x3c1;</mi>
                    </mstyle>
                    <mn>4</mn>
                  </msup>
                  <mo>]</mo>
                </mrow>
                <mn>0</mn>
                <mn>1</mn>
              </msubsup>
              <mo>=</mo>
              <mfrac>
                <mn>1</mn>
                <mn>24</mn>
              </mfrac>
              <mo>&#x2248;</mo>
              <mn>0.0417</mn>
            </mstyle>
          </math>
        MATHML
        latex = '\int_{o}^{1} B_{4} ( \mathit{\rho} ) \text{d} \mathit{\rho} = [ \frac{1}{24} \mathit{\rho}^{4} ]_{0}^{1} = \frac{1}{24} \approx 0.0417'
        asciimath = 'int_(o)^(1) B_(4) (ii(rho)) "d" ii(rho) = [frac(1)(24) ii(rho)^(4)]_(0)^(1) = frac(1)(24) approx 0.0417'
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml(unary_function_spacing: false)).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end
  end

  describe ".to_omml" do
    subject(:formula) { described_class.new(string).to_formula.to_omml }

    context "contains one value in sub tag in Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML">
            <mrow>
              <msubsup>
                <mrow>
                  <mstyle mathvariant="italic">
                    <mi>N</mi>
                  </mstyle>
                </mrow>
                <mrow>
                  <mi>s</mi>
                </mrow>
                <mrow>
                  <mn>2</mn>
                </mrow>
              </msubsup>
              <mstyle mathvariant="italic">
                <mi>T</mi>
              </mstyle>
            </mrow>
            <mrow>
              <msubsup>
                <mrow>
                  <mstyle mathvariant="italic">
                    <mi>N</mi>
                  </mstyle>
                </mrow>
                <mrow>
                  <mi>s</mi>
                </mrow>
                <mrow>
                  <mn>2</mn>
                </mrow>
              </msubsup>
              <mstyle mathvariant="italic">
                <mn>100</mn>
              </mstyle>
            </mrow>
            <mrow>
              <msubsup>
                <mrow>
                  <mstyle mathvariant="italic">
                    <mi>N</mi>
                  </mstyle>
                </mrow>
                <mrow>
                  <mi>s</mi>
                </mrow>
                <mrow>
                  <mn>2</mn>
                </mrow>
              </msubsup>
              <mstyle mathvariant="italic">
                <mrow>
                  <mfrac>
                    <mo>f</mo>
                    <mn>100</mn>
                  </mfrac>
                </mrow>
              </mstyle>
            </mrow>
          </math>
        MATHML
      end

      let(:expected_value) do
        <<~OMML
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
                      <m:sty m:val="i"/>
                    </m:rPr>
                    <m:t>N</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>s</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>2</m:t>
                  </m:r>
                </m:sup>
              </m:sSubSup>
              <m:r>
                <m:rPr>
                  <m:sty m:val="i"/>
                </m:rPr>
                <m:t>T</m:t>
              </m:r>
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
                    <m:t>N</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>s</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>2</m:t>
                  </m:r>
                </m:sup>
              </m:sSubSup>
              <m:r>
                <m:rPr>
                  <m:sty m:val="i"/>
                </m:rPr>
                <m:t>100</m:t>
              </m:r>
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
                    <m:t>N</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>s</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>2</m:t>
                  </m:r>
                </m:sup>
              </m:sSubSup>
              <m:r>
                <m:rPr>
                  <m:sty m:val="i"/>
                </m:rPr>
                <m:f>
                  <m:fPr>
                    <m:ctrlPr>
                      <w:rPr>
                        <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                        <w:i/>
                      </w:rPr>
                    </m:ctrlPr>
                  </m:fPr>
                  <m:num>
                    <m:r>
                      <m:t>f</m:t>
                    </m:r>
                  </m:num>
                  <m:den>
                    <m:r>
                      <m:t>100</m:t>
                    </m:r>
                  </m:den>
                </m:f>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        OMML
      end

      it 'returns Mathml string' do
        expect(formula).to eq(expected_value)
      end
    end

    context "contains multiple tags in Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msup>
                <mn>2</mn>
                <mi/>
              </msup>
              <msup>
                <mi/>
                <mi>&#x3b8;</mi>
              </msup>
              <mo linebreak="newline" linebreakstyle="after">=</mo>
              <msub>
                <mi/>
                <mi>&#x3b8;</mi>
              </msub>
              <msub>
                <mn>100</mn>
                <mrow>
                  <mi>&#x3b8;</mi>
                </mrow>
              </msub>
              <msgroup>
                <munderover>
                  <mn>100</mn>
                  <mi>&#x3b1;</mi>
                  <mrow>
                    <mi>&#x3b2;</mi>
                  </mrow>
                </munderover>
              </msgroup>
            </mstyle>
          </math>
        MATHML
      end

      let(:expected_value) do
        <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
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
                    <m:t>2</m:t>
                  </m:r>
                </m:e>
                <m:sup>
                  <m:r>
                    <m:t>&#8203;</m:t>
                  </m:r>
                </m:sup>
              </m:sSup>
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
                    <m:t>&#8203;</m:t>
                  </m:r>
                </m:e>
                <m:sup>
                  <m:r>
                    <m:t>&#x3b8;</m:t>
                  </m:r>
                </m:sup>
              </m:sSup>
              <m:r>
                <m:t>=</m:t>
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
                    <m:t>&#8203;</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>&#x3b8;</m:t>
                  </m:r>
                </m:sub>
              </m:sSub>
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
                    <m:t>100</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>&#x3b8;</m:t>
                  </m:r>
                </m:sub>
              </m:sSub>
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
                        <m:t>100</m:t>
                      </m:r>
                    </m:e>
                    <m:lim>
                      <m:r>
                        <m:t>&#x3b2;</m:t>
                      </m:r>
                    </m:lim>
                  </m:limUpp>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>&#x3b1;</m:t>
                  </m:r>
                </m:lim>
              </m:limLow>
            </m:oMath>
          </m:oMathPara>
        OMML
      end

      it 'returns Mathml string' do
        expect(formula).to eq(expected_value)
      end
    end

    context "contains menclose tags in Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <menclose notation="updiagonalstrike">
                <msubsup>
                  <mi>a</mi>
                  <mi>b</mi>
                  <mi>c</mi>
                </msubsup>
              </menclose>
            </mstyle>
          </math>
        MATHML
      end

      let(:expected_value) do
        <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:borderBox>
                <m:borderBoxPr>
                  <m:hideTop m:val="on"/>
                  <m:hideBot m:val="on"/>
                  <m:hideLeft m:val="on"/>
                  <m:hideRight m:val="on"/>
                  <m:strikeBLTR m:val="on"/>
                </m:borderBoxPr>
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
                        <m:t>a</m:t>
                      </m:r>
                    </m:e>
                    <m:sub>
                      <m:r>
                        <m:t>b</m:t>
                      </m:r>
                    </m:sub>
                    <m:sup>
                      <m:r>
                        <m:t>c</m:t>
                      </m:r>
                    </m:sup>
                  </m:sSubSup>
                </m:e>
              </m:borderBox>
            </m:oMath>
          </m:oMathPara>
        OMML
      end

      it 'returns Mathml string' do
        expect(formula).to eq(expected_value)
      end
    end

    context "contains scarries, longdiv, msline and scarry tags in Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mscarries crossout='updiagonalstrike'>
                <mlongdiv longdivstyle="lefttop">
                  <mn>2</mn>
                  <msline length="2"/>
                  <mn>12</mn>
                </mlongdiv>
                <mscarry crossout='none'>
                  <none/>
                </mscarry>
              </mscarries>
            </mstyle>
          </math>
        MATHML
      end

      let(:expected_value) do
        <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:r>
                <m:t>2</m:t>
              </m:r>
              <m:r>
                <m:t>12</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        OMML
      end

      it 'returns Mathml string' do
        expect(formula).to eq(expected_value)
      end
    end

    context "contains underover, under, and over tags with displaystyle false in Mathml" do
      let(:string)  do
        <<~MATHML
          <math display="block" xmlns="http://www.w3.org/1998/Math/MathML">
            <mstyle displaystyle="false">
              <mrow>
                <munderover>
                  <mi>m</mi>
                  <mi>d</mi>
                  <mn>3</mn>
                </munderover>
                <munder>
                  <mi>s</mi>
                  <mi>p</mi>
                </munder>
                <mover>
                  <mi>θ</mi>
                  <mi>d</mi>
                </mover>
              </mrow>
            </mstyle>
          </math>
        MATHML
      end

      let(:expected_value) do
        <<~OMML
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
                    <m:t>m</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>3</m:t>
                  </m:r>
                </m:sup>
              </m:sSubSup>
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
                    <m:t>p</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>s</m:t>
                  </m:r>
                </m:sub>
              </m:sSub>
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
                    <m:t>&#x3b8;</m:t>
                  </m:r>
                </m:sup>
              </m:sSup>
            </m:oMath>
          </m:oMathPara>
        OMML
      end

      it 'returns Mathml string' do
        expect(formula).to eq(expected_value)
      end
    end

    context "contains bar, vec, dot, ddot, ul, and tilde examples containing accent and accentunder true in Mathml" do
      let(:string)  do
        <<~MATHML
          <math display="block" xmlns="http://www.w3.org/1998/Math/MathML">
            <mstyle displaystyle="true">
              <semantics>
                <mrow>
                  <munder accentunder="true">
                    <mn>3</mn>
                    <mo>&#xaf;</mo>
                  </munder>
                  <mover accent="true">
                    <mn>3</mn>
                    <mo>&#x332;</mo>
                  </mover>
                  <mover accent="true">
                    <mi>d</mi>
                    <mo>..</mo>
                  </mover>
                  <mover accent="true">
                    <mi>d</mi>
                    <mo>&#x2192;</mo>
                  </mover>
                  <mover accent="true">
                    <mi>d</mi>
                    <mo>~</mo>
                  </mover>
                  <munder accentunder="true">
                    <mi>d</mi>
                    <mo>&#xaf;</mo>
                  </munder>
                </mrow>
                <annotation>
                  <mi>MathType@MTEF@5@5@+= feaagKart1ev2aaatCvAUfeBSjuyZL2yd9gzLbvyNv2CaerbbjxAHX garuavP1wzZbItLDhis9wBH5garmWu51MyVXgarqqtubsr4rNCHbGe aGqipG0dh9qqWrVepG0dbbL8F4rqqrVepeea0xe9LqFf0xc9q8qqaq Fn0lXdHiVcFbIOFHK8Feea0dXdar=Jb9hs0dXdHuk9fr=xfr=xfrpe WZqaaeaaciWacmGadaGadeaabaGaaqaaaOqaamaapedabaGaamOzai aacIcacaWG0bGaaiykaKqzaeGaaiizaOGaamiDaaWcbaGaamiDamaa BaaameaacaaIYaaabeaaaSqaaiaadshadaWgaaadbaGaaGymaaqaba aaniabgUIiYdaaaa@40DD@ </mi>
                </annotation>
              </semantics>
            </mstyle>
          </math>
        MATHML
      end

      let(:expected_value) do
        <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:groupChr>
                <m:groupChrPR>
                  <m:chr m:val="_"/>
                  <m:pos m:val="bot"/>
                </m:groupChrPR>
                <m:e>
                  <m:r>
                    <m:t>3</m:t>
                  </m:r>
                </m:e>
              </m:groupChr>
              <m:acc>
                <m:accPr>
                  <m:chr m:val="‾"/>
                </m:accPr>
                <m:e>
                  <m:r>
                    <m:t>3</m:t>
                  </m:r>
                </m:e>
              </m:acc>
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
                    <m:t>..</m:t>
                  </m:r>
                </m:lim>
              </m:limUpp>
              <m:acc>
                <m:accPr>
                  <m:chr m:val="→"/>
                </m:accPr>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
              </m:acc>
              <m:acc>
                <m:accPr>
                  <m:chr m:val="˜"/>
                </m:accPr>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
              </m:acc>
              <m:groupChr>
                <m:groupChrPR>
                  <m:chr m:val="_"/>
                  <m:pos m:val="bot"/>
                </m:groupChrPR>
                <m:e>
                  <m:r>
                    <m:t>d</m:t>
                  </m:r>
                </m:e>
              </m:groupChr>
            </m:oMath>
          </m:oMathPara>
        OMML
      end

      it 'returns Mathml string' do
        expect(formula).to eq(expected_value)
      end
    end

    context "contains nary example Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mover>
                  <mo>&#x222c;</mo>
                  <mn>1</mn>
                </mover>
                <mrow>
                  <mn>3</mn>
                </mrow>
              </mrow>
            </mstyle>
            <mstyle displaystyle="true">
              <mrow>
                <msup>
                  <mo>&#x222c;</mo>
                  <mn>1</mn>
                </msup>
                <mrow>
                  <mn>3</mn>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
      end

      let(:expected_value) do
        <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:nary>
                <m:naryPr>
                  <m:chr m:val="∬"/>
                  <m:limLoc m:val="undOvr"/>
                  <m:subHide m:val="1"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:naryPr>
                <m:sub>
                  <m:r>
                    <m:t>&#8203;</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>1</m:t>
                  </m:r>
                </m:sup>
                <m:e>
                  <m:r>
                    <m:t>3</m:t>
                  </m:r>
                </m:e>
              </m:nary>
              <m:nary>
                <m:naryPr>
                  <m:chr m:val="∬"/>
                  <m:limLoc m:val="subSup"/>
                  <m:subHide m:val="1"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:naryPr>
                <m:sub>
                  <m:r>
                    <m:t>&#8203;</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>1</m:t>
                  </m:r>
                </m:sup>
                <m:e>
                  <m:r>
                    <m:t>3</m:t>
                  </m:r>
                </m:e>
              </m:nary>
            </m:oMath>
          </m:oMathPara>
        OMML
      end

      it 'returns Mathml string' do
        expect(formula).to eq(expected_value)
      end
    end

    context "contains mfrac with options/attributes tag Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfrac linethickness="0">
                <mn>12</mn>
                <mi>i</mi>
              </mfrac>
              <mfrac bevelled="true">
                <mn>12</mn>
                <mi>i</mi>
              </mfrac>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:f>
                <m:fPr>
                  <m:type m:val="noBar"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:fPr>
                <m:num>
                  <m:r>
                    <m:t>12</m:t>
                  </m:r>
                </m:num>
                <m:den>
                  <m:r>
                    <m:t>i</m:t>
                  </m:r>
                </m:den>
              </m:f>
              <m:f>
                <m:fPr>
                  <m:type m:val="skw"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:fPr>
                <m:num>
                  <m:r>
                    <m:t>12</m:t>
                  </m:r>
                </m:num>
                <m:den>
                  <m:r>
                    <m:t>i</m:t>
                  </m:r>
                </m:den>
              </m:f>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to eq(omml)
      end
    end

    context "contains mglyph with options/attributes index, src, and alt Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mglyph src="image.png" alt="Alternate Text" index="65534"/>
              <mglyph src="image.png" alt="Alternate Text 1" index="34"/>
              <mglyph src="image.png" alt="Alternate Text 2" index="0"/>
              <mglyph src="image.png" alt="Alternate Text 2" index="10"/>
              <mglyph src="image.png" alt="Alternate Text 2" index="176"/>
              <mglyph src="image.png" alt="Alternate Text 2" index="192"/>
              <mglyph src="image.png" alt="Alternate Text 2" index="208"/>
              <mglyph src="image.png" alt="Alternate Text 2" index="224"/>
              <mglyph src="image.png" alt="Alternate Text 2" index="240"/>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:r>
                <m:t>Alternate Text</m:t>
              </m:r>
              <m:r>
                <m:t>&#x22;</m:t>
              </m:r>
              <m:r>
                <m:t>Alternate Text 2</m:t>
              </m:r>
              <m:r>
                <m:t>&#xA;</m:t>
              </m:r>
              <m:r>
                <m:t>&#xB0;</m:t>
              </m:r>
              <m:r>
                <m:t>&#xC0;</m:t>
              </m:r>
              <m:r>
                <m:t>&#xD0;</m:t>
              </m:r>
              <m:r>
                <m:t>&#xE0;</m:t>
              </m:r>
              <m:r>
                <m:t>&#xF0;</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to eq(omml)
      end
    end

    context "contains mpadded with attributes width, height, and depth Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mpadded height="100" width="100" depth="100">
                <mi>F</mi>
              </mpadded>
              <mpadded height="0%" width="0%" depth="00%">
                <mi>F</mi>
              </mpadded>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:phant>
                <m:e>
                  <m:r>
                    <m:t>F</m:t>
                  </m:r>
                </m:e>
              </m:phant>
              <m:phant>
                <m:phantPr>
                  <zeroAsc m:val="on"/>
                  <zeroDesc m:val="on"/>
                  <zeroWid m:val="on"/>
                </m:phantPr>
                <m:e>
                  <m:r>
                    <m:t>F</m:t>
                  </m:r>
                </m:e>
              </m:phant>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to eq(omml)
      end
    end

    context "contains ms tag Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <ms>
              <mi>F</mi>
              <mn>F</mn>
            </ms>
            <ms>
              <msubsup>
                <mrow>
                  <mi>F</mi>
                </mrow>
                <mn>3</mn>
                <mo>&#x2a;</mo>
              </msubsup>
            </ms>
          </math>
        MATHML
      end

      it 'compares OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:t>“F F”</m:t>
              <m:t>“F 3 *”</m:t>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to eq(omml)
      end
    end

    context "contains multiscripts containing none tag Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mmultiscripts>
                <mo>&#x2211;</mo>
                <mi>F</mi>
                <mi>A</mi>
                <mprescripts/>
                <none/>
                <mi/>
              </mmultiscripts>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:sPre>
                <m:e>
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
                            <m:t>&#x2211;</m:t>
                          </m:r>
                        </m:e>
                        <m:lim>
                          <m:r>
                            <m:t>A</m:t>
                          </m:r>
                        </m:lim>
                      </m:limUpp>
                    </m:e>
                    <m:lim>
                      <m:r>
                        <m:t>F</m:t>
                      </m:r>
                    </m:lim>
                  </m:limLow>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>&#8203;</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>&#8203;</m:t>
                  </m:r>
                </m:sup>
              </m:sPre>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to eq(omml)
      end
    end

    context "contains oint msubsup tag Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <msubsup>
                  <mo>&#x222e;</mo>
                  <mi>F</mi>
                  <mi>A</mi>
                </msubsup>
                <mi>C</mi>
              </mrow>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares OMML string' do
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
                    <m:t>F</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>A</m:t>
                  </m:r>
                </m:sup>
                <m:e>
                  <m:r>
                    <m:t>C</m:t>
                  </m:r>
                </m:e>
              </m:nary>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to eq(omml)
      end
    end

    context "contains nary iiint symbol in underover for nary tag Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <munderover>
                  <mo>&#x222d;</mo>
                  <mi>F</mi>
                  <mi>A</mi>
                </munderover>
                <mi>C</mi>
              </mrow>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:nary>
                <m:naryPr>
                  <m:chr m:val="∭"/>
                  <m:limLoc m:val="undOvr"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:naryPr>
                <m:sub>
                  <m:r>
                    <m:t>F</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>A</m:t>
                  </m:r>
                </m:sup>
                <m:e>
                  <m:r>
                    <m:t>C</m:t>
                  </m:r>
                </m:e>
              </m:nary>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to eq(omml)
      end
    end

    context "contains nary iiint symbol in subsup for nary tag Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <msubsup>
                  <mo>&#x222d;</mo>
                  <mi>F</mi>
                  <mi>A</mi>
                </msubsup>
                <mi>C</mi>
              </mrow>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:nary>
                <m:naryPr>
                  <m:chr m:val="∭"/>
                  <m:limLoc m:val="subSup"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:naryPr>
                <m:sub>
                  <m:r>
                    <m:t>F</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>A</m:t>
                  </m:r>
                </m:sup>
                <m:e>
                  <m:r>
                    <m:t>C</m:t>
                  </m:r>
                </m:e>
              </m:nary>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to eq(omml)
      end
    end

    context "contains nary prod symbol in underover for nary tag Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <munderover>
                  <mo>&#x220f;</mo>
                  <mi>F</mi>
                  <mi>A</mi>
                </munderover>
                <mi>C</mi>
              </mrow>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:nary>
                <m:naryPr>
                  <m:chr m:val="∏"/>
                  <m:limLoc m:val="undOvr"/>
                  <m:subHide m:val="0"/>
                  <m:supHide m:val="0"/>
                </m:naryPr>
                <m:sub>
                  <m:r>
                    <m:t>F</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>A</m:t>
                  </m:r>
                </m:sup>
                <m:e>
                  <m:r>
                    <m:t>C</m:t>
                  </m:r>
                </m:e>
              </m:nary>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to eq(omml)
      end
    end

    context "contains nary iiint symbol in munder for nary tag Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <munder>
                  <mo>&#x222d;</mo>
                  <mi>F</mi>
                </munder>
                <mi>C</mi>
              </mrow>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares OMML string' do
        omml = <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:nary>
                <m:naryPr>
                  <m:chr m:val="∭"/>
                  <m:limLoc m:val="undOvr"/>
                  <m:supHide m:val="1"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:naryPr>
                <m:sub>
                  <m:r>
                    <m:t>F</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>&#8203;</m:t>
                  </m:r>
                </m:sup>
                <m:e>
                  <m:r>
                    <m:t>C</m:t>
                  </m:r>
                </m:e>
              </m:nary>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to eq(omml)
      end
    end

    context "contains empty mo example from plurimath/plurimath#318 Mathml" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML">
            <mstyle displaystyle="true">
              <msub>
                <mi>y</mi>
                <mi>k</mi>
              </msub>
              <mrow>
                <mo>=</mo>
              </mrow>
              <mrow>
                <mo>(</mo>
                <msub>
                  <mi>x</mi>
                  <mi>k</mi>
                </msub>
                <mrow>
                  <mo>&#xB1;</mo>
                </mrow>
                <mi>h</mi>
                <mo>)</mo>
              </mrow>
              <mo/>
              <mi>m</mi>
            </mstyle>
          </math>
        MATHML
      end

      it 'compares OMML string' do
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
                    <m:t>y</m:t>
                  </m:r>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>k</m:t>
                  </m:r>
                </m:sub>
              </m:sSub>
              <m:r>
                <m:t>=</m:t>
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
                        <m:t>x</m:t>
                      </m:r>
                    </m:e>
                    <m:sub>
                      <m:r>
                        <m:t>k</m:t>
                      </m:r>
                    </m:sub>
                  </m:sSub>
                  <m:r>
                    <m:t>&#xb1;</m:t>
                  </m:r>
                  <m:r>
                    <m:t>h</m:t>
                  </m:r>
                </m:e>
              </m:d>
              <m:r>
                <m:t/>
              </m:r>
              <m:r>
                <m:t>m</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        OMML
        expect(formula).to eq(omml)
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(string).to_formula.to_html }

    context "contains subsup and linebreak with different values example in MathML" do
      let(:string)  do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML">
            <msubsup>
              <mrow>
                <mstyle mathvariant="italic">
                  <mi>N</mi>
                </mstyle>
              </mrow>
              <mrow>
                <mi>s</mi>
              </mrow>
              <mrow>
                <mn>2</mn>
              </mrow>
            </msubsup>
            <mo linebreak="newline" linebreakstyle="after">=</mo>
            <mi>T</mi>
            <mo linebreak="newline">&#x2191;</mo>
            <mi>S</mi>
            <mo linebreak="newline" />
            <mi>D</mi>
          </math>
        MATHML
      end

      let(:expected_value) { "<i>N</i><sub>s</sub><sup>2</sup> =<br/> T <br/>&#x2191; S <br/> D" }

      it 'returns HTML string for linebreak' do
        expect(formula).to eq(expected_value)
      end
    end
  end
end
