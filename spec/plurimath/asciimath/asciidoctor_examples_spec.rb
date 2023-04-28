require_relative "../../../spec/spec_helper"

# These examples originate from https://github.com/asciidoctor/asciimath

RSpec.describe Plurimath::Asciimath::Parser do

  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    context "when contains example #01" do
      let(:string) { "underset(_)(hat A)(^) = hat A exp j vartheta_0" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Symbol.new("_"),
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Symbol.new("A")
            )
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("^")
            ],
            Plurimath::Math::Symbol.new(")")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Symbol.new("A")
          ),
          Plurimath::Math::Function::Exp.new(
            Plurimath::Math::Symbol.new("j")
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x3d1;"),
            Plurimath::Math::Number.new("0")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #02" do
      let(:string) { "x+b/(2a)<+-sqrt((b^2)/(4a^2)-c/a)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Symbol.new("b"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new("a")
            ]),
          ),
          Plurimath::Math::Symbol.new("&#x3c;"),
          Plurimath::Math::Symbol.new("&#xb1;"),
          Plurimath::Math::Function::Sqrt.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbol.new("b"),
                  Plurimath::Math::Number.new("2")
                ),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("4"),
                  Plurimath::Math::Function::Power.new(
                    Plurimath::Math::Symbol.new("a"),
                    Plurimath::Math::Number.new("2")
                  )
                ])
              ),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Symbol.new("c"),
                Plurimath::Math::Symbol.new("a")
              ),
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #03" do
      let(:string) { "a^2 + b^2 = c^2" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("b"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("c"),
            Plurimath::Math::Number.new("2")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #04" do
      let(:string) { "x = (-b+-sqrt(b^2-4ac))/(2a)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Symbol.new("b"),
              Plurimath::Math::Symbol.new("&#xb1;"),
              Plurimath::Math::Function::Sqrt.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::Power.new(
                    Plurimath::Math::Symbol.new("b"),
                    Plurimath::Math::Number.new("2")
                  ),
                  Plurimath::Math::Symbol.new("-"),
                  Plurimath::Math::Number.new("4"),
                  Plurimath::Math::Symbol.new("a"),
                  Plurimath::Math::Symbol.new("c")
                ])
              )
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new("a")
            ])
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #05" do
      let(:string) { "m = (y_2 - y_1)/(x_2 - x_1) = (Deltay)/(Deltax)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("m"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("y"),
                Plurimath::Math::Number.new("2")
              ),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("y"),
                Plurimath::Math::Number.new("1")
              )
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Number.new("2")
              ),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Number.new("1")
              )
            ]),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x394;"),
              Plurimath::Math::Symbol.new("y")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x394;"),
              Plurimath::Math::Symbol.new("x")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #06" do
      let(:string) { "f\'(x) = lim_(Deltax->0)(f(x+Deltax)-f(x))/(Deltax)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::F.new(
            Plurimath::Math::Symbol.new("&#x2032;")
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("x")
            ],
            Plurimath::Math::Symbol.new(")")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Lim.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x394;"),
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new("&#x2192;"),
              Plurimath::Math::Number.new("0")
            ])
          ),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::F.new(
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbol.new("("),
                  [
                    Plurimath::Math::Symbol.new("x"),
                    Plurimath::Math::Symbol.new("+"),
                    Plurimath::Math::Symbol.new("&#x394;"),
                    Plurimath::Math::Symbol.new("x"),
                  ],
                  Plurimath::Math::Symbol.new(")"),
                )
              ),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Function::F.new(
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbol.new("("),
                  [
                    Plurimath::Math::Symbol.new("x"),
                  ],
                  Plurimath::Math::Symbol.new(")"),
                )
              )
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x394;"),
              Plurimath::Math::Symbol.new("x")
            ])
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #07" do
      let(:string) { "d/dx [x^n] = nx^(n - 1)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Symbol.new("d"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("d"),
              Plurimath::Math::Symbol.new("x"),
            ]),
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("["),
            [
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Symbol.new("n")
              )
            ],
            Plurimath::Math::Symbol.new("]")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("n"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("n"),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Number.new("1")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #08" do
      let(:string) { "int_a^b f(x) dx = [F(x)]_a^b = F(b) - F(a)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Int.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Symbol.new("b")
          ),
          Plurimath::Math::Function::F.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [Plurimath::Math::Symbol.new("x")],
              Plurimath::Math::Symbol.new(")"),
            )
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("d"),
            Plurimath::Math::Symbol.new("x"),
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("["),
              [
                Plurimath::Math::Symbol.new("F"),
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbol.new("("),
                  [
                    Plurimath::Math::Symbol.new("x")
                  ],
                  Plurimath::Math::Symbol.new(")")
                ),
              ],
              Plurimath::Math::Symbol.new("]"),
            ),
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Symbol.new("b")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("F"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("b")
            ],
            Plurimath::Math::Symbol.new(")")
          ),
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Symbol.new("F"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("a")
            ],
            Plurimath::Math::Symbol.new(")")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #09" do
      let(:string) { "int_a^b f(x) dx = f(c)(b - a)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Int.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Symbol.new("b")
          ),
          Plurimath::Math::Function::F.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("x"),
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("d"),
            Plurimath::Math::Symbol.new("x"),
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::F.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("c"),
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("b"),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Symbol.new("a")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #10" do
      let(:string) { "ax^2 + bx + c = 0" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("b"),
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("c"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("0")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #11" do
      let(:string) { '"average value"=1/(b-a) int_a^b f(x) dx' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("average value"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("b"),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Symbol.new("a")
            ])
          ),
          Plurimath::Math::Function::Int.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Symbol.new("b")
          ),
          Plurimath::Math::Function::F.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("x")
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("d"),
            Plurimath::Math::Symbol.new("x")
          ]),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #12" do
      let(:string) { "d/dx[int_a^x f(t) dt] = f(x)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Symbol.new("d"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("d"),
              Plurimath::Math::Symbol.new("x"),
            ])
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("["),
            [
              Plurimath::Math::Function::Int.new(
                Plurimath::Math::Symbol.new("a"),
                Plurimath::Math::Symbol.new("x")
              ),
              Plurimath::Math::Function::F.new(
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbol.new("("),
                  [
                    Plurimath::Math::Symbol.new("t"),
                  ],
                  Plurimath::Math::Symbol.new(")"),
                )
              ),
              Plurimath::Math::Symbol.new("d"),
              Plurimath::Math::Symbol.new("t")
            ],
            Plurimath::Math::Symbol.new("]")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::F.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("x"),
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #13" do
      let(:string) { "hat(ab) bar(xy) ul(A) vec(v)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Symbol.new("b")
            ])
          ),
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new("y")
            ])
          ),
          Plurimath::Math::Function::Ul.new(
            Plurimath::Math::Symbol.new("A")
          ),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Symbol.new("v")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #14" do
      let(:string) { "z_12^34" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("z"),
            Plurimath::Math::Number.new("12"),
            Plurimath::Math::Number.new("34"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #15" do
      let(:string) { "lim_(x->c)(f(x)-f(c))/(x-c)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Lim.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new("&#x2192;"),
              Plurimath::Math::Symbol.new("c")
            ])
          ),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::F.new(
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbol.new("("),
                  [
                    Plurimath::Math::Symbol.new("x"),
                  ],
                  Plurimath::Math::Symbol.new(")"),
                )
              ),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Function::F.new(
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbol.new("("),
                  [
                    Plurimath::Math::Symbol.new("c"),
                  ],
                  Plurimath::Math::Symbol.new(")"),
                )
              ),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Symbol.new("c")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #16" do
      let(:string) { "int_0^(pi/2) g(x) dx" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Int.new(
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Symbol.new("&#x3c0;"),
              Plurimath::Math::Number.new("2")
            )
          ),
          Plurimath::Math::Function::G.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Symbol.new("x"),
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("d"),
            Plurimath::Math::Symbol.new("x")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #17" do
      let(:string) { "sum_(n=0)^oo a_n" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("n"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("0")
            ]),
            Plurimath::Math::Symbol.new("&#x221e;")
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Symbol.new("n")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #18" do
      let(:string) { "((1),(42))" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("42")
                ])
              ]),
            ],
            "(",
            ")",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #19" do
      let(:string) { "((1,42))" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("42"),
                ])
              ]),
            ],
            "(",
            ")",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #20" do
      let(:string) { "((1,2,3),(4,5,6),(7,8,9))" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("2")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("3")
                ]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("4")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("5")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("6")
                ]),
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("7")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("8")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("9")
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

    context "when contains example #21" do
      let(:string) { "|(a,b),(c,d)|=ad-bc" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("a")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("b")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("c")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("d")
                ])
              ])
            ],
            "|",
            "|",
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("d"),
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Symbol.new("b"),
          Plurimath::Math::Symbol.new("c")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #22" do
      let(:string) { "((a_(11), cdots , a_(1n)),(vdots, ddots, vdots),(a_(m1), cdots , a_(mn)))" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("a"),
                    Plurimath::Math::Number.new("11")
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("&#x22ef;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("a"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Number.new("1"),
                      Plurimath::Math::Symbol.new("n")
                    ])
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("&#x22ee;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("&#x22f1;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("&#x22ee;")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("a"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("m"),
                      Plurimath::Math::Number.new("1")
                    ])
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("&#x22ef;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("a"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("m"),
                      Plurimath::Math::Symbol.new("n")
                    ])
                  )
                ])
              ])
            ],
            "(",
            ")"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #23" do
      let(:string) { "sum_(k=1)^n k = 1+2+ cdots +n=(n(n+1))/2" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("k"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Symbol.new("n")
          ),
          Plurimath::Math::Symbol.new("k"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("&#x22ef;"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("n"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("n"),
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbol.new("("),
                [
                  Plurimath::Math::Symbol.new("n"),
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Number.new("1")
                ],
                Plurimath::Math::Symbol.new(")")
              )
            ]),
            Plurimath::Math::Number.new("2")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #24" do
      let(:string) { '"Скорость"=("Расстояние")/("Время")' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("Скорость"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Function::Text.new("Расстояние"),
            Plurimath::Math::Function::Text.new("Время")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #25" do
      let(:string) { "bb (a + b) + cc c = fr (d^n)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle::Bold.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Symbol.new("b")
            ]),
            "bb"
          ),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Function::FontStyle::Script.new(
            Plurimath::Math::Symbol.new("c"),
            "cc"
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::FontStyle::Fraktur.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new("d"),
              Plurimath::Math::Symbol.new("n")
            ),
            "fr"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #26" do
      let(:string) { "max()" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Max.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              nil,
              Plurimath::Math::Symbol.new(")"),
            )
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #27" do
      let(:string) { 'text("foo")' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new('"foo"')
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #28" do
      let(:string) { "ubrace(1 + 2) obrace(3 + 4" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Ubrace.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("2")
            ])
          ),
          Plurimath::Math::Function::Obrace.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("4")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #29" do
      let(:string) { 's\'_i = {(- 1, if s_i > s_(i + 1)),( + 1, if s_i <= s_(i + 1)):}' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("s"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x2032;"),
            Plurimath::Math::Symbol.new("i")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("-"),
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("if"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("s"),
                    Plurimath::Math::Symbol.new("i")
                  ),
                  Plurimath::Math::Symbol.new("&#x3e;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("s"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("i"),
                      Plurimath::Math::Symbol.new("+"),
                      Plurimath::Math::Number.new("1")
                    ])
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("if"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("s"),
                    Plurimath::Math::Symbol.new("i")
                  ),
                  Plurimath::Math::Symbol.new("&#x2264;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("s"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("i"),
                      Plurimath::Math::Symbol.new("+"),
                      Plurimath::Math::Number.new("1")
                    ])
                  )
                ])
              ])
            ],
            "{",
            ":}"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #30" do
      let(:string) { 's\'_i = {(, if s_i > s_(i + 1)),( + 1,):}' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("s"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("&#x2032;"),
            Plurimath::Math::Symbol.new("i")
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("if"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("s"),
                    Plurimath::Math::Symbol.new("i")
                  ),
                  Plurimath::Math::Symbol.new("&#x3e;"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("s"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("i"),
                      Plurimath::Math::Symbol.new("+"),
                      Plurimath::Math::Number.new("1")
                    ])
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Function::Td.new([])
              ])
            ],
            "{",
            ":}"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #31" do
      let(:string) { '{:(a,b),(c,d):}' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("a")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("b")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("c")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("d")
                ])
              ])
            ],
            "{:",
            ":}",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #32" do
      let(:string) { 'overset (a + b) (c + d)' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Symbol.new("b")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("c"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Symbol.new("d")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #33" do
      let(:string) { 'underset a b' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Symbol.new("b")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #34" do
      let(:string) { 'sin a_c^b' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Sin.new(
              Plurimath::Math::Symbol.new("a")
            ),
            Plurimath::Math::Symbol.new("c"),
            Plurimath::Math::Symbol.new("b"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #35" do
      let(:string) { 'max a_c^b' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Max.new(
              Plurimath::Math::Symbol.new("a")
            ),
            Plurimath::Math::Symbol.new("c"),
            Plurimath::Math::Symbol.new("b"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #36" do
      let(:string) { 'norm a_c^b' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Norm.new(
              Plurimath::Math::Symbol.new("a")
            ),
            Plurimath::Math::Symbol.new("c"),
            Plurimath::Math::Symbol.new("b"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #37" do
      let(:string) { 'overarc a_b^c' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("o"),
          Plurimath::Math::Symbol.new("v"),
          Plurimath::Math::Symbol.new("e"),
          Plurimath::Math::Symbol.new("r"),
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("r"),
          Plurimath::Math::Symbol.new("c"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Symbol.new("b"),
            Plurimath::Math::Symbol.new("c"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #38" do
      let(:string) { 'frown a_b^c' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x2322;"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Symbol.new("b"),
            Plurimath::Math::Symbol.new("c"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #39" do
      let(:string) { 'sin(a_c^b)' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Function::PowerBase.new(
                  Plurimath::Math::Symbol.new("a"),
                  Plurimath::Math::Symbol.new("c"),
                  Plurimath::Math::Symbol.new("b"),
                ),
              ],
              Plurimath::Math::Symbol.new(")"),
            )
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #40" do
      let(:string) { 'cancel(a_b^c) cancel a_b^c' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Cancel.new(
            Plurimath::Math::Function::PowerBase.new(
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Symbol.new("b"),
              Plurimath::Math::Symbol.new("c")
            )
          ),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Cancel.new(
              Plurimath::Math::Symbol.new("a")
            ),
            Plurimath::Math::Symbol.new("b"),
            Plurimath::Math::Symbol.new("c")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #41" do
      let(:string) { 'color(red)(x) color(red)(y) color(blue)(z) colortext(blue)(a_b^c)' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Color.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("r"),
              Plurimath::Math::Symbol.new("e"),
              Plurimath::Math::Symbol.new("d"),
            ]),
            Plurimath::Math::Symbol.new("x")
          ),
          Plurimath::Math::Function::Color.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("r"),
              Plurimath::Math::Symbol.new("e"),
              Plurimath::Math::Symbol.new("d"),
            ]),
            Plurimath::Math::Symbol.new("y")
          ),
          Plurimath::Math::Function::Color.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("b"),
              Plurimath::Math::Symbol.new("l"),
              Plurimath::Math::Symbol.new("u"),
              Plurimath::Math::Symbol.new("e"),
            ]),
            Plurimath::Math::Symbol.new("z")
          ),
          Plurimath::Math::Function::Color.new(
            Plurimath::Math::Symbol.new("blue"),
            Plurimath::Math::Function::PowerBase.new(
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Symbol.new("b"),
              Plurimath::Math::Symbol.new("c")
            )
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #42" do
      let(:string) { '{ x\ : \ x in A ^^ x in B }' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("{"),
            [
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new("&#xa0;"),
              Plurimath::Math::Symbol.new("&#x3a;"),
              Plurimath::Math::Symbol.new("&#xa0;"),
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new("&#x2208;"),
              Plurimath::Math::Symbol.new("A"),
              Plurimath::Math::Symbol.new("&#x2227;"),
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new("&#x2208;"),
              Plurimath::Math::Symbol.new("B")
            ],
            Plurimath::Math::Symbol.new("}")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #43" do
      let(:string) { 'ii' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("i"),
          Plurimath::Math::Symbol.new("i"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #44" do
      let(:string) { 'rm(ms)' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle::Normal.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("m"),
              Plurimath::Math::Symbol.new("s")
            ]),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #45" do
      let(:string) { 'hat' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Hat.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #46" do
      let(:string) { '40% * 3!' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("40"),
          Plurimath::Math::Symbol.new("&#x25;"),
          Plurimath::Math::Symbol.new("&#x22c5;"),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("&#x21;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #47" do
      let(:string) { 'R(alpha_(K+1)|x)' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("R"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("&#x3b1;"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("K"),
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Number.new("1")
                ])
              ),
              Plurimath::Math::Symbol.new("&#x7c;"),
              Plurimath::Math::Symbol.new("x")
            ],
            Plurimath::Math::Symbol.new(")")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #48" do
      let(:string) { '|(a),(b)|' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("a")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("b")
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

    context "when contains example #49" do
      let(:string) { '|a+b|' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x7c;"),
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("b"),
          Plurimath::Math::Symbol.new("&#x7c;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #50" do
      let(:string) { '|a+b|/c' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x7c;"),
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("b"),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Symbol.new("&#x7c;"),
            Plurimath::Math::Symbol.new("c")
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #51" do
      let(:string) { '[[a,b,|,c],[d,e,|,f]]' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("a")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("b")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("&#x7c;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("c")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("d")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("e")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("&#x7c;")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::F.new
                ])
              ])
            ],
            "[",
            "]"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #52" do
      let(:string) { '~a mlt b mgt -+c' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&#x7e;"),
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("m"),
          Plurimath::Math::Symbol.new("&#x3c;"),
          Plurimath::Math::Symbol.new("b"),
          Plurimath::Math::Symbol.new("m"),
          Plurimath::Math::Symbol.new("&#x3e;"),
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("c")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #53" do
      let(:string) { 'a+b+...+c' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("b"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("&#x2026;"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("c")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #54" do
      let(:string) { 'frac{a}{b}' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Symbol.new("b")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #55" do
      let(:string) { 'ubrace(((1, 0),(0, 1)))_("Adjustment to texture space")' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Ubrace.new(
              Plurimath::Math::Function::Table.new(
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
                "(",
                ")"
              )
            ),
            Plurimath::Math::Function::Text.new("Adjustment to texture space")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
