require "spec_helper"

# These examples originate from https://github.com/metanorma/mn-samples-itu

RSpec.describe Plurimath::Asciimath::Parser do

  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    context "example #01 from /site/documents/STL-manual.presentation.xml" do
      let(:string) { "A(ztext(/)overset(~)(gamma)) = sum_(i=1)^M overset(~)(gamma)_j^ia_iz^(-i), text( for ) j=1,2." }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Symbol.new("A"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("z"),
              Plurimath::Math::Function::Text.new("/"),
              Plurimath::Math::Function::Overset.new(
                Plurimath::Math::Symbols::Sptilde.new,
                Plurimath::Math::Symbols::Gamma.new
              )
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          ),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("i"),
              Plurimath::Math::Symbols::Equal.new,
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Symbols::Symbol.new("M"),
            Plurimath::Math::Function::PowerBase.new(
              Plurimath::Math::Function::Overset.new(
                Plurimath::Math::Symbols::Sptilde.new,
                Plurimath::Math::Symbols::Gamma.new
              ),
              Plurimath::Math::Symbols::Symbol.new("j"),
              Plurimath::Math::Symbols::Symbol.new("i")
            ),
          ),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbols::Symbol.new("a"),
            Plurimath::Math::Symbols::Symbol.new("i")
          ),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbols::Symbol.new("z"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Minus.new,
              Plurimath::Math::Symbols::Symbol.new("i")
            ])
          ),
          Plurimath::Math::Symbols::Comma.new,
          Plurimath::Math::Function::Text.new(" for "),
          Plurimath::Math::Symbols::Symbol.new("j"),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbols::Comma.new,
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Symbols::Period.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "example #02 from /site/documents/STL-manual.presentation.xml" do
      let(:string) { "H_s(z)=(1-A(ztext(/)overset(~)(gamma)))/(1-A(ztext(/)overset(~)(gamma)))(1+mu z^(-1)), text( with ) 0&#x3c;overset(~)(gamma)_1&#x3c;overset(~)(gamma)_2&#x3c;=1" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbols::Symbol.new("H"),
            Plurimath::Math::Symbols::Symbol.new("s")
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("z")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          ),
          Plurimath::Math::Symbols::Equal.new,
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Minus.new,
              Plurimath::Math::Symbols::Symbol.new("A"),
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbols::Paren::Lround.new,
                [
                  Plurimath::Math::Symbols::Symbol.new("z"),
                  Plurimath::Math::Function::Text.new("/"),
                  Plurimath::Math::Function::Overset.new(
                    Plurimath::Math::Symbols::Sptilde.new,
                    Plurimath::Math::Symbols::Gamma.new
                  )
                ],
                Plurimath::Math::Symbols::Paren::Rround.new
              )
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Minus.new,
              Plurimath::Math::Symbols::Symbol.new("A"),
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbols::Paren::Lround.new,
                [
                  Plurimath::Math::Symbols::Symbol.new("z"),
                  Plurimath::Math::Function::Text.new("/"),
                  Plurimath::Math::Function::Overset.new(
                    Plurimath::Math::Symbols::Sptilde.new,
                    Plurimath::Math::Symbols::Gamma.new
                  )
                ],
                Plurimath::Math::Symbols::Paren::Rround.new
              )
            ])
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Symbols::Mu.new,
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbols::Symbol.new("z"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbols::Minus.new,
                  Plurimath::Math::Number.new("1")
                ])
              )
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          ),
          Plurimath::Math::Symbols::Comma.new,
          Plurimath::Math::Function::Text.new(" with "),
          Plurimath::Math::Number.new("0"),
          Plurimath::Math::Symbols::Less.new,
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Overset.new(
                Plurimath::Math::Symbols::Sptilde.new,
                Plurimath::Math::Symbols::Gamma.new
              ),
              Plurimath::Math::Number.new("1")
            ),
            Plurimath::Math::Symbols::Less.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Overset.new(
                  Plurimath::Math::Symbols::Sptilde.new,
                  Plurimath::Math::Symbols::Gamma.new
                ),
                Plurimath::Math::Number.new("2")
              ),
              Plurimath::Math::Symbols::Less.new,
              Plurimath::Math::Symbols::Equal.new,
              Plurimath::Math::Number.new("1")
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "example #01 from /site/documents/Z.100-201811-AnnF1.xml" do
      let(:string) { " &lt; &lt; mode, &lt; s(ag) &gt; &gt;, s" }

      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Less.new,
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Symbols::Less.new,
            Plurimath::Math::Symbols::Symbol.new("e")
          ),
          Plurimath::Math::Symbols::Comma.new,
          Plurimath::Math::Symbols::Less.new,
          Plurimath::Math::Symbols::Symbol.new("s"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbols::Paren::Lround.new,
            [
              Plurimath::Math::Symbols::Symbol.new("a"),
              Plurimath::Math::Symbols::Symbol.new("g")
            ],
            Plurimath::Math::Symbols::Paren::Rround.new
          ),
          Plurimath::Math::Symbols::Greater.new,
          Plurimath::Math::Symbols::Greater.new,
          Plurimath::Math::Symbols::Comma.new,
          Plurimath::Math::Symbols::Symbol.new("s")
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
