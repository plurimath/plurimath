RSpec.describe Plurimath::Math do

  describe ".to_display(:asciimath)" do
    subject(:formula) { Plurimath::Math.parse(exp, :asciimath).to_display(:asciimath) }

    context "AsciiMath Math zone representation of sin and simple equation #1" do
      let(:exp) { "sum_3^1 sintheta" }

      it 'should puts Math zone representation of sample example #1' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "sum_(3)^(1) sintheta"
               |_ "sum_(3)^(1) sintheta" summation
                  |_ "3" subscript
                  |_ "1" supscript
                  |_ "sintheta" term
                     |_ "sintheta" function apply
                        |_ "sin" function name
                        |_ "theta" argument
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation of parentheses wrapped sin equation #2" do
      let(:exp) { "(a + 1 sin theta)" }

      it 'should puts Math zone representation of sample example #2' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "(a + 1 sintheta)"
               |_ "a + 1" text
               |_ "sintheta" function apply
                  |_ "sin" function name
                  |_ "theta" argument
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation example provided in github issue#113 #3" do
      let(:exp) { '1/(2pi) int_0^(2pi) (bbb"d" theta) / (a + b sin theta) = 1/sqrt(a^2−b^2)' }

      it 'should puts Math zone representation of sample example #3' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "frac(1)(2 pi) int_(0)^(2 pi) frac(mathbb("d") theta)(a + b sintheta) = frac(1)(sqrt(a^(2) − b^(2)))"
               |_ "frac(1)(2 pi)" fraction
               |  |_ "1" numerator
               |  |_ "2 pi" denominator
               |_ "int_(0)^(2 pi) frac(mathbb("d") theta)(a + b sintheta)" integral
               |  |_ "0" lower limit
               |  |_ "2 pi" upper limit
               |  |_ "frac(mathbb("d") theta)(a + b sintheta)" integrand
               |     |_ "frac(mathbb("d") theta)(a + b sintheta)" fraction
               |        |_ "mathbb("d") theta" numerator
               |        |  |_ "mathbb("d")" function apply
               |        |  |  |_ "bbb" font family
               |        |  |  |_ ""d"" argument
               |        |  |_ "&#x3b8;" text
               |        |_ "a + b sintheta" denominator
               |           |_ "a + b" text
               |           |_ "sintheta" function apply
               |              |_ "sin" function name
               |              |_ "theta" argument
               |_ "=" text
               |_ "frac(1)(sqrt(a^(2) − b^(2)))" fraction
                  |_ "1" numerator
                  |_ "sqrt(a^(2) − b^(2))" denominator
                     |_ "sqrt(a^(2) − b^(2))" function apply
                        |_ "sqrt" function name
                        |_ "a^(2) − b^(2)" argument
                           |_ "a^(2)" superscript
                           |  |_ "a" base
                           |  |_ "2" script
                           |_ "−" text
                           |_ "b^(2)" superscript
                              |_ "b" base
                              |_ "2" script
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation of cos function #4" do
      let(:exp) { 'cos(2)' }

      it 'should puts Math zone representation of sample example #4' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "cos(2)"
               |_ "cos(2)" function apply
                  |_ "cos" function name
                  |_ "(2)" argument
                     |_ "2" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation of power_base #5" do
      let(:exp) { 'cos(2)_(theta)^sigma cos(2)' }

      it 'should puts Math zone representation of sample example #5' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "cos(2)_(theta)^(sigma) cos(2)"
               |_ "cos(2)_(theta)^(sigma)" subsup
               |  |_ "cos(2)" base
               |  |  |_ "cos(2)" function apply
               |  |     |_ "cos" function name
               |  |     |_ "(2)" argument
               |  |        |_ "2" text
               |  |_ "theta" subscript
               |  |_ "sigma" supscript
               |_ "cos(2)" function apply
                  |_ "cos" function name
                  |_ "(2)" argument
                     |_ "2" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation of mod #6" do
      let(:exp) { 'cos(2) mod sigma' }

      it 'should puts Math zone representation of sample example #6' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "cos(2) mod sigma"
               |_ "cos(2) mod sigma" mod
                  |_ "cos(2)" base
                  |  |_ "cos(2)" function apply
                  |     |_ "cos" function name
                  |     |_ "(2)" argument
                  |        |_ "2" text
                  |_ "sigma" argument
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation of mod with multiple base values #7" do
      let(:exp) { '(cos(2) sin(3))mod sigma' }

      it 'should puts Math zone representation of sample example #7' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "(cos(2) sin(3)) mod sigma"
               |_ "(cos(2) sin(3)) mod sigma" mod
                  |_ "(cos(2) sin(3))" base
                  |  |_ "cos(2)" function apply
                  |  |  |_ "cos" function name
                  |  |  |_ "(2)" argument
                  |  |     |_ "2" text
                  |  |_ "sin(3)" function apply
                  |     |_ "sin" function name
                  |     |_ "(3)" argument
                  |        |_ "3" text
                  |_ "sigma" argument
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation of table #8" do
      let(:exp) { '[[sigma, gamma], [theta, alpha]]' }

      it 'should puts Math zone representation of sample example #8' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "[[sigma, gamma], [theta, alpha]]"
               |_ "table" function apply
                  |_ "tr" function apply
                  |  |_ "td" function apply
                  |  |  |_ "&#x3c3;" text
                  |  |_ "td" function apply
                  |     |_ "&#x3b3;" text
                  |_ "tr" function apply
                     |_ "td" function apply
                     |  |_ "&#x3b8;" text
                     |_ "td" function apply
                        |_ "&#x3b1;" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation of overset #9" do
      let(:exp) { 'overset(sigma)(theta)' }

      it 'should puts Math zone representation of sample example #9' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "overset(sigma)(theta)"
               |_ "overset(sigma)(theta)" overset
                  |_ "sigma" base
                  |_ "theta" supscript
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation of underset #10" do
      let(:exp) { 'underset(sigma)(theta)' }

      it 'should puts Math zone representation of sample example #10' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "underset(sigma)(theta)"
               |_ "underset(sigma)(theta)" underscript
                  |_ "sigma" underscript value
                  |_ "theta" base expression
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation of color #11" do
      let(:exp) { 'color(red)(theta)' }

      it 'should puts Math zone representation of sample example #11' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "color(red)(theta)"
               |_ "color(red)(theta)" color
                  |_ "r e d" mathcolor
                  |_ "theta" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation of four unary functions #12" do
      let(:exp) { 'abs(x)floor(x)ceil(x)norm(vecx)' }

      it 'should puts Math zone representation of sample example #12' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "abs(x) floor(x) ceil(x) norm(vec(x))"
               |_ "abs(x)" function apply
               |  |_ "abs" function name
               |  |_ "x" argument
               |_ "floor(x)" function apply
               |  |_ "floor" function name
               |  |_ "x" argument
               |_ "ceil(x)" function apply
               |  |_ "ceil" function name
               |  |_ "x" argument
               |_ "norm(vec(x))" function apply
                  |_ "norm" function name
                  |_ "vec(x)" argument
                     |_ "vec(x)" function apply
                        |_ "vec" function name
                        |_ "x" supscript
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation of font functions #13" do
      let(:exp) { 'mathbf(x)mathbb(x)mathcal(x)mathtt(x)mathfrak(x)mathsf(x)' }

      it 'should puts Math zone representation of sample example #13' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "mathbf(x) mathbb(x) mathcal(x) mathtt(x) mathfrak(x) mathsf(x)"
               |_ "mathbf(x)" function apply
               |  |_ "mathbf" font family
               |  |_ "x" argument
               |_ "mathbb(x)" function apply
               |  |_ "mathbb" font family
               |  |_ "x" argument
               |_ "mathcal(x)" function apply
               |  |_ "mathcal" font family
               |  |_ "x" argument
               |_ "mathtt(x)" function apply
               |  |_ "mathtt" font family
               |  |_ "x" argument
               |_ "mathfrak(x)" function apply
               |  |_ "mathfrak" font family
               |  |_ "x" argument
               |_ "mathsf(x)" function apply
                  |_ "mathsf" font family
                  |_ "x" argument
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end
  end

  describe ".to_display(:mathml)" do
    subject(:formula) { Plurimath::Math.parse(exp, :mathml).to_display(:mathml) }

    context "MathML Math zone representation of sin and simple equation #1" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mn>3</mn>
                  <mn>1</mn>
                </munderover>
                <mrow>
                  <mi>sin</mi>
                  <mi>&#x3b8;</mi>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #1' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><munderover><mo>&#x2211;</mo><mn>3</mn><mn>1</mn></munderover><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mstyle></math>"
               |_ "<mrow><munderover><mo>&#x2211;</mo><mn>3</mn><mn>1</mn></munderover><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow>" summation
                  |_ "<mn>3</mn>" subscript
                  |_ "<mn>1</mn>" supscript
                  |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" term
                     |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" function apply
                        |_ "sin" function name
                        |_ "<mi>&#x3b8;</mi>" argument
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "MathML Math zone representation of parentheses wrapped sin equation #2" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>(</mo>
                <mi>a</mi>
                <mo>+</mo>
                <mn>1</mn>
                <mrow>
                  <mi>sin</mi>
                  <mi>&#x3b8;</mi>
                </mrow>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #1' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mo>(</mo><mi>a</mi><mo>+</mo><mn>1</mn><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow><mo>)</mo></mrow></mstyle></math>"
               |_ "<mtext>a + 1</mtext>" text
               |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" function apply
                  |_ "sin" function name
                  |_ "<mi>&#x3b8;</mi>" argument
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "MathML Math zone representation example provided in github issue#113(AsciiMath to MathML converted) #3" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfrac>
                <mn>1</mn>
                <mrow>
                  <mn>2</mn>
                  <mi>&#x3c0;</mi>
                </mrow>
              </mfrac>
              <mrow>
                <msubsup>
                  <mo>&#x222b;</mo>
                  <mn>0</mn>
                  <mrow>
                    <mn>2</mn>
                    <mi>&#x3c0;</mi>
                  </mrow>
                </msubsup>
                <mfrac>
                  <mrow>
                    <mstyle mathvariant="double-struck">
                      <mtext>d</mtext>
                    </mstyle>
                    <mi>&#x3b8;</mi>
                  </mrow>
                  <mrow>
                    <mi>a</mi>
                    <mo>+</mo>
                    <mi>b</mi>
                    <mrow>
                      <mi>sin</mi>
                      <mi>&#x3b8;</mi>
                    </mrow>
                  </mrow>
                </mfrac>
              </mrow>
              <mo>=</mo>
              <mfrac>
                <mn>1</mn>
                <msqrt>
                  <mrow>
                    <msup>
                      <mi>a</mi>
                      <mn>2</mn>
                    </msup>
                    <mi>−</mi>
                    <msup>
                      <mi>b</mi>
                      <mn>2</mn>
                    </msup>
                  </mrow>
                </msqrt>
              </mfrac>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #1' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mfrac><mn>1</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></mfrac><mrow><msubsup><mo>&#x222b;</mo><mn>0</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></msubsup><mfrac><mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac></mrow><mo>=</mo><mfrac><mn>1</mn><msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt></mfrac></mrow></mstyle></math>"
               |_ "<mfrac><mn>1</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></mfrac>" fraction
               |  |_ "<mn>1</mn>" numerator
               |  |_ "<mrow><mn>2</mn><mi>&#x3c0;</mi></mrow>" denominator
               |_ "<mrow><msubsup><mo>&#x222b;</mo><mn>0</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></msubsup><mfrac><mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac></mrow>" integral
               |  |_ "<mn>0</mn>" lower limit
               |  |_ "<mrow><mn>2</mn><mi>&#x3c0;</mi></mrow>" upper limit
               |  |_ "<mfrac><mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac>" integrand
               |     |_ "<mfrac><mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac>" fraction
               |        |_ "<mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow>" numerator
               |        |  |_ "<mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle>" function apply
               |        |  |  |_ "double-struck" font family
               |        |  |  |_ "<mtext>d</mtext>" argument
               |        |  |_ "<mtext>&#x3b8;</mtext>" text
               |        |_ "<mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow>" denominator
               |          |_ "<mtext>a + b</mtext>" text
               |          |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" function apply
               |             |_ "sin" function name
               |             |_ "<mi>&#x3b8;</mi>" argument
               |_ "<mtext>=</mtext>" text
               |_ "<mfrac><mn>1</mn><msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt></mfrac>" fraction
                  |_ "<mn>1</mn>" numerator
                  |_ "<msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt>" denominator
                    |_ "<msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt>" function apply
                       |_ "sqrt" function name
                       |_ "<mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow>" argument
                          |_ "<msup><mi>a</mi><mn>2</mn></msup>" superscript
                          |  |_ "<mi>a</mi>" base
                          |  |_ "<mn>2</mn>" script
                          |_ "<mtext>&#x2212;</mtext>" text
                          |_ "<msup><mi>b</mi><mn>2</mn></msup>" superscript
                             |_ "<mi>b</mi>" base
                             |_ "<mn>2</mn>" script
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "MathML Math zone representation of cos function #4" do
      let(:exp) do
        <<~MATHZONE
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
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #4' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow></mstyle></math>"
               |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
                  |_ "cos" function name
                  |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
                     |_ "<mtext>2</mtext>" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "MathML Math zone representation of power_base #5" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mrow>
                  <mi>cos</mi>
                  <mrow>
                    <mo>(</mo>
                    <mn>2</mn>
                    <mo>)</mo>
                  </mrow>
                </mrow>
                <mi>&#x3b8;</mi>
                <mi>&#x3c3;</mi>
              </msubsup>
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
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #5' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><msubsup><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mi>&#x3b8;</mi><mi>&#x3c3;</mi></msubsup><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow></mrow></mstyle></math>"
               |_ "<msubsup><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mi>&#x3b8;</mi><mi>&#x3c3;</mi></msubsup>" subsup
               |  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" base
               |  |  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
               |  |     |_ "cos" function name
               |  |     |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
               |  |        |_ "<mtext>2</mtext>" text
               |  |_ "<mi>&#x3b8;</mi>" subscript
               |  |_ "<mi>&#x3c3;</mi>" supscript
               |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
                  |_ "cos" function name
                  |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
                     |_ "<mtext>2</mtext>" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "MathML Math zone representation of mod #6" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mrow>
                  <mi>cos</mi>
                  <mrow>
                    <mo>(</mo>
                    <mn>2</mn>
                    <mo>)</mo>
                  </mrow>
                </mrow>
                <mi>mod</mi>
                <mi>&#x3c3;</mi>
              </mrow>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #6' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow></mstyle></math>"
               |_ "<mrow><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow>" mod
                  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" base
                  |  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
                  |     |_ "cos" function name
                  |     |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
                  |        |_ "<mtext>2</mtext>" text
                  |_ "<mi>&#x3c3;</mi>" argument
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "MathML Math zone representation of mod with multiple base values #7" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mrow>
                  <mo>(</mo>
                  <mrow>
                    <mi>cos</mi>
                    <mrow>
                      <mo>(</mo>
                      <mn>2</mn>
                      <mo>)</mo>
                    </mrow>
                  </mrow>
                  <mrow>
                    <mi>sin</mi>
                    <mrow>
                      <mo>(</mo>
                      <mn>3</mn>
                      <mo>)</mo>
                    </mrow>
                  </mrow>
                  <mo>)</mo>
                </mrow>
                <mi>mod</mi>
                <mi>&#x3c3;</mi>
              </mrow>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #7' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mrow><mo>(</mo><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mrow><mi>sin</mi><mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow></mrow><mo>)</mo></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow></mstyle></math>"
               |_ "<mrow><mrow><mo>(</mo><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mrow><mi>sin</mi><mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow></mrow><mo>)</mo></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow>" mod
                  |_ "<mrow><mo>(</mo><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mrow><mi>sin</mi><mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow></mrow><mo>)</mo></mrow>" base
                  |  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
                  |  |  |_ "cos" function name
                  |  |  |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
                  |  |     |_ "<mtext>2</mtext>" text
                  |  |_ "<mrow><mi>sin</mi><mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow></mrow>" function apply
                  |     |_ "sin" function name
                  |     |_ "<mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow>" argument
                  |        |_ "<mtext>3</mtext>" text
                  |_ "<mi>&#x3c3;</mi>" argument
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "MathML Math zone representation of table #8" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>[</mo>
                <mtable>
                  <mtr>
                    <mtd>
                      <mi>&#x3c3;</mi>
                    </mtd>
                    <mtd>
                      <mi>&#x3b3;</mi>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mi>&#x3b8;</mi>
                    </mtd>
                    <mtd>
                      <mi>&#x3b1;</mi>
                    </mtd>
                  </mtr>
                </mtable>
                <mo>]</mo>
              </mrow>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #8' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mo>[</mo><mtable><mtr><mtd><mi>&#x3c3;</mi></mtd><mtd><mi>&#x3b3;</mi></mtd></mtr><mtr><mtd><mi>&#x3b8;</mi></mtd><mtd><mi>&#x3b1;</mi></mtd></mtr></mtable><mo>]</mo></mrow></mstyle></math>"
               |_ "table" function apply
                  |_ "tr" function apply
                  |  |_ "td" function apply
                  |  |  |_ "<mtext>&#x3c3;</mtext>" text
                  |  |_ "td" function apply
                  |     |_ "<mtext>&#x3b3;</mtext>" text
                  |_ "tr" function apply
                     |_ "td" function apply
                     |  |_ "<mtext>&#x3b8;</mtext>" text
                     |_ "td" function apply
                        |_ "<mtext>&#x3b1;</mtext>" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "MathML Math zone representation of overset #9" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mi>&#x3b8;</mi>
                <mi>&#x3c3;</mi>
              </mover>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #9' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mover><mi>&#x3b8;</mi><mi>&#x3c3;</mi></mover></mstyle></math>"
               |_ "<mover><mi>&#x3b8;</mi><mi>&#x3c3;</mi></mover>" overset
                  |_ "<mi>&#x3c3;</mi>" base
                  |_ "<mi>&#x3b8;</mi>" supscript
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "MathML Math zone representation of underset #10" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mi>&#x3b8;</mi>
                <mi>&#x3c3;</mi>
              </munder>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #10' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><munder><mi>&#x3b8;</mi><mi>&#x3c3;</mi></munder></mstyle></math>"
               |_ "<munder><mi>&#x3b8;</mi><mi>&#x3c3;</mi></munder>" underscript
                  |_ "<mi>&#x3c3;</mi>" underscript value
                  |_ "<mi>&#x3b8;</mi>" base expression
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation of color #11" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathcolor="red">
                <mi>&#x3b8;</mi>
              </mstyle>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #11' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mstyle mathcolor="red"><mi>&#x3b8;</mi></mstyle></mstyle></math>"
               |_ "<mstyle mathcolor="red"><mi>&#x3b8;</mi></mstyle>" color
                  |_ "<mtext>red</mtext>" mathcolor
                  |_ "<mi>&#x3b8;</mi>" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "AsciiMath Math zone representation of four unary functions #12" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>|</mo>
                <mi>x</mi>
                <mo>|</mo>
              </mrow>
              <mrow>
                <mo>&#x230a;</mo>
                <mi>x</mi>
                <mo>&#x230b;</mo>
              </mrow>
              <mrow>
                <mo>&#x2308;</mo>
                <mi>x</mi>
                <mo>&#x2309;</mo>
              </mrow>
              <mrow>
                <mo>&#x2225;</mo>
                <mover>
                  <mi>x</mi>
                  <mo>&#x2192;</mo>
                </mover>
                <mo>&#x2225;</mo>
              </mrow>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #12' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mrow><mo>|</mo><mi>x</mi><mo>|</mo></mrow><mrow><mo>&#x230a;</mo><mi>x</mi><mo>&#x230b;</mo></mrow><mrow><mo>&#x2308;</mo><mi>x</mi><mo>&#x2309;</mo></mrow><mrow><mi>&#x2225;</mi><mover><mi>x</mi><mo>&#x2192;</mo></mover><mi>&#x2225;</mi></mrow></mrow></mstyle></math>"
               |_ "<mtext>| x |</mtext>" text
               |_ "<mtext>x</mtext>" text
               |_ "<mtext>x</mtext>" text
               |_ "<mtext>&#x2225;</mtext>" text
               |_ "<mover><mi>x</mi><mo>&#x2192;</mo></mover>" overset
               |  |_ "<mo>&#x2192;</mo>" base
               |  |_ "<mi>x</mi>" supscript
               |_ "<mtext>&#x2225;</mtext>" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end
  end

  describe ".to_display(:OMML)" do
    subject(:formula) { Plurimath::Math.parse(exp, :omml).to_display(:omml) }

    context "OMML Math zone representation of sin and simple equation #1" do
      let(:exp) do
        <<~MATHZONE
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:nary>
                <m:naryPr>
                  <m:chr m:val="∑"/>
                  <m:limLoc m:val="undOvr"/>
                  <m:subHide m:val="0"/>
                  <m:supHide m:val="0"/>
                </m:naryPr>
                <m:sub>
                  <m:r>
                    <m:t>3</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>1</m:t>
                  </m:r>
                </m:sup>
                <m:e>
                  <m:func>
                    <m:funcPr>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:funcPr>
                    <m:fName>
                      <m:r>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                        </w:rPr>
                        <m:t>sin</m:t>
                      </m:r>
                    </m:fName>
                    <m:e>
                      <m:r>
                        <m:t>&#x3b8;</m:t>
                      </m:r>
                    </m:e>
                  </m:func>
                </m:e>
              </m:nary>
            </m:oMath>
          </m:oMathPara>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #1' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:nary><m:naryPr><m:chr m:val="∑"/><m:limLoc m:val="undOvr"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>3</m:t></m:r></m:sub><m:sup><m:r><m:t>1</m:t></m:r></m:sup><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:e></m:nary></m:oMath></m:oMathPara>"
               |_ "<m:nary><m:naryPr><m:chr m:val="∑"/><m:limLoc m:val="undOvr"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>3</m:t></m:r></m:sub><m:sup><m:r><m:t>1</m:t></m:r></m:sup><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:e></m:nary>" summation
                  |_ "<m:t>3</m:t>" subscript
                  |_ "<m:t>1</m:t>" supscript
                  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" term
                     |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" function apply
                        |_ "sin" function name
                        |_ "<m:t>&#x3b8;</m:t>" argument
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "OMML Math zone representation of parentheses wrapped sin equation #2" do
      let(:exp) do
        <<~MATHZONE
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="("/>
                  <m:endChr m:val=")"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>a</m:t>
                  </m:r>
                  <m:r>
                    <m:t>+</m:t>
                  </m:r>
                  <m:r>
                    <m:t>1</m:t>
                  </m:r>
                  <m:func>
                    <m:funcPr>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:funcPr>
                    <m:fName>
                      <m:r>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                        </w:rPr>
                        <m:t>sin</m:t>
                      </m:r>
                    </m:fName>
                    <m:e>
                      <m:r>
                        <m:t>&#x3b8;</m:t>
                      </m:r>
                    </m:e>
                  </m:func>
                </m:e>
              </m:d>
            </m:oMath>
          </m:oMathPara>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #1' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>1</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:e></m:d></m:oMath></m:oMathPara>"
               |_ "<m:t>a&#xa0;+&#xa0;1</m:t>" text
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" function apply
                  |_ "sin" function name
                  |_ "<m:t>&#x3b8;</m:t>" argument
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "OMML Math zone representation example provided in github issue#113(AsciiMath to OMML converted) #3" do
      let(:exp) do
        <<~MATHZONE
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
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
                    <m:t>1</m:t>
                  </m:r>
                </m:num>
                <m:den>
                  <m:r>
                    <m:t>2</m:t>
                  </m:r>
                  <m:r>
                    <m:t>&#x3c0;</m:t>
                  </m:r>
                </m:den>
              </m:f>
              <m:nary>
                <m:naryPr>
                  <m:chr m:val="∫"/>
                  <m:limLoc m:val="subSup"/>
                  <m:subHide m:val="0"/>
                  <m:supHide m:val="0"/>
                </m:naryPr>
                <m:sub>
                  <m:r>
                    <m:t>0</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>2</m:t>
                  </m:r>
                  <m:r>
                    <m:t>&#x3c0;</m:t>
                  </m:r>
                </m:sup>
                <m:e>
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
                        <m:rPr>
                          <m:scr m:val="double-struck"/>
                        </m:rPr>
                        <m:t>d</m:t>
                      </m:r>
                      <m:r>
                        <m:t>&#x3b8;</m:t>
                      </m:r>
                    </m:num>
                    <m:den>
                      <m:r>
                        <m:t>a</m:t>
                      </m:r>
                      <m:r>
                        <m:t>+</m:t>
                      </m:r>
                      <m:r>
                        <m:t>b</m:t>
                      </m:r>
                      <m:func>
                        <m:funcPr>
                          <m:ctrlPr>
                            <w:rPr>
                              <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                              <w:i/>
                            </w:rPr>
                          </m:ctrlPr>
                        </m:funcPr>
                        <m:fName>
                          <m:r>
                            <w:rPr>
                              <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                            </w:rPr>
                            <m:t>sin</m:t>
                          </m:r>
                        </m:fName>
                        <m:e>
                          <m:r>
                            <m:t>&#x3b8;</m:t>
                          </m:r>
                        </m:e>
                      </m:func>
                    </m:den>
                  </m:f>
                </m:e>
              </m:nary>
              <m:r>
                <m:t>=</m:t>
              </m:r>
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
                    <m:t>1</m:t>
                  </m:r>
                </m:num>
                <m:den>
                  <m:rad>
                    <m:radPr>
                      <m:degHide m:val="1"/>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:radPr>
                    <m:deg/>
                    <m:e>
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
                            <m:t>a</m:t>
                          </m:r>
                        </m:e>
                        <m:sup>
                          <m:r>
                            <m:t>2</m:t>
                          </m:r>
                        </m:sup>
                      </m:sSup>
                      <m:r>
                        <m:t>&#x2212;</m:t>
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
                            <m:t>b</m:t>
                          </m:r>
                        </m:e>
                        <m:sup>
                          <m:r>
                            <m:t>2</m:t>
                          </m:r>
                        </m:sup>
                      </m:sSup>
                    </m:e>
                  </m:rad>
                </m:den>
              </m:f>
            </m:oMath>
          </m:oMathPara>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #1' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:den></m:f><m:nary><m:naryPr><m:chr m:val="∫"/><m:limLoc m:val="subSup"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>0</m:t></m:r></m:sub><m:sup><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:sup><m:e><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f></m:e></m:nary><m:r><m:t>=</m:t></m:r><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad></m:den></m:f></m:oMath></m:oMathPara>"
               |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:den></m:f>" fraction
               |  |_ "<m:t>1</m:t>" numerator
               |  |_ "<m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r>" denominator
               |_ "<m:nary><m:naryPr><m:chr m:val="∫"/><m:limLoc m:val="subSup"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>0</m:t></m:r></m:sub><m:sup><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:sup><m:e><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f></m:e></m:nary>" integral
               |  |_ "<m:t>0</m:t>" lower limit
               |  |_ "<m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r>" upper limit
               |  |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f>" integrand
               |     |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f>" fraction
               |        |_ "<m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r>" numerator
               |        |  |_ "<m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r>" function apply
               |        |  |  |_ "double-struck" font family
               |        |  |  |_ "<m:t>d</m:t>" argument
               |        |  |_ "<m:t>&#x3b8;</m:t>" text
               |        |_ "<m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" denominator
               |          |_ "<m:t>a&#xa0;+&#xa0;b</m:t>" text
               |          |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" function apply
               |             |_ "sin" function name
               |             |_ "<m:t>&#x3b8;</m:t>" argument
               |_ "<m:t>=</m:t>" text
               |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad></m:den></m:f>" fraction
                  |_ "<m:t>1</m:t>" numerator
                  |_ "<m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad>" denominator
                    |_ "<m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad>" function apply
                       |_ "sqrt" function name
                       |_ "<m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup>" argument
                          |_ "<m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup>" superscript
                          |  |_ "<m:t>a</m:t>" base
                          |  |_ "<m:t>2</m:t>" script
                          |_ "<m:t>&#x2212;</m:t>" text
                          |_ "<m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup>" superscript
                             |_ "<m:t>b</m:t>" base
                             |_ "<m:t>2</m:t>" script
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "OMML Math zone representation of cos function #4" do
      let(:exp) do
        <<~MATHZONE
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:func>
                <m:funcPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:funcPr>
                <m:fName>
                  <m:r>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                    </w:rPr>
                    <m:t>cos</m:t>
                  </m:r>
                </m:fName>
                <m:e>
                  <m:d>
                    <m:dPr>
                      <m:begChr m:val="("/>
                      <m:endChr m:val=")"/>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:dPr>
                    <m:e>
                      <m:r>
                        <m:t>2</m:t>
                      </m:r>
                    </m:e>
                  </m:d>
                </m:e>
              </m:func>
            </m:oMath>
          </m:oMathPara>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #4' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func></m:oMath></m:oMathPara>"
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
                  |_ "cos" function name
                  |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
                     |_ "<m:t>2</m:t>" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "OMML Math zone representation of power_base #5" do
      let(:exp) do
        <<~MATHZONE
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
                  <m:func>
                    <m:funcPr>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:funcPr>
                    <m:fName>
                      <m:r>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                        </w:rPr>
                        <m:t>cos</m:t>
                      </m:r>
                    </m:fName>
                    <m:e>
                      <m:d>
                        <m:dPr>
                          <m:begChr m:val="("/>
                          <m:endChr m:val=")"/>
                          <m:ctrlPr>
                            <w:rPr>
                              <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                              <w:i/>
                            </w:rPr>
                          </m:ctrlPr>
                        </m:dPr>
                        <m:e>
                          <m:r>
                            <m:t>2</m:t>
                          </m:r>
                        </m:e>
                      </m:d>
                    </m:e>
                  </m:func>
                </m:e>
                <m:sub>
                  <m:r>
                    <m:t>&#x3b8;</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>&#x3c3;</m:t>
                  </m:r>
                </m:sup>
              </m:sSubSup>
              <m:func>
                <m:funcPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:funcPr>
                <m:fName>
                  <m:r>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                    </w:rPr>
                    <m:t>cos</m:t>
                  </m:r>
                </m:fName>
                <m:e>
                  <m:d>
                    <m:dPr>
                      <m:begChr m:val="("/>
                      <m:endChr m:val=")"/>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:dPr>
                    <m:e>
                      <m:r>
                        <m:t>2</m:t>
                      </m:r>
                    </m:e>
                  </m:d>
                </m:e>
              </m:func>
            </m:oMath>
          </m:oMathPara>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #5' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:sSubSup><m:sSubSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSubSupPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func></m:e><m:sub><m:r><m:t>&#x3b8;</m:t></m:r></m:sub><m:sup><m:r><m:t>&#x3c3;</m:t></m:r></m:sup></m:sSubSup><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func></m:oMath></m:oMathPara>"
               |_ "<m:sSubSup><m:sSubSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSubSupPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func></m:e><m:sub><m:r><m:t>&#x3b8;</m:t></m:r></m:sub><m:sup><m:r><m:t>&#x3c3;</m:t></m:r></m:sup></m:sSubSup>" subsup
               |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" base
               |  |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
               |  |     |_ "cos" function name
               |  |     |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
               |  |        |_ "<m:t>2</m:t>" text
               |  |_ "<m:t>&#x3b8;</m:t>" subscript
               |  |_ "<m:t>&#x3c3;</m:t>" supscript
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
                  |_ "cos" function name
                  |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
                     |_ "<m:t>2</m:t>" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "OMML Math zone representation of mod #6" do
      let(:exp) do
        <<~MATHZONE
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:func>
                <m:funcPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:funcPr>
                <m:fName>
                  <m:r>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                    </w:rPr>
                    <m:t>cos</m:t>
                  </m:r>
                </m:fName>
                <m:e>
                  <m:d>
                    <m:dPr>
                      <m:begChr m:val="("/>
                      <m:endChr m:val=")"/>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:dPr>
                    <m:e>
                      <m:r>
                        <m:t>2</m:t>
                      </m:r>
                    </m:e>
                  </m:d>
                </m:e>
              </m:func>
              <m:r>
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>mod</m:t>
              </m:r>
              <m:r>
                <m:t>&#x3c3;</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #6' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r></m:r><m:r><m:t>&#x3c3;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
               |  |_ "cos" function name
               |  |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
               |     |_ "<m:t>2</m:t>" text
               |_ "<m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r></m:r>" function apply
               |  |_ "normal" font family
               |  |_ "<m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r>" argument
               |  |  |_ "<m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r>" mod
               |_ "<m:t>&#x3c3;</m:t>" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "OMML Math zone representation of mod with multiple base values #7" do
      let(:exp) do
        <<~MATHZONE
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="("/>
                  <m:endChr m:val=")"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:dPr>
                <m:e>
                  <m:func>
                    <m:funcPr>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:funcPr>
                    <m:fName>
                      <m:r>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                        </w:rPr>
                        <m:t>cos</m:t>
                      </m:r>
                    </m:fName>
                    <m:e>
                      <m:d>
                        <m:dPr>
                          <m:begChr m:val="("/>
                          <m:endChr m:val=")"/>
                          <m:ctrlPr>
                            <w:rPr>
                              <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                              <w:i/>
                            </w:rPr>
                          </m:ctrlPr>
                        </m:dPr>
                        <m:e>
                          <m:r>
                            <m:t>2</m:t>
                          </m:r>
                        </m:e>
                      </m:d>
                    </m:e>
                  </m:func>
                  <m:func>
                    <m:funcPr>
                      <m:ctrlPr>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                          <w:i/>
                        </w:rPr>
                      </m:ctrlPr>
                    </m:funcPr>
                    <m:fName>
                      <m:r>
                        <w:rPr>
                          <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                        </w:rPr>
                        <m:t>sin</m:t>
                      </m:r>
                    </m:fName>
                    <m:e>
                      <m:d>
                        <m:dPr>
                          <m:begChr m:val="("/>
                          <m:endChr m:val=")"/>
                          <m:ctrlPr>
                            <w:rPr>
                              <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                              <w:i/>
                            </w:rPr>
                          </m:ctrlPr>
                        </m:dPr>
                        <m:e>
                          <m:r>
                            <m:t>3</m:t>
                          </m:r>
                        </m:e>
                      </m:d>
                    </m:e>
                  </m:func>
                </m:e>
              </m:d>
              <m:r>
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>mod</m:t>
              </m:r>
              <m:r>
                <m:t>&#x3c3;</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #7' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>3</m:t></m:r></m:e></m:d></m:e></m:func></m:e></m:d><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r></m:r><m:r><m:t>&#x3c3;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
               |  |_ "cos" function name
               |  |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
               |     |_ "<m:t>2</m:t>" text
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>3</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
               |  |_ "sin" function name
               |  |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>3</m:t></m:r></m:e></m:d>" argument
               |     |_ "<m:t>3</m:t>" text
               |_ "<m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r></m:r>" function apply
               |  |_ "normal" font family
               |  |_ "<m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r>" argument
               |  |  |_ "<m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r>" mod
               |_ "<m:t>&#x3c3;</m:t>" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "OMML Math zone representation of table #8" do
      let(:exp) do
        <<~MATHZONE
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
                            <m:count m:val="2"/>
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
                          <m:t>&#x3c3;</m:t>
                        </m:r>
                      </m:e>
                      <m:e>
                        <m:r>
                          <m:t>&#x3b3;</m:t>
                        </m:r>
                      </m:e>
                    </m:mr>
                    <m:mr>
                      <m:e>
                        <m:r>
                          <m:t>&#x3b8;</m:t>
                        </m:r>
                      </m:e>
                      <m:e>
                        <m:r>
                          <m:t>&#x3b1;</m:t>
                        </m:r>
                      </m:e>
                    </m:mr>
                  </m:m>
                </m:e>
              </m:d>
            </m:oMath>
          </m:oMathPara>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #8' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:d><m:dPr><m:begChr m:val="["/><m:endChr m:val="]"/><m:sepChr m:val=""/><m:grow/></m:dPr><m:e><m:m><m:mPr><m:mcs><m:mc><m:mcPr><m:count m:val="2"/><m:mcJc m:val="center"/></m:mcPr></m:mc></m:mcs><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:mPr><m:mr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:e><m:r><m:t>&#x3b3;</m:t></m:r></m:e></m:mr><m:mr><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e><m:e><m:r><m:t>&#x3b1;</m:t></m:r></m:e></m:mr></m:m></m:e></m:d></m:oMath></m:oMathPara>"
               |_ "table" function apply
                  |_ "tr" function apply
                  |  |_ "td" function apply
                  |  |  |_ "<m:t>&#x3c3;</m:t>" text
                  |  |_ "td" function apply
                  |     |_ "<m:t>&#x3b3;</m:t>" text
                  |_ "tr" function apply
                     |_ "td" function apply
                     |  |_ "<m:t>&#x3b8;</m:t>" text
                     |_ "td" function apply
                        |_ "<m:t>&#x3b1;</m:t>" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "OMML Math zone representation of overset #9" do
      let(:exp) do
        <<~MATHZONE
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
                    <m:t>&#x3c3;</m:t>
                  </m:r>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>&#x3b8;</m:t>
                  </m:r>
                </m:lim>
              </m:limUpp>
            </m:oMath>
          </m:oMathPara>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #9' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limUpp></m:oMath></m:oMathPara>"
               |_ "<m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limUpp>" overset
                  |_ "<m:t>&#x3c3;</m:t>" base
                  |_ "<m:t>&#x3b8;</m:t>" supscript
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "OMML Math zone representation of underset #10" do
      let(:exp) do
        <<~MATHZONE
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
                    <m:t>&#x3c3;</m:t>
                  </m:r>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>&#x3b8;</m:t>
                  </m:r>
                </m:lim>
              </m:limLow>
            </m:oMath>
          </m:oMathPara>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #10' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:limLow><m:limLowPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limLowPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limLow></m:oMath></m:oMathPara>"
               |_ "<m:limLow><m:limLowPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limLowPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limLow>" underscript
                  |_ "<m:t>&#x3c3;</m:t>" underscript value
                  |_ "<m:t>&#x3b8;</m:t>" base expression
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "OMML Math zone representation of color #11" do
      let(:exp) do
        <<~MATHZONE
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:r>
                <m:t>&#x3b8;</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #11' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:r><m:t>&#x3b8;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:t>&#x3b8;</m:t>" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end

    context "OMML Math zone representation of four unary functions #12" do
      let(:exp) do
        <<~MATHZONE
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:r>
                <m:t>|</m:t>
              </m:r>
              <m:r>
                <m:t>x</m:t>
              </m:r>
              <m:r>
                <m:t>|</m:t>
              </m:r>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="&#x230a;"/>
                  <m:endChr m:val="&#x230b;"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>x</m:t>
                  </m:r>
                </m:e>
              </m:d>
              <m:d>
                <m:dPr>
                  <m:begChr m:val="&#x2308;"/>
                  <m:endChr m:val="&#x2309;"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:dPr>
                <m:e>
                  <m:r>
                    <m:t>x</m:t>
                  </m:r>
                </m:e>
              </m:d>
              <m:r>
                <m:t>&#x2225;</m:t>
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
                    <m:t>x</m:t>
                  </m:r>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>→</m:t>
                  </m:r>
                </m:lim>
              </m:limUpp>
              <m:r>
                <m:t>&#x2225;</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #12' do
        expected_value = <<~MATHZONE
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:r><m:t>|</m:t></m:r><m:r><m:t>x</m:t></m:r><m:r><m:t>|</m:t></m:r><m:d><m:dPr><m:begChr m:val="⌊"/><m:sepChr m:val=""/><m:endChr m:val="⌋"/></m:dPr><m:e><m:r><m:t>x</m:t></m:r></m:e></m:d><m:d><m:dPr><m:begChr m:val="⌈"/><m:sepChr m:val=""/><m:endChr m:val="⌉"/></m:dPr><m:e><m:r><m:t>x</m:t></m:r></m:e></m:d><m:r><m:t>&#x2225;</m:t></m:r><m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>x</m:t></m:r></m:e><m:lim><m:r><m:t>→</m:t></m:r></m:lim></m:limUpp><m:r><m:t>&#x2225;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:t>|&#xa0;x&#xa0;|</m:t>" text
               |_ "<m:t>x</m:t>" text
               |_ "<m:t>x</m:t>" text
               |_ "<m:t>&#x2225;</m:t>" text
               |_ "<m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>x</m:t></m:r></m:e><m:lim><m:r><m:t>→</m:t></m:r></m:lim></m:limUpp>" overset
               |  |_ "<m:t>&#x2192;</m:t>" base
               |  |_ "<m:t>x</m:t>" supscript
               |_ "<m:t>&#x2225;</m:t>" text
        MATHZONE
        expect(formula).to eql(expected_value)
      end
    end
  end

  describe "AsciiMath input to all to_display(:lang) conversions" do
    subject(:formula) { Plurimath::Math.parse(exp, :asciimath) }

    context "AsciiMath Math zone representation of sin and simple equation #1" do
      let(:exp) { "sum_3^1 sintheta" }

      it 'should puts Math zone representation of sample example #1' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:nary><m:naryPr><m:chr m:val="∑"/><m:limLoc m:val="undOvr"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>3</m:t></m:r></m:sub><m:sup><m:r><m:t>1</m:t></m:r></m:sup><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:e></m:nary></m:oMath></m:oMathPara>"
               |_ "<m:nary><m:naryPr><m:chr m:val="∑"/><m:limLoc m:val="undOvr"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>3</m:t></m:r></m:sub><m:sup><m:r><m:t>1</m:t></m:r></m:sup><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:e></m:nary>" summation
                  |_ "<m:t>3</m:t>" subscript
                  |_ "<m:t>1</m:t>" supscript
                  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" term
                     |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" function apply
                        |_ "sin" function name
                        |_ "<m:t>&#x3b8;</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\sum_{3}^{1} \\sin{\\theta}"
               |_ "\\sum_{3}^{1} \\sin{\\theta}" summation
                  |_ "3" subscript
                  |_ "1" supscript
                  |_ "\\sin{\\theta}" term
                     |_ "\\sin{\\theta}" function apply
                        |_ "sin" function name
                        |_ "\\theta" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><munderover><mo>&#x2211;</mo><mn>3</mn><mn>1</mn></munderover><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mstyle></math>"
               |_ "<mrow><munderover><mo>&#x2211;</mo><mn>3</mn><mn>1</mn></munderover><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow>" summation
                  |_ "<mn>3</mn>" subscript
                  |_ "<mn>1</mn>" supscript
                  |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" term
                     |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" function apply
                        |_ "sin" function name
                        |_ "<mi>&#x3b8;</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "sum_(3)^(1) sintheta"
               |_ "sum_(3)^(1) sintheta" summation
                  |_ "3" subscript
                  |_ "1" supscript
                  |_ "sintheta" term
                     |_ "sintheta" function apply
                        |_ "sin" function name
                        |_ "theta" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation of parentheses wrapped sin equation #2" do
      let(:exp) { "(a + 1 sin theta)" }

      it 'should puts Math zone representation of sample example #2' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>1</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:e></m:d></m:oMath></m:oMathPara>"
               |_ "<m:t>a&#xa0;+&#xa0;1</m:t>" text
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" function apply
                  |_ "sin" function name
                  |_ "<m:t>&#x3b8;</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "( a + 1 \\sin{\\theta} )"
               |_ "a + 1" text
               |_ "\\sin{\\theta}" function apply
                  |_ "sin" function name
                  |_ "\\theta" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mo>(</mo><mi>a</mi><mo>+</mo><mn>1</mn><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow><mo>)</mo></mrow></mstyle></math>"
               |_ "<mtext>a + 1</mtext>" text
               |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" function apply
                  |_ "sin" function name
                  |_ "<mi>&#x3b8;</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "(a + 1 sintheta)"
               |_ "a + 1" text
               |_ "sintheta" function apply
                  |_ "sin" function name
                  |_ "theta" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation example provided in github issue#113 #3" do
      let(:exp) { '1/(2pi) int_0^(2pi) (bbb"d" theta) / (a + b sin theta) = 1/sqrt(a^2−b^2)' }

      it 'should puts Math zone representation of sample example #3' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:den></m:f><m:nary><m:naryPr><m:chr m:val="∫"/><m:limLoc m:val="subSup"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>0</m:t></m:r></m:sub><m:sup><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:sup><m:e><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f></m:e></m:nary><m:r><m:t>=</m:t></m:r><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>−</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad></m:den></m:f></m:oMath></m:oMathPara>"
               |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:den></m:f>" fraction
               |  |_ "<m:t>1</m:t>" numerator
               |  |_ "<m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r>" denominator
               |_ "<m:nary><m:naryPr><m:chr m:val="∫"/><m:limLoc m:val="subSup"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>0</m:t></m:r></m:sub><m:sup><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:sup><m:e><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f></m:e></m:nary>" integral
               |  |_ "<m:t>0</m:t>" lower limit
               |  |_ "<m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r>" upper limit
               |  |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f>" integrand
               |     |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f>" fraction
               |        |_ "<m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r>" numerator
               |        |  |_ "<m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r>" function apply
               |        |  |  |_ "double-struck" font family
               |        |  |  |_ "<m:t>d</m:t>" argument
               |        |  |_ "<m:t>&#x3b8;</m:t>" text
               |        |_ "<m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" denominator
               |          |_ "<m:t>a&#xa0;+&#xa0;b</m:t>" text
               |          |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" function apply
               |             |_ "sin" function name
               |             |_ "<m:t>&#x3b8;</m:t>" argument
               |_ "<m:t>=</m:t>" text
               |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>−</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad></m:den></m:f>" fraction
                  |_ "<m:t>1</m:t>" numerator
                  |_ "<m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>−</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad>" denominator
                    |_ "<m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>−</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad>" function apply
                       |_ "sqrt" function name
                       |_ "<m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>−</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup>" argument
                          |_ "<m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup>" superscript
                          |  |_ "<m:t>a</m:t>" base
                          |  |_ "<m:t>2</m:t>" script
                          |_ "<m:t>&#x2212;</m:t>" text
                          |_ "<m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup>" superscript
                             |_ "<m:t>b</m:t>" base
                             |_ "<m:t>2</m:t>" script
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\frac{1}{2 \\pi} \\int_{0}^{2 \\pi} \\frac{\\mathbb{\\text{d}} \\theta}{a + b \\sin{\\theta}} = \\frac{1}{\\sqrt{a^{2} − b^{2}}}"
               |_ "\\frac{1}{2 \\pi}" fraction
               |  |_ "1" numerator
               |  |_ "2 \\pi" denominator
               |_ "\\int_{0}^{2 \\pi} \\frac{\\mathbb{\\text{d}} \\theta}{a + b \\sin{\\theta}}" integral
               |  |_ "0" lower limit
               |  |_ "2 \\pi" upper limit
               |  |_ "\\frac{\\mathbb{\\text{d}} \\theta}{a + b \\sin{\\theta}}" integrand
               |     |_ "\\frac{\\mathbb{\\text{d}} \\theta}{a + b \\sin{\\theta}}" fraction
               |        |_ "\\mathbb{\\text{d}} \\theta" numerator
               |        |  |_ "\\mathbb{\\text{d}}" function apply
               |        |  |  |_ "bbb" font family
               |        |  |  |_ "\\text{d}" argument
               |        |  |_ "&#x3b8;" text
               |        |_ "a + b \\sin{\\theta}" denominator
               |           |_ "a + b" text
               |           |_ "\\sin{\\theta}" function apply
               |              |_ "sin" function name
               |              |_ "\\theta" argument
               |_ "=" text
               |_ "\\frac{1}{\\sqrt{a^{2} − b^{2}}}" fraction
                  |_ "1" numerator
                  |_ "\\sqrt{a^{2} − b^{2}}" denominator
                     |_ "\\sqrt{a^{2} − b^{2}}" function apply
                        |_ "sqrt" function name
                        |_ "a^{2} − b^{2}" argument
                           |_ "a^{2}" superscript
                           |  |_ "a" base
                           |  |_ "2" script
                           |_ "−" text
                           |_ "b^{2}" superscript
                              |_ "b" base
                              |_ "2" script
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mfrac><mn>1</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></mfrac><mrow><msubsup><mo>&#x222b;</mo><mn>0</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></msubsup><mfrac><mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac></mrow><mo>=</mo><mfrac><mn>1</mn><msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mi>−</mi><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt></mfrac></mstyle></math>"
               |_ "<mfrac><mn>1</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></mfrac>" fraction
               |  |_ "<mn>1</mn>" numerator
               |  |_ "<mrow><mn>2</mn><mi>&#x3c0;</mi></mrow>" denominator
               |_ "<mrow><msubsup><mo>&#x222b;</mo><mn>0</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></msubsup><mfrac><mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac></mrow>" integral
               |  |_ "<mn>0</mn>" lower limit
               |  |_ "<mrow><mn>2</mn><mi>&#x3c0;</mi></mrow>" upper limit
               |  |_ "<mfrac><mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac>" integrand
               |     |_ "<mfrac><mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac>" fraction
               |        |_ "<mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow>" numerator
               |        |  |_ "<mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle>" function apply
               |        |  |  |_ "double-struck" font family
               |        |  |  |_ "<mtext>d</mtext>" argument
               |        |  |_ "<mtext>&#x3b8;</mtext>" text
               |        |_ "<mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow>" denominator
               |          |_ "<mtext>a + b</mtext>" text
               |          |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" function apply
               |             |_ "sin" function name
               |             |_ "<mi>&#x3b8;</mi>" argument
               |_ "<mtext>=</mtext>" text
               |_ "<mfrac><mn>1</mn><msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mi>−</mi><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt></mfrac>" fraction
                  |_ "<mn>1</mn>" numerator
                  |_ "<msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mi>−</mi><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt>" denominator
                    |_ "<msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mi>−</mi><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt>" function apply
                       |_ "sqrt" function name
                       |_ "<mrow><msup><mi>a</mi><mn>2</mn></msup><mi>−</mi><msup><mi>b</mi><mn>2</mn></msup></mrow>" argument
                          |_ "<msup><mi>a</mi><mn>2</mn></msup>" superscript
                          |  |_ "<mi>a</mi>" base
                          |  |_ "<mn>2</mn>" script
                          |_ "<mtext>−</mtext>" text
                          |_ "<msup><mi>b</mi><mn>2</mn></msup>" superscript
                             |_ "<mi>b</mi>" base
                             |_ "<mn>2</mn>" script
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "frac(1)(2 pi) int_(0)^(2 pi) frac(mathbb("d") theta)(a + b sintheta) = frac(1)(sqrt(a^(2) − b^(2)))"
               |_ "frac(1)(2 pi)" fraction
               |  |_ "1" numerator
               |  |_ "2 pi" denominator
               |_ "int_(0)^(2 pi) frac(mathbb("d") theta)(a + b sintheta)" integral
               |  |_ "0" lower limit
               |  |_ "2 pi" upper limit
               |  |_ "frac(mathbb("d") theta)(a + b sintheta)" integrand
               |     |_ "frac(mathbb("d") theta)(a + b sintheta)" fraction
               |        |_ "mathbb("d") theta" numerator
               |        |  |_ "mathbb("d")" function apply
               |        |  |  |_ "bbb" font family
               |        |  |  |_ ""d"" argument
               |        |  |_ "&#x3b8;" text
               |        |_ "a + b sintheta" denominator
               |           |_ "a + b" text
               |           |_ "sintheta" function apply
               |              |_ "sin" function name
               |              |_ "theta" argument
               |_ "=" text
               |_ "frac(1)(sqrt(a^(2) − b^(2)))" fraction
                  |_ "1" numerator
                  |_ "sqrt(a^(2) − b^(2))" denominator
                     |_ "sqrt(a^(2) − b^(2))" function apply
                        |_ "sqrt" function name
                        |_ "a^(2) − b^(2)" argument
                           |_ "a^(2)" superscript
                           |  |_ "a" base
                           |  |_ "2" script
                           |_ "−" text
                           |_ "b^(2)" superscript
                              |_ "b" base
                              |_ "2" script
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation of cos function #4" do
      let(:exp) { 'cos(2)' }

      it 'should puts Math zone representation of sample example #4' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func></m:oMath></m:oMathPara>"
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
                  |_ "cos" function name
                  |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
                     |_ "<m:t>2</m:t>" text
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\cos{( 2 )}"
               |_ "\\cos{( 2 )}" function apply
                  |_ "cos" function name
                  |_ "( 2 )" argument
                     |_ "2" text
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow></mstyle></math>"
               |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
                  |_ "cos" function name
                  |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
                     |_ "<mtext>2</mtext>" text
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "cos(2)"
               |_ "cos(2)" function apply
                  |_ "cos" function name
                  |_ "(2)" argument
                     |_ "2" text
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation of power_base #5" do
      let(:exp) { 'cos(2)_(theta)^sigma cos(2)' }

      it 'should puts Math zone representation of sample example #5' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:sSubSup><m:sSubSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSubSupPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func></m:e><m:sub><m:r><m:t>&#x3b8;</m:t></m:r></m:sub><m:sup><m:r><m:t>&#x3c3;</m:t></m:r></m:sup></m:sSubSup><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func></m:oMath></m:oMathPara>"
               |_ "<m:sSubSup><m:sSubSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSubSupPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func></m:e><m:sub><m:r><m:t>&#x3b8;</m:t></m:r></m:sub><m:sup><m:r><m:t>&#x3c3;</m:t></m:r></m:sup></m:sSubSup>" subsup
               |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" base
               |  |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
               |  |     |_ "cos" function name
               |  |     |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
               |  |        |_ "<m:t>2</m:t>" text
               |  |_ "<m:t>&#x3b8;</m:t>" subscript
               |  |_ "<m:t>&#x3c3;</m:t>" supscript
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
                  |_ "cos" function name
                  |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
                     |_ "<m:t>2</m:t>" text
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\cos{( 2 )}_{\\theta}^{\\sigma} \\cos{( 2 )}"
               |_ "\\cos{( 2 )}_{\\theta}^{\\sigma}" subsup
               |  |_ "\\cos{( 2 )}" base
               |  |  |_ "\\cos{( 2 )}" function apply
               |  |     |_ "cos" function name
               |  |     |_ "( 2 )" argument
               |  |        |_ "2" text
               |  |_ "\\theta" subscript
               |  |_ "\\sigma" supscript
               |_ "\\cos{( 2 )}" function apply
                  |_ "cos" function name
                  |_ "( 2 )" argument
                     |_ "2" text
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><msubsup><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mi>&#x3b8;</mi><mi>&#x3c3;</mi></msubsup><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow></mstyle></math>"
               |_ "<msubsup><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mi>&#x3b8;</mi><mi>&#x3c3;</mi></msubsup>" subsup
               |  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" base
               |  |  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
               |  |     |_ "cos" function name
               |  |     |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
               |  |        |_ "<mtext>2</mtext>" text
               |  |_ "<mi>&#x3b8;</mi>" subscript
               |  |_ "<mi>&#x3c3;</mi>" supscript
               |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
                  |_ "cos" function name
                  |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
                     |_ "<mtext>2</mtext>" text
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "cos(2)_(theta)^(sigma) cos(2)"
               |_ "cos(2)_(theta)^(sigma)" subsup
               |  |_ "cos(2)" base
               |  |  |_ "cos(2)" function apply
               |  |     |_ "cos" function name
               |  |     |_ "(2)" argument
               |  |        |_ "2" text
               |  |_ "theta" subscript
               |  |_ "sigma" supscript
               |_ "cos(2)" function apply
                  |_ "cos" function name
                  |_ "(2)" argument
                     |_ "2" text
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation of mod #6" do
      let(:exp) { 'cos(2) mod sigma' }

      it 'should puts Math zone representation of sample example #6' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r><m:r><m:t>&#x3c3;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r><m:r><m:t>&#x3c3;</m:t></m:r>" mod
                  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" base
                  |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
                  |     |_ "cos" function name
                  |     |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
                  |        |_ "<m:t>2</m:t>" text
                  |_ "<m:t>&#x3c3;</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "{\\cos{( 2 )}} \\mod {\\sigma}"
               |_ "{\\cos{( 2 )}} \\mod {\\sigma}" mod
                  |_ "\\cos{( 2 )}" base
                  |  |_ "\\cos{( 2 )}" function apply
                  |     |_ "cos" function name
                  |     |_ "( 2 )" argument
                  |        |_ "2" text
                  |_ "\\sigma" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow></mstyle></math>"
               |_ "<mrow><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow>" mod
                  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" base
                  |  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
                  |     |_ "cos" function name
                  |     |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
                  |        |_ "<mtext>2</mtext>" text
                  |_ "<mi>&#x3c3;</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "cos(2) mod sigma"
               |_ "cos(2) mod sigma" mod
                  |_ "cos(2)" base
                  |  |_ "cos(2)" function apply
                  |     |_ "cos" function name
                  |     |_ "(2)" argument
                  |        |_ "2" text
                  |_ "sigma" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation of mod with multiple base values #7" do
      let(:exp) { '(cos(2) sin(3))mod sigma' }

      it 'should puts Math zone representation of sample example #7' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>3</m:t></m:r></m:e></m:d></m:e></m:func></m:e></m:d><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r><m:r><m:t>&#x3c3;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>3</m:t></m:r></m:e></m:d></m:e></m:func></m:e></m:d><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r><m:r><m:t>&#x3c3;</m:t></m:r>" mod
                  |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>3</m:t></m:r></m:e></m:d></m:e></m:func></m:e></m:d>" base
                  |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
                  |     |_ "cos" function name
                  |     |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
                  |        |_ "<m:t>2</m:t>" text
                  |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>3</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
                  |     |_ "sin" function name
                  |     |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>3</m:t></m:r></m:e></m:d>" argument
                  |        |_ "<m:t>3</m:t>" text
                  |_ "<m:t>&#x3c3;</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "{( \\cos{( 2 )} \\sin{( 3 )} )} \\mod {\\sigma}"
               |_ "{( \\cos{( 2 )} \\sin{( 3 )} )} \\mod {\\sigma}" mod
                  |_ "( \\cos{( 2 )} \\sin{( 3 )} )" base
                  |  |_ "\\cos{( 2 )}" function apply
                  |  |  |_ "cos" function name
                  |  |  |_ "( 2 )" argument
                  |  |     |_ "2" text
                  |  |_ "\\sin{( 3 )}" function apply
                  |     |_ "sin" function name
                  |     |_ "( 3 )" argument
                  |        |_ "3" text
                  |_ "\\sigma" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mrow><mo>(</mo><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mrow><mi>sin</mi><mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow></mrow><mo>)</mo></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow></mstyle></math>"
               |_ "<mrow><mrow><mo>(</mo><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mrow><mi>sin</mi><mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow></mrow><mo>)</mo></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow>" mod
                  |_ "<mrow><mo>(</mo><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mrow><mi>sin</mi><mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow></mrow><mo>)</mo></mrow>" base
                  |  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
                  |  |  |_ "cos" function name
                  |  |  |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
                  |  |     |_ "<mtext>2</mtext>" text
                  |  |_ "<mrow><mi>sin</mi><mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow></mrow>" function apply
                  |     |_ "sin" function name
                  |     |_ "<mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow>" argument
                  |        |_ "<mtext>3</mtext>" text
                  |_ "<mi>&#x3c3;</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "(cos(2) sin(3)) mod sigma"
               |_ "(cos(2) sin(3)) mod sigma" mod
                  |_ "(cos(2) sin(3))" base
                  |  |_ "cos(2)" function apply
                  |  |  |_ "cos" function name
                  |  |  |_ "(2)" argument
                  |  |     |_ "2" text
                  |  |_ "sin(3)" function apply
                  |     |_ "sin" function name
                  |     |_ "(3)" argument
                  |        |_ "3" text
                  |_ "sigma" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation of table #8" do
      let(:exp) { '[[sigma, gamma], [theta, alpha]]' }

      it 'should puts Math zone representation of sample example #8' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:d><m:dPr><m:begChr m:val="["/><m:endChr m:val="]"/><m:sepChr m:val=""/><m:grow/></m:dPr><m:e><m:m><m:mPr><m:mcs><m:mc><m:mcPr><m:count m:val="2"/><m:mcJc m:val="center"/></m:mcPr></m:mc></m:mcs><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:mPr><m:mr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:e><m:r><m:t>&#x3b3;</m:t></m:r></m:e></m:mr><m:mr><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e><m:e><m:r><m:t>&#x3b1;</m:t></m:r></m:e></m:mr></m:m></m:e></m:d></m:oMath></m:oMathPara>"
               |_ "table" function apply
                  |_ "tr" function apply
                  |  |_ "td" function apply
                  |  |  |_ "<m:t>&#x3c3;</m:t>" text
                  |  |_ "td" function apply
                  |     |_ "<m:t>&#x3b3;</m:t>" text
                  |_ "tr" function apply
                     |_ "td" function apply
                     |  |_ "<m:t>&#x3b8;</m:t>" text
                     |_ "td" function apply
                        |_ "<m:t>&#x3b1;</m:t>" text
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\left [\\begin{matrix}\\sigma & \\gamma \\\\ \\theta & \\alpha\\end{matrix}\\right ]"
               |_ "table" function apply
                  |_ "tr" function apply
                  |  |_ "td" function apply
                  |  |  |_ "&#x3c3;" text
                  |  |_ "td" function apply
                  |     |_ "&#x3b3;" text
                  |_ "tr" function apply
                     |_ "td" function apply
                     |  |_ "&#x3b8;" text
                     |_ "td" function apply
                        |_ "&#x3b1;" text
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mo>[</mo><mtable><mtr><mtd><mi>&#x3c3;</mi></mtd><mtd><mi>&#x3b3;</mi></mtd></mtr><mtr><mtd><mi>&#x3b8;</mi></mtd><mtd><mi>&#x3b1;</mi></mtd></mtr></mtable><mo>]</mo></mrow></mstyle></math>"
               |_ "table" function apply
                  |_ "tr" function apply
                  |  |_ "td" function apply
                  |  |  |_ "<mtext>&#x3c3;</mtext>" text
                  |  |_ "td" function apply
                  |     |_ "<mtext>&#x3b3;</mtext>" text
                  |_ "tr" function apply
                     |_ "td" function apply
                     |  |_ "<mtext>&#x3b8;</mtext>" text
                     |_ "td" function apply
                        |_ "<mtext>&#x3b1;</mtext>" text
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "[[sigma, gamma], [theta, alpha]]"
               |_ "table" function apply
                  |_ "tr" function apply
                  |  |_ "td" function apply
                  |  |  |_ "&#x3c3;" text
                  |  |_ "td" function apply
                  |     |_ "&#x3b3;" text
                  |_ "tr" function apply
                     |_ "td" function apply
                     |  |_ "&#x3b8;" text
                     |_ "td" function apply
                        |_ "&#x3b1;" text
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation of overset #9" do
      let(:exp) { 'overset(sigma)(theta)' }

      it 'should puts Math zone representation of sample example #9' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limUpp></m:oMath></m:oMathPara>"
               |_ "<m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limUpp>" overset
                  |_ "<m:t>&#x3c3;</m:t>" base
                  |_ "<m:t>&#x3b8;</m:t>" supscript
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\overset{\\sigma}{\\theta}"
               |_ "\\overset{\\sigma}{\\theta}" overset
                  |_ "\\sigma" base
                  |_ "\\theta" supscript
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mover><mi>&#x3b8;</mi><mi>&#x3c3;</mi></mover></mstyle></math>"
               |_ "<mover><mi>&#x3b8;</mi><mi>&#x3c3;</mi></mover>" overset
                  |_ "<mi>&#x3c3;</mi>" base
                  |_ "<mi>&#x3b8;</mi>" supscript
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "overset(sigma)(theta)"
               |_ "overset(sigma)(theta)" overset
                  |_ "sigma" base
                  |_ "theta" supscript
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation of underset #10" do
      let(:exp) { 'underset(sigma)(theta)' }

      it 'should puts Math zone representation of sample example #10' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:limLow><m:limLowPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limLowPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limLow></m:oMath></m:oMathPara>"
               |_ "<m:limLow><m:limLowPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limLowPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limLow>" underscript
                  |_ "<m:t>&#x3c3;</m:t>" underscript value
                  |_ "<m:t>&#x3b8;</m:t>" base expression
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\underset{\\sigma}{\\theta}"
               |_ "\\underset{\\sigma}{\\theta}" underscript
                  |_ "\\sigma" underscript value
                  |_ "\\theta" base expression
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><munder><mi>&#x3b8;</mi><mi>&#x3c3;</mi></munder></mstyle></math>"
               |_ "<munder><mi>&#x3b8;</mi><mi>&#x3c3;</mi></munder>" underscript
                  |_ "<mi>&#x3c3;</mi>" underscript value
                  |_ "<mi>&#x3b8;</mi>" base expression
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "underset(sigma)(theta)"
               |_ "underset(sigma)(theta)" underscript
                  |_ "sigma" underscript value
                  |_ "theta" base expression
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation of color #11" do
      let(:exp) { 'color(red)(theta)' }

      it 'should puts Math zone representation of sample example #11' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:r><m:t>&#x3b8;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:r><m:t>&#x3b8;</m:t></m:r>" color
                  |_ "<m:t>&#x3b8;</m:t>" text
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "{\\color{red} \\theta}"
               |_ "{\\color{red} \\theta}" color
                  |_ "r e d" mathcolor
                  |_ "\\theta" text
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mstyle mathcolor="red"><mi>&#x3b8;</mi></mstyle></mstyle></math>"
               |_ "<mstyle mathcolor="red"><mi>&#x3b8;</mi></mstyle>" color
                  |_ "<mrow><mi>r</mi><mi>e</mi><mi>d</mi></mrow>" mathcolor
                  |_ "<mi>&#x3b8;</mi>" text
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "color(red)(theta)"
               |_ "color(red)(theta)" color
                  |_ "r e d" mathcolor
                  |_ "theta" text
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation of four unary functions #12" do
      let(:exp) { 'abs(x)floor(x)ceil(x)norm(vecx)' }

      it 'should puts Math zone representation of sample example #12' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:d><m:dPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:begChr m:val="|"/><m:endChr m:val="|"/><m:sepChr m:val=""/><m:grow/></m:dPr><m:e><m:r><m:t>x</m:t></m:r></m:e></m:d><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>⌊</m:t></m:r><m:r><m:t>x</m:t></m:r><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>⌋</m:t></m:r><m:d><m:dPr><m:begChr m:val="⌈"/><m:sepChr m:val=""/><m:endChr m:val="⌉"/></m:dPr><m:e><m:r><m:t>x</m:t></m:r></m:e></m:d><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>∥</m:t></m:r><m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>x</m:t></m:r></m:e><m:lim><m:r><m:t>→</m:t></m:r></m:lim></m:limUpp><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>∥</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:d><m:dPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:begChr m:val="|"/><m:endChr m:val="|"/><m:sepChr m:val=""/><m:grow/></m:dPr><m:e><m:r><m:t>x</m:t></m:r></m:e></m:d>" function apply
               |  |_ "abs" function name
               |  |_ "<m:t>x</m:t>" argument
               |_ "<m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>⌊</m:t></m:r><m:r><m:t>x</m:t></m:r><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>⌋</m:t></m:r>" function apply
               |  |_ "floor" function name
               |  |_ "<m:t>x</m:t>" argument
               |_ "<m:d><m:dPr><m:begChr m:val="⌈"/><m:sepChr m:val=""/><m:endChr m:val="⌉"/></m:dPr><m:e><m:r><m:t>x</m:t></m:r></m:e></m:d>" function apply
               |  |_ "ceil" function name
               |  |_ "<m:t>x</m:t>" argument
               |_ "<m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>∥</m:t></m:r><m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>x</m:t></m:r></m:e><m:lim><m:r><m:t>→</m:t></m:r></m:lim></m:limUpp><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>∥</m:t></m:r>" function apply
                  |_ "norm" function name
                  |_ "<m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>x</m:t></m:r></m:e><m:lim><m:r><m:t>→</m:t></m:r></m:lim></m:limUpp>" argument
                     |_ "<m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>x</m:t></m:r></m:e><m:lim><m:r><m:t>→</m:t></m:r></m:lim></m:limUpp>" overset
                        |_ "<m:t>&#x2192;</m:t>" base
                        |_ "<m:t>x</m:t>" supscript
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\abs{x} {\\lfloor x \\rfloor} {\\lceil x \\rceil} {\\lVert \\vec{x} \\lVert}"
               |_ "\\abs{x}" function apply
               |  |_ "abs" function name
               |  |_ "x" argument
               |_ "{\\lfloor x \\rfloor}" function apply
               |  |_ "floor" function name
               |  |_ "x" argument
               |_ "{\\lceil x \\rceil}" function apply
               |  |_ "ceil" function name
               |  |_ "x" argument
               |_ "{\\lVert \\vec{x} \\lVert}" function apply
                  |_ "norm" function name
                  |_ "\\vec{x}" argument
                     |_ "\\vec{x}" function apply
                        |_ "vec" function name
                        |_ "x" supscript
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mo>|</mo><mi>x</mi><mo>|</mo></mrow><mrow><mo>&#x230a;</mo><mi>x</mi><mo>&#x230b;</mo></mrow><mrow><mo>&#x2308;</mo><mi>x</mi><mo>&#x2309;</mo></mrow><mrow><mo>&#x2225;</mo><mover><mi>x</mi><mo>&#x2192;</mo></mover><mo>&#x2225;</mo></mrow></mstyle></math>"
               |_ "<mrow><mo>|</mo><mi>x</mi><mo>|</mo></mrow>" function apply
               |  |_ "abs" function name
               |  |_ "<mi>x</mi>" argument
               |_ "<mrow><mo>&#x230a;</mo><mi>x</mi><mo>&#x230b;</mo></mrow>" function apply
               |  |_ "floor" function name
               |  |_ "<mi>x</mi>" argument
               |_ "<mrow><mo>&#x2308;</mo><mi>x</mi><mo>&#x2309;</mo></mrow>" function apply
               |  |_ "ceil" function name
               |  |_ "<mi>x</mi>" argument
               |_ "<mrow><mo>&#x2225;</mo><mover><mi>x</mi><mo>&#x2192;</mo></mover><mo>&#x2225;</mo></mrow>" function apply
                  |_ "norm" function name
                  |_ "<mover><mi>x</mi><mo>&#x2192;</mo></mover>" argument
                     |_ "<mover><mi>x</mi><mo>&#x2192;</mo></mover>" overset
                        |_ "<mo>&#x2192;</mo>" base
                        |_ "<mi>x</mi>" supscript
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "abs(x) floor(x) ceil(x) norm(vec(x))"
               |_ "abs(x)" function apply
               |  |_ "abs" function name
               |  |_ "x" argument
               |_ "floor(x)" function apply
               |  |_ "floor" function name
               |  |_ "x" argument
               |_ "ceil(x)" function apply
               |  |_ "ceil" function name
               |  |_ "x" argument
               |_ "norm(vec(x))" function apply
                  |_ "norm" function name
                  |_ "vec(x)" argument
                     |_ "vec(x)" function apply
                        |_ "vec" function name
                        |_ "x" supscript
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation of font functions #13" do
      let(:exp) { 'mathbf(x)mathbb(x)mathcal(x)mathtt(x)mathfrak(x)mathsf(x)' }

      it 'should puts Math zone representation of sample example #13' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:r><m:rPr><m:sty m:val="b"/></m:rPr><m:t>x</m:t></m:r><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>x</m:t></m:r><m:r><m:rPr><m:scr m:val="script"/><m:sty m:val="p"/></m:rPr><m:t>x</m:t></m:r><m:r><m:rPr><m:scr m:val="monospace"/></m:rPr><m:t>x</m:t></m:r><m:r><m:rPr><m:scr m:val="fraktur"/><m:sty m:val="p"/></m:rPr><m:t>x</m:t></m:r><m:r><m:rPr><m:scr m:val="sans-serif"/><m:sty m:val="p"/></m:rPr><m:t>x</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:r><m:rPr><m:sty m:val="b"/></m:rPr><m:t>x</m:t></m:r>" function apply
               |  |_ "bold" font family
               |  |_ "<m:t>x</m:t>" argument
               |_ "<m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>x</m:t></m:r>" function apply
               |  |_ "double-struck" font family
               |  |_ "<m:t>x</m:t>" argument
               |_ "<m:r><m:rPr><m:scr m:val="script"/><m:sty m:val="p"/></m:rPr><m:t>x</m:t></m:r>" function apply
               |  |_ "script" font family
               |  |_ "<m:t>x</m:t>" argument
               |_ "<m:r><m:rPr><m:scr m:val="monospace"/></m:rPr><m:t>x</m:t></m:r>" function apply
               |  |_ "monospace" font family
               |  |_ "<m:t>x</m:t>" argument
               |_ "<m:r><m:rPr><m:scr m:val="fraktur"/><m:sty m:val="p"/></m:rPr><m:t>x</m:t></m:r>" function apply
               |  |_ "fraktur" font family
               |  |_ "<m:t>x</m:t>" argument
               |_ "<m:r><m:rPr><m:scr m:val="sans-serif"/><m:sty m:val="p"/></m:rPr><m:t>x</m:t></m:r>" function apply
                  |_ "sans-serif" font family
                  |_ "<m:t>x</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\mathbf{x} \\mathbb{x} \\mathcal{x} \\mathtt{x} \\mathfrak{x} \\mathsf{x}"
               |_ "\\mathbf{x}" function apply
               |  |_ "mathbf" font family
               |  |_ "x" argument
               |_ "\\mathbb{x}" function apply
               |  |_ "mathbb" font family
               |  |_ "x" argument
               |_ "\\mathcal{x}" function apply
               |  |_ "mathcal" font family
               |  |_ "x" argument
               |_ "\\mathtt{x}" function apply
               |  |_ "mathtt" font family
               |  |_ "x" argument
               |_ "\\mathfrak{x}" function apply
               |  |_ "mathfrak" font family
               |  |_ "x" argument
               |_ "\\mathsf{x}" function apply
                  |_ "mathsf" font family
                  |_ "x" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mstyle mathvariant="bold"><mi>x</mi></mstyle><mstyle mathvariant="double-struck"><mi>x</mi></mstyle><mstyle mathvariant="script"><mi>x</mi></mstyle><mstyle mathvariant="monospace"><mi>x</mi></mstyle><mstyle mathvariant="fraktur"><mi>x</mi></mstyle><mstyle mathvariant="sans-serif"><mi>x</mi></mstyle></mstyle></math>"
               |_ "<mstyle mathvariant="bold"><mi>x</mi></mstyle>" function apply
               |  |_ "bold" font family
               |  |_ "<mi>x</mi>" argument
               |_ "<mstyle mathvariant="double-struck"><mi>x</mi></mstyle>" function apply
               |  |_ "double-struck" font family
               |  |_ "<mi>x</mi>" argument
               |_ "<mstyle mathvariant="script"><mi>x</mi></mstyle>" function apply
               |  |_ "script" font family
               |  |_ "<mi>x</mi>" argument
               |_ "<mstyle mathvariant="monospace"><mi>x</mi></mstyle>" function apply
               |  |_ "monospace" font family
               |  |_ "<mi>x</mi>" argument
               |_ "<mstyle mathvariant="fraktur"><mi>x</mi></mstyle>" function apply
               |  |_ "fraktur" font family
               |  |_ "<mi>x</mi>" argument
               |_ "<mstyle mathvariant="sans-serif"><mi>x</mi></mstyle>" function apply
                  |_ "sans-serif" font family
                  |_ "<mi>x</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "mathbf(x) mathbb(x) mathcal(x) mathtt(x) mathfrak(x) mathsf(x)"
               |_ "mathbf(x)" function apply
               |  |_ "mathbf" font family
               |  |_ "x" argument
               |_ "mathbb(x)" function apply
               |  |_ "mathbb" font family
               |  |_ "x" argument
               |_ "mathcal(x)" function apply
               |  |_ "mathcal" font family
               |  |_ "x" argument
               |_ "mathtt(x)" function apply
               |  |_ "mathtt" font family
               |  |_ "x" argument
               |_ "mathfrak(x)" function apply
               |  |_ "mathfrak" font family
               |  |_ "x" argument
               |_ "mathsf(x)" function apply
                  |_ "mathsf" font family
                  |_ "x" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end
  end

  describe "LaTeX input to all to_display(:lang) conversions" do
    subject(:formula) { Plurimath::Math.parse(exp, :latex) }

    context "LaTeX Math zone representation of sin and simple equation #1" do
      let(:exp) { '\sum_3^1 \sin\theta' }

      it 'should puts Math zone representation of sample example #1' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:nary><m:naryPr><m:chr m:val="∑"/><m:limLoc m:val="undOvr"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>3</m:t></m:r></m:sub><m:sup><m:r><m:t>1</m:t></m:r></m:sup><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:e></m:nary></m:oMath></m:oMathPara>"
               |_ "<m:nary><m:naryPr><m:chr m:val="∑"/><m:limLoc m:val="undOvr"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>3</m:t></m:r></m:sub><m:sup><m:r><m:t>1</m:t></m:r></m:sup><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:e></m:nary>" summation
                  |_ "<m:t>3</m:t>" subscript
                  |_ "<m:t>1</m:t>" supscript
                  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" term
                     |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" function apply
                        |_ "sin" function name
                        |_ "<m:t>&#x3b8;</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\sum_{3}^{1} \\sin{\\theta}"
               |_ "\\sum_{3}^{1} \\sin{\\theta}" summation
                  |_ "3" subscript
                  |_ "1" supscript
                  |_ "\\sin{\\theta}" term
                     |_ "\\sin{\\theta}" function apply
                        |_ "sin" function name
                        |_ "\\theta" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><munderover><mo>&#x2211;</mo><mn>3</mn><mn>1</mn></munderover><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mstyle></math>"
               |_ "<mrow><munderover><mo>&#x2211;</mo><mn>3</mn><mn>1</mn></munderover><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow>" summation
                  |_ "<mn>3</mn>" subscript
                  |_ "<mn>1</mn>" supscript
                  |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" term
                     |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" function apply
                        |_ "sin" function name
                        |_ "<mi>&#x3b8;</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "sum_(3)^(1) sintheta"
               |_ "sum_(3)^(1) sintheta" summation
                  |_ "3" subscript
                  |_ "1" supscript
                  |_ "sintheta" term
                     |_ "sintheta" function apply
                        |_ "sin" function name
                        |_ "theta" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "LaTeX Math zone representation of parentheses wrapped sin equation #2" do
      let(:exp) { '(a + 1 \sin \theta)' }

      it 'should puts Math zone representation of sample example #2' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>1</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:e></m:d></m:oMath></m:oMathPara>"
               |_ "<m:t>a&#xa0;+&#xa0;1</m:t>" text
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" function apply
                  |_ "sin" function name
                  |_ "<m:t>&#x3b8;</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "( a + 1 \\sin{\\theta} )"
               |_ "a + 1" text
               |_ "\\sin{\\theta}" function apply
                  |_ "sin" function name
                  |_ "\\theta" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mo>(</mo><mi>a</mi><mo>+</mo><mn>1</mn><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow><mo>)</mo></mrow></mstyle></math>"
               |_ "<mtext>a + 1</mtext>" text
               |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" function apply
                  |_ "sin" function name
                  |_ "<mi>&#x3b8;</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "(a + 1 sintheta)"
               |_ "a + 1" text
               |_ "sintheta" function apply
                  |_ "sin" function name
                  |_ "theta" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "LaTeX Math zone representation example provided in github issue#113 #3" do
      let(:exp) { '\frac{1}{2 \pi} \int_0^{2\pi} \frac{\mathbb{\text{"d"}} \theta}{a + b \sin{\theta}} = \frac{1}{\sqrt{a^2−b^2}}' }

      it 'should puts Math zone representation of sample example #3' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:den></m:f><m:nary><m:naryPr><m:chr m:val="∫"/><m:limLoc m:val="subSup"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>0</m:t></m:r></m:sub><m:sup><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:sup><m:e><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>&#x22;d&#x22;</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f></m:e></m:nary><m:r><m:t>=</m:t></m:r><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad></m:den></m:f></m:oMath></m:oMathPara>"
               |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:den></m:f>" fraction
               |  |_ "<m:t>1</m:t>" numerator
               |  |_ "<m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r>" denominator
               |_ "<m:nary><m:naryPr><m:chr m:val="∫"/><m:limLoc m:val="subSup"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>0</m:t></m:r></m:sub><m:sup><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:sup><m:e><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>&#x22;d&#x22;</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f></m:e></m:nary>" integral
               |  |_ "<m:t>0</m:t>" lower limit
               |  |_ "<m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r>" upper limit
               |  |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>&#x22;d&#x22;</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f>" integrand
               |     |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>&#x22;d&#x22;</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f>" fraction
               |        |_ "<m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>&#x22;d&#x22;</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r>" numerator
               |        |  |_ "<m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>&#x22;d&#x22;</m:t></m:r>" function apply
               |        |  |  |_ "double-struck" font family
               |        |  |  |_ "<m:t>&#x22;d&#x22;</m:t>" argument
               |        |  |_ "<m:t>&#x3b8;</m:t>" text
               |        |_ "<m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" denominator
               |          |_ "<m:t>a&#xa0;+&#xa0;b</m:t>" text
               |          |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" function apply
               |             |_ "sin" function name
               |             |_ "<m:t>&#x3b8;</m:t>" argument
               |_ "<m:t>=</m:t>" text
               |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad></m:den></m:f>" fraction
                  |_ "<m:t>1</m:t>" numerator
                  |_ "<m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad>" denominator
                    |_ "<m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad>" function apply
                       |_ "sqrt" function name
                       |_ "<m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup>" argument
                          |_ "<m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup>" superscript
                          |  |_ "<m:t>a</m:t>" base
                          |  |_ "<m:t>2</m:t>" script
                          |_ "<m:t>&#x2212;</m:t>" text
                          |_ "<m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup>" superscript
                             |_ "<m:t>b</m:t>" base
                             |_ "<m:t>2</m:t>" script
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\frac{1}{2 \\pi} \\int_{0}^{2 \\pi} \\frac{\\mathbb{\\text{"d"}} \\theta}{a + b \\sin{\\theta}} = \\frac{1}{\\sqrt{a^{2} - b^{2}}}"
               |_ "\\frac{1}{2 \\pi}" fraction
               |  |_ "1" numerator
               |  |_ "2 \\pi" denominator
               |_ "\\int_{0}^{2 \\pi} \\frac{\\mathbb{\\text{"d"}} \\theta}{a + b \\sin{\\theta}}" integral
               |  |_ "0" lower limit
               |  |_ "2 \\pi" upper limit
               |  |_ "\\frac{\\mathbb{\\text{"d"}} \\theta}{a + b \\sin{\\theta}}" integrand
               |     |_ "\\frac{\\mathbb{\\text{"d"}} \\theta}{a + b \\sin{\\theta}}" fraction
               |        |_ "\\mathbb{\\text{"d"}} \\theta" numerator
               |        |  |_ "\\mathbb{\\text{"d"}}" function apply
               |        |  |  |_ "mathbb" font family
               |        |  |  |_ "\\text{"d"}" argument
               |        |  |_ "&#x3b8;" text
               |        |_ "a + b \\sin{\\theta}" denominator
               |           |_ "a + b" text
               |           |_ "\\sin{\\theta}" function apply
               |              |_ "sin" function name
               |              |_ "\\theta" argument
               |_ "=" text
               |_ "\\frac{1}{\\sqrt{a^{2} - b^{2}}}" fraction
                  |_ "1" numerator
                  |_ "\\sqrt{a^{2} - b^{2}}" denominator
                     |_ "\\sqrt{a^{2} - b^{2}}" function apply
                        |_ "sqrt" function name
                        |_ "a^{2} - b^{2}" argument
                           |_ "a^{2}" superscript
                           |  |_ "a" base
                           |  |_ "2" script
                           |_ "&#x2212;" text
                           |_ "b^{2}" superscript
                              |_ "b" base
                              |_ "2" script
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mfrac><mn>1</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></mfrac><mrow><msubsup><mo>&#x222b;</mo><mn>0</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></msubsup><mfrac><mrow><mstyle mathvariant="double-struck"><mtext>"d"</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac></mrow><mo>=</mo><mfrac><mn>1</mn><msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt></mfrac></mstyle></math>"
               |_ "<mfrac><mn>1</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></mfrac>" fraction
               |  |_ "<mn>1</mn>" numerator
               |  |_ "<mrow><mn>2</mn><mi>&#x3c0;</mi></mrow>" denominator
               |_ "<mrow><msubsup><mo>&#x222b;</mo><mn>0</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></msubsup><mfrac><mrow><mstyle mathvariant="double-struck"><mtext>"d"</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac></mrow>" integral
               |  |_ "<mn>0</mn>" lower limit
               |  |_ "<mrow><mn>2</mn><mi>&#x3c0;</mi></mrow>" upper limit
               |  |_ "<mfrac><mrow><mstyle mathvariant="double-struck"><mtext>"d"</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac>" integrand
               |     |_ "<mfrac><mrow><mstyle mathvariant="double-struck"><mtext>"d"</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac>" fraction
               |        |_ "<mrow><mstyle mathvariant="double-struck"><mtext>"d"</mtext></mstyle><mi>&#x3b8;</mi></mrow>" numerator
               |        |  |_ "<mstyle mathvariant="double-struck"><mtext>"d"</mtext></mstyle>" function apply
               |        |  |  |_ "double-struck" font family
               |        |  |  |_ "<mtext>"d"</mtext>" argument
               |        |  |_ "<mtext>&#x3b8;</mtext>" text
               |        |_ "<mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow>" denominator
               |          |_ "<mtext>a + b</mtext>" text
               |          |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" function apply
               |             |_ "sin" function name
               |             |_ "<mi>&#x3b8;</mi>" argument
               |_ "<mtext>=</mtext>" text
               |_ "<mfrac><mn>1</mn><msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt></mfrac>" fraction
                  |_ "<mn>1</mn>" numerator
                  |_ "<msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt>" denominator
                    |_ "<msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt>" function apply
                       |_ "sqrt" function name
                       |_ "<mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow>" argument
                          |_ "<msup><mi>a</mi><mn>2</mn></msup>" superscript
                          |  |_ "<mi>a</mi>" base
                          |  |_ "<mn>2</mn>" script
                          |_ "<mtext>&#x2212;</mtext>" text
                          |_ "<msup><mi>b</mi><mn>2</mn></msup>" superscript
                             |_ "<mi>b</mi>" base
                             |_ "<mn>2</mn>" script
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "frac(1)(2 pi) int_(0)^(2 pi) frac(mathbb(""d"") theta)(a + b sintheta) = frac(1)(sqrt(a^(2) - b^(2)))"
               |_ "frac(1)(2 pi)" fraction
               |  |_ "1" numerator
               |  |_ "2 pi" denominator
               |_ "int_(0)^(2 pi) frac(mathbb(""d"") theta)(a + b sintheta)" integral
               |  |_ "0" lower limit
               |  |_ "2 pi" upper limit
               |  |_ "frac(mathbb(""d"") theta)(a + b sintheta)" integrand
               |     |_ "frac(mathbb(""d"") theta)(a + b sintheta)" fraction
               |        |_ "mathbb(""d"") theta" numerator
               |        |  |_ "mathbb(""d"")" function apply
               |        |  |  |_ "mathbb" font family
               |        |  |  |_ """d""" argument
               |        |  |_ "&#x3b8;" text
               |        |_ "a + b sintheta" denominator
               |           |_ "a + b" text
               |           |_ "sintheta" function apply
               |              |_ "sin" function name
               |              |_ "theta" argument
               |_ "=" text
               |_ "frac(1)(sqrt(a^(2) - b^(2)))" fraction
                  |_ "1" numerator
                  |_ "sqrt(a^(2) - b^(2))" denominator
                     |_ "sqrt(a^(2) - b^(2))" function apply
                        |_ "sqrt" function name
                        |_ "a^(2) - b^(2)" argument
                           |_ "a^(2)" superscript
                           |  |_ "a" base
                           |  |_ "2" script
                           |_ "&#x2212;" text
                           |_ "b^(2)" superscript
                              |_ "b" base
                              |_ "2" script
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "LaTeX Math zone representation of cos function #4" do
      let(:exp) { '\\cos{2}' }

      it 'should puts Math zone representation of sample example #4' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func></m:oMath></m:oMathPara>"
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func>" function apply
                  |_ "cos" function name
                  |_ "<m:t>2</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\cos{2}"
               |_ "\\cos{2}" function apply
                  |_ "cos" function name
                  |_ "2" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mi>cos</mi><mn>2</mn></mrow></mstyle></math>"
               |_ "<mrow><mi>cos</mi><mn>2</mn></mrow>" function apply
                  |_ "cos" function name
                  |_ "<mn>2</mn>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "cos2"
               |_ "cos2" function apply
                  |_ "cos" function name
                  |_ "2" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "LaTeX Math zone representation of power_base #5" do
      let(:exp) { '\cos{2}_{\theta}^{\sigma} \cos{2}' }

      it 'should puts Math zone representation of sample example #5' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:sSubSup><m:sSubSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSubSupPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func></m:e><m:sub><m:r><m:t>&#x3b8;</m:t></m:r></m:sub><m:sup><m:r><m:t>&#x3c3;</m:t></m:r></m:sup></m:sSubSup><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func></m:oMath></m:oMathPara>"
               |_ "<m:sSubSup><m:sSubSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSubSupPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func></m:e><m:sub><m:r><m:t>&#x3b8;</m:t></m:r></m:sub><m:sup><m:r><m:t>&#x3c3;</m:t></m:r></m:sup></m:sSubSup>" subsup
               |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func>" base
               |  |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func>" function apply
               |  |     |_ "cos" function name
               |  |     |_ "<m:t>2</m:t>" argument
               |  |_ "<m:t>&#x3b8;</m:t>" subscript
               |  |_ "<m:t>&#x3c3;</m:t>" supscript
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func>" function apply
                  |_ "cos" function name
                  |_ "<m:t>2</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\cos{2}_{\\theta}^{\\sigma} \\cos{2}"
               |_ "\\cos{2}_{\\theta}^{\\sigma}" subsup
               |  |_ "\\cos{2}" base
               |  |  |_ "\\cos{2}" function apply
               |  |     |_ "cos" function name
               |  |     |_ "2" argument
               |  |_ "\\theta" subscript
               |  |_ "\\sigma" supscript
               |_ "\\cos{2}" function apply
                  |_ "cos" function name
                  |_ "2" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><msubsup><mrow><mi>cos</mi><mn>2</mn></mrow><mi>&#x3b8;</mi><mi>&#x3c3;</mi></msubsup><mrow><mi>cos</mi><mn>2</mn></mrow></mstyle></math>"
               |_ "<msubsup><mrow><mi>cos</mi><mn>2</mn></mrow><mi>&#x3b8;</mi><mi>&#x3c3;</mi></msubsup>" subsup
               |  |_ "<mrow><mi>cos</mi><mn>2</mn></mrow>" base
               |  |  |_ "<mrow><mi>cos</mi><mn>2</mn></mrow>" function apply
               |  |     |_ "cos" function name
               |  |     |_ "<mn>2</mn>" argument
               |  |_ "<mi>&#x3b8;</mi>" subscript
               |  |_ "<mi>&#x3c3;</mi>" supscript
               |_ "<mrow><mi>cos</mi><mn>2</mn></mrow>" function apply
                  |_ "cos" function name
                  |_ "<mn>2</mn>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "cos2_(theta)^(sigma) cos2"
               |_ "cos2_(theta)^(sigma)" subsup
               |  |_ "cos2" base
               |  |  |_ "cos2" function apply
               |  |     |_ "cos" function name
               |  |     |_ "2" argument
               |  |_ "theta" subscript
               |  |_ "sigma" supscript
               |_ "cos2" function apply
                  |_ "cos" function name
                  |_ "2" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "LaTeX Math zone representation of mod #6" do
      let(:exp) { '{\cos{2}}\pmod{\sigma}' }

      it 'should puts Math zone representation of sample example #6' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r><m:r><m:t>&#x3c3;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r><m:r><m:t>&#x3c3;</m:t></m:r>" mod
                  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func>" base
                  |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func>" function apply
                  |     |_ "cos" function name
                  |     |_ "<m:t>2</m:t>" argument
                  |_ "<m:t>&#x3c3;</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "{\\cos{2}} \\mod {\\sigma}"
               |_ "{\\cos{2}} \\mod {\\sigma}" mod
                  |_ "\\cos{2}" base
                  |  |_ "\\cos{2}" function apply
                  |     |_ "cos" function name
                  |     |_ "2" argument
                  |_ "\\sigma" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mrow><mi>cos</mi><mn>2</mn></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow></mstyle></math>"
               |_ "<mrow><mrow><mi>cos</mi><mn>2</mn></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow>" mod
                  |_ "<mrow><mi>cos</mi><mn>2</mn></mrow>" base
                  |  |_ "<mrow><mi>cos</mi><mn>2</mn></mrow>" function apply
                  |     |_ "cos" function name
                  |     |_ "<mn>2</mn>" argument
                  |_ "<mi>&#x3c3;</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "cos2 mod sigma"
               |_ "cos2 mod sigma" mod
                  |_ "cos2" base
                  |  |_ "cos2" function apply
                  |     |_ "cos" function name
                  |     |_ "2" argument
                  |_ "sigma" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "LaTeX Math zone representation of mod with multiple base values #7" do
      let(:exp) { '{\cos{2} \sin{3}}\pmod {\sigma}' }

      it 'should puts Math zone representation of sample example #7' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>3</m:t></m:r></m:e></m:func><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r><m:r><m:t>&#x3c3;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>3</m:t></m:r></m:e></m:func><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r><m:r><m:t>&#x3c3;</m:t></m:r>" mod
                  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>3</m:t></m:r></m:e></m:func>" base
                  |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:r><m:t>2</m:t></m:r></m:e></m:func>" function apply
                  |  |  |_ "cos" function name
                  |  |  |_ "<m:t>2</m:t>" argument
                  |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>3</m:t></m:r></m:e></m:func>" function apply
                  |     |_ "sin" function name
                  |     |_ "<m:t>3</m:t>" argument
                  |_ "<m:t>&#x3c3;</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "{\\cos{2} \\sin{3}} \\mod {\\sigma}"
               |_ "{\\cos{2} \\sin{3}} \\mod {\\sigma}" mod
                  |_ "\\cos{2} \\sin{3}" base
                  |  |_ "\\cos{2}" function apply
                  |  |  |_ "cos" function name
                  |  |  |_ "2" argument
                  |  |_ "\\sin{3}" function apply
                  |     |_ "sin" function name
                  |     |_ "3" argument
                  |_ "\\sigma" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mrow><mrow><mi>cos</mi><mn>2</mn></mrow><mrow><mi>sin</mi><mn>3</mn></mrow></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow></mstyle></math>"
               |_ "<mrow><mrow><mrow><mi>cos</mi><mn>2</mn></mrow><mrow><mi>sin</mi><mn>3</mn></mrow></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow>" mod
                  |_ "<mrow><mrow><mi>cos</mi><mn>2</mn></mrow><mrow><mi>sin</mi><mn>3</mn></mrow></mrow>" base
                  |  |_ "<mrow><mi>cos</mi><mn>2</mn></mrow>" function apply
                  |  |  |_ "cos" function name
                  |  |  |_ "<mn>2</mn>" argument
                  |  |_ "<mrow><mi>sin</mi><mn>3</mn></mrow>" function apply
                  |     |_ "sin" function name
                  |     |_ "<mn>3</mn>" argument
                  |_ "<mi>&#x3c3;</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "cos2 sin3 mod sigma"
               |_ "cos2 sin3 mod sigma" mod
                  |_ "cos2 sin3" base
                  |  |_ "cos2" function apply
                  |  |  |_ "cos" function name
                  |  |  |_ "2" argument
                  |  |_ "sin3" function apply
                  |     |_ "sin" function name
                  |     |_ "3" argument
                  |_ "sigma" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "LaTeX Math zone representation of table #8" do
      let(:exp) { '\left [\begin{matrix}\sigma & \gamma \\\\ \theta & \alpha\end{matrix}\right ]' }

      it 'should puts Math zone representation of sample example #8' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:r><m:t>[</m:t></m:r><m:m><m:mPr><m:mcs><m:mc><m:mcPr><m:count m:val="2"/><m:mcJc m:val="center"/></m:mcPr></m:mc></m:mcs><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:mPr><m:mr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:e><m:r><m:t>&#x3b3;</m:t></m:r></m:e></m:mr><m:mr><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e><m:e><m:r><m:t>&#x3b1;</m:t></m:r></m:e></m:mr></m:m><m:r><m:t>]</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:t>[</m:t>" left
               |_ "table" function apply
               |  |_ "tr" function apply
               |  |  |_ "td" function apply
               |  |  |  |_ "<m:t>&#x3c3;</m:t>" text
               |  |  |_ "td" function apply
               |  |     |_ "<m:t>&#x3b3;</m:t>" text
               |  |_ "tr" function apply
               |     |_ "td" function apply
               |     |  |_ "<m:t>&#x3b8;</m:t>" text
               |     |_ "td" function apply
               |        |_ "<m:t>&#x3b1;</m:t>" text
               |_ "<m:t>]</m:t>" right
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\left [ \\begin{matrix}\\sigma & \\gamma \\\\ \\theta & \\alpha\\end{matrix} \\right ]"
               |_ "[" left
               |_ "table" function apply
               |  |_ "tr" function apply
               |  |  |_ "td" function apply
               |  |  |  |_ "&#x3c3;" text
               |  |  |_ "td" function apply
               |  |     |_ "&#x3b3;" text
               |  |_ "tr" function apply
               |     |_ "td" function apply
               |     |  |_ "&#x3b8;" text
               |     |_ "td" function apply
               |        |_ "&#x3b1;" text
               |_ "]" right
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mo>[</mo><mtable><mtr><mtd><mi>&#x3c3;</mi></mtd><mtd><mi>&#x3b3;</mi></mtd></mtr><mtr><mtd><mi>&#x3b8;</mi></mtd><mtd><mi>&#x3b1;</mi></mtd></mtr></mtable><mo>]</mo></mstyle></math>"
               |_ "<mo>[</mo>" left
               |_ "table" function apply
               |  |_ "tr" function apply
               |  |  |_ "td" function apply
               |  |  |  |_ "<mtext>&#x3c3;</mtext>" text
               |  |  |_ "td" function apply
               |  |     |_ "<mtext>&#x3b3;</mtext>" text
               |  |_ "tr" function apply
               |     |_ "td" function apply
               |     |  |_ "<mtext>&#x3b8;</mtext>" text
               |     |_ "td" function apply
               |        |_ "<mtext>&#x3b1;</mtext>" text
               |_ "<mo>]</mo>" right
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "left[ {:[sigma, gamma], [theta, alpha]:} right]"
               |_ "[" left
               |_ "table" function apply
               |  |_ "tr" function apply
               |  |  |_ "td" function apply
               |  |  |  |_ "&#x3c3;" text
               |  |  |_ "td" function apply
               |  |     |_ "&#x3b3;" text
               |  |_ "tr" function apply
               |     |_ "td" function apply
               |     |  |_ "&#x3b8;" text
               |     |_ "td" function apply
               |        |_ "&#x3b1;" text
               |_ "]" right
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "LaTeX Math zone representation of overset #9" do
      let(:exp) { '\overset{\sigma}{\theta}' }

      it 'should puts Math zone representation of sample example #9' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limUpp></m:oMath></m:oMathPara>"
               |_ "<m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limUpp>" overset
                  |_ "<m:t>&#x3c3;</m:t>" base
                  |_ "<m:t>&#x3b8;</m:t>" supscript
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\overset{\\sigma}{\\theta}"
               |_ "\\overset{\\sigma}{\\theta}" overset
                  |_ "\\sigma" base
                  |_ "\\theta" supscript
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mover><mi>&#x3b8;</mi><mi>&#x3c3;</mi></mover></mstyle></math>"
               |_ "<mover><mi>&#x3b8;</mi><mi>&#x3c3;</mi></mover>" overset
                  |_ "<mi>&#x3c3;</mi>" base
                  |_ "<mi>&#x3b8;</mi>" supscript
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "overset(sigma)(theta)"
               |_ "overset(sigma)(theta)" overset
                  |_ "sigma" base
                  |_ "theta" supscript
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "LaTeX Math zone representation of underset #10" do
      let(:exp) { '\underset{\sigma}{\theta}' }

      it 'should puts Math zone representation of sample example #10' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:limLow><m:limLowPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limLowPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limLow></m:oMath></m:oMathPara>"
               |_ "<m:limLow><m:limLowPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limLowPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limLow>" underscript
                  |_ "<m:t>&#x3c3;</m:t>" underscript value
                  |_ "<m:t>&#x3b8;</m:t>" base expression
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\underset{\\sigma}{\\theta}"
               |_ "\\underset{\\sigma}{\\theta}" underscript
                  |_ "\\sigma" underscript value
                  |_ "\\theta" base expression
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><munder><mi>&#x3b8;</mi><mi>&#x3c3;</mi></munder></mstyle></math>"
               |_ "<munder><mi>&#x3b8;</mi><mi>&#x3c3;</mi></munder>" underscript
                  |_ "<mi>&#x3c3;</mi>" underscript value
                  |_ "<mi>&#x3b8;</mi>" base expression
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "underset(sigma)(theta)"
               |_ "underset(sigma)(theta)" underscript
                  |_ "sigma" underscript value
                  |_ "theta" base expression
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "LaTeX Math zone representation of color #11" do
      let(:exp) { '\color{red}{\theta}' }

      it 'should puts Math zone representation of sample example #11' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:r><m:t>&#x3b8;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:r><m:t>&#x3b8;</m:t></m:r>" color
                  |_ "<m:t>&#x3b8;</m:t>" text
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "{\\color{red} \\theta}"
               |_ "{\\color{red} \\theta}" color
                  |_ "red" mathcolor
                  |_ "\\theta" text
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mstyle mathcolor="red"><mi>&#x3b8;</mi></mstyle></mstyle></math>"
               |_ "<mstyle mathcolor="red"><mi>&#x3b8;</mi></mstyle>" color
                  |_ "<mi>red</mi>" mathcolor
                  |_ "<mi>&#x3b8;</mi>" text
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "color(red)(theta)"
               |_ "color(red)(theta)" color
                  |_ "red" mathcolor
                  |_ "theta" text
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "LaTeX Math zone representation of font functions #12" do
      let(:exp) { '\mathbf{x}\mathbb{x}\mathcal{x}\mathtt{x}\mathfrak{x}\mathsf{x}' }

      it 'should puts Math zone representation of sample example #13' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:r><m:rPr><m:sty m:val="b"/></m:rPr><m:t>x</m:t></m:r><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>x</m:t></m:r><m:r><m:rPr><m:scr m:val="script"/><m:sty m:val="p"/></m:rPr><m:t>x</m:t></m:r><m:r><m:rPr><m:scr m:val="monospace"/></m:rPr><m:t>x</m:t></m:r><m:r><m:rPr><m:scr m:val="fraktur"/><m:sty m:val="p"/></m:rPr><m:t>x</m:t></m:r><m:r><m:rPr><m:scr m:val="sans-serif"/><m:sty m:val="p"/></m:rPr><m:t>x</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:r><m:rPr><m:sty m:val="b"/></m:rPr><m:t>x</m:t></m:r>" function apply
               |  |_ "bold" font family
               |  |_ "<m:t>x</m:t>" argument
               |_ "<m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>x</m:t></m:r>" function apply
               |  |_ "double-struck" font family
               |  |_ "<m:t>x</m:t>" argument
               |_ "<m:r><m:rPr><m:scr m:val="script"/><m:sty m:val="p"/></m:rPr><m:t>x</m:t></m:r>" function apply
               |  |_ "script" font family
               |  |_ "<m:t>x</m:t>" argument
               |_ "<m:r><m:rPr><m:scr m:val="monospace"/></m:rPr><m:t>x</m:t></m:r>" function apply
               |  |_ "monospace" font family
               |  |_ "<m:t>x</m:t>" argument
               |_ "<m:r><m:rPr><m:scr m:val="fraktur"/><m:sty m:val="p"/></m:rPr><m:t>x</m:t></m:r>" function apply
               |  |_ "fraktur" font family
               |  |_ "<m:t>x</m:t>" argument
               |_ "<m:r><m:rPr><m:scr m:val="sans-serif"/><m:sty m:val="p"/></m:rPr><m:t>x</m:t></m:r>" function apply
                  |_ "sans-serif" font family
                  |_ "<m:t>x</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\mathbf{x} \\mathbb{x} \\mathcal{x} \\mathtt{x} \\mathfrak{x} \\mathsf{x}"
               |_ "\\mathbf{x}" function apply
               |  |_ "mathbf" font family
               |  |_ "x" argument
               |_ "\\mathbb{x}" function apply
               |  |_ "mathbb" font family
               |  |_ "x" argument
               |_ "\\mathcal{x}" function apply
               |  |_ "mathcal" font family
               |  |_ "x" argument
               |_ "\\mathtt{x}" function apply
               |  |_ "mathtt" font family
               |  |_ "x" argument
               |_ "\\mathfrak{x}" function apply
               |  |_ "mathfrak" font family
               |  |_ "x" argument
               |_ "\\mathsf{x}" function apply
                  |_ "mathsf" font family
                  |_ "x" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mstyle mathvariant="bold"><mi>x</mi></mstyle><mstyle mathvariant="double-struck"><mi>x</mi></mstyle><mstyle mathvariant="script"><mi>x</mi></mstyle><mstyle mathvariant="monospace"><mi>x</mi></mstyle><mstyle mathvariant="fraktur"><mi>x</mi></mstyle><mstyle mathvariant="sans-serif"><mi>x</mi></mstyle></mstyle></math>"
               |_ "<mstyle mathvariant="bold"><mi>x</mi></mstyle>" function apply
               |  |_ "bold" font family
               |  |_ "<mi>x</mi>" argument
               |_ "<mstyle mathvariant="double-struck"><mi>x</mi></mstyle>" function apply
               |  |_ "double-struck" font family
               |  |_ "<mi>x</mi>" argument
               |_ "<mstyle mathvariant="script"><mi>x</mi></mstyle>" function apply
               |  |_ "script" font family
               |  |_ "<mi>x</mi>" argument
               |_ "<mstyle mathvariant="monospace"><mi>x</mi></mstyle>" function apply
               |  |_ "monospace" font family
               |  |_ "<mi>x</mi>" argument
               |_ "<mstyle mathvariant="fraktur"><mi>x</mi></mstyle>" function apply
               |  |_ "fraktur" font family
               |  |_ "<mi>x</mi>" argument
               |_ "<mstyle mathvariant="sans-serif"><mi>x</mi></mstyle>" function apply
                  |_ "sans-serif" font family
                  |_ "<mi>x</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "mathbf(x) mathbb(x) mathcal(x) mathtt(x) mathfrak(x) mathsf(x)"
               |_ "mathbf(x)" function apply
               |  |_ "mathbf" font family
               |  |_ "x" argument
               |_ "mathbb(x)" function apply
               |  |_ "mathbb" font family
               |  |_ "x" argument
               |_ "mathcal(x)" function apply
               |  |_ "mathcal" font family
               |  |_ "x" argument
               |_ "mathtt(x)" function apply
               |  |_ "mathtt" font family
               |  |_ "x" argument
               |_ "mathfrak(x)" function apply
               |  |_ "mathfrak" font family
               |  |_ "x" argument
               |_ "mathsf(x)" function apply
                  |_ "mathsf" font family
                  |_ "x" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end
  end

  describe "MathML input to all to_display(:lang) conversions" do
    subject(:formula) { Plurimath::Math.parse(exp, :mathml) }

    context "MathML Math zone representation of sin and simple equation #1" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mn>3</mn>
                  <mn>1</mn>
                </munderover>
                <mrow>
                  <mi>sin</mi>
                  <mi>&#x3b8;</mi>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #1' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:nary><m:naryPr><m:chr m:val="∑"/><m:limLoc m:val="undOvr"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>3</m:t></m:r></m:sub><m:sup><m:r><m:t>1</m:t></m:r></m:sup><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:e></m:nary></m:oMath></m:oMathPara>"
               |_ "<m:nary><m:naryPr><m:chr m:val="∑"/><m:limLoc m:val="undOvr"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>3</m:t></m:r></m:sub><m:sup><m:r><m:t>1</m:t></m:r></m:sup><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:e></m:nary>" summation
                  |_ "<m:t>3</m:t>" subscript
                  |_ "<m:t>1</m:t>" supscript
                  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" term
                     |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" function apply
                        |_ "sin" function name
                        |_ "<m:t>&#x3b8;</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\sum_{3}^{1} \\sin{\\theta}"
               |_ "\\sum_{3}^{1} \\sin{\\theta}" summation
                  |_ "3" subscript
                  |_ "1" supscript
                  |_ "\\sin{\\theta}" term
                     |_ "\\sin{\\theta}" function apply
                        |_ "sin" function name
                        |_ "\\theta" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><munderover><mo>&#x2211;</mo><mn>3</mn><mn>1</mn></munderover><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mstyle></math>"
               |_ "<mrow><munderover><mo>&#x2211;</mo><mn>3</mn><mn>1</mn></munderover><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow>" summation
                  |_ "<mn>3</mn>" subscript
                  |_ "<mn>1</mn>" supscript
                  |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" term
                     |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" function apply
                        |_ "sin" function name
                        |_ "<mi>&#x3b8;</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "sum_(3)^(1) sintheta"
               |_ "sum_(3)^(1) sintheta" summation
                  |_ "3" subscript
                  |_ "1" supscript
                  |_ "sintheta" term
                     |_ "sintheta" function apply
                        |_ "sin" function name
                        |_ "theta" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "MathML Math zone representation of parentheses wrapped sin equation #2" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>(</mo>
                <mi>a</mi>
                <mo>+</mo>
                <mn>1</mn>
                <mrow>
                  <mi>sin</mi>
                  <mi>&#x3b8;</mi>
                </mrow>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #1' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>1</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:e></m:d></m:oMath></m:oMathPara>"
               |_ "<m:t>a&#xa0;+&#xa0;1</m:t>" text
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" function apply
                  |_ "sin" function name
                  |_ "<m:t>&#x3b8;</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "( a + 1 \\sin{\\theta} )"
               |_ "a + 1" text
               |_ "\\sin{\\theta}" function apply
                  |_ "sin" function name
                  |_ "\\theta" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mo>(</mo><mi>a</mi><mo>+</mo><mn>1</mn><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow><mo>)</mo></mrow></mstyle></math>"
               |_ "<mtext>a + 1</mtext>" text
               |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" function apply
                  |_ "sin" function name
                  |_ "<mi>&#x3b8;</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "(a + 1 sintheta)"
               |_ "a + 1" text
               |_ "sintheta" function apply
                  |_ "sin" function name
                  |_ "theta" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "MathML Math zone representation example provided in github issue#113(AsciiMath to MathML converted) #3" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mfrac>
                <mn>1</mn>
                <mrow>
                  <mn>2</mn>
                  <mi>&#x3c0;</mi>
                </mrow>
              </mfrac>
              <mrow>
                <msubsup>
                  <mo>&#x222b;</mo>
                  <mn>0</mn>
                  <mrow>
                    <mn>2</mn>
                    <mi>&#x3c0;</mi>
                  </mrow>
                </msubsup>
                <mfrac>
                  <mrow>
                    <mstyle mathvariant="double-struck">
                      <mtext>d</mtext>
                    </mstyle>
                    <mi>&#x3b8;</mi>
                  </mrow>
                  <mrow>
                    <mi>a</mi>
                    <mo>+</mo>
                    <mi>b</mi>
                    <mrow>
                      <mi>sin</mi>
                      <mi>&#x3b8;</mi>
                    </mrow>
                  </mrow>
                </mfrac>
              </mrow>
              <mo>=</mo>
              <mfrac>
                <mn>1</mn>
                <msqrt>
                  <mrow>
                    <msup>
                      <mi>a</mi>
                      <mn>2</mn>
                    </msup>
                    <mi>−</mi>
                    <msup>
                      <mi>b</mi>
                      <mn>2</mn>
                    </msup>
                  </mrow>
                </msqrt>
              </mfrac>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #1' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:den></m:f><m:nary><m:naryPr><m:chr m:val="∫"/><m:limLoc m:val="subSup"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>0</m:t></m:r></m:sub><m:sup><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:sup><m:e><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f></m:e></m:nary><m:r><m:t>=</m:t></m:r><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad></m:den></m:f></m:oMath></m:oMathPara>"
               |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:den></m:f>" fraction
               |  |_ "<m:t>1</m:t>" numerator
               |  |_ "<m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r>" denominator
               |_ "<m:nary><m:naryPr><m:chr m:val="∫"/><m:limLoc m:val="subSup"/><m:subHide m:val="0"/><m:supHide m:val="0"/></m:naryPr><m:sub><m:r><m:t>0</m:t></m:r></m:sub><m:sup><m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r></m:sup><m:e><m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f></m:e></m:nary>" integral
               |  |_ "<m:t>0</m:t>" lower limit
               |  |_ "<m:r><m:t>2</m:t></m:r><m:r><m:t>&#x3c0;</m:t></m:r>" upper limit
               |  |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f>" integrand
               |     |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r></m:num><m:den><m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func></m:den></m:f>" fraction
               |        |_ "<m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r><m:r><m:t>&#x3b8;</m:t></m:r>" numerator
               |        |  |_ "<m:r><m:rPr><m:scr m:val="double-struck"/></m:rPr><m:t>d</m:t></m:r>" function apply
               |        |  |  |_ "double-struck" font family
               |        |  |  |_ "<m:t>d</m:t>" argument
               |        |  |_ "<m:t>&#x3b8;</m:t>" text
               |        |_ "<m:r><m:t>a</m:t></m:r><m:r><m:t>+</m:t></m:r><m:r><m:t>b</m:t></m:r><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" denominator
               |          |_ "<m:t>a&#xa0;+&#xa0;b</m:t>" text
               |          |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e></m:func>" function apply
               |             |_ "sin" function name
               |             |_ "<m:t>&#x3b8;</m:t>" argument
               |_ "<m:t>=</m:t>" text
               |_ "<m:f><m:fPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:fPr><m:num><m:r><m:t>1</m:t></m:r></m:num><m:den><m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad></m:den></m:f>" fraction
                  |_ "<m:t>1</m:t>" numerator
                  |_ "<m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad>" denominator
                    |_ "<m:rad><m:radPr><m:degHide m:val="on"/><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:radPr><m:deg/><m:e><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:e></m:rad>" function apply
                       |_ "sqrt" function name
                       |_ "<m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup><m:r><m:t>&#x2212;</m:t></m:r><m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup>" argument
                          |_ "<m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>a</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup>" superscript
                          |  |_ "<m:t>a</m:t>" base
                          |  |_ "<m:t>2</m:t>" script
                          |_ "<m:t>&#x2212;</m:t>" text
                          |_ "<m:sSup><m:sSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSupPr><m:e><m:r><m:t>b</m:t></m:r></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup>" superscript
                             |_ "<m:t>b</m:t>" base
                             |_ "<m:t>2</m:t>" script
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\frac{1}{2 \\pi} \\int_{0}^{2 \\pi} \\frac{\\mathbb{\\text{d}} \\theta}{a + b \\sin{\\theta}} = \\frac{1}{\\sqrt{a^{2} - b^{2}}}"
               |_ "\\frac{1}{2 \\pi}" fraction
               |  |_ "1" numerator
               |  |_ "2 \\pi" denominator
               |_ "\\int_{0}^{2 \\pi} \\frac{\\mathbb{\\text{d}} \\theta}{a + b \\sin{\\theta}}" integral
               |  |_ "0" lower limit
               |  |_ "2 \\pi" upper limit
               |  |_ "\\frac{\\mathbb{\\text{d}} \\theta}{a + b \\sin{\\theta}}" integrand
               |     |_ "\\frac{\\mathbb{\\text{d}} \\theta}{a + b \\sin{\\theta}}" fraction
               |        |_ "\\mathbb{\\text{d}} \\theta" numerator
               |        |  |_ "\\mathbb{\\text{d}}" function apply
               |        |  |  |_ "double-struck" font family
               |        |  |  |_ "\\text{d}" argument
               |        |  |_ "&#x3b8;" text
               |        |_ "a + b \\sin{\\theta}" denominator
               |           |_ "a + b" text
               |           |_ "\\sin{\\theta}" function apply
               |              |_ "sin" function name
               |              |_ "\\theta" argument
               |_ "=" text
               |_ "\\frac{1}{\\sqrt{a^{2} - b^{2}}}" fraction
                  |_ "1" numerator
                  |_ "\\sqrt{a^{2} - b^{2}}" denominator
                     |_ "\\sqrt{a^{2} - b^{2}}" function apply
                        |_ "sqrt" function name
                        |_ "a^{2} - b^{2}" argument
                           |_ "a^{2}" superscript
                           |  |_ "a" base
                           |  |_ "2" script
                           |_ "&#x2212;" text
                           |_ "b^{2}" superscript
                              |_ "b" base
                              |_ "2" script
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mfrac><mn>1</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></mfrac><mrow><msubsup><mo>&#x222b;</mo><mn>0</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></msubsup><mfrac><mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac></mrow><mo>=</mo><mfrac><mn>1</mn><msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt></mfrac></mrow></mstyle></math>"
               |_ "<mfrac><mn>1</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></mfrac>" fraction
               |  |_ "<mn>1</mn>" numerator
               |  |_ "<mrow><mn>2</mn><mi>&#x3c0;</mi></mrow>" denominator
               |_ "<mrow><msubsup><mo>&#x222b;</mo><mn>0</mn><mrow><mn>2</mn><mi>&#x3c0;</mi></mrow></msubsup><mfrac><mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac></mrow>" integral
               |  |_ "<mn>0</mn>" lower limit
               |  |_ "<mrow><mn>2</mn><mi>&#x3c0;</mi></mrow>" upper limit
               |  |_ "<mfrac><mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac>" integrand
               |     |_ "<mfrac><mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow><mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow></mfrac>" fraction
               |        |_ "<mrow><mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle><mi>&#x3b8;</mi></mrow>" numerator
               |        |  |_ "<mstyle mathvariant="double-struck"><mtext>d</mtext></mstyle>" function apply
               |        |  |  |_ "double-struck" font family
               |        |  |  |_ "<mtext>d</mtext>" argument
               |        |  |_ "<mtext>&#x3b8;</mtext>" text
               |        |_ "<mrow><mi>a</mi><mo>+</mo><mi>b</mi><mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow></mrow>" denominator
               |          |_ "<mtext>a + b</mtext>" text
               |          |_ "<mrow><mi>sin</mi><mi>&#x3b8;</mi></mrow>" function apply
               |             |_ "sin" function name
               |             |_ "<mi>&#x3b8;</mi>" argument
               |_ "<mtext>=</mtext>" text
               |_ "<mfrac><mn>1</mn><msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt></mfrac>" fraction
                  |_ "<mn>1</mn>" numerator
                  |_ "<msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt>" denominator
                    |_ "<msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt>" function apply
                       |_ "sqrt" function name
                       |_ "<mrow><msup><mi>a</mi><mn>2</mn></msup><mo>&#x2212;</mo><msup><mi>b</mi><mn>2</mn></msup></mrow>" argument
                          |_ "<msup><mi>a</mi><mn>2</mn></msup>" superscript
                          |  |_ "<mi>a</mi>" base
                          |  |_ "<mn>2</mn>" script
                          |_ "<mtext>&#x2212;</mtext>" text
                          |_ "<msup><mi>b</mi><mn>2</mn></msup>" superscript
                             |_ "<mi>b</mi>" base
                             |_ "<mn>2</mn>" script
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "frac(1)(2 pi) int_(0)^(2 pi) frac(mathbb("d") theta)(a + b sintheta) = frac(1)(sqrt(a^(2) - b^(2)))"
               |_ "frac(1)(2 pi)" fraction
               |  |_ "1" numerator
               |  |_ "2 pi" denominator
               |_ "int_(0)^(2 pi) frac(mathbb("d") theta)(a + b sintheta)" integral
               |  |_ "0" lower limit
               |  |_ "2 pi" upper limit
               |  |_ "frac(mathbb("d") theta)(a + b sintheta)" integrand
               |     |_ "frac(mathbb("d") theta)(a + b sintheta)" fraction
               |        |_ "mathbb("d") theta" numerator
               |        |  |_ "mathbb("d")" function apply
               |        |  |  |_ "double-struck" font family
               |        |  |  |_ ""d"" argument
               |        |  |_ "&#x3b8;" text
               |        |_ "a + b sintheta" denominator
               |           |_ "a + b" text
               |           |_ "sintheta" function apply
               |              |_ "sin" function name
               |              |_ "theta" argument
               |_ "=" text
               |_ "frac(1)(sqrt(a^(2) - b^(2)))" fraction
                  |_ "1" numerator
                  |_ "sqrt(a^(2) - b^(2))" denominator
                     |_ "sqrt(a^(2) - b^(2))" function apply
                        |_ "sqrt" function name
                        |_ "a^(2) - b^(2)" argument
                           |_ "a^(2)" superscript
                           |  |_ "a" base
                           |  |_ "2" script
                           |_ "&#x2212;" text
                           |_ "b^(2)" superscript
                              |_ "b" base
                              |_ "2" script
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "MathML Math zone representation of cos function #4" do
      let(:exp) do
        <<~MATHZONE
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
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #4' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func></m:oMath></m:oMathPara>"
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
                  |_ "cos" function name
                  |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
                     |_ "<m:t>2</m:t>" text
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\cos{( 2 )}"
               |_ "\\cos{( 2 )}" function apply
                  |_ "cos" function name
                  |_ "( 2 )" argument
                     |_ "2" text
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow></mstyle></math>"
               |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
                  |_ "cos" function name
                  |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
                     |_ "<mtext>2</mtext>" text
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "cos(2)"
               |_ "cos(2)" function apply
                  |_ "cos" function name
                  |_ "(2)" argument
                     |_ "2" text
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "MathML Math zone representation of power_base #5" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mrow>
                  <mi>cos</mi>
                  <mrow>
                    <mo>(</mo>
                    <mn>2</mn>
                    <mo>)</mo>
                  </mrow>
                </mrow>
                <mi>&#x3b8;</mi>
                <mi>&#x3c3;</mi>
              </msubsup>
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
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #5' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:sSubSup><m:sSubSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSubSupPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func></m:e><m:sub><m:r><m:t>&#x3b8;</m:t></m:r></m:sub><m:sup><m:r><m:t>&#x3c3;</m:t></m:r></m:sup></m:sSubSup><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func></m:oMath></m:oMathPara>"
               |_ "<m:sSubSup><m:sSubSupPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:sSubSupPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func></m:e><m:sub><m:r><m:t>&#x3b8;</m:t></m:r></m:sub><m:sup><m:r><m:t>&#x3c3;</m:t></m:r></m:sup></m:sSubSup>" subsup
               |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" base
               |  |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
               |  |     |_ "cos" function name
               |  |     |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
               |  |        |_ "<m:t>2</m:t>" text
               |  |_ "<m:t>&#x3b8;</m:t>" subscript
               |  |_ "<m:t>&#x3c3;</m:t>" supscript
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
                  |_ "cos" function name
                  |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
                     |_ "<m:t>2</m:t>" text
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\cos{( 2 )}_{\\theta}^{\\sigma} \\cos{( 2 )}"
               |_ "\\cos{( 2 )}_{\\theta}^{\\sigma}" subsup
               |  |_ "\\cos{( 2 )}" base
               |  |  |_ "\\cos{( 2 )}" function apply
               |  |     |_ "cos" function name
               |  |     |_ "( 2 )" argument
               |  |        |_ "2" text
               |  |_ "\\theta" subscript
               |  |_ "\\sigma" supscript
               |_ "\\cos{( 2 )}" function apply
                  |_ "cos" function name
                  |_ "( 2 )" argument
                     |_ "2" text
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><msubsup><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mi>&#x3b8;</mi><mi>&#x3c3;</mi></msubsup><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow></mrow></mstyle></math>"
               |_ "<msubsup><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mi>&#x3b8;</mi><mi>&#x3c3;</mi></msubsup>" subsup
               |  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" base
               |  |  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
               |  |     |_ "cos" function name
               |  |     |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
               |  |        |_ "<mtext>2</mtext>" text
               |  |_ "<mi>&#x3b8;</mi>" subscript
               |  |_ "<mi>&#x3c3;</mi>" supscript
               |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
                  |_ "cos" function name
                  |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
                     |_ "<mtext>2</mtext>" text
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "cos(2)_(theta)^(sigma) cos(2)"
               |_ "cos(2)_(theta)^(sigma)" subsup
               |  |_ "cos(2)" base
               |  |  |_ "cos(2)" function apply
               |  |     |_ "cos" function name
               |  |     |_ "(2)" argument
               |  |        |_ "2" text
               |  |_ "theta" subscript
               |  |_ "sigma" supscript
               |_ "cos(2)" function apply
                  |_ "cos" function name
                  |_ "(2)" argument
                     |_ "2" text
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "MathML Math zone representation of mod #6" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mrow>
                  <mi>cos</mi>
                  <mrow>
                    <mo>(</mo>
                    <mn>2</mn>
                    <mo>)</mo>
                  </mrow>
                </mrow>
                <mi>mod</mi>
                <mi>&#x3c3;</mi>
              </mrow>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #6' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r><m:r><m:t>&#x3c3;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r><m:r><m:t>&#x3c3;</m:t></m:r>" mod
                  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" base
                  |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
                  |     |_ "cos" function name
                  |     |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
                  |        |_ "<m:t>2</m:t>" text
                  |_ "<m:t>&#x3c3;</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "{\\cos{( 2 )}} \\mod {\\sigma}"
               |_ "{\\cos{( 2 )}} \\mod {\\sigma}" mod
                  |_ "\\cos{( 2 )}" base
                  |  |_ "\\cos{( 2 )}" function apply
                  |     |_ "cos" function name
                  |     |_ "( 2 )" argument
                  |        |_ "2" text
                  |_ "\\sigma" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow></mstyle></math>"
               |_ "<mrow><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow>" mod
                  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" base
                  |  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
                  |     |_ "cos" function name
                  |     |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
                  |        |_ "<mtext>2</mtext>" text
                  |_ "<mi>&#x3c3;</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "cos(2) mod sigma"
               |_ "cos(2) mod sigma" mod
                  |_ "cos(2)" base
                  |  |_ "cos(2)" function apply
                  |     |_ "cos" function name
                  |     |_ "(2)" argument
                  |        |_ "2" text
                  |_ "sigma" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "MathML Math zone representation of mod with multiple base values #7" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mrow>
                  <mo>(</mo>
                  <mrow>
                    <mi>cos</mi>
                    <mrow>
                      <mo>(</mo>
                      <mn>2</mn>
                      <mo>)</mo>
                    </mrow>
                  </mrow>
                  <mrow>
                    <mi>sin</mi>
                    <mrow>
                      <mo>(</mo>
                      <mn>3</mn>
                      <mo>)</mo>
                    </mrow>
                  </mrow>
                  <mo>)</mo>
                </mrow>
                <mi>mod</mi>
                <mi>&#x3c3;</mi>
              </mrow>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #7' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>3</m:t></m:r></m:e></m:d></m:e></m:func></m:e></m:d><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r><m:r><m:t>&#x3c3;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>3</m:t></m:r></m:e></m:d></m:e></m:func></m:e></m:d><m:r><m:rPr><m:sty m:val="p"/></m:rPr><m:t>mod</m:t></m:r><m:r><m:t>&#x3c3;</m:t></m:r>" mod
                  |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func><m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>3</m:t></m:r></m:e></m:d></m:e></m:func></m:e></m:d>" base
                  |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>cos</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
                  |     |_ "cos" function name
                  |     |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>2</m:t></m:r></m:e></m:d>" argument
                  |        |_ "<m:t>2</m:t>" text
                  |  |_ "<m:func><m:funcPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:funcPr><m:fName><m:r><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr><m:t>sin</m:t></m:r></m:fName><m:e><m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>3</m:t></m:r></m:e></m:d></m:e></m:func>" function apply
                  |     |_ "sin" function name
                  |     |_ "<m:d><m:dPr><m:begChr m:val="("/><m:sepChr m:val=""/><m:endChr m:val=")"/></m:dPr><m:e><m:r><m:t>3</m:t></m:r></m:e></m:d>" argument
                  |        |_ "<m:t>3</m:t>" text
                  |_ "<m:t>&#x3c3;</m:t>" argument
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "{( \\cos{( 2 )} \\sin{( 3 )} )} \\mod {\\sigma}"
               |_ "{( \\cos{( 2 )} \\sin{( 3 )} )} \\mod {\\sigma}" mod
                  |_ "( \\cos{( 2 )} \\sin{( 3 )} )" base
                  |  |_ "\\cos{( 2 )}" function apply
                  |  |  |_ "cos" function name
                  |  |  |_ "( 2 )" argument
                  |  |     |_ "2" text
                  |  |_ "\\sin{( 3 )}" function apply
                  |     |_ "sin" function name
                  |     |_ "( 3 )" argument
                  |        |_ "3" text
                  |_ "\\sigma" argument
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mrow><mo>(</mo><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mrow><mi>sin</mi><mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow></mrow><mo>)</mo></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow></mstyle></math>"
               |_ "<mrow><mrow><mo>(</mo><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mrow><mi>sin</mi><mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow></mrow><mo>)</mo></mrow><mi>mod</mi><mi>&#x3c3;</mi></mrow>" mod
                  |_ "<mrow><mo>(</mo><mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow><mrow><mi>sin</mi><mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow></mrow><mo>)</mo></mrow>" base
                  |  |_ "<mrow><mi>cos</mi><mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow></mrow>" function apply
                  |  |  |_ "cos" function name
                  |  |  |_ "<mrow><mo>(</mo><mn>2</mn><mo>)</mo></mrow>" argument
                  |  |     |_ "<mtext>2</mtext>" text
                  |  |_ "<mrow><mi>sin</mi><mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow></mrow>" function apply
                  |     |_ "sin" function name
                  |     |_ "<mrow><mo>(</mo><mn>3</mn><mo>)</mo></mrow>" argument
                  |        |_ "<mtext>3</mtext>" text
                  |_ "<mi>&#x3c3;</mi>" argument
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "(cos(2) sin(3)) mod sigma"
               |_ "(cos(2) sin(3)) mod sigma" mod
                  |_ "(cos(2) sin(3))" base
                  |  |_ "cos(2)" function apply
                  |  |  |_ "cos" function name
                  |  |  |_ "(2)" argument
                  |  |     |_ "2" text
                  |  |_ "sin(3)" function apply
                  |     |_ "sin" function name
                  |     |_ "(3)" argument
                  |        |_ "3" text
                  |_ "sigma" argument
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "MathML Math zone representation of table #8" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mo>[</mo>
                <mtable>
                  <mtr>
                    <mtd>
                      <mi>&#x3c3;</mi>
                    </mtd>
                    <mtd>
                      <mi>&#x3b3;</mi>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mi>&#x3b8;</mi>
                    </mtd>
                    <mtd>
                      <mi>&#x3b1;</mi>
                    </mtd>
                  </mtr>
                </mtable>
                <mo>]</mo>
              </mrow>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #8' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:d><m:dPr><m:begChr m:val="["/><m:endChr m:val="]"/><m:sepChr m:val=""/><m:grow/></m:dPr><m:e><m:m><m:mPr><m:mcs><m:mc><m:mcPr><m:count m:val="2"/><m:mcJc m:val="center"/></m:mcPr></m:mc></m:mcs><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:mPr><m:mr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:e><m:r><m:t>&#x3b3;</m:t></m:r></m:e></m:mr><m:mr><m:e><m:r><m:t>&#x3b8;</m:t></m:r></m:e><m:e><m:r><m:t>&#x3b1;</m:t></m:r></m:e></m:mr></m:m></m:e></m:d></m:oMath></m:oMathPara>"
               |_ "table" function apply
                  |_ "tr" function apply
                  |  |_ "td" function apply
                  |  |  |_ "<m:t>&#x3c3;</m:t>" text
                  |  |_ "td" function apply
                  |     |_ "<m:t>&#x3b3;</m:t>" text
                  |_ "tr" function apply
                     |_ "td" function apply
                     |  |_ "<m:t>&#x3b8;</m:t>" text
                     |_ "td" function apply
                        |_ "<m:t>&#x3b1;</m:t>" text
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\left [\\begin{matrix}\\sigma & \\gamma \\\\ \\theta & \\alpha\\end{matrix}\\right ]"
               |_ "table" function apply
                  |_ "tr" function apply
                  |  |_ "td" function apply
                  |  |  |_ "&#x3c3;" text
                  |  |_ "td" function apply
                  |     |_ "&#x3b3;" text
                  |_ "tr" function apply
                     |_ "td" function apply
                     |  |_ "&#x3b8;" text
                     |_ "td" function apply
                        |_ "&#x3b1;" text
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mrow><mo>[</mo><mtable><mtr><mtd><mi>&#x3c3;</mi></mtd><mtd><mi>&#x3b3;</mi></mtd></mtr><mtr><mtd><mi>&#x3b8;</mi></mtd><mtd><mi>&#x3b1;</mi></mtd></mtr></mtable><mo>]</mo></mrow></mstyle></math>"
               |_ "table" function apply
                  |_ "tr" function apply
                  |  |_ "td" function apply
                  |  |  |_ "<mtext>&#x3c3;</mtext>" text
                  |  |_ "td" function apply
                  |     |_ "<mtext>&#x3b3;</mtext>" text
                  |_ "tr" function apply
                     |_ "td" function apply
                     |  |_ "<mtext>&#x3b8;</mtext>" text
                     |_ "td" function apply
                        |_ "<mtext>&#x3b1;</mtext>" text
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "[[sigma, gamma], [theta, alpha]]"
               |_ "table" function apply
                  |_ "tr" function apply
                  |  |_ "td" function apply
                  |  |  |_ "&#x3c3;" text
                  |  |_ "td" function apply
                  |     |_ "&#x3b3;" text
                  |_ "tr" function apply
                     |_ "td" function apply
                     |  |_ "&#x3b8;" text
                     |_ "td" function apply
                        |_ "&#x3b1;" text
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "MathML Math zone representation of overset #9" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mi>&#x3b8;</mi>
                <mi>&#x3c3;</mi>
              </mover>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #9' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limUpp></m:oMath></m:oMathPara>"
               |_ "<m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limUpp>" overset
                  |_ "<m:t>&#x3c3;</m:t>" base
                  |_ "<m:t>&#x3b8;</m:t>" supscript
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\overset{\\sigma}{\\theta}"
               |_ "\\overset{\\sigma}{\\theta}" overset
                  |_ "\\sigma" base
                  |_ "\\theta" supscript
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mover><mi>&#x3b8;</mi><mi>&#x3c3;</mi></mover></mstyle></math>"
               |_ "<mover><mi>&#x3b8;</mi><mi>&#x3c3;</mi></mover>" overset
                  |_ "<mi>&#x3c3;</mi>" base
                  |_ "<mi>&#x3b8;</mi>" supscript
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "overset(sigma)(theta)"
               |_ "overset(sigma)(theta)" overset
                  |_ "sigma" base
                  |_ "theta" supscript
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "MathML Math zone representation of underset #10" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mi>&#x3b8;</mi>
                <mi>&#x3c3;</mi>
              </munder>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #10' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:limLow><m:limLowPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limLowPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limLow></m:oMath></m:oMathPara>"
               |_ "<m:limLow><m:limLowPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limLowPr><m:e><m:r><m:t>&#x3c3;</m:t></m:r></m:e><m:lim><m:r><m:t>&#x3b8;</m:t></m:r></m:lim></m:limLow>" underscript
                  |_ "<m:t>&#x3c3;</m:t>" underscript value
                  |_ "<m:t>&#x3b8;</m:t>" base expression
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "\\underset{\\sigma}{\\theta}"
               |_ "\\underset{\\sigma}{\\theta}" underscript
                  |_ "\\sigma" underscript value
                  |_ "\\theta" base expression
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><munder><mi>&#x3b8;</mi><mi>&#x3c3;</mi></munder></mstyle></math>"
               |_ "<munder><mi>&#x3b8;</mi><mi>&#x3c3;</mi></munder>" underscript
                  |_ "<mi>&#x3c3;</mi>" underscript value
                  |_ "<mi>&#x3b8;</mi>" base expression
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "underset(sigma)(theta)"
               |_ "underset(sigma)(theta)" underscript
                  |_ "sigma" underscript value
                  |_ "theta" base expression
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation of color #11" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mstyle mathcolor="red">
                <mi>&#x3b8;</mi>
              </mstyle>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #11' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:r><m:t>&#x3b8;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "<m:r><m:t>&#x3b8;</m:t></m:r>" color
                  |_ "<m:t>&#x3b8;</m:t>" text
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "{\\color{"red"} \\theta}"
               |_ "{\\color{"red"} \\theta}" color
                  |_ "\\text{red}" mathcolor
                  |_ "\\theta" text
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><mstyle mathcolor="red"><mi>&#x3b8;</mi></mstyle></mstyle></math>"
               |_ "<mstyle mathcolor="red"><mi>&#x3b8;</mi></mstyle>" color
                  |_ "<mtext>red</mtext>" mathcolor
                  |_ "<mi>&#x3b8;</mi>" text
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "color("red")(theta)"
               |_ "color("red")(theta)" color
                  |_ ""red"" mathcolor
                  |_ "theta" text
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end

    context "AsciiMath Math zone representation of four unary functions #12" do
      let(:exp) do
        <<~MATHZONE
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msgroup displaystyle="true">
                <mrow>
                  <mo>|</mo>
                  <mi>x</mi>
                  <mo>|</mo>
                </mrow>
                <mrow>
                  <mo>&#x230a;</mo>
                  <mi>x</mi>
                  <mo>&#x230b;</mo>
                </mrow>
                <mrow>
                  <mo>&#x2308;</mo>
                  <mi>x</mi>
                  <mo>&#x2309;</mo>
                </mrow>
                <mrow>
                  <mo>&#x2225;</mo>
                  <mover>
                    <mi>x</mi>
                    <mo>&#x2192;</mo>
                  </mover>
                  <mo>&#x2225;</mo>
                </mrow>
              </msgroup>
            </mstyle>
          </math>
        MATHZONE
      end

      it 'should puts Math zone representation of sample example #12' do
        omml = <<~OMML
          |_ Math zone
            |_ "<m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"><m:oMath><m:r><m:t>|</m:t></m:r><m:r><m:t>x</m:t></m:r><m:r><m:t>|</m:t></m:r><m:d><m:dPr><m:begChr m:val="&#x230a;"/><m:sepChr m:val=""/><m:endChr m:val="&#x230b;"/></m:dPr><m:e><m:r><m:t>x</m:t></m:r></m:e></m:d><m:d><m:dPr><m:begChr m:val="&#x2308;"/><m:sepChr m:val=""/><m:endChr m:val="&#x2309;"/></m:dPr><m:e><m:r><m:t>x</m:t></m:r></m:e></m:d><m:r><m:t>&#x2225;</m:t></m:r><m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>x</m:t></m:r></m:e><m:lim><m:r><m:t>→</m:t></m:r></m:lim></m:limUpp><m:r><m:t>&#x2225;</m:t></m:r></m:oMath></m:oMathPara>"
               |_ "msgroup" function apply
                  |_ "<m:t>|&#xa0;x&#xa0;|</m:t>" text
                  |_ "<m:t>x</m:t>" text
                  |_ "<m:t>x</m:t>" text
                  |_ "<m:t>&#x2225;</m:t>" text
                  |_ "<m:limUpp><m:limUppPr><m:ctrlPr><w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr></m:ctrlPr></m:limUppPr><m:e><m:r><m:t>x</m:t></m:r></m:e><m:lim><m:r><m:t>→</m:t></m:r></m:lim></m:limUpp>" overset
                  |  |_ "<m:t>&#x2192;</m:t>" base
                  |  |_ "<m:t>x</m:t>" supscript
                  |_ "<m:t>&#x2225;</m:t>" text
        OMML
        latex = <<~LATEX
          |_ Math zone
            |_ "| x |\\lfloor x \\rfloor\\lceil x \\rceil\\rVert \\vec{x} \\rVert"
               |_ "msgroup" function apply
                  |_ "| x |" text
                  |_ "x" text
                  |_ "x" text
                  |_ "&#x2225;" text
                  |_ "\\vec{x}" function apply
                  |  |_ "vec" function name
                  |  |_ "x" supscript
                  |_ "&#x2225;" text
        LATEX
        mathml = <<~MATHML
          |_ Math zone
            |_ "<math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><mstyle displaystyle="true"><msgroup><mrow><mo>|</mo><mi>x</mi><mo>|</mo></mrow><mrow><mo>&#x230a;</mo><mi>x</mi><mo>&#x230b;</mo></mrow><mrow><mo>&#x2308;</mo><mi>x</mi><mo>&#x2309;</mo></mrow><mrow><mi>&#x2225;</mi><mover><mi>x</mi><mo>&#x2192;</mo></mover><mi>&#x2225;</mi></mrow></msgroup></mstyle></math>"
               |_ "msgroup" function apply
                  |_ "<mtext>| x |</mtext>" text
                  |_ "<mtext>x</mtext>" text
                  |_ "<mtext>x</mtext>" text
                  |_ "<mtext>&#x2225;</mtext>" text
                  |_ "<mover><mi>x</mi><mo>&#x2192;</mo></mover>" overset
                  |  |_ "<mo>&#x2192;</mo>" base
                  |  |_ "<mi>x</mi>" supscript
                  |_ "<mtext>&#x2225;</mtext>" text
        MATHML
        asciimath = <<~ASCIIMATH
          |_ Math zone
            |_ "| x ||__x__||~x~|rVert vec(x) rVert"
               |_ "msgroup" function apply
                  |_ "| x |" text
                  |_ "x" text
                  |_ "x" text
                  |_ "&#x2225;" text
                  |_ "vec(x)" function apply
                  |  |_ "vec" function name
                  |  |_ "x" supscript
                  |_ "&#x2225;" text
        ASCIIMATH
        expect(formula.to_display(:omml)).to eql(omml)
        expect(formula.to_display(:latex)).to eql(latex)
        expect(formula.to_display(:mathml)).to eql(mathml)
        expect(formula.to_display(:asciimath)).to eql(asciimath)
      end
    end
  end
end
