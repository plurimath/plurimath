require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Formula do
  describe ".to_latex" do
    subject(:formula) { exp.to_latex.gsub("\n", "").gsub(" ", "") }

    context "contains Formula of symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("\\beta"),
        ])
      }
      it "returns string of symbol" do
        expected_value =
        <<~Latex
          \\beta
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("p"),
            Plurimath::Math::Symbol.new("\\max"),
          )
        ])
      }
      it "returns string of symbol" do
        expected_value =
        <<~Latex
          p_{\\max}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Left.new(
            Plurimath::Math::Function::Table.new(
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
                      Plurimath::Math::Number.new("0")
                    ])
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Text.new("x"),
                      Plurimath::Math::Symbol.new("-"),
                      Plurimath::Math::Function::Text.new("y"),
                      Plurimath::Math::Symbol.new("+"),
                      Plurimath::Math::Number.new("8"),
                      Plurimath::Math::Function::Text.new("z"),
                      Plurimath::Math::Symbol.new("="),
                      Plurimath::Math::Number.new("0")
                    ])
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Function::Text.new("x"),
                      Plurimath::Math::Symbol.new("-"),
                      Plurimath::Math::Number.new("6"),
                      Plurimath::Math::Function::Text.new("y"),
                      Plurimath::Math::Symbol.new("+"),
                      Plurimath::Math::Function::Text.new("z"),
                      Plurimath::Math::Symbol.new("="),
                      Plurimath::Math::Number.new("0")
                    ])
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("l")
              ],
            )
          )
        ])
      }
      it "returns string of symbol" do
        expected_value =
        <<~Latex
          \\left(
            \\begin{array}{l}
              3x - 5y + 4z = 0 \\\\
              x - y + 8z = 0 \\\\
              2x - 6y + z = 0
            \\end{array}
          \\right)
        Latex
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains Formula of symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("hat"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Text.new("e")
                    ]),
                    Plurimath::Math::Symbol.new("xi")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("hat"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Text.new("e")
                    ]),
                    Plurimath::Math::Symbol.new("eta")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("hat"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Text.new("e")
                    ]),
                    Plurimath::Math::Symbol.new("zeta")
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
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("hat"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Text.new("e")
                    ]),
                    Plurimath::Math::Function::Text.new("x")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("hat"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Text.new("e")
                    ]),
                    Plurimath::Math::Function::Text.new("y")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("hat"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Text.new("e")
                    ]),
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
      }
      it "returns string of symbol" do
        expected_value =
        <<~Latex
          \\begin{pmatrix}
            \\hat{e}_{\\xi} \\\\ \\hat{e}_{\\eta} \\\\ \\hat{e}_{\\zeta}
          \\end{pmatrix}
          = \\bf{T}
          \\begin{pmatrix}
            \\hat{e}_{x} \\\\ \\hat{e}_{y} \\\\ \\hat{e}_{z}
          \\end{pmatrix},
        Latex
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains Formula of symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Left.new(
            Plurimath::Math::Function::Table.new(
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
            )
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("h"),
            Plurimath::Math::Function::Text.new("s")
          ),
          Plurimath::Math::Symbol.new(":"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("D"),
            Plurimath::Math::Function::Text.new("s")
          ),
          Plurimath::Math::Symbol.new(":"),
          Plurimath::Math::Function::Left.new(
            Plurimath::Math::Function::Table.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("varepsilon"),
                      Plurimath::Math::Function::Text.new("xz")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("varepsilon"),
                      Plurimath::Math::Function::Text.new("yz")
                    )
                  ])
                ])
              ],
              nil,
              [
                Plurimath::Math::Function::Text.new("c")
              ],
            )
          )
        ])
      }
      it "returns string of symbol" do
        expected_value =
        <<~Latex
          \\left(
            \\begin{array}{c}
              V_{x} \\\\
              V_{y}
            \\end{array}
          \\right) =
          h_{s} \\: D_{s} \\: \\left(
                            \\begin{array}{c}
                              \\varepsilon_{xz} \\\\
                              \\varepsilon_{yz}
                            \\end{array}
                          \\right)
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Inf.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Symbol.new(">"),
              Plurimath::Math::Function::Text.new("s"),
            ])
          ),
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Function::Text.new("x")
        ])
      }
      it "returns string of symbol" do
        expected_value =
        <<~Latex
          \\inf_{x > s}fx
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Limits.new(
            Plurimath::Math::Function::Int.new,
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Symbol.new("pi")
          )
        ])
      }
      it "returns string of symbol" do
        expected_value =
        <<~Latex
          \\int\\limits_{0}^{\\pi}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Substack.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("xi"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Function::Text.new("g"),
              Plurimath::Math::Function::Left.new(
                Plurimath::Math::Function::Text.new("x")
              )
            ])
          )
        ])
      }
      it "returns string of symbol" do
        expected_value =
        <<~Latex
          \\substack{ \\xi2=g\\left(x \\right)}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Function::Substack.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbol.new("le"),
                Plurimath::Math::Function::Text.new("i"),
                Plurimath::Math::Symbol.new("le"),
                Plurimath::Math::Function::Text.new("n")
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Text.new("i"),
                Plurimath::Math::Symbol.new("ne"),
                Plurimath::Math::Function::Text.new("j")
              ])
            ),
            nil
           )
        ])
      }
      it "returns string of symbol" do
        expected_value =
        <<~Latex
          \\sum_{\\substack{1\\le i\\le n\\\\ i\\ne j}}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Tan.new(
            Plurimath::Math::Function::Text.new("x")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Sec.new(
            Plurimath::Math::Function::Text.new("x")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Cos.new(
            Plurimath::Math::Function::Text.new("x")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Function::Text.new("x")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Cot.new(
            Plurimath::Math::Function::Text.new("x")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Csc.new(
            Plurimath::Math::Function::Text.new("x")
          )
        ])
      }
      it "returns string of symbol" do
        expected_value =
        <<~Latex
          \\tan{x} + \\sec{x} + \\cos{x} + \\sin{x} + \\cot{x} + \\csc{x}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Function::Text.new("b"),
            Plurimath::Math::Function::Text.new("c"),
          )
        ])
      }
      it "returns string of symbol" do
        expected_value =
        <<~Latex
          a_{b}^{c}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Sum" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("^"),
          Plurimath::Math::Number.new("3")
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          ^3
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Sum" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new,
          Plurimath::Math::Function::Text.new("x")
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\log x
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Sum" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbol.new("\\beta"),
            Plurimath::Math::Number.new("1")
          ),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\sum_{\\beta}^{1}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Sum with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbol.new("\\beta"),
            Plurimath::Math::Function::Text.new("a")
          ),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\sum_{\\beta}^{a}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Cos with symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Function::Cos.new(
            Plurimath::Math::Symbol.new("\\beta")
          ),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          3\\cos{\\beta}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of simple Plus math equation" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("b")
          ]),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          a+b
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Left function" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Left.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("\\beta"),
                Plurimath::Math::Symbol.new("slash"),
                Plurimath::Math::Function::Text.new("t"),
              ]),
            ]),
          ),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\left(\\beta\\slasht\\right)
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Bar with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Function::Text.new("v")
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\overline{v}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Bar with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Overset.new,
          Plurimath::Math::Function::Text.new("rightarrow"),
          Plurimath::Math::Function::Text.new("a")
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\overrightarrow a
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Base" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Number.new("1"),
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          1_{}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Sum with infty symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Symbol.new("infty"),
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\sum_{n=1}^{\\infty}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Prod with infty symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Symbol.new("infty"),
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\prod_{n=1}^{\\infty}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Mod with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Function::Text.new("b"),
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          {a}\\pmod{b}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Plus Minus math equation" do
      let(:exp) {
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
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          3x-5y+4z=0
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of simple multiplication equation" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Number.new("2"),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          3x*2
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Frac" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Number.new("2"),
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\frac{1}{2}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Array Table" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
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
            [Plurimath::Math::Function::Text.new("a")]
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{array}{a}3x-5y+4z=0\\end{array}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Array with separator args" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
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
            nil,
            [
              Plurimath::Math::Function::Text.new("a"),
              Plurimath::Math::Function::Text.new("b"),
            ]
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{array}{ab}
            a_{1} & b_{2} \\\\
            c_{1} & d_{2}
          \\end{array}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Pmatrix with numbers" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{pmatrix}
            2 \\\\ 3
          \\end{pmatrix}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Array with separator args and simple text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
            nil,
            [
              Plurimath::Math::Function::Text.new("a"),
              Plurimath::Math::Function::Text.new("b"),
            ]
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{array}{ab}
            a & b
          \\end{array}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Bmatrix with simple text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{Bmatrix}
            a & b \\\\
            c & d
          \\end{Bmatrix}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Vmatrix with simple text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{vmatrix} a & b \\end{vmatrix}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Bmatrix with negative text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{Bmatrix}-a & b \\\\ c & d \\end{Bmatrix}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Pmatrix with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{pmatrix}
            a & b
          \\end{pmatrix}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Array with separator symbol and hline symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
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
            ],
            nil,
            [
              Plurimath::Math::Function::Text.new("a"),
              Plurimath::Math::Symbol.new("|"),
              Plurimath::Math::Function::Text.new("b"),
            ]
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{array}{a|b}
            1 & 2 \\hline \\\\ 3 & 4
          \\end{array}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Vmatrix with Sqrt function" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{Vmatrix}
            \\sqrt{{-25}^{2}} = \\pm 25
          \\end{Vmatrix}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Root with symbols" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Root.new(
            Plurimath::Math::Symbol.new("\\beta"),
            Plurimath::Math::Symbol.new("pm"),
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\sqrt[\\beta]{\\pm}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Log" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new(
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Text.new("x"),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\log_{2}x
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Lim" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\lim_{x\\to +\\infty} fx
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Array, Base with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new(
              Plurimath::Math::Function::Table.new(
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
                  Plurimath::Math::Function::Text.new("a"),
                ]
              ),
            )
          ])
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\left(
            \\begin{array}{a}
              V_{x} \\\\
              V_{y}
            \\end{array}
          \\right)
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of simple text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a+b")
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value ="a+b"
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Greater Than symbol with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Number.new("2"),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          a > 2
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Less Than symbol with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Symbol.new("<"),
          Plurimath::Math::Number.new("2"),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          a < 2
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of only Ampersand symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&"),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          &
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of FontStyle mathrm" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("R"),
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("\\beta"),
            ]),
            "mathrm",
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\mathrm{R1\\beta}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Symbol PowerBase with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("\\beta"),
            Plurimath::Math::Function::Text.new("R"),
            Plurimath::Math::Function::Text.new("C"),
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\beta_{R}^{C}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Symbol PowerBase with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([]),
                Plurimath::Math::Function::Td.new([]),
                Plurimath::Math::Function::Td.new([]),
                Plurimath::Math::Function::Td.new([]),
                Plurimath::Math::Function::Td.new([]),
                Plurimath::Math::Function::Td.new([]),
                Plurimath::Math::Function::Td.new([]),
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
                ]),
              ]),
            ],
            nil,
            [
              Plurimath::Math::Function::Text.new("a"),
              Plurimath::Math::Function::Text.new("b"),
              Plurimath::Math::Function::Text.new("c"),
              Plurimath::Math::Function::Text.new("d"),
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Function::Text.new("f"),
              Plurimath::Math::Function::Text.new("g"),
            ]
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{array}{abcdefg}
            & & & & & & \\\\
            & +k & & & & -k
          \\end{array}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Symbol PowerBase with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("cdots"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("mbox{degreeoffreedom1,node1}")
                ]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([]),
                Plurimath::Math::Function::Td.new([]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("cdots"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("mbox{degreeoffreedom2,node2}")
                ]),
              ]),
            ],
            nil,
            [
              Plurimath::Math::Function::Text.new("a"),
              Plurimath::Math::Function::Text.new("b"),
            ]
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{array}{ab}
            \\cdots & mbox{degreeoffreedom1,node1} \\\\
            & \\\\
            \\cdots & mbox{degreeoffreedom2,node2}
          \\end{array}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Symbol PowerBase with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("C"),
                    Plurimath::Math::Function::Text.new("L"),
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Overset.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Text.new("L")
                    ]),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Overset.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Number.new("1")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Number.new("2")
                        ]),
                      ),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Symbol.new("rho"),
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
                      Plurimath::Math::Function::Text.new("S"),
                    ]),
                  )
                ]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("C"),
                    Plurimath::Math::Function::Text.new("D"),
                  ),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Overset.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Text.new("D"),
                    ]),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Overset.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Number.new("1")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Number.new("2")
                        ]),
                      ),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Symbol.new("rho"),
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
                        Plurimath::Math::Number.new("2"),
                      ),
                      Plurimath::Math::Function::Text.new("S"),
                    ]),
                  )
                ]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Vec.new(
                      Plurimath::Math::Function::Text.new("C"),
                    ),
                    Plurimath::Math::Function::Text.new("M"),
                  ),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Overset.new(
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Function::Vec.new(
                          Plurimath::Math::Function::Text.new("M"),
                        ),
                      ]),
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Function::Overset.new(
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Number.new("1")
                          ]),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Number.new("2")
                          ]),
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("rho"),
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
                        ),
                      ]),
                    ),
                    Plurimath::Math::Symbol.new(","),
                  ]),
                ]),
              ]),
            ],
            nil,
            [
              Plurimath::Math::Function::Text.new("a"),
              Plurimath::Math::Function::Text.new("b"),
            ]
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{array}{ab}
            C_{L} &= {L \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} S} \\\\ \\\\
            C_{D} &= {D \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} S} \\\\ \\\\
            \\vec{C}_{M} &= {\\vec{M} \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} c_{\\textrm{ref}} S_{\\textrm{ref}}},
          \\end{array}
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Symbol PowerBase with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Function::Text.new("l"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("L"),
              Plurimath::Math::Symbol.new("'"),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Overset.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1"),
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("2"),
                ]),
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("rho"),
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
                Plurimath::Math::Number.new("2"),
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("c"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm",
                ),
              ),
            ]),
          ),
          Plurimath::Math::Symbol.new("pm"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Function::Text.new("d"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("D"),
              Plurimath::Math::Symbol.new("'"),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Overset.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1"),
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("2"),
                ]),
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("rho"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm",
                )
              ),
              Plurimath::Math::Function::PowerBase.new(
                Plurimath::Math::Function::Text.new("q"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm",
                ),
                Plurimath::Math::Number.new("2"),
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Text.new("c"),
                Plurimath::Math::Function::FontStyle.new(
                  Plurimath::Math::Function::Text.new("ref"),
                  "textrm",
                )
              ),
            ]),
          ),
          Plurimath::Math::Symbol.new("pm"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Vec.new(
              Plurimath::Math::Function::Text.new("c"),
            ),
            Plurimath::Math::Function::Text.new("m"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Overset.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Vec.new(
                  Plurimath::Math::Function::Text.new("M"),
                ),
                Plurimath::Math::Symbol.new("'"),
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Overset.new(
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Number.new("1"),
                  ]),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Number.new("2"),
                  ]),
                ),
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Symbol.new("rho"),
                  Plurimath::Math::Function::FontStyle.new(
                    Plurimath::Math::Function::Text.new("ref"),
                    "textrm",
                  ),
                ),
                Plurimath::Math::Function::PowerBase.new(
                  Plurimath::Math::Function::Text.new("q"),
                  Plurimath::Math::Function::FontStyle.new(
                    Plurimath::Math::Function::Text.new("ref"),
                    "textrm",
                  ),
                  Plurimath::Math::Number.new("2"),
                ),
                Plurimath::Math::Function::PowerBase.new(
                  Plurimath::Math::Function::Text.new("c"),
                  Plurimath::Math::Function::FontStyle.new(
                    Plurimath::Math::Function::Text.new("ref"),
                    "textrm",
                  ),
                  Plurimath::Math::Number.new("2"),
                ),
              ]),
            )
          ]),
          Plurimath::Math::Symbol.new(","),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          c_{l} = {L' \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} c_{\\textrm{ref}}} \\pm
          c_{d} = {D' \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} c_{\\textrm{ref}}} \\pm
          \\vec{c}_{m} = {\\vec{M}' \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} c_{\\textrm{ref}}^{2}},
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end

    context "contains Formula of Symbol PowerBase with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new(
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Function::Text.new("T"),
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("T"),
                  Plurimath::Math::Function::FontStyle.new(
                    Plurimath::Math::Function::Text.new("ref"),
                    "textrm"
                  ),
                )
              ),
            ),
          ])
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\left(\\frac{T}{T_{\\textrm{ref}}} \\right)
        Latex
        expect(formula).to eq(expected_value.gsub("\n", "").gsub(" ", ""))
      end
    end
  end
end
