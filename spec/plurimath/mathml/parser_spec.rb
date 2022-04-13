require_relative "../../../lib/plurimath/mathml"

RSpec.describe Plurimath::Mathml::Parser do

  subject(:formula) { Plurimath::Mathml::Parser.new(exp).parse }

  context "contains mathml string of sin formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <mi>sin</mi>
              <mrow>
                <mo>(</mo>
                <mn>1</mn>
                <mo>)</mo>
              </mrow>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sin from mathml string" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new(
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("("),
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Symbol.new(")"),
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum and prod formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <munderover>
              <mo>&#x2211;</mo>
              <mrow>
                <mo>(</mo>
                <mo>&#x220f;</mo>
                <mo>)</mo>
              </mrow>
              <mo>&#x22c1;</mo>
            </munderover>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sum and prod" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Underover.new(
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("("),
            Plurimath::Math::Function::Prod.new,
            Plurimath::Math::Symbol.new(")"),
          ]),
          Plurimath::Math::Symbol.new("vvv")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mi>x</mi>
                <mi>s</mi>
              </munderover>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sum and prod" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Symbol.new("s"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum with text formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mrow>
                  <mi>s</mi>
                  <mi>x</mi>
                </mrow>
                <mrow>
                  <mi>s</mi>
                  <mi>w</mi>
                </mrow>
              </munderover>
            </mrow>
            <mtext>something</mtext>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sum" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("s"),
              Plurimath::Math::Symbol.new("x"),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("s"),
              Plurimath::Math::Symbol.new("w"),
            ])
          )
        ]),
        Plurimath::Math::Function::Text.new("something")
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sin with sum formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <msub>
                <mi>sin</mi>
                <mrow>
                  <mo>&#x2211;</mo>
                </mrow>
              </msub>
              <mo></mo>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sin" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new,
          Plurimath::Math::Symbol.new("_"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Sum.new
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sin and sum formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <msup>
                <mi>sin</mi>
                <mrow>
                  <mo>&#x2211;</mo>
                </mrow>
              </msup>
              <mo></mo>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sin" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new,
          Plurimath::Math::Symbol.new("^"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Sum.new
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sin sum and prod formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <mrow>
                <msubsup>
                  <mi>sin</mi>
                  <mrow>
                    <mo>&#x220f;</mo>
                  </mrow>
                  <mrow>
                    <mo>&#x2211;</mo>
                  </mrow>
                </msubsup>
              </mrow>
              <mo></mo>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sin" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Subsup.new(
              Plurimath::Math::Function::Sin.new,
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Prod.new
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Sum.new
              ])
            )
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum with symbol formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
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
            </mrow>
            <msup>
              <mi>i</mi>
              <mn>3</mn>
            </msup>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sum" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Symbol.new("n"),
          )
        ]),
        Plurimath::Math::Symbol.new("i"),
        Plurimath::Math::Symbol.new("^"),
        Plurimath::Math::Number.new("3"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of simple sin formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>sin</mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sin" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Sin.new,
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of simple text formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mtext>sinsumsom&#x393;</mtext>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of text" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Text.new("sinsumsomGamma"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum frac formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
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
            </mrow>
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
    }
    it "returns formula of sum and frac" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Symbol.new("n"),
          ),
        ]),
        Plurimath::Math::Symbol.new("i"),
        Plurimath::Math::Symbol.new("^"),
        Plurimath::Math::Number.new("3"),
        Plurimath::Math::Symbol.new("="),
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("("),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("n"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("("),
                Plurimath::Math::Symbol.new("n"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Symbol.new("1"),
                Plurimath::Math::Symbol.new(")"),
              ]),
            ]),
            Plurimath::Math::Number.new("2"),
          ),
          Plurimath::Math::Symbol.new(")"),
        ]),
        Plurimath::Math::Symbol.new("^"),
        Plurimath::Math::Number.new("2"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sin sum and theta formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <mi>sin</mi>
              <mrow>
                <mo>(</mo>
                <mover>
                  <mo>&#x2211;</mo>
                  <mrow>
                    <mi>&#x3B8;</mi>
                  </mrow>
                </mover>
                <mo>)</mo>
              </mrow>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sum" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new,
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("("),
            Plurimath::Math::Function::Overset.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("theta"),
              ]),
              Plurimath::Math::Function::Sum.new,
            ),
            Plurimath::Math::Symbol.new(")"),
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum only exponent formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mover>
              <mo>&#x2211;</mo>
              <mn>3</mn>
            </mover>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sum" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Function::Sum.new,
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum with Theta formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mover>
              <mo>&#x2211;</mo>
              <mrow>
                <mo>&#x398;</mo>
              </mrow>
            </mover>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sum" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("Theta"),
          ]),
          Plurimath::Math::Function::Sum.new,
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum with square formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mfrac>
                    <mn>12</mn>
                    <mo>&#x25A1;</mo>
                  </mfrac>
                </mrow>
                <mn>33</mn>
              </munderover>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sum" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Number.new("12"),
                Plurimath::Math::Symbol.new("square")
              ),
            ]),
            Plurimath::Math::Number.new("33"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of log text formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <mrow>
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
                  <mrow>
                    <mrow>
                      <mtext>4 terms</mtext>
                    </mrow>
                  </mrow>
                </msubsup>
              </mrow>
              <mo></mo>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of log and text" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Subsup.new(
              Plurimath::Math::Function::Log.new,
              Plurimath::Math::Formula.new([
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("4"),
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::Text.new("4terms")
                ])
              ]),
            )
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of simple symbol formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mover>
              <mrow>
                <mi>i</mi>
              </mrow>
              <mrow>
                <mn>1234</mn>
              </mrow>
            </mover>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of symbol" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1234")
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("i")
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of mod formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mn>12</mn>
            <mo>mod</mo>
            <mrow>
              <mo>(</mo>
              <mn>1234</mn>
              <mo>)</mo>
            </mrow>
            <mrow>
              <mo>(</mo>
              <mi>i</mi>
              <mo>)</mo>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of mod" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Symbol.new("12"),
        Plurimath::Math::Function::Mod.new,
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("("),
          Plurimath::Math::Number.new("1234"),
          Plurimath::Math::Symbol.new(")"),
        ]),
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("("),
          Plurimath::Math::Symbol.new("i"),
          Plurimath::Math::Symbol.new(")"),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of symbols and text formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <mrow>
                <msubsup>
                  <mo>a</mo>
                  <mrow>
                    <mtable>
                      <mtr>
                        <mtd>
                          <mn>1</mn>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <mo>+</mo>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <mn>2</mn>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <mo>+</mo>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <mn>3</mn>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <mo>+</mo>
                        </mtd>
                      </mtr>
                      <mtr>
                        <mtd>
                          <mn>4</mn>
                        </mtd>
                      </mtr>
                    </mtable>
                  </mrow>
                  <mrow>
                    <mrow>
                      <mtext>4 terms</mtext>
                    </mrow>
                  </mrow>
                </msubsup>
              </mrow>
              <mo></mo>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of symbols and text" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Subsup.new(
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("4"),
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::Text.new("4terms")
                ])
              ]),
            )
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sqrt formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <msqrt>
              <mrow>
                <mo>&#x2211;</mo>
              </mrow>
            </msqrt>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sqrt" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Sqrt.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Sum.new
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of symbol (using mfenced tag) formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <mrow>
                <msubsup>
                  <mo>a</mo>
                  <mrow>
                    <mfenced open='{' close='}'>
                      <mtable>
                        <mtr>
                          <mtd>
                            <mn>1</mn>
                          </mtd>
                        </mtr>
                        <mtr>
                          <mtd>
                            <mo>+</mo>
                          </mtd>
                        </mtr>
                        <mtr>
                          <mtd>
                            <mn>2</mn>
                          </mtd>
                        </mtr>
                        <mtr>
                          <mtd>
                            <mo>+</mo>
                          </mtd>
                        </mtr>
                        <mtr>
                          <mtd>
                            <mn>3</mn>
                          </mtd>
                        </mtr>
                        <mtr>
                          <mtd>
                            <mo>+</mo>
                          </mtd>
                        </mtr>
                        <mtr>
                          <mtd>
                            <mn>4</mn>
                          </mtd>
                        </mtr>
                      </mtable>
                    </mfenced>
                  </mrow>
                  <mrow>
                    <mrow>
                      <mtext>4 terms</mtext>
                    </mrow>
                  </mrow>
                </msubsup>
              </mrow>
              <mo></mo>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of symbol" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Subsup.new(
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("{"),
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("4"),
                Plurimath::Math::Symbol.new("}"),
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::Text.new("4terms")
                ])
              ]),
            )
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of int and f formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <msubsup>
                <mo>&#x222B;</mo>
                <mn>0</mn>
                <mn>1</mn>
              </msubsup>
            </mrow>
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
    }
    it "returns formula of int and f" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Subsup.new(
            Plurimath::Math::Function::Int.new,
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Number.new("1"),
          )
        ]),
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::F.new,
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("("),
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Symbol.new(")"),
          ])
        ]),
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("d"),
          Plurimath::Math::Symbol.new("x"),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of log and text formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <msup>
                <mrow>
                  <mi>log</mi>
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
                </mrow>
                <mrow>
                  <mrow>
                    <mtext>4 terms\</mtext>
                  </mrow>
                </mrow>
              </msup>
              <mo></mo>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of log and text" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Log.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("4"),
              Plurimath::Math::Symbol.new(")"),
            ])
          ]),
          Plurimath::Math::Symbol.new("^"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("4terms")
            ])
          ]),
        ]),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of prod and theta formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <munder>
              <mo>&#x220F;</mo>
              <mrow>
                <mi>&#x3B8;</mi>
              </mrow>
            </munder>
            <mrow>
              <mo>(</mo>
              <mi>i</mi>
              <mo>)</mo>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of prod and theta" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Underset.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("theta")
          ]),
          Plurimath::Math::Function::Prod.new,
        ),
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("("),
          Plurimath::Math::Symbol.new("i"),
          Plurimath::Math::Symbol.new(")"),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of root and theta  formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mroot>
              <mrow>
                <mi>&#x3B8;</mi>
              </mrow>
              <mrow>
                <mi>x</mi>
              </mrow>
            </mroot>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of root and theta" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Root.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("theta")
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("x")
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of ubrace formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
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
              <mo>&#x23DF;</mo>
            </mover>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of ubrace" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Ubrace.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Number.new("4"),
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum and ne formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mstyle mathcolor='blue'>
                    <mrow>
                      <mo>&#x2260;</mo>
                    </mrow>
                  </mstyle>
                </mrow>
                <mn>33</mn>
              </munderover>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sum and ne" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Function::Color.new(
                Plurimath::Math::Symbol.new("blue"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("!=")
                ]),
              )
            ]),
            Plurimath::Math::Number.new("33"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum and frac formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mo>frac</mo>
                  <mrow>
                    <mo>{</mo>
                    <mn>13</mn>
                    <mo>}</mo>
                  </mrow>
                </mrow>
                <mn>33</mn>
              </munderover>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sum and frac" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Function::Frac.new,
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("{"),
                Plurimath::Math::Number.new("13"),
                Plurimath::Math::Symbol.new("}"),
              ]),
            ]),
            Plurimath::Math::Number.new("33"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum sin and frac formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
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
            </mrow>
            <msup>
              <mi>i</mi>
              <mn>3</mn>
            </msup>
            <mo>=</mo>
            <mrow>
              <msup>
                <mrow>
                  <mi>sin</mi>
                  <mrow>
                    <mo>(</mo>
                    <mfrac>
                      <mi>n</mi>
                      <mn>2</mn>
                    </mfrac>
                    <mo>)</mo>
                  </mrow>
                </mrow>
                <mn>2</mn>
              </msup>
              <mo></mo>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sum sin and frac" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Number.new("1"),
          ]),
          Plurimath::Math::Symbol.new("n"),
        ),
        ]),
        Plurimath::Math::Symbol.new("i"),
        Plurimath::Math::Symbol.new("^"),
        Plurimath::Math::Number.new("3"),
        Plurimath::Math::Symbol.new("="),
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Symbol.new("n"),
                Plurimath::Math::Number.new("2"),
              ),
              Plurimath::Math::Symbol.new(")"),
            ])
          ]),
          Plurimath::Math::Symbol.new("^"),
          Plurimath::Math::Number.new("2"),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of abs formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mrow>
              <mo>|</mo>
              <mrow>
                <mn>1</mn>
                <mo>+</mo>
                <mn>2</mn>
                <mo>+</mo>
                <mn>3</mn>
                <mo>+</mo>
                <mn>4</mn>
              </mrow>
              <mo>|</mo>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of abs" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Number.new("4"),
          ]),
          Plurimath::Math::Symbol.new("|"),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of unmacthing closing tag" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
          </menclose>
        </math>
      MATHML
    }
    it "returns formula of sum" do
      expect{formula}.to raise_error(Plurimath::Math::Error)
    end
  end
end
