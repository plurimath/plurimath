require_relative "../../../lib/plurimath/math"

RSpec.describe Plurimath::Asciimath::Parser do

  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    context "when contains Cos function string" do
      let(:string) { "cos(2)" }

      it "returns Cos formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Cos.new(
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Number.new("2"),
              ],
              true,
            )
          )]
        )
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains Sum function string" do
      let(:string) { "sum(2)" }

      it "returns Cos Formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Number.new("2"),
            ],
            true,
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Function::Cos.new(
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Symbol.new("theta")
                    ],
                    true,
                  )
                )
              ],
              true,
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Function::Sum.new(
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Symbol.new("theta"),
                    ],
                    true,
                  ),
                  nil
                )
              ],
              true,
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Function::Sum.new(
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Symbol.new("theta"),
                    ],
                    true,
                  ),
                  Plurimath::Math::Number.new("3"),
                )
              ],
              true,
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Function::Sum.new(
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Symbol.new("theta"),
                    ],
                    true,
                  ),
                  Plurimath::Math::Function::Sin.new(
                    Plurimath::Math::Formula.new(
                      [
                        Plurimath::Math::Symbol.new("theta")
                      ],
                      true
                    )
                  )
                )
              ],
              true,
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Function::Sum.new(
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Symbol.new("theta"),
                    ],
                    true,
                  ),
                  Plurimath::Math::Function::Sin.new(
                    Plurimath::Math::Formula.new(
                      [
                        Plurimath::Math::Symbol.new("cong")
                      ],
                      true,
                    )
                  )
                )
              ],
              true,
            )
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("1")
            ],
            true,
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i"),
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Number.new("1")
              ],
              true,
            ),
            Plurimath::Math::Symbol.new("n")
          ),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Number.new("3"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Sin.new(
                Plurimath::Math::Formula.new(
                  [
                    Plurimath::Math::Symbol.new("n"),
                    Plurimath::Math::Symbol.new("/"),
                    Plurimath::Math::Number.new("2"),
                  ],
                  true,
                )
              ),
              Plurimath::Math::Number.new("2"),
            )
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when Sum contains frac function" do
      let(:string) { "sum_(i=frac{1}{3})^33" }

      it "returns Sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i"),
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Function::Frac.new(
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Number.new("1"),
                    ],
                    true,
                  ),
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Number.new("3"),
                    ],
                    true,
                  ),
                )
              ],
              true,
            ),
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i"),
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Function::Frac.new(
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Number.new("13")
                    ],
                    true
                  )
                )
              ],
              true
            ),
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i"),
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Function::Color.new(
                Plurimath::Math::Function::Text.new("1"),
                Plurimath::Math::Formula.new(
                  [
                    Plurimath::Math::Number.new("3")
                  ],
                  true,
                )
              )
              ],
              true
            ),
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i"),
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Function::Color.new(
                Plurimath::Math::Function::Text.new("\"blue\"")
              )
              ],
              true,
            ),
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
          ),
          Plurimath::Math::Function::F.new(
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("x")
              ],
              true,
            ),
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
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Obrace.new(
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Number.new("1"),
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Number.new("2"),
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Number.new("3"),
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Number.new("4")
                ],
                true
              )
            ),
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Function::Text.new("4 terms"),
              ],
              true,
            )
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("4")
              ],
              true,
            )
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("4")
              ],
              true,
            ),
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Function::Text.new("4 terms")
              ],
              true,
            )
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("4")
              ],
              true
            )
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i"),
              ],
              true,
            ),
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Number.new("1234"),
              ],
              true,
            ),
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i")
              ],
              true,
            ),
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Number.new("1234"),
              ],
              true,
            ),
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i")
              ],
              true,
            ),
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i")
              ],
              true,
            ),
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Number.new("1234"),
              ],
              true,
            ),
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i")
              ],
              true,
            )
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i")
              ],
              true,
            )
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
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Symbol.new("i")
                ],
                true,
              )
            ),
            Plurimath::Math::Number.new("3"),
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
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Symbol.new("i"),
            ],
            true,
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Number.new("1234")
              ],
              true,
            )
          ),
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Symbol.new("i"),
            ],
            true,
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("theta")
              ],
              true,
            )
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
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Obrace.new(
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Number.new("1"),
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Number.new("2"),
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Number.new("3"),
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Number.new("4"),
                ]
              )
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("4"),
              ],
              true,
            ),
            Plurimath::Math::Function::Abs.new(
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Symbol.new("theta")
                ],
                true,
              )
            ),
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("4"),
              ],
              true,
            ),
            Plurimath::Math::Function::Text.new("theta"),
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("4"),
              ],
              true,
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
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Function::Sin.new(
              Plurimath::Math::Symbol.new("="),
            ),
          ),
          Plurimath::Math::Function::Sum.new,
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
            Plurimath::Math::Symbol.new("i"),
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i"),
              ],
              true,
            )
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i"),
              ],
              true,
            )
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
            Plurimath::Math::Symbol.new("d"),
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i"),
              ],
              true,
            )
          ),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Number.new("1"),
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
            Plurimath::Math::Symbol.new("d"),
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i"),
              ],
              true,
            )
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Function::Sin.new(
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Number.new("1")
                ],
                true,
              )
            ),
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains sum function" do
      let(:string) { "sum_(i=1)^ni^3=sin((n(n+1))/2)^2" }

      it "returns sum formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("i"),
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Number.new("1"),
              ],
              true
            ),
            Plurimath::Math::Symbol.new("n"),
          ),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Symbol.new("3"),
          ),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Sin.new(
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Symbol.new("n"),
                      Plurimath::Math::Formula.new(
                        [
                          Plurimath::Math::Symbol.new("n"),
                          Plurimath::Math::Symbol.new("+"),
                          Plurimath::Math::Number.new("1"),
                        ],
                        true,
                      )
                    ],
                    true,
                  ),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Number.new("2"),
                ],
                true,
              ),
            ),
            Plurimath::Math::Number.new("2"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains int function" do
      let(:string) { "int_0^1 f(x)dx" }

      it "returns int formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Int.new(
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::F.new(
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Symbol.new("x")
                ],
                true,
              )
            ),
            Plurimath::Math::Symbol.new("d"),
            Plurimath::Math::Symbol.new("x"),
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains log function" do
      let(:string) { "log(1+2+3+4)^(\"4 terms\")" }

      it "returns log formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new,
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("3"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("4"),
              ],
              true,
            ),
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Function::Text.new("4 terms"),
              ],
              true,
            )
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("theta"),
              ],
              true,
            ),
            nil,
          ),
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Symbol.new("i"),
            ],
            true,
          )
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
            "mathfrak",
          ),
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Symbol.new("i"),
            ],
            true,
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Function::Text.new("theta"),
              ],
              true,
            ),
            "mathbb",
          ),
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Symbol.new("i"),
            ],
            true,
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("theta"),
              ],
              true
            ),
            "cc",
          ),
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Symbol.new("i"),
            ],
            true
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
            "(",
            ")",
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
            "(",
            ")",
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
            "(",
            ")",
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains left right with table values" do
      let(:string) { "left[[1,3], [1,3], [1,3]right]" }

      it "returns prod formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Left.new("["),
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
            "",
            "",
          ),
          Plurimath::Math::Function::Right.new("]"),
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
            Plurimath::Math::Symbol.new("sigma"),
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
          Plurimath::Math::Number.new(".1"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains nagative decimal value" do
      let(:string) { "-0.1" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Number.new("0.1"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains nagative value" do
      let(:string) { "-.1" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("-"),
          Plurimath::Math::Number.new(".1"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #01" do
      let(:string) { "underset(_)(hat A) = hat A exp j vartheta_0" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("_"),
              ],
              true
            ),
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Function::Hat.new(
                  Plurimath::Math::Symbol.new("A"),
                ),
              ],
              true,
            )
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Hat.new(
                Plurimath::Math::Symbol.new("A"),
              ),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Exp.new(
                  Plurimath::Math::Symbol.new("j"),
                ),
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Symbol.new("vartheta"),
                  Plurimath::Math::Number.new("0"),
                )
              ])
            ])
          ])
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
          Plurimath::Math::Symbol.new("b"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Symbol.new("a")
            ],
            true
          ),
          Plurimath::Math::Symbol.new("<"),
          Plurimath::Math::Symbol.new("+-"),
          Plurimath::Math::Function::Sqrt.new(
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Formula.new(
                  [
                    Plurimath::Math::Function::Power.new(
                      Plurimath::Math::Symbol.new("b"),
                      Plurimath::Math::Number.new("2"),
                    ),
                  ],
                  true
                ),
                Plurimath::Math::Symbol.new("/"),
                Plurimath::Math::Formula.new(
                  [
                    Plurimath::Math::Number.new("4"),
                    Plurimath::Math::Function::Power.new(
                    Plurimath::Math::Symbol.new("a"),
                    Plurimath::Math::Number.new("2"),
                  )
                  ],
                  true
                ),
                Plurimath::Math::Symbol.new("-"),
                Plurimath::Math::Symbol.new("c"),
                Plurimath::Math::Symbol.new("/"),
                Plurimath::Math::Symbol.new("a")
              ],
              true
            )
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
            Plurimath::Math::Number.new("2"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbol.new("b"),
                Plurimath::Math::Number.new("2"),
              ),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbol.new("c"),
                  Plurimath::Math::Number.new("2"),
                )
              ])
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #04" do
      let(:string) { "x = (-b+-sqrt(b^2-4ac))/(2a)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("-"),
                Plurimath::Math::Symbol.new("b"),
                Plurimath::Math::Symbol.new("+-"),
                Plurimath::Math::Function::Sqrt.new(
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Function::Power.new(
                      Plurimath::Math::Symbol.new("b"),
                      Plurimath::Math::Number.new("2"),
                    ),
                    Plurimath::Math::Symbol.new("-"),
                    Plurimath::Math::Number.new("4"),
                    Plurimath::Math::Symbol.new("a"),
                    Plurimath::Math::Symbol.new("c"),
                  ])
                )
              ]),
              Plurimath::Math::Symbol.new("/"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbol.new("a")
              ])
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #05" do
      let(:string) { "m = (y_2 - y_1)/(x_2 - x_1) = (Deltay)/(Deltax)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("m"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Symbol.new("y"),
                  Plurimath::Math::Number.new("2"),
                ),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("-"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("y"),
                    Plurimath::Math::Number.new("1"),
                  )
                ])
              ]),
              Plurimath::Math::Symbol.new("/"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Number.new("2"),
                ),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("-"),
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("x"),
                    Plurimath::Math::Number.new("1"),
                  )
                ])
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("Delta"),
                    Plurimath::Math::Symbol.new("y"),
                  ]),
                  Plurimath::Math::Symbol.new("/"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("Delta"),
                    Plurimath::Math::Symbol.new("x")
                  ])
                ])
              ])
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #06" do
      let(:string) { "f\'(x) = lim_(Deltax->0)(f(x+Deltax)-f(x))/(Deltax)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::F.new(
            Plurimath::Math::Symbol.new("'")
          ),
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Symbol.new("x"),
            ],
            true
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Lim.new(
                Plurimath::Math::Formula.new(
                  [
                    Plurimath::Math::Symbol.new("Delta"),
                    Plurimath::Math::Symbol.new("x"),
                    Plurimath::Math::Symbol.new("->"),
                    Plurimath::Math::Number.new("0")
                  ],
                  true
                ),
                nil,
              ),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::F.new(
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Symbol.new("x"),
                      Plurimath::Math::Symbol.new("+"),
                      Plurimath::Math::Symbol.new("Delta"),
                      Plurimath::Math::Symbol.new("x")
                    ],
                    true
                  )
                ),
                Plurimath::Math::Symbol.new("-"),
                Plurimath::Math::Function::F.new(
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Symbol.new("x")
                    ],
                    true
                  )
                )
              ]),
              Plurimath::Math::Symbol.new("/"),
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Symbol.new("Delta"),
                  Plurimath::Math::Symbol.new("x")
                ],
                true
              )
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #07" do
      let(:string) { "d/dx [x^n] = nx^(n - 1)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("d"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Symbol.new("d"),
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Symbol.new("n"),
                ),
              ],
              true
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("n"),
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Symbol.new("n"),
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Symbol.new("-"),
                        Plurimath::Math::Number.new("1")
                      ])
                    ],
                    true
                  )
                )
              ])
            ])
          ])
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
            Plurimath::Math::Symbol.new("b"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::F.new(
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Symbol.new("x"),
                ],
                true
              )
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("d"),
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::PowerBase.new(
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("F"),
                      Plurimath::Math::Formula.new(
                        [
                          Plurimath::Math::Symbol.new("x"),
                        ],
                        true
                      )
                    ]),
                    Plurimath::Math::Symbol.new("a"),
                    Plurimath::Math::Symbol.new("b"),
                  ),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("="),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("F"),
                      Plurimath::Math::Formula.new(
                        [
                          Plurimath::Math::Symbol.new("b"),
                        ],
                        true
                      ),
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Symbol.new("-"),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("F"),
                          Plurimath::Math::Formula.new(
                            [
                              Plurimath::Math::Symbol.new("a")
                            ],
                            true
                          )
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
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
            Plurimath::Math::Symbol.new("b"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::F.new(
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Symbol.new("x"),
                ],
                true
              )
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("d"),
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::F.new(
                    Plurimath::Math::Formula.new(
                      [
                        Plurimath::Math::Symbol.new("c"),
                      ],
                      true
                    )
                  ),
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Symbol.new("b"),
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Symbol.new("-"),
                        Plurimath::Math::Symbol.new("a")
                      ])
                    ],
                    true
                  )
                ])
              ])
            ])
          ])
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
            Plurimath::Math::Number.new("2"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("b"),
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("c"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("="),
                    Plurimath::Math::Number.new("0")
                  ])
                ])
              ])
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #11" do
      let(:string) { "\"average value\"=1/(b-a) int_a^b f(x) dx" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("average value"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Symbol.new("b"),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Symbol.new("a")
            ],
            true
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Int.new(
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Symbol.new("b"),
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::F.new(
                Plurimath::Math::Formula.new(
                  [
                    Plurimath::Math::Symbol.new("x"),
                  ],
                  true
                )
              ),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("d"),
                Plurimath::Math::Symbol.new("x")
              ])
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #12" do
      let(:string) { "d/dx[int_a^x f(t) dt] = f(x)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("d"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Symbol.new("d"),
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Function::Int.new(
                Plurimath::Math::Symbol.new("a"),
                Plurimath::Math::Symbol.new("x"),
              ),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::F.new(
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Symbol.new("t"),
                    ],
                    true
                  )
                ),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("d"),
                  Plurimath::Math::Symbol.new("t")
                ])
              ])
            ],
            true,
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Function::F.new(
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Symbol.new("x"),
                ],
                true
              )
            )
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #13" do
      let(:string) { "hat(ab) bar(xy) ul(A) vec(v)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("a"),
                Plurimath::Math::Symbol.new("b")
              ],
              true
            )
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Bar.new(
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Symbol.new("y")
                ],
                true
              )
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Ul.new(
                Plurimath::Math::Formula.new(
                  [
                    Plurimath::Math::Symbol.new("A"),
                  ],
                  true
                )
              ),
              Plurimath::Math::Function::Vec.new(
                Plurimath::Math::Formula.new(
                  [
                    Plurimath::Math::Symbol.new("v")
                  ],
                  true
                )
              )
            ])
          ])
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Symbol.new("->"),
                Plurimath::Math::Symbol.new("c")
              ],
              true
            ),
            nil
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::F.new(
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Symbol.new("x")
                ],
                true,
              )
            ),
            Plurimath::Math::Symbol.new("-"),
            Plurimath::Math::Function::F.new(
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Symbol.new("c")
                ],
                true,
              )
            )
          ]),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Symbol.new("c")
            ],
            true
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
            Plurimath::Math::Formula.new(
              [
                Plurimath::Math::Symbol.new("pi"),
                Plurimath::Math::Symbol.new("/"),
                Plurimath::Math::Number.new("2")
              ],
              true
            )
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::G.new(
              Plurimath::Math::Formula.new(
                [
                  Plurimath::Math::Symbol.new("x")
                ],
                true
              )
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("d"),
              Plurimath::Math::Symbol.new("x")
            ])
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
              Plurimath::Math::Number.new("0"),
            ]),
            Plurimath::Math::Symbol.new("oo"),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("a"),
            Plurimath::Math::Symbol.new("n"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #18" do
      let(:string) { "([1],[42])" }

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
                    Plurimath::Math::Formula.new(
                      [
                        Plurimath::Math::Number.new("11"),
                      ],
                      true,
                    )
                  )
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("cdots")
                  ])
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::Base.new(
                    Plurimath::Math::Symbol.new("a"),
                    Plurimath::Math::Formula.new(
                      [
                        Plurimath::Math::Number.new("1"),
                        Plurimath::Math::Symbol.new("n")
                      ],
                      true
                    )
                  )
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("vdots")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("ddots"),
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Symbol.new("vdots")
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
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("cdots")
                  ])
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
            ")",
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
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("k"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("="),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("2"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("cdots"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("+"),
                    Plurimath::Math::Symbol.new("n"),
                    Plurimath::Math::Symbol.new("="),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("n"),
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Symbol.new("n"),
                        Plurimath::Math::Symbol.new("+"),
                        Plurimath::Math::Number.new("1")
                      ])
                    ]),
                    Plurimath::Math::Symbol.new("/"),
                    Plurimath::Math::Number.new("2")
                  ])
                ])
              ])
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #24" do
      let(:string) { "\"Скорость\"=(\"Расстояние\")/(\"Время\"" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("Скорость"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Function::Text.new("Расстояние"),
            ],
            true,
          ),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Function::Text.new("Время")
            ],
            true
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
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Symbol.new("b")
              ])
            ]),
            "bb",
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("+"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::FontStyle::Script.new(
                Plurimath::Math::Symbol.new("c"),
                "cc",
              ),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Function::FontStyle::Fraktur.new(
                  Plurimath::Math::Formula.new(
                    [
                      Plurimath::Math::Function::Power.new(
                        Plurimath::Math::Symbol.new("d"),
                        Plurimath::Math::Symbol.new("n"),
                      ),
                    ],
                    true,
                  ),
                  "fr",
                ),
              ])
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #26" do
      let(:string) { "max()" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Max.new(
            Plurimath::Math::Formula.new(
              [""],
              true
            )
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #27" do
      let(:string) { "text(\"foo\")" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("\"foo\"")
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
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("2")
              ])
            ])
          ),
          Plurimath::Math::Function::Obrace.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("4")
              ])
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
            Plurimath::Math::Symbol.new("'"),
            Plurimath::Math::Symbol.new("i")
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Function::Table.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("-"),
                      Plurimath::Math::Number.new("1")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("i"),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Function::F.new(
                          Plurimath::Math::Symbol.new("s")
                        ),
                        Plurimath::Math::Symbol.new("i")
                      ),
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Symbol.new(">"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("s"),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Symbol.new("i"),
                            Plurimath::Math::Formula.new([
                              Plurimath::Math::Symbol.new("+"),
                              Plurimath::Math::Number.new("1")
                            ])
                          ])
                        )
                      ])
                    ])
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("+"),
                      Plurimath::Math::Number.new("1")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("i"),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Function::F.new(
                          Plurimath::Math::Symbol.new("s")
                        ),
                        Plurimath::Math::Symbol.new("i")
                      ),
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Symbol.new("<="),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("s"),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Symbol.new("i"),
                            Plurimath::Math::Formula.new([
                              Plurimath::Math::Symbol.new("+"),
                              Plurimath::Math::Number.new("1")
                            ])
                          ])
                        )
                      ])
                    ])
                  ])
                ])
              ],
              "{",
              ":}",
            )
          ])
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
            Plurimath::Math::Symbol.new("'"),
            Plurimath::Math::Symbol.new("i")
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("="),
            Plurimath::Math::Function::Table.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new(nil)
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("i"),
                      Plurimath::Math::Function::Base.new(
                        Plurimath::Math::Function::F.new(
                          Plurimath::Math::Symbol.new("s")
                        ),
                        Plurimath::Math::Symbol.new("i")
                      ),
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Symbol.new(">"),
                        Plurimath::Math::Function::Base.new(
                          Plurimath::Math::Symbol.new("s"),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Symbol.new("i"),
                            Plurimath::Math::Formula.new([
                              Plurimath::Math::Symbol.new("+"),
                              Plurimath::Math::Number.new("1")
                            ])
                          ])
                        )
                      ])
                    ])
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("+"),
                      Plurimath::Math::Number.new("1")
                    ])
                  ]),
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new(nil)
                  ])
                ])
              ],
              "{",
              ":}",
            )
          ])
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
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Symbol.new("b")
              ])
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("c"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Symbol.new("d")
              ])
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
          Plurimath::Math::Symbol.new("frown"),
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
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::PowerBase.new(
                Plurimath::Math::Symbol.new("a"),
                Plurimath::Math::Symbol.new("c"),
                Plurimath::Math::Symbol.new("b"),
              ),
            ])
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
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::PowerBase.new(
                Plurimath::Math::Symbol.new("a"),
                Plurimath::Math::Symbol.new("b"),
                Plurimath::Math::Symbol.new("c"),
              ),
            ])
          ),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Cancel.new(
              Plurimath::Math::Symbol.new("a")
            ),
            Plurimath::Math::Symbol.new("b"),
            Plurimath::Math::Symbol.new("c"),
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
            Plurimath::Math::Function::Text.new("red"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("x"),
            ]),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Color.new(
              Plurimath::Math::Function::Text.new("red"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("y")
              ]),
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Color.new(
                Plurimath::Math::Function::Text.new("blue"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("z"),
                ]),
              ),
              Plurimath::Math::Function::Color.new(
                Plurimath::Math::Function::Text.new("blue"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Function::PowerBase.new(
                    Plurimath::Math::Symbol.new("a"),
                    Plurimath::Math::Symbol.new("b"),
                    Plurimath::Math::Symbol.new("c"),
                  ),
                ])
              )
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #42" do
      let(:string) { '{ x\ : \ x in A ^^ x in B }' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("\\"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new(":"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("\\"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("in"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("A"),
                    Plurimath::Math::Formula.new([
                      Plurimath::Math::Symbol.new("^^"),
                      Plurimath::Math::Formula.new([
                        Plurimath::Math::Symbol.new("x"),
                        Plurimath::Math::Formula.new([
                          Plurimath::Math::Symbol.new("in"),
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Symbol.new("B")
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
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
          Plurimath::Math::Symbol.new("r"),
          Plurimath::Math::Symbol.new("m"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("m"),
            Plurimath::Math::Symbol.new("s")
          ])
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
          Plurimath::Math::Symbol.new("%"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("*"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("!")
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #47" do
      let(:string) { 'R(alpha_(K+1)|x)' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("R"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Symbol.new("alpha"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("K"),
                Plurimath::Math::Symbol.new("+"),
                Plurimath::Math::Number.new("1")
              ])
            ),
            Plurimath::Math::Symbol.new("|"),
            Plurimath::Math::Symbol.new("x")
          ])
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
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("b"),
          Plurimath::Math::Symbol.new("|")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when contains example #50" do
      let(:string) { '|a+b|/c' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("b"),
          Plurimath::Math::Symbol.new("|"),
          Plurimath::Math::Symbol.new("/"),
          Plurimath::Math::Symbol.new("c")
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
                  Plurimath::Math::Symbol.new("|")
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
                  Plurimath::Math::Symbol.new("|")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Function::F.new
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

    context "when contains example #52" do
      let(:string) { '~a mlt b mgt -+c' }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("~"),
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("m"),
            Plurimath::Math::Symbol.new("lt"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("b"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("m"),
                Plurimath::Math::Symbol.new("gt"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("-"),
                  Plurimath::Math::Symbol.new("+"),
                  Plurimath::Math::Symbol.new("c")
                ])
              ])
            ])
          ])
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
          Plurimath::Math::Number.new("..."),
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
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("a"),
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("b")
            ]),
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
              Plurimath::Math::Formula.new([
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
                  ")",
                ),
              ]),
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("Adjustment to texture space"),
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
