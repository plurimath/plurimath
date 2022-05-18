require_relative "../../../lib/plurimath/math"

RSpec.describe Plurimath::Latex::Parser do

  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    context "contains cos with argument" do
      let(:string) {
        <<~LATEX
          {3}\\cos{\\beta}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Function::Cos.new(
            Plurimath::Math::Symbol.new("beta")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains simple nested values" do
      let(:string) {
        <<~LATEX
          {a+{b}}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Function::Text.new("b"),
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains left with multiple values and right" do
      let(:string) {
        <<~LATEX
          \\left(\\beta\\slash{t}\\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Left.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("beta"),
              Plurimath::Math::Symbol.new("slash"),
              Plurimath::Math::Function::Text.new("t"),
            ]),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains sqrt function" do
      let(:string) {
        <<~LATEX
          \\sqrt {\\sqrt {\\left( t{3}\\right) v}}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sqrt.new(
            Plurimath::Math::Function::Sqrt.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Left.new(
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Text.new("t"),
                    Plurimath::Math::Number.new("3"),
                  ]),
                ),
                Plurimath::Math::Function::Text.new("v"),
              ])
            )
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains overline function" do
      let(:string) {
        <<~LATEX
          \\overline{v}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Function::Text.new("v")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains empty subscript" do
      let(:string) {
        <<~LATEX
          1_{}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Number.new("1"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains sum with subscript and supscript" do
      let(:string) {
        <<~LATEX
          \\sum_{n=1}^{\\infty}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Symbol.new("infty"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains prod with supscript and subscript" do
      let(:string) {
        <<~LATEX
          \\prod^{\\infty}_{n=1}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Symbol.new("infty"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains bmod with two arguments" do
      let(:string) {
        <<~LATEX
          {a}\\bmod{b}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Function::Text.new("b"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains pmod with two arguments" do
      let(:string) {
        <<~LATEX
          {c}\\pmod{d}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Function::Text.new("d"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains complete, simple math equation" do
      let(:string) {
        <<~LATEX
          3x-5y+4z=0
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Number.new("5"),
          Plurimath::Math::Function::Text.new("y"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Number.new("4"),
          Plurimath::Math::Function::Text.new("z"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("0"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains simple multiplication math equation" do
      let(:string) {
        <<~LATEX
          3x*2
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Number.new("2"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains simple use of over" do
      let(:string) {
        <<~LATEX
          1 \\over 2
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Number.new("2"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains array environment and math equation without separator" do
      let(:string) {
        <<~LATEX
          \\begin{array}{l}{3x-5y+4z=0}\\end{array}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new([
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("3"),
                  Plurimath::Math::Function::Text.new("x"),
                  Plurimath::Math::Symbol.new("-"),
                  Plurimath::Math::Number.new("5"),
                  Plurimath::Math::Function::Text.new("y"),
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Number.new("4"),
                  Plurimath::Math::Function::Text.new("z"),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Number.new("0"),
                ])
              ])
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains array environment and math equation with separator" do
      let(:string) {
        <<~LATEX
          \\begin{array}{|}{3x-5y+4z=0}\\end{array}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new([
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("3"),
                  Plurimath::Math::Function::Text.new("x"),
                  Plurimath::Math::Symbol.new("-"),
                  Plurimath::Math::Number.new("5"),
                  Plurimath::Math::Function::Text.new("y"),
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Number.new("4"),
                  Plurimath::Math::Function::Text.new("z"),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Number.new("0"),
                ]),
              ]),
              Plurimath::Math::Symbol.new("|"),
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains matix environment and subscript math equation" do
      let(:string) {
        <<~LATEX
          \\begin{matrix}
            a_{1} & b_{2} \\\\
            c_{1} & d_{2}
          \\end{matrix}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new([
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("a"),
                  Plurimath::Math::Number.new("1"),
                )
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("b"),
                  Plurimath::Math::Number.new("2"),
                )
              ]),
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("c"),
                  Plurimath::Math::Number.new("1"),
                )
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("d"),
                  Plurimath::Math::Number.new("2"),
                )
              ]),
            ]),
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains binom command" do
      let(:string) {
        <<~LATEX
          \\binom{2}{3}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Number.new("2"),
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Number.new("3"),
            ])],
            "(",
            ")",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains inline matrix with sinle row" do
      let(:string) {
        <<~LATEX
          \\matrix{a & b}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new([
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new("a"),
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new("b"),
              ]),
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains inline matrix with two rows" do
      let(:string) {
        <<~LATEX
          \\Bmatrix{a & b \\\\ c & d}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("a"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("b"),
                ]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("c"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("d"),
                ]),
              ]),
            ],
            "{",
            "}",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains vmatrix with simple two letters" do
      let(:string) {
        <<~LATEX
          \\begin{vmatrix} a & b \\end{vmatrix}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("a")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("b")
                ]),
              ])
            ],
            "|",
            "|",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Bmatrix with negative value" do
      let(:string) {
        <<~LATEX
          \\begin{Bmatrix}-a & b \\\\ c & d \\end{Bmatrix}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("-"),
                  Plurimath::Math::Function::Text.new("a"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("b"),
                ]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("c"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("d"),
                ]),
              ]),
            ],
            "{",
            "}",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains pmatrix with simple letters" do
      let(:string) {
        <<~LATEX
          \\begin{pmatrix}a & b \\end{pmatrix}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("a"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("b"),
                ]),
              ])
            ],
            "(",
            ")",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains array environment without args list separator" do
      let(:string) {
        <<~LATEX
          \\begin{array}{c|r}
            1 & 2 \\hline \\\\ 3 & 4
          \\end{array}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new([
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("1"),
              ]),
              Plurimath::Math::Symbol.new("|"),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbol.new("hline"),
              ]),
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("3"),
              ]),
              Plurimath::Math::Symbol.new("|"),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("4"),
              ]),
            ]),
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains vmatrix with sqrt complete equation" do
      let(:string) {
        <<~LATEX
          \\begin{Vmatrix}
            \\sqrt{(-25)^{2}} = \\pm 25
          \\end{Vmatrix}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Sqrt.new(
                    Plurimath::Math::Function::Power.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("-"),
                          Plurimath::Math::Number.new("25"),
                        ]),
                        Plurimath::Math::Number.new("2"),
                      ),
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Symbol.new("pm"),
                  Plurimath::Math::Number.new("25"),
                ])
              ])
            ],
            "norm[",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains sqrt with args" do
      let(:string) {
        <<~LATEX
          \\sqrt[\\beta]{\\pm}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Root.new(
            Plurimath::Math::Symbol.new("beta"),
            Plurimath::Math::Symbol.new("pm"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains log with subscript" do
      let(:string) {
        <<~LATEX
          \\log_2{x}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new(
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Text.new("x"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains lim with subscript and f" do
      let(:string) {
        <<~LATEX
          \\lim_{x\\to +\\infty} f(x)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Lim.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Symbol.new("to"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Symbol.new("infty"),
            ]),
          ),
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Function::Text.new("x"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains lim with subscript and f" do
      let(:string) {
        <<~LATEX
          \\left( \\begin{array}{c}
              V_x  \\\\
              V_y  \\end{array} \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Left.new(
            Plurimath::Math::Function::Table.new([
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("V"),
                    Plurimath::Math::Function::Text.new("x"),
                  ),
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("V"),
                    Plurimath::Math::Function::Text.new("y"),
                  ),
                ])
              ]),
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains mbox" do
      let(:string) {
        <<~LATEX
          \\mbox(a+b)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a+b")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains frac" do
      let(:string) {
        <<~LATEX
          \\frac{1}{2}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Number.new("2"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains greater than equation" do
      let(:string) {
        <<~LATEX
          {a} > {2}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Number.new("2"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains less than equation" do
      let(:string) {
        <<~LATEX
          {a} < {2}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Symbol.new("<"),
          Plurimath::Math::Number.new("2"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains ampersand symbol only" do
      let(:string) { "&" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains less than equation" do
      let(:string) {
        <<~LATEX
          \\mathrm{R1\\beta}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("R"),
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("beta"),
            ]),
            "mathrm",
          )
        ])
        formula.to_asciimath
        expect(formula).to eq(expected_value)
      end
    end
  end
end
