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
              <mrow>
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
              </mrow>
            </mstyle>
          </math>
        MATHML
        latex = "h a n n i n g ( k ) = 0 . 5 \\cdot [ 1 - \\cos{(} 2 \\pi \\cdot \\frac{k + 1}{n + 1} ) ] \\text{} ( 0 \\le k \\le n - 1 )"
        asciimath = 'h a n n i n g ( k ) = 0 . 5 * [ 1 - cos( 2 pi * frac(k + 1)(n + 1) ) ] "" ( 0 le k le n - 1 )'
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
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
                      <mo>d</mo>
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
                    <mi>d</mi>
                    <mi>t</mi>
                  </mrow>
                </mrow>
                <annotation>
                  <mi>MathType@MTEF@5@5@+= feaagKart1ev2aaatCvAUfeBSjuyZL2yd9gzLbvyNv2CaerbbjxAHX garuavP1wzZbItLDhis9wBH5garmWu51MyVXgarqqtubsr4rNCHbGe aGqipG0dh9qqWrVepG0dbbL8F4rqqrVepeea0xe9LqFf0xc9q8qqaq Fn0lXdHiVcFbIOFHK8Feea0dXdar=Jb9hs0dXdHuk9fr=xfr=xfrpe WZqaaeaaciWacmGadaGadeaabaGaaqaaaOqaamaapedabaGaamOzai aacIcacaWG0bGaaiykaKqzaeGaaiizaOGaamiDaaWcbaGaamiDamaa BaaameaacaaIYaaabeaaaSqaaiaadshadaWgaaadbaGaaGymaaqaba aaniabgUIiYdaaaa@40DD@ </mi>
                </annotation>
              </semantics>
            </mstyle>
          </math>
        MATHML
        latex = "\\int_{t_{2}}^{t_{1}} f ( t ) d t"
        asciimath = 'int_(t_(2))^(t_(1)) f ( t ) d t'
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
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
                    <mo> + </mo>
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
        latex = " x  \\  \\   +   z "
        asciimath = ' x  \  \  +  z '
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
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
        expect(formula.to_mathml).to be_equivalent_to(mathml)
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
        expect(formula.to_mathml).to be_equivalent_to(mathml)
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
              <mo>=</mo>
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
                        <mrow>
                          <mi>cos</mi>
                          <mi>&#8289;</mi>
                        </mrow>
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
              <mrow>
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
                          <mrow>
                            <mi>cos</mi>
                            <mi>&#x2061;</mi>
                          </mrow>
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
              </mrow>
            </mstyle>
          </math>
        MATHML
        latex = "\\text{Convert} ( x , y , z , p_{a} , p_{o} , R , S , T ) = R_{z} ( \\alpha ) R_{y} ( \\beta ) R_{x} ( \\gamma ) S ( x - a_{x} ,  y - a_{y} ,  z - a_{z} ) + p_{o} + T = \\left [\\begin{matrix}\\cos{&#x2061;} \\alpha \\cos{\\beta} & \\cos{&#x2061;} \\alpha \\sin{&#x2061;} \\beta \\sin{&#x2061;} \\gamma - \\sin{&#x2061;} \\alpha \\cos{\\gamma} & \\cos{&#x2061;} \\alpha \\sin{&#x2061;} \\beta \\cos{&#x2061;} \\gamma + \\sin{&#x2061;} \\alpha \\sin{&#x2061;} \\gamma \\\\ \\sin{&#x2061;} \\alpha \\cos{&#x2061;} \\beta & \\sin{&#x2061;} \\alpha \\sin{&#x2061;} \\beta \\sin{&#x2061;} \\gamma + \\cos{&#x2061;} \\alpha \\cos{&#x2061;} \\gamma & \\sin{&#x2061;} \\alpha \\sin{&#x2061;} \\beta \\cos{&#x2061;} \\gamma - \\cos{&#x2061;} \\alpha \\sin{&#x2061;} \\gamma \\\\ - \\sin{&#x2061;} \\beta & \\cos{&#x2061;} \\beta \\sin{&#x2061;} \\gamma & \\cos{&#x2061;} \\beta \\cos{&#x2061;} \\gamma\\end{matrix}\\right ] \\left [\\begin{matrix}s_{x} \\ast ( x - a_{x} ) \\\\ s_{y} \\ast ( y - a_{y} ) \\\\ s_{z} \\ast ( z - a_{z} )\\end{matrix}\\right ] + \\left [\\begin{matrix}x_{0} + t_{x} \\\\ y_{0} + t_{y} \\\\ z_{0} + t_{z}\\end{matrix}\\right ] \\sqrt{d}"
        asciimath = "\"Convert\" (x , y , z , p_(a) , p_(o) , R , S , T) = R_(z) (alpha) R_(y) (beta) R_(x) (gamma) S (x - a_(x) ,  y - a_(y) ,  z - a_(z)) + p_(o) + T = [[cos&#x2061; alpha cosbeta, cos&#x2061; alpha sin&#x2061; beta sin&#x2061; gamma - sin&#x2061; alpha cosgamma, cos&#x2061; alpha sin&#x2061; beta cos&#x2061; gamma + sin&#x2061; alpha sin&#x2061; gamma], [sin&#x2061; alpha cos&#x2061; beta, sin&#x2061; alpha sin&#x2061; beta sin&#x2061; gamma + cos&#x2061; alpha cos&#x2061; gamma, sin&#x2061; alpha sin&#x2061; beta cos&#x2061; gamma - cos&#x2061; alpha sin&#x2061; gamma], [- sin&#x2061; beta, cos&#x2061; beta sin&#x2061; gamma, cos&#x2061; beta cos&#x2061; gamma]] [[s_(x) ast (x - a_(x))], [s_(y) ast (y - a_(y))], [s_(z) ast (z - a_(z))]] + [[x_(0) + t_(x)], [y_(0) + t_(y)], [z_(0) + t_(z)]] sqrt(d)"
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
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
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
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
  end
end
