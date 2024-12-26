require "spec_helper"

RSpec.describe Plurimath::Asciimath::Parser do

  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    context "when contains Cos function string" do
      let(:string) { "unitsml(V*s//A,symbol:V cdot s//A)" }

      it "returns Cos formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Symbol.new("u"),
          Plurimath::Math::Symbols::Symbol.new("n"),
          Plurimath::Math::Symbols::Symbol.new("i"),
          Plurimath::Math::Symbols::Symbol.new("t"),
          Plurimath::Math::Symbols::Symbol.new("s"),
          Plurimath::Math::Symbols::Symbol.new("m"),
          Plurimath::Math::Symbols::Symbol.new("l"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("V"),
              Plurimath::Math::Symbols::Cdot.new,
              Plurimath::Math::Symbols::Symbol.new("s"),
              Plurimath::Math::Symbols::Mathslash.new,
              Plurimath::Math::Symbols::Symbol.new("A"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Symbols::Symbol.new("s"),
              Plurimath::Math::Symbols::Symbol.new("y"),
              Plurimath::Math::Symbols::Symbol.new("m"),
              Plurimath::Math::Symbols::Symbol.new("b"),
              Plurimath::Math::Symbols::Symbol.new("o"),
              Plurimath::Math::Symbols::Symbol.new("l"),
              Plurimath::Math::Symbols::Mathcolon.new,
              Plurimath::Math::Symbols::Symbol.new("V"),
              Plurimath::Math::Symbols::Cdot.new,
              Plurimath::Math::Symbols::Symbol.new("s"),
              Plurimath::Math::Symbols::Mathslash.new,
              Plurimath::Math::Symbols::Symbol.new("A")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains simple comma separated string" do
      let(:string) { "(a,a)" }

      it "returns Cos formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("a"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Symbols::Symbol.new("a")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains simple comma and alphabet string" do
      let(:string) { "a," }

      it "returns Cos formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Symbol.new("a"),
          Plurimath::Math::Symbols::Comma.new,
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains Cos function string" do
      let(:string) { "cos(2)" }

      it "returns Cos formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Cos.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Number.new("2"),
              ],
              Plurimath::Math::Symbols::Paren::Rround.new,
            )
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains Sum function string" do
      let(:string) { "sum(2)" }

      it "returns Cos Formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Number.new("2")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
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
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Function::Cos.new(
                  Plurimath::Math::Function::Fenced.new(
                    Plurimath::Math::Symbols::Paren::Lcurly.new,
                    [
                      Plurimath::Math::Symbols::Theta.new,
                    ],
                    Plurimath::Math::Symbols::Paren::Rcurly.new,
                  )
                ),
              ],
              Plurimath::Math::Symbols::Paren::Rround.new,
            )
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
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Function::Sum.new(
                  Plurimath::Math::Symbols::Theta.new
                ),
              ],
              Plurimath::Math::Symbols::Paren::Rround.new,
            )
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
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Function::Sum.new(
                  Plurimath::Math::Symbols::Theta.new,
                  Plurimath::Math::Number.new("3")
                ),
              ],
              Plurimath::Math::Symbols::Paren::Rround.new,
            )
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
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Function::Sum.new(
                  Plurimath::Math::Symbols::Theta.new,
                  Plurimath::Math::Function::Sin.new(
                    Plurimath::Math::Function::Fenced.new(
                      Plurimath::Math::Symbols::Paren::Lround.new,
                      [
                        Plurimath::Math::Symbols::Theta.new,
                      ],
                      Plurimath::Math::Symbols::Paren::Rround.new,
                    )
                  )
                ),
              ],
              Plurimath::Math::Symbols::Paren::Rround.new,
            )
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
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Function::Sum.new(
                  Plurimath::Math::Symbols::Theta.new,
                  Plurimath::Math::Function::Sin.new(
                    Plurimath::Math::Function::Fenced.new(
                      Plurimath::Math::Symbols::Paren::Lround.new,
                      [
                        Plurimath::Math::Symbols::Cong.new,
                      ],
                      Plurimath::Math::Symbols::Paren::Rround.new,
                    )
                  )
                ),
              ],
              Plurimath::Math::Symbols::Paren::Rround.new,
            )
          ),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lsquare.new,
            [
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("1")
            ],
            Plurimath::Math::Symbols::Paren::Rsquare.new
          )
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
              Plurimath::Math::Symbols::Symbol.new("i"),
              Plurimath::Math::Symbols::Equal.new,
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Symbols::Symbol.new("n"),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbols::Symbol.new("i"),
              Plurimath::Math::Number.new("3")
            ),
          ),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Sin.new(
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbols::Paren::Lround.new,
                [
                  Plurimath::Math::Function::Frac.new(
                    Plurimath::Math::Symbols::Symbol.new("n"),
                    Plurimath::Math::Number.new("2")
                  ),
                ],
                Plurimath::Math::Symbols::Paren::Rround.new,
              ),
            ),
            Plurimath::Math::Number.new("2")
          )
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
              Plurimath::Math::Symbols::Symbol.new("i"),
              Plurimath::Math::Symbols::Equal.new,
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Number.new("3")
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
              Plurimath::Math::Symbols::Symbol.new("i"),
              Plurimath::Math::Symbols::Equal.new,
              Plurimath::Math::Function::Frac.new(
                Plurimath::Math::Number.new("13")
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
              Plurimath::Math::Symbols::Symbol.new("i"),
              Plurimath::Math::Symbols::Equal.new,
              Plurimath::Math::Function::Color.new(
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("1"),
                ]),
                Plurimath::Math::Number.new("3")
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
              Plurimath::Math::Symbols::Symbol.new("i"),
              Plurimath::Math::Symbols::Equal.new,
              Plurimath::Math::Symbols::Symbol.new("c"),
              Plurimath::Math::Symbols::Symbol.new("o"),
              Plurimath::Math::Symbols::Symbol.new("l"),
              Plurimath::Math::Symbols::Symbol.new("o"),
              Plurimath::Math::Symbols::Symbol.new("r"),
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbols::Paren::Lcurly.new,
                [Plurimath::Math::Function::Text.new("blue")],
                Plurimath::Math::Symbols::Paren::Rcurly.new,
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
          Plurimath::Math::Function::Int.new(
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Symbols::Symbol.new("f"),
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("x")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new,
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbols::Symbol.new("d"),
            Plurimath::Math::Symbols::Symbol.new("x")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains obrace function and other values" do
      let(:string) { 'obrace(1+2+3+4)^("4 terms")' }

      it "returns obrace formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Obrace.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("4")
              ])
            ),
            Plurimath::Math::Function::Text.new("4 terms")
          )
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
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Plus.new,
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
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("4")
            ]),
            Plurimath::Math::Function::Text.new("4 terms")
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
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Plus.new,
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
            Plurimath::Math::Symbols::Symbol.new("i")
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
            Plurimath::Math::Number.new("1234"),
            Plurimath::Math::Symbols::Symbol.new("i")
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
            Plurimath::Math::Number.new("1234"),
            Plurimath::Math::Symbols::Symbol.new("i")
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
            Plurimath::Math::Symbols::Symbol.new("i")
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
            Plurimath::Math::Number.new("1234"),
            Plurimath::Math::Symbols::Symbol.new("i")
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
            Plurimath::Math::Symbols::Symbol.new("i")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sum function with power parenthesis" do
      let(:string) { 'sum^2' }

      it "returns sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            nil,
            Plurimath::Math::Number.new("2")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains underset function with power number" do
      let(:string) { 'underset1234(i)^3' }

      it "returns underset formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Underset.new(
              Plurimath::Math::Number.new("1234"),
              Plurimath::Math::Symbols::Symbol.new("i")
            ),
            Plurimath::Math::Number.new("3")
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
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("i")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          )
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
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Number.new("1234")
              ],
              Plurimath::Math::Symbols::Paren::Rround.new,
            )
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("i")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          )
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
            Plurimath::Math::Symbols::Theta.new
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
            Plurimath::Math::Symbols::Symbol.new("i"),
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
              Plurimath::Math::Symbols::Symbol.new("i")
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

    context "when contains sum function with exponent only unary class no arg" do
      let(:string) { 'sum^sin' }

      it "returns sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            nil,
            Plurimath::Math::Function::Sin.new,
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
            Plurimath::Math::Symbols::Symbol.new("w"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains obrace function" do
      let(:string) { 'obrace(1+2+3+4)^text(4 terms)' }

      it "returns obrace formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Obrace.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("4")
              ])
            ),
            Plurimath::Math::Function::Text.new("4 terms"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains log function with abs function" do
      let(:string) { 'log(1+2+3+4)^abs(theta)' }

      it "returns log formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new,
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("4")
              ],
              Plurimath::Math::Symbols::Paren::Rround.new,
            ),
            Plurimath::Math::Function::Abs.new(
              Plurimath::Math::Symbols::Theta.new
            )
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains log function" do
      let(:string) { 'log(1+2+3+4)^"theta"' }

      it "returns log formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new,
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("4")
              ],
              Plurimath::Math::Symbols::Paren::Rround.new,
            ),
            Plurimath::Math::Function::Text.new("theta")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains log function" do
      let(:string) { 'log(1+2+3+4)^text("theta")' }

      it "returns log formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new,
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("4")
              ],
              Plurimath::Math::Symbols::Paren::Rround.new,
            ),
            Plurimath::Math::Function::Text.new("\"theta\""),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sin and sum function" do
      let(:string) { 'i_sin = sum' }

      it "returns simple formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbols::Symbol.new("i"),
            Plurimath::Math::Function::Sin.new(
              Plurimath::Math::Symbols::Equal.new
            )
          ),
          Plurimath::Math::Function::Sum.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sin function" do
      let(:string) { 'sin_i' }

      it "returns sin formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Sin.new,
            Plurimath::Math::Symbols::Symbol.new("i"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sin function" do
      let(:string) { 'sin_(i)' }

      it "returns sin formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Sin.new,
            Plurimath::Math::Symbols::Symbol.new("i")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sin function" do
      let(:string) { 'sin^(i)' }

      it "returns sin formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Sin.new,
            Plurimath::Math::Symbols::Symbol.new("i")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sin function" do
      let(:string) { 'sin_d^(i)1+1' }

      it "returns sin formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Sin.new,
            Plurimath::Math::Symbols::Symbol.new("d"),
            Plurimath::Math::Symbols::Symbol.new("i")
          ),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbols::Plus.new,
          Plurimath::Math::Number.new("1")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sin function" do
      let(:string) { 'sin_d^(i) = sin(1)' }

      it "returns sin formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Sin.new,
            Plurimath::Math::Symbols::Symbol.new("d"),
            Plurimath::Math::Symbols::Symbol.new("i")
          ),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Number.new("1")
              ],
              Plurimath::Math::Symbols::Paren::Rround.new,
            )
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sum function" do
      let(:string) { "sum_(i=1)^ni^3=sin((n(n+1))/2)^2" }

      it "returns sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("i"),
              Plurimath::Math::Symbols::Equal.new,
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Symbols::Symbol.new("n"),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbols::Symbol.new("i"),
              Plurimath::Math::Number.new("3")
            ),
          ),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Sin.new(
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbols::Paren::Lround.new,
                [
                  Plurimath::Math::Function::Frac.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbols::Symbol.new("n"),
                      Plurimath::Math::Function::Fenced.new(
                        Plurimath::Math::Symbols::Paren::Lround.new,
                        [
                          Plurimath::Math::Symbols::Symbol.new("n"),
                          Plurimath::Math::Symbols::Plus.new,
                          Plurimath::Math::Number.new("1")
                        ],
                        Plurimath::Math::Symbols::Paren::Rround.new
                      )
                    ]),
                    Plurimath::Math::Number.new("2")
                  ),
                ],
                Plurimath::Math::Symbols::Paren::Rround.new,
              )
            ),
            Plurimath::Math::Number.new("2")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains log function" do
      let(:string) { 'log(1+2+3+4)^("4 terms")' }

      it "returns log formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new,
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Number.new("4")
              ],
              Plurimath::Math::Symbols::Paren::Rround.new,
            ),
            Plurimath::Math::Function::Text.new("4 terms")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains prod function" do
      let(:string) { "prod_(theta) (i)" }

      it "returns prod formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Theta.new,
            nil,
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Symbols::Symbol.new("i")
              ],
              Plurimath::Math::Symbols::Paren::Rround.new
            )
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains mathfrak fontstyle without parenthesis" do
      let(:string) { "mathfrak\"theta\" (i)" }

      it "returns prod formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle::Fraktur.new(
            Plurimath::Math::Function::Text.new("theta"),
            "mathfrak"
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("i")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains mathbb fontstyle with parenthesis" do
      let(:string) { "mathbb(\"theta\") (i)" }

      it "returns prod formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle::DoubleStruck.new(
            Plurimath::Math::Function::Text.new("theta"),
            "mathbb"
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("i")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains cc fontstyle with symbol" do
      let(:string) { "cc(theta) (i)" }

      it "returns prod formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle::Script.new(
            Plurimath::Math::Symbols::Theta.new,
            "cc"
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("i")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains table values" do
      let(:string) { "([1,3], [1,3])" }

      it "returns prod formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("3")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("3")
                ])
              ])
            ],
            Plurimath::Math::Symbols::Paren::Lround.new,
            Plurimath::Math::Symbols::Paren::Rround.new,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains table values" do
      let(:string) { "([1,3], [1,3], [1,3])" }

      it "returns prod formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("3"),
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("3"),
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("3"),
                ])
              ]),
            ],
            Plurimath::Math::Symbols::Paren::Lround.new,
            Plurimath::Math::Symbols::Paren::Rround.new,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains left right with table values" do
      let(:string) { "left[[1,3], [1,3], [1,3]right]" }

      it "returns prod formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("3")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("3")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("3")
                ])
              ]),
            ],
            Plurimath::Math::Symbols::Paren::Lsquare.new,
            Plurimath::Math::Symbols::Paren::Rsquare.new,
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains left right values" do
      let(:string) { "left(sum_prod^sigmaright)" }

      it "returns prod formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Left.new("("),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Function::Prod.new,
            Plurimath::Math::Symbols::Sigma.new
          ),
          Plurimath::Math::Function::Right.new(")")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains simple decimal" do
      let(:string) { "0.1" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("0.1")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains numeric value" do
      let(:string) { ".1" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Period.new,
          Plurimath::Math::Number.new("1"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains nagative decimal value" do
      let(:string) { "-0.1" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Minus.new,
          Plurimath::Math::Number.new("0.1")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains nagative value" do
      let(:string) { "-.1" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Minus.new,
          Plurimath::Math::Symbols::Period.new,
          Plurimath::Math::Number.new("1"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains long comma separated string" do
      let(:string) do
        <<~ASCIIMATH
          (
            2, 2, 3, 1, 3, 2, 3, 2, 1, 3, 1, 1, 2, 3, 1,
            1, 2, 2, 2, 3, 3, 2, 3, 2, 3, 1, 2, 2, 3, 3,
            2, 2, 2, 1, 3, 3, 3, 2, 3, 2, 1, 3, 2, 3, 1,
            2, 2, 3, 1, 1, 3, 2, 3, 2, 3, 1, 2, 2, 3, 3,
            2, 2, 2, 1, 3, 3, 3, 2, 3, 2, 1, 2, 2, 3, 3,
            3, 2, 3, 2, 1, 2, 2, 2, 1, 3, 3, 3, 2, 3, 2,
            1, 3, 2, 3, 1, 2, 2, 3, 1, 1
          )
        ASCIIMATH
      end

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Number.new("1")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new,
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sum as ternary class with all values example" do
      let(:string) { "a(ii(W) - 1) + b(ii(W)-1)^2 + sum_{i=1}^5 c_i [ln(ii(W))\ " }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Symbol.new("a"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Function::FontStyle::Italic.new(
                Plurimath::Math::Symbols::Symbol.new("W"),
                "ii"
              ),
              Plurimath::Math::Symbols::Minus.new,
              Plurimath::Math::Number.new("1")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new,
          ),
          Plurimath::Math::Symbols::Plus.new,
          Plurimath::Math::Symbols::Symbol.new("b"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbols::Paren::Lround.new,
              [
                Plurimath::Math::Function::FontStyle::Italic.new(
                  Plurimath::Math::Symbols::Symbol.new("W"),
                  "ii",
                ),
                Plurimath::Math::Symbols::Minus.new,
                Plurimath::Math::Number.new("1")
              ],
              Plurimath::Math::Symbols::Paren::Rround.new,
            ),
            Plurimath::Math::Number.new("2"),
          ),
          Plurimath::Math::Symbols::Plus.new,
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("i"),
              Plurimath::Math::Symbols::Equal.new,
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Number.new("5"),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Symbols::Symbol.new("c"),
              Plurimath::Math::Symbols::Symbol.new("i")
            )
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lsquare.new,
            [
              Plurimath::Math::Function::Ln.new(
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbols::Paren::Lround.new,
                  [
                    Plurimath::Math::Function::FontStyle::Italic.new(
                      Plurimath::Math::Symbols::Symbol.new("W"),
                      "ii"
                    )
                  ],
                  Plurimath::Math::Symbols::Paren::Rround.new
                )
              ),
            ],
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains int as ternary class with no values example" do
      let(:string) { 'ii(phi)_"V" = int int ii(I)_"V" (ii(theta),ii(phi)) sin ii(theta) "&#x200c;" " d" ii(phi) " d" ii(theta)' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::FontStyle::Italic.new(
              Plurimath::Math::Symbols::Varphi.new,
              "ii"
            ),
            Plurimath::Math::Function::Text.new("V")
          ),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Function::Int.new,
          Plurimath::Math::Function::Int.new,
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::FontStyle::Italic.new(
              Plurimath::Math::Symbols::Symbol.new("I"),
              "ii"
            ),
            Plurimath::Math::Function::Text.new("V")
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Function::FontStyle::Italic.new(
                Plurimath::Math::Symbols::Theta.new,
                "ii"
              ),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Function::FontStyle::Italic.new(
                Plurimath::Math::Symbols::Varphi.new,
                "ii"
              )
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          ),
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Function::FontStyle::Italic.new(
              Plurimath::Math::Symbols::Theta.new,
              "ii",
            )
          ),
          Plurimath::Math::Function::Text.new("&#x200c;"),
          Plurimath::Math::Function::Text.new(" d"),
          Plurimath::Math::Function::FontStyle::Italic.new(
            Plurimath::Math::Symbols::Varphi.new,
            "ii"
          ),
          Plurimath::Math::Function::Text.new(" d"),
          Plurimath::Math::Function::FontStyle::Italic.new(
            Plurimath::Math::Symbols::Theta.new,
            "ii"
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example extracted from metanorma/site #1" do
      let(:string) { "540 xx 10^(12) \"unitsml(Hz)\", \" \"ii(K)_(\"cd\")" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("540"),
          Plurimath::Math::Symbols::Times.new,
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Number.new("10"),
            Plurimath::Math::Number.new("12"),
          ),
          Plurimath::Math::Function::Unitsml.new("Hz"),
          Plurimath::Math::Symbols::Comma.new,
          Plurimath::Math::Function::Text.new(" "),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::FontStyle::Italic.new(
              Plurimath::Math::Symbols::Symbol.new("K"),
              "ii",
            ),
            Plurimath::Math::Function::Text.new("cd")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example extracted from metanorma/site #2" do
      let(:string) { "m = (8 ii(V))/(a_0^3) (2ii(R)_(oo)h)/(c ii(alpha)^2) (m_(\"Si\"))/(m_\"e\")" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Symbol.new("m"),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("8"),
              Plurimath::Math::Function::FontStyle::Italic.new(
                Plurimath::Math::Symbols::Symbol.new("V"),
                "ii",
              )
            ]),
            Plurimath::Math::Function::PowerBase.new(
              Plurimath::Math::Symbols::Symbol.new("a"),
              Plurimath::Math::Number.new("0"),
              Plurimath::Math::Number.new("3"),
            )
          ),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::FontStyle::Italic.new(
                  Plurimath::Math::Symbols::Symbol.new("R"),
                  "ii",
                ),
                Plurimath::Math::Symbols::Oo.new
              ),
              Plurimath::Math::Symbols::Symbol.new("h")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("c"),
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Function::FontStyle::Italic.new(
                  Plurimath::Math::Symbols::Alpha.new,
                  "ii",
                ),
                Plurimath::Math::Number.new("2")
              )
            ]),
          ),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Symbols::Symbol.new("m"),
              Plurimath::Math::Function::Text.new("Si")
            ),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Symbols::Symbol.new("m"),
              Plurimath::Math::Function::Text.new("e")
            )
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example extracted from metanorma/site #3" do
      let(:string) { "hat ii(V)_(\"cal\",i)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Function::FontStyle::Italic.new(
                Plurimath::Math::Symbols::Symbol.new("V"),
                "ii"
              ),
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("cal"),
              Plurimath::Math::Symbols::Comma.new,
              Plurimath::Math::Symbols::Symbol.new("i")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
