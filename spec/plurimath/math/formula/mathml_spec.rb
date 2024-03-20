require "spec_helper"

RSpec.describe Plurimath::Math::Formula do
  describe ".to_mathml" do
    subject(:formula) { exp.to_mathml(display_style: display_style) }
    let(:display_style) { true }

    context "contains mathml string of sin formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new,
          Plurimath::Math::Number.new("1"),
        ])
      }
      it "returns formula of sin from mathml string" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>sin</mi>
              <mn>1</mn>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sum and prod formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Function::Prod.new,
            Plurimath::Math::Symbol.new("vvv")
          )
        ])
      }
      it "returns formula of sum and prod" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&#x220f;</mo>
                <mo>&#x22c1;</mo>
              </munderover>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sum formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Symbol.new("s"),
          )
        ])
      }
      it "returns formula of sum and prod" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover>
                <mo>&#x2211;</mo>
                <mi>x</mi>
                <mi>s</mi>
              </munderover>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sum with text formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Symbol.new("w"),
          ),
          Plurimath::Math::Function::Text.new("something"),
        ])
      }
      it "returns formula of sum" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover>
                <mo>&#x2211;</mo>
                <mi>x</mi>
                <mi>w</mi>
              </munderover>
              <mtext>something</mtext>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sin with sum formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Sin.new,
            Plurimath::Math::Function::Sum.new,
          )
        ])
      }
      it "returns formula of sin" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mi>sin</mi>
                <mo>&#x2211;</mo>
              </msub>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sin and sum formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Sin.new,
            Plurimath::Math::Function::Sum.new,
          )
        ])
      }
      it "returns formula of sin" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msup>
                <mi>sin</mi>
                <mo>&#x2211;</mo>
              </msup>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sin sum and prod formula" do
      let(:exp) {
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
      }
      it "returns formula of sin" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mi>sin</mi>
                <mrow>
                  <mo>&#x220f;</mo>
                </mrow>
                <mrow>
                  <mo>&#x2211;</mo>
                </mrow>
              </msubsup>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sum with symbol formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
              Plurimath::Math::Function::Sum.new,
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("n"),
            ),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Number.new("3"),
          )
        ])
      }
      it "returns formula of sum" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover>
                <mo>&#x2211;</mo>
                <mi>i</mi>
                <mi>n</mi>
              </munderover>
              <msup>
                <mi>i</mi>
                <mn>3</mn>
              </msup>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
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
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>sin</mi>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
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
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtext>sinsumsom&#x393;gamma</mtext>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
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
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mtext>sinsumsom&#x393;&#x3b3;</mtext>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sum frac formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Symbol.new("n"),
          ),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Number.new("3"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("n"),
                Plurimath::Math::Number.new("1"),
              ]),
              Plurimath::Math::Number.new("2"),
            ),
            Plurimath::Math::Number.new("2"),
          )
        ])
      }
      it "returns formula of sum and frac" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover>
                <mo>&#x2211;</mo>
                <mn>1</mn>
                <mi>n</mi>
              </munderover>
              <msup>
                <mi>i</mi>
                <mn>3</mn>
              </msup>
              <mo>=</mo>
              <msup>
                <mfrac>
                  <mrow>
                    <mi>n</mi>
                    <mn>1</mn>
                  </mrow>
                  <mn>2</mn>
                </mfrac>
                <mn>2</mn>
              </msup>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sin sum and theta formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new,
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Symbol.new("theta"),
            Plurimath::Math::Function::Sum.new,
          ),
        ])
      }
      it "returns formula of sum" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mi>sin</mi>
              <mover>
                <mo>&#x2211;</mo>
                <mo>&#x3b8;</mo>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
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
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mo>&#x2211;</mo>
                <mn>3</mn>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sum with Theta formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Symbol.new("Theta"),
            Plurimath::Math::Function::Sum.new,
          )
        ])
      }
      it "returns formula of sum" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mo>&#x2211;</mo>
                <mo>&#x398;</mo>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sum with square formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Number.new("12"),
              Plurimath::Math::Symbol.new("square")
            ),
            Plurimath::Math::Number.new("33"),
          )
        ])
      }
      it "returns formula of sum" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover>
                <mo>&#x2211;</mo>
                <mfrac>
                  <mn>12</mn>
                  <mo>&#x25a1;</mo>
                </mfrac>
                <mn>33</mn>
              </munderover>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of log text formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Log.new,
            Plurimath::Math::Number.new("4"),
            Plurimath::Math::Function::Text.new("4terms"),
          )
        ])
      }
      it "returns formula of log and text" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mi>log</mi>
                <mn>4</mn>
                <mtext>4terms</mtext>
              </msubsup>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of simple symbol formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Number.new("1234"),
            Plurimath::Math::Symbol.new("i"),
          )
        ])
      }
      it "returns formula of symbol" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover>
                <mi>i</mi>
                <mn>1234</mn>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of mod formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("12"),
          Plurimath::Math::Function::Mod.new,
          Plurimath::Math::Number.new("1234"),
          Plurimath::Math::Symbol.new("i"),
        ])
      }
      it "returns formula of mod" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mn>12</mn>
              <mrow>
                <mi>mod</mi>
              </mrow>
              <mn>1234</mn>
              <mi>i</mi>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of symbols and text formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Function::Table.new([
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1"),
                ])
              ]),
            ]),
            Plurimath::Math::Function::Text.new("4terms"),
          )
        ])
      }
      it "returns formula of symbols and text" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mi>a</mi>
                <mtable>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                  </mtr>
                </mtable>
                <mtext>4terms</mtext>
              </msubsup>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of table with norm" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Function::Table.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("1"),
                  ])
                ]),
              ],
              "norm["
            ),
            Plurimath::Math::Function::Text.new("4terms"),
          )
        ])
      }
      it "returns formula of symbols and text" do
        expected_value = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mi>a</mi>
                <mrow>
                  <mo>&#x2016;</mo>
                  <mtable>
                    <mtr>
                      <mtd>
                        <mn>1</mn>
                      </mtd>
                    </mtr>
                  </mtable>
                  <mo>&#x2016;</mo>
                </mrow>
                <mtext>4terms</mtext>
              </msubsup>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of table with opening bracket" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Function::Table.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("1"),
                  ])
                ]),
              ],
              "["
            ),
            Plurimath::Math::Function::Text.new("4terms"),
          )
        ])
      }
      it "returns formula of symbols and text" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mi>a</mi>
                <mrow>
                  <mo>[</mo>
                  <mtable>
                    <mtr>
                      <mtd>
                        <mn>1</mn>
                      </mtd>
                    </mtr>
                  </mtable>
                  <mo></mo>
                </mrow>
                <mtext>4terms</mtext>
              </msubsup>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sqrt formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sqrt.new(
            Plurimath::Math::Function::Sum.new
          )
        ])
      }
      it "returns formula of sqrt" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msqrt>
                <mo>&#x2211;</mo>
              </msqrt>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of symbol (using mfenced tag) formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("{"),
              [
                Plurimath::Math::Function::Table.new([
                  Plurimath::Math::Function::Tr.new([
                    Plurimath::Math::Function::Td.new([
                      Plurimath::Math::Number.new("1"),
                    ])
                  ]),
                ])
              ],
              Plurimath::Math::Symbol.new("}"),
            ),
            Plurimath::Math::Function::Text.new("4terms"),
          )
        ])
      }
      it "returns formula of symbol" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mi>a</mi>
                <mrow>
                  <mo>{</mo>
                  <mtable>
                    <mtr>
                      <mtd>
                        <mn>1</mn>
                      </mtd>
                    </mtr>
                  </mtable>
                  <mo>}</mo>
                </mrow>
                <mtext>4terms</mtext>
              </msubsup>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sum and ne formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Function::Color.new(
                Plurimath::Math::Function::Text.new("blue"),
                Plurimath::Math::Symbol.new("!="),
              )
            ]),
            Plurimath::Math::Number.new("33"),
          )
        ])
      }
      it "returns formula of sum and ne" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover>
                <mo>&#x2211;</mo>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mstyle mathcolor="blue">
                    <mo>&#x2260;</mo>
                  </mstyle>
                </mrow>
                <mn>33</mn>
              </munderover>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sum ne and longer text formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Function::Color.new(
                Plurimath::Math::Function::Text.new("blue"),
                Plurimath::Math::Symbol.new("!="),
              )
            ]),
            Plurimath::Math::Symbol.new("something"),
          )
        ])
      }
      it "returns formula of sum and ne" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munderover>
                <mo>&#x2211;</mo>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mstyle mathcolor="blue">
                    <mo>&#x2260;</mo>
                  </mstyle>
                </mrow>
                <mi>something</mi>
              </munderover>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string of sum ne and longer text formula" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Root.new(
            Plurimath::Math::Function::Text.new("Some"),
            Plurimath::Math::Function::Text.new("thing"),
          )
        ])
      }
      it "returns formula of sum and ne" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mroot>
                <mtext>Some</mtext>
                <mtext>thing</mtext>
              </mroot>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string bold text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Root.new(
            Plurimath::Math::Function::Text.new("Some"),
            Plurimath::Math::Function::FontStyle::Bold.new(
              Plurimath::Math::Function::Text.new("thing"),
              "bold",
            )
          )
        ])
      }
      it "returns string of bold text" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mroot>
                <mtext>Some</mtext>
                <mstyle mathvariant="bold">
                  <mtext>thing</mtext>
                </mstyle>
              </mroot>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains mathml string bold text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("n"),
          Plurimath::Math::Symbol.new("<"),
          Plurimath::Math::Number.new("1")
        ])
      }
      let(:display_style) { false }
      it "returns string of bold text" do
        expected_value =
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="false">
              <mi>n</mi>
              <mo>&lt;</mo>
              <mn>1</mn>
            </mstyle>
          </math>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end
end
