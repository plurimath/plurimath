require_relative "../../../../lib/plurimath/math"

RSpec.describe Plurimath::Asciimath::Parser do

  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    context "example #01 from /site/documents/STL-manual.presentation.xml" do
      let(:string) { "A(ztext(/)overset(~)(gamma)) = sum_(i=1)^M overset(~)(gamma)_j^ia_iz^(-i), text( for ) j=1,2." }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("A"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("z"),
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbol.new("("),
                [
                  Plurimath::Math::Function::Text.new("/")
                ],
                Plurimath::Math::Symbol.new(")")
              ),
              Plurimath::Math::Function::Overset.new(
                Plurimath::Math::Symbol.new("&#x7e;"),
                Plurimath::Math::Symbol.new("&#x3b3;")
              )
            ],
            Plurimath::Math::Symbol.new(")")
          ),
          Plurimath::Math::Symbol.new("&#x3d;"),
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("i"),
              Plurimath::Math::Symbol.new("&#x3d;"),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Symbol.new("M")
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::PowerBase.new(
              Plurimath::Math::Function::Overset.new(
                Plurimath::Math::Symbol.new("&#x7e;"),
                Plurimath::Math::Symbol.new("&#x3b3;")
              ),
              Plurimath::Math::Symbol.new("j"),
              Plurimath::Math::Symbol.new("i")
            ),
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Symbol.new("i")
            ),
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new("z"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("&#x2212;"),
                Plurimath::Math::Symbol.new("i")
              ])
            ),
            Plurimath::Math::Symbol.new(", "),
            Plurimath::Math::Function::Fenced.new(
              Plurimath::Math::Symbol.new("("),
              [
                Plurimath::Math::Function::Text.new(" for ")
              ],
              Plurimath::Math::Symbol.new(")")
            ),
            Plurimath::Math::Symbol.new("j"),
            Plurimath::Math::Symbol.new("&#x3d;"),
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Symbol.new(","),
            Plurimath::Math::Number.new("2.")
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "example #02 from /site/documents/STL-manual.presentation.xml" do
      let(:string) { "H_s(z)=(1-A(ztext(/)overset(~)(gamma)))/(1-A(ztext(/)overset(~)(gamma)))(1+mu z^(-1)), text( with ) 0&#x3c;overset(~)(gamma)_1&#x3c;overset(~)(gamma)_2&#x3c;=1" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("H"),
            Plurimath::Math::Symbol.new("s")
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("z")
            ],
            Plurimath::Math::Symbol.new(")")
          ),
          Plurimath::Math::Symbol.new("&#x3d;"),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("&#x2212;"),
              Plurimath::Math::Symbol.new("A"),
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbol.new("("),
                [
                  Plurimath::Math::Symbol.new("z"),
                  Plurimath::Math::Function::Fenced.new(
                    Plurimath::Math::Symbol.new("("),
                    [
                      Plurimath::Math::Function::Text.new("/")
                    ],
                    Plurimath::Math::Symbol.new(")")
                  ),
                  Plurimath::Math::Function::Overset.new(
                    Plurimath::Math::Symbol.new("&#x7e;"),
                    Plurimath::Math::Symbol.new("&#x3b3;")
                  )
                ],
                Plurimath::Math::Symbol.new(")")
              )
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("&#x2212;"),
              Plurimath::Math::Symbol.new("A"),
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbol.new("("),
                [
                  Plurimath::Math::Symbol.new("z"),
                  Plurimath::Math::Function::Fenced.new(
                    Plurimath::Math::Symbol.new("("),
                    [
                      Plurimath::Math::Function::Text.new("/")
                    ],
                    Plurimath::Math::Symbol.new(")")
                  ),
                  Plurimath::Math::Function::Overset.new(
                    Plurimath::Math::Symbol.new("&#x7e;"),
                    Plurimath::Math::Symbol.new("&#x3b3;")
                  )
                ],
                Plurimath::Math::Symbol.new(")")
              )
            ])
          ),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Number.new("1"),
              Plurimath::Math::Symbol.new("&#x2b;"),
              Plurimath::Math::Symbol.new("&#x3bc;"),
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbol.new("z"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("&#x2212;"),
                  Plurimath::Math::Number.new("1")
                ])
              )
            ],
            Plurimath::Math::Symbol.new(")")
          ),
          Plurimath::Math::Symbol.new(", "),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Function::Text.new(" with ")
            ],
            Plurimath::Math::Symbol.new(")")
          ),
          Plurimath::Math::Number.new("0"),
          Plurimath::Math::Symbol.new("&#x26;"),
          Plurimath::Math::Symbol.new("&#x23;"),
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Symbol.new("c"),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Overset.new(
                Plurimath::Math::Symbol.new("&#x7e;"),
                Plurimath::Math::Symbol.new("&#x3b3;")
              ),
              Plurimath::Math::Number.new("1")
            ),
            Plurimath::Math::Symbol.new("&#x26;"),
            Plurimath::Math::Symbol.new("&#x23;"),
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Symbol.new("c"),
            Plurimath::Math::Symbol.new("&#x3b;"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Function::Overset.new(
                  Plurimath::Math::Symbol.new("&#x7e;"),
                  Plurimath::Math::Symbol.new("&#x3b3;")
                ),
                Plurimath::Math::Number.new("2")
              ),
              Plurimath::Math::Symbol.new("&#x26;"),
              Plurimath::Math::Symbol.new("&#x23;"),
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("c"),
              Plurimath::Math::Symbol.new("&#x3b;"),
              Plurimath::Math::Symbol.new("&#x3d;"),
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
          Plurimath::Math::Symbol.new("&#x26;"),
          Plurimath::Math::Symbol.new("&#x3c;;"),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Symbol.new("&#x26;"),
          Plurimath::Math::Symbol.new("&#x3c;;"),
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Symbol.new("&#x3b;"),
            Plurimath::Math::Symbol.new("e")
          ),
          Plurimath::Math::Symbol.new(", "),
          Plurimath::Math::Symbol.new("&#x26;"),
          Plurimath::Math::Symbol.new("&#x3c;;"),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Symbol.new("s"),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new("a"),
              Plurimath::Math::Function::G.new
            ],
            Plurimath::Math::Symbol.new(")")
          ),
          Plurimath::Math::Symbol.new("&#x26;"),
          Plurimath::Math::Symbol.new("&#x3e;"),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Symbol.new("&#x26;"),
          Plurimath::Math::Symbol.new("&#x3e;"),
          Plurimath::Math::Symbol.new("&#x3b;"),
          Plurimath::Math::Symbol.new(", "),
          Plurimath::Math::Symbol.new("s")
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
