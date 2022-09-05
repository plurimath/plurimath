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
            Plurimath::Math::Symbol.new("&#x3B2;")
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
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x3B2;"),
              Plurimath::Math::Symbol.new("&#x2215;"),
              Plurimath::Math::Function::Text.new("t"),
            ]),
            Plurimath::Math::Function::Right.new(")"),
          ]),
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
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::Left.new("("),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Text.new("t"),
                    Plurimath::Math::Number.new("3"),
                  ]),
                  Plurimath::Math::Function::Right.new(")"),
                ]),
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
            Plurimath::Math::Formula.new
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains limits with int" do
      let(:string) {
        <<~LATEX
          \\int\\limits_{0}^{\\pi}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Limits.new(
            Plurimath::Math::Function::Int.new(
              nil,
              nil
            ),
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Symbol.new("&#x3C0;"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains unary function without any args" do
      let(:string) {
        <<~LATEX
          \\cos
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Cos.new,
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
            Plurimath::Math::Symbol.new("&#x221E;"),
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
            Plurimath::Math::Symbol.new("&#x221E;"),
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
          {1 \\over 2}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2"),
            ]),
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
          Plurimath::Math::Function::Table::Array.new(
            [
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
            ],
            nil,
            [
              Plurimath::Math::Function::Text.new("l"),
            ]
          )
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
          Plurimath::Math::Function::Table::Array.new(
            [
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
                ])
              ])
            ],
            nil,
            [
              Plurimath::Math::Symbol.new("|"),
            ]
          )
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
          Plurimath::Math::Function::Table::Matrix.new(
            [
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
          ],
            "(",
            ")",
          )
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
          Plurimath::Math::Function::Table::Vmatrix.new(
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
          Plurimath::Math::Function::Table::Bmatrix.new(
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
            "[",
            "]",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains bmatrix with negative value" do
      let(:string) {
        <<~LATEX
          \\begin{Bmatrix}-a & b \\\\ c & d \\end{Bmatrix}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Bmatrix.new(
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
            "[",
            "]",
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
          Plurimath::Math::Function::Table::Pmatrix.new(
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
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("2"),
                  Plurimath::Math::Symbol.new("&#x23AF;"),
                ]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("3"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("4"),
                ]),
              ]),
            ],
            nil,
            [
              Plurimath::Math::Function::Text.new("c"),
              Plurimath::Math::Symbol.new("|"),
              Plurimath::Math::Function::Text.new("r"),
            ]
          )
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
          Plurimath::Math::Function::Table::Vmatrix.new(
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
                  Plurimath::Math::Symbol.new("&#xB1;"),
                  Plurimath::Math::Number.new("25"),
                ])
              ])
            ],
            "|",
            "|",
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
            Plurimath::Math::Symbol.new("&#x3B2;"),
            Plurimath::Math::Symbol.new("&#xB1;"),
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
              Plurimath::Math::Symbol.new("&#x2192;"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Symbol.new("&#x221E;"),
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
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
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
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ]
            ),
            Plurimath::Math::Function::Right.new(")"),
          ])
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
          Plurimath::Math::Function::Text.new("\\mbox{a+b}")
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

    context "contains mathrm" do
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
              Plurimath::Math::Symbol.new("&#x3B2;"),
            ]),
            "mathrm",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains left right with base value" do
      let(:string) {
        <<~LATEX
          \\left( \\frac{T}{T_{\\textrm{ref}}} \\right)_{3/2}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Left.new("("),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Function::Text.new("T"),
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("T"),
                  Plurimath::Math::Function::FontStyle.new(
                    Plurimath::Math::Function::Text.new("ref"),
                    "textrm"
                  ),
                ),
              ),
              Plurimath::Math::Function::Right.new(")"),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("/"),
              Plurimath::Math::Number.new("2"),
            ]),
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains over with base value" do
      let(:string) {
        <<~LATEX
          {2 \\over \\beta}_{3/2}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Over.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Number.new("2"),
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("&#x3B2;"),
              ]),
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("/"),
              Plurimath::Math::Number.new("2"),
            ]),
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains over with power value" do
      let(:string) {
        <<~LATEX
          {2 \\over \\beta}^{3/2}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Over.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Number.new("2"),
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("&#x3B2;"),
              ]),
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("/"),
              Plurimath::Math::Number.new("2"),
            ]),
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #1" do
      let(:string) {
        <<~LATEX
          \\vec{F} = F_x \\hat{e}_x + F_y \\hat{e}_y + F_z \\hat{e}_z = \\int \\vec{f} \\ ,dA,
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("F")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("F"),
            Plurimath::Math::Function::Text.new("x"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Function::Text.new("x"),
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("F"),
            Plurimath::Math::Function::Text.new("y"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Function::Text.new("y"),
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("F"),
            Plurimath::Math::Function::Text.new("z"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Function::Text.new("z"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x222B;"),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("f")
          ),
          Plurimath::Math::Symbol.new("&#x2C;"),
          Plurimath::Math::Function::Text.new("dA"),
          Plurimath::Math::Symbol.new(","),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #2" do
      let(:string) {
        <<~LATEX
          \\vec{M} = M_x \\hat{e}_x + M_y \\hat{e}_y + M_z \\hat{e}_z = \\int (\\vec{r} - \\vec{r}_0) \\times \\vec{f} \\,dA.
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("M")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("M"),
            Plurimath::Math::Function::Text.new("x"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Function::Text.new("x"),
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("M"),
            Plurimath::Math::Function::Text.new("y"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Function::Text.new("y"),
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("M"),
            Plurimath::Math::Function::Text.new("z"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Function::Text.new("z"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x222B;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Vec.new(
              Plurimath::Math::Function::Text.new("r"),
            ),
            Plurimath::Math::Symbol.new("-"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Vec.new(
                Plurimath::Math::Function::Text.new("r"),
              ),
              Plurimath::Math::Number.new("0"),
            )
          ]),
          Plurimath::Math::Symbol.new("&#xD7;"),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("f"),
          ),
          Plurimath::Math::Symbol.new("&#x2C;"),
          Plurimath::Math::Function::Text.new("dA"),
          Plurimath::Math::Symbol.new("."),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #3" do
      let(:string) {
        <<~LATEX
          L = \\vec{F} \\cdot \\hat{L}  \\qquad  D = \\vec{F} \\cdot \\hat{D}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("L"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("F")
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Function::Text.new("L"),
          ),
          Plurimath::Math::Symbol.new("&#xA0;&#xA0;&#xA0;&#xA0;"),
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("F"),
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Function::Text.new("D"),
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #4" do
      let(:string) {
        <<~LATEX
          L = \\vec{F} \\cdot \\hat{e}_{\\eta} \\qquad D = \\vec{F} \\cdot \\hat{e}_{\\xi}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("L"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("F")
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Symbol.new("&#x3B7;"),
          ),
          Plurimath::Math::Symbol.new("&#xA0;&#xA0;&#xA0;&#xA0;"),
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("F"),
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Symbol.new("&#x3BE;")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #5" do
      let(:string) {
        <<~LATEX
          \\vec{M} = M_\\xi \\hat{e}_{\\xi} + M_\\eta \\hat{e}_{\\eta} + M_\\zeta \\hat{e}_{\\zeta} =
            \\int (\\vec{r} - \\vec{r}_0) \\times \\vec{f} \\,dA.
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("M"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("M"),
            Plurimath::Math::Symbol.new("&#x3BE;"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Symbol.new("&#x3BE;")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("M"),
            Plurimath::Math::Symbol.new("&#x3B7;"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Symbol.new("&#x3B7;"),
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("M"),
            Plurimath::Math::Symbol.new("&#x3B6;"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Symbol.new("&#x3B6;"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x222B;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Vec.new(
              Plurimath::Math::Function::Text.new("r")
            ),
            Plurimath::Math::Symbol.new("-"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Vec.new(
                Plurimath::Math::Function::Text.new("r"),
              ),
              Plurimath::Math::Number.new("0"),
            ),
          ]),
          Plurimath::Math::Symbol.new("&#xD7;"),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("f")
          ),
          Plurimath::Math::Symbol.new("&#x2C;"),
          Plurimath::Math::Function::Text.new("dA"),
          Plurimath::Math::Symbol.new(".")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #6" do
      let(:string) {
        <<~LATEX
          \\begin{split}
            C_L &= {L \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 S} \\\\ \\\\
            C_D &= {D \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 S} \\\\ \\\\
            \\vec{C}_M &= {\\beta \\vec{M} \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 c_\\textrm{ref} S_\\textrm{ref}},
          \\end{split}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Split.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("C"),
                    Plurimath::Math::Function::Text.new("L")
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Over.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Text.new("L")
                    ]),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Over.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Number.new("1")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Number.new("2")
                        ])
                      ),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Symbol.new("&#x3C1;"),
                        Plurimath::Math::Function::FontStyle.new(
                          Plurimath::Math::Function::Text.new("ref"),
                          "textrm"
                        )
                      ),
                      Plurimath::Math::Function::PowerBase.new(
                        Plurimath::Math::Function::Text.new("q"),
                        Plurimath::Math::Function::FontStyle.new(
                          Plurimath::Math::Function::Text.new("ref"),
                          "textrm"
                        ),
                        Plurimath::Math::Number.new("2"),
                      ),
                      Plurimath::Math::Function::Text.new("S")
                    ])
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("C"),
                    Plurimath::Math::Function::Text.new("D")
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Over.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Text.new("D")
                    ]),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Over.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Number.new("1")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Number.new("2")
                        ])
                      ),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Symbol.new("&#x3C1;"),
                        Plurimath::Math::Function::FontStyle.new(
                          Plurimath::Math::Function::Text.new("ref"),
                          "textrm"
                        )
                      ),
                      Plurimath::Math::Function::PowerBase.new(
                        Plurimath::Math::Function::Text.new("q"),
                        Plurimath::Math::Function::FontStyle.new(
                          Plurimath::Math::Function::Text.new("ref"),
                          "textrm"
                        ),
                        Plurimath::Math::Number.new("2"),
                      ),
                      Plurimath::Math::Function::Text.new("S")
                    ])
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Vec.new(
                      Plurimath::Math::Function::Text.new("C")
                    ),
                    Plurimath::Math::Function::Text.new("M")
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Over.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("&#x3B2;"),
                      Plurimath::Math::Function::Vec.new(
                        Plurimath::Math::Function::Text.new("M")
                      )
                    ]),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Over.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Number.new("1")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Number.new("2")
                        ])
                      ),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Symbol.new("&#x3C1;"),
                        Plurimath::Math::Function::FontStyle.new(
                          Plurimath::Math::Function::Text.new("ref"),
                          "textrm"
                        )
                      ),
                      Plurimath::Math::Function::PowerBase.new(
                        Plurimath::Math::Function::Text.new("q"),
                        Plurimath::Math::Function::FontStyle.new(
                          Plurimath::Math::Function::Text.new("ref"),
                          "textrm"
                        ),
                        Plurimath::Math::Number.new("2"),
                      ),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Function::Text.new("c"),
                        Plurimath::Math::Function::FontStyle.new(
                          Plurimath::Math::Function::Text.new("ref"),
                          "textrm"
                        )
                      ),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Function::Text.new("S"),
                        Plurimath::Math::Function::FontStyle.new(
                          Plurimath::Math::Function::Text.new("ref"),
                          "textrm"
                        )
                      )
                    ])
                  ),
                  Plurimath::Math::Symbol.new(",")
                ])
              ])
            ],
            "[",
            "]",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #7" do
      let(:string) {
        <<~LATEX
          c_l = {L' \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 c_\\textrm{ref}} \\qquad
          c_d = {D' \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 c_\\textrm{ref}} \\qquad
          \\vec{c}_m = {\\vec{M}' \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 c_\\textrm{ref}^2},
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Function::Text.new("l"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("L"),
              Plurimath::Math::Symbol.new("'"),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Over.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("2")
                ]),
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("&#x3C1;"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                )
              ),
              Plurimath::Math::Function::PowerBase.new(
                Plurimath::Math::Function::Text.new("q"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                ),
                Plurimath::Math::Number.new("2"),
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("c"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                )
              ),
            ])
          ),
          Plurimath::Math::Symbol.new("&#xA0;&#xA0;&#xA0;&#xA0;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Function::Text.new("d"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("D"),
              Plurimath::Math::Symbol.new("'")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Over.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("2")
                ]),
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("&#x3C1;"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                )
              ),
              Plurimath::Math::Function::PowerBase.new(
                Plurimath::Math::Function::Text.new("q"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                ),
                Plurimath::Math::Number.new("2"),
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("c"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                )
              ),
            ])
          ),
          Plurimath::Math::Symbol.new("&#xA0;&#xA0;&#xA0;&#xA0;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Vec.new(
              Plurimath::Math::Function::Text.new("c")
            ),
            Plurimath::Math::Function::Text.new("m")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Vec.new(
                Plurimath::Math::Function::Text.new("M")
              ),
              Plurimath::Math::Symbol.new("'")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Over.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("2")
                ]),
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("&#x3C1;"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                ),
              ),
              Plurimath::Math::Function::PowerBase.new(
                Plurimath::Math::Function::Text.new("q"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                ),
                Plurimath::Math::Number.new("2")
              ),
              Plurimath::Math::Function::PowerBase.new(
                Plurimath::Math::Function::Text.new("c"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                ),
                Plurimath::Math::Number.new("2")
              ),
            ]),
          ),
          Plurimath::Math::Symbol.new(",")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #8" do
      let(:string) {
        <<~LATEX
          k = k_{\\textrm{ref}} \\left( \\frac{T}{T_{\\textrm{ref}}} \\right)^{3/2} \\frac{T_{\\textrm{ref}} + T_{s}}{T + T_{s}},
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("k"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("k"),
            Plurimath::Math::Function::FontStyle.new(
              Plurimath::Math::Function::Text.new("ref"),
              "textrm"
            ),
          ),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Left.new("("),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Function::Text.new("T"),
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("T"),
                  Plurimath::Math::Function::FontStyle.new(
                    Plurimath::Math::Function::Text.new("ref"),
                    "textrm"
                  ),
                ),
              ),
              Plurimath::Math::Function::Right.new(")"),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("/"),
              Plurimath::Math::Number.new("2"),
            ]),
          ),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("T"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                ),
              ),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("T"),
                Plurimath::Math::Function::Text.new("s"),
              ),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("T"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("T"),
                Plurimath::Math::Function::Text.new("s"),
              )
            ]),
          ),
          Plurimath::Math::Symbol.new(","),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #9" do
      let(:string) {
        <<~LATEX
          -\\overline{u'_i u'_j} = \\nu_{t} \\left(
                      \\frac{\\partial u_i }{\\partial x_j } +
                      \\frac{\\partial u_j }{\\partial x_i }
                    \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("u"),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("'"),
                Plurimath::Math::Function::Text.new("iu"),
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("'"),
                Plurimath::Math::Function::Text.new("j"),
              ),
            ])
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3BD;"),
            Plurimath::Math::Function::Text.new("t"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("u"),
                    Plurimath::Math::Function::Text.new("i"),
                  ),
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("x"),
                    Plurimath::Math::Function::Text.new("j"),
                  ),
                ]),
              ),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("u"),
                    Plurimath::Math::Function::Text.new("j"),
                  ),
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("x"),
                    Plurimath::Math::Function::Text.new("i"),
                  ),
                ]),
              ),
            ]),
            Plurimath::Math::Function::Right.new(")"),
          ]),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #10" do
      let(:string) {
        <<~LATEX
          \\mu = \\mu_{\\textrm{ref}} \\left( \\frac{T}{T_{\\textrm{ref}}} \\right)^{n}.
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3BC;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3BC;"),
            Plurimath::Math::Function::FontStyle.new(
              Plurimath::Math::Function::Text.new("ref"),
              "textrm",
            ),
          ),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Left.new("("),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Function::Text.new("T"),
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("T"),
                  Plurimath::Math::Function::FontStyle.new(
                    Plurimath::Math::Function::Text.new("ref"),
                    "textrm",
                  ),
                ),
              ),
              Plurimath::Math::Function::Right.new(")"),
            ]),
            Plurimath::Math::Function::Text.new("n"),
          ),
          Plurimath::Math::Symbol.new("."),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #11" do
      let(:string) {
        <<~LATEX
          \\mu = \\mu_{\\textrm{ref}} \\left( \\frac{T}{T_{\\textrm{ref}}} \\right)^{3/2}
          \\frac{T_{\\textrm{ref}} + T_{s}}{T + T_{s}},
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3BC;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3BC;"),
            Plurimath::Math::Function::FontStyle.new(
              Plurimath::Math::Function::Text.new("ref"),
              "textrm",
            ),
          ),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Left.new("("),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Function::Text.new("T"),
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("T"),
                  Plurimath::Math::Function::FontStyle.new(
                    Plurimath::Math::Function::Text.new("ref"),
                    "textrm",
                  ),
                ),
              ),
              Plurimath::Math::Function::Right.new(")"),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("/"),
              Plurimath::Math::Number.new("2"),
            ]),
          ),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("T"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm",
                ),
              ),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("T"),
                Plurimath::Math::Function::Text.new("s"),
              ),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("T"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("T"),
                Plurimath::Math::Function::Text.new("s"),
              ),
            ]),
          ),
          Plurimath::Math::Symbol.new(","),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #12" do
      let(:string) {
        <<~LATEX
          $$f_i = \\sum_{j=1}^2 s_{ij} n_j \\; {\\rm for} \\; i = 1,2$$
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("$"),
          Plurimath::Math::Symbol.new("$"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("f"),
            Plurimath::Math::Function::Text.new("i"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("j"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Number.new("2"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("ij"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("n"),
            Plurimath::Math::Function::Text.new("j"),
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm",
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Symbol.new("$"),
          Plurimath::Math::Symbol.new("$"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #13" do
      let(:string) {
        <<~LATEX
          f_i = \\sum_{j=1}^3 s_{ij} n_j \\; {\\rm for} \\; i = 1,3
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("f"),
            Plurimath::Math::Function::Text.new("i"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("j"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Number.new("3"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("ij"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("n"),
            Plurimath::Math::Function::Text.new("j"),
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm",
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("3"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #14" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{ccc}
              s & 0 & 0 \\\\
              0 & s & 0 \\\\
              0 & 0 & s
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("s"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("0"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("0"),
                ]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("0"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("s"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("0"),
                ]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("0"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("0"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("s"),
                ]),
              ]),
            ],
              nil,
              [
                Plurimath::Math::Function::Text.new("ccc")
              ]
            ),
            Plurimath::Math::Function::Right.new(")"),
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #15" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{ccc}
              s_{11} & 0 & 0 \\\\
              0 & s_{22} & 0 \\\\
              0 & 0 & s_{33}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("s"),
                    Plurimath::Math::Number.new("11"),
                  ),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("0"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("0"),
                ]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("0"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("s"),
                    Plurimath::Math::Number.new("22"),
                  ),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("0"),
                ]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("0"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("0"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("s"),
                    Plurimath::Math::Number.new("33"),
                  ),
                ]),
              ]),
            ],
              nil,
              [
                Plurimath::Math::Function::Text.new("ccc")
              ]
            ),
            Plurimath::Math::Function::Right.new(")"),
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #16" do
      let(:string) {
        <<~LATEX
          s_{ij} = \\sum_{k=1}^2 \\sum_{l=1}^2 d_{ijkl} e_{kl} \\;
          {\\rm for} \\; i = 1,2 \\; {\\rm and} \\; j = 1,2
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("ij"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("k"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Number.new("2"),
          ),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("l"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Number.new("2"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("d"),
            Plurimath::Math::Function::Text.new("ijkl"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("e"),
            Plurimath::Math::Function::Text.new("kl"),
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm",
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("and"),
            "rm",
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::Text.new("j"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("2"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #17" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{c}
              s_{11} \\\\
              s_{22} \\\\
              s_{33} \\\\
              s_{12} \\\\
              s_{23} \\\\
              s_{31}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("11"),
                    ),
                  ]),
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("22"),
                    ),
                  ]),
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("33"),
                    ),
                  ]),
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("12"),
                    ),
                  ]),
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("23"),
                    ),
                  ]),
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("31"),
                    ),
                  ]),
                ]),
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ]
            ),
            Plurimath::Math::Function::Right.new(")"),
          ]),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #18" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{cccccc}
              d_{1111} &
              d_{1122} &
              d_{1133} &
              d_{1112} &
              d_{1123} &
              d_{1131} \\\\
              & d_{2222} &
              d_{2233} &
              d_{2212} &
              d_{2223} &
              d_{2231} \\\\
              & & d_{3333} &
              d_{3312} &
              d_{3323} &
              d_{3331} \\\\
              & & & d_{1212} &
              d_{1223} &
              d_{1231} \\\\
              & \\mbox{symmetric} & & &
              d_{2323} &
              d_{2331} \\\\
              & & & & & d_{3131}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1111")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1122")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1133")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1112")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1123")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1131")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2222")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2233")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2212")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2223")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2231")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("3333")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("3312")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("3323")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("3331")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1212")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1223")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1231")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("\\mbox{symmetric}")
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2323")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2331")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("3131")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cccccc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #19" do
      let(:string) {
        <<~LATEX
          \\Delta \\sigma_{ij} =  \\sum_{k=1}^3 \\sum_{l=1}^3 d_{ijkl} (\\Delta \\varepsilon_{kl} -
          \\alpha_{kl}\\Delta T - \\beta_{kl}\\Delta M)  \\;
          {\\rm for} \\; i = 1,3 \\; {\\rm and} \\; j = 1,3
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3C3;"),
            Plurimath::Math::Function::Text.new("ij"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("k"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Number.new("3")
          ),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("l"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Number.new("3")
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("d"),
            Plurimath::Math::Function::Text.new("ijkl"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("&#x394;"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Symbol.new("&#x03B5;"),
              Plurimath::Math::Function::Text.new("kl")
            ),
            Plurimath::Math::Symbol.new("-"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Symbol.new("&#x3B1;"),
              Plurimath::Math::Function::Text.new("kl")
            ),
            Plurimath::Math::Symbol.new("&#x394;"),
            Plurimath::Math::Function::Text.new("T"),
            Plurimath::Math::Symbol.new("-"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Symbol.new("&#x3B2;"),
              Plurimath::Math::Function::Text.new("kl")
            ),
            Plurimath::Math::Symbol.new("&#x394;"),
            Plurimath::Math::Function::Text.new("M")
          ]),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("and"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::Text.new("j"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("3"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #20" do
      let(:string) {
        <<~LATEX
          G = {\\displaystyle \\frac{E}{2(1 + \\nu)}}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("G"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Function::Text.new("E"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1"),
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Symbol.new("&#x3BD;"),
                ]),
              ]),
            ),
            "displaystyle",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #21" do
      let(:string) {
        <<~LATEX
            \\left(
              \\begin{array}{cccccc}
                {\\displaystyle \\frac{1}{E_{11}}} &
                -{\\displaystyle \\frac{\\nu_{12}}{E_{22}}} &
                -{\\displaystyle \\frac{\\nu_{13}}{E_{33}}} &
                {\\displaystyle \\frac{\\nu_{1,12}}{G_{12}}} &
                0 &
                0 \\\\[3mm] &
                {\\displaystyle \\frac{1}{E_{22}}} &
                -{\\displaystyle \\frac{\\nu_{23}}{E_{22}}} &
                {\\displaystyle \\frac{\\nu_{2,12}}{G_{12}}} &
                0 &
                0 \\\\[3mm] & &
                {\\displaystyle \\frac{1}{E_{33}}} &
                {\\displaystyle \\frac{\\nu_{3,12}}{G_{12}}} &
                0 &
                0 \\\\[3mm] & & &
                {\\displaystyle \\frac{1}{G_{12}}} &
                0 &
                0 \\\\[3mm] &
                \\mbox{symmetric} & & &
                {\\displaystyle \\frac{1}{G_{23}}} &
                {\\displaystyle \\frac{\\nu_{23,31}}{G_{31}}} \\\\
                [3mm] & & & & &
                {\\displaystyle \\frac{1}{G_{31}}}
              \\end{array}
            \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Number.new("11")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Number.new("12")
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Number.new("22")
                        ),
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Number.new("13")
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Number.new("33")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Number.new("1"),
                            Plurimath::Math::Symbol.new(","),
                            Plurimath::Math::Number.new("12")
                          ])
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Number.new("12")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Number.new("22")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Number.new("23")
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Number.new("22")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Number.new("2"),
                            Plurimath::Math::Symbol.new(","),
                            Plurimath::Math::Number.new("12")
                          ])
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Number.new("12")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Number.new("33")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Number.new("3"),
                            Plurimath::Math::Symbol.new(","),
                            Plurimath::Math::Number.new("12")
                          ])
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Number.new("12")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Number.new("12")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("\\mbox{symmetric}")
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Number.new("23")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Number.new("23"),
                            Plurimath::Math::Symbol.new(","),
                            Plurimath::Math::Number.new("31")
                          ])
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Number.new("31")
                        )
                      ),
                      "displaystyle"
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Number.new("31")
                        )
                      ),
                      "displaystyle"
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cccccc")
              ]
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #22" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{cccccc}
              {\\displaystyle \\frac{1}{E_{11}}} &
              -{\\displaystyle \\frac{\\nu_{12}}{E_{22}}} &
              -{\\displaystyle \\frac{\\nu_{13}}{E_{33}}} &
              0 &
              0 &
              0 \\\\
              [3mm] &
              {\\displaystyle \\frac{1}{E_{22}}} &
              -{\\displaystyle \\frac{\\nu_{23}}{E_{33}}} &
              0 &
              0 &
              0 \\\\
              [3mm] & &
              {\\displaystyle \\frac{1}{E_{33}}} &
              0 &
              0 &
              0 \\\\
              [3mm] & & &
              {\\displaystyle \\frac{1}{G_{12}}} &
              0 &
              0 \\\\
              [3mm] &
              \\mbox{symmetric} & & &
              {\\displaystyle \\frac{1}{G_{23}}} &
              0 \\\\
              [3mm] & & & & &
              {\\displaystyle \\frac{1}{G_{31}}}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Number.new("11")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Number.new("12")
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Number.new("22")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Number.new("13")
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Number.new("33")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Number.new("22")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Number.new("23")
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Number.new("33")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Number.new("33")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Number.new("12")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("\\mbox{symmetric}")
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Number.new("23")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Number.new("31")
                        )
                      ),
                      "displaystyle"
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cccccc")
              ]
            ),
            Plurimath::Math::Function::Right.new(")"),
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #23" do
      let(:string) {
        <<~LATEX
          G_{tt} = {\\displaystyle \\frac{E_{tt}}{2(1 + \\nu_{tt})}}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("G"),
            Plurimath::Math::Function::Text.new("tt")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("E"),
                Plurimath::Math::Function::Text.new("tt")
              ),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1"),
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3BD;"),
                    Plurimath::Math::Function::Text.new("tt")
                  )
                ])
              ])
            ),
            "displaystyle"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #24" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{cccccc}
              {\\displaystyle \\frac{1}{E_{ll}}} &
              -{\\displaystyle \\frac{\\nu_{tl}}{E_{tt}}} &
              -{\\displaystyle \\frac{\\nu_{tl}}{E_{tt}}} &
              0 &
              0 &
              0 \\\\
              [3mm] &
              {\\displaystyle \\frac{1}{E_{tt}}} &
              -{\\displaystyle \\frac{\\nu_{tt}}{E_{tt}}} &
              0 &
              0 &
              0 \\\\
              [3mm] & &
              {\\displaystyle \\frac{1}{E_{tt}}} &
              0 &
              0 &
              0 \\\\
              [3mm] & & &
              {\\displaystyle \\frac{1}{G_{lt}}} &
              0 &
              0 \\\\
              [3mm] &
              \\mbox{symmetric} & & &
              {\\displaystyle \\frac{1}{G_{tt}}} &
              0 \\\\
              [3mm] & & & & &
              {\\displaystyle \\frac{1}{G_{lt}}}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Function::Text.new("ll")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Function::Text.new("tl")
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Function::Text.new("tt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Function::Text.new("tl")
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Function::Text.new("tt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Function::Text.new("tt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Function::Text.new("tt")
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Function::Text.new("tt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Function::Text.new("tt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Function::Text.new("lt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("\\mbox{symmetric}")
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Function::Text.new("tt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Function::Text.new("lt")
                        )
                      ),
                      "displaystyle"
                    )
                  ])
                ])
              ],
              nil,
              [
                  Plurimath::Math::Function::Text.new("cccccc")
                ]
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #25" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{cccccc}
              {\\displaystyle \\frac{1}{E_{ll}}} &
              -{\\displaystyle \\frac{\\nu_{tl}}{E_{tt}}} &
              -{\\displaystyle \\frac{\\nu_{tl}}{E_{tt}}} &
              0 &
              0 &
              0 \\\\
              [3mm] &
              {\\displaystyle \\frac{1}{E_{tt}}} &
              -{\\displaystyle \\frac{\\nu_{tt}}{E_{tt}}} &
              0 &
              0 &
              0 \\\\
              [3mm] & &
              {\\displaystyle \\frac{1}{E_{tt}}} &
              0 &
              0 &
              0 \\\\
              [3mm] & & &
              {\\displaystyle \\frac{1}{G_{lt}}} &
              0 &
              0 \\\\
              [3mm] &
              \\mbox{symmetric} & & &
              {\\displaystyle \\frac{1}{G_{tt}}} &
              0 \\\\
              [3mm] & & & & &
              {\\displaystyle \\frac{1}{G_{lt}}}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Function::Text.new("ll")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Function::Text.new("tl")
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Function::Text.new("tt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Function::Text.new("tl")
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Function::Text.new("tt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Function::Text.new("tt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("&#x3BD;"),
                          Plurimath::Math::Function::Text.new("tt")
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Function::Text.new("tt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("E"),
                          Plurimath::Math::Function::Text.new("tt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Function::Text.new("lt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("\\mbox{symmetric}")
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Function::Text.new("tt")
                        )
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Function::Text.new("G"),
                          Plurimath::Math::Function::Text.new("lt")
                        )
                      ),
                      "displaystyle"
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cccccc")
              ]
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #26" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{cccccc}
              {\\displaystyle \\frac{1}{E}} &
              -{\\displaystyle \\frac{\\nu}{E}} &
              -{\\displaystyle \\frac{\\nu}{E}} &
              0 &
              0 &
              0 \\\\
              [3mm] &
              {\\displaystyle \\frac{1}{E}} &
              -{\\displaystyle \\frac{\\nu}{E}} &
              0 &
              0 &
              0 \\\\[3mm] & &
              {\\displaystyle \\frac{1}{E}} &
              0 &
              0 &
              0 \\\\
              [3mm] & & &
              {\\displaystyle \\frac{1}{G}} &
              0 &
              0 \\\\
              [3mm] &
              \\mbox{symmetric} & & &
              {\\displaystyle \\frac{1}{G}} &
              0 \\\\
              [3mm] & & & & &
              {\\displaystyle \\frac{1}{G}}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Text.new("E")
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Symbol.new("&#x3BD;"),
                        Plurimath::Math::Function::Text.new("E")
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Symbol.new("&#x3BD;"),
                        Plurimath::Math::Function::Text.new("E")
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Text.new("E")
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Symbol.new("&#x3BD;"),
                        Plurimath::Math::Function::Text.new("E")
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Text.new("E")
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Text.new("G")
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("\\mbox{symmetric}")
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Text.new("G")
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Function::Text.new("G")
                      ),
                      "displaystyle"
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cccccc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #27" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{c}
              \\varepsilon_{11} \\\\
              \\varepsilon_{22} \\\\
              \\varepsilon_{33} \\\\
              2\\varepsilon_{12} \\\\
              2\\varepsilon_{23} \\\\
              2\\varepsilon_{31}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03B5;"),
                      Plurimath::Math::Number.new("11")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03B5;"),
                      Plurimath::Math::Number.new("22")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03B5;"),
                      Plurimath::Math::Number.new("33")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("2"),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03B5;"),
                      Plurimath::Math::Number.new("12")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("2"),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03B5;"),
                      Plurimath::Math::Number.new("23")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Symbol.new("&#x03B5;"),
                        Plurimath::Math::Number.new("31")
                      )
                    ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ],
            ),
            Plurimath::Math::Function::Right.new(")"),
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #28" do
      let(:string) {
        <<~LATEX
          S_i =  \\sum_{j=1}^{6} D_{ij} (E_{j} - E_{j}^{T} - E_{j}^{M})  \\;
          {\\rm for} \\; i = 1,6
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("S"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("j"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("6")
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("D"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Text.new("E"),
              Plurimath::Math::Function::Text.new("j")
            ),
            Plurimath::Math::Symbol.new("-"),
            Plurimath::Math::Function::PowerBase.new(
              Plurimath::Math::Function::Text.new("E"),
              Plurimath::Math::Function::Text.new("j"),
              Plurimath::Math::Function::Text.new("T"),
            ),
            Plurimath::Math::Symbol.new("-"),
            Plurimath::Math::Function::PowerBase.new(
              Plurimath::Math::Function::Text.new("E"),
              Plurimath::Math::Function::Text.new("j"),
              Plurimath::Math::Function::Text.new("M"),
            )
          ]),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("6")
        ])
        expect(formula).to eq(expected_value)
      end
    end
# set counting numbers

    context "contains latex equation #29" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{cccccc}
              d_{1111} &
              d_{1122} &
              d_{1133} &
              d_{1112} &
              d_{1123} &
              d_{1131} \\\\
              & d_{2222} &
              d_{2233} &
              d_{2212} &
              d_{2223} &
              d_{2231} \\\\
              & & d_{3333} &
              d_{3312} &
              d_{3323} &
              d_{3331} \\\\
              & & & d_{1212} &
              d_{1223} &
              d_{1231} \\\\
              & \\mbox{symmetric} &
              & & d_{2323} &
              d_{2331} \\\\
              & & & & & d_{3131}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1111")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1122")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1133")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1112")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1123")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1131")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2222")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2233")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2212")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2223")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2231")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("3333")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("3312")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("3323")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("3331")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1212")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1223")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("1231")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("\\mbox{symmetric}")
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2323")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("2331")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("d"),
                      Plurimath::Math::Number.new("3131")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cccccc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #30" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{c}
              s_{11} \\\\
              s_{22} \\\\
              s_{33} \\\\
              s_{12} \\\\
              s_{23} \\\\
              s_{31}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("11")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("22")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("33")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("12")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("23")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("31")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #31" do
      let(:string) {
        <<~LATEX
          s_{ij} =  \\sum_{k=1}^3 \\sum_{l=1}^3 d_{ijkl} e_{kl} \\;
          {\\rm for} \\; i = 1,3 \\; {\\rm and} \\; j = 1,3
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("k"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("3")
          ),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("l"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("3")
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("d"),
            Plurimath::Math::Function::Text.new("ijkl")
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("e"),
            Plurimath::Math::Function::Text.new("kl")
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("and"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::Text.new("j"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("3")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #32" do
      let(:string) {
        <<~LATEX
          s_{ij} =  \\sum_{k=1}^2 \\sum_{l=1}^2 d_{ijkl} e_{kl} \\;
          {\\rm for} \\; i = 1,2 \\; {\\rm and} \\; j = 1,2
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("k"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("l"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("d"),
            Plurimath::Math::Function::Text.new("ijkl")
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("e"),
            Plurimath::Math::Function::Text.new("kl")
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("and"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::Text.new("j"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("2")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #33" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{ccc}
              s_{11} &
              0 &
              0 \\\\
              0 &
              s_{22} &
              0 \\\\
              0 &
              0 &
              s_{33}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("11")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("22")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("s"),
                      Plurimath::Math::Number.new("33")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("ccc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #34" do
      let(:string) {
        <<~LATEX
          -\\rho \\overline{w' w'}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Symbol.new("&#x3C1;"),
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("w"),
              Plurimath::Math::Symbol.new("'"),
              Plurimath::Math::Function::Text.new("w"),
              Plurimath::Math::Symbol.new("'")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #35" do
      let(:string) {
        <<~LATEX
          {1\\over2} \\rho q^2
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2")
            ])
          ),
          Plurimath::Math::Symbol.new("&#x3C1;"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("q"),
            Plurimath::Math::Number.new("2")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #36" do
      let(:string) {
        <<~LATEX
          \\begin{array}{ccc}
            \\tilde{x} = x/L, &  \\tilde{u} = u/c_\\infty, & \\tilde{\\rho} = \\rho/\\rho_\\infty, \\\\
            \\tilde{y} = y/L, & \\tilde{v} = v/c_\\infty, &  \\tilde{p} = p/(\\rho_\\infty c_\\infty^2), \\\\
            \\tilde{z} = z/L, \\quad & \\tilde{w} = w/c_\\infty, \\quad & \\tilde{\\mu} = \\mu/\\mu_\\infty,
          \\end{array}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Tilde.new(
                    Plurimath::Math::Function::Text.new("x"),
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Text.new("x"),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Text.new("L"),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Tilde.new(
                    Plurimath::Math::Function::Text.new("u"),
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Text.new("u"),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("c"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Tilde.new(
                    Plurimath::Math::Symbol.new("&#x3C1;"),
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Symbol.new("&#x3C1;"),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3C1;"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Tilde.new(
                    Plurimath::Math::Function::Text.new("y"),
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Text.new("y"),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Text.new("L"),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Tilde.new(
                    Plurimath::Math::Function::Text.new("v"),
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Text.new("v"),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("c"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Tilde.new(
                    Plurimath::Math::Function::Text.new("p"),
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Text.new("p"),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3C1;"),
                      Plurimath::Math::Symbol.new("&#x221E;")
                    ),
                    Plurimath::Math::Function::PowerBase.new(
                      Plurimath::Math::Function::Text.new("c"),
                      Plurimath::Math::Symbol.new("&#x221E;"),
                      Plurimath::Math::Number.new("2"),
                    )
                  ]),
                  Plurimath::Math::Symbol.new(",")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Tilde.new(
                    Plurimath::Math::Function::Text.new("z"),
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Text.new("z"),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Text.new("L"),
                  Plurimath::Math::Symbol.new(","),
                  Plurimath::Math::Symbol.new("&#x2001;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Tilde.new(
                    Plurimath::Math::Function::Text.new("w"),
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Text.new("w"),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("c"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new(","),
                  Plurimath::Math::Symbol.new("&#x2001;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Tilde.new(
                    Plurimath::Math::Symbol.new("&#x3BC;"),
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Symbol.new("&#x3BC;"),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3BC;"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ])
              ])
            ],
            nil,
            [
              Plurimath::Math::Function::Text.new("ccc")
            ],
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #37" do
      let(:string) {
        <<~LATEX
          x' = x/L, & u' = u/(L/T), & \\rho' = \\rho/(M/L^3), \\\\
          y' = y/L, & v' = v/(L/T), & p' = p/(M/(L T^2)), \\\\
          z' = z/L, \\quad & w' = w/(L/T), \\quad & \\mu' = \\mu/(M/(L T)),
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Function::Text.new("L"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Symbol.new("&"),
          Plurimath::Math::Function::Text.new("u"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("u"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("L"),
            Plurimath::Math::Symbol.new("/"),
            Plurimath::Math::Function::Text.new("T")
          ]),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Symbol.new("&"),
          Plurimath::Math::Symbol.new("&#x3C1;"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x3C1;"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("M"),
            Plurimath::Math::Symbol.new("/"),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("L"),
              Plurimath::Math::Number.new("3")
            )
          ]),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Symbol.new("\\\\"),
          Plurimath::Math::Function::Text.new("y"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("y"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Function::Text.new("L"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Symbol.new("&"),
          Plurimath::Math::Function::Text.new("v"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("v"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("L"),
            Plurimath::Math::Symbol.new("/"),
            Plurimath::Math::Function::Text.new("T")
          ]),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Symbol.new("&"),
          Plurimath::Math::Function::Text.new("p"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("p"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("M"),
            Plurimath::Math::Symbol.new("/"),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("LT"),
              Plurimath::Math::Number.new("2")
            )
          ]),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Symbol.new("\\\\"),
          Plurimath::Math::Function::Text.new("z"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("z"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Function::Text.new("L"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Symbol.new("&#x2001;"),
          Plurimath::Math::Symbol.new("&"),
          Plurimath::Math::Function::Text.new("w"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("w"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("L"),
            Plurimath::Math::Symbol.new("/"),
            Plurimath::Math::Function::Text.new("T")
          ]),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Symbol.new("&#x2001;"),
          Plurimath::Math::Symbol.new("&"),
          Plurimath::Math::Symbol.new("&#x3BC;"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x3BC;"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("M"),
            Plurimath::Math::Symbol.new("/"),
            Plurimath::Math::Function::Text.new("LT")
          ]),
          Plurimath::Math::Symbol.new(",")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #38" do
      let(:string) {
        <<~LATEX
          \\begin{array}{ccc}
            x'_\\textrm{ref} = x_\\textrm{ref}/L, & u'_\\textrm{ref} = u_\\textrm{ref}/(L/T), & \\rho'_\\textrm{ref} = \\rho_\\textrm{ref}/(M/L^3), \\\\
            y'_\\textrm{ref} = y_\\textrm{ref}/L, &  v'_\\textrm{ref} = v_\\textrm{ref}/(L/T), & p'_\\textrm{ref} = p_\\textrm{ref}/(M/(L T^2)) \\\\
            z'_\\textrm{ref} = z_\\textrm{ref}/L, \\quad & w'_\\textrm{ref} = w_\\textrm{ref}/(L/T), \\quad & \\mu'_\\textrm{ref} = \\mu_\\textrm{ref}/(M/(L T)).
          \\end{array}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("x"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("'"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("x"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Text.new("L"),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("u"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("'"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("u"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Text.new("L"),
                    Plurimath::Math::Symbol.new("/"),
                    Plurimath::Math::Function::Text.new("T")
                  ]),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("&#x3C1;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("'"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3C1;"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Text.new("M"),
                    Plurimath::Math::Symbol.new("/"),
                    Plurimath::Math::Function::Power.new(
                      Plurimath::Math::Function::Text.new("L"),
                      Plurimath::Math::Number.new("3")
                    )
                  ]),
                  Plurimath::Math::Symbol.new(",")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("y"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("'"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("y"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Text.new("L"),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("v"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("'"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("v"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Text.new("L"),
                    Plurimath::Math::Symbol.new("/"),
                    Plurimath::Math::Function::Text.new("T")
                  ]),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("p"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("'"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("p"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Text.new("M"),
                    Plurimath::Math::Symbol.new("/"),
                    Plurimath::Math::Function::Power.new(
                      Plurimath::Math::Function::Text.new("LT"),
                      Plurimath::Math::Number.new("2")
                    )
                  ])
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("z"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("'"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("z"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Text.new("L"),
                  Plurimath::Math::Symbol.new(","),
                  Plurimath::Math::Symbol.new("&#x2001;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("w"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("'"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("w"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Text.new("L"),
                    Plurimath::Math::Symbol.new("/"),
                    Plurimath::Math::Function::Text.new("T")
                  ]),
                  Plurimath::Math::Symbol.new(","),
                  Plurimath::Math::Symbol.new("&#x2001;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("&#x3BC;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("'"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3BC;"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Text.new("M"),
                    Plurimath::Math::Symbol.new("/"),
                    Plurimath::Math::Function::Text.new("LT")
                  ]),
                  Plurimath::Math::Symbol.new(".")
                ])
              ])
            ],
            nil,
            [
              Plurimath::Math::Function::Text.new("ccc")
            ],
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #39" do
      let(:string) {
        <<~LATEX
          \\begin{split}
            p''_{ijk} &\\equiv p_{ijk} / (\\rho_\\textrm{ref} c_\\textrm{ref}^2)[.02in] \\\\ \\\\
            \\displaystyle &{}= {p_{ijk} \\over M/(L T^2)} {M/L^3 \\over \\rho_\\textrm{ref}} \\left[ L/T \\over c_\\textrm{ref} \\right]^2 \\\\ \\\\
            \\displaystyle &{}= p'_{ijk} / (\\rho'_\\textrm{ref} (c'_\\textrm{ref})^2)
          \\end{split}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Split.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("p"),
                  Plurimath::Math::Symbol.new("'"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("'"),
                    Plurimath::Math::Function::Text.new("ijk")
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("&#x2261;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("p"),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3C1;"),
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Function::Text.new("ref"),
                        "textrm"
                      )
                    ),
                    Plurimath::Math::Function::PowerBase.new(
                      Plurimath::Math::Function::Text.new("c"),
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Function::Text.new("ref"),
                        "textrm"
                      ),
                      Plurimath::Math::Number.new("2")
                    )
                  ]),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("."),
                    Plurimath::Math::Number.new("02"),
                    Plurimath::Math::Function::Text.new("in")
                  ])
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::FontStyle.new(
                    Plurimath::Math::Symbol.new("&"),
                    "displaystyle"
                  ),
                  Plurimath::Math::Formula.new,
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Over.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Function::Text.new("p"),
                        Plurimath::Math::Function::Text.new("ijk")
                      )
                    ]),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Text.new("M"),
                      Plurimath::Math::Symbol.new("/"),
                      Plurimath::Math::Function::Power.new(
                        Plurimath::Math::Function::Text.new("LT"),
                        Plurimath::Math::Number.new("2")
                      )
                    ])
                  ),
                  Plurimath::Math::Function::Over.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Text.new("M"),
                      Plurimath::Math::Symbol.new("/"),
                      Plurimath::Math::Function::Power.new(
                        Plurimath::Math::Function::Text.new("L"),
                        Plurimath::Math::Number.new("3")
                      )
                    ]),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Symbol.new("&#x3C1;"),
                        Plurimath::Math::Function::FontStyle.new(
                          Plurimath::Math::Function::Text.new("ref"),
                          "textrm"
                        )
                      )
                    ])
                  ),
                  Plurimath::Math::Function::Power.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Left.new("["),
                      Plurimath::Math::Function::Over.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Text.new("L"),
                          Plurimath::Math::Symbol.new("/"),
                          Plurimath::Math::Function::Text.new("T")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Base.new(
                            Plurimath::Math::Function::Text.new("c"),
                            Plurimath::Math::Function::FontStyle.new(
                              Plurimath::Math::Function::Text.new("ref"),
                              "textrm"
                            )
                          )
                        ])
                      ),
                      Plurimath::Math::Function::Right.new("]")
                    ]),
                    Plurimath::Math::Number.new("2")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::FontStyle.new(
                    Plurimath::Math::Symbol.new("&"),
                    "displaystyle"
                  ),
                  Plurimath::Math::Formula.new,
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Text.new("p"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("'"),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("&#x3C1;"),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("'"),
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Function::Text.new("ref"),
                        "textrm"
                      )
                    ),
                    Plurimath::Math::Function::Power.new(
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Function::Text.new("c"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("'"),
                          Plurimath::Math::Function::FontStyle.new(
                            Plurimath::Math::Function::Text.new("ref"),
                            "textrm"
                          )
                        )
                      ]),
                      Plurimath::Math::Number.new("2")
                    )
                  ])
                ])
              ])
            ],
            "[",
            "]",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #40" do
      let(:string) {
        <<~LATEX
          \\begin{array}{ccc}
            \\tilde{x}_{ijk} = x_{ijk}/L, & \\tilde{u}_{ijk} = u_{ijk}/c_\\infty, & \\tilde{\\rho}_{ijk} = \\rho_{ijk}/\\rho_\\infty, \\\\
            \\tilde{y}_{ijk} = y_{ijk}/L, & \\tilde{v}_{ijk} = v_{ijk}/c_\\infty, & \\tilde{p}_{ijk} = p_{ijk}/(\\rho_\\infty c_\\infty^2),[.02in] \\\\
            \\tilde{z}_{ijk} = z_{ijk}/L, & \\tilde{w}_{ijk} = w_{ijk}/c_\\infty, & \\tilde{\\tilde{\\mu}}_{ijk} = \\mu_{ijk} / (\\rho_\\infty c_\\infty L),
          \\end{array}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                          Plurimath::Math::Function::Text.new("x")
                        ),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("x"),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Text.new("L"),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Text.new("u")
                    ),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("u"),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("c"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Symbol.new("&#x3C1;")
                    ),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3C1;"),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3C1;"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Text.new("y")
                    ),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("y"),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Text.new("L"),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Text.new("v")
                    ),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("v"),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("c"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Text.new("p")
                    ),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("p"),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3C1;"),
                      Plurimath::Math::Symbol.new("&#x221E;")
                    ),
                    Plurimath::Math::Function::PowerBase.new(
                      Plurimath::Math::Function::Text.new("c"),
                      Plurimath::Math::Symbol.new("&#x221E;"),
                      Plurimath::Math::Number.new("2"),
                    )
                  ]),
                  Plurimath::Math::Symbol.new(","),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("."),
                    Plurimath::Math::Number.new("02"),
                    Plurimath::Math::Function::Text.new("in")
                  ])
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Text.new("z")
                    ),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("z"),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Text.new("L"),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Text.new("w")
                    ),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("w"),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("c"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Tilde.new(
                        Plurimath::Math::Symbol.new("&#x3BC;")
                      )
                    ),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3BC;"),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3C1;"),
                      Plurimath::Math::Symbol.new("&#x221E;")
                    ),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("c"),
                      Plurimath::Math::Symbol.new("&#x221E;")
                    ),
                    Plurimath::Math::Function::Text.new("L")
                  ]),
                  Plurimath::Math::Symbol.new(",")
                ])
              ])
            ],
            nil,
            [
              Plurimath::Math::Function::Text.new("ccc")
            ],
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #41" do
      let(:string) {
        <<~LATEX
          \\begin{array}{cc}
            \\tilde{u}_\\infty = u_\\infty/c_\\infty, \\quad & \\tilde{\\rho}_\\infty = \\rho_\\infty/\\rho_\\infty = 1, \\\\
            \\tilde{v}_\\infty = v_\\infty/c_\\infty, & \\tilde{p}_\\infty = p_\\infty/(\\rho_\\infty c_\\infty^2) = 1/\\gamma,[.02in] \\\\
            \\tilde{w}_\\infty = w_\\infty/c_\\infty, & \\tilde{\\tilde{\\mu}}_\\infty = \\mu_\\infty / (\\rho_\\infty c_\\infty L) \\sim O(1/Re),
          \\end{array}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Text.new("u")
                    ),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("u"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("c"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new(","),
                  Plurimath::Math::Symbol.new("&#x2001;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Symbol.new("&#x3C1;")
                    ),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3C1;"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3C1;"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Number.new("1"),
                  Plurimath::Math::Symbol.new(",")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Text.new("v")
                    ),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("v"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("c"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Text.new("p")
                    ),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("p"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3C1;"),
                      Plurimath::Math::Symbol.new("&#x221E;")
                    ),
                    Plurimath::Math::Function::PowerBase.new(
                      Plurimath::Math::Function::Text.new("c"),
                      Plurimath::Math::Symbol.new("&#x221E;"),
                      Plurimath::Math::Number.new("2"),
                    )
                  ]),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Number.new("1"),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Symbol.new("&#x3B3;"),
                  Plurimath::Math::Symbol.new(","),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("."),
                    Plurimath::Math::Number.new("02"),
                    Plurimath::Math::Function::Text.new("in")
                  ])
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Text.new("w")
                    ),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("w"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("c"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Tilde.new(
                        Plurimath::Math::Symbol.new("&#x3BC;")
                      )
                    ),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3BC;"),
                    Plurimath::Math::Symbol.new("&#x221E;")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3C1;"),
                      Plurimath::Math::Symbol.new("&#x221E;")
                    ),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("c"),
                      Plurimath::Math::Symbol.new("&#x221E;")
                    ),
                    Plurimath::Math::Function::Text.new("L")
                  ]),
                  Plurimath::Math::Symbol.new("&#x223C;"),
                  Plurimath::Math::Function::Text.new("O"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Number.new("1"),
                    Plurimath::Math::Symbol.new("/"),
                    Plurimath::Math::Function::Text.new("Re")
                  ]),
                  Plurimath::Math::Symbol.new(",")
                ])
              ])
            ],
            nil,
            [Plurimath::Math::Function::Text.new("cc")],
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #42" do
      let(:string) {
        <<~LATEX
          c_p = {p - p_\\textrm{ref} \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2},
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Function::Text.new("p")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("p"),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("p"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                )
              )
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Over.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("2")
                ])
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("&#x3C1;"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                )
              ),
              Plurimath::Math::Function::PowerBase.new(
                Plurimath::Math::Function::Text.new("q"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                ),
                Plurimath::Math::Number.new("2")
              )
            ])
          ),
          Plurimath::Math::Symbol.new(",")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #43" do
      let(:string) {
        <<~LATEX
           \\vec{c}_f = {\\vec{\\tau} \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2},
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Vec.new(
              Plurimath::Math::Function::Text.new("c")
            ),
            Plurimath::Math::Function::Text.new("f")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Vec.new(
                Plurimath::Math::Symbol.new("&#x3C4;")
              )
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Over.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("2")
                ])
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("&#x3C1;"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                )
              ),
              Plurimath::Math::Function::PowerBase.new(
                Plurimath::Math::Function::Text.new("q"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm"
                ),
                Plurimath::Math::Number.new("2")
              )
            ])
          ),
          Plurimath::Math::Symbol.new(",")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #44" do
      let(:string) {
        <<~LATEX
          {1\\over2}(u^2 + v^2 + w^2) = {1\\over2} q^2
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2")
            ])
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("u"),
              Plurimath::Math::Number.new("2")
            ),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("v"),
              Plurimath::Math::Number.new("2")
            ),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("w"),
              Plurimath::Math::Number.new("2")
            )
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2")
            ])
          ),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("q"),
            Plurimath::Math::Number.new("2")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end
    # structural_response_representation_schema_annotated => 54

    context "contains latex equation #45" do
      let(:string) {
        <<~LATEX
          T = G \\: J \\: \\frac{\\partial \\theta}{\\partial x}
          - E \\: \\frac{\\partial^2}{\\partial x^2} ( C_w \\:
          \\frac{\\partial \\theta}{\\partial x} )
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("T"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("G"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Text.new("J"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Symbol.new("&#x3B8;")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Function::Text.new("x")
            ])
          ),
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Function::Text.new("E"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Number.new("2")
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Function::Text.new("x"),
                Plurimath::Math::Number.new("2")
              )
            ])
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Text.new("C"),
              Plurimath::Math::Function::Text.new("w")
            ),
            Plurimath::Math::Symbol.new("&#x3A;"),
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("&#x2202;"),
                Plurimath::Math::Symbol.new("&#x3B8;")
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("&#x2202;"),
                Plurimath::Math::Function::Text.new("x")
              ])
            )
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #46" do
      let(:string) {
        <<~LATEX
          \\frac{\\Delta \\theta}{\\Delta L} = \\frac{T }{J \\: G}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x394;"),
              Plurimath::Math::Symbol.new("&#x3B8;")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x394;"),
              Plurimath::Math::Function::Text.new("L")
            ])
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Function::Text.new("T"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("J"),
              Plurimath::Math::Symbol.new("&#x3A;"),
              Plurimath::Math::Function::Text.new("G")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #47" do
      let(:string) {
        <<~LATEX
          V = \\frac{1}{2} \\: k \\: d^2
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("V"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Text.new("k"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("d"),
            Plurimath::Math::Number.new("2")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #48" do
      let(:string) {
        <<~LATEX
          D_s = G \\: \\left(
                        \\begin{array}{cc}
                          1 & 0 \\\\
                          0 & 1
                        \\end{array}
                      \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("D"),
            Plurimath::Math::Function::Text.new("s")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("G"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("1")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("1")
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #49" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{c}
              V_x  \\\\
              V_y
            \\end{array}
          \\right) = h_s \\: D_s \\: \\left(
                                        \\begin{array}{c}
                                          \\varepsilon_{xz} \\\\
                                          \\varepsilon_{yz}
                                        \\end{array}
                                      \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("V"),
                      Plurimath::Math::Function::Text.new("x")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("V"),
                      Plurimath::Math::Function::Text.new("y")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("h"),
            Plurimath::Math::Function::Text.new("s")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("D"),
            Plurimath::Math::Function::Text.new("s")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03B5;"),
                      Plurimath::Math::Function::Text.new("xz")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03B5;"),
                      Plurimath::Math::Function::Text.new("yz")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #50" do
      let(:string) {
        <<~LATEX
          D' = \\left(
                 \\begin{array} {cc}
                   h_m \\, D_{mm} &
                   h_b \\, p \\, D_{mc} \\\\
                   [2mm] h_b \\, p \\, D_{mc} &
                   {\\displaystyle (\\frac{1}{12} h_b^3 + h_b \\, p^2) \\, D_{mb} }
                 \\end{array}
               \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("h"),
                      Plurimath::Math::Function::Text.new("m")
                    ),
                    Plurimath::Math::Symbol.new("&#x2C;"),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("D"),
                      Plurimath::Math::Function::Text.new("mm")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("h"),
                      Plurimath::Math::Function::Text.new("b")
                    ),
                    Plurimath::Math::Symbol.new("&#x2C;"),
                    Plurimath::Math::Function::Text.new("p"),
                    Plurimath::Math::Symbol.new("&#x2C;"),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("D"),
                      Plurimath::Math::Function::Text.new("mc")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Function::Text.new("mm")
                    ]),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("h"),
                      Plurimath::Math::Function::Text.new("b")
                    ),
                    Plurimath::Math::Symbol.new("&#x2C;"),
                    Plurimath::Math::Function::Text.new("p"),
                    Plurimath::Math::Symbol.new("&#x2C;"),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("D"),
                      Plurimath::Math::Function::Text.new("mc")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Frac.new(
                            Plurimath::Math::Number.new("1"),
                            Plurimath::Math::Number.new("12")
                          ),
                          Plurimath::Math::Function::PowerBase.new(
                            Plurimath::Math::Function::Text.new("h"),
                            Plurimath::Math::Function::Text.new("b"),
                            Plurimath::Math::Number.new("3"),
                          ),
                          Plurimath::Math::Symbol.new("+"),
                          Plurimath::Math::Function::Base.new(
                            Plurimath::Math::Function::Text.new("h"),
                            Plurimath::Math::Function::Text.new("b")
                          ),
                          Plurimath::Math::Symbol.new("&#x2C;"),
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Function::Text.new("p"),
                            Plurimath::Math::Number.new("2")
                          )
                        ]),
                        "displaystyle"
                      ),
                      Plurimath::Math::Symbol.new("&#x2C;"),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Function::Text.new("D"),
                        Plurimath::Math::Function::Text.new("mb")
                      )
                    ])
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #51" do
      let(:string) {
        <<~LATEX
          D_m = \\frac{E}{(1 - \\nu^2)} \\:
          \\left(
            \\begin{array}{ccc}
              1 &
              \\nu &
              0 \\\\
              [2mm] \\nu &
              1 &
              0 \\\\
              [2mm] 0 &
              0 &
              {\\displaystyle \\frac{(1 - \\nu)}{2} }
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("D"),
            Plurimath::Math::Function::Text.new("m")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Function::Text.new("E"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbol.new("&#x3BD;"),
                Plurimath::Math::Number.new("2")
              )
            ])
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("1")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("&#x3BD;")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Function::Text.new("mm")
                    ]),
                    Plurimath::Math::Symbol.new("&#x3BD;")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("1")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Function::Text.new("mm")
                    ]),
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Number.new("1"),
                          Plurimath::Math::Symbol.new("-"),
                          Plurimath::Math::Symbol.new("&#x3BD;")
                        ]),
                        Plurimath::Math::Number.new("2")
                      ),
                      "displaystyle"
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("ccc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #52" do
      let(:string) {
        <<~LATEX
          D' =  \\left(
                  \\begin{array}{cc}
                    h \\, D_m &
                    h \\, p \\, D_m \\\\
                    [2mm] h \\, p \\, D_m &
                    {\\displaystyle (\\frac{1}{12} h^3 + h \\, p^2) \\, D_m }
                  \\end{array}
                \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("h"),
                    Plurimath::Math::Symbol.new("&#x2C;"),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("D"),
                      Plurimath::Math::Function::Text.new("m")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("h"),
                    Plurimath::Math::Symbol.new("&#x2C;"),
                    Plurimath::Math::Function::Text.new("p"),
                    Plurimath::Math::Symbol.new("&#x2C;"),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("D"),
                      Plurimath::Math::Function::Text.new("m")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Function::Text.new("mm")
                    ]),
                    Plurimath::Math::Function::Text.new("h"),
                    Plurimath::Math::Symbol.new("&#x2C;"),
                    Plurimath::Math::Function::Text.new("p"),
                    Plurimath::Math::Symbol.new("&#x2C;"),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("D"),
                      Plurimath::Math::Function::Text.new("m")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Frac.new(
                            Plurimath::Math::Number.new("1"),
                            Plurimath::Math::Number.new("12")
                          ),
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Function::Text.new("h"),
                            Plurimath::Math::Number.new("3")
                          ),
                          Plurimath::Math::Symbol.new("+"),
                          Plurimath::Math::Function::Text.new("h"),
                          Plurimath::Math::Symbol.new("&#x2C;"),
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Function::Text.new("p"),
                            Plurimath::Math::Number.new("2")
                          )
                        ]),
                        "displaystyle"
                      ),
                      Plurimath::Math::Symbol.new("&#x2C;"),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Function::Text.new("D"),
                        Plurimath::Math::Function::Text.new("m")
                      )
                    ])
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #53" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{c}
              \\varepsilon_{xx} \\\\
              \\varepsilon_{yy} \\\\
              \\gamma_{xy} \\\\
              \\chi_{xx} \\\\
              \\chi_{yy} \\\\
              \\tau_{xy}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03B5;"),
                      Plurimath::Math::Function::Text.new("xx")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03B5;"),
                      Plurimath::Math::Function::Text.new("yy")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3B3;"),
                      Plurimath::Math::Function::Text.new("xy")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3C7;"),
                      Plurimath::Math::Function::Text.new("xx")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3C7;"),
                      Plurimath::Math::Function::Text.new("yy")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3C4;"),
                      Plurimath::Math::Function::Text.new("xy")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #54" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{c}
              N_{yy}\\\\
              N_{xx}\\\\
              N_{xy}\\\\
              M_{xx}\\\\
              M_{yy}\\\\
              M_{xy}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("N"),
                      Plurimath::Math::Function::Text.new("yy")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("N"),
                      Plurimath::Math::Function::Text.new("xx")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("N"),
                      Plurimath::Math::Function::Text.new("xy")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("M"),
                      Plurimath::Math::Function::Text.new("xx")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("M"),
                      Plurimath::Math::Function::Text.new("yy")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("M"),
                      Plurimath::Math::Function::Text.new("xy")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #55" do
      let(:string) {
        <<~LATEX
          \\sigma' = D' \\: \\varepsilon'
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3C3;"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Symbol.new("&#x03B5;"),
          Plurimath::Math::Symbol.new("'")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #56" do
      let(:string) {
        <<~LATEX
          \\varepsilon' = B' \\: {\\bf u}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x03B5;"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("B"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("u"),
            "bf"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #57" do
      let(:string) {
        <<~LATEX
          V = \\frac{1}{2}
          \\: {\\bf u}^t \\:
          \\int_{surface} \\: {B'}^t \\: D' \\: B' \\: ds
          \\; {\\bf u}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("V"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::FontStyle.new(
                Plurimath::Math::Function::Text.new("u"),
                "bf"
              )
            ]),
            Plurimath::Math::Function::Text.new("t")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x222B;"),
            Plurimath::Math::Function::Text.new("surface")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("B"),
              Plurimath::Math::Symbol.new("'")
            ]),
            Plurimath::Math::Function::Text.new("t")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Text.new("B"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Text.new("ds"),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("u"),
            "bf"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #58" do
      let(:string) {
        <<~LATEX
          \\sigma = D \\: \\varepsilon
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3C3;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Symbol.new("&#x03B5;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #59" do
      let(:string) {
        <<~LATEX
          \\varepsilon = B \\: {\\bf u}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x03B5;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("B"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("u"),
            "bf"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #60" do
      let(:string) {
        <<~LATEX
          V = \\frac{1}{2} \\: {\\bf u}^t \\:
          \\int_{surface} \\: \\int_{thickness} \\: B^t \\: D \\: B \\: dt \\: ds
          \\; {\\bf u}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("V"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::FontStyle.new(
                Plurimath::Math::Function::Text.new("u"),
                "bf"
              )
            ]),
            Plurimath::Math::Function::Text.new("t")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x222B;"),
            Plurimath::Math::Function::Text.new("surface")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x222B;"),
            Plurimath::Math::Function::Text.new("thickness")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("B"),
            Plurimath::Math::Function::Text.new("t")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Text.new("B"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Text.new("dt"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Text.new("ds"),
          Plurimath::Math::Symbol.new("&#x3B;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("u"),
            "bf"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #61" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{c}
              {\\displaystyle \\frac{\\partial w}{\\partial x} + \\frac{\\partial u}
              {\\partial z}} \\\\
              [3mm] {\\displaystyle \\frac{\\partial w}{\\partial y} + \\frac{\\partial v}{\\partial z}}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Function::Frac.new(
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Function::Text.new("w")
                          ]),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Function::Text.new("x")
                          ])
                        ),
                        "displaystyle"
                      ),
                      Plurimath::Math::Symbol.new("+"),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("u")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("z")
                        ])
                      )
                    ])
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ]),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Function::Frac.new(
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Function::Text.new("w")
                          ]),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Function::Text.new("y")
                          ])
                        ),
                        "displaystyle"
                      ),
                      Plurimath::Math::Symbol.new("+"),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("v")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("z")
                        ])
                      )
                    ])
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #62" do
      let(:string) {
        <<~LATEX
          \\Delta F_{i} = \\sum_{j = 1}^2  s_{ij} \\: \\Delta\\varepsilon_{j}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("F"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("j"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03B5;"),
            Plurimath::Math::Function::Text.new("j")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #63" do
      let(:string) {
        <<~LATEX
          \\Delta N_{ij} =  \\sum_{k=1}^2 \\sum_{l=1}^2  d_{ijkl} \\: \\Delta c_{kl}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("N"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("k"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("l"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("d"),
            Plurimath::Math::Function::Text.new("ijkl")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Function::Text.new("kl")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #64" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{cc}
              {\\displaystyle - \\frac{\\partial^2 w}{\\partial x^2}}   &
              {\\displaystyle - \\frac{\\partial^2 w}{\\partial x \\partial y}}   \\\\[3mm]
              {\\displaystyle - \\frac{\\partial^2 w}{\\partial x \\partial y}}    &
              {\\displaystyle - \\frac{\\partial^2 w}{\\partial y^2}}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Symbol.new("-"),
                        "displaystyle"
                      ),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Number.new("2")
                          ),
                          Plurimath::Math::Function::Text.new("w")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Function::Text.new("x"),
                            Plurimath::Math::Number.new("2")
                          )
                        ])
                      )
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Symbol.new("-"),
                        "displaystyle"
                      ),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Number.new("2")
                          ),
                          Plurimath::Math::Function::Text.new("w")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("x"),
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("y")
                        ])
                      )
                    ])
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ]),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Symbol.new("-"),
                        "displaystyle"
                      ),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Number.new("2")
                          ),
                          Plurimath::Math::Function::Text.new("w")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("x"),
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("y")
                        ])
                      )
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Symbol.new("-"),
                        "displaystyle"
                      ),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Number.new("2")
                          ),
                          Plurimath::Math::Function::Text.new("w")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Function::Text.new("y"),
                            Plurimath::Math::Number.new("2")
                          )
                        ])
                      )
                    ])
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #65" do
      let(:string) {
        <<~LATEX
          \\Delta D_{ij} =  \\sum_{k=1}^2 \\sum_{l=1}^2  d_{ijkl} \\: \\Delta c_{kl}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("D"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("k"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("l"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("d"),
            Plurimath::Math::Function::Text.new("ijkl")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Function::Text.new("kl")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #66" do
      let(:string) {
        <<~LATEX
          J = \\left(
                \\begin{array}{cc}
                  {\\displaystyle \\frac{\\partial u}{\\partial x}} &
                  {\\displaystyle \\frac{\\partial v}{\\partial x}} \\\\
                  [3mm] {\\displaystyle \\frac{\\partial u}{\\partial y}} &
                  {\\displaystyle \\frac{\\partial v}{\\partial y}}
                \\end{array}
              \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("J"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("u")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("x")
                        ])
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("v")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("x")
                        ])
                      ),
                      "displaystyle"
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ]),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("u")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("y")
                        ])
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("v")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("y")
                        ])
                      ),
                      "displaystyle"
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #67" do
      let(:string) {
        <<~LATEX
          \\varepsilon = \\frac{1}{2} ( J + J^t )
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x03B5;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("J"),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("J"),
              Plurimath::Math::Function::Text.new("t")
            )
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #68" do
      let(:string) {
        <<~LATEX
          \\Delta N_{ij} =  \\sum_{k=1}^2 \\sum_{l=1}^2 d_{ijkl} \\: \\Delta\\varepsilon_{kl}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("N"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("k"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("l"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("d"),
            Plurimath::Math::Function::Text.new("ijkl")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03B5;"),
            Plurimath::Math::Function::Text.new("kl")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #69" do
      let(:string) {
        <<~LATEX
          \\Delta\\varepsilon_{ij} =  \\beta_{ij}(M) \\: \\Delta M
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03B5;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3B2;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Function::Text.new("M"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Text.new("M")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #70" do
      let(:string) {
        <<~LATEX
          \\varepsilon_{ij} =  \\alpha_{ij} \\: ( T \\:  -  \\: T_o )
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03B5;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3B1;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("T"),
            Plurimath::Math::Symbol.new("&#x3A;"),
            Plurimath::Math::Symbol.new("-"),
            Plurimath::Math::Symbol.new("&#x3A;"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Text.new("T"),
              Plurimath::Math::Function::Text.new("o")
            )
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #71" do
      let(:string) {
        <<~LATEX
          \\Delta\\varepsilon_{ij} =  \\alpha_{ij}(T) \\: \\Delta T
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03B5;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3B1;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Function::Text.new("T"),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Text.new("T")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #72" do
      let(:string) {
        <<~LATEX
          \\Delta\\sigma_{ij} = \\sum_{k=1}^3 \\sum_{l=1}^3  d_{ijkl} \\: \\Delta\\varepsilon_{kl}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3C3;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("k"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("3")
          ),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("l"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("3")
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("d"),
            Plurimath::Math::Function::Text.new("ijkl")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03B5;"),
            Plurimath::Math::Function::Text.new("kl")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #73" do
      let(:string) {
        <<~LATEX
          Q^s_i = \\sum_{j=1}^m \\:  s_{ji} \\: w^s_j \\: q_{ji}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("Q"),
            Plurimath::Math::Function::Text.new("i"),
            Plurimath::Math::Function::Text.new("s"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("j"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Function::Text.new("m")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("ji")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("w"),
            Plurimath::Math::Function::Text.new("j"),
            Plurimath::Math::Function::Text.new("s"),
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("q"),
            Plurimath::Math::Function::Text.new("ji")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #74" do
      let(:string) {
        <<~LATEX
          Q = \\sum_{i=1}^n \\:  j_i \\: w^f_i \\: Q^s_i
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("Q"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Function::Text.new("n")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("j"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("w"),
            Plurimath::Math::Function::Text.new("i"),
            Plurimath::Math::Function::Text.new("f"),
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("Q"),
            Plurimath::Math::Function::Text.new("i"),
            Plurimath::Math::Function::Text.new("s"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #75" do
      let(:string) {
        <<~LATEX
          Q^s_i = \\sum_{j=1}^m \\:  w^s_j \\: q_{ji}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("Q"),
            Plurimath::Math::Function::Text.new("i"),
            Plurimath::Math::Function::Text.new("s"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("j"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Function::Text.new("m")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("w"),
            Plurimath::Math::Function::Text.new("j"),
            Plurimath::Math::Function::Text.new("s"),
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("q"),
            Plurimath::Math::Function::Text.new("ji")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #76" do
      let(:string) {
        <<~LATEX
          Q = \\sum_{i=1}^n \\: s_i \\: w_i \\: q_i
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("Q"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Function::Text.new("n")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("w"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("q"),
            Plurimath::Math::Function::Text.new("i")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #77" do
      let(:string) {
        <<~LATEX
          Q = \\sum_{i=1}^n \\: s_i \\: j_i \\: w_i \\: q_i
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("Q"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Function::Text.new("n")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("j"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("w"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("q"),
            Plurimath::Math::Function::Text.new("i")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #78" do
      let(:string) {
        <<~LATEX
          Q = \\sum_{i=1}^n \\: j_i \\: w_i \\:  q_i
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("Q"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Function::Text.new("n")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("j"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("w"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("q"),
            Plurimath::Math::Function::Text.new("i")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #79" do
      let(:string) {
        <<~LATEX
          \\bf{y} \\cdot \\bf{d} > \\bf{tolerance} \\, |\\bf{y}| \\, |\\bf{d}|
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("y"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("d"),
            "bf"
          ),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("tolerance"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x2C;"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("y"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Symbol.new("&#x2C;"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("d"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("|")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #80" do
      let(:string) {
        <<~LATEX
          \\bf{z} = \\langle \\bf{x} \\times \\bf{d} \\rangle
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("z"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x27E8;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("x"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#xD7;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("d"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x27E9;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #81" do
      let(:string) {
        <<~LATEX
          \\bf{x} \\cdot \\bf{X} > \\bf{tolerance} \\, |\\bf{x}| \\, |\\bf{X}|
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("x"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("X"),
            "bf"
          ),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("tolerance"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x2C;"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("x"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Symbol.new("&#x2C;"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("X"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("|")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #82" do
      let(:string) {
        <<~LATEX
          z = << x xx Y >>
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("z"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("<"),
          Plurimath::Math::Symbol.new("<"),
          Plurimath::Math::Function::Text.new("xxxY"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Symbol.new(">")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #83" do
      let(:string) {
        <<~LATEX
          x * X > 0
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Function::Text.new("X"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Number.new("0")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #84" do
      let(:string) {
        <<~LATEX
          x * X > 0
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Function::Text.new("X"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Number.new("0")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #85" do
      let(:string) {
        <<~LATEX
          x * X > 0
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Function::Text.new("X"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Number.new("0")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #86" do
      let(:string) {
        <<~LATEX
          d * x > "tolerance" |d| |x|
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("d"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Function::Text.new("\"tolerance\""),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Function::Text.new("d"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbol.new("|")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #87" do
      let(:string) {
        <<~LATEX
          z * d > 0
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("z"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Function::Text.new("d"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Number.new("0")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #88" do
      let(:string) {
        <<~LATEX
          z * Z > "tolerance" |z| |Z|
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("z"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Function::Text.new("Z"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Function::Text.new("\"tolerance\""),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Function::Text.new("z"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Function::Text.new("Z"),
          Plurimath::Math::Symbol.new("|")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #89" do
      let(:string) {
        <<~LATEX
          y = << z xx X >>
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("y"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("<"),
          Plurimath::Math::Symbol.new("<"),
          Plurimath::Math::Function::Text.new("zxxX"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Symbol.new(">")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #90" do
      let(:string) {
        <<~LATEX
          z * Z > 0
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("z"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Function::Text.new("Z"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Number.new("0")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #91" do
      let(:string) {
        <<~LATEX
          \\bf{x^\\prime} = \\langle \\bf{\\eta} \\times \\bf{\\zeta} \\rangle
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Symbol.new("&#x2032;")
            ),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x27E8;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3B7;"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#xD7;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3B6;"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x27E9;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #92" do
      let(:string) {
        <<~LATEX
          \\bf{z^\\prime} = \\bf{\\zeta}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("z"),
              Plurimath::Math::Symbol.new("&#x2032;")
            ),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3B6;"),
            "bf"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #93" do
      let(:string) {
        <<~LATEX
          \\bf{z^\\prime} = \\langle \\bf{\\xi} \\times \\bf{\\eta} \\rangle
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("z"),
              Plurimath::Math::Symbol.new("&#x2032;")
            ),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x27E8;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3BE;"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#xD7;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3B7;"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x27E9;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #94" do
      let(:string) {
        <<~LATEX
          \\bf{y^\\prime} = \\bf{\\eta}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("y"),
              Plurimath::Math::Symbol.new("&#x2032;")
            ),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3B7;"),
            "bf"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #95" do
      let(:string) {
        <<~LATEX
          \\bf{y^\\prime} = \\langle \\bf{\\zeta} \\times \\bf{\\xi} \\rangle
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("y"),
              Plurimath::Math::Symbol.new("&#x2032;")
            ),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x27E8;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3B6;"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#xD7;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3BE;"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x27E9;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #96" do
      let(:string) {
        <<~LATEX
          \\bf{x^\\prime} = \\bf{\\xi}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Symbol.new("&#x2032;")
            ),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3BE;"),
            "bf"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #97" do
      let(:string) {
        <<~LATEX
          \\begin{array}{cc}
            \\left(
              \\begin{array}{ccccccc}
                & & & & & & \\\\
                & +k & & & & -k  \\\\
                & & & & & & \\\\
                & & & & & & \\\\
                & & & & & & \\\\
                & -k & & & & +k
              \\end{array}
            \\right) &
            \\begin{array}{cc}
              & \\\\
              \\cdots &
              \\mbox{degree of freedom 1, node 1} \\\\
              & \\\\
              & \\\\
              & \\\\
              \\cdots &
              \\mbox{degree of freedom 2, node 2}
            \\end{array} \\\\
            & \\\\
            \\begin{array}{cccccc}
              \\vdots & & & & & \\vdots
            \\end{array}
            & \\\\
            \\begin{array}{cccc}
              & \\mbox{degree of} &
              \\mbox{degree of} & \\\\
              & \\mbox{freedom 1,} &
              \\mbox{freedom 2,} & \\\\
              & \\mbox{node 1} &
              \\mbox{node 2} &
            \\end{array} &
          \\end{array}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Left.new("("),
                    Plurimath::Math::Function::Table::Array.new(
                      [
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([])
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([
                            Plurimath::Math::Symbol.new("+"),
                            Plurimath::Math::Function::Text.new("k")
                          ]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([
                            Plurimath::Math::Symbol.new("-"),
                            Plurimath::Math::Function::Text.new("k")
                          ])
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([])
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([])
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([])
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([
                            Plurimath::Math::Symbol.new("-"),
                            Plurimath::Math::Function::Text.new("k")
                          ]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([]),
                          Plurimath::Math::Function::Td.new([
                            Plurimath::Math::Symbol.new("+"),
                            Plurimath::Math::Function::Text.new("k")
                          ])
                        ])
                      ],
                      nil,
                      [
                        Plurimath::Math::Function::Text.new("ccccccc")
                      ],
                    ),
                    Plurimath::Math::Function::Right.new(")")
                  ])
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Table::Array.new(
                    [
                      Plurimath::Math::Function::Tr.new([
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([])
                      ]),
                      Plurimath::Math::Function::Tr.new([
                        Plurimath::Math::Function::Td.new([
                          Plurimath::Math::Symbol.new("&#x22EF;")
                        ]),
                        Plurimath::Math::Function::Td.new([
                          Plurimath::Math::Function::Text.new("\\mbox{degreeoffreedom1,node1}")
                        ])
                      ]),
                      Plurimath::Math::Function::Tr.new([
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([])
                      ]),
                      Plurimath::Math::Function::Tr.new([
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([])
                      ]),
                      Plurimath::Math::Function::Tr.new([
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([])
                      ]),
                      Plurimath::Math::Function::Tr.new([
                        Plurimath::Math::Function::Td.new([
                          Plurimath::Math::Symbol.new("&#x22EF;")
                        ]),
                        Plurimath::Math::Function::Td.new([
                          Plurimath::Math::Function::Text.new("\\mbox{degreeoffreedom2,node2}")
                        ])
                      ])
                    ],
                    nil,
                    [
                      Plurimath::Math::Function::Text.new("cc")
                    ],
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([]),
                Plurimath::Math::Function::Td.new([])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Table::Array.new(
                    [
                      Plurimath::Math::Function::Tr.new([
                        Plurimath::Math::Function::Td.new([
                          Plurimath::Math::Symbol.new("&#x22EE;")
                        ]),
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([
                          Plurimath::Math::Symbol.new("&#x22EE;")
                        ])
                      ])
                    ],
                    nil,
                    [
                      Plurimath::Math::Function::Text.new("cccccc")
                    ],
                  )
                ]),
                Plurimath::Math::Function::Td.new([])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Table::Array.new(
                    [
                      Plurimath::Math::Function::Tr.new([
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([
                          Plurimath::Math::Function::Text.new("\\mbox{degreeof}")
                        ]),
                        Plurimath::Math::Function::Td.new([
                          Plurimath::Math::Function::Text.new("\\mbox{degreeof}")
                        ]),
                        Plurimath::Math::Function::Td.new([])
                      ]),
                      Plurimath::Math::Function::Tr.new([
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([
                          Plurimath::Math::Function::Text.new("\\mbox{freedom1,}")
                        ]),
                        Plurimath::Math::Function::Td.new([
                          Plurimath::Math::Function::Text.new("\\mbox{freedom2,}")
                        ]),
                        Plurimath::Math::Function::Td.new([])
                      ]),
                      Plurimath::Math::Function::Tr.new([
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([
                          Plurimath::Math::Function::Text.new("\\mbox{node1}")
                        ]),
                        Plurimath::Math::Function::Td.new([
                          Plurimath::Math::Function::Text.new("\\mbox{node2}")
                        ]),
                        Plurimath::Math::Function::Td.new([])
                      ])
                    ],
                    nil,
                    [
                      Plurimath::Math::Function::Text.new("cccc")
                    ],
                  )
                ]),
                Plurimath::Math::Function::Td.new([])
              ])
            ],
            nil,
            [Plurimath::Math::Function::Text.new("cc")],
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #98" do
      let(:string) {
        <<~LATEX
          \\left(
             \\begin{array}{cccccc}
                dt_{x} & & & & & \\\\
                & dt_{y} & & & & \\\\
                & & dt_{z} & & & \\\\
                & & & dr_{x} & & \\\\
                & & & & dr_{y} & \\\\
                & & & & & dr_{z}
             \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("dt"),
                      Plurimath::Math::Function::Text.new("x")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("dt"),
                      Plurimath::Math::Function::Text.new("y")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("dt"),
                      Plurimath::Math::Function::Text.new("z")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("dr"),
                      Plurimath::Math::Function::Text.new("x")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("dr"),
                      Plurimath::Math::Function::Text.new("y")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("dr"),
                      Plurimath::Math::Function::Text.new("z")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cccccc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #99" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{cccccc}
              kt_{x} & & & & & \\\\
              & kt_{y} & & & & \\\\
              & & kt_{z} & & & \\\\
              & & & kr_{x} & & \\\\
              & & & & kr_{y} & \\\\
              & & & & & kr_{z}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("kt"),
                      Plurimath::Math::Function::Text.new("x")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("kt"),
                      Plurimath::Math::Function::Text.new("y")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("kt"),
                      Plurimath::Math::Function::Text.new("z")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("kr"),
                      Plurimath::Math::Function::Text.new("x")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("kr"),
                      Plurimath::Math::Function::Text.new("y")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("kr"),
                      Plurimath::Math::Function::Text.new("z")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cccccc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #100" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{cccccc}
              m_{x} & & & & & \\\\
              & m_{y} & & & & \\\\
              & & m_{z} & & & \\\\
              & & & i_{xx} &
              i_{xy} &
              i_{xz} \\\\
              & & & i_{xy} &
              i_{yy} &
              i_{yz} \\\\
              & & & i_{xz} &
              i_{yz} &
              i_{zz}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("m"),
                      Plurimath::Math::Function::Text.new("x")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("m"),
                      Plurimath::Math::Function::Text.new("y")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("m"),
                      Plurimath::Math::Function::Text.new("z")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("i"),
                      Plurimath::Math::Function::Text.new("xx")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("i"),
                      Plurimath::Math::Function::Text.new("xy")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("i"),
                      Plurimath::Math::Function::Text.new("xz")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("i"),
                      Plurimath::Math::Function::Text.new("xy")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("i"),
                      Plurimath::Math::Function::Text.new("yy")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("i"),
                      Plurimath::Math::Function::Text.new("yz")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("i"),
                      Plurimath::Math::Function::Text.new("xz")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("i"),
                      Plurimath::Math::Function::Text.new("yz")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("i"),
                      Plurimath::Math::Function::Text.new("zz")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cccccc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #101" do
      let(:string) {
        <<~LATEX
          bb f = M bb a
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("bbf"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("Mbba")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #102" do
      let(:string) {
        <<~LATEX
          bb f = D bb v
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("bbf"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("Dbbv")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #103" do
      let(:string) {
        <<~LATEX
          bb f = K bb d
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("bbf"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("Kbbd")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #104" do
      let(:string) {
        <<~LATEX
          ((1,,,,),(,2,,0,),(,,,3,),(,0,,ddots,),(,,,,n))
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(",")
            ]),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Number.new("0"),
              Plurimath::Math::Symbol.new(",")
            ]),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new(",")
            ]),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Number.new("0"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Function::Text.new("ddots"),
              Plurimath::Math::Symbol.new(",")
            ]),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Function::Text.new("n")
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #105" do
      let(:string) {
        <<~LATEX
          ((1,,,,,,("symetric")),(2,n+1,,,,,),(3,n+2,2n,,,,),(*,*,*,3n-2,,,),(*,*,*,*,*,,),(*,*,*,*,*,*,),(n,2n-1,3n-3,*,*,*,n(n+1)//2))
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Function::Text.new("\"symetric\"")
            ]),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(",")
            ]),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(",")
            ]),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(",")
            ]),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new(",")
            ]),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(",")
            ]),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("*"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Text.new("n"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("1")
              ]),
              Plurimath::Math::Symbol.new("/"),
              Plurimath::Math::Symbol.new("/"),
              Plurimath::Math::Number.new("2")
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end
    # results_schema_annotated

    context "contains latex equation #106" do
      let(:string) {
        <<~LATEX
          \\tilde{s} = p/\\rho^\\gamma
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Tilde.new(
            Plurimath::Math::Function::Text.new("s"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("p"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("&#x3C1;"),
            Plurimath::Math::Symbol.new("&#x3B3;")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #107" do
      let(:string) {
        <<~LATEX
          \\vec{q} = u \\hat{e}_x + v \\hat{e}_y + w \\hat{e}_z
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("u"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("x")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Text.new("v"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("y")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Text.new("w"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("z")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #108" do
      let(:string) {
        <<~LATEX
          q = \\sqrt{ \\vec{q} \\cdot \\vec{q} }
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("q"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sqrt.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Vec.new(
                Plurimath::Math::Function::Text.new("q")
              ),
              Plurimath::Math::Symbol.new("&#x22C5;"),
              Plurimath::Math::Function::Vec.new(
                Plurimath::Math::Function::Text.new("q")
              )
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #109" do
      let(:string) {
        <<~LATEX
          \\rho \\vec{q} = \\rho u \\hat{e}_x + \\rho v \\hat{e}_y + \\rho w \\hat{e}_z
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3C1;"),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x3C1;"),
          Plurimath::Math::Function::Text.new("u"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("x")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("&#x3C1;"),
          Plurimath::Math::Function::Text.new("v"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("y")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("&#x3C1;"),
          Plurimath::Math::Function::Text.new("w"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("z")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #110" do
      let(:string) {
        <<~LATEX
          \\rho e_0
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3C1;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("e"),
            Plurimath::Math::Number.new("0")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #111" do
      let(:string) {
        <<~LATEX
          \\mu
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3BC;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #112" do
      let(:string) {
        <<~LATEX
          \\nu
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3BD;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #113" do
      let(:string) {
        <<~LATEX
          \\bar{\\bar{S}}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Function::Bar.new(
              Plurimath::Math::Function::Text.new("S")
            ),
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #114" do
      let(:string) {
        <<~LATEX
          \\bar{\\bar{\\tau}}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Function::Bar.new(
              Plurimath::Math::Symbol.new("&#x3C4;")
            )
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #115" do
      let(:string) {
        <<~LATEX
          (x_1,x_2,x_3) = (x,y,z)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Number.new("1")
            ),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Number.new("2")
            ),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Number.new("3")
            )
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("x"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Function::Text.new("y"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Function::Text.new("z")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #116" do
      let(:string) {
        <<~LATEX
          (u_1,u_2,u_3) = (u,v,w)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Text.new("u"),
              Plurimath::Math::Number.new("1")
            ),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Text.new("u"),
              Plurimath::Math::Number.new("2")
            ),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Text.new("u"),
              Plurimath::Math::Number.new("3")
            )
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("u"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Function::Text.new("v"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Function::Text.new("w")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #117" do
      let(:string) {
        <<~LATEX
          \\lambda = -2/3 \\mu
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3BB;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("&#x3BC;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #118" do
      let(:string) {
        <<~LATEX
          - \\rho \\overline{u' e'}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Symbol.new("&#x3C1;"),
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("u"),
              Plurimath::Math::Symbol.new("'"),
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Symbol.new("'")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #119" do
      let(:string) {
        <<~LATEX
          \\overline{u' v'} = \\nu_t \\left( \\frac{\\partial u}{\\partial y} + \\frac{\\partial v}{\\partial x} \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("u"),
              Plurimath::Math::Symbol.new("'"),
              Plurimath::Math::Function::Text.new("v"),
              Plurimath::Math::Symbol.new("'")
            ])
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3BD;"),
            Plurimath::Math::Function::Text.new("t")
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Text.new("u")
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Text.new("y")
                ])
              ),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Text.new("v")
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Text.new("x")
                ])
              )
            ]),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #120" do
      let(:string) {
        <<~LATEX
          \\nu_t
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3BD;"),
            Plurimath::Math::Function::Text.new("t")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #121" do
      let(:string) {
        <<~LATEX
          \\epsilon
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3F5;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #122" do
      let(:string) {
        <<~LATEX
          k = {1\\over2}(\\overline{u'u'} + \\overline{v'v'} + \\overline{w'w'})
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("k"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2")
            ])
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Bar.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Text.new("u"),
                Plurimath::Math::Symbol.new("'"),
                Plurimath::Math::Function::Text.new("u"),
                Plurimath::Math::Symbol.new("'")
              ])
            ),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Function::Bar.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Text.new("v"),
                Plurimath::Math::Symbol.new("'"),
                Plurimath::Math::Function::Text.new("v"),
                Plurimath::Math::Symbol.new("'")
              ])
            ),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Function::Bar.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Text.new("w"),
                Plurimath::Math::Symbol.new("'"),
                Plurimath::Math::Function::Text.new("w"),
                Plurimath::Math::Symbol.new("'")
              ])
            )
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #123" do
      let(:string) {
        <<~LATEX
          \\nabla\\phi = \\vec{q}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2207;"),
          Plurimath::Math::Symbol.new("&#x3D5;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #124" do
      let(:string) {
        <<~LATEX
          \\nabla  \\times  \\psi = \\vec{q}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2207;"),
          Plurimath::Math::Symbol.new("&#xD7;"),
          Plurimath::Math::Symbol.new("&#x3C8;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #125" do
      let(:string) {
        <<~LATEX
          \\rho_0
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3C1;"),
            Plurimath::Math::Number.new("0")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #126" do
      let(:string) {
        <<~LATEX
          u = \\vec{q} \\cdot \\hat{e}_x
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("u"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("x")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #127" do
      let(:string) {
        <<~LATEX
          v = \\vec{q} \\cdot \\hat{e}_y
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("v"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("y")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #128" do
      let(:string) {
        <<~LATEX
          w = \\vec{q} \\cdot \\hat{e}_z
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("w"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("z")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #129" do
      let(:string) {
        <<~LATEX
          \\vec{q} \\cdot \\hat{e}_{r}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("r")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #130" do
      let(:string) {
        <<~LATEX
          \\theta
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3B8;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #131" do
      let(:string) {
        <<~LATEX
          \\vec{q} \\cdot \\hat{e}_{\\theta}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Symbol.new("&#x3B8;")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #132" do
      let(:string) {
        <<~LATEX
          \\phi
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3D5;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #133" do
      let(:string) {
        <<~LATEX
          \\vec{q} \\cdot \\hat{e}_{\\phi}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Symbol.new("&#x3D5;")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #134" do
      let(:string) {
        <<~LATEX
          \\vec{q} \\cdot \\hat{n}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Function::Text.new("n")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #135" do
      let(:string) {
        <<~LATEX
          \\rho u
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3C1;"),
          Plurimath::Math::Function::Text.new("u")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #136" do
      let(:string) {
        <<~LATEX
          (\\vec{q} \\cdot \\hat{e}_x)/q
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Vec.new(
              Plurimath::Math::Function::Text.new("q")
            ),
            Plurimath::Math::Symbol.new("&#x22C5;"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Hat.new(
                Plurimath::Math::Function::Text.new("e")
              ),
              Plurimath::Math::Function::Text.new("x")
            )
          ]),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Function::Text.new("q")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #137" do
      let(:string) {
        <<~LATEX
          (\\vec{q}\\cdot\\hat{e}_y)/q
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Vec.new(
              Plurimath::Math::Function::Text.new("q")
            ),
            Plurimath::Math::Symbol.new("&#x22C5;"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Hat.new(
                Plurimath::Math::Function::Text.new("e")
              ),
              Plurimath::Math::Function::Text.new("y")
            )
          ]),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Function::Text.new("q")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #138" do
      let(:string) {
        <<~LATEX
          (\\vec{q} \\cdot \\hat{e}_z)/q
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Vec.new(
              Plurimath::Math::Function::Text.new("q")
            ),
            Plurimath::Math::Symbol.new("&#x22C5;"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Hat.new(
                Plurimath::Math::Function::Text.new("e")
              ),
              Plurimath::Math::Function::Text.new("z")
            )
          ]),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Function::Text.new("q")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #139" do
      let(:string) {
        <<~LATEX
          \\rho \\vec{q} \\cdot \\hat{n}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3C1;"),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Function::Text.new("n")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #140" do
      let(:string) {
        <<~LATEX
          \\nu = \\mu / \\rho
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3BD;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x3BC;"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Symbol.new("&#x3C1;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #141" do
      let(:string) {
        <<~LATEX
          R = c_p - c_v
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("R"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Function::Text.new("p")
          ),
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Function::Text.new("v")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #142" do
      let(:string) {
        <<~LATEX
          \\rho \\overline{u' u'}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3C1;"),
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Text.new("u"),
                Plurimath::Math::Symbol.new("'"),
                Plurimath::Math::Function::Text.new("u"),
                Plurimath::Math::Symbol.new("'")
              ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end
    # domain_schema_annotated

    context "contains latex equation #143" do
      let(:string) {
        <<~LATEX
          \\begin{pmatrix}
            \\hat{e}_{\\xi} \\\\ \\hat{e}_{\\eta} \\\\ \\hat{e}_{\\zeta}
          \\end{pmatrix}
          = {\\bf T}
          \\begin{pmatrix}
            \\hat{e}_x \\\\ \\hat{e}_y \\\\ \\hat{e}_z
          \\end{pmatrix},
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Pmatrix.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Hat.new(
                      Plurimath::Math::Function::Text.new("e")
                    ),
                    Plurimath::Math::Symbol.new("&#x3BE;")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Hat.new(
                      Plurimath::Math::Function::Text.new("e")
                    ),
                    Plurimath::Math::Symbol.new("&#x3B7;")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Hat.new(
                      Plurimath::Math::Function::Text.new("e")
                    ),
                    Plurimath::Math::Symbol.new("&#x3B6;")
                  )
                ])
              ])
            ],
            "(",
            ")",
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("T"),
            "bf"
          ),
          Plurimath::Math::Function::Table::Pmatrix.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Hat.new(
                      Plurimath::Math::Function::Text.new("e")
                    ),
                    Plurimath::Math::Function::Text.new("x")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Hat.new(
                      Plurimath::Math::Function::Text.new("e")
                    ),
                    Plurimath::Math::Function::Text.new("y")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Hat.new(
                      Plurimath::Math::Function::Text.new("e")
                    ),
                    Plurimath::Math::Function::Text.new("z")
                  )
                ])
              ])
            ],
            "(",
            ")",
          ),
          Plurimath::Math::Symbol.new(",")
        ])
        expect(formula).to eq(expected_value)
      end
    end
    # finite_element_analysis_control_and_result_schema_annotated

    context "contains latex equation #144" do
      let(:string) {
        <<~LATEX
          \\varepsilon  =  \\frac{\\partial u}{\\partial x}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x03B5;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Function::Text.new("u")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Function::Text.new("x")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #145" do
      let(:string) {
        <<~LATEX
          \\phi  = \\frac{\\partial \\theta}{\\partial x}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3D5;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Symbol.new("&#x3B8;")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Function::Text.new("x")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #146" do
      let(:string) {
        <<~LATEX
          \\frac{\\partial \\theta}{\\partial z}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Symbol.new("&#x3B8;")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Function::Text.new("z")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #147" do
      let(:string) {
        <<~LATEX
          f =    {\\bf F}^{t}  \\:
          \\left(
            \\begin{array}{c}
              n_y \\\\
              n_z
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::FontStyle.new(
                Plurimath::Math::Function::Text.new("F"),
                "bf",
              )
            ]),
            Plurimath::Math::Function::Text.new("t")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("n"),
                      Plurimath::Math::Function::Text.new("y")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("n"),
                      Plurimath::Math::Function::Text.new("z")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #148" do
      let(:string) {
        <<~LATEX
          m =    {\\bf M}^{t}  \\:
          \\left( \\begin{array}{c} n_y \\\\ n_z \\end{array} \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("m"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::FontStyle.new(
                Plurimath::Math::Function::Text.new("M"),
                "bf"
              )
            ]),
            Plurimath::Math::Function::Text.new("t")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("n"),
                      Plurimath::Math::Function::Text.new("y")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("n"),
                      Plurimath::Math::Function::Text.new("z")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #149" do
      let(:string) {
        <<~LATEX
          {\\bf c} =  \\left(
                        \\begin{array}{c}
                          {\\displaystyle  - \\frac{\\partial^2 v}{\\partial x^2} } \\\\[2mm]
                          {\\displaystyle  - \\frac{\\partial^2 w}{\\partial x^2} }
                        \\end{array}
                      \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("c"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Symbol.new("-"),
                        "displaystyle"
                      ),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Number.new("2")
                          ),
                          Plurimath::Math::Function::Text.new("v")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Function::Text.new("x"),
                            Plurimath::Math::Number.new("2")
                          )
                        ])
                      )
                    ])
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Function::Text.new("mm")
                    ]),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Symbol.new("-"),
                        "displaystyle"
                      ),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Number.new("2")
                          ),
                          Plurimath::Math::Function::Text.new("w")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Function::Text.new("x"),
                            Plurimath::Math::Number.new("2")
                          )
                        ])
                      )
                    ])
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #150" do
      let(:string) {
        <<~LATEX
          \\left(
            \\begin{array}{c}
              {\\displaystyle \\frac{\\partial \\theta}{\\partial y}}   \\\\[3mm]
              {\\displaystyle \\frac{\\partial \\theta}{\\partial z}}
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Symbol.new("&#x3B8;")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("y")
                        ])
                      ),
                      "displaystyle"
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("3"),
                      Plurimath::Math::Function::Text.new("mm")
                    ]),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Symbol.new("&#x3B8;")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("z")
                        ])
                      ),
                      "displaystyle"
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #151" do
      let(:string) {
        <<~LATEX
          f =  \\bf{F}^{t}  \\:
          \\left(
            \\begin{array}{c}
              n_x \\\\
              n_y
            \\end{array}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::FontStyle.new(
              Plurimath::Math::Function::Text.new("F"),
              "bf"
            ),
            Plurimath::Math::Function::Text.new("t")
          ),
          Plurimath::Math::Symbol.new("&#x3A;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("n"),
                      Plurimath::Math::Function::Text.new("x")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("n"),
                      Plurimath::Math::Function::Text.new("y")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #152" do
      let(:string) {
        <<~LATEX
          \\varepsilon =  \\left(
                            \\begin{array}{c}
                              {\\displaystyle  \\frac{\\partial w}{\\partial x} +
                              \\frac{\\partial u}{\\partial z} }  \\\\
                              [2mm] {\\displaystyle  \\frac{\\partial w}{\\partial y} +
                              \\frac{\\partial v}{\\partial z} }
                            \\end{array}
                          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x03B5;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Function::Frac.new(
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Function::Text.new("w")
                          ]),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Function::Text.new("x")
                          ])
                        ),
                        "displaystyle"
                      ),
                      Plurimath::Math::Symbol.new("+"),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("u")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("z")
                        ])
                      )
                    ])
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Function::Text.new("mm")
                    ]),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Function::Frac.new(
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Function::Text.new("w")
                          ]),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Function::Text.new("y")
                          ])
                        ),
                        "displaystyle"
                      ),
                      Plurimath::Math::Symbol.new("+"),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("v")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("z")
                        ])
                      )
                    ])
                  ])
                ])
              ],
              nil,
              [
                  Plurimath::Math::Function::Text.new("c")
                ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #153" do
      let(:string) {
        <<~LATEX
          \\varepsilon =  \\left(
                            \\begin{array}{cc}
                              {\\displaystyle   \\frac{\\partial u}{\\partial x} }  &
                              {\\displaystyle \\frac{\\partial u}{\\partial y} } \\\\ [2mm]
                              {\\displaystyle   \\frac{\\partial v}{\\partial x} }  &
                              {\\displaystyle \\frac{\\partial v}{\\partial y} }
                            \\end{array}
                          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x03B5;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("u")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("x")
                        ])
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("u")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("y")
                        ])
                      ),
                      "displaystyle"
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Function::Text.new("mm")
                    ]),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("v")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("x")
                        ])
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("v")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("y")
                        ])
                      ),
                      "displaystyle"
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #154" do
      let(:string) {
        <<~LATEX
          c = \\left(
                \\begin{array}{cc}
                  {\\displaystyle - \\frac{\\partial^2 w}{\\partial x^2} } &
                  {\\displaystyle - \\frac{\\partial^2 w}{\\partial x \\partial y} } \\\\
                  [2mm]{\\displaystyle - \\frac{\\partial^2 w}{\\partial x \\partial y} } &
                  {\\displaystyle - \\frac{\\partial^2 w}{\\partial y^2} }
                \\end{array}
              \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("c"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Symbol.new("-"),
                        "displaystyle"
                      ),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Number.new("2")
                          ),
                          Plurimath::Math::Function::Text.new("w")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Function::Text.new("x"),
                            Plurimath::Math::Number.new("2")
                          )
                        ])
                      )
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Symbol.new("-"),
                        "displaystyle"
                      ),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Number.new("2")
                          ),
                          Plurimath::Math::Function::Text.new("w")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("x"),
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("y")
                        ])
                      )
                    ])
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Function::Text.new("mm")
                    ]),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Symbol.new("-"),
                        "displaystyle"
                      ),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Number.new("2")
                          ),
                          Plurimath::Math::Function::Text.new("w")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("x"),
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Text.new("y")
                        ])
                      )
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::FontStyle.new(
                        Plurimath::Math::Symbol.new("-"),
                        "displaystyle"
                      ),
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Symbol.new("&#x2202;"),
                            Plurimath::Math::Number.new("2")
                          ),
                          Plurimath::Math::Function::Text.new("w")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("&#x2202;"),
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Function::Text.new("y"),
                            Plurimath::Math::Number.new("2")
                          )
                        ])
                      )
                    ])
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("cc")
              ],
            ),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #155" do
      let(:string) {
        <<~LATEX
          \\varepsilon_{ij}^{E} = 1/2
          \\left(
            \\frac{\\partial v_i}{\\partial x_j} +
            \\frac{\\partial v_j}{\\partial x_i}
          \\right)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("&#x03B5;"),
            Plurimath::Math::Function::Text.new("ij"),
            Plurimath::Math::Function::Text.new("E"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("v"),
                    Plurimath::Math::Function::Text.new("i")
                  )
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("x"),
                    Plurimath::Math::Function::Text.new("j")
                  )
                ])
              ),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("v"),
                    Plurimath::Math::Function::Text.new("j")
                  )
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("x"),
                    Plurimath::Math::Function::Text.new("i")
                  )
                ])
              )
            ]),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #156" do
      let(:string) {
        <<~LATEX
          \\varepsilon_{ij}^{T} = \\alpha_{ij}(T-T_0)
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("&#x03B5;"),
            Plurimath::Math::Function::Text.new("ij"),
            Plurimath::Math::Function::Text.new("T"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3B1;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("T"),
            Plurimath::Math::Symbol.new("-"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Text.new("T"),
              Plurimath::Math::Number.new("0")
            )
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #157" do
      let(:string) {
        <<~LATEX
          \\varepsilon_{ij} = \\varepsilon_{ij}^{E} + \\varepsilon_{ij}^{T}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03B5;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("&#x03B5;"),
            Plurimath::Math::Function::Text.new("ij"),
            Plurimath::Math::Function::Text.new("E"),
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("&#x03B5;"),
            Plurimath::Math::Function::Text.new("ij"),
            Plurimath::Math::Function::Text.new("T"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #158" do
      let(:string) {
        <<~LATEX
          \\Delta v = \\sum_i \\sum_j   \\sigma_{ij} \\Delta \\varepsilon_{ij}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Text.new("v"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Function::Text.new("i"),
            nil
          ),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Function::Text.new("j"),
            nil
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3C3;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03B5;"),
            Plurimath::Math::Function::Text.new("ij")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #159" do
      let(:string) {
        <<~LATEX
          a_i \\cdot x_i = b_i
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x22C5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("x"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("b"),
            Plurimath::Math::Function::Text.new("i")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #160" do
      let(:string) {
        <<~LATEX
          \\sum_{i=1}^n \\left( a_i \\cdot x_i \\right)  = b
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Function::Text.new("n")
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("a"),
                Plurimath::Math::Function::Text.new("i")
              ),
              Plurimath::Math::Symbol.new("&#x22C5;"),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("x"),
                Plurimath::Math::Function::Text.new("i")
              )
            ]),
            Plurimath::Math::Function::Right.new(")")
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("b")
        ])
        expect(formula).to eq(expected_value)
      end
    end
    # 07-conditions.adoc

    context "contains latex equation #161" do
      let(:string) {
        <<~LATEX
          \\left[
            \\frac{\\partial}{\\partial t} + (u \\pm c) \\frac{\\partial}{\\partial x}
          \\right]
          \\left(
            u \\pm {2\\over{\\gamma - 1}} c
          \\right) = 0.
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("["),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Symbol.new("&#x2202;"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Text.new("t")
                ])
              ),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Text.new("u"),
                Plurimath::Math::Symbol.new("&#xB1;"),
                Plurimath::Math::Function::Text.new("c")
              ]),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Symbol.new("&#x2202;"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2202;"),
                  Plurimath::Math::Function::Text.new("x")
                ])
              )
            ]),
            Plurimath::Math::Function::Right.new("]")
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("u"),
              Plurimath::Math::Symbol.new("&#xB1;"),
              Plurimath::Math::Function::Over.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("2")
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("&#x3B3;"),
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Number.new("1")
                  ])
                ])
              ),
              Plurimath::Math::Function::Text.new("c")
            ]),
            Plurimath::Math::Function::Right.new(")")
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("0"),
          Plurimath::Math::Symbol.new(".")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #162" do
      let(:string) {
        <<~LATEX
          vec q xx hat s = 0
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("vecqxxhats"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("0")
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
