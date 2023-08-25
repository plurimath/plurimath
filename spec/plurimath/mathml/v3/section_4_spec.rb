require_relative "../../../../spec/spec_helper"

RSpec.describe Plurimath::Mathml::Parser do

  subject(:formula) { Plurimath::Mathml::Parser.new(exp).parse }

  context "contains mathml v3 #4 example #71" do
    let(:exp) {
      <<~MATHML
        <math>
          <mn>0x7F800000</mn>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Number.new("0x7F800000")
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #72" do
    let(:exp) {
      <<~MATHML
        <math>
          <msub>
            <mn>7FE0</mn>
            <mn>16</mn>
          </msub>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Base.new(
          Plurimath::Math::Symbol.new("7FE0"),
          Plurimath::Math::Symbol.new("16")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #73" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mn>22</mn>
            <mo>/</mo>
            <mn>7</mn>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("22"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Symbol.new("7")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #74" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
             <mn>12.3</mn>
             <mo>+</mo>
             <mn>5</mn>
             <mo>&#x2062;<!--INVISIBLE TIMES--></mo>
             <mi>i</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("12.3"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Number.new("5"),
          Plurimath::Math::Symbol.new("&#x2062;"),
          Plurimath::Math::Symbol.new("i")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #75" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>Polar</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mn>2</mn>
              <mn>3.1415</mn>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("Polar"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Number.new("3.1415")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #76" do
    let(:exp) {
      <<~MATHML
        <math>
          <msup>
            <mi>C</mi>
            <mn>2</mn>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Symbol.new("C"),
          Plurimath::Math::Number.new("2"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #77" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>{</mo>
            <ms>A</ms>
            <mo>,</mo>
            <ms>B</ms>
            <mo>,</mo>
            <ms>&#xa0;<!--NO-BREAK SPACE-->&#xa0;<!--NO-BREAK SPACE--></ms>
            <mo>}</mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("{"),
          [
            Plurimath::Math::Function::Text.new("A"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Function::Text.new("B"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Function::Text.new("&#xa0;"),
          ],
          Plurimath::Math::Symbol.new("}"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #78" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            F
            <mo>&#x2061;</mo>
            <mrow>
              <mo fence="true">(</mo>
              A1
              <mo separator="true">,</mo>
              ...
              <mo separator="true">,</mo>
              A2
              <mo separator="true">,</mo>
              An
              <mo fence="true">)</mo>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#xa;    F&#xa;    "),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("&#xa;      A1&#xa;      "),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("&#xa;      ...&#xa;      "),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("&#xa;      A2&#xa;      "),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("&#xa;      An&#xa;      "),
            ],
            Plurimath::Math::Symbol.new(")")
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #79" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <munder>
              Op
              <mrow> X <mo>&#x2208;</mo><!--ELEMENT OF--> D </mrow>
            </munder>
            <mo>&#x2061;</mo><!--FUNCTION APPLICATION-->
            <mrow>
              <mo fence="true">(</mo>
              Expression-in-X
              <mo fence="true">)</mo>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(" X "),
              Plurimath::Math::Symbol.new("&#x2208;"),
              Plurimath::Math::Symbol.new(" D ")
            ]),
            Plurimath::Math::Symbol.new("&#xa;      Op&#xa;      ")
          ),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("&#xa;      Expression-in-X&#xa;      "),
            ],
            Plurimath::Math::Symbol.new(")")
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #80" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            B
            <mrow>
              x1
              <mo separator="true">,</mo>
              ...
              <mo separator="true">,</mo>
              xn
            </mrow>
            <mo separator="true">.</mo>
            S
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#xa;    B&#xa;    "),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("&#xa;      x1&#xa;      "),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Symbol.new("&#xa;      ...&#xa;      "),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Symbol.new("&#xa;      xn&#xa;    ")
          ]),
          Plurimath::Math::Symbol.new("."),
          Plurimath::Math::Symbol.new("&#xa;    S&#xa;  ")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #81" do
    let(:exp) {
      <<~MATHML
        <math>
          <merror>
            <mtext>DivisionByZero:&#160;</mtext>
            <mfrac>
              <mi>x</mi>
              <mn>0</mn>
            </mfrac>
          </merror>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Merror.new(
          Plurimath::Math::Function::Text.new("DivisionByZero:&#xa0;"),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Number.new("0")
          )
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #82" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfenced>
            <mi>x</mi>
            <mn>1</mn>
          </mfenced>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          [
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Number.new("1"),
          ],
          Plurimath::Math::Symbol.new(")"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #83" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfenced open="[" close="]">
            <mn>0</mn>
            <mn>1</mn>
          </mfenced>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("["),
          [
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Number.new("1"),
          ],
          Plurimath::Math::Symbol.new("]"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #84" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfenced open="(" close="]">
            <mn>0</mn>
            <mn>1</mn>
          </mfenced>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          [
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Number.new("1"),
          ],
          Plurimath::Math::Symbol.new("]"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #85" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfenced open="[" close=")">
            <mn>0</mn>
            <mn>1</mn>
          </mfenced>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("["),
          [
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Number.new("1"),
          ],
          Plurimath::Math::Symbol.new(")"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #86" do
    let(:exp) {
      <<~MATHML
        <math>
          <msup>
            <mi>f</mi>
            <mrow>
              <mo>(</mo>
              <mn>-1</mn>
              <mo>)</mo>
            </mrow>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Symbol.new("f"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Number.new("-1"),
            ],
            Plurimath::Math::Symbol.new(")")
          )
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #87" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <msup>
              <mi>A</mi>
              <mrow>
                <mo>(</mo>
                <mn>-1</mn>
                <mo>)</mo>
              </mrow>
            </msup>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mi>a</mi>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("A"),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Number.new("-1"),
              ],
              Plurimath::Math::Symbol.new(")")
            )
          ),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("a")
            ],
            Plurimath::Math::Symbol.new(")"),
          ),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #88" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>&#x3bb;<!--GREEK SMALL LETTER LAMDA--></mi>
            <mi>x</mi>
            <mo>.</mo>
            <mfenced>
              <mrow>
                <mi>sin</mi>
                <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
                <mrow>
                  <mo>(</mo>
                  <mi>x</mi>
                  <mo>+</mo>
                  <mn>1</mn>
                  <mo>)</mo>
                </mrow>
              </mrow>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3bb;"),
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("."),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Sin.new(
                  Plurimath::Math::Symbol.new("&#x2061;"),
                ),
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbol.new("("),
                  [
                    Plurimath::Math::Symbol.new("x"),
                    Plurimath::Math::Symbol.new("+"),
                    Plurimath::Math::Number.new("1"),
                  ],
                  Plurimath::Math::Symbol.new(")")
                )
              ])
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #89" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>x</mi>
            <mo>&#x21a6;<!--RIGHTWARDS ARROW FROM BAR--></mo>
            <mrow>
              <mi>sin</mi>
              <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>+</mo>
                <mn>1</mn>
                <mo>)</mo>
              </mrow>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("&#x21a6;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Sin.new(
              Plurimath::Math::Symbol.new("&#x2061;"),
            ),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("1"),
              ],
              Plurimath::Math::Symbol.new(")")
            )
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #90" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>f</mi>
            <mo>&#x2218;<!--RING OPERATOR--></mo>
            <mi>g</mi>
            <mo>&#x2218;<!--RING OPERATOR--></mo>
            <mi>h</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("f"),
          Plurimath::Math::Symbol.new("&#x2218;"),
          Plurimath::Math::Symbol.new("g"),
          Plurimath::Math::Symbol.new("&#x2218;"),
          Plurimath::Math::Symbol.new("h")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #91" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mrow>
              <mrow>
                <mo>(</mo>
                <mi>f</mi>
                <mo>&#x2218;<!--RING OPERATOR--></mo>
                <mi>g</mi>
                <mo>)</mo>
              </mrow>
              <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
              <mfenced>
                <mi>x</mi>
              </mfenced>
            </mrow>
            <mo>=</mo>
            <mrow>
              <mi>f</mi>
              <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
              <mfenced>
                <mrow>
                  <mi>g</mi>
                  <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
                  <mfenced>
                    <mi>x</mi>
                  </mfenced>
                </mrow>
              </mfenced>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("f"),
                Plurimath::Math::Symbol.new("&#x2218;"),
                Plurimath::Math::Symbol.new("g"),
              ],
              Plurimath::Math::Symbol.new(")")
            ),
            Plurimath::Math::Symbol.new("&#x2061;"),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("x")
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("f"),
            Plurimath::Math::Symbol.new("&#x2061;"),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("g"),
                  Plurimath::Math::Symbol.new("&#x2061;"),
                  Plurimath::Math::Function::Fenced.new(
                    Plurimath::Math::Symbol.new("("),
                    [
                      Plurimath::Math::Symbol.new("x")
                    ],
                    Plurimath::Math::Symbol.new(")"),
                  )
                ])
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #92" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mrow>
              <mi>f</mi>
              <mo>&#x2218;<!--RING OPERATOR--></mo>
              <msup>
                <mi>f</mi>
                <mrow>
                  <mo>(</mo>
                  <mn>-1</mn>
                  <mo>)</mo>
                </mrow>
              </msup>
            </mrow>
            <mo>=</mo>
            <mi>id</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("f"),
            Plurimath::Math::Symbol.new("&#x2218;"),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new("f"),
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbol.new("("),
                [
                  Plurimath::Math::Number.new("-1"),
                ],
                Plurimath::Math::Symbol.new(")")
              ),
            )
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("id")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #93" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mrow>
              <mi>domain</mi>
              <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
              <mfenced>
                <mi>f</mi>
              </mfenced>
            </mrow>
            <mo>=</mo>
            <mi mathvariant="double-struck">R</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("domain"),
            Plurimath::Math::Symbol.new("&#x2061;"),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("f")
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::FontStyle::DoubleStruck.new(
            Plurimath::Math::Symbol.new("R"),
            "double-struck",
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #94" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mrow>
              <mi>codomain</mi>
              <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
              <mfenced>
                <mi>f</mi>
              </mfenced>
            </mrow>
            <mo>=</mo>
            <mi mathvariant="double-struck">Q</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("codomain"),
            Plurimath::Math::Symbol.new("&#x2061;"),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("f")
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::FontStyle::DoubleStruck.new(
            Plurimath::Math::Symbol.new("Q"),
            "double-struck"
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #95" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mrow>
              <mi>image</mi>
              <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
              <mfenced>
                <mi>sin</mi>
              </mfenced>
            </mrow>
            <mo>=</mo>
            <mfenced open="[" close="]">
              <mn>-1</mn>
              <mn>1</mn>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("image"),
            Plurimath::Math::Symbol.new("&#x2061;"),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Function::Sin.new
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("["),
            [
              Plurimath::Math::Number.new("-1"),
              Plurimath::Math::Number.new("1")
            ],
            Plurimath::Math::Symbol.new("]"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #96" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>{</mo>
            <mtable>
              <mtr>
                <mtd>
                  <mrow>
                    <mo>&#x2212;<!--MINUS SIGN--></mo>
                    <mi>x</mi>
                  </mrow>
                </mtd>
                <mtd columnalign="left">
                  <mtext>&#xa0;<!--NO-BREAK SPACE--> if &#xa0;<!--NO-BREAK SPACE--></mtext>
                </mtd>
                <mtd>
                  <mrow>
                    <mi>x</mi>
                    <mo>&lt;</mo>
                    <mn>0</mn>
                  </mrow>
                </mtd>
              </mtr>
              <mtr>
                <mtd>
                  <mn>0</mn>
                </mtd>
                <mtd columnalign="left">
                  <mtext>&#xa0;<!--NO-BREAK SPACE--> if &#xa0;<!--NO-BREAK SPACE--></mtext>
                </mtd>
                <mtd>
                  <mrow>
                    <mi>x</mi>
                    <mo>=</mo>
                    <mn>0</mn>
                  </mrow>
                </mtd>
              </mtr>
              <mtr>
                <mtd>
                  <mi>x</mi>
                </mtd>
                <mtd columnalign="left">
                  <mtext>&#xa0;<!--NO-BREAK SPACE--> if &#xa0;<!--NO-BREAK SPACE--></mtext>
                </mtd>
                <mtd>
                  <mrow>
                    <mi>x</mi>
                    <mo>&gt;</mo>
                    <mn>0</mn>
                  </mrow>
                </mtd>
              </mtr>
            </mtable>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("{"),
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("&#x2212;"),
                    Plurimath::Math::Symbol.new("x")
                  ])
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("&#xa0; if &#xa0;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("x"),
                    Plurimath::Math::Symbol.new("&#x3c;"),
                    Plurimath::Math::Number.new("0")
                  ])
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("0")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("&#xa0; if &#xa0;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("x"),
                    Plurimath::Math::Symbol.new("="),
                    Plurimath::Math::Number.new("0")
                  ])
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("x")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("&#xa0; if &#xa0;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("x"),
                    Plurimath::Math::Symbol.new("&#x3e;"),
                    Plurimath::Math::Number.new("0")
                  ])
                ])
              ])
            ],
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #97" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x230a;<!--LEFT FLOOR--></mo>
            <mi>a</mi>
            <mo>/</mo>
            <mi>b</mi>
            <mo>&#x230b;<!--RIGHT FLOOR--></mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("&#x230a;"),
          [
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Symbol.new("/"),
            Plurimath::Math::Symbol.new("b"),
          ],
          Plurimath::Math::Symbol.new("&#x230b;")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #98" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>n</mi>
            <mo>!</mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("n"),
          Plurimath::Math::Symbol.new("!"),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #99" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>a</mi>
            <mo>/</mo>
            <mi>b</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Symbol.new("b"),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #100" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>max</mi>
            <mrow>
              <mo>{</mo>
              <mn>2</mn>
              <mo>,</mo>
              <mn>3</mn>
              <mo>,</mo>
              <mn>5</mn>
              <mo>}</mo>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Max.new(
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("{"),
            [
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Number.new("5"),
            ],
            Plurimath::Math::Symbol.new("}")
          )
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #101" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>max</mi>
            <mrow>
              <mo>{</mo>
              <mi>y</mi>
              <mo>|</mo>
              <mrow>
                <msup>
                  <mi>y</mi>
                  <mn>3</mn>
                </msup>
                <mo>&#x2208;<!--ELEMENT OF--></mo>
                <mfenced open="[" close="]">
                  <mn>0</mn>
                  <mn>1</mn>
                </mfenced>
              </mrow>
              <mo>}</mo>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Max.new(
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("{"),
            [
              Plurimath::Math::Symbol.new("y"),
              Plurimath::Math::Symbol.new("|"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbol.new("y"),
                  Plurimath::Math::Number.new("3")
                ),
                Plurimath::Math::Symbol.new("&#x2208;"),
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbol.new("["),
                  [
                    Plurimath::Math::Number.new("0"),
                    Plurimath::Math::Number.new("1")
                  ],
                  Plurimath::Math::Symbol.new("]"),
                )
              ]),
            ],
            Plurimath::Math::Symbol.new("}")
          )
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #102" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>min</mi>
            <mrow>
              <mo>{</mo>
              <mi>a</mi>
              <mo>,</mo>
              <mi>b</mi>
              <mo>}</mo>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Min.new(
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("{"),
            [
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("b"),
            ],
            Plurimath::Math::Symbol.new("}")
          )
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #103" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>min</mi>
            <mrow>
              <mo>{</mo>
              <msup>
                <mi>x</mi>
                <mn>2</mn>
              </msup>
              <mo>|</mo>
              <mrow>
                <mi>x</mi>
                <mo>&#x2209;<!--NOT AN ELEMENT OF--></mo>
                <mi>B</mi>
              </mrow>
              <mo>}</mo>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Min.new(
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("{"),
            [
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Number.new("2")
              ),
              Plurimath::Math::Symbol.new("|"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Symbol.new("&#x2209;"),
                Plurimath::Math::Symbol.new("B")
              ]),
            ],
            Plurimath::Math::Symbol.new("}")
          )
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #104" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x2212;<!--MINUS SIGN--></mo>
            <mn>3</mn>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2212;"),
          Plurimath::Math::Number.new("3"),
        ]),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #105" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>x</mi>
            <mo>&#x2212;<!--MINUS SIGN--></mo>
            <mi>y</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("&#x2212;"),
          Plurimath::Math::Symbol.new("y"),
        ]),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #106" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>x</mi>
            <mo>+</mo>
            <mi>y</mi>
            <mo>+</mo>
            <mi>z</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("y"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("z"),
        ]),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #107" do
    let(:exp) {
      <<~MATHML
        <math>
          <msup>
            <mi>x</mi>
            <mn>3</mn>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Number.new("3"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #108" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>a</mi>
            <mo>mod</mo>
            <mi>b</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Mod.new(
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Number.new("b"),
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #109" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>a</mi>
            <mo>&#x2062;<!--INVISIBLE TIMES--></mo>
            <mi>b</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("&#x2062;"),
          Plurimath::Math::Symbol.new("b")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #110" do
    let(:exp) {
      <<~MATHML
        <math>
          <mroot>
            <mi>a</mi>
            <mi>n</mi>
          </mroot>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Root.new(
          Plurimath::Math::Symbol.new("n"),
          Plurimath::Math::Symbol.new("a"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #111" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>gcd</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mi>a</mi>
              <mi>b</mi>
              <mi>c</mi>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Gcd.new(
            Plurimath::Math::Symbol.new("&#x2061;"),
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Symbol.new("b"),
              Plurimath::Math::Symbol.new("c")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #112" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>a</mi>
            <mo>&#x2227;<!--LOGICAL AND--></mo>
            <mi>b</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("&#x2227;"),
          Plurimath::Math::Symbol.new("b")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #113" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <munderover>
              <mo>&#x22C0;<!--N-ARY LOGICAL AND--></mo>
              <mrow>
                <mi>i</mi>
                <mo>=</mo>
                <mn>0</mn>
              </mrow>
              <mi>n</mi>
            </munderover>
            <mrow>
              <mo>(</mo>
              <msub>
                <mi>a</mi>
                <mi>i</mi>
              </msub>
              <mo>&gt;</mo>
              <mn>0</mn>
              <mo>)</mo>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new(
          [
            Plurimath::Math::Function::Underover.new(
              Plurimath::Math::Symbol.new("&#x22c0;"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("i"),
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Number.new("0")
              ]),
              Plurimath::Math::Symbol.new("n"),
            ),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Symbol.new("a"),
                  Plurimath::Math::Symbol.new("i")
                ),
                Plurimath::Math::Symbol.new("&#x3e;"),
                Plurimath::Math::Number.new("0"),
              ],
              Plurimath::Math::Symbol.new(")")
            )
          ],
          false
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #114" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>a</mi>
            <mo>&#x2228;<!--LOGICAL OR--></mo>
            <mi>b</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("&#x2228;"),
          Plurimath::Math::Symbol.new("b"),
        ]),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #115" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>a</mi>
            <mo>xor</mo>
            <mi>b</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("xor"),
          Plurimath::Math::Symbol.new("b"),
        ]),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #116" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#xac;<!--NOT SIGN--></mo>
            <mi>a</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#xac;"),
          Plurimath::Math::Symbol.new("a"),
        ]),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #117" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>A</mi>
            <mo>&#x21d2;<!--RIGHTWARDS DOUBLE ARROW--></mo>
            <mi>B</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("A"),
          Plurimath::Math::Symbol.new("&#x21d2;"),
          Plurimath::Math::Symbol.new("B"),
        ]),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #118" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x2200;<!--FOR ALL--></mo>
            <mi>x</mi>
            <mo>.</mo>
            <mfenced>
              <mrow>
                <mrow>
                  <mi>x</mi>
                  <mo>&#x2212;<!--MINUS SIGN--></mo>
                  <mi>x</mi>
                </mrow>
                <mo>=</mo>
                <mn>0</mn>
              </mrow>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2200;"),
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("."),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Formula.new([
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Symbol.new("&#x2212;"),
                  Plurimath::Math::Symbol.new("x")
                ]),
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Number.new("0")
              ])
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #119" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x2200;<!--FOR ALL--></mo>
            <mrow>
              <mrow>
                <mi>p</mi>
                <mo>&#x2208;<!--ELEMENT OF--></mo>
                <mi mathvariant="double-struck">Q</mi>
              </mrow>
              <mo>&#x2227;<!--LOGICAL AND--></mo>
              <mrow>
                <mi>q</mi>
                <mo>&#x2208;<!--ELEMENT OF--></mo>
                <mi mathvariant="double-struck">Q</mi>
              </mrow>
              <mo>&#x2227;<!--LOGICAL AND--></mo>
              <mrow>
                <mo>(</mo>
                <mi>p</mi>
                <mo>&lt;</mo>
                <mi>q</mi>
                <mo>)</mo>
              </mrow>
            </mrow>
            <mo>.</mo>
            <mfenced>
              <mrow>
                <mi>p</mi>
                <mo>&lt;</mo>
                <msup>
                  <mi>q</mi>
                  <mn>2</mn>
                </msup>
              </mrow>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2200;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("p"),
              Plurimath::Math::Symbol.new("&#x2208;"),
              Plurimath::Math::Function::FontStyle::DoubleStruck.new(
                Plurimath::Math::Symbol.new("Q"),
                "double-struck",
              )
            ]),
            Plurimath::Math::Symbol.new("&#x2227;"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("q"),
              Plurimath::Math::Symbol.new("&#x2208;"),
              Plurimath::Math::Function::FontStyle::DoubleStruck.new(
                Plurimath::Math::Symbol.new("Q"),
                "double-struck"
              )
            ]),
            Plurimath::Math::Symbol.new("&#x2227;"),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("p"),
                Plurimath::Math::Symbol.new("&#x3c;"),
                Plurimath::Math::Symbol.new("q"),
              ],
              Plurimath::Math::Symbol.new(")")
            )
          ]),
          Plurimath::Math::Symbol.new("."),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("p"),
                Plurimath::Math::Symbol.new("&#x3c;"),
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbol.new("q"),
                  Plurimath::Math::Number.new("2")
                )
              ])
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #120" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x2200;<!--FOR ALL--></mo>
            <mrow>
              <mi>p</mi>
              <mo>,</mo>
              <mi>q</mi>
            </mrow>
            <mo>.</mo>
            <mfenced>
              <mrow>
                <mrow>
                  <mo>(</mo>
                  <mrow>
                    <mi>p</mi>
                    <mo>&#x2208;<!--ELEMENT OF--></mo>
                    <mi mathvariant="double-struck">Q</mi>
                  </mrow>
                  <mo>&#x2227;<!--LOGICAL AND--></mo>
                  <mrow>
                    <mi>q</mi>
                    <mo>&#x2208;<!--ELEMENT OF--></mo>
                    <mi mathvariant="double-struck">Q</mi>
                  </mrow>
                  <mo>&#x2227;<!--LOGICAL AND--></mo>
                  <mrow>
                    <mo>(</mo>
                    <mi>p</mi>
                    <mo>&lt;</mo>
                    <mi>q</mi>
                    <mo>)</mo>
                  </mrow>
                  <mo>)</mo>
                </mrow>
                <mo>&#x21d2;<!--RIGHTWARDS DOUBLE ARROW--></mo>
                <mrow>
                  <mo>(</mo>
                  <mi>p</mi>
                  <mo>&lt;</mo>
                  <msup>
                    <mi>q</mi>
                    <mn>2</mn>
                  </msup>
                  <mo>)</mo>
                </mrow>
              </mrow>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2200;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("p"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Symbol.new("q")
          ]),
          Plurimath::Math::Symbol.new("."),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbol.new("("),
                  [
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("p"),
                      Plurimath::Math::Symbol.new("&#x2208;"),
                      Plurimath::Math::Function::FontStyle::DoubleStruck.new(
                        Plurimath::Math::Symbol.new("Q"),
                        "double-struck",
                      )
                    ]),
                    Plurimath::Math::Symbol.new("&#x2227;"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("q"),
                      Plurimath::Math::Symbol.new("&#x2208;"),
                      Plurimath::Math::Function::FontStyle::DoubleStruck.new(
                        Plurimath::Math::Symbol.new("Q"),
                        "double-struck",
                      )
                    ]),
                    Plurimath::Math::Symbol.new("&#x2227;"),
                    Plurimath::Math::Function::Fenced.new(
                      Plurimath::Math::Symbol.new("("),
                      [
                        Plurimath::Math::Symbol.new("p"),
                        Plurimath::Math::Symbol.new("&#x3c;"),
                        Plurimath::Math::Symbol.new("q"),
                      ],
                      Plurimath::Math::Symbol.new(")")
                    ),
                  ],
                  Plurimath::Math::Symbol.new(")")
                ),
                Plurimath::Math::Symbol.new("&#x21d2;"),
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbol.new("("),
                  [
                    Plurimath::Math::Symbol.new("p"),
                    Plurimath::Math::Symbol.new("&#x3c;"),
                    Plurimath::Math::Function::Power.new(
                      Plurimath::Math::Symbol.new("q"),
                      Plurimath::Math::Number.new("2")
                    ),
                  ],
                  Plurimath::Math::Symbol.new(")")
                )
              ])
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #121" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x2203;<!--THERE EXISTS--></mo>
            <mi>x</mi>
            <mo>.</mo>
            <mfenced>
              <mrow>
                <mrow><mi>f</mi><mo>&#x2061;<!--FUNCTION APPLICATION--></mo><mfenced><mi>x</mi></mfenced></mrow>
                <mo>=</mo>
                <mn>0</mn>
              </mrow>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2203;"),
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("."),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Formula.new([
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("f"),
                  Plurimath::Math::Symbol.new("&#x2061;"),
                  Plurimath::Math::Function::Fenced.new(
                    Plurimath::Math::Symbol.new("("),
                    [
                      Plurimath::Math::Symbol.new("x")
                    ],
                    Plurimath::Math::Symbol.new(")"),
                  )
                ]),
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Number.new("0")
              ])
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #122" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x2203;<!--THERE EXISTS--></mo>
            <mi>x</mi>
            <mo>.</mo>
            <mfenced separators="">
              <mrow>
                <mi>x</mi>
                <mo>&#x2208;<!--ELEMENT OF--></mo>
                <mi mathvariant="double-struck">Z</mi>
              </mrow>
              <mo>&#x2227;<!--LOGICAL AND--></mo>
              <mrow>
                <mrow>
                  <mi>f</mi>
                  <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
                  <mfenced>
                    <mi>x</mi>
                  </mfenced>
                </mrow>
                <mo>=</mo>
                <mn>0</mn>
              </mrow>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2203;"),
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("."),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Symbol.new("&#x2208;"),
                Plurimath::Math::Function::FontStyle::DoubleStruck.new(
                  Plurimath::Math::Symbol.new("Z"),
                  "double-struck",
                )
              ]),
              Plurimath::Math::Symbol.new("&#x2227;"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("f"),
                  Plurimath::Math::Symbol.new("&#x2061;"),
                  Plurimath::Math::Function::Fenced.new(
                    Plurimath::Math::Symbol.new("("),
                    [
                      Plurimath::Math::Symbol.new("x")
                    ],
                    Plurimath::Math::Symbol.new(")"),
                  )
                ]),
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Number.new("0")
              ])
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #123" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>|</mo>
            <mi>x</mi>
            <mo>|</mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("|"),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #124" do
    let(:exp) {
      <<~MATHML
        <math>
          <mover>
            <mrow>
              <mi>x</mi>
              <mo>+</mo>
              <mrow>
                <mn>&#x2148;<!--DOUBLE-STRUCK ITALIC SMALL I--></mn>
                <mo>&#x2062;<!--INVISIBLE TIMES--></mo>
                <mi>y</mi>
              </mrow>
            </mrow>
            <mo>&#xaf;<!--MACRON--></mo>
          </mover>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Bar.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("&#x2148;"),
              Plurimath::Math::Symbol.new("&#x2062;"),
              Plurimath::Math::Symbol.new("y")
            ])
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #125" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>arg</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mrow>
                <mi>x</mi>
                <mo>+</mo>
                <mrow>
                  <mi>i</mi>
                  <mo>&#x2062;<!--INVISIBLE TIMES--></mo>
                  <mi>y</mi>
                </mrow>
              </mrow>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("arg"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("i"),
                  Plurimath::Math::Symbol.new("&#x2062;"),
                  Plurimath::Math::Symbol.new("y")
                ])
              ])
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #126" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x211b;<!--SCRIPT CAPITAL R--></mo>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mrow>
                <mi>x</mi>
                <mo>+</mo>
                <mrow><mi>i</mi><mo>&#x2062;<!--INVISIBLE TIMES--></mo><mi>y</mi></mrow>
              </mrow>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x211b;"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("i"),
                  Plurimath::Math::Symbol.new("&#x2062;"),
                  Plurimath::Math::Symbol.new("y")
                ])
              ])
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #127" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x2111;<!--BLACK-LETTER CAPITAL I--></mo>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mrow>
                <mi>x</mi>
                <mo>+</mo>
                <mrow><mi>i</mi><mo>&#x2062;<!--INVISIBLE TIMES--></mo><mi>y</mi></mrow>
              </mrow>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2111;"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("i"),
                  Plurimath::Math::Symbol.new("&#x2062;"),
                  Plurimath::Math::Symbol.new("y")
                ])
              ])
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #128" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>lcm</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mi>a</mi>
              <mi>b</mi>
              <mi>c</mi>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Lcm.new(
            Plurimath::Math::Symbol.new("&#x2061;"),
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Symbol.new("b"),
              Plurimath::Math::Symbol.new("c")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #129" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x230a;<!--LEFT FLOOR--></mo>
            <mi>a</mi>
            <mo>&#x230b;<!--RIGHT FLOOR--></mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("&#x230a;"),
          [
            Plurimath::Math::Symbol.new("a"),
          ],
          Plurimath::Math::Symbol.new("&#x230b;")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #130" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x2308;<!--LEFT CEILING--></mo>
            <mi>a</mi>
            <mo>&#x2309;<!--RIGHT CEILING--></mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("&#x2308;"),
          [
            Plurimath::Math::Symbol.new("a"),
          ],
          Plurimath::Math::Symbol.new("&#x2309;")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #131" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mrow>
              <mn>2</mn>
              <mo>/</mo>
              <mn>4</mn>
            </mrow>
            <mo>=</mo>
            <mrow>
              <mn>1</mn>
              <mo>/</mo>
              <mn>2</mn>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Symbol.new("/"),
            Plurimath::Math::Number.new("4")
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Symbol.new("/"),
            Plurimath::Math::Number.new("2")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #132" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mn>3</mn>
            <mo>&#x2260;<!--NOT EQUAL TO--></mo>
            <mn>4</mn>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("&#x2260;"),
          Plurimath::Math::Number.new("4")
        ]),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #133" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mn>3</mn>
            <mo>&gt;</mo>
            <mn>2</mn>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("&#x3e;"),
          Plurimath::Math::Number.new("2")
        ]),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #134" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mn>2</mn>
            <mo>&lt;</mo>
            <mn>3</mn>
            <mo>&lt;</mo>
            <mn>4</mn>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Symbol.new("&#x3c;"),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("&#x3c;"),
          Plurimath::Math::Number.new("4"),
        ]),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #135" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mn>4</mn>
            <mo>&#x2265;<!--GREATER-THAN OR EQUAL TO--></mo>
            <mn>3</mn>
            <mo>&#x2265;<!--GREATER-THAN OR EQUAL TO--></mo>
            <mn>3</mn>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("4"),
          Plurimath::Math::Symbol.new("&#x2265;"),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("&#x2265;"),
          Plurimath::Math::Number.new("3"),
        ]),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #136" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mn>3</mn>
            <mo>&#x2264;<!--LESS-THAN OR EQUAL TO--></mo>
            <mn>3</mn>
            <mo>&#x2264;<!--LESS-THAN OR EQUAL TO--></mo>
            <mn>4</mn>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("&#x2264;"),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("&#x2264;"),
          Plurimath::Math::Number.new("4"),
        ]),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #137" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>a</mi>
            <mo>&#x2261;<!--IDENTICAL TO--></mo>
            <mrow>
              <mo>&#xac;<!--NOT SIGN--></mo>
              <mrow>
                <mo>&#xac;<!--NOT SIGN--></mo>
                <mi>a</mi>
              </mrow>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("&#x2261;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("&#xac;"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#xac;"),
              Plurimath::Math::Symbol.new("a")
            ])
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #138" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>&#x3c0;<!--GREEK SMALL LETTER PI--></mi>
            <mo>&#x2243;<!--ASYMPTOTICALLY EQUAL TO--></mo>
            <mrow>
              <mn>22</mn>
              <mo>/</mo>
              <mn>7</mn>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3c0;"),
          Plurimath::Math::Symbol.new("&#x2243;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("22"),
            Plurimath::Math::Symbol.new("/"),
            Plurimath::Math::Number.new("7")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #139" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>a</mi>
            <mo>|</mo>
            <mi>b</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Symbol.new("b"),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #140" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mrow>
              <mi>&#x222b;<!--INTEGRAL--></mi>
              <mi>sin</mi>
            </mrow>
            <mo>=</mo>
            <mi>cos</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Int.new,
            Plurimath::Math::Function::Sin.new
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Cos.new
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #141" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <msubsup>
              <mi>&#x222b;<!--INTEGRAL--></mi>
              <mi>a</mi>
              <mi>b</mi>
            </msubsup>
            <mi>cos</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Int.new(
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("b"),
          Plurimath::Math::Function::Cos.new
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #142" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <msubsup>
              <mi>&#x222b;<!--INTEGRAL--></mi>
              <mn>0</mn>
              <mn>1</mn>
            </msubsup>
            <msup>
              <mi>x</mi>
              <mn>2</mn>
            </msup>
            <mi>d</mi>
            <mi>x</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Int.new(
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Number.new("2"),
            ),
          ),
          Plurimath::Math::Symbol.new("d"),
          Plurimath::Math::Symbol.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #143" do
    let(:exp) {
      <<~MATHML
        <math>
          <msup>
            <mi>f</mi>
            <mo>&#x2032;<!--PRIME--></mo>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Symbol.new("f"),
          Plurimath::Math::Symbol.new("&#x2032;"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #144" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mfrac>
              <mrow>
                <mi>d</mi>
                <mrow>
                  <mi>sin</mi>
                  <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
                  <mi>x</mi>
                </mrow>
              </mrow>
              <mrow>
                <mi>d</mi>
                <mi>x</mi>
              </mrow>
            </mfrac>
            <mo>=</mo>
            <mrow>
              <mi>cos</mi>
              <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
              <mi>x</mi>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("d"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Sin.new(
                  Plurimath::Math::Symbol.new("&#x2061;"),
                ),
                Plurimath::Math::Symbol.new("x")
              ])
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("d"),
              Plurimath::Math::Symbol.new("x")
            ])
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Cos.new(
              Plurimath::Math::Symbol.new("&#x2061;"),
            ),
            Plurimath::Math::Symbol.new("x")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #145" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfrac>
            <mrow>
              <msup>
                <mi>d</mi>
                <mn>2</mn>
              </msup>
              <msup>
                <mi>x</mi>
                <mn>4</mn>
              </msup>
            </mrow>
            <mrow>
              <mi>d</mi>
              <msup>
                <mi>x</mi>
                <mn>2</mn>
              </msup>
            </mrow>
          </mfrac>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new("d"),
              Plurimath::Math::Number.new("2")
            ),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Number.new("4"),
            )
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("d"),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Number.new("2"),
            )
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #146" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <msub>
              <mi>D</mi>
              <mrow>
                <mn>1</mn>
                <mo>,</mo>
                <mn>1</mn>
                <mo>,</mo>
                <mn>3</mn>
              </mrow>
            </msub>
            <mi>f</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("D"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Number.new("3")
            ])
          ),
          Plurimath::Math::Symbol.new("f")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #147" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfrac>
            <mrow>
              <msup>
                <mo>∂<!--PARTIAL DIFFERENTIAL--></mo>
                <mn>3</mn>
              </msup>
              <mrow>
                <mi>f</mi>
                <mo>⁡<!--FUNCTION APPLICATION--></mo>
                <mfenced>
                  <mi>x</mi>
                  <mi>y</mi>
                  <mi>z</mi>
                </mfenced>
              </mrow>
            </mrow>
            <mrow>
              <mrow>
                <mo>∂<!--PARTIAL DIFFERENTIAL--></mo>
                <msup>
                  <mi>x</mi>
                  <mn>2</mn>
                </msup>
              </mrow>
              <mrow>
                <mo>∂<!--PARTIAL DIFFERENTIAL--></mo>
                <mi>z</mi>
              </mrow>
            </mrow>
          </mfrac>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Number.new("3"),
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("f"),
              Plurimath::Math::Symbol.new("&#x2061;"),
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbol.new("("),
                [
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Symbol.new("y"),
                  Plurimath::Math::Symbol.new("z")
                ],
                Plurimath::Math::Symbol.new(")"),
              )
            ])
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Number.new("2"),
              )
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Symbol.new("z")
            ])
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #148" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfrac>
            <mrow>
              <msup>
                <mo>∂<!--PARTIAL DIFFERENTIAL--></mo>
                <mn>2</mn>
              </msup>
              <mrow>
                <mi>f</mi>
                <mo>⁡<!--FUNCTION APPLICATION--></mo>
                <mfenced>
                  <mi>x</mi>
                  <mi>y</mi>
                </mfenced>
              </mrow>
            </mrow>
            <mrow>
              <mrow>
                <mo>∂<!--PARTIAL DIFFERENTIAL--></mo>
                <mi>x</mi>
              </mrow>
              <mrow>
                <mo>∂<!--PARTIAL DIFFERENTIAL--></mo>
                <mi>y</mi>
              </mrow>
            </mrow>
          </mfrac>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Number.new("2"),
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("f"),
              Plurimath::Math::Symbol.new("&#x2061;"),
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbol.new("("),
                [
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Symbol.new("y")
                ],
                Plurimath::Math::Symbol.new(")"),
              )
            ])
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Symbol.new("x")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Symbol.new("y")
            ])
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #149" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfrac>
            <mrow>
              <msup>
                <mo>∂<!--PARTIAL DIFFERENTIAL--></mo>
                <mi>k</mi>
              </msup>
              <mrow>
                <mi>f</mi>
                <mo>⁡<!--FUNCTION APPLICATION--></mo>
                <mfenced>
                  <mi>x</mi>
                  <mi>y</mi>
                </mfenced>
              </mrow>
            </mrow>
            <mrow>
              <mrow>
                <mo>∂<!--PARTIAL DIFFERENTIAL--></mo>
                <msup>
                  <mi>x</mi>
                  <mi>m</mi>
                </msup>
              </mrow>
              <mrow>
                <mo>∂<!--PARTIAL DIFFERENTIAL--></mo>
                <msup>
                  <mi>y</mi>
                  <mi>n</mi>
                </msup>
              </mrow>
            </mrow>
          </mfrac>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Symbol.new("k"),
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("f"),
              Plurimath::Math::Symbol.new("&#x2061;"),
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbol.new("("),
                [
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Symbol.new("y")
                ],
                Plurimath::Math::Symbol.new(")"),
              )
            ])
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Symbol.new("m"),
              )
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbol.new("y"),
                Plurimath::Math::Symbol.new("n"),
              )
            ])
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #150" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>div</mi>
            <mo>⁡<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mi>a</mi>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("div"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("a")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #151" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>div</mi>
            <mo>⁡<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mi>E</mi>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("div"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("E")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #152" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>∇<!--NABLA--></mo>
            <mo>⋅<!--DOT OPERATOR--></mo>
            <mi>E</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2207;"),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Symbol.new("E")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #153" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>div</mi>
            <mo>⁡<!--FUNCTION APPLICATION--></mo>
            <mo>(</mo>
            <mtable>
              <mtr>
                <mtd>
                  <mi>x</mi>
                  <mo>↦<!--RIGHTWARDS ARROW FROM BAR--></mo>
                  <mrow>
                    <mi>x</mi>
                    <mo>+</mo>
                    <mi>y</mi>
                  </mrow>
                </mtd>
              </mtr>
              <mtr>
                <mtd>
                  <mi>y</mi>
                  <mo>↦<!--RIGHTWARDS ARROW FROM BAR--></mo>
                  <mrow>
                    <mi>x</mi>
                    <mo>+</mo>
                    <mi>z</mi>
                  </mrow>
                </mtd>
              </mtr>
              <mtr>
                <mtd>
                  <mi>z</mi>
                  <mo>↦<!--RIGHTWARDS ARROW FROM BAR--></mo>
                  <mrow>
                    <mi>z</mi>
                    <mo>+</mo>
                    <mi>y</mi>
                  </mrow>
                </mtd>
              </mtr>
            </mtable>
            <mo>)</mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("div"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Symbol.new("("),
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Symbol.new("&#x21a6;"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("x"),
                    Plurimath::Math::Symbol.new("+"),
                    Plurimath::Math::Symbol.new("y")
                  ])
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("y"),
                  Plurimath::Math::Symbol.new("&#x21a6;"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("x"),
                    Plurimath::Math::Symbol.new("+"),
                    Plurimath::Math::Symbol.new("z")
                  ])
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("z"),
                  Plurimath::Math::Symbol.new("&#x21a6;"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("z"),
                    Plurimath::Math::Symbol.new("+"),
                    Plurimath::Math::Symbol.new("y")
                  ])
                ])
              ])
            ],
            nil,
            nil
          ),
          Plurimath::Math::Symbol.new(")")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #154" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>grad</mi>
            <mo>⁡<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mi>f</mi>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("grad"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("f")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #155" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x2207;<!--NABLA--></mo>
            <mo>⁡<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mi>f</mi>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2207;"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("f")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #156" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>grad</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mrow>
              <mo>(</mo>
              <mfenced>
                <mi>x</mi>
                <mi>y</mi>
                <mi>z</mi>
              </mfenced>
              <mo>&#x21a6;<!--RIGHTWARDS ARROW FROM BAR--></mo>
              <mrow>
                <mi>x</mi>
                <mo>&#x2062;<!--INVISIBLE TIMES--></mo>
                <mi>y</mi>
                <mo>&#x2062;<!--INVISIBLE TIMES--></mo>
                <mi>z</mi>
              </mrow>
              <mo>)</mo>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("grad"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbol.new("("),
                [
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Symbol.new("y"),
                  Plurimath::Math::Symbol.new("z")
                ],
                Plurimath::Math::Symbol.new(")"),
              ),
              Plurimath::Math::Symbol.new("&#x21a6;"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Symbol.new("&#x2062;"),
                Plurimath::Math::Symbol.new("y"),
                Plurimath::Math::Symbol.new("&#x2062;"),
                Plurimath::Math::Symbol.new("z")
              ]),
            ],
            Plurimath::Math::Symbol.new(")")
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #157" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>curl</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mi>a</mi>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("curl"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("a")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #158" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x2207;<!--NABLA--></mo>
            <mo>&#xd7;<!--MULTIPLICATION SIGN--></mo>
            <mi>a</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2207;"),
          Plurimath::Math::Symbol.new("&#xd7;"),
          Plurimath::Math::Symbol.new("a")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #159" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <msup>
              <mo>&#x2207;<!--NABLA--></mo>
              <mn>2</mn>
            </msup>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mi>E</mi>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("&#x2207;"),
            Plurimath::Math::Number.new("2"),
          ),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("E")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #160" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <msup>
              <mo>&#x2207;<!--NABLA--></mo>
              <mn>2</mn>
            </msup>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mrow>
              <mo>(</mo>
              <mfenced>
                <mi>x</mi>
                <mi>y</mi>
                <mi>z</mi>
              </mfenced>
              <mo>&#x21a6;<!--RIGHTWARDS ARROW FROM BAR--></mo>
              <mrow>
                <mi>f</mi>
                <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
                <mfenced>
                  <mi>x</mi>
                  <mi>y</mi>
                </mfenced>
              </mrow>
              <mo>)</mo>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("&#x2207;"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbol.new("("),
                [
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Symbol.new("y"),
                  Plurimath::Math::Symbol.new("z")
                ],
                Plurimath::Math::Symbol.new(")"),
              ),
              Plurimath::Math::Symbol.new("&#x21a6;"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("f"),
                Plurimath::Math::Symbol.new("&#x2061;"),
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbol.new("("),
                  [
                    Plurimath::Math::Symbol.new("x"),
                    Plurimath::Math::Symbol.new("y")
                  ],
                  Plurimath::Math::Symbol.new(")"),
                )
              ]),
            ],
            Plurimath::Math::Symbol.new(")")
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #161" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>{</mo>
            <mi>a</mi>
            <mo>,</mo>
            <mi>b</mi>
            <mo>,</mo>
            <mi>c</mi>
            <mo>}</mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("{"),
          [
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Symbol.new("b"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Symbol.new("c"),
          ],
          Plurimath::Math::Symbol.new("}")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #162" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>{</mo>
            <mi>x</mi>
            <mo>|</mo>
            <mrow>
              <mi>x</mi>
              <mo>&lt;</mo>
              <mn>5</mn>
            </mrow>
            <mo>}</mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("{"),
          [
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Symbol.new("|"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new("&#x3c;"),
              Plurimath::Math::Number.new("5")
            ]),
          ],
          Plurimath::Math::Symbol.new("}")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #163" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>{</mo>
            <mi>S</mi>
            <mo>|</mo>
            <mrow><mi>S</mi><mo>&#x2208;<!--ELEMENT OF--></mo><mi>T</mi></mrow>
            <mo>}</mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("{"),
          [
            Plurimath::Math::Symbol.new("S"),
            Plurimath::Math::Symbol.new("|"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("S"),
              Plurimath::Math::Symbol.new("&#x2208;"),
              Plurimath::Math::Symbol.new("T")
            ]),
          ],
          Plurimath::Math::Symbol.new("}")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #164" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>{</mo>
            <mi>x</mi>
            <mo>|</mo>
            <mrow>
              <mrow>
                <mo>(</mo>
                <mi>x</mi>
                <mo>&lt;</mo>
                <mn>5</mn>
                <mo>)</mo>
              </mrow>
              <mo>&#x2227;<!--LOGICAL AND--></mo>
              <mrow>
                <mi>x</mi>
                <mo>&#x2208;<!--ELEMENT OF--></mo>
                <mi mathvariant="double-struck">N</mi>
              </mrow>
            </mrow>
            <mo>}</mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("{"),
          [
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Symbol.new("|"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbol.new("("),
                [
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Symbol.new("&#x3c;"),
                  Plurimath::Math::Number.new("5"),
                ],
                Plurimath::Math::Symbol.new(")")
              ),
              Plurimath::Math::Symbol.new("&#x2227;"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Symbol.new("&#x2208;"),
                Plurimath::Math::Function::FontStyle::DoubleStruck.new(
                  Plurimath::Math::Symbol.new("N"),
                  "double-struck",
                )
              ])
            ]),
          ],
          Plurimath::Math::Symbol.new("}")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #165" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>(</mo>
            <mi>a</mi>
            <mo>,</mo>
            <mi>b</mi>
            <mo>,</mo>
            <mi>c</mi>
            <mo>)</mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          [
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Symbol.new("b"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Symbol.new("c"),
          ],
          Plurimath::Math::Symbol.new(")")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #166" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>(</mo>
            <mi>x</mi>
            <mo>|</mo>
            <mrow>
              <mi>x</mi>
              <mo>&lt;</mo>
              <mn>5</mn>
            </mrow>
            <mo>)</mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          [
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Symbol.new("|"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new("&#x3c;"),
              Plurimath::Math::Number.new("5")
            ]),
          ],
          Plurimath::Math::Symbol.new(")")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #167" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>A</mi>
            <mo>&#x222a;<!--UNION--></mo>
            <mi>B</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("A"),
          Plurimath::Math::Symbol.new("&#x222a;"),
          Plurimath::Math::Symbol.new("B")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #168" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <munder>
              <mo>&#x22c3;<!--N-ARY UNION--></mo>
              <mi>L</mi>
            </munder>
            <mi>S</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Symbol.new("L"),
            Plurimath::Math::Symbol.new("&#x22c3;"),
          ),
          Plurimath::Math::Symbol.new("S")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #169" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>A</mi>
            <mo>&#x2229;<!--INTERSECTION--></mo>
            <mi>B</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("A"),
          Plurimath::Math::Symbol.new("&#x2229;"),
          Plurimath::Math::Symbol.new("B")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #170" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <munder>
              <mo>&#x22c2;<!--N-ARY INTERSECTION--></mo>
              <mi>L</mi>
            </munder>
            <mi>S</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Symbol.new("L"),
            Plurimath::Math::Symbol.new("&#x22c2;"),
          ),
          Plurimath::Math::Symbol.new("S")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #171" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>a</mi>
            <mo>&#x2208;<!--ELEMENT OF--></mo>
            <mi>A</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("&#x2208;"),
          Plurimath::Math::Symbol.new("A")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #172" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>a</mi>
            <mo>&#x2209;<!--NOT AN ELEMENT OF--></mo>
            <mi>A</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("&#x2209;"),
          Plurimath::Math::Symbol.new("A")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #173" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>A</mi>
            <mo>&#x2286;<!--SUBSET OF OR EQUAL TO--></mo>
            <mi>B</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("A"),
          Plurimath::Math::Symbol.new("&#x2286;"),
          Plurimath::Math::Symbol.new("B")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #174" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>A</mi>
            <mo>&#x2282;<!--SUBSET OF--></mo>
            <mi>B</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("A"),
          Plurimath::Math::Symbol.new("&#x2282;"),
          Plurimath::Math::Symbol.new("B")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #175" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>A</mi>
            <mo>&#x2288;<!--NEITHER A SUBSET OF NOR EQUAL TO--></mo>
            <mi>B</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("A"),
          Plurimath::Math::Symbol.new("&#x2288;"),
          Plurimath::Math::Symbol.new("B")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #176" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>A</mi>
            <mo>&#x2284;<!--NOT A SUBSET OF--></mo>
            <mi>B</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("A"),
          Plurimath::Math::Symbol.new("&#x2284;"),
          Plurimath::Math::Symbol.new("B")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #177" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>A</mi>
            <mo>&#x2216;<!--SET MINUS--></mo>
            <mi>B</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("A"),
          Plurimath::Math::Symbol.new("&#x2216;"),
          Plurimath::Math::Symbol.new("B")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #178" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mrow>
              <mo>|</mo>
              <mi>A</mi>
              <mo>|</mo>
            </mrow>
            <mo>=</mo>
            <mn>5</mn>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("|"),
            Plurimath::Math::Symbol.new("A"),
            Plurimath::Math::Symbol.new("|")
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("5")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #179" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>A</mi>
            <mo>&#xd7;<!--MULTIPLICATION SIGN--></mo>
            <mi>B</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("A"),
          Plurimath::Math::Symbol.new("&#xd7;"),
          Plurimath::Math::Symbol.new("B")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #180" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <munderover>
              <mo>&#x2211;<!--N-ARY SUMMATION--></mo>
              <mrow>
                <mi>x</mi>
                <mo>=</mo>
                <mi>a</mi>
              </mrow>
              <mi>b</mi>
            </munderover>
            <mrow>
              <mi>f</mi>
              <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
              <mfenced>
                <mi>x</mi>
              </mfenced>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Sum.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Symbol.new("a")
          ]),
          Plurimath::Math::Symbol.new("b"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("f"),
            Plurimath::Math::Symbol.new("&#x2061;"),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("x")
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ])
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #181" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <munder>
              <mo>&#x2211;<!--N-ARY SUMMATION--></mo>
              <mrow>
                <mi>x</mi>
                <mo>&#x2208;<!--ELEMENT OF--></mo>
                <mi>B</mi>
              </mrow>
            </munder>
            <mrow>
              <mi>f</mi>
              <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
              <mfenced>
                <mi>x</mi>
              </mfenced>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new("&#x2208;"),
              Plurimath::Math::Symbol.new("B")
            ]),
            Plurimath::Math::Function::Sum.new
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("f"),
            Plurimath::Math::Symbol.new("&#x2061;"),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("x")
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #182" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <munder>
              <mo>&#x2211;<!--N-ARY SUMMATION--></mo>
              <mi>B</mi>
            </munder>
            <mi>f</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Symbol.new("B"),
            Plurimath::Math::Function::Sum.new
          ),
          Plurimath::Math::Symbol.new("f"),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #183" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <munderover>
              <mo>&#x220f;<!--N-ARY PRODUCT--></mo>
              <mrow>
                <mi>x</mi>
                <mo>=</mo>
                <mi>a</mi>
              </mrow>
              <mi>b</mi>
            </munderover>
            <mrow>
              <mi>f</mi>
              <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
              <mfenced>
                <mi>x</mi>
              </mfenced>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Prod.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Symbol.new("a")
          ]),
          Plurimath::Math::Symbol.new("b"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("f"),
            Plurimath::Math::Symbol.new("&#x2061;"),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("x")
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ])
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #184" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <munder>
              <mo>&#x220f;<!--N-ARY PRODUCT--></mo>
              <mrow>
                <mi>x</mi>
                <mo>&#x2208;<!--ELEMENT OF--></mo>
                <mi>B</mi>
              </mrow>
            </munder>
            <mrow>
              <mi>f</mi>
              <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
              <mfenced>
                <mi>x</mi>
              </mfenced>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new("&#x2208;"),
              Plurimath::Math::Symbol.new("B")
            ]),
            Plurimath::Math::Function::Prod.new,
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("f"),
            Plurimath::Math::Symbol.new("&#x2061;"),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("x")
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #185" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <munder>
              <mi>lim</mi>
              <mrow>
                <mi>x</mi>
                <mo>&#x2192;<!--RIGHTWARDS ARROW--></mo>
                <mn>0</mn>
              </mrow>
            </munder>
            <mrow>
              <mi>sin</mi>
              <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
              <mi>x</mi>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Function::Vec.new,
              Plurimath::Math::Number.new("0")
            ]),
            Plurimath::Math::Symbol.new("lim")
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Sin.new(
              Plurimath::Math::Symbol.new("&#x2061;"),
            ),
            Plurimath::Math::Symbol.new("x")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #186" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <munder>
              <mi>lim</mi>
              <mrow>
                <mi>x</mi>
                <mo>&#x2192;<!--RIGHTWARDS ARROW--></mo>
                <msup>
                  <mi>a</mi>
                  <mo>+</mo>
                </msup>
              </mrow>
            </munder>
            <mrow>
              <mi>sin</mi>
              <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
              <mi>x</mi>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Function::Vec.new,
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbol.new("a"),
                Plurimath::Math::Symbol.new("+")
              )
            ]),
            Plurimath::Math::Symbol.new("lim")
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Sin.new(
              Plurimath::Math::Symbol.new("&#x2061;"),
            ),
            Plurimath::Math::Symbol.new("x")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #187" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <msup>
              <mi>x</mi>
              <mn>2</mn>
            </msup>
            <mo>&#x2192;<!--RIGHTWARDS ARROW--></mo>
            <msup>
              <msup>
                <mi>a</mi>
                <mn>2</mn>
              </msup>
              <mo>+</mo>
            </msup>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Vec.new,
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Number.new("2")
            ),
            Plurimath::Math::Symbol.new("+")
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #188" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfenced>
            <mtable>
              <mtr>
                <mtd>
                  <mi>x</mi>
                </mtd>
              </mtr>
              <mtr>
                <mtd>
                  <mi>y</mi>
                </mtd>
              </mtr>
            </mtable>
          </mfenced>
          <mo>&#x2192;<!--RIGHTWARDS ARROW--></mo>
          <mfenced>
            <mtable>
              <mtr>
                <mtd>
                  <mi>f</mi>
                  <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
                  <mfenced>
                    <mi>x</mi>
                    <mi>y</mi>
                  </mfenced>
                </mtd>
              </mtr>
              <mtr>
                <mtd>
                  <mi>g</mi>
                  <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
                  <mfenced>
                    <mi>x</mi>
                    <mi>y</mi>
                  </mfenced>
                </mtd>
              </mtr>
            </mtable>
          </mfenced>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          [
            Plurimath::Math::Function::Table.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("x")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("y")
                  ])
                ])
              ],
              nil,
              nil
            )
          ],
          Plurimath::Math::Symbol.new(")"),
        ),
        Plurimath::Math::Function::Vec.new,
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          [
            Plurimath::Math::Function::Table.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("f"),
                    Plurimath::Math::Symbol.new("&#x2061;"),
                    Plurimath::Math::Function::Fenced.new(
                      Plurimath::Math::Symbol.new("("),
                      [
                        Plurimath::Math::Symbol.new("x"),
                        Plurimath::Math::Symbol.new("y")
                      ],
                      Plurimath::Math::Symbol.new(")"),
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("g"),
                    Plurimath::Math::Symbol.new("&#x2061;"),
                    Plurimath::Math::Function::Fenced.new(
                      Plurimath::Math::Symbol.new("("),
                      [
                        Plurimath::Math::Symbol.new("x"),
                        Plurimath::Math::Symbol.new("y")
                      ],
                      Plurimath::Math::Symbol.new(")"),
                    )
                  ])
                ])
              ],
              nil,
              nil
            )
          ],
          Plurimath::Math::Symbol.new(")"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #189" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>sin</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mi>x</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Symbol.new("&#x2061;"),
          ),
          Plurimath::Math::Symbol.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #190" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>sin</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mrow>
              <mo>(</mo>
              <mrow>
                <mi>cos</mi>
                <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
                <mi>x</mi>
              </mrow>
              <mo>+</mo>
              <msup>
                <mi>x</mi>
                <mn>3</mn>
              </msup>
              <mo>)</mo>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Symbol.new("&#x2061;"),
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Cos.new(
                  Plurimath::Math::Symbol.new("&#x2061;"),
                ),
                Plurimath::Math::Symbol.new("x")
              ]),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Number.new("3")
              ),
            ],
            Plurimath::Math::Symbol.new(")")
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #191" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>arcsin</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mi>x</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Arcsin.new(
            Plurimath::Math::Symbol.new("&#x2061;"),
          ),
          Plurimath::Math::Symbol.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #192" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <msup>
              <mi>sin</mi>
              <mrow>
                <mo>-</mo>
                <mn>1</mn>
              </mrow>
            </msup>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mi>x</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Sin.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Number.new("1")
            ])
          ),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Symbol.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #193" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>sinh</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mi>x</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sinh.new(
            Plurimath::Math::Symbol.new("&#x2061;"),
          ),
          Plurimath::Math::Symbol.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #194" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>arcsinh</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mi>x</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("arcsinh"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Symbol.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #195" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <msup>
              <mi>sinh</mi>
              <mrow>
                <mo>-</mo>
                <mn>1</mn>
              </mrow>
            </msup>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mi>x</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Sinh.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Number.new("1")
            ])
          ),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Symbol.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #196" do
    let(:exp) {
      <<~MATHML
        <math>
          <msup>
            <mi>e</mi>
            <mi>x</mi>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Symbol.new("e"),
          Plurimath::Math::Symbol.new("x")
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #197" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>ln</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mi>a</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Ln.new(
            Plurimath::Math::Symbol.new("&#x2061;"),
          ),
          Plurimath::Math::Symbol.new("a"),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #198" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <msub>
              <mi>log</mi>
              <mn>3</mn>
            </msub>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mi>x</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Log.new,
            Plurimath::Math::Number.new("3")
          ),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Symbol.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #199" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>log</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mi>x</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new,
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Symbol.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #200" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x2329;<!--MATHEMATICAL LEFT ANGLE BRACKET--></mo>
            <mn>3</mn><mo>,</mo><mn>4</mn><mo>,</mo><mn>3</mn>
            <mo>,</mo><mn>7</mn><mo>,</mo><mn>4</mn>
            <mo>&#x232a;<!--MATHEMATICAL RIGHT ANGLE BRACKET--></mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("&#x2329;"),
          [
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Number.new("4"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Number.new("7"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Number.new("4"),
          ],
          Plurimath::Math::Symbol.new("&#x232a;")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #201" do
    let(:exp) {
      <<~MATHML
        <math>
          <mover>
            <mi>X</mi>
            <mo>&#xaf;<!--MACRON--></mo>
          </mover>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Bar.new(
          Plurimath::Math::Symbol.new("X"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #202" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x3c3;<!--GREEK SMALL LETTER SIGMA--></mo>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mn>3</mn>
              <mn>4</mn>
              <mn>2</mn>
              <mn>2</mn>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3c3;"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Number.new("4"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Number.new("2")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #203" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x3c3;<!--GREEK SMALL LETTER SIGMA--></mo>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mi>X</mi>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3c3;"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("X"),
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #204" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <msup>
              <mo>&#x3c3;<!--GREEK SMALL LETTER SIGMA--></mo>
              <mn>2</mn>
            </msup>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mn>3</mn>
              <mn>4</mn>
              <mn>2</mn>
              <mn>2</mn>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("&#x3c3;"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Number.new("4"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Number.new("2")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #205" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <msup>
              <mo>&#x3c3;<!--GREEK SMALL LETTER SIGMA--></mo>
              <mn>2</mn>
            </msup>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mi>X</mi>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("&#x3c3;"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("X")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #206" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>median</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mn>3</mn>
              <mn>4</mn>
              <mn>2</mn>
              <mn>2</mn>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("median"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Number.new("4"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Number.new("2")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #207" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi>mode</mi>
            <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
            <mfenced>
              <mn>3</mn>
              <mn>4</mn>
              <mn>2</mn>
              <mn>2</mn>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("mode"),
          Plurimath::Math::Symbol.new("&#x2061;"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Number.new("4"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Number.new("2")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #208" do
    let(:exp) {
      <<~MATHML
        <math>
          <msub>
            <mrow>
              <mo>&#x2329;<!--MATHEMATICAL LEFT ANGLE BRACKET--></mo>
              <msup>
                <mfenced>
                  <mn>6</mn>
                  <mn>4</mn>
                  <mn>2</mn>
                  <mn>2</mn>
                  <mn>5</mn>
                </mfenced>
                <mn>3</mn>
              </msup>
              <mo>&#x232a;<!--MATHEMATICAL RIGHT ANGLE BRACKET--></mo>
            </mrow>
            <mi>mean</mi>
          </msub>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Base.new(
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("&#x2329;"),
            [
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbol.new("("),
                  [
                    Plurimath::Math::Number.new("6"),
                    Plurimath::Math::Number.new("4"),
                    Plurimath::Math::Number.new("2"),
                    Plurimath::Math::Number.new("2"),
                    Plurimath::Math::Number.new("5")
                  ],
                  Plurimath::Math::Symbol.new(")"),
                ),
                Plurimath::Math::Number.new("3")
              ),
            ],
            Plurimath::Math::Symbol.new("&#x232a;")
          ),
          Plurimath::Math::Symbol.new("mean")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #209" do
    let(:exp) {
      <<~MATHML
        <math>
          <msub>
            <mrow>
              <mo>&#x2329;<!--MATHEMATICAL LEFT ANGLE BRACKET--></mo><msup><mi>X</mi><mn>3</mn></msup><mo>&#x232a;<!--MATHEMATICAL RIGHT ANGLE BRACKET--></mo>
            </mrow>
            <mi>p</mi>
          </msub>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Base.new(
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("&#x2329;"),
            [
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbol.new("X"),
                Plurimath::Math::Number.new("3")
              ),
            ],
            Plurimath::Math::Symbol.new("&#x232a;")
          ),
          Plurimath::Math::Symbol.new("p")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end
end
