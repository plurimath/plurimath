require_relative "../../../lib/plurimath/math"

RSpec.describe Plurimath::Asciimath::Parser do

  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    context "when contains Cos function string" do
      let(:string) { "cos(2)" }
      it "returns Cos formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Cos.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2")
            ])
          )]
        )
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains Sum function string" do
      let(:string) { "sum(2)" }
      it "returns Cos Formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when Sin contains Cos function as arg" do
      let(:string) { "sin(cos{theta})" }
      it "returns Sin formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Cos.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("theta")
                ])
              )
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when Sin contains Sum function with base value" do
      let(:string) { "sin(sum_(theta))" }
      it "returns Sin formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Sum.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("theta")
                ])
              )
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when Sin contains Sum function as arg" do
      let(:string) { "sin(sum_(theta)^3)" }
      it "returns Sin formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Sum.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("theta")
                ]),
                Plurimath::Math::Number.new("3")
              )
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when Sin contains with multiple functions" do
      let(:string) { "sin(sum_(theta)^sin(theta))" }
      it "returns Sin formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Sum.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("theta")
                ]),
                Plurimath::Math::Function::Sin.new(
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("theta")
                  ])
                )
              )
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when Sin contains with second half of equation" do
      let(:string) { "sin(sum_(theta)^sin(cong))=[1+1]" }
      it "returns Sin formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Sum.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("theta")
                ]),
                Plurimath::Math::Function::Sin.new(
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("cong")
                  ])
                )
              )
            ])
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Number.new("1")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when Sum contains with second half of equation" do
      let(:string) { "sum_(i=1)^ni^3 = sin(n/2)^2" }
      it "returns Sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Symbol.new("n")
          ),
          Plurimath::Math::Symbol.new("i"),
          Plurimath::Math::Symbol.new("^"),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("n"),
              Plurimath::Math::Symbol.new("/"),
              Plurimath::Math::Number.new("2"),
            ])
          ),
          Plurimath::Math::Symbol.new("^"),
          Plurimath::Math::Number.new("2"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when Sum contains frac function" do
      let(:string) { "sum_(i=frac{1}{3})^33" }
      it "returns Sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("3")
                ])
              )
            ]),
            Plurimath::Math::Number.new("33")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when Sum contains frac function with single arg" do
      let(:string) { "sum_(i=frac{13})^33" }
      it "returns Sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("13")
                ])
              )
            ]),
            Plurimath::Math::Number.new("33")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when Sum contains color function" do
      let(:string) { "sum_(i=color{1}{3})^33" }
      it "returns Sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Function::Color.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("3")
                ])
              )
            ]),
            Plurimath::Math::Number.new("33")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when Sum contains color function with single arg" do
      let(:string) { 'sum_(i=color{"blue"})^33' }
      it "returns Sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Function::Color.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::Text.new("blue")
                ])
              )
            ]),
            Plurimath::Math::Number.new("33")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains F function and symbols" do
      let(:string) { "int_0^1f(x)dx" }
      it "returns F formula including symbols" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("int"),
          Plurimath::Math::Symbol.new("_"),
          Plurimath::Math::Number.new("0"),
          Plurimath::Math::Symbol.new("^"),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Function::F.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("x")
            ])
          ),
          Plurimath::Math::Symbol.new("d"),
          Plurimath::Math::Symbol.new("x"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains obrace function and other values" do
      let(:string) { 'obrace(1+2+3+4)^("4 terms")' }
      it "returns obrace formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Obrace.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("4")
            ])
          ),
          Plurimath::Math::Symbol.new("^"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("4 terms")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains only obrace function" do
      let(:string) { 'obrace(1+2+3+4)' }
      it "returns obrace formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Obrace.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("4")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains complete log function" do
      let(:string) { 'log_(1+2+3+4)^("4 terms")' }
      it "returns log formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("4")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("4 terms")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains log function with base only" do
      let(:string) { 'log_(1+2+3+4)' }
      it "returns log formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("4")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains root function without base parenthesis" do
      let(:string) { 'root1234(i)' }
      it "returns root formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Root.new(
            Plurimath::Math::Number.new("1234"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains root function" do
      let(:string) { 'root(1234)(i)' }
      it "returns root formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Root.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1234")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains overset function" do
      let(:string) { 'overset(1234)(i)' }
      it "returns overset formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1234")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains overset function without base parenthesis" do
      let(:string) { 'overset1234(i)' }
      it "returns overset formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Number.new("1234"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains underset function" do
      let(:string) { 'underset(1234)(i)' }
      it "returns underset formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1234")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains underset function without base parenthesis" do
      let(:string) { 'underset1234(i)' }
      it "returns underset formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Number.new("1234"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains mod function without divisor parenthesis" do
      let(:string) { '12mod1234(i)' }
      it "returns mod formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Number.new("12"),
            Plurimath::Math::Number.new("1234")
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("i"),
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains mod function with divisor parenthesis" do
      let(:string) { '12mod(1234)(i)' }
      it "returns mod formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Number.new("12"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1234")
            ])
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("i"),
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sum function with exponent only number" do
      let(:string) { 'sum^(theta)' }
      it "returns sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            nil,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("theta")
            ]),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sum function with base only number" do
      let(:string) { 'sum_3' }
      it "returns sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Number.new("3"),
            nil,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sum function with exponent only number" do
      let(:string) { 'sum^3' }
      it "returns sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            nil,
            Plurimath::Math::Number.new("3"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sum function with base only symbol" do
      let(:string) { 'sum_i' }
      it "returns sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbol.new("i"),
            nil,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sum function with base only unary class arg number" do
      let(:string) { 'sum_sin114' }
      it "returns sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Function::Sin.new(
              Plurimath::Math::Number.new("114")
            ),
            nil,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sum function with base only unary class arg symbol" do
      let(:string) { 'sum_sini' }
      it "returns sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Function::Sin.new(
              Plurimath::Math::Symbol.new("i")
            ),
            nil,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sum function with base only unary class no arg" do
      let(:string) { 'sum_sin' }
      it "returns sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Function::Sin.new,
            nil,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sum function only" do
      let(:string) { 'sum' }
      it "returns sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sum function only exponent symbol" do
      let(:string) { 'sum^w' }
      it "returns sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            nil,
            Plurimath::Math::Symbol.new("w"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains obrace function" do
      let(:string) { 'obrace(1+2+3+4)^text(4 terms)' }
      it "returns obrace formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Obrace.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("4"),
            ])
          ),
          Plurimath::Math::Symbol.new("^"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("4 terms")
          ]),
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
