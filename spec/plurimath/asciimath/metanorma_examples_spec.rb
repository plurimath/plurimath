require "spec_helper"

# These examples originate from https://github.com/metanorma/metanorma-standoc

RSpec.describe Plurimath::Asciimath::Parser do

  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    context "contains example #01" do
      let(:string) { "(gamma)/(sigma)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Symbols::Gamma.new,
            Plurimath::Math::Symbols::Sigma.new
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #02" do
      let(:string) { "ii(V)(ii(X)) = (b-a)^2/12 + d^2/9." }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle::Italic.new(
            Plurimath::Math::Symbols::Symbol.new("V"),
            "ii",
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Function::FontStyle::Italic.new(
                Plurimath::Math::Symbols::Symbol.new("X"),
                "ii",
              )
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          ),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbols::Paren::Lround.new,
                [
                  Plurimath::Math::Symbols::Symbol.new("b"),
                  Plurimath::Math::Symbols::Minus.new,
                  Plurimath::Math::Symbols::Symbol.new("a")
                ],
                Plurimath::Math::Symbols::Paren::Rround.new,
              ),
              Plurimath::Math::Number.new("2"),
            ),
            Plurimath::Math::Number.new("12"),
          ),
          Plurimath::Math::Symbols::Plus.new,
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbols::Symbol.new("d"),
              Plurimath::Math::Number.new("2")
            ),
            Plurimath::Math::Number.new("9")
          ),
          Plurimath::Math::Symbols::Period.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #03" do
      let(:string) { "ii(V)(ii(X)) = {(b - a)^2}/24 (1 + ii(beta)^2)." }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle::Italic.new(
            Plurimath::Math::Symbols::Symbol.new("V"),
            "ii",
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Function::FontStyle::Italic.new(
                Plurimath::Math::Symbols::Symbol.new("X"),
                "ii",
              )
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          ),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbols::Paren::Lround.new,
                [
                  Plurimath::Math::Symbols::Symbol.new("b"),
                  Plurimath::Math::Symbols::Minus.new,
                  Plurimath::Math::Symbols::Symbol.new("a")
                ],
                Plurimath::Math::Symbols::Paren::Rround.new,
              ),
              Plurimath::Math::Number.new("2")
            ),
            Plurimath::Math::Number.new("24")
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Function::FontStyle::Italic.new(
                  Plurimath::Math::Symbols::Upbeta.new,
                  "ii",
                ),
                Plurimath::Math::Number.new("2")
              )
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          ),
          Plurimath::Math::Symbols::Period.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #04" do
      let(:string) { "ii(E)(ii(X)) = {a + b}/2," }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::FontStyle::Italic.new(
            Plurimath::Math::Symbols::Symbol.new("E"),
            "ii",
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Function::FontStyle::Italic.new(
                Plurimath::Math::Symbols::Symbol.new("X"),
                "ii",
              )
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          ),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbols::Symbol.new("a"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Symbols::Symbol.new("b")
              ]),
              Plurimath::Math::Number.new("2"),
            ),
            Plurimath::Math::Symbols::Comma.new,
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #05" do
      let(:string) { "\"CO\"_2\" (aq.) \"+ \"H\"_2\"O\" overset(larr)(rarr) \"HCO\"_3^(-) + \"H\"^(+) \" log \"ii(K) = -6.38 80_{0}^{+2}" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("CO"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Text.new(" (aq.) "),
          Plurimath::Math::Symbols::Plus.new,
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("H"),
            Plurimath::Math::Number.new("2")
          ),
          Plurimath::Math::Function::Text.new("O"),
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Symbols::Gets.new,
            Plurimath::Math::Symbols::Rightarrow.new
          ),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("HCO"),
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Symbols::Minus.new
          ),
          Plurimath::Math::Symbols::Plus.new,
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("H"),
            Plurimath::Math::Symbols::Plus.new
          ),
          Plurimath::Math::Function::Text.new(" log "),
          Plurimath::Math::Function::FontStyle::Italic.new(
            Plurimath::Math::Symbols::Symbol.new("K"),
            "ii",
          ),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Symbols::Minus.new,
          Plurimath::Math::Number.new("6.38"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Number.new("80"),
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("2")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #06" do
      let(:string) { "gama)[d^d" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Symbol.new("g"),
          Plurimath::Math::Symbols::Symbol.new("a"),
          Plurimath::Math::Symbols::Symbol.new("m"),
          Plurimath::Math::Symbols::Symbol.new("a"),
          Plurimath::Math::Symbols::Paren::Rround.new,
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lsquare.new,
            [
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbols::Symbol.new("d"),
                Plurimath::Math::Symbols::Symbol.new("d")
              )
            ],
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #07" do
      let(:string) { "gama)^[d" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Symbol.new("g"),
          Plurimath::Math::Symbols::Symbol.new("a"),
          Plurimath::Math::Symbols::Symbol.new("m"),
          Plurimath::Math::Symbols::Symbol.new("a"),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Symbols::Symbol.new("d")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #08" do
      let(:string) { ")_dd" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Symbols::Symbol.new("d")
          ),
          Plurimath::Math::Symbols::Symbol.new("d")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #09" do
      let(:string) { ")^d, " }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Symbols::Symbol.new("d")
          ),
          Plurimath::Math::Symbols::Comma.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #10" do
      let(:string) { ")_d," }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Symbols::Symbol.new("d")
          ),
          Plurimath::Math::Symbols::Comma.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #11" do
      let(:string) { ")_d" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Symbols::Symbol.new("d")
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #12" do
      let(:string) { ")_dd" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Symbols::Symbol.new("d")
          ),
          Plurimath::Math::Symbols::Symbol.new("d")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #13" do
      let(:string) { ")_d^d" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Symbols::Symbol.new("d"),
            Plurimath::Math::Symbols::Symbol.new("d"),
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #14" do
      let(:string) { ")^d d" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Symbols::Symbol.new("d")
          ),
          Plurimath::Math::Symbols::Symbol.new("d")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #15" do
      let(:string) { ")_b^c c" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Symbols::Symbol.new("b"),
            Plurimath::Math::Symbols::Symbol.new("c")
          ),
          Plurimath::Math::Symbols::Symbol.new("c")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #16" do
      let(:string) { ")_3,^{c} c" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new
            ]),
            Plurimath::Math::Symbols::Symbol.new("c")
          ),
          Plurimath::Math::Symbols::Symbol.new("c")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #17" do
      let(:string) { ")_3^c c," }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Symbols::Symbol.new("c")
          ),
          Plurimath::Math::Symbols::Symbol.new("c"),
          Plurimath::Math::Symbols::Comma.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #18" do
      let(:string) { ")_3,^c c," }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new
            ]),
            Plurimath::Math::Symbols::Symbol.new("c")
          ),
          Plurimath::Math::Symbols::Symbol.new("c"),
          Plurimath::Math::Symbols::Comma.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #19" do
      let(:string) { ")_3,^c, c," }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Comma.new
            ]),
            Plurimath::Math::Symbols::Symbol.new("c")
          ),
          Plurimath::Math::Symbols::Comma.new,
          Plurimath::Math::Symbols::Symbol.new("c"),
          Plurimath::Math::Symbols::Comma.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #20" do
      let(:string) { ")_3^c, c," }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Symbols::Symbol.new("c")
          ),
          Plurimath::Math::Symbols::Comma.new,
          Plurimath::Math::Symbols::Symbol.new("c"),
          Plurimath::Math::Symbols::Comma.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #21" do
      let(:string) { "a_b^dd" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbols::Symbol.new("a"),
            Plurimath::Math::Symbols::Symbol.new("b"),
            Plurimath::Math::Symbols::Symbol.new("d")
          ),
          Plurimath::Math::Symbols::Symbol.new("d")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #22" do
      let(:string) { "frac(d)(d))d," }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Symbols::Symbol.new("d"),
            Plurimath::Math::Symbols::Symbol.new("d")
          ),
          Plurimath::Math::Symbols::Paren::Rround.new,
          Plurimath::Math::Symbols::Symbol.new("d"),
          Plurimath::Math::Symbols::Comma.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #23" do
      let(:string) { "1_d^d_d," }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::PowerBase.new(
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Symbol.new("d"),
              Plurimath::Math::Symbols::Symbol.new("d")
            ),
            Plurimath::Math::Symbols::Symbol.new("d")
          ),
          Plurimath::Math::Symbols::Comma.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #24" do
      let(:string) { "colortext(blue)(a_b^c)(abc)" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Color.new(
            Plurimath::Math::Function::Text.new("blue"),
            Plurimath::Math::Function::PowerBase.new(
              Plurimath::Math::Symbols::Symbol.new("a"),
              Plurimath::Math::Symbols::Symbol.new("b"),
              Plurimath::Math::Symbols::Symbol.new("c")
            )
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("a"),
              Plurimath::Math::Symbols::Symbol.new("b"),
              Plurimath::Math::Symbols::Symbol.new("c")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #25" do
      let(:string) { "underset(_)(hat A)sum_d^d" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underset.new(
            Plurimath::Math::Symbols::Ul.new,
            Plurimath::Math::Function::Hat.new(
              Plurimath::Math::Symbols::Symbol.new("A")
            )
          ),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbols::Symbol.new("d"),
            Plurimath::Math::Symbols::Symbol.new("d")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #26" do
      let(:string) { ")^d, w^3, \"\"" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Symbols::Symbol.new("d")
          ),
          Plurimath::Math::Symbols::Comma.new,
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbols::Symbol.new("w"),
            Plurimath::Math::Number.new("3"),
          ),
          Plurimath::Math::Symbols::Comma.new,
          Plurimath::Math::Function::Text.new("")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #27" do
      let(:string) { ")^d, w^3, " }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbols::Paren::Rround.new,
            Plurimath::Math::Symbols::Symbol.new("d")
          ),
          Plurimath::Math::Symbols::Comma.new,
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbols::Symbol.new("w"),
            Plurimath::Math::Number.new("3"),
          ),
          Plurimath::Math::Symbols::Comma.new
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
