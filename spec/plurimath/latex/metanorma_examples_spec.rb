require "spec_helper"

RSpec.describe Plurimath::Latex::Parser do

  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    context "contains example #1" do
      let(:string) {
        <<~LATEX
          \\mbox{rule{15mm}{0mm}}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Mbox.new("rule{15mm}{0mm}")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #2" do
      let(:string) {
        <<~LATEX
          10^{Q/10}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Number.new("10"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("Q"),
              Plurimath::Math::Symbols::Slash.new,
              Plurimath::Math::Number.new("10")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #3" do
      let(:string) {
        <<~LATEX
          \\mbox{rule{15mm}{0mm}}^{Q/10}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Mbox.new("rule{15mm}{0mm}"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("Q"),
              Plurimath::Math::Symbols::Slash.new,
              Plurimath::Math::Number.new("10")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #4" do
      let(:string) {
        <<~LATEX
          \\mbox{rule{15mm}{0mm}}_{Q/10}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Mbox.new("rule{15mm}{0mm}"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("Q"),
              Plurimath::Math::Symbols::Slash.new,
              Plurimath::Math::Number.new("10")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #5" do
      let(:string) {
        <<~LATEX
          <_{a}^{b}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbols::Less.new,
            Plurimath::Math::Symbols::Symbol.new("a"),
            Plurimath::Math::Symbols::Symbol.new("b"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #6" do
      let(:string) {
        <<~LATEX
          +_{d}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbols::Plus.new,
            Plurimath::Math::Symbols::Symbol.new("d"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #7" do
      let(:string) {
        <<~LATEX
          \\frac{s}{c}_{d}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Symbols::Symbol.new("s"),
              Plurimath::Math::Symbols::Symbol.new("c"),
            ),
            Plurimath::Math::Symbols::Symbol.new("d"),
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains example #8" do
      let(:string) {
        <<~LATEX
          <^{d}
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbols::Less.new,
            Plurimath::Math::Symbols::Symbol.new("d"),
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    # repo: https://github.com/metanorma/mn-samples-itu/sources/STL-manual/en.adoc

    context "contains example #9" do
      let(:string) {
        <<~LATEX
          H_I^p(z) = K + \\sum_{l=1}^{L}
                { b_{0l}+b_{1l} z^{-1} \\over
                  \\ 1+c_{1l} z^{-1}+ c_{2l} z^{-2} \\
                }
        LATEX
      }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbols::Symbol.new("H"),
            Plurimath::Math::Symbols::Symbol.new("I"),
            Plurimath::Math::Symbols::Symbol.new("p")
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("z"),
            ],
            Plurimath::Math::Symbols::Paren::Rround.new,
          ),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Symbols::Symbol.new("K"),
          Plurimath::Math::Symbols::Plus.new,
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("l"),
              Plurimath::Math::Symbols::Equal.new,
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Symbols::Symbol.new("L"),
            Plurimath::Math::Function::Over.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Symbols::Symbol.new("b"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Number.new("0"),
                    Plurimath::Math::Symbols::Symbol.new("l")
                  ])
                ),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Symbols::Symbol.new("b"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Number.new("1"),
                    Plurimath::Math::Symbols::Symbol.new("l")
                  ])
                ),
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbols::Symbol.new("z"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbols::Minus.new,
                    Plurimath::Math::Number.new("1")
                  ])
                )
              ]),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Text.new(" "),
                Plurimath::Math::Number.new("1"),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Symbols::Symbol.new("c"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Number.new("1"),
                    Plurimath::Math::Symbols::Symbol.new("l")
                  ])
                ),
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbols::Symbol.new("z"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbols::Minus.new,
                    Plurimath::Math::Number.new("1")
                  ])
                ),
                Plurimath::Math::Symbols::Plus.new,
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Symbols::Symbol.new("c"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Number.new("2"),
                    Plurimath::Math::Symbols::Symbol.new("l")
                  ])
                ),
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbols::Symbol.new("z"),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbols::Minus.new,
                    Plurimath::Math::Number.new("2")
                  ])
                ),
                Plurimath::Math::Function::Text.new(" ")
              ])
            )
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
