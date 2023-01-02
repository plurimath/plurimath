require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Formula do
  describe ".to_latex" do
    subject(:formula) { exp.to_latex.gsub(/\s/, "") }

    context "contains Formula of symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3b2;"),
        ])
      }
      it "returns string of symbol" do
        expected_value = "\\beta"
        expect(formula).to eq(expected_value)
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
        expected_value = "p_{\\max}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Array matrix with left and right" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Left.new("("),
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
          ),
          Plurimath::Math::Function::Right.new(")"),
        ])
      }
      it "returns string of symbol" do
        expected_value = "\\left(\\begin{array}{l}3x-5y+4z=0\\\\x-y+8z=0\\\\2x-6y+z=0\\end{array}\\right)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Pmatrix" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Pmatrix.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Hat.new(
                      Plurimath::Math::Function::Text.new("e")
                    ),
                    Plurimath::Math::Symbol.new("&#x3be;")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Hat.new(
                      Plurimath::Math::Function::Text.new("e")
                    ),
                    Plurimath::Math::Symbol.new("&#x3b7;")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Hat.new(
                      Plurimath::Math::Function::Text.new("e")
                    ),
                    Plurimath::Math::Symbol.new("&#x3b6;")
                  )
                ])
              ])
            ],
           "(",
            [],
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
            [],
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

    context "contains Formula of double left and right with Array matrix" do
      let(:exp) {
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
          Plurimath::Math::Function::Right.new(")"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("h"),
            Plurimath::Math::Function::Text.new("s")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("D"),
            Plurimath::Math::Function::Text.new("s")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Left.new("("),
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x03b5;"),
                    Plurimath::Math::Function::Text.new("xz")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x03b5;"),
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
          Plurimath::Math::Function::Right.new(")"),
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
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains Formula of inf class" do
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
        expected_value = "\\inf_{x>s}fx"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of limits with int" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Limits.new(
            Plurimath::Math::Function::Int.new,
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Symbol.new("&#x3c0;")
          )
        ])
      }
      it "returns string of symbol" do
        expected_value = "\\int\\limits_{0}^{\\pi}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of substack" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Substack.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x3be;"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Function::Text.new("g"),
              Plurimath::Math::Function::Left.new("("),
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Function::Right.new(")"),
            ])
          )
        ])
      }
      it "returns string of symbol" do
        expected_value = "\\substack{\\xi2=g\\left(x\\right)}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of sum with substack" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Function::Substack.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbol.new("&#x2264;"),
                Plurimath::Math::Function::Text.new("i"),
                Plurimath::Math::Symbol.new("&#x2264;"),
                Plurimath::Math::Function::Text.new("n")
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Text.new("i"),
                Plurimath::Math::Symbol.new("&#x2260;"),
                Plurimath::Math::Function::Text.new("j")
              ])
            ),
            nil
          )
        ])
      }
      it "returns string of symbol" do
        expected_value = "\\sum_{\\substack{1\\lei\\len\\\\i\\nej}}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of multiple math classes" do
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
        expected_value = "\\tan{x}+\\sec{x}+\\cos{x}+\\sin{x}+\\cot{x}+\\csc{x}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of PowerBase" do
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
        expected_value = "a_{b}^{c}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Power symbol with number" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("^"),
          Plurimath::Math::Number.new("3")
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "^3"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Log and text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new,
          Plurimath::Math::Function::Text.new("x")
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\logx"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Sum" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbol.new("&#x3b2;"),
            Plurimath::Math::Number.new("1")
          ),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\sum_{\\beta}^{1}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Sum with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbol.new("&#x3b2;"),
            Plurimath::Math::Function::Text.new("a")
          ),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\sum_{\\beta}^{a}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Cos with symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Function::Cos.new(
            Plurimath::Math::Symbol.new("&#x3b2;")
          ),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "3\\cos{\\beta}"
        expect(formula).to eq(expected_value)
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
        expected_value = "a+b"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Left function" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Left.new("("),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x3b2;"),
              Plurimath::Math::Symbol.new("&#x2215;"),
              Plurimath::Math::Function::Text.new("t"),
            ]),
          ]),
          Plurimath::Math::Function::Right.new(")"),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\left(\\beta\\slasht\\right)"
        expect(formula).to eq(expected_value)
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
        expected_value = "\\bar{v}"
        expect(formula).to eq(expected_value)
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
        expected_value = "\\overrightarrowa"
        expect(formula).to eq(expected_value)
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
        expected_value = "1_{}"
        expect(formula).to eq(expected_value)
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
            Plurimath::Math::Symbol.new("&#x221e;"),
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\sum_{n=1}^{\\infty}"
        expect(formula).to eq(expected_value)
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
            Plurimath::Math::Symbol.new("&#x221e;"),
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\prod_{n=1}^{\\infty}"
        expect(formula).to eq(expected_value)
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
        expected_value = "{a}\\pmod{b}"
        expect(formula).to eq(expected_value)
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
        expected_value = "3x-5y+4z=0"
        expect(formula).to eq(expected_value)
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
        expected_value = "3x*2"
        expect(formula).to eq(expected_value)
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
        expected_value = "\\frac{1}{2}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Array Table" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
              Plurimath::Math::Function::Text.new("a")
            ]
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\begin{array}{a}3x-5y+4z=0\\end{array}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Array with separator args" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
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
        expected_value = "\\begin{array}{ab}a_{1}&b_{2}\\\\c_{1}&d_{2}\\end{array}"
        expect(formula).to eq(expected_value)
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
        expected_value = "\\begin{pmatrix}2\\\\3\\end{pmatrix}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Array with separator args and simple text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
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
        expected_value = "\\begin{array}{ab}a&b\\end{array}"
        expect(formula).to eq(expected_value)
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
            [],
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\begin{Bmatrix}a&b\\\\c&d\\end{Bmatrix}"
        expect(formula).to eq(expected_value)
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
        expected_value = "\\begin{vmatrix}a&b\\end{vmatrix}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Bmatrix with negative text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
            "{",
            [],
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\begin{Bmatrix}-a&b\\\\c&d\\end{Bmatrix}"
        expect(formula).to eq(expected_value)
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
            [],
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\begin{pmatrix}a&b\\end{pmatrix}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Array with separator symbol and hline symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1"),
                ]),
                Plurimath::Math::Symbol.new("|"),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("2"),
                  Plurimath::Math::Symbol.new("&#x23af;"),
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
        expected_value = "\\begin{array}{a|b}1&2\\hline\\\\3&4\\end{array}"
        expect(formula).to eq(expected_value)
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
                  Plurimath::Math::Symbol.new("&#xb1;"),
                  Plurimath::Math::Number.new("25"),
                ])
              ])
            ],
            "norm[",
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\begin{Vmatrix}\\sqrt{{-25}^{2}}=\\pm25\\end{Vmatrix}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Root with symbols" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Root.new(
            Plurimath::Math::Symbol.new("&#x3b2;"),
            Plurimath::Math::Symbol.new("&#xb1;"),
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\sqrt[\\beta]{\\pm}"
        expect(formula).to eq(expected_value)
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
        expected_value = "\\log_{2}x"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Lim" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Lim.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Symbol.new("&#x2192;"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Symbol.new("&#x221e;"),
            ]),
          ),
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Function::Text.new("x"),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\lim_{x\\to+\\infty}fx"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Array, Base with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                Plurimath::Math::Function::Text.new("a"),
              ]
            ),
            Plurimath::Math::Function::Right.new(")"),
          ])
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\left(\\begin{array}{a}V_{x}\\\\V_{y}\\end{array}\\right)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of simple text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a+b")
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "a+b"
        expect(formula).to eq(expected_value)
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
        expected_value = "a>2"
        expect(formula).to eq(expected_value)
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
        expected_value = "a<2"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of only Ampersand symbol" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&"),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "&"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of FontStyle mathrm" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("R"),
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("&#x3b2;"),
            ]),
            "mathrm",
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\mathrm{R1\\beta}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Symbol PowerBase with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("&#x3b2;"),
            Plurimath::Math::Function::Text.new("R"),
            Plurimath::Math::Function::Text.new("C"),
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\beta_{R}^{C}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Symbol PowerBase with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
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
        expected_value = "\\begin{array}{abcdefg}&&&&&&\\\\&+k&&&&-k\\end{array}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Symbol PowerBase with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("&#x22ef;"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("\\mbox{degreeoffreedom1,node1}")
                ]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([]),
                Plurimath::Math::Function::Td.new([]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("&#x22ef;"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Text.new("\\mbox{degreeoffreedom2,node2}")
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
        expected_value = "\\begin{array}{ab}\\cdots&\\mbox{degreeoffreedom1,node1}\\\\&\\\\\\cdots&\\mbox{degreeoffreedom2,node2}\\end{array}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains Formula of Symbol PowerBase with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Split.new(
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
                      Plurimath::Math::Function::Over.new(
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Number.new("1")
                        ]),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Number.new("2")
                        ]),
                      ),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Symbol.new("&#x3c1;"),
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
                        Plurimath::Math::Symbol.new("&#x3c1;"),
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
                          Plurimath::Math::Symbol.new("&#x3c1;"),
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
            [],
          )
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value =
        <<~Latex
          \\begin{split}
            C_{L} &= {L \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} S} \\\\ \\\\
            C_{D} &= {D \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} S} \\\\ \\\\
            \\vec{C}_{M} &= {\\vec{M} \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} c_{\\textrm{ref}} S_{\\textrm{ref}}},
          \\end{split}
        Latex
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
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
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("L"),
              Plurimath::Math::Symbol.new("'"),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Over.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1"),
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("2"),
                ]),
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("&#x3c1;"),
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
          Plurimath::Math::Symbol.new("&#xa0;&#xa0;&#xa0;&#xa0;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Function::Text.new("d"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("D"),
              Plurimath::Math::Symbol.new("'"),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Over.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1"),
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("2"),
                ]),
              ),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("&#x3c1;"),
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
          Plurimath::Math::Symbol.new("&#xa0;&#xa0;&#xa0;&#xa0;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Vec.new(
              Plurimath::Math::Function::Text.new("c"),
            ),
            Plurimath::Math::Function::Text.new("m"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Over.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Vec.new(
                  Plurimath::Math::Function::Text.new("M"),
                ),
                Plurimath::Math::Symbol.new("'"),
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Over.new(
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Number.new("1"),
                  ]),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Number.new("2"),
                  ]),
                ),
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Symbol.new("&#x3c1;"),
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
          c_{l} = {L' \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} c_{\\textrm{ref}}} \\qquad
          c_{d} = {D' \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} c_{\\textrm{ref}}} \\qquad
          \\vec{c}_{m} = {\\vec{M}' \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} c_{\\textrm{ref}}^{2}},
        Latex
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains Formula of Symbol PowerBase with text" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
              )
            ),
            Plurimath::Math::Function::Right.new(")"),
          ])
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\left(\\frac{T}{T_{\\textrm{ref}}}\\right)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #1" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x222b;"),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("f")
          ),
          Plurimath::Math::Symbol.new("&#x2c;"),
          Plurimath::Math::Function::Text.new("dA"),
          Plurimath::Math::Symbol.new(","),
        ])
      }
      it "returns formula of sin from Latex string" do
        expected_value = "\\vec{F}=F_{x}\\hat{e}_{x}+F_{y}\\hat{e}_{y}+F_{z}\\hat{e}_{z}=\\int\\vec{f}\\,dA,"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #2" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x222b;"),
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
          Plurimath::Math::Symbol.new("&#xd7;"),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("f"),
          ),
          Plurimath::Math::Symbol.new("&#x2c;"),
          Plurimath::Math::Function::Text.new("dA"),
          Plurimath::Math::Symbol.new("."),
        ])
      }
      it "returns formula" do
        expected_value = "\\vec{M}=M_{x}\\hat{e}_{x}+M_{y}\\hat{e}_{y}+M_{z}\\hat{e}_{z}=\\int\\vec{r}-\\vec{r}_{0}\\times\\vec{f}\\,dA."
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #3" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("L"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("F")
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Function::Text.new("L"),
          ),
          Plurimath::Math::Symbol.new("&#xa0;&#xa0;&#xa0;&#xa0;"),
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("F"),
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Function::Text.new("D"),
          ),
        ])
      }
      it "returns formula" do
        expected_value = "L=\\vec{F}\\cdot\\hat{L}\\qquadD=\\vec{F}\\cdot\\hat{D}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #4" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("L"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("F")
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Symbol.new("&#x3b7;"),
          ),
          Plurimath::Math::Symbol.new("&#xa0;&#xa0;&#xa0;&#xa0;"),
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("F"),
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Symbol.new("&#x3be;")
          )
        ])
      }
      it "returns formula" do
        expected_value = "L=\\vec{F}\\cdot\\hat{e}_{\\eta}\\qquadD=\\vec{F}\\cdot\\hat{e}_{\\xi}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #5" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("M"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("M"),
            Plurimath::Math::Symbol.new("&#x3be;"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Symbol.new("&#x3be;")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("M"),
            Plurimath::Math::Symbol.new("&#x3b7;"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Symbol.new("&#x3b7;"),
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("M"),
            Plurimath::Math::Symbol.new("&#x3b6;"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e"),
            ),
            Plurimath::Math::Symbol.new("&#x3b6;"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x222b;"),
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
          Plurimath::Math::Symbol.new("&#xd7;"),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("f")
          ),
          Plurimath::Math::Symbol.new("&#x2c;"),
          Plurimath::Math::Function::Text.new("dA"),
          Plurimath::Math::Symbol.new(".")
        ])
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\vec{M} = M_{\\xi} \\hat{e}_{\\xi} + M_{\\eta} \\hat{e}_{\\eta} + M_{\\zeta} \\hat{e}_{\\zeta} =
            \\int \\vec{r} - \\vec{r}_{0} \\times \\vec{f} \\,dA.
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #6" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                        Plurimath::Math::Symbol.new("&#x3c1;"),
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
                        Plurimath::Math::Symbol.new("&#x3c1;"),
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
                      Plurimath::Math::Symbol.new("&#x3b2;"),
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
                        Plurimath::Math::Symbol.new("&#x3c1;"),
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
            nil,
            [],
          )
        ])
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\begin{split}
            C_{L} &= {L \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} S} \\\\ \\\\
            C_{D} &= {D \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} S} \\\\ \\\\
            \\vec{C}_{M} &= {\\beta \\vec{M} \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} c_{\\textrm{ref}} S_{\\textrm{ref}}},
          \\end{split}
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #7" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                Plurimath::Math::Symbol.new("&#x3c1;"),
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
          Plurimath::Math::Symbol.new("&#xa0;&#xa0;&#xa0;&#xa0;"),
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
                Plurimath::Math::Symbol.new("&#x3c1;"),
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
          Plurimath::Math::Symbol.new("&#xa0;&#xa0;&#xa0;&#xa0;"),
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
                Plurimath::Math::Symbol.new("&#x3c1;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          c_{l} = {L' \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} c_{\\textrm{ref}}} \\qquad
          c_{d} = {D' \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} c_{\\textrm{ref}}} \\qquad
          \\vec{c}_{m} = {\\vec{M}' \\over {1\\over2} \\rho_{\\textrm{ref}} q_{\\textrm{ref}}^{2} c_{\\textrm{ref}}^{2}},
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #8" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "k=k_{\\textrm{ref}}{\\left(\\frac{T}{T_{\\textrm{ref}}}\\right)}^{3/2}\\frac{T_{\\textrm{ref}}+T_{s}}{T+T_{s}},"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #9" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("u"),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("'"),
                Plurimath::Math::Function::Text.new("i"),
              ),
                Plurimath::Math::Function::Text.new("u"),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("'"),
                Plurimath::Math::Function::Text.new("j"),
              ),
            ])
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3bd;"),
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
      }
      it "returns formula" do
        expected_value = "-\\bar{u'_{i}u'_{j}}=\\nu_{t}\\left(\\frac{\\partialu_{i}}{\\partialx_{j}}+\\frac{\\partialu_{j}}{\\partialx_{i}}\\right)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #10" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3bc;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3bc;"),
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
      }
      it "returns formula" do
        expected_value = "\\mu=\\mu_{\\textrm{ref}}{\\left(\\frac{T}{T_{\\textrm{ref}}}\\right)}^{n}."
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #11" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3bc;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3bc;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\mu = \\mu_{\\textrm{ref}} {\\left( \\frac{T}{T_{\\textrm{ref}}} \\right)}^{3/2}
          \\frac{T_{\\textrm{ref}} + T_{s}}{T + T_{s}},
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #12" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm",
          ),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Symbol.new("$"),
          Plurimath::Math::Symbol.new("$"),
        ])
      }
      it "returns formula" do
        expected_value = "$$f_{i}=\\sum_{j=1}^{2}s_{ij}n_{j}\\;\\rm{for}\\;i=1,2$$"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #13" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm",
          ),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("3"),
        ])
      }
      it "returns formula" do
        expected_value = "f_{i}=\\sum_{j=1}^{3}s_{ij}n_{j}\\;\\rm{for}\\;i=1,3"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #14" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "\\left(\\begin{array}{ccc}s&0&0\\\\0&s&0\\\\0&0&s\\end{array}\\right)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #15" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "\\left(\\begin{array}{ccc}s_{11}&0&0\\\\0&s_{22}&0\\\\0&0&s_{33}\\end{array}\\right)"
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #16" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm",
          ),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("and"),
            "rm",
          ),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::Text.new("j"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("2"),
        ])
      }
      it "returns formula" do
        expected_value = "s_{ij}=\\sum_{k=1}^{2}\\sum_{l=1}^{2}d_{ijkl}e_{kl}\\;\\rm{for}\\;i=1,2\\;\\rm{and}\\;j=1,2"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #17" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "\\left(\\begin{array}{c}s_{11}\\\\s_{22}\\\\s_{33}\\\\s_{12}\\\\s_{23}\\\\s_{31}\\end{array}\\right)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #18" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #19" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3c3;"),
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
              Plurimath::Math::Symbol.new("&#x03b5;"),
              Plurimath::Math::Function::Text.new("kl")
            ),
            Plurimath::Math::Symbol.new("-"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Symbol.new("&#x3b1;"),
              Plurimath::Math::Function::Text.new("kl")
            ),
            Plurimath::Math::Symbol.new("&#x394;"),
            Plurimath::Math::Function::Text.new("T"),
            Plurimath::Math::Symbol.new("-"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Symbol.new("&#x3b2;"),
              Plurimath::Math::Function::Text.new("kl")
            ),
            Plurimath::Math::Symbol.new("&#x394;"),
            Plurimath::Math::Function::Text.new("M")
          ]),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("and"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::Text.new("j"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("3"),
        ])
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\Delta \\sigma_{ij} =  \\sum_{k=1}^{3} \\sum_{l=1}^{3} d_{ijkl} \\Delta \\varepsilon_{kl} -
          \\alpha_{kl}\\Delta T - \\beta_{kl}\\Delta M  \\;
          \\rm{for} \\; i = 1,3 \\; \\rm{and} \\; j = 1,3
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #20" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                  Plurimath::Math::Symbol.new("&#x3bd;"),
                ]),
              ]),
            ),
            "displaystyle",
          )
        ])
      }
      it "returns formula" do
        expected_value = "G=\\displaystyle{\\frac{E}{21+\\nu}}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #21" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
            \\left(
              \\begin{array}{cccccc}
                \\displaystyle{\\frac{1}{E_{11}}} &
                -\\displaystyle{\\frac{\\nu_{12}}{E_{22}}} &
                -\\displaystyle{\\frac{\\nu_{13}}{E_{33}}} &
                \\displaystyle{\\frac{\\nu_{1,12}}{G_{12}}} &
                0 &
                0 \\\\3mm &
                \\displaystyle{\\frac{1}{E_{22}}} &
                -\\displaystyle{\\frac{\\nu_{23}}{E_{22}}} &
                \\displaystyle{\\frac{\\nu_{2,12}}{G_{12}}} &
                0 &
                0 \\\\3mm & &
                \\displaystyle{\\frac{1}{E_{33}}} &
                \\displaystyle{\\frac{\\nu_{3,12}}{G_{12}}} &
                0 &
                0 \\\\3mm & & &
                \\displaystyle{\\frac{1}{G_{12}}} &
                0 &
                0 \\\\3mm &
                \\mbox{symmetric} & & &
                \\displaystyle{\\frac{1}{G_{23}}} &
                \\displaystyle{\\frac{\\nu_{23,31}}{G_{31}}} \\\\
                3mm & & & & &
                \\displaystyle{\\frac{1}{G_{31}}}
              \\end{array}
            \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #22" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
                    Plurimath::Math::Function::Text.new("symmetric")
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\left(
            \\begin{array}{cccccc}
              \\displaystyle{\\frac{1}{E_{11}}} &
              -\\displaystyle{\\frac{\\nu_{12}}{E_{22}}} &
              -\\displaystyle{\\frac{\\nu_{13}}{E_{33}}} &
              0 &
              0 &
              0 \\\\
              3mm &
              \\displaystyle{\\frac{1}{E_{22}}} &
              -\\displaystyle{\\frac{\\nu_{23}}{E_{33}}} &
              0 &
              0 &
              0 \\\\
              3mm & &
              \\displaystyle{\\frac{1}{E_{33}}} &
              0 &
              0 &
              0 \\\\
              3mm & & &
              \\displaystyle{\\frac{1}{G_{12}}} &
              0 &
              0 \\\\
              3mm &
              symmetric & & &
              \\displaystyle{\\frac{1}{G_{23}}} &
              0 \\\\
              3mm & & & & &
              \\displaystyle{\\frac{1}{G_{31}}}
            \\end{array}
          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #23" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                    Plurimath::Math::Symbol.new("&#x3bd;"),
                    Plurimath::Math::Function::Text.new("tt")
                  )
                ])
              ])
            ),
            "displaystyle"
          )
        ])
      }
      it "returns formula" do
        expected_value = "G_{tt}=\\displaystyle{\\frac{E_{tt}}{21+\\nu_{tt}}}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #24" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\left(
            \\begin{array}{cccccc}
              \\displaystyle{\\frac{1}{E_{ll}}} &
              -\\displaystyle{\\frac{\\nu_{tl}}{E_{tt}}} &
              -\\displaystyle{\\frac{\\nu_{tl}}{E_{tt}}} &
              0 &
              0 &
              0 \\\\
              3mm &
              \\displaystyle{\\frac{1}{E_{tt}}} &
              -\\displaystyle{\\frac{\\nu_{tt}}{E_{tt}}} &
              0 &
              0 &
              0 \\\\
              3mm & &
              \\displaystyle{\\frac{1}{E_{tt}}} &
              0 &
              0 &
              0 \\\\
              3mm & & &
              \\displaystyle{\\frac{1}{G_{lt}}} &
              0 &
              0 \\\\
              3mm &
              \\mbox{symmetric} & & &
              \\displaystyle{\\frac{1}{G_{tt}}} &
              0 \\\\
              3mm & & & & &
              \\displaystyle{\\frac{1}{G_{lt}}}
            \\end{array}
          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #25" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
                          Plurimath::Math::Symbol.new("&#x3bd;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\left(
            \\begin{array}{cccccc}
              \\displaystyle{\\frac{1}{E_{ll}}} &
              -\\displaystyle{\\frac{\\nu_{tl}}{E_{tt}}} &
              -\\displaystyle{\\frac{\\nu_{tl}}{E_{tt}}} &
              0 &
              0 &
              0 \\\\
              3mm &
              \\displaystyle{\\frac{1}{E_{tt}}} &
              -\\displaystyle{\\frac{\\nu_{tt}}{E_{tt}}} &
              0 &
              0 &
              0 \\\\
              3mm & &
              \\displaystyle{\\frac{1}{E_{tt}}} &
              0 &
              0 &
              0 \\\\
              3mm & & &
              \\displaystyle{\\frac{1}{G_{lt}}} &
              0 &
              0 \\\\
              3mm &
              \\mbox{symmetric} & & &
              \\displaystyle{\\frac{1}{G_{tt}}} &
              0 \\\\
              3mm & & & & &
              \\displaystyle{\\frac{1}{G_{lt}}}
            \\end{array}
          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #26" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                        Plurimath::Math::Symbol.new("&#x3bd;"),
                        Plurimath::Math::Function::Text.new("E")
                      ),
                      "displaystyle"
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Frac.new(
                        Plurimath::Math::Symbol.new("&#x3bd;"),
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
                        Plurimath::Math::Symbol.new("&#x3bd;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\left(
            \\begin{array}{cccccc}
              \\displaystyle{\\frac{1}{E}} &
              -\\displaystyle{\\frac{\\nu}{E}} &
              -\\displaystyle{\\frac{\\nu}{E}} &
              0 &
              0 &
              0 \\\\
              3mm &
              \\displaystyle{\\frac{1}{E}} &
              -\\displaystyle{\\frac{\\nu}{E}} &
              0 &
              0 &
              0 \\\\3mm & &
              \\displaystyle{\\frac{1}{E}} &
              0 &
              0 &
              0 \\\\
              3mm & & &
              \\displaystyle{\\frac{1}{G}} &
              0 &
              0 \\\\
              3mm &
              \\mbox{symmetric} & & &
              \\displaystyle{\\frac{1}{G}} &
              0 \\\\
              3mm & & & & &
              \\displaystyle{\\frac{1}{G}}
            \\end{array}
          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #27" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03b5;"),
                      Plurimath::Math::Number.new("11")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03b5;"),
                      Plurimath::Math::Number.new("22")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03b5;"),
                      Plurimath::Math::Number.new("33")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("2"),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03b5;"),
                      Plurimath::Math::Number.new("12")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("2"),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03b5;"),
                      Plurimath::Math::Number.new("23")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Symbol.new("&#x03b5;"),
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
      }
      it "returns formula" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #28" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("6")
        ])
      }
      it "returns formula" do
        expected_value = "S_{i}=\\sum_{j=1}^{6}D_{ij}E_{j}-E_{j}^{T}-E_{j}^{M}\\;\\rm{for}\\;i=1,6"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #29" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #30" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "\\left(\\begin{array}{c}s_{11} \\\\s_{22} \\\\s_{33} \\\\s_{12} \\\\s_{23} \\\\s_{31}\\end{array}\\right)"
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #31" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("and"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::Text.new("j"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("3")
        ])
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          s_{ij} =  \\sum_{k=1}^{3} \\sum_{l=1}^{3} d_{ijkl} e_{kl} \\;
          \\rm{for} \\; i = 1,3 \\; \\rm{and} \\; j = 1,3
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #32" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("for"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("and"),
            "rm"
          ),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::Text.new("j"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new(","),
          Plurimath::Math::Number.new("2")
        ])
      }
      it "returns formula" do
        expected_value = "s_{ij}=\\sum_{k=1}^{2}\\sum_{l=1}^{2}d_{ijkl}e_{kl}\\;\\rm{for}\\;i=1,2\\;\\rm{and}\\;j=1,2"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #33" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "\\left(\\begin{array}{ccc}s_{11}&0&0\\\\0&s_{22}&0\\\\0&0&s_{33}\\end{array}\\right)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #34" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Symbol.new("&#x3c1;"),
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("w"),
              Plurimath::Math::Symbol.new("'"),
              Plurimath::Math::Function::Text.new("w"),
              Plurimath::Math::Symbol.new("'")
            ])
          )
        ])
      }
      it "returns formula" do
        expected_value = "-\\rho\\bar{w'w'}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #35" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2")
            ])
          ),
          Plurimath::Math::Symbol.new("&#x3c1;"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("q"),
            Plurimath::Math::Number.new("2")
          )
        ])
      }
      it "returns formula" do
        expected_value = "{1\\over2}\\rhoq^{2}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #36" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Tilde.new(
                    Plurimath::Math::Symbol.new("&#x3c1;"),
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Symbol.new("&#x3c1;"),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3c1;"),
                    Plurimath::Math::Symbol.new("&#x221e;")
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
                    Plurimath::Math::Symbol.new("&#x221e;")
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
                      Plurimath::Math::Symbol.new("&#x3c1;"),
                      Plurimath::Math::Symbol.new("&#x221e;")
                    ),
                    Plurimath::Math::Function::PowerBase.new(
                      Plurimath::Math::Function::Text.new("c"),
                      Plurimath::Math::Symbol.new("&#x221e;"),
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
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new(","),
                  Plurimath::Math::Symbol.new("&#x2001;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Tilde.new(
                    Plurimath::Math::Symbol.new("&#x3bc;"),
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Symbol.new("&#x3bc;"),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3bc;"),
                    Plurimath::Math::Symbol.new("&#x221e;")
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\begin{array}{ccc}
            \\tilde{x} = x/L, &  \\tilde{u} = u/c_{\\infty}, & \\tilde{\\rho} = \\rho/\\rho_{\\infty}, \\\\
            \\tilde{y} = y/L, & \\tilde{v} = v/c_{\\infty}, &  \\tilde{p} = p/\\rho_{\\infty} c_{\\infty}^{2}, \\\\
            \\tilde{z} = z/L, \\quad & \\tilde{w} = w/c_{\\infty}, \\quad & \\tilde{\\mu} = \\mu/\\mu_{\\infty},
          \\end{array}
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #37" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3c1;"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x3c1;"),
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
          Plurimath::Math::Symbol.new("&#x3bc;"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x3bc;"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("M"),
            Plurimath::Math::Symbol.new("/"),
            Plurimath::Math::Function::Text.new("LT")
          ]),
          Plurimath::Math::Symbol.new(",")
        ])
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          x' = x/L, & u' = u/L/T, & \\rho' = \\rho/M/L^{3}, \\\\
          y' = y/L, & v' = v/L/T, & p' = p/M/L T^{2}, \\\\
          z' = z/L, \\quad & w' = w/L/T, \\quad & \\mu' = \\mu/M/L T,
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #38" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                  Plurimath::Math::Symbol.new("&#x3c1;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("'"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3c1;"),
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
                  Plurimath::Math::Symbol.new("&#x3bc;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("'"),
                    Plurimath::Math::Function::FontStyle.new(
                      Plurimath::Math::Function::Text.new("ref"),
                      "textrm"
                    )
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3bc;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\begin{array}{ccc}
            x'_{\\textrm{ref}} = x_{\\textrm{ref}}/L, & u'_{\\textrm{ref}} = u_{\\textrm{ref}}/L/T, & \\rho'_{\\textrm{ref}} = \\rho_{\\textrm{ref}}/M/L^{3}, \\\\
            y'_{\\textrm{ref}} = y_{\\textrm{ref}}/L, &  v'_{\\textrm{ref}} = v_{\\textrm{ref}}/L/T, & p'_{\\textrm{ref}} = p_{\\textrm{ref}}/M/L T^{2} \\\\
            z'_{\\textrm{ref}} = z_{\\textrm{ref}}/L, \\quad & w'_{\\textrm{ref}} = w_{\\textrm{ref}}/L/T, \\quad & \\mu'_{\\textrm{ref}} = \\mu_{\\textrm{ref}}/M/L T.
          \\end{array}
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #39" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                      Plurimath::Math::Symbol.new("&#x3c1;"),
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
                        Plurimath::Math::Symbol.new("&#x3c1;"),
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
                    Plurimath::Math::Symbol.new("&#x3c1;"),
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
            nil,
            [],
          )
        ])
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\begin{split}
            p''_{ijk} &\\equiv p_{ijk} / \\rho_{\\textrm{ref}} c_{\\textrm{ref}}^{2}.02in \\\\ \\\\
            \\displaystyle{&}= {p_{ijk} \\over M/L T^{2}} {M/L^{3} \\over \\rho_{\\textrm{ref}}} {\\left[{L/T \\over c_{\\textrm{ref}}}\\right]}^{2} \\\\ \\\\
            \\displaystyle{&}= p'_{ijk} / \\rho'_{\\textrm{ref}} {c'_{\\textrm{ref}}}^{2}
          \\end{split}
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #40" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Symbol.new("&#x3c1;")
                    ),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3c1;"),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3c1;"),
                    Plurimath::Math::Symbol.new("&#x221e;")
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
                    Plurimath::Math::Symbol.new("&#x221e;")
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
                      Plurimath::Math::Symbol.new("&#x3c1;"),
                      Plurimath::Math::Symbol.new("&#x221e;")
                    ),
                    Plurimath::Math::Function::PowerBase.new(
                      Plurimath::Math::Function::Text.new("c"),
                      Plurimath::Math::Symbol.new("&#x221e;"),
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
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Tilde.new(
                        Plurimath::Math::Symbol.new("&#x3bc;")
                      )
                    ),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3bc;"),
                    Plurimath::Math::Function::Text.new("ijk")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3c1;"),
                      Plurimath::Math::Symbol.new("&#x221e;")
                    ),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("c"),
                      Plurimath::Math::Symbol.new("&#x221e;")
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\begin{array}{ccc}
            \\tilde{x}_{ijk} = x_{ijk}/L, & \\tilde{u}_{ijk} = u_{ijk}/c_{\\infty}, & \\tilde{\\rho}_{ijk} = \\rho_{ijk}/\\rho_{\\infty}, \\\\
            \\tilde{y}_{ijk} = y_{ijk}/L, & \\tilde{v}_{ijk} = v_{ijk}/c_{\\infty}, & \\tilde{p}_{ijk} = p_{ijk}/\\rho_{\\infty} c_{\\infty}^{2},.02in \\\\
            \\tilde{z}_{ijk} = z_{ijk}/L, & \\tilde{w}_{ijk} = w_{ijk}/c_{\\infty}, & \\tilde{\\tilde{\\mu}}_{ijk} = \\mu_{ijk} / \\rho_{\\infty} c_{\\infty} L,
          \\end{array}
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #41" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Text.new("u")
                    ),
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("u"),
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("c"),
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new(","),
                  Plurimath::Math::Symbol.new("&#x2001;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Symbol.new("&#x3c1;")
                    ),
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3c1;"),
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3c1;"),
                    Plurimath::Math::Symbol.new("&#x221e;")
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
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("v"),
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("c"),
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Text.new("p")
                    ),
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("p"),
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3c1;"),
                      Plurimath::Math::Symbol.new("&#x221e;")
                    ),
                    Plurimath::Math::Function::PowerBase.new(
                      Plurimath::Math::Function::Text.new("c"),
                      Plurimath::Math::Symbol.new("&#x221e;"),
                      Plurimath::Math::Number.new("2"),
                    )
                  ]),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Number.new("1"),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Symbol.new("&#x3b3;"),
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
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("w"),
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Text.new("c"),
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new(",")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Tilde.new(
                      Plurimath::Math::Function::Tilde.new(
                        Plurimath::Math::Symbol.new("&#x3bc;")
                      )
                    ),
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new("="),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("&#x3bc;"),
                    Plurimath::Math::Symbol.new("&#x221e;")
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3c1;"),
                      Plurimath::Math::Symbol.new("&#x221e;")
                    ),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("c"),
                      Plurimath::Math::Symbol.new("&#x221e;")
                    ),
                    Plurimath::Math::Function::Text.new("L")
                  ]),
                  Plurimath::Math::Symbol.new("&#x223c;"),
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
            [
              Plurimath::Math::Function::Text.new("cc")
            ],
          )
        ])
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\begin{array}{cc}
            \\tilde{u}_{\\infty} = u_{\\infty}/c_{\\infty}, \\quad & \\tilde{\\rho}_{\\infty} = \\rho_{\\infty}/\\rho_{\\infty} = 1, \\\\
            \\tilde{v}_{\\infty} = v_{\\infty}/c_{\\infty}, & \\tilde{p}_{\\infty} = p_{\\infty}/\\rho_{\\infty} c_{\\infty}^{2} = 1/\\gamma,.02in \\\\
            \\tilde{w}_{\\infty} = w_{\\infty}/c_{\\infty}, & \\tilde{\\tilde{\\mu}}_{\\infty} = \\mu_{\\infty} / \\rho_{\\infty} c_{\\infty} L \\sim O1/Re,
          \\end{array}
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #42" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                Plurimath::Math::Symbol.new("&#x3c1;"),
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
      }
      it "returns formula" do
        expected_value = "c_{p}={p-p_{\\textrm{ref}}\\over{1\\over2}\\rho_{\\textrm{ref}}q_{\\textrm{ref}}^{2}},"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #43" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                Plurimath::Math::Symbol.new("&#x3c4;")
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
                Plurimath::Math::Symbol.new("&#x3c1;"),
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
      }
      it "returns formula" do
        expected_value = "\\vec{c}_{f}={\\vec{\\tau}\\over{1\\over2}\\rho_{\\textrm{ref}}q_{\\textrm{ref}}^{2}},"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #44" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "{1\\over2}u^{2}+v^{2}+w^{2}={1\\over2}q^{2}"
        expect(formula).to eq(expected_value)
      end
    end
    # structural_response_representation_schema_annotated => 54

    context "contains latex equation #45" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("T"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("G"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Text.new("J"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Symbol.new("&#x3b8;")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Function::Text.new("x")
            ])
          ),
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Function::Text.new("E"),
          Plurimath::Math::Symbol.new("&#x3a;"),
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
            Plurimath::Math::Symbol.new("&#x3a;"),
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("&#x2202;"),
                Plurimath::Math::Symbol.new("&#x3b8;")
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("&#x2202;"),
                Plurimath::Math::Function::Text.new("x")
              ])
            )
          ])
        ])
      }
      it "returns formula" do
        expected_value = "T=G\\:J\\:\\frac{\\partial\\theta}{\\partialx}-E\\:\\frac{\\partial^{2}}{\\partialx^{2}}C_{w}\\:\\frac{\\partial\\theta}{\\partialx}"
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #46" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x394;"),
              Plurimath::Math::Symbol.new("&#x3b8;")
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
              Plurimath::Math::Symbol.new("&#x3a;"),
              Plurimath::Math::Function::Text.new("G")
            ])
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\frac{\\Delta\\theta}{\\DeltaL}=\\frac{T}{J\\:G}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #47" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("V"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Text.new("k"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("d"),
            Plurimath::Math::Number.new("2")
          )
        ])
      }
      it "returns formula" do
        expected_value = "V=\\frac{1}{2}\\:k\\:d^{2}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #48" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("D"),
            Plurimath::Math::Function::Text.new("s")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("G"),
          Plurimath::Math::Symbol.new("&#x3a;"),
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
      }
      it "returns formula" do
        expected_value = "D_{s}=G\\:\\left(\\begin{array}{cc}1&0\\\\0&1\\end{array}\\right)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #49" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("D"),
            Plurimath::Math::Function::Text.new("s")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03b5;"),
                      Plurimath::Math::Function::Text.new("xz")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03b5;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\left(
            \\begin{array}{c}
              V_{x}  \\\\
              V_{y}
            \\end{array}
          \\right) = h_{s} \\: D_{s} \\:  \\left(
                                            \\begin{array}{c}
                                              \\varepsilon_{xz} \\\\
                                              \\varepsilon_{yz}
                                            \\end{array}
                                          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #50" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                    Plurimath::Math::Symbol.new("&#x2c;"),
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
                    Plurimath::Math::Symbol.new("&#x2c;"),
                    Plurimath::Math::Function::Text.new("p"),
                    Plurimath::Math::Symbol.new("&#x2c;"),
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
                    Plurimath::Math::Symbol.new("&#x2c;"),
                    Plurimath::Math::Function::Text.new("p"),
                    Plurimath::Math::Symbol.new("&#x2c;"),
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
                          Plurimath::Math::Symbol.new("&#x2c;"),
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Function::Text.new("p"),
                            Plurimath::Math::Number.new("2")
                          )
                        ]),
                        "displaystyle"
                      ),
                      Plurimath::Math::Symbol.new("&#x2c;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          D' =  \\left(
                  \\begin{array} {cc}
                    h_{m} \\, D_{mm} &
                    h_{b} \\, p \\, D_{mc} \\\\
                    2mm h_{b} \\, p \\, D_{mc} &
                    \\displaystyle{\\frac{1}{12} h_{b}^{3} + h_{b} \\, p^{2}} \\, D_{mb}
                  \\end{array}
                \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #51" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                Plurimath::Math::Symbol.new("&#x3bd;"),
                Plurimath::Math::Number.new("2")
              )
            ])
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("1")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Symbol.new("&#x3bd;")
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
                    Plurimath::Math::Symbol.new("&#x3bd;")
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
                          Plurimath::Math::Symbol.new("&#x3bd;")
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          D_{m} = \\frac{E}{1 - \\nu^{2}} \\:
          \\left(
            \\begin{array}{ccc}
              1 &
              \\nu &
              0 \\\\
              2mm \\nu &
              1 &
              0 \\\\
              2mm 0 &
              0 &
              \\displaystyle{\\frac{1 - \\nu}{2} }
            \\end{array}
          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #52" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                    Plurimath::Math::Symbol.new("&#x2c;"),
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Text.new("D"),
                      Plurimath::Math::Function::Text.new("m")
                    )
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("h"),
                    Plurimath::Math::Symbol.new("&#x2c;"),
                    Plurimath::Math::Function::Text.new("p"),
                    Plurimath::Math::Symbol.new("&#x2c;"),
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
                    Plurimath::Math::Symbol.new("&#x2c;"),
                    Plurimath::Math::Function::Text.new("p"),
                    Plurimath::Math::Symbol.new("&#x2c;"),
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
                          Plurimath::Math::Symbol.new("&#x2c;"),
                          Plurimath::Math::Function::Power.new(
                            Plurimath::Math::Function::Text.new("p"),
                            Plurimath::Math::Number.new("2")
                          )
                        ]),
                        "displaystyle"
                      ),
                      Plurimath::Math::Symbol.new("&#x2c;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          D' =  \\left(
                  \\begin{array}{cc}
                    h \\, D_{m} &
                    h \\, p \\, D_{m} \\\\
                    2mm h \\, p \\, D_{m} &
                    \\displaystyle{\\frac{1}{12} h^{3} + h \\, p^{2}} \\, D_{m}
                  \\end{array}
                \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #53" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03b5;"),
                      Plurimath::Math::Function::Text.new("xx")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x03b5;"),
                      Plurimath::Math::Function::Text.new("yy")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3b3;"),
                      Plurimath::Math::Function::Text.new("xy")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3c7;"),
                      Plurimath::Math::Function::Text.new("xx")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3c7;"),
                      Plurimath::Math::Function::Text.new("yy")
                    )
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbol.new("&#x3c4;"),
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
      }
      it "returns formula" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #54" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "\\left(\\begin{array}{c}N_{yy}\\\\N_{xx}\\\\N_{xy}\\\\M_{xx}\\\\M_{yy}\\\\M_{xy}\\end{array}\\right)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #55" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3c3;"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Symbol.new("&#x03b5;"),
          Plurimath::Math::Symbol.new("'")
        ])
      }
      it "returns formula" do
        expected_value = "\\sigma'=D'\\:\\varepsilon'"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #56" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x03b5;"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("B"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("u"),
            "bf"
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\varepsilon'=B'\\:\\bf{u}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #57" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("V"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::FontStyle.new(
                Plurimath::Math::Function::Text.new("u"),
                "bf"
              )
            ]),
            Plurimath::Math::Function::Text.new("t")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x222b;"),
            Plurimath::Math::Function::Text.new("surface")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("B"),
              Plurimath::Math::Symbol.new("'")
            ]),
            Plurimath::Math::Function::Text.new("t")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Text.new("B"),
          Plurimath::Math::Symbol.new("'"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Text.new("ds"),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("u"),
            "bf"
          )
        ])
      }
      it "returns formula" do
        expected_value = "V=\\frac{1}{2}\\:{\\bf{u}}^{t}\\:\\int_{surface}\\:{B'}^{t}\\:D'\\:B'\\:ds\\;\\bf{u}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #58" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3c3;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Symbol.new("&#x03b5;")
        ])
      }
      it "returns formula" do
        expected_value = "\\sigma=D\\:\\varepsilon"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #59" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x03b5;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("B"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("u"),
            "bf"
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\varepsilon=B\\:\\bf{u}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #60" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("V"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::FontStyle.new(
                Plurimath::Math::Function::Text.new("u"),
                "bf"
              )
            ]),
            Plurimath::Math::Function::Text.new("t")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x222b;"),
            Plurimath::Math::Function::Text.new("surface")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x222b;"),
            Plurimath::Math::Function::Text.new("thickness")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("B"),
            Plurimath::Math::Function::Text.new("t")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Text.new("D"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Text.new("B"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Text.new("dt"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Text.new("ds"),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("u"),
            "bf"
          )
        ])
      }
      it "returns formula" do
        expected_value = "V=\\frac{1}{2}\\:{\\bf{u}}^{t}\\:\\int_{surface}\\:\\int_{thickness}\\:B^{t}\\:D\\:B\\:dt\\:ds\\;\\bf{u}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #61" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\left(
            \\begin{array}{c}
              \\displaystyle{\\frac{\\partial w}{\\partial x}} + \\frac{\\partial u} {\\partial z} \\\\
              3mm \\displaystyle{\\frac{\\partial w}{\\partial y}} + \\frac{\\partial v}{\\partial z}
            \\end{array}
          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #62" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03b5;"),
            Plurimath::Math::Function::Text.new("j")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\DeltaF_{i}=\\sum_{j=1}^{2}s_{ij}\\:\\Delta\\varepsilon_{j}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #63" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Function::Text.new("kl")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\DeltaN_{ij}=\\sum_{k=1}^{2}\\sum_{l=1}^{2}d_{ijkl}\\:\\Deltac_{kl}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #64" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\left(
            \\begin{array}{cc}
              \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x^{2}}   &
              \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x \\partial y}   \\\\3mm
              \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x \\partial y}    &
              \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial y^{2}}
            \\end{array}
          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #65" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Function::Text.new("kl")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\DeltaD_{ij}=\\sum_{k=1}^{2}\\sum_{l=1}^{2}d_{ijkl}\\:\\Deltac_{kl}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #66" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          J = \\left(
                \\begin{array}{cc}
                  \\displaystyle{\\frac{\\partial u}{\\partial x}} &
                  \\displaystyle{\\frac{\\partial v}{\\partial x}} \\\\
                  3mm \\displaystyle{\\frac{\\partial u}{\\partial y}} &
                  \\displaystyle{\\frac{\\partial v}{\\partial y}}
                \\end{array}
              \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #67" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x03b5;"),
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
      }
      it "returns formula" do
        expected_value = "\\varepsilon=\\frac{1}{2}J+J^{t}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #68" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03b5;"),
            Plurimath::Math::Function::Text.new("kl")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\DeltaN_{ij}=\\sum_{k=1}^{2}\\sum_{l=1}^{2}d_{ijkl}\\:\\Delta\\varepsilon_{kl}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #69" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03b5;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3b2;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Function::Text.new("M"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Text.new("M")
        ])
      }
      it "returns formula" do
        expected_value = "\\Delta\\varepsilon_{ij}=\\beta_{ij}M\\:\\DeltaM"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #70" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03b5;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3b1;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("T"),
            Plurimath::Math::Symbol.new("&#x3a;"),
            Plurimath::Math::Symbol.new("-"),
            Plurimath::Math::Symbol.new("&#x3a;"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Text.new("T"),
              Plurimath::Math::Function::Text.new("o")
            )
          ])
        ])
      }
      it "returns formula" do
        expected_value = "\\varepsilon_{ij}=\\alpha_{ij}\\:T\\:-\\:T_{o}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #71" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03b5;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3b1;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Function::Text.new("T"),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Text.new("T")
        ])
      }
      it "returns formula" do
        expected_value = "\\Delta\\varepsilon_{ij}=\\alpha_{ij}T\\:\\DeltaT"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #72" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3c3;"),
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
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03b5;"),
            Plurimath::Math::Function::Text.new("kl")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\Delta\\sigma_{ij}=\\sum_{k=1}^{3}\\sum_{l=1}^{3}d_{ijkl}\\:\\Delta\\varepsilon_{kl}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #73" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("ji")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("w"),
            Plurimath::Math::Function::Text.new("j"),
            Plurimath::Math::Function::Text.new("s"),
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("q"),
            Plurimath::Math::Function::Text.new("ji")
          )
        ])
      }
      it "returns formula" do
        expected_value = "Q_{i}^{s}=\\sum_{j=1}^{m}\\:s_{ji}\\:w_{j}^{s}\\:q_{ji}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #74" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("j"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("w"),
            Plurimath::Math::Function::Text.new("i"),
            Plurimath::Math::Function::Text.new("f"),
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("Q"),
            Plurimath::Math::Function::Text.new("i"),
            Plurimath::Math::Function::Text.new("s"),
          )
        ])
      }
      it "returns formula" do
        expected_value = "Q=\\sum_{i=1}^{n}\\:j_{i}\\:w_{i}^{f}\\:Q_{i}^{s}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #75" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("w"),
            Plurimath::Math::Function::Text.new("j"),
            Plurimath::Math::Function::Text.new("s"),
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("q"),
            Plurimath::Math::Function::Text.new("ji")
          )
        ])
      }
      it "returns formula" do
        expected_value = "Q_{i}^{s}=\\sum_{j=1}^{m}\\:w_{j}^{s}\\:q_{ji}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #76" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("w"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("q"),
            Plurimath::Math::Function::Text.new("i")
          )
        ])
      }
      it "returns formula" do
        expected_value = "Q=\\sum_{i=1}^{n}\\:s_{i}\\:w_{i}\\:q_{i}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #77" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("j"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("w"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("q"),
            Plurimath::Math::Function::Text.new("i")
          )
        ])
      }
      it "returns formula" do
        expected_value = "Q=\\sum_{i=1}^{n}\\:s_{i}\\:j_{i}\\:w_{i}\\:q_{i}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #78" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("j"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("w"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("q"),
            Plurimath::Math::Function::Text.new("i")
          )
        ])
      }
      it "returns formula" do
        expected_value = "Q=\\sum_{i=1}^{n}\\:j_{i}\\:w_{i}\\:q_{i}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #79" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("y"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("d"),
            "bf"
          ),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("tolerance"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x2c;"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("y"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Symbol.new("&#x2c;"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("d"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("|")
        ])
      }
      it "returns formula" do
        expected_value = "\\bf{y}\\cdot\\bf{d}>\\bf{tolerance}\\,|\\bf{y}|\\,|\\bf{d}|"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #80" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("z"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x27e8;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("x"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#xd7;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("d"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x27e9;")
        ])
      }
      it "returns formula" do
        expected_value = "\\bf{z}=\\langle\\bf{x}\\times\\bf{d}\\rangle"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #81" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("x"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("X"),
            "bf"
          ),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("tolerance"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x2c;"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("x"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Symbol.new("&#x2c;"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Text.new("X"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("|")
        ])
      }
      it "returns formula" do
        expected_value = "\\bf{x}\\cdot\\bf{X}>\\bf{tolerance}\\,|\\bf{x}|\\,|\\bf{X}|"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #82" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("z"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("<"),
          Plurimath::Math::Symbol.new("<"),
          Plurimath::Math::Function::Text.new("xxxY"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Symbol.new(">")
        ])
      }
      it "returns formula" do
        expected_value = "z=<<xxxY>>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #83" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Function::Text.new("X"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Number.new("0")
        ])
      }
      it "returns formula" do
        expected_value = "x*X>0"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #84" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Function::Text.new("X"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Number.new("0")
        ])
      }
      it "returns formula" do
        expected_value = "x*X>0"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #85" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Function::Text.new("X"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Number.new("0")
        ])
      }
      it "returns formula" do
        expected_value = "x*X>0"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #86" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "d*x>\"tolerance\"|d||x|"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #87" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("z"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Function::Text.new("d"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Number.new("0")
        ])
      }
      it "returns formula" do
        expected_value = "z*d>0"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #88" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "z*Z>\"tolerance\"|z||Z|"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #89" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("y"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("<"),
          Plurimath::Math::Symbol.new("<"),
          Plurimath::Math::Function::Text.new("zxxX"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Symbol.new(">")
        ])
      }
      it "returns formula" do
        expected_value = "y=<<zxxX>>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #90" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("z"),
          Plurimath::Math::Symbol.new("*"),
          Plurimath::Math::Function::Text.new("Z"),
          Plurimath::Math::Symbol.new(">"),
          Plurimath::Math::Number.new("0")
        ])
      }
      it "returns formula" do
        expected_value = "z*Z>0"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #91" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Symbol.new("&#x2032;")
            ),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x27e8;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3b7;"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#xd7;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3b6;"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x27e9;")
        ])
      }
      it "returns formula" do
        expected_value = "\\bf{x^{\\prime}}=\\langle\\bf{\\eta}\\times\\bf{\\zeta}\\rangle"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #92" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("z"),
              Plurimath::Math::Symbol.new("&#x2032;")
            ),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3b6;"),
            "bf"
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\bf{z^{\\prime}}=\\bf{\\zeta}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #93" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("z"),
              Plurimath::Math::Symbol.new("&#x2032;")
            ),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x27e8;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3be;"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#xd7;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3b7;"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x27e9;")
        ])
      }
      it "returns formula" do
        expected_value = "\\bf{z^{\\prime}}=\\langle\\bf{\\xi}\\times\\bf{\\eta}\\rangle"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #94" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("y"),
              Plurimath::Math::Symbol.new("&#x2032;")
            ),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3b7;"),
            "bf"
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\bf{y^{\\prime}}=\\bf{\\eta}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #95" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("y"),
              Plurimath::Math::Symbol.new("&#x2032;")
            ),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x27e8;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3b6;"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#xd7;"),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3be;"),
            "bf"
          ),
          Plurimath::Math::Symbol.new("&#x27e9;")
        ])
      }
      it "returns formula" do
        expected_value = "\\bf{y^{\\prime}}=\\langle\\bf{\\zeta}\\times\\bf{\\xi}\\rangle"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #96" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Symbol.new("&#x2032;")
            ),
            "bf"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::FontStyle.new(
            Plurimath::Math::Symbol.new("&#x3be;"),
            "bf"
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\bf{x^{\\prime}}=\\bf{\\xi}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #97" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                          Plurimath::Math::Symbol.new("&#x22ef;")
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
                          Plurimath::Math::Symbol.new("&#x22ef;")
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
                          Plurimath::Math::Symbol.new("&#x22ee;")
                        ]),
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([]),
                        Plurimath::Math::Function::Td.new([
                          Plurimath::Math::Symbol.new("&#x22ee;")
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
      }
      it "returns formula" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #98" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #99" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #100" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
        }
      it "returns formula" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #101" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("bbf"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("Mbba")
        ])
      }
      it "returns formula" do
        expected_value = "bbf=Mbba"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #102" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("bbf"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("Dbbv")
        ])
      }
      it "returns formula" do
        expected_value = "bbf=Dbbv"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #103" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("bbf"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("Kbbd")
        ])
      }
      it "returns formula" do
        expected_value = "bbf=Kbbd"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #104" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "1,,,,,,2,,0,,,,,3,,,0,,ddots,,,,,,n"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #105" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "1,,,,,,\"symetric\",2,n+1,,,,,,3,n+2,2n,,,,,*,*,*,3n-2,,,,*,*,*,*,*,,,*,*,*,*,*,*,,n,2n-1,3n-3,*,*,*,nn+1//2"
        expect(formula).to eq(expected_value)
      end
    end
    # results_schema_annotated

    context "contains latex equation #106" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Tilde.new(
            Plurimath::Math::Function::Text.new("s"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Text.new("p"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("&#x3c1;"),
            Plurimath::Math::Symbol.new("&#x3b3;")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\tilde{s}=p/\\rho^{\\gamma}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #107" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "\\vec{q}=u\\hat{e}_{x}+v\\hat{e}_{y}+w\\hat{e}_{z}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #108" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("q"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sqrt.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Vec.new(
                Plurimath::Math::Function::Text.new("q")
              ),
              Plurimath::Math::Symbol.new("&#x22c5;"),
              Plurimath::Math::Function::Vec.new(
                Plurimath::Math::Function::Text.new("q")
              )
            ])
          )
        ])
      }
      it "returns formula" do
        expected_value = "q=\\sqrt{\\vec{q}\\cdot\\vec{q}}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #109" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3c1;"),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x3c1;"),
          Plurimath::Math::Function::Text.new("u"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("x")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("&#x3c1;"),
          Plurimath::Math::Function::Text.new("v"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("y")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("&#x3c1;"),
          Plurimath::Math::Function::Text.new("w"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("z")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\rho\\vec{q}=\\rhou\\hat{e}_{x}+\\rhov\\hat{e}_{y}+\\rhow\\hat{e}_{z}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #110" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3c1;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("e"),
            Plurimath::Math::Number.new("0")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\rhoe_{0}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #111" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3bc;")
        ])
      }
      it "returns formula" do
        expected_value = "\\mu"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #112" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3bd;")
        ])
      }
      it "returns formula" do
        expected_value = "\\nu"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #113" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Function::Bar.new(
              Plurimath::Math::Function::Text.new("S")
            ),
          ),
        ])
      }
      it "returns formula" do
        expected_value = "\\bar{\\bar{S}}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #114" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Function::Bar.new(
              Plurimath::Math::Symbol.new("&#x3c4;")
            )
          ),
        ])
      }
      it "returns formula" do
        expected_value = "\\bar{\\bar{\\tau}}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #115" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "x_{1},x_{2},x_{3}=x,y,z"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #116" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "u_{1},u_{2},u_{3}=u,v,w"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #117" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3bb;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("&#x3bc;")
        ])
      }
      it "returns formula" do
        expected_value = "\\lambda=-2/3\\mu"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #118" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Symbol.new("&#x3c1;"),
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("u"),
              Plurimath::Math::Symbol.new("'"),
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Symbol.new("'")
            ])
          )
        ])
      }
      it "returns formula" do
        expected_value = "-\\rho\\bar{u'e'}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #119" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
            Plurimath::Math::Symbol.new("&#x3bd;"),
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
      }
      it "returns formula" do
        expected_value = "\\bar{u'v'}=\\nu_{t}\\left(\\frac{\\partialu}{\\partialy}+\\frac{\\partialv}{\\partialx}\\right)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #120" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3bd;"),
            Plurimath::Math::Function::Text.new("t")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\nu_{t}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #121" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3f5;")
        ])
      }
      it "returns formula" do
        expected_value = "\\epsilon"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #122" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "k={1\\over2}\\bar{u'u'}+\\bar{v'v'}+\\bar{w'w'}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #123" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2207;"),
          Plurimath::Math::Symbol.new("&#x3d5;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\nabla\\phi=\\vec{q}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #124" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2207;"),
          Plurimath::Math::Symbol.new("&#xd7;"),
          Plurimath::Math::Symbol.new("&#x3c8;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\nabla\\times\\psi=\\vec{q}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #125" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3c1;"),
            Plurimath::Math::Number.new("0")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\rho_{0}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #126" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("u"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("x")
          )
        ])
      }
      it "returns formula" do
        expected_value = "u=\\vec{q}\\cdot\\hat{e}_{x}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #127" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("v"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("y")
          )
        ])
      }
      it "returns formula" do
        expected_value = "v=\\vec{q}\\cdot\\hat{e}_{y}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #128" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("w"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("z")
          )
        ])
      }
      it "returns formula" do
        expected_value = "w=\\vec{q}\\cdot\\hat{e}_{z}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #129" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Function::Text.new("r")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\vec{q}\\cdot\\hat{e}_{r}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #130" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3b8;")
        ])
      }
      it "returns formula" do
        expected_value = "\\theta"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #131" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Symbol.new("&#x3b8;")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\vec{q}\\cdot\\hat{e}_{\\theta}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #132" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3d5;")
        ])
      }
      it "returns formula" do
        expected_value = "\\phi"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #133" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::Text.new("e")
            ),
            Plurimath::Math::Symbol.new("&#x3d5;")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\vec{q}\\cdot\\hat{e}_{\\phi}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #134" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Function::Text.new("n")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\vec{q}\\cdot\\hat{n}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #135" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3c1;"),
          Plurimath::Math::Function::Text.new("u")
        ])
      }
      it "returns formula" do
        expected_value = "\\rhou"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #136" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Vec.new(
              Plurimath::Math::Function::Text.new("q")
            ),
            Plurimath::Math::Symbol.new("&#x22c5;"),
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
      }
      it "returns formula" do
        expected_value = "\\vec{q}\\cdot\\hat{e}_{x}/q"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #137" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Vec.new(
              Plurimath::Math::Function::Text.new("q")
            ),
            Plurimath::Math::Symbol.new("&#x22c5;"),
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
      }
      it "returns formula" do
        expected_value = "\\vec{q}\\cdot\\hat{e}_{y}/q"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #138" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Vec.new(
              Plurimath::Math::Function::Text.new("q")
            ),
            Plurimath::Math::Symbol.new("&#x22c5;"),
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
      }
      it "returns formula" do
        expected_value = "\\vec{q}\\cdot\\hat{e}_{z}/q"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #139" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3c1;"),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new("q")
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Function::Text.new("n")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\rho\\vec{q}\\cdot\\hat{n}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #140" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3bd;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("&#x3bc;"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Symbol.new("&#x3c1;")
        ])
      }
      it "returns formula" do
        expected_value = "\\nu=\\mu/\\rho"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #141" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value = "R=c_{p}-c_{v}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #142" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3c1;"),
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("u"),
              Plurimath::Math::Symbol.new("'"),
              Plurimath::Math::Function::Text.new("u"),
              Plurimath::Math::Symbol.new("'")
            ])
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\rho\\bar{u'u'}"
        expect(formula).to eq(expected_value)
      end
    end
    # domain_schema_annotated

    context "contains latex equation #143" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Pmatrix.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Hat.new(
                      Plurimath::Math::Function::Text.new("e")
                    ),
                    Plurimath::Math::Symbol.new("&#x3be;")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Hat.new(
                      Plurimath::Math::Function::Text.new("e")
                    ),
                    Plurimath::Math::Symbol.new("&#x3b7;")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Function::Hat.new(
                      Plurimath::Math::Function::Text.new("e")
                    ),
                    Plurimath::Math::Symbol.new("&#x3b6;")
                  )
                ])
              ])
            ],
            "(",
            [],
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
            [],
          ),
          Plurimath::Math::Symbol.new(",")
        ])
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\begin{pmatrix}
            \\hat{e}_{\\xi} \\\\ \\hat{e}_{\\eta} \\\\ \\hat{e}_{\\zeta}
          \\end{pmatrix}
          = \\bf{T}
          \\begin{pmatrix}
            \\hat{e}_{x} \\\\ \\hat{e}_{y} \\\\ \\hat{e}_{z}
          \\end{pmatrix},
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end
    # finite_element_analysis_control_and_result_schema_annotated

    context "contains latex equation #144" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x03b5;"),
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
      }
      it "returns formula" do
        expected_value = "\\varepsilon=\\frac{\\partialu}{\\partialx}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #145" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x3d5;"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Symbol.new("&#x3b8;")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Function::Text.new("x")
            ])
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\phi=\\frac{\\partial\\theta}{\\partialx}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #146" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Symbol.new("&#x3b8;")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x2202;"),
              Plurimath::Math::Function::Text.new("z")
            ])
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\frac{\\partial\\theta}{\\partialz}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #147" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3a;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          f =    {\\bf{F}}^{t}  \\:
          \\left(
            \\begin{array}{c}
              n_{y} \\\\
              n_{z}
            \\end{array}
          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #148" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
          Plurimath::Math::Symbol.new("&#x3a;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          m =    {\\bf{M}}^{t}  \\:
          \\left( \\begin{array}{c} n_{y} \\\\ n_{z} \\end{array} \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #149" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\bf{c} =  \\left(
                        \\begin{array}{c}
                          \\displaystyle{-}\\frac{\\partial^{2} v}{\\partial x^{2}} \\\\2mm
                          \\displaystyle{-}\\frac{\\partial^{2} w}{\\partial x^{2}}
                        \\end{array}
                      \\right)

        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #150" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                          Plurimath::Math::Symbol.new("&#x3b8;")
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
                          Plurimath::Math::Symbol.new("&#x3b8;")
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\left(
            \\begin{array}{c}
              \\displaystyle{\\frac{\\partial \\theta}{\\partial y}}   \\\\3mm
              \\displaystyle{\\frac{\\partial \\theta}{\\partial z}}
            \\end{array}
          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #151" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::FontStyle.new(
                Plurimath::Math::Function::Text.new("F"),
                "bf"
              )
            ]),
            Plurimath::Math::Function::Text.new("t")
          ),
          Plurimath::Math::Symbol.new("&#x3a;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          f =  {\\bf{F}}^{t}  \\:
          \\left(
            \\begin{array}{c}
              n_{x} \\\\
              n_{y}
            \\end{array}
          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #152" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x03b5;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\varepsilon =  \\left(
                            \\begin{array}{c}
                              \\displaystyle{\\frac{\\partial w}{\\partial x} } +
                              \\frac{\\partial u}{\\partial z}  \\\\
                              2mm \\displaystyle{\\frac{\\partial w}{\\partial y} } +
                              \\frac{\\partial v}{\\partial z}
                            \\end{array}
                          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #153" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x03b5;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\varepsilon =  \\left(
                            \\begin{array}{cc}
                              \\displaystyle{\\frac{\\partial u}{\\partial x} }  &
                              \\displaystyle{\\frac{\\partial u}{\\partial y} } \\\\ 2mm
                              \\displaystyle{\\frac{\\partial v}{\\partial x} }  &
                              \\displaystyle{\\frac{\\partial v}{\\partial y} }
                            \\end{array}
                          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #154" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          c = \\left(
                \\begin{array}{cc}
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x^{2}} &
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x \\partial y} \\\\
                  2mm\\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x \\partial y}  &
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial y^{2}}
                \\end{array}
              \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #155" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("&#x03b5;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\varepsilon_{ij}^{E} = 1/2
          \\left(
            \\frac{\\partial v_{i}}{\\partial x_{j}} +
            \\frac{\\partial v_{j}}{\\partial x_{i}}
          \\right)
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #156" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("&#x03b5;"),
            Plurimath::Math::Function::Text.new("ij"),
            Plurimath::Math::Function::Text.new("T"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3b1;"),
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
      }
      it "returns formula" do
        expected_value = "\\varepsilon_{ij}^{T}=\\alpha_{ij}T-T_{0}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #157" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03b5;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("&#x03b5;"),
            Plurimath::Math::Function::Text.new("ij"),
            Plurimath::Math::Function::Text.new("E"),
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("&#x03b5;"),
            Plurimath::Math::Function::Text.new("ij"),
            Plurimath::Math::Function::Text.new("T"),
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\varepsilon_{ij}=\\varepsilon_{ij}^{E}+\\varepsilon_{ij}^{T}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #158" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
            Plurimath::Math::Symbol.new("&#x3c3;"),
            Plurimath::Math::Function::Text.new("ij")
          ),
          Plurimath::Math::Symbol.new("&#x394;"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x03b5;"),
            Plurimath::Math::Function::Text.new("ij")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\Deltav=\\sum_{i}\\sum_{j}\\sigma_{ij}\\Delta\\varepsilon_{ij}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #159" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Function::Text.new("i")
          ),
          Plurimath::Math::Symbol.new("&#x22c5;"),
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
      }
      it "returns formula" do
        expected_value = "a_{i}\\cdotx_{i}=b_{i}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #160" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
              Plurimath::Math::Symbol.new("&#x22c5;"),
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
      }
      it "returns formula" do
        expected_value = "\\sum_{i=1}^{n}\\left(a_{i}\\cdotx_{i}\\right)=b"
        expect(formula).to eq(expected_value)
      end
    end
    # 07-conditions.adoc

    context "contains latex equation #161" do
      let(:exp) {
        Plurimath::Math::Formula.new([
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
                Plurimath::Math::Symbol.new("&#xb1;"),
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
              Plurimath::Math::Symbol.new("&#xb1;"),
              Plurimath::Math::Function::Over.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("2")
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("&#x3b3;"),
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
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          \\left[
            \\frac{\\partial}{\\partial t} + u \\pm c \\frac{\\partial}{\\partial x}
          \\right]
          \\left(
            u \\pm {2\\over\\gamma-1} c
          \\right) = 0.
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #162" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("vecqxxhats"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("0")
        ])
      }
      it "returns formula" do
        expected_value = "vecqxxhats=0"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #163" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Color.new(
            Plurimath::Math::Function::Text.new("blue"),
            Plurimath::Math::Function::Text.new("something")
          )
        ])
      }
      it "returns formula" do
        expected_value = "\\color{blue}something"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains latex equation #164" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("c"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("["),
            Plurimath::Math::Function::Table::Multline.new(
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
              [],
            ),
            Plurimath::Math::Function::Right.new("]")
          ])
        ])
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          c = \\left[
                \\begin{multline}
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x^{2}} &
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x \\partial y} \\\\
                  2mm\\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x \\partial y}  &
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial y^{2}}
                \\end{multline}
              \\right]
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #165" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("c"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("["),
            Plurimath::Math::Function::Table::Align.new(
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
              []
            ),
            Plurimath::Math::Function::Right.new("]")
          ])
        ])
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          c = \\left[
                \\begin{align}
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x^{2}} &
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x \\partial y} \\\\
                  2mm\\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x \\partial y}  &
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial y^{2}}
                \\end{align}
              \\right]
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #166" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("c"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("["),
            Plurimath::Math::Function::Table::Matrix.new(
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
              []
            ),
            Plurimath::Math::Function::Right.new("]")
          ])
        ])
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          c = \\left[
                \\begin{matrix}
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x^{2}} &
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x \\partial y} \\\\
                  2mm\\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x \\partial y}  &
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial y^{2}}
                \\end{matrix}
              \\right]
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #167" do
      let(:exp) {
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("c"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("["),
            Plurimath::Math::Function::Table::Vmatrix.new([
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
            ]),
            Plurimath::Math::Function::Right.new("]")
          ])
        ])
      }
      it "returns formula" do
        expected_value =
        <<~LATEX
          c = \\left[
                \\begin{vmatrix}
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x^{2}} &
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x \\partial y} \\\\
                  2mm\\displaystyle{-} \\frac{\\partial^{2} w}{\\partial x \\partial y}  &
                  \\displaystyle{-} \\frac{\\partial^{2} w}{\\partial y^{2}}
                \\end{vmatrix}
              \\right]
        LATEX
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains latex equation #168" do
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
      }
      it "returns formula" do
        expected_value = "a_{{\\begin{array}11\\end{array}}}^{4terms}"
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end
  end
end
