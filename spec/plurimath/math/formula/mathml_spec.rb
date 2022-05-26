require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Formula do
  describe ".to_mathml" do
    subject(:formula) { exp.to_mathml.gsub("\n", "").gsub(" ", "") }

    context "contains mathml string of sin formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula of sin from mathml string" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sum and prod formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula of sum and prod" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sum formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Underover.new(
              Plurimath::Math::Function::Sum.new,
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new("s"),
            )
          ])
        ])
      }
      it "returns formula of sum and prod" do
        expected_value =
        <<~MATHML
          <math xmlns='http://www.w3.org/1998/Math/MathML'>
            <mstyle displaystyle='true'>
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mo>x</mo>
                  <mo>s</mo>
                </munderover>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sum with text formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula of sum" do
        expected_value =
        <<~MATHML
          <math xmlns='http://www.w3.org/1998/Math/MathML'>
            <mstyle displaystyle='true'>
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mrow>
                    <mo>s</mo>
                    <mo>x</mo>
                  </mrow>
                  <mrow>
                    <mo>s</mo>
                    <mo>w</mo>
                  </mrow>
                </munderover>
              </mrow>
              <mtext>something</mtext>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sin with sum formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Sin.new,
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Sum.new
              ])
            )
          ])
        ])
      }
      it "returns formula of sin" do
        expected_value =
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
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sin and sum formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Sin.new,
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Sum.new
              ])
            )
          ])
        ])
      }
      it "returns formula of sin" do
        expected_value =
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
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sin sum and prod formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::PowerBase.new(
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
      }
      it "returns formula of sin" do
        expected_value =
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
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sum with symbol formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Number.new("3"),
          )
        ])
      }
      it "returns formula of sum" do
        expected_value =
        <<~MATHML
          <math xmlns='http://www.w3.org/1998/Math/MathML'>
            <mstyle displaystyle='true'>
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mrow>
                    <mo>i</mo>
                    <mo>=</mo>
                    <mn>1</mn>
                  </mrow>
                  <mo>n</mo>
                </munderover>
              </mrow>
              <msup>
                <mo>i</mo>
                <mn>3</mn>
              </msup>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of simple sin formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new,
        ])
      }
      it "returns formula of sin" do
        expected_value =
        <<~MATHML
          <math xmlns='http://www.w3.org/1998/Math/MathML'>
            <mstyle displaystyle='true'>
              <mi>sin</mi>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of simple text formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("sinsumsomunicode[:Gamma]gamma"),
        ])
      }
      it "returns formula of text" do
        expected_value =
        <<~MATHML
          <math xmlns='http://www.w3.org/1998/Math/MathML'>
            <mstyle displaystyle='true'>
              <mtext>sinsumsom&#x393;gamma</mtext>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of simple text formula multiple unicodes" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("sinsumsomunicode[:Gamma]unicode[:gamma]"),
        ])
      }
      it "returns formula of text" do
        expected_value =
        <<~MATHML
          <math xmlns='http://www.w3.org/1998/Math/MathML'>
            <mstyle displaystyle='true'>
              <mtext>sinsumsom&#x393;&#x3B3;</mtext>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sum frac formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Number.new("3"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("n"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("("),
                    Plurimath::Math::Symbol.new("n"),
                    Plurimath::Math::Symbol.new("+"),
                    Plurimath::Math::Number.new("1"),
                    Plurimath::Math::Symbol.new(")"),
                  ]),
                ]),
                Plurimath::Math::Number.new("2"),
              ),
              Plurimath::Math::Symbol.new(")"),
            ]),
            Plurimath::Math::Number.new("2"),
          )
        ])
      }
      it "returns formula of sum and frac" do
        expected_value =
        <<~MATHML
          <math xmlns='http://www.w3.org/1998/Math/MathML'>
            <mstyle displaystyle='true'>
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mrow>
                    <mo>i</mo>
                    <mo>=</mo>
                    <mn>1</mn>
                  </mrow>
                  <mo>n</mo>
                </munderover>
              </mrow>
              <msup>
                <mo>i</mo>
                <mn>3</mn>
              </msup>
              <mo>=</mo>
              <msup>
                <mrow>
                  <mo>(</mo>
                  <mfrac>
                    <mrow>
                      <mo>n</mo>
                      <mrow>
                        <mo>(</mo>
                        <mo>n</mo>
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
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sin sum and theta formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula of sum" do
        expected_value =
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
                      <mo>&#x3B8;</mo>
                    </mrow>
                  </mover>
                  <mo>)</mo>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sum only exponent formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Function::Sum.new,
          )
        ])
      }
      it "returns formula of sum" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sum with Theta formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("Theta"),
            ]),
            Plurimath::Math::Function::Sum.new,
          )
        ])
      }
      it "returns formula of sum" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sum with square formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula of sum" do
        expected_value =
        <<~MATHML
          <math xmlns='http://www.w3.org/1998/Math/MathML'>
            <mstyle displaystyle='true'>
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mrow>
                    <mo>i</mo>
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
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of log text formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::PowerBase.new(
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
      }
      it "returns formula of log and text" do
        expected_value =
        <<~MATHML
          <math xmlns='http://www.w3.org/1998/Math/MathML'>
            <mstyle displaystyle='true'>
              <mrow>
                <mrow>
                  <msubsup>
                    <mo>log</mo>
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
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of simple symbol formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1234")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i")
            ])
          )
        ])
      }
      it "returns formula of symbol" do
        expected_value =
        <<~MATHML
          <math xmlns='http://www.w3.org/1998/Math/MathML'>
            <mstyle displaystyle='true'>
              <mover>
                <mrow>
                  <mo>i</mo>
                </mrow>
                <mrow>
                  <mn>1234</mn>
                </mrow>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of mod formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("12"),
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
      }
      it "returns formula of mod" do
        expected_value =
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
                <mo>i</mo>
                <mo>)</mo>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of symbols and text formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::PowerBase.new(
                Plurimath::Math::Symbol.new("a"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::Table.new([
                    Plurimath::Math::Function::Tr.new([
                      Plurimath::Math::Function::Td.new([
                        Plurimath::Math::Number.new("1"),
                      ])
                    ]),
                    Plurimath::Math::Function::Tr.new([
                      Plurimath::Math::Function::Td.new([
                        Plurimath::Math::Symbol.new("+"),
                      ])
                    ]),
                    Plurimath::Math::Function::Tr.new([
                      Plurimath::Math::Function::Td.new([
                        Plurimath::Math::Number.new("2"),
                      ])
                    ]),
                    Plurimath::Math::Function::Tr.new([
                      Plurimath::Math::Function::Td.new([
                        Plurimath::Math::Symbol.new("+"),
                      ])
                    ]),
                    Plurimath::Math::Function::Tr.new([
                      Plurimath::Math::Function::Td.new([
                        Plurimath::Math::Number.new("3"),
                      ])
                    ]),
                    Plurimath::Math::Function::Tr.new([
                      Plurimath::Math::Function::Td.new([
                        Plurimath::Math::Symbol.new("+"),
                      ])
                    ]),
                    Plurimath::Math::Function::Tr.new([
                      Plurimath::Math::Function::Td.new([
                        Plurimath::Math::Number.new("4"),
                      ])
                    ]),
                  ])
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
      }
      it "returns formula of symbols and text" do
        expected_value =
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
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sqrt formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sqrt.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Sum.new
            ])
          )
        ])
      }
      it "returns formula of sqrt" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of symbol (using mfenced tag) formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::PowerBase.new(
                Plurimath::Math::Symbol.new("a"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::Fenced.new(
                    Plurimath::Math::Symbol.new("{"),
                    [
                      Plurimath::Math::Function::Table.new([
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([
                            Plurimath::Math::Number.new("1"),
                          ])
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([
                            Plurimath::Math::Symbol.new("+"),
                          ])
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([
                            Plurimath::Math::Number.new("2"),
                          ])
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([
                            Plurimath::Math::Symbol.new("+"),
                          ])
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([
                            Plurimath::Math::Number.new("3"),
                          ])
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([
                            Plurimath::Math::Symbol.new("+"),
                          ])
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([
                            Plurimath::Math::Number.new("4"),
                          ])
                        ]),
                      ])
                    ],
                    Plurimath::Math::Symbol.new("}"),
                  )
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
      }
      it "returns formula of symbol" do
        expected_value =
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
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sum and ne formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula of sum and ne" do
        expected_value =
        <<~MATHML
          <math xmlns='http://www.w3.org/1998/Math/MathML'>
            <mstyle displaystyle='true'>
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mrow>
                    <mo>i</mo>
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
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains mathml string of sum ne and longer text formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
              Plurimath::Math::Symbol.new("something"),
            )
          ])
        ])
      }
      it "returns formula of sum and ne" do
        expected_value =
        <<~MATHML
          <math xmlns='http://www.w3.org/1998/Math/MathML'>
            <mstyle displaystyle='true'>
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mrow>
                    <mo>i</mo>
                    <mo>=</mo>
                    <mstyle mathcolor='blue'>
                      <mrow>
                        <mo>&#x2260;</mo>
                      </mrow>
                    </mstyle>
                  </mrow>
                  <mo>something</mo>
                </munderover>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end
  end
end
