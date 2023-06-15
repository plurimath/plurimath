require_relative '../spec_helper'

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
                  <mrow>
                    <mi>cos</mi>
                  </mrow>
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
        latex = "h a n n i n g ( k ) = 0 . 5 \\cdot [ 1 - \\cos ( 2 \\pi \\cdot \\frac{k + 1}{n + 1} ) ] \\text{} ( 0 \\le k \\le n - 1 )"
        asciimath = 'h a n n i n g ( k ) = 0 . 5 * [ 1 - cos ( 2 pi * frac(k + 1)(n + 1) ) ] "" ( 0 le k le n - 1 )'
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
                  <mrow>
                    <msubsup>
                      <msubsup>
                        <mo>&#x222b;</mo>
                      </msubsup>
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
                      <mo>(</mo>
                      <mi>t</mi>
                      <mo>)</mo>
                      <mi>d</mi>
                      <mi>t</mi>
                    </mrow>
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
  end
end
