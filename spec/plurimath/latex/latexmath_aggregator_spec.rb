require "spec_helper"

RSpec.describe Plurimath::Latex::Parser do

  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    context "contains example #1" do
      let(:string) { "1 \\over 2" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #2" do
      let(:string) { "L' \\over {1\\over2}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Over.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("L"),
              Plurimath::Math::Symbols::Sprime.new
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Over.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("2")
                ])
              )
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #3" do
      let(:string) { "\\left\\{\\right." }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("{"),
            Plurimath::Math::Function::Right.new
          ]),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #4" do
      let(:string) { "\\begin{matrix}a & b \\\\ c & d \\end{matrix}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Matrix.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Symbol.new("a")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Symbol.new("b")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Symbol.new("c")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Symbol.new("d")
                ])
              ])
            ],
            nil,
            nil,
            {}
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #5" do
      let(:string) do
        <<~LATEX
          \\left\\{
            \\begin{array}{ l }{ 3x - 5y + 4z = 0} \\\\{ x - y + 8z = 0} \\\\{ 2x - 6y + z = 0}\\end{array}
          \\right\\}
        LATEX
      end
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("{"),
            Plurimath::Math::Function::Table::Array.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new(
                    [
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Number.new("3"),
                        Plurimath::Math::Symbols::Symbol.new("x"),
                        Plurimath::Math::Symbols::Minus.new,
                        Plurimath::Math::Number.new("5"),
                        Plurimath::Math::Symbols::Symbol.new("y"),
                        Plurimath::Math::Symbols::Plus.new,
                        Plurimath::Math::Number.new("4"),
                        Plurimath::Math::Symbols::Symbol.new("z"),
                        Plurimath::Math::Symbols::Equal.new,
                        Plurimath::Math::Number.new("0")
                      ])
                    ],
                    { columnalign: "left" },
                  )
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new(
                    [
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Symbols::Symbol.new("x"),
                        Plurimath::Math::Symbols::Minus.new,
                        Plurimath::Math::Symbols::Symbol.new("y"),
                        Plurimath::Math::Symbols::Plus.new,
                        Plurimath::Math::Number.new("8"),
                        Plurimath::Math::Symbols::Symbol.new("z"),
                        Plurimath::Math::Symbols::Equal.new,
                        Plurimath::Math::Number.new("0")
                      ])
                    ],
                    { columnalign: "left" },
                  )
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new(
                    [
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Number.new("2"),
                        Plurimath::Math::Symbols::Symbol.new("x"),
                        Plurimath::Math::Symbols::Minus.new,
                        Plurimath::Math::Number.new("6"),
                        Plurimath::Math::Symbols::Symbol.new("y"),
                        Plurimath::Math::Symbols::Plus.new,
                        Plurimath::Math::Symbols::Symbol.new("z"),
                        Plurimath::Math::Symbols::Equal.new,
                        Plurimath::Math::Number.new("0")
                      ])
                    ],
                    { columnalign: "left" },
                  )
                ])
              ],
              nil,
              nil,
            ),
            Plurimath::Math::Function::Right.new("}")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #6" do
      let(:string) do
        <<~LATEX
          \\begin{matrix*}a & b \\\\ c & d \\end{matrix*}
        LATEX
      end
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Matrix.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Symbol.new("a")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Symbol.new("b")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Symbol.new("c")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Symbol.new("d")
                ])
              ])
            ],
            nil,
            nil,
            { asterisk: true }
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #7" do
      let(:string) do
        <<~LATEX
          \\begin{matrix*}[r]a & b \\\\ c & d \\end{matrix*}
        LATEX
      end
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Matrix.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Symbol.new("a")
                  ],
                  { columnalign: "right" },
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Symbol.new("b")
                  ],
                  { columnalign: "right" },
                )
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Symbol.new("c")
                  ],
                  { columnalign: "right" },
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Symbol.new("d")
                  ],
                  { columnalign: "right" },
                )
              ])
            ],
            nil,
            nil,
            { asterisk: true }
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #8" do
      let(:string) do
        <<~LATEX
          \\begin{matrix}-a & b \\\\ c & d \\end{matrix}
        LATEX
      end
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Matrix.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbols::Minus.new,
                    Plurimath::Math::Symbols::Symbol.new("a")
                  ])
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Symbol.new("b")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Symbol.new("c")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Symbol.new("d")
                ])
              ])
            ],
            nil,
            nil,
            {},
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #9" do
      let(:string) do
        <<~LATEX
          \\begin{matrix}-\\end{matrix}
        LATEX
      end
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Matrix.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Minus.new
                ])
              ]),
            ],
            nil,
            nil,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #10" do
      let(:string) do
        <<~LATEX
          \\begin{matrix}a_{1} & b_{2} \\\\ c_{3} & d_{4} \\end{matrix}
        LATEX
      end
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Matrix.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbols::Symbol.new("a"),
                    Plurimath::Math::Number.new("1")
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbols::Symbol.new("b"),
                    Plurimath::Math::Number.new("2")
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbols::Symbol.new("c"),
                    Plurimath::Math::Number.new("3")
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbols::Symbol.new("d"),
                    Plurimath::Math::Number.new("4")
                  )
                ])
              ])
            ],
            nil,
            nil,
            {}
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #11" do
      let(:string) do
        <<~LATEX
          \\begin{array}{cc} 1 & 2 \\\\ 3 & 4 \\end{array}
        LATEX
      end
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Number.new("1")
                  ],
                  { columnalign: "center" }
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Number.new("2")
                  ],
                  { columnalign: "center" }
                )
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Number.new("3")
                  ],
                  { columnalign: "center" }
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Number.new("4")
                  ],
                  { columnalign: "center" }
                )
              ])
            ],
            nil,
            nil,
            {}
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #12" do
      let(:string) do
        <<~LATEX
          \\begin{bmatrix}
            a_{1,1} & a_{1,2} & \\cdots & a_{1,n} \\\\
            a_{2,1} & a_{2,2} & \\cdots & a_{2,n} \\\\
            \\vdots & \\vdots & \\ddots & \\vdots \\\\
            a_{m,1} & a_{m,2} & \\cdots & a_{m,n}
          \\end{bmatrix}
        LATEX
      end


      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Bmatrix.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbols::Symbol.new("a"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("1"),
                      Plurimath::Math::Symbols::Comma.new,
                      Plurimath::Math::Number.new("1")
                    ])
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbols::Symbol.new("a"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("1"),
                      Plurimath::Math::Symbols::Comma.new,
                      Plurimath::Math::Number.new("2")
                    ])
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Cdots.new
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbols::Symbol.new("a"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("1"),
                      Plurimath::Math::Symbols::Comma.new,
                      Plurimath::Math::Symbols::Symbol.new("n")
                    ])
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbols::Symbol.new("a"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Symbols::Comma.new,
                      Plurimath::Math::Number.new("1")
                    ])
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbols::Symbol.new("a"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Symbols::Comma.new,
                      Plurimath::Math::Number.new("2")
                    ])
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Cdots.new
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbols::Symbol.new("a"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("2"),
                      Plurimath::Math::Symbols::Comma.new,
                      Plurimath::Math::Symbols::Symbol.new("n")
                    ])
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Vdots.new
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Vdots.new
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Ddots.new
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Vdots.new
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbols::Symbol.new("a"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbols::Symbol.new("m"),
                      Plurimath::Math::Symbols::Comma.new,
                      Plurimath::Math::Number.new("1")
                    ])
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbols::Symbol.new("a"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbols::Symbol.new("m"),
                      Plurimath::Math::Symbols::Comma.new,
                      Plurimath::Math::Number.new("2")
                    ])
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Cdots.new
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbols::Symbol.new("a"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbols::Symbol.new("m"),
                      Plurimath::Math::Symbols::Comma.new,
                      Plurimath::Math::Symbols::Symbol.new("n")
                    ])
                  )
                ])
              ])
            ],
            Plurimath::Math::Symbols::Paren::Lsquare.new,
            Plurimath::Math::Symbols::Paren::Rsquare.new,
            {}
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #13" do
      let(:string) { "\\sqrt { ( - 25 ) ^ { 2 } } = \\pm 25" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sqrt.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbols::Paren::Lround.new,
                [
                  Plurimath::Math::Symbols::Minus.new,
                  Plurimath::Math::Number.new("25"),
                ],
                Plurimath::Math::Symbols::Paren::Rround.new,
              ),
              Plurimath::Math::Number.new("2"),
            )
          ),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Symbols::Pm.new,
          Plurimath::Math::Number.new("25")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #14" do
      let(:string) { "\\left(- x^{3} + 5\\right)^{5}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Left.new("("),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbols::Minus.new,
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbols::Symbol.new("x"),
                  Plurimath::Math::Number.new("3")
                ),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("5")
              ]),
              Plurimath::Math::Function::Right.new(")")
            ]),
            Plurimath::Math::Number.new("5")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #15" do
      let(:string) do
        <<~LATEX
          \\begin{array}{rcl}
            ABC&=&a\\\\
            A&=&abc
          \\end{array}
        LATEX
      end
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Symbol.new("A"),
                    Plurimath::Math::Symbols::Symbol.new("B"),
                    Plurimath::Math::Symbols::Symbol.new("C")
                  ],
                  { columnalign: "right" }
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Equal.new
                  ],
                  { columnalign: "center" }
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Symbol.new("a")
                  ],
                  { columnalign: "left" }
                )
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Symbol.new("A")
                  ],
                  { columnalign: "right" }
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Equal.new
                  ],
                  { columnalign: "center" }
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Symbol.new("a"),
                    Plurimath::Math::Symbols::Symbol.new("b"),
                    Plurimath::Math::Symbols::Symbol.new("c")
                  ],
                  { columnalign: "left" }
                )
              ])
            ],
            nil,
            nil,
            {}
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #16" do
      let(:string) do
        <<~LATEX
          \\begin{array}{cr}
            1 & 2 \\\\
            3 & 4 \\\\
            \\hline 5 & 6
          \\end{array}
        LATEX
      end

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Number.new("1")
                  ],
                  { columnalign: "center" }
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Number.new("2")
                  ],
                  { columnalign: "right" }
                )
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Number.new("3")
                  ],
                  { columnalign: "center" }
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Number.new("4")
                  ],
                  { columnalign: "right" }
                )
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Hline.new,
                    Plurimath::Math::Number.new("5")
                  ],
                  { columnalign: "center" }
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Number.new("6")
                  ],
                  { columnalign: "right" }
                )
              ])
            ],
            nil,
            nil,
            { rowline: "none none solid" }
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #17" do
      let(:string) do
        <<~LATEX
          \\begin{array}{cr}
            1 & 2 \\\\
            \\hline 3 & 4 \\\\
            \\hline 5 & 6
          \\end{array}
        LATEX
      end
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Number.new("1")
                  ],
                  { columnalign: "center" }
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Number.new("2")
                  ],
                  { columnalign: "right" }
                )
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Hline.new,
                    Plurimath::Math::Number.new("3")
                  ],
                  { columnalign: "center" }
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Number.new("4")
                  ],
                  { columnalign: "right" }
                )
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Hline.new,
                    Plurimath::Math::Number.new("5")
                  ],
                  { columnalign: "center" }
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Number.new("6")
                  ],
                  { columnalign: "right" }
                )
              ])
            ],
            nil,
            nil,
            { rowline: "none solid solid" }
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #18" do
      let(:string) { "\\mathrm{...}" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle::Normal.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Period.new,
              Plurimath::Math::Symbols::Period.new,
              Plurimath::Math::Symbols::Period.new
            ]),
            "mathrm"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #19" do
      let(:string) { "\\frac{x + 4}{x + \\frac{123 \\left(\\sqrt{x} + 5\\right)}{x + 4} - 8}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("x"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("4")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("x"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("123"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Left.new("("),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Sqrt.new(
                        Plurimath::Math::Symbols::Symbol.new("x")
                      ),
                      Plurimath::Math::Symbols::Plus.new,
                      Plurimath::Math::Number.new("5")
                    ]),
                    Plurimath::Math::Function::Right.new(")")
                  ])
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbols::Symbol.new("x"),
                  Plurimath::Math::Symbols::Plus.new,
                  Plurimath::Math::Number.new("4")
                ])
              ),
              Plurimath::Math::Symbols::Minus.new,
              Plurimath::Math::Number.new("8")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #20" do
      let(:string) { "\\sqrt {\\sqrt {\\left( x^{3}\\right) + v}}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sqrt.new(
            Plurimath::Math::Function::Sqrt.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::Left.new("("),
                  Plurimath::Math::Function::Power.new(
                    Plurimath::Math::Symbols::Symbol.new("x"),
                    Plurimath::Math::Number.new("3")
                  ),
                  Plurimath::Math::Function::Right.new(")")
                ]),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Symbols::Symbol.new("v")
              ])
            )
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #21" do
      let(:string) { "\\left(x\\right){5}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Symbols::Symbol.new("x"),
            Plurimath::Math::Function::Right.new(")")
          ]),
          Plurimath::Math::Number.new("5")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #22" do
      let(:string) { "\\sqrt[3]{}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Root.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
            ]),
            Plurimath::Math::Formula.new([]),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #23" do
      let(:string) { "1_{}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Number.new("1")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #24" do
      let(:string) { "\\array{}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([])
              ])
            ],
            nil,
            nil
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #25" do
      let(:string) { "\\array{{}}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([])
              ])
            ],
            nil,
            nil
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #26" do
      let(:string) do
        <<~LATEX
          \\left[
            \\begin{matrix}
              1 & 0 & 0 & 0\\\\
              0 & 1 & 0 & 0\\\\
              0 & 0 & 1 & 0\\\\
              0 & 0 & 0 & 1
            \\end{matrix}
          \\right]
        LATEX
      end
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("["),
            Plurimath::Math::Function::Table::Matrix.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("1")
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
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("1")
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
                    Plurimath::Math::Number.new("0")
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
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("0")
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("1")
                  ])
                ])
              ],
              nil,
              nil
            ),
            Plurimath::Math::Function::Right.new("]")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #27" do
      let(:string) do
        <<~LATEX
          x^{x^{x^{x}}}
          \\left(
            x^{x^{x}}
            \\left(
              x^{x}
              \\left(
                \\log{\\left(x \\right)} + 1
              \\right) \\log{\\left(x \\right)} + \\frac{x^{x}}{x}
            \\right) \\log{\\left(x \\right)} + \\frac{x^{x^{x}}}{x}
          \\right)
        LATEX
      end
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbols::Symbol.new("x"),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbols::Symbol.new("x"),
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbols::Symbol.new("x"),
                Plurimath::Math::Symbols::Symbol.new("x")
              )
            )
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Left.new("("),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbols::Symbol.new("x"),
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbols::Symbol.new("x"),
                  Plurimath::Math::Symbols::Symbol.new("x")
                )
              ),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Left.new("("),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::Power.new(
                    Plurimath::Math::Symbols::Symbol.new("x"),
                    Plurimath::Math::Symbols::Symbol.new("x")
                  ),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Left.new("("),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Log.new,
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Function::Left.new("("),
                        Plurimath::Math::Symbols::Symbol.new("x"),
                        Plurimath::Math::Function::Right.new(")")
                      ]),
                      Plurimath::Math::Symbols::Plus.new,
                      Plurimath::Math::Number.new("1")
                    ]),
                    Plurimath::Math::Function::Right.new(")")
                  ]),
                  Plurimath::Math::Function::Log.new,
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Left.new("("),
                    Plurimath::Math::Symbols::Symbol.new("x"),
                    Plurimath::Math::Function::Right.new(")")
                  ]),
                  Plurimath::Math::Symbols::Plus.new,
                  Plurimath::Math::Function::Frac.new(
                    Plurimath::Math::Function::Power.new(
                      Plurimath::Math::Symbols::Symbol.new("x"),
                      Plurimath::Math::Symbols::Symbol.new("x")
                    ),
                    Plurimath::Math::Symbols::Symbol.new("x")
                  )
                ]),
                Plurimath::Math::Function::Right.new(")")
              ]),
              Plurimath::Math::Function::Log.new,
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Left.new("("),
                Plurimath::Math::Symbols::Symbol.new("x"),
                Plurimath::Math::Function::Right.new(")")
              ]),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbols::Symbol.new("x"),
                  Plurimath::Math::Function::Power.new(
                    Plurimath::Math::Symbols::Symbol.new("x"),
                    Plurimath::Math::Symbols::Symbol.new("x")
                  )
                ),
                Plurimath::Math::Symbols::Symbol.new("x")
              )
            ]),
            Plurimath::Math::Function::Right.new(")")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #28" do
      let(:string) { "\\log_2{x}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new(
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Symbols::Symbol.new("x")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #29" do
      let(:string) { "\\sqrt[]{3}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Root.new(
            Plurimath::Math::Formula.new([]),
            Plurimath::Math::Number.new("3")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #30" do
      let(:string) { "\\frac{3}{\\frac{1}{2}{x}^{2}}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Number.new("2")
              ),
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbols::Symbol.new("x"),
                Plurimath::Math::Number.new("2")
              )
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #31" do
      let(:string) { "\\frac{3}{\\frac{1}{2}{x}^{2}-\\frac{3\\sqrt[]{3}}{2}x+3}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Number.new("2")
              ),
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbols::Symbol.new("x"),
                Plurimath::Math::Number.new("2")
              ),
              Plurimath::Math::Symbols::Minus.new,
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("3"),
                  Plurimath::Math::Function::Root.new(
                    Plurimath::Math::Formula.new([]),
                    Plurimath::Math::Number.new("3")
                  )
                ]),
                Plurimath::Math::Number.new("2")
              ),
              Plurimath::Math::Symbols::Symbol.new("x"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("3")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #32" do
      let(:string) { "^3" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Hat.new,
          Plurimath::Math::Number.new("3")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #33" do
      let(:string) { "\\lim_{x \\to +\\infty} f(x)" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Lim.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("x"),
              Plurimath::Math::Symbols::Rightarrow.new,
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Symbols::Oo.new
            ])
          ),
          Plurimath::Math::Symbols::Symbol.new("f"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("x"),
            ],
            Plurimath::Math::Symbols::Paren::Rround.new,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #34" do
      let(:string) { "\\inf_{x > s}f(x)" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Inf.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("x"),
              Plurimath::Math::Symbols::Greater.new,
              Plurimath::Math::Symbols::Symbol.new("s")
            ])
          ),
          Plurimath::Math::Symbols::Symbol.new("f"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("x"),
            ],
            Plurimath::Math::Symbols::Paren::Rround.new,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #35" do
      let(:string) { "\\sup_{x \\in \\mathbb{R}}f(x)" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Sup.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("x"),
              Plurimath::Math::Symbols::In.new,
              Plurimath::Math::Function::FontStyle::DoubleStruck.new(
                Plurimath::Math::Symbols::Symbol.new("R"),
                "mathbb"
              )
            ])
          ),
          Plurimath::Math::Symbols::Symbol.new("f"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("x"),
            ],
            Plurimath::Math::Symbols::Paren::Rround.new,
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #36" do
      let(:string) { "\\max_{x \\in \\[a,b\\]}f(x)" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Max.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("x"),
              Plurimath::Math::Symbols::In.new,
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbols::Symbol.new("\\["),
                [
                  Plurimath::Math::Symbols::Symbol.new("a"),
                  Plurimath::Math::Symbols::Comma.new,
                  Plurimath::Math::Symbols::Symbol.new("b"),
                ],
                Plurimath::Math::Symbols::Symbol.new("\\]")
              )
            ])
          ),
          Plurimath::Math::Symbols::Symbol.new("f"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("x"),
            ],
            Plurimath::Math::Symbols::Paren::Rround.new,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #37" do
      let(:string) { "\\min_{x \\in \\[\\alpha,\\beta\\]}f(x)" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Min.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("x"),
              Plurimath::Math::Symbols::In.new,
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbols::Symbol.new("\\["),
                [
                  Plurimath::Math::Symbols::Alpha.new,
                  Plurimath::Math::Symbols::Comma.new,
                  Plurimath::Math::Symbols::Upbeta.new,
                ],
                Plurimath::Math::Symbols::Symbol.new("\\]"),
              )
            ])
          ),
          Plurimath::Math::Symbols::Symbol.new("f"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("x"),
            ],
            Plurimath::Math::Symbols::Paren::Rround.new,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #38" do
      let(:string) { "\\int\\limits_{0}^{\\pi}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Limits.new(
            Plurimath::Math::Function::Int.new,
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Symbols::Pi.new
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #39" do
      let(:string) { "\\sum_{\\substack{1\\le i\\le n\\\\ i\\ne j}}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Function::Substack.new([
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1"),
                  Plurimath::Math::Symbols::Le.new,
                  Plurimath::Math::Symbols::Symbol.new("i"),
                  Plurimath::Math::Symbols::Le.new,
                  Plurimath::Math::Symbols::Symbol.new("n")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbols::Symbol.new("i"),
                  Plurimath::Math::Symbols::Ne.new,
                  Plurimath::Math::Symbols::Symbol.new("j")
                ])
              ])
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #40" do
      let(:string) { "\\mathrm{AA}" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle::Normal.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("A"),
              Plurimath::Math::Symbols::Symbol.new("A")
            ]),
            "mathrm"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #41" do
      let(:string) { "(1+(x-y)^{2})" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbols::Paren::Lround.new,
                  [
                    Plurimath::Math::Symbols::Symbol.new("x"),
                    Plurimath::Math::Symbols::Minus.new,
                    Plurimath::Math::Symbols::Symbol.new("y")
                  ],
                  Plurimath::Math::Symbols::Paren::Rround.new,
                ),
                Plurimath::Math::Number.new("2"),
              ),
            ],
            Plurimath::Math::Symbols::Paren::Rround.new,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #42" do
      let(:string) do
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
            \\right)   &
            \\begin{array}{cc}
              & \\\\
              \\cdots & \\mbox{degree of freedom 1, node 1} \\\\
              & \\\\
              & \\\\
              & \\\\
              \\cdots & \\mbox{degree of freedom 2, node 2}
            \\end{array} \\\\ & \\\\
            \\begin{array}{cccccc}
              \\vdots & & & & & \\vdots
            \\end{array} & \\\\
            \\begin{array}{cccc}
                & \\mbox{degree of}  & \\mbox{degree of}  & \\\\
                & \\mbox{freedom 1,} & \\mbox{freedom 2,} & \\\\
                & \\mbox{node 1} & \\mbox{node 2}  &
            \\end{array}    &
          \\end{array}
        LATEX
      end
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Array.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Function::Left.new("("),
                      Plurimath::Math::Function::Table::Array.new(
                        [
                          Plurimath::Math::Function::Tr.new([
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                          ]),
                          Plurimath::Math::Function::Tr.new([
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new(
                              [
                                Plurimath::Math::Symbols::Plus.new,
                                Plurimath::Math::Symbols::Symbol.new("k"),
                              ],
                              { columnalign: "center" }
                            ),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new(
                              [
                                Plurimath::Math::Formula.new([
                                  Plurimath::Math::Symbols::Minus.new,
                                  Plurimath::Math::Symbols::Symbol.new("k"),
                                ]),
                              ],
                              { columnalign: "center" }
                            ),
                          ]),
                          Plurimath::Math::Function::Tr.new([
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                          ]),
                          Plurimath::Math::Function::Tr.new([
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                          ]),
                          Plurimath::Math::Function::Tr.new([
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                          ]),
                          Plurimath::Math::Function::Tr.new([
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new(
                              [
                                Plurimath::Math::Formula.new([
                                  Plurimath::Math::Symbols::Minus.new,
                                  Plurimath::Math::Symbols::Symbol.new("k"),
                                ]),
                              ],
                              { columnalign: "center" }
                            ),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new([], {
                              columnalign: "center",
                            }),
                            Plurimath::Math::Function::Td.new(
                              [
                                Plurimath::Math::Symbols::Plus.new,
                                Plurimath::Math::Symbols::Symbol.new("k"),
                              ],
                              { columnalign: "center" }
                            ),
                          ]),
                        ],
                        nil,
                        nil,
                        {}
                      ),
                      Plurimath::Math::Function::Right.new(")"),
                    ]),
                  ],
                  { columnalign: "center" }
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Function::Table::Array.new(
                      [
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new(
                            [Plurimath::Math::Symbols::Cdots.new],
                            { columnalign: "center" }
                          ),
                          Plurimath::Math::Function::Td.new(
                            [
                              Plurimath::Math::Function::Mbox.new("degree of freedom 1, node 1"),
                            ],
                            { columnalign: "center" }
                          ),
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new(
                            [Plurimath::Math::Symbols::Cdots.new],
                            { columnalign: "center" }
                          ),
                          Plurimath::Math::Function::Td.new(
                            [
                              Plurimath::Math::Function::Mbox.new("degree of freedom 2, node 2"),
                            ],
                            { columnalign: "center" }
                          ),
                        ]),
                      ],
                      nil,
                      nil,
                      {}
                    ),
                  ],
                  { columnalign: "center" }
                ),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([], { columnalign: "center" }),
                Plurimath::Math::Function::Td.new([], { columnalign: "center" }),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Function::Table::Array.new(
                      [
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new(
                            [Plurimath::Math::Symbols::Vdots.new],
                            { columnalign: "center" }
                          ),
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                          Plurimath::Math::Function::Td.new(
                            [Plurimath::Math::Symbols::Vdots.new],
                            { columnalign: "center" }
                          ),
                        ]),
                      ],
                      nil,
                      nil,
                      {}
                    ),
                  ],
                  { columnalign: "center" }
                ),
                Plurimath::Math::Function::Td.new([], { columnalign: "center" }),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Function::Table::Array.new(
                      [
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                          Plurimath::Math::Function::Td.new(
                            [
                              Plurimath::Math::Function::Mbox.new("degree of"),
                            ],
                            { columnalign: "center" }
                          ),
                          Plurimath::Math::Function::Td.new(
                            [
                              Plurimath::Math::Function::Mbox.new("degree of"),
                            ],
                            { columnalign: "center" }
                          ),
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                          Plurimath::Math::Function::Td.new(
                            [
                              Plurimath::Math::Function::Mbox.new("freedom 1,"),
                            ],
                            { columnalign: "center" }
                          ),
                          Plurimath::Math::Function::Td.new(
                            [
                              Plurimath::Math::Function::Mbox.new("freedom 2,"),
                            ],
                            { columnalign: "center" }
                          ),
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                        ]),
                        Plurimath::Math::Function::Tr.new([
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                          Plurimath::Math::Function::Td.new(
                            [
                              Plurimath::Math::Function::Mbox.new("node 1"),
                            ],
                            { columnalign: "center" }
                          ),
                          Plurimath::Math::Function::Td.new(
                            [
                              Plurimath::Math::Function::Mbox.new("node 2"),
                            ],
                            { columnalign: "center" }
                          ),
                          Plurimath::Math::Function::Td.new([], {
                            columnalign: "center",
                          }),
                        ]),
                      ],
                      nil,
                      nil,
                      {}
                    ),
                  ],
                  { columnalign: "center" }
                ),
                Plurimath::Math::Function::Td.new([], { columnalign: "center" }),
              ]),
            ],
            nil,
            nil,
            {}
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #43" do
      let(:string) do
        <<~LATEX
          \\begin{split}
            C_L &= {L \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 S} \\\\ \\\\
            C_D &= {D \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 S} \\\\ \\\\
            \\vec{C}_M &= {\\vec{M} \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 c_\\textrm{ref} S_\\textrm{ref}},
          \\end{split}
        LATEX
      end
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table::Split.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbols::Symbol.new("C"),
                      Plurimath::Math::Symbols::Symbol.new("L")
                    ),
                  ],
                  nil
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Equal.new,
                    Plurimath::Math::Function::Over.new(
                      Plurimath::Math::Formula.new([Plurimath::Math::Symbols::Symbol.new("L")]),
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Function::Over.new(
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Number.new("1"),
                          ]),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Number.new("2"),
                          ])
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbols::Rho.new,
                          Plurimath::Math::Function::FontStyle::Normal.new(
                            Plurimath::Math::Formula.new([
                              Plurimath::Math::Symbols::Symbol.new("r"),
                              Plurimath::Math::Symbols::Symbol.new("e"),
                              Plurimath::Math::Symbols::Symbol.new("f"),
                            ]),
                            "textrm"
                          )
                        ),
                        Plurimath::Math::Function::PowerBase.new(
                          Plurimath::Math::Symbols::Symbol.new("q"),
                          Plurimath::Math::Function::FontStyle::Normal.new(
                            Plurimath::Math::Formula.new([
                              Plurimath::Math::Symbols::Symbol.new("r"),
                              Plurimath::Math::Symbols::Symbol.new("e"),
                              Plurimath::Math::Symbols::Symbol.new("f"),
                            ]),
                            "textrm"
                          ),
                          Plurimath::Math::Number.new("2")
                        ),
                        Plurimath::Math::Symbols::Symbol.new("S"),
                      ])
                    ),
                  ],
                  nil
                ),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([], nil),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Symbols::Symbol.new("C"),
                      Plurimath::Math::Symbols::Symbol.new("D")
                    ),
                  ],
                  nil
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Equal.new,
                    Plurimath::Math::Function::Over.new(
                      Plurimath::Math::Formula.new([Plurimath::Math::Symbols::Symbol.new("D")]),
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Function::Over.new(
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Number.new("1"),
                          ]),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Number.new("2"),
                          ])
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbols::Rho.new,
                          Plurimath::Math::Function::FontStyle::Normal.new(
                            Plurimath::Math::Formula.new([
                              Plurimath::Math::Symbols::Symbol.new("r"),
                              Plurimath::Math::Symbols::Symbol.new("e"),
                              Plurimath::Math::Symbols::Symbol.new("f"),
                            ]),
                            "textrm"
                          )
                        ),
                        Plurimath::Math::Function::PowerBase.new(
                          Plurimath::Math::Symbols::Symbol.new("q"),
                          Plurimath::Math::Function::FontStyle::Normal.new(
                            Plurimath::Math::Formula.new([
                              Plurimath::Math::Symbols::Symbol.new("r"),
                              Plurimath::Math::Symbols::Symbol.new("e"),
                              Plurimath::Math::Symbols::Symbol.new("f"),
                            ]),
                            "textrm"
                          ),
                          Plurimath::Math::Number.new("2")
                        ),
                        Plurimath::Math::Symbols::Symbol.new("S"),
                      ])
                    ),
                  ],
                  nil
                ),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([], nil),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Function::Base.new(
                      Plurimath::Math::Function::Vec.new(
                        Plurimath::Math::Symbols::Symbol.new("C")
                      ),
                      Plurimath::Math::Symbols::Symbol.new("M")
                    ),
                  ],
                  nil
                ),
                Plurimath::Math::Function::Td.new(
                  [
                    Plurimath::Math::Symbols::Equal.new,
                    Plurimath::Math::Function::Over.new(
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Function::Vec.new(
                          Plurimath::Math::Symbols::Symbol.new("M")
                        ),
                      ]),
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Function::Over.new(
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Number.new("1"),
                          ]),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Number.new("2"),
                          ])
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbols::Rho.new,
                          Plurimath::Math::Function::FontStyle::Normal.new(
                            Plurimath::Math::Formula.new([
                              Plurimath::Math::Symbols::Symbol.new("r"),
                              Plurimath::Math::Symbols::Symbol.new("e"),
                              Plurimath::Math::Symbols::Symbol.new("f"),
                            ]),
                            "textrm"
                          )
                        ),
                        Plurimath::Math::Function::PowerBase.new(
                          Plurimath::Math::Symbols::Symbol.new("q"),
                          Plurimath::Math::Function::FontStyle::Normal.new(
                            Plurimath::Math::Formula.new([
                              Plurimath::Math::Symbols::Symbol.new("r"),
                              Plurimath::Math::Symbols::Symbol.new("e"),
                              Plurimath::Math::Symbols::Symbol.new("f"),
                            ]),
                            "textrm"
                          ),
                          Plurimath::Math::Number.new("2")
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbols::Symbol.new("c"),
                          Plurimath::Math::Function::FontStyle::Normal.new(
                            Plurimath::Math::Formula.new([
                              Plurimath::Math::Symbols::Symbol.new("r"),
                              Plurimath::Math::Symbols::Symbol.new("e"),
                              Plurimath::Math::Symbols::Symbol.new("f"),
                            ]),
                            "textrm"
                          )
                        ),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbols::Symbol.new("S"),
                          Plurimath::Math::Function::FontStyle::Normal.new(
                            Plurimath::Math::Formula.new([
                              Plurimath::Math::Symbols::Symbol.new("r"),
                              Plurimath::Math::Symbols::Symbol.new("e"),
                              Plurimath::Math::Symbols::Symbol.new("f"),
                            ]),
                            "textrm"
                          )
                        ),
                      ])
                    ),
                    Plurimath::Math::Symbols::Comma.new,
                  ],
                  nil
                ),
              ]),
            ],
            nil,
            nil,
            {}
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
