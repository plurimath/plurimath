require "spec_helper"

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
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new,
          Plurimath::Math::Number.new("1"),
        ])
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
        Plurimath::Math::Function::Sum.new(
          Plurimath::Math::Function::Prod.new,
          Plurimath::Math::Symbol.new("&#x22c1;"),
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
        Plurimath::Math::Function::Sum.new(
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
        Plurimath::Math::Function::Sum.new(
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
        Plurimath::Math::Function::Sum.new(
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
        Plurimath::Math::Function::Sum.new(
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
          Plurimath::Math::Symbol.new("&#x3b8;"),
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
          Plurimath::Math::Number.new("&#x398;"),
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
        Plurimath::Math::Function::Sum.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Number.new("12"),
              Plurimath::Math::Symbol.new("&#x25a1;")
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
        Plurimath::Math::Function::Log.new(
          Plurimath::Math::Number.new("4"),
          Plurimath::Math::Function::Text.new("4 terms"),
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
          Plurimath::Math::Function::Text.new("4 terms")
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

  context "contains mathml mfenced tag and solid columnlines for table formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msubsup>
            <mo>a</mo>
            <mfenced open='{' close='}'>
              <mtable columnlines="solid">
                <mtr>
                  <mtd>
                    <mn>1</mn>
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
                    Plurimath::Math::Number.new("1"),
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("|"),
                  ]),
                ]),
              ]),
            ],
            Plurimath::Math::Symbol.new("}"),
          ),
          Plurimath::Math::Function::Text.new("4 terms"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml mfenced tag and solid columnlines for table formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msubsup>
            <mo>a</mo>
            <mfenced open='{' close='}'>
              <mtable columnlines="none">
                <mtr>
                  <mtd>
                    <mn>1</mn>
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
                    Plurimath::Math::Number.new("1"),
                  ])
                ]),
              ]),
            ],
            Plurimath::Math::Symbol.new("}"),
          ),
          Plurimath::Math::Function::Text.new("4 terms"),
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
        Plurimath::Math::Function::Int.new(
          Plurimath::Math::Number.new("0"),
          Plurimath::Math::Number.new("1"),
        ),
        Plurimath::Math::Symbol.new("f"),
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
          Plurimath::Math::Function::Text.new("4 terms")
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
          Plurimath::Math::Symbol.new("&#x3b8;"),
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
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("&#x3b8;"),
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

  context "contains mathml string of obrace formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <munder>
            <mn>4</mn>
            <mo>&#x23DE;</mo>
          </munder>
        </math>
      MATHML
    }
    it "returns formula of obrace" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Obrace.new(
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
        Plurimath::Math::Function::Sum.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Function::Color.new(
              Plurimath::Math::Function::Text.new("blue"),
              Plurimath::Math::Symbol.new("&#x2260;"),
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
        Plurimath::Math::Function::Sum.new(
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
        Plurimath::Math::Function::Sum.new(
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new("n"),
        ),
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Symbol.new("i"),
          Plurimath::Math::Number.new("3"),
        ),
        Plurimath::Math::Symbol.new("="),
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Symbol.new("n"),
              Plurimath::Math::Number.new("2"),
            ),
          ),
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
        Plurimath::Math::Function::FontStyle::Fraktur.new(
          Plurimath::Math::Symbol.new("f"),
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
        Plurimath::Math::Function::FontStyle::SansSerif.new(
          Plurimath::Math::Symbol.new("f"),
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
        Plurimath::Math::Function::FontStyle::Monospace.new(
          Plurimath::Math::Symbol.new("f"),
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
        Plurimath::Math::Function::FontStyle::Script.new(
          Plurimath::Math::Symbol.new("f"),
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
        Plurimath::Math::Function::FontStyle::DoubleStruck.new(
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
        Plurimath::Math::Function::FontStyle::Bold.new(
          Plurimath::Math::Symbol.new("d"),
          "bold",
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of random string as font style fraktur formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle mathcolor="red" mathvariant="fraktur">
            <mi>d</mi>
          </mstyle>
        </math>
      MATHML
    }
    it "returns FontStyle with second value asci" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Color.new(
          Plurimath::Math::Function::Text.new("red"),
          Plurimath::Math::Function::FontStyle::Fraktur.new(
            Plurimath::Math::Symbol.new("d"),
            "fraktur",
          )
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of random string as font style asci formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle mathcolor="red" mathvariant="asci">
            <mi>d</mi>
          </mstyle>
        </math>
      MATHML
    }
    it "returns FontStyle with second value asci" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Color.new(
          Plurimath::Math::Function::Text.new("red"),
          Plurimath::Math::Symbol.new("d"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of Mathbf formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msgroup>
            <mi>33</mi>
            <mtext>dd</mtext>0
          </msgroup>
        </math>
      MATHML
    }
    it "returns formula of Mathbf" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Msgroup.new([
          Plurimath::Math::Number.new("33"),
          Plurimath::Math::Function::Text.new("dd"),
          Plurimath::Math::Number.new("0\n  "),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of Mathbf formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msgroup>
            <mi>33</mi>
            <mi>dd</mi>0
          </msgroup>
        </math>
      MATHML
    }
    it "returns formula of Mathbf" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Msgroup.new([
          Plurimath::Math::Number.new("33"),
          Plurimath::Math::Symbol.new("dd"),
          Plurimath::Math::Number.new("0\n  ")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of Mathbf formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msgroup>
            <mi>n</mi>
            <mi>&#x3c;</mi>
            <mn>1</mn>
          </msgroup>
        </math>
      MATHML
    }
    it "returns formula of Mathbf" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Msgroup.new([
          Plurimath::Math::Symbol.new("n"),
          Plurimath::Math::Symbol.new("&#x3c;"),
          Plurimath::Math::Number.new("1")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of dot decimal values only" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msgroup>
            <mn>1.4</mn>
          </msgroup>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Msgroup.new([
          Plurimath::Math::Number.new("1.4"),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of comma decimal values only" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msgroup>
            <mn>1,4</mn>
          </msgroup>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Msgroup.new([
          Plurimath::Math::Number.new("1,4"),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of comma decimal values only" do
    let(:exp) {
      <<~MATHML
        <math>
          <msub>
            <mrow>
              <mover accent="true">
                <mrow>
                  <mi>e</mi>
                </mrow>
                <mo>^</mo>
              </mover>
            </mrow>
            <mrow>
              <mi>r</mi>
            </mrow>
          </msub>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Base.new(
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Symbol.new("e"),
            { accent: true }
          ),
          Plurimath::Math::Symbol.new("r"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml empty text tag with slash" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msup>
            <mtext/>
            <mn>12</mn>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Function::Text.new(""),
          Plurimath::Math::Number.new("12"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml empty text tag" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msup>
            <mtext></mtext>
            <mn>12</mn>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Function::Text.new(""),
          Plurimath::Math::Number.new("12"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of comma decimal values only" do
    let(:exp) {
      <<~MATHML
        <math>
          <mo>Δ</mo>
          <mrow>
            <mi>ν</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Symbol.new("&#x394;"),
        Plurimath::Math::Symbol.new("&#x3bd;")
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of comma decimal values only" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow xref="U_GOhm">
            <mi mathvariant="normal">GΩ</mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::FontStyle::Normal.new(
          Plurimath::Math::Symbol.new("G&#x2126;"),
          "normal",
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string from metanorma/mn-samples-bipm" do
    let(:exp) {
      <<~MATHML
        <math xmlns="http://www.w3.org/1998/Math/MathML">
          <mathml:mstyle scriptminsize="6pt">
            <msub>
              <mrow>
                <mstyle mathvariant="italic">
                  <mi>T</mi>
                </mstyle>
              </mrow>
              <mrow>
                <mn>90</mn>
              </mrow>
            </msub>
            <mo stretchy="false" lspace="0.1em" rspace="0em">/</mo>
            <mrow xref="U_NISTu5">
              <mi mathvariant="normal">K</mi>
            </mrow>
            <mo>=</mo>
            <msub>
              <mrow>
                <mstyle mathvariant="italic">
                  <mi>A</mi>
                </mstyle>
              </mrow>
              <mrow>
                <mn>0</mn>
              </mrow>
            </msub>
            <mo>+</mo>
            <munderover>
              <mrow>
                <mo>∑</mo>
              </mrow>
              <mrow>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mn>1</mn>
                </mrow>
              </mrow>
              <mrow>
                <mn>9</mn>
              </mrow>
            </munderover>
            <msub>
              <mrow>
                <mstyle mathvariant="italic">
                  <mi>A</mi>
                </mstyle>
              </mrow>
              <mrow>
                <mi>i</mi>
              </mrow>
            </msub>
            <msup>
              <mrow>
                <mfenced open="[" close="]" separators="">
                  <mathml:mspace width="-0.15em"/>
                  <mrow>
                    <mfenced open="(" close=")" separators="">
                      <mathml:mspace width="-0.15em"/>
                      <mrow>
                        <mi>ln</mi>
                        <mathml:mo rspace="-0.35em"/>
                        <mfenced open="(" close=")" separators="">
                          <mathml:mspace width="-0.15em"/>
                          <mrow>
                            <mi>p</mi>
                            <mo stretchy="false" lspace="0em" rspace="0em">/</mo>
                            <mrow xref="U_NISTu12">
                              <mi mathvariant="normal">Pa</mi>
                            </mrow>
                          </mrow>
                          <mathml:mspace width="-0.1em"/>
                        </mfenced>
                        <mo>—</mo>
                        <mstyle mathvariant="italic">
                          <mi>B</mi>
                        </mstyle>
                      </mrow>
                      <mathml:mspace width="-0.1em"/>
                    </mfenced>
                    <mo stretchy="false" lspace="0em" rspace="0em">/</mo>
                    <mstyle mathvariant="italic">
                      <mi>C</mi>
                    </mstyle>
                  </mrow>
                  <mathml:mspace width="-0.1em"/>
                </mfenced>
              </mrow>
              <mrow>
                <mi>i</mi>
              </mrow>
            </msup>
            <mo>.</mo>
          </mathml:mstyle>
        </math>
      MATHML
    }

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::FontStyle::Italic.new(
              Plurimath::Math::Symbol.new("T"),
              "italic",
            ),
            Plurimath::Math::Number.new("90"),
          ),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Function::FontStyle::Normal.new(
            Plurimath::Math::Symbol.new("K"),
            "normal"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::FontStyle::Italic.new(
              Plurimath::Math::Symbol.new("A"),
              "italic",
            ),
            Plurimath::Math::Number.new("0"),
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("9"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::FontStyle::Italic.new(
              Plurimath::Math::Symbol.new("A"),
              "italic",
            ),
            Plurimath::Math::Symbol.new("i"),
          ),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("["),
              [
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::Fenced.new(
                    Plurimath::Math::Symbol.new("("),
                    [
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Function::Ln.new(
                          Plurimath::Math::Function::Fenced.new(
                            Plurimath::Math::Symbol.new("("),
                            [
                              Plurimath::Math::Formula.new([
                                Plurimath::Math::Symbol.new("p"),
                                Plurimath::Math::Symbol.new("/"),
                                Plurimath::Math::Function::FontStyle::Normal.new(
                                  Plurimath::Math::Symbol.new("Pa"),
                                  "normal"
                                )
                              ])
                            ],
                            Plurimath::Math::Symbol.new(")")
                          ),
                        ),
                        Plurimath::Math::Symbol.new("&#x2014;"),
                        Plurimath::Math::Function::FontStyle::Italic.new(
                          Plurimath::Math::Symbol.new("B"),
                          "italic",
                        ),
                      ])
                    ],
                    Plurimath::Math::Symbol.new(")")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::FontStyle::Italic.new(
                    Plurimath::Math::Symbol.new("C"),
                    "italic",
                  ),
                ])
              ],
              Plurimath::Math::Symbol.new("]")
            ),
            Plurimath::Math::Symbol.new("i")
          ),
          Plurimath::Math::Symbol.new(".")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string from metanorma/mn-samples-bipm" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Semantics.new(
          Plurimath::Math::Function::Int.new(
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Symbol.new("t"),
              Plurimath::Math::Number.new("2")
            ),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Symbol.new("t"),
              Plurimath::Math::Number.new("1")
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("f"),
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Symbol.new("t"),
              Plurimath::Math::Symbol.new(")"),
              Plurimath::Math::Symbol.new("d"),
              Plurimath::Math::Symbol.new("t")
            ])
          ),
          [
            {
              annotation: [
                Plurimath::Math::Symbol.new("MathType@MTEF@5@5@+= feaagKart1ev2aaatCvAUfeBSjuyZL2yd9gzLbvyNv2CaerbbjxAHX garuavP1wzZbItLDhis9wBH5garmWu51MyVXgarqqtubsr4rNCHbGe aGqipG0dh9qqWrVepG0dbbL8F4rqqrVepeea0xe9LqFf0xc9q8qqaq Fn0lXdHiVcFbIOFHK8Feea0dXdar=Jb9hs0dXdHuk9fr=xfr=xfrpe WZqaaeaaciWacmGadaGadeaabaGaaqaaaOqaamaapedabaGaamOzai aacIcacaWG0bGaaiykaKqzaeGaaiizaOGaamiDaaWcbaGaamiDamaa BaaameaacaaIYaaabeaaaSqaaiaadshadaWgaaadbaGaaGymaaqaba aaniabgUIiYdaaaa@40DD@ ")
              ]
            }
          ]
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string from issue #89 Exp #1" do
    let(:exp) {
      <<~MATHML
        <math xmlns="http://www.w3.org/1998/Math/MathML">
          <msub>
            <mrow>
              <mstyle mathvariant="italic">
                <mi>D</mi>
              </mstyle>
            </mrow>
            <mrow>
              <mi>i</mi>
            </mrow>
          </msub>
          <mo>=</mo>
          <msub>
            <mrow>
              <mi>x</mi>
            </mrow>
            <mrow>
              <mi>i</mi>
            </mrow>
          </msub>
          <mo>−</mo>
          <msub>
            <mrow>
              <mi>x</mi>
            </mrow>
            <mrow>
              <mrow>
                <mi mathvariant="normal">S</mi>
                <mi mathvariant="normal">R</mi>
                <mi mathvariant="normal">P</mi>
                <mn>27</mn>
              </mrow>
            </mrow>
          </msub>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Base.new(
          Plurimath::Math::Function::FontStyle::Italic.new(
            Plurimath::Math::Symbol.new("D"),
            "italic",
          ),
          Plurimath::Math::Symbol.new("i"),
        ),
        Plurimath::Math::Symbol.new("="),
        Plurimath::Math::Function::Base.new(
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("i"),
        ),
        Plurimath::Math::Symbol.new("&#x2212;"),
        Plurimath::Math::Function::Base.new(
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::FontStyle::Normal.new(
              Plurimath::Math::Symbol.new("S"),
              "normal",
            ),
            Plurimath::Math::Function::FontStyle::Normal.new(
              Plurimath::Math::Symbol.new("R"),
              "normal",
            ),
            Plurimath::Math::Function::FontStyle::Normal.new(
              Plurimath::Math::Symbol.new("P"),
              "normal",
            ),
            Plurimath::Math::Number.new("27"),
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string from issue #89 Exp #2" do
    let(:exp) {
      <<~MATHML
        <math xmlns="http://www.w3.org/1998/Math/MathML">
          <mstyle mathcolor="#ff0000">
            <mtext>Assigned value</mtext>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Color.new(
          Plurimath::Math::Function::Text.new("#ff0000"),
          Plurimath::Math::Function::Text.new("Assigned value")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains metanorma mathml string Exp #1" do
    let(:exp) {
      <<~MATHML
        <math xmlns="http://www.w3.org/1998/Math/MathML">
          <mathml:mstyle scriptminsize="6pt">
            <msub>
              <mrow>
                <mstyle mathvariant="italic">
                  <mi>W</mi>
                </mstyle>
              </mrow>
              <mrow>
                <mi>t</mi>
              </mrow>
            </msub>
            <mathml:mo rspace="-0.35em"/>
            <mfenced open="(" close=")" separators="">
              <mathml:mspace width="-0.15em"/>
              <mrow>
                <msub>
                  <mrow>
                    <mstyle mathvariant="italic">
                      <mi>T</mi>
                    </mstyle>
                  </mrow>
                  <mrow>
                    <mn>90</mn>
                  </mrow>
                </msub>
              </mrow>
              <mathml:mspace width="-0.1em"/>
            </mfenced>
          </mathml:mstyle>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::FontStyle::Italic.new(
              Plurimath::Math::Symbol.new("W"),
              "italic",
            ),
            Plurimath::Math::Symbol.new("t"),
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::FontStyle::Italic.new(
                  Plurimath::Math::Symbol.new("T"),
                  "italic",
                ),
                Plurimath::Math::Number.new("90"),
              )
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end
end
