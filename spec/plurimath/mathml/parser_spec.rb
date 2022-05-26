require_relative "../../../lib/plurimath/mathml"

RSpec.describe Plurimath::Mathml::Parser do

  subject(:formula) { Plurimath::Mathml::Parser.new(exp).parse }

  context "contains mathml string of sin formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle displaystyle='true'>
            <mi>sin</mi>
            <mn>1</mn>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of sin from mathml string" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Sin.new,
        Plurimath::Math::Number.new("1"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum and prod formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <munderover>
            <mo>&#x2211;</mo>
            <mo>&#x220f;</mo>
            <mo>&#x22c1;</mo>
          </munderover>
        </math>
      MATHML
    }
    it "returns formula of sum and prod" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Underover.new(
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Function::Prod.new,
          Plurimath::Math::Symbol.new("vvv"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <munderover>
            <mo>&#x2211;</mo>
            <mi>x</mi>
            <mi>s</mi>
          </munderover>
        </math>
      MATHML
    }
    it "returns formula of sum and prod" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Underover.new(
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("s"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum with text formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
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
          <mtext>something</mtext>
        </math>
      MATHML
    }
    it "returns formula of sum" do
      expected_value = Plurimath::Math::Formula.new([
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
        ),
        Plurimath::Math::Function::Text.new("something")
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sin with sum formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msub>
            <mi>sin</mi>
            <mo>&#x2211;</mo>
          </msub>
        </math>
      MATHML
    }
    it "returns formula of sin" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Base.new(
          Plurimath::Math::Function::Sin.new,
          Plurimath::Math::Function::Sum.new,
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sin and sum formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msup>
            <mi>sin</mi>
            <mo>&#x2211;</mo>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of sin" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Function::Sin.new,
          Plurimath::Math::Function::Sum.new
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sin sum and prod formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msubsup>
            <mi>sin</mi>
            <mo>&#x220f;</mo>
            <mo>&#x2211;</mo>
          </msubsup>
        </math>
      MATHML
    }
    it "returns formula of sin" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::PowerBase.new(
          Plurimath::Math::Function::Sin.new,
          Plurimath::Math::Function::Prod.new,
          Plurimath::Math::Function::Sum.new,
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum with symbol formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <munderover>
            <mo>&#x2211;</mo>
            <mn>1</mn>
            <mi>n</mi>
          </munderover>
          <msup>
            <mi>i</mi>
            <mn>3</mn>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of sum" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Underover.new(
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new("n"),
        ),
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Symbol.new("i"),
          Plurimath::Math::Number.new("3"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of simple sin formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mrow>sin</mrow>
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
          <mtext>sinsumsom&#x393;gamma</mtext>
        </math>
      MATHML
    }
    it "returns formula of text" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Text.new("sinsumsomunicode[:Gamma]gamma"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of simple text formula multiple unicodes" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mtext>sinsumsom&#x393;&#x3B3;</mtext>
        </math>
      MATHML
    }
    it "returns formula of text" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Text.new("sinsumsomunicode[:Gamma]unicode[:gamma]"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum frac formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
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
              <mi>n</mi>
              <mn>2</mn>
            </mfrac>
            <mn>2</mn>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of sum and frac" do
      expected_value = Plurimath::Math::Formula.new([
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
            Plurimath::Math::Symbol.new("n"),
            Plurimath::Math::Number.new("2"),
          ),
          Plurimath::Math::Number.new("2"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sin sum and theta formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mi>sin</mi>
          <mover>
            <mo>&#x2211;</mo>
            <mi>&#x3B8;</mi>
          </mover>
        </math>
      MATHML
    }
    it "returns formula of sum" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Sin.new,
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Symbol.new("theta"),
          Plurimath::Math::Function::Sum.new,
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum only exponent formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mover>
            <mo>&#x2211;</mo>
            <mn>3</mn>
          </mover>
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
          <mover>
            <mo>&#x2211;</mo>
            <mo>&#x398;</mo>
          </mover>
        </math>
      MATHML
    }
    it "returns formula of sum" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Number.new("Theta"),
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
        </math>
      MATHML
    }
    it "returns formula of sum" do
      expected_value = Plurimath::Math::Formula.new([
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
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of log text formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msubsup>
            <mi>log</mi>
            <mn>4</mn>
            <mtext>4 terms</mtext>
          </msubsup>
        </math>
      MATHML
    }
    it "returns formula of log and text" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::PowerBase.new(
          Plurimath::Math::Function::Log.new,
          Plurimath::Math::Number.new("4"),
          Plurimath::Math::Function::Text.new("4terms"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of simple symbol formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mover>
            <mi>i</mi>
            <mn>1234</mn>
          </mover>
        </math>
      MATHML
    }
    it "returns formula of symbol" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Number.new("1234"),
          Plurimath::Math::Symbol.new("i"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of mod formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mn>12</mn>
          <mo>mod</mo>
          <mn>1234</mn>
          <mi>i</mi>
        </math>
      MATHML
    }
    it "returns formula of mod" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Symbol.new("12"),
        Plurimath::Math::Function::Mod.new,
        Plurimath::Math::Number.new("1234"),
        Plurimath::Math::Symbol.new("i"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of symbols and text formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msubsup>
            <mo>a</mo>
            <mtable>
              <mtr>
                <mtd>
                  <mn>1</mn>
                </mtd>
              </mtr>
            </mtable>
            <mtext>4 terms</mtext>
          </msubsup>
        </math>
      MATHML
    }
    it "returns formula of symbols and text" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::PowerBase.new(
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Function::Table.new([
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("1"),
              ])
            ]),
          ]),
          Plurimath::Math::Function::Text.new("4terms")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sqrt formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msqrt>
            <mo>&#x2211;</mo>
          </msqrt>
        </math>
      MATHML
    }
    it "returns formula of sqrt" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Sqrt.new(
          Plurimath::Math::Function::Sum.new
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of symbol (using mfenced tag) formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msubsup>
                  <mo>a</mo>
                  <mfenced open='{' close='}'>
                    <mtable>
                      <mtr>
                        <mtd>
                          <mn>1</mn>
                        </mtd>
                      </mtr>
                    </mtable>
                  </mfenced>
                  <mtext>4 terms</mtext>
                </msubsup>
        </math>
      MATHML
    }
    it "returns formula of symbol" do
      expected_value = Plurimath::Math::Formula.new([
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
              ]),
            ],
            Plurimath::Math::Symbol.new("}"),
          ),
          Plurimath::Math::Function::Text.new("4terms"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of int and f formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msubsup>
            <mo>&#x222B;</mo>
            <mn>0</mn>
            <mn>1</mn>
          </msubsup>
          <mi>f</mi>
          <mi>x</mi>
          <mi>d</mi>
          <mi>x</mi>
        </math>
      MATHML
    }
    it "returns formula of int and f" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::PowerBase.new(
          Plurimath::Math::Function::Int.new,
          Plurimath::Math::Number.new("0"),
          Plurimath::Math::Number.new("1"),
        ),
        Plurimath::Math::Function::F.new,
        Plurimath::Math::Symbol.new("x"),
        Plurimath::Math::Symbol.new("d"),
        Plurimath::Math::Symbol.new("x"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of log and text formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msup>
            <mrow>
              <mi>log</mi>
              <mn>4</mn>
            </mrow>
            <mrow>
              <mtext>4 terms\</mtext>
            </mrow>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of log and text" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Log.new,
            Plurimath::Math::Number.new("4"),
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("4terms")
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of prod and theta formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <munder>
            <mo>&#x220F;</mo>
            <mi>&#x3B8;</mi>
          </munder>
          <mi>i</mi>
        </math>
      MATHML
    }
    it "returns formula of prod and theta" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Underset.new(
          Plurimath::Math::Symbol.new("theta"),
          Plurimath::Math::Function::Prod.new,
        ),
        Plurimath::Math::Symbol.new("i"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of root and theta  formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mroot>
            <mi>&#x3B8;</mi>
            <mi>x</mi>
          </mroot>
        </math>
      MATHML
    }
    it "returns formula of root and theta" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Root.new(
          Plurimath::Math::Symbol.new("theta"),
          Plurimath::Math::Symbol.new("x"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of ubrace formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mover>
            <mn>4</mn>
            <mo>&#x23DF;</mo>
          </mover>
        </math>
      MATHML
    }
    it "returns formula of ubrace" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Ubrace.new(
          Plurimath::Math::Number.new("4"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum and ne formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <munderover>
            <mo>&#x2211;</mo>
            <mrow>
              <mi>i</mi>
              <mo>=</mo>
              <mstyle mathcolor='blue'>
                <mo>&#x2260;</mo>
              </mstyle>
            </mrow>
            <mn>33</mn>
          </munderover>
        </math>
      MATHML
    }
    it "returns formula of sum and ne" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Underover.new(
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Function::Color.new(
              Plurimath::Math::Symbol.new("blue"),
              Plurimath::Math::Symbol.new("!="),
            )
          ]),
          Plurimath::Math::Number.new("33"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum and frac formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <munderover>
            <mo>&#x2211;</mo>
            <mrow>
              <mi>i</mi>
              <mo>=</mo>
              <mo>frac</mo>
            </mrow>
            <mn>33</mn>
          </munderover>
        </math>
      MATHML
    }
    it "returns formula of sum and frac" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Underover.new(
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Function::Frac.new,
          ]),
          Plurimath::Math::Number.new("33"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum sin and frac formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
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
            <mrow>
              <mi>sin</mi>
              <mfrac>
                <mi>n</mi>
                <mn>2</mn>
              </mfrac>
            </mrow>
            <mn>2</mn>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of sum sin and frac" do
      expected_value = Plurimath::Math::Formula.new([
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
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Sin.new,
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Symbol.new("n"),
              Plurimath::Math::Number.new("2"),
            ),
          ]),
          Plurimath::Math::Number.new("2"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of abs formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mo>|</mo>
          <mn>4</mn>
          <mo>|</mo>
        </math>
      MATHML
    }
    it "returns formula of abs" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Symbol.new("|"),
        Plurimath::Math::Number.new("4"),
        Plurimath::Math::Symbol.new("|"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of mathfrak formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle mathvariant="fraktur">
            <mi>f</mi>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of mathfrak" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::FontStyle.new(
          Plurimath::Math::Function::F.new,
          "fraktur",
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of Mathsf formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle mathvariant="sans-serif">
            <mi>f</mi>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of Mathsf" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::FontStyle.new(
          Plurimath::Math::Function::F.new,
          "sans-serif",
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of Mathtt formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle mathvariant="monospace">
            <mi>f</mi>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of Mathtt" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::FontStyle.new(
          Plurimath::Math::Function::F.new,
          "monospace",
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of Mathcal formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle mathvariant="script">
            <mi>f</mi>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of Mathcal" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::FontStyle.new(
          Plurimath::Math::Function::F.new,
          "script",
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of Mathbb formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle mathvariant="double-struck">
            <mi>s</mi>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of Mathbb" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::FontStyle.new(
          Plurimath::Math::Symbol.new("s"),
          "double-struck",
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of Mathbf formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle mathvariant="bold">
            <mi>d</mi>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of Mathbf" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::FontStyle.new(
          Plurimath::Math::Symbol.new("d"),
          "bold",
        )
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
