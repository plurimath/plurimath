require "spec_helper"

RSpec.describe Plurimath::Html::Parser do

  describe ".parse" do

    subject(:formula) {
      described_class.new(string.gsub(/\s/, "")).parse
    }

    context "basic parse rules for single character tag" do
      let(:string) { "<i>&sum;</i>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "basic parse rules for multiple character tag" do
      let(:string) { "<div>&sum;</div>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains sum with sub and sup values" do
      let(:string) { "&sum;<sub>d</sub><sup>prod</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Function::Text.new("d"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("p"),
              Plurimath::Math::Function::Text.new("r"),
              Plurimath::Math::Function::Text.new("o"),
              Plurimath::Math::Function::Text.new("d")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains sub tag" do
      let(:string) { "<div>&sum;<sub>&prod;</sub></div>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Function::Prod.new,
            nil
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains sub and sup tag" do
      let(:string) { "<div>&sum;<sub>&prod;</sub><sup>prod</sup></div>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Function::Prod.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("p"),
              Plurimath::Math::Function::Text.new("r"),
              Plurimath::Math::Function::Text.new("o"),
              Plurimath::Math::Function::Text.new("d")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains complex sub and sup tag" do
      let(:string) { "<div>some<sup><span>(</span><span>S</span><span>)</span></sup><sub>g</sub></div>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("s"),
          Plurimath::Math::Function::Text.new("o"),
          Plurimath::Math::Function::Text.new("m"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("e"),
            Plurimath::Math::Function::Text.new("g"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lround.new,
              Plurimath::Math::Function::Text.new("S"),
              Plurimath::Math::Symbols::Paren::Rround.new
            ]),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #1" do
      let(:string) { "abs(3)" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Abs.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lround.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Paren::Rround.new
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #2" do
      let(:string) { "abc[0]" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Function::Text.new("b"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lsquare.new,
              Plurimath::Math::Number.new("0"),
              Plurimath::Math::Symbols::Paren::Rsquare.new
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #3" do
      let(:string) { "abc{0}" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Function::Text.new("b"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lbrace.new,
              Plurimath::Math::Number.new("0"),
              Plurimath::Math::Symbols::Paren::Rbrace.new
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #4" do
      let(:string) { "abc(weatever text [and things])" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Function::Text.new("b"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lround.new,
              Plurimath::Math::Function::Text.new("w"),
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Function::Text.new("a"),
              Plurimath::Math::Function::Text.new("t"),
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Function::Text.new("v"),
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Function::Text.new("r"),
              Plurimath::Math::Function::Text.new("t"),
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Text.new("t"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbols::Paren::Lsquare.new,
                  Plurimath::Math::Function::Text.new("a"),
                  Plurimath::Math::Function::Text.new("n"),
                  Plurimath::Math::Function::Text.new("d"),
                  Plurimath::Math::Function::Text.new("t"),
                  Plurimath::Math::Function::Text.new("h"),
                  Plurimath::Math::Function::Text.new("i"),
                  Plurimath::Math::Function::Text.new("n"),
                  Plurimath::Math::Function::Text.new("g"),
                  Plurimath::Math::Function::Text.new("s"),
                  Plurimath::Math::Symbols::Paren::Rsquare.new
                ])
              ]),
              Plurimath::Math::Symbols::Paren::Rround.new
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #5" do
      let(:string) { "ϑ(t)" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Symbol.new("ϑ"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbols::Paren::Lround.new,
            Plurimath::Math::Function::Text.new("t"),
            Plurimath::Math::Symbols::Paren::Rround.new
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #6" do
      let(:string) { "<i>a</i><sup>2</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Number.new("2")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #7" do
      let(:string) { "<i>a</i><sub>2</sub>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Number.new("2")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #8" do
      let(:string) { "<i>a</i><sup><i>n</i></sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Function::Text.new("n")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #9" do
      let(:string) { "<i>a</i><sub><i>n</i></sub>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Function::Text.new("n")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #10" do
      let(:string) { "2<sup>3</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("3")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #11" do
      let(:string) { "2<sup>3+4</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("4")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #12" do
      let(:string) { "2<sub>3+4</sub>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("4")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #13" do
      let(:string) { "<i>a</i><sub><i>b</i>+2</sub>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("b"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("2")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #14" do
      let(:string) { "<i>a</i><sup>-2</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("-"),
              Plurimath::Math::Number.new("2")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #15" do
      let(:string) { "<i>a</i><sub>-2</sub>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("-"),
              Plurimath::Math::Number.new("2")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #16" do
      let(:string) { "<i>a</i><sup>-<i>n</i></sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("-"),
              Plurimath::Math::Function::Text.new("n")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #17" do
      let(:string) { "<i>a</i><sub>-<i>n</i></sub>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("-"),
              Plurimath::Math::Function::Text.new("n")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #18" do
      let(:string) { "<i>a</i><sub><i>n</i></sub><sup>2</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Function::Text.new("n"),
            Plurimath::Math::Number.new("2"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #19" do
      let(:string) { "<i>a</i><sub><i>n+1</i></sub><sup><i>b</i>+<i>c</i></sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("b"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Function::Text.new("c")
            ]),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #20" do
      let(:string) { "<i>f</i>(<i>x</x>)" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbols::Paren::Lround.new,
            Plurimath::Math::Function::Text.new("x"),
            Plurimath::Math::Symbols::Paren::Rround.new
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #21" do
      let(:string) { "<i>f</i>(<i>g</i>(<i>x</x>))" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbols::Paren::Lround.new,
            Plurimath::Math::Function::Text.new("g"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lround.new,
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Symbols::Paren::Rround.new,
            ]),
            Plurimath::Math::Symbols::Paren::Rround.new,
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #22" do
      let(:string) { "f&sum;(<i>n</i>)(<i>2</i>)" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Symbols::Symbol.new("&sum;"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbols::Paren::Lround.new,
            Plurimath::Math::Function::Text.new("n"),
            Plurimath::Math::Symbols::Paren::Rround.new
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbols::Paren::Lround.new,
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Symbols::Paren::Rround.new
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #23" do
      let(:string) { "fib(<i>n</i>)" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("b"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lround.new,
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbols::Paren::Rround.new
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #24" do
      let(:string) { "<i>f</i><sub>max</sub>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("f"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("m"),
              Plurimath::Math::Function::Text.new("a"),
              Plurimath::Math::Function::Text.new("x")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #25" do
      let(:string) { "<i>&omega;</i>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Symbol.new("&omega;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #26" do
      let(:string) { "<i>&Omega;</i>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Symbol.new("&Omega;")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #27" do
      let(:string) { "αβγ" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Symbol.new("α"),
          Plurimath::Math::Symbols::Symbol.new("β"),
          Plurimath::Math::Symbols::Symbol.new("γ")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #28" do
      let(:string) { "абг" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Symbol.new("а"),
          Plurimath::Math::Symbols::Symbol.new("б"),
          Plurimath::Math::Symbols::Symbol.new("г")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #29" do
      let(:string) { "<i>f</i><sup>-1</sup>(<i>x</x>)" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("f"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Symbol.new("-"),
              Plurimath::Math::Number.new("1")
            ])
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbols::Paren::Lround.new,
            Plurimath::Math::Function::Text.new("x"),
            Plurimath::Math::Symbols::Paren::Rround.new
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #30" do
      let(:string) { "<sub>sth</sub>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("s"),
          Plurimath::Math::Function::Text.new("t"),
          Plurimath::Math::Function::Text.new("h")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #31" do
      let(:string) { "root(<i>sth</i>)" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("r"),
          Plurimath::Math::Function::Text.new("o"),
          Plurimath::Math::Function::Text.new("o"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("t"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lround.new,
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Text.new("s"),
                Plurimath::Math::Function::Text.new("t"),
                Plurimath::Math::Function::Text.new("h")
              ]),
              Plurimath::Math::Symbols::Paren::Rround.new
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #32" do
      let(:string) { "<table><tr><td>Something</td></tr></table>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new([
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new("S"),
                Plurimath::Math::Function::Text.new("o"),
                Plurimath::Math::Function::Text.new("m"),
                Plurimath::Math::Function::Text.new("e"),
                Plurimath::Math::Function::Text.new("t"),
                Plurimath::Math::Function::Text.new("h"),
                Plurimath::Math::Function::Text.new("i"),
                Plurimath::Math::Function::Text.new("n"),
                Plurimath::Math::Function::Text.new("g")
              ])
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #33" do
      let(:string) do
        <<~HTML
          <table>
            <tr>
              <td>4</td>
            </tr>
            <tr>
              <td>3</td>
            </tr>
            <tr>
              <td>2</td>
            </tr>
            <tr>
              <td>1</td>
            </tr>
          </table>
        HTML
      end
      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new([
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("4")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("3")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("2")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("1")
              ])
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #34" do
      let(:string) do
        <<~HTML
          <table>
            <tr>
              <td>so</td>
            </tr>
            <tr>
              <td>es</td>
            </tr>
            <tr>
              <td>&sum;</td>
            </tr>
            <tr>
              <td>&prod;</td>
            </tr>
          </table>
        HTML
      end
      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Table.new([
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new("s"),
                Plurimath::Math::Function::Text.new("o")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new("e"),
                Plurimath::Math::Function::Text.new("s")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Sum.new
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Prod.new
              ])
            ])
          ])
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #35" do
      let(:string) { "&sum;<sub>drop</sub><sup>prod</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("d"),
              Plurimath::Math::Function::Text.new("r"),
              Plurimath::Math::Function::Text.new("o"),
              Plurimath::Math::Function::Text.new("p")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("p"),
              Plurimath::Math::Function::Text.new("r"),
              Plurimath::Math::Function::Text.new("o"),
              Plurimath::Math::Function::Text.new("d")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #36" do
      let(:string) { "&sum;<sub>drop</sub><sup>p</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("d"),
              Plurimath::Math::Function::Text.new("r"),
              Plurimath::Math::Function::Text.new("o"),
              Plurimath::Math::Function::Text.new("p")
            ]),
            Plurimath::Math::Function::Text.new("p")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #37" do
      let(:string) { "&sum;<sup>p</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            nil,
            Plurimath::Math::Function::Text.new("p")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #38" do
      let(:string) { "&sum;<sup>prod</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            nil,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("p"),
              Plurimath::Math::Function::Text.new("r"),
              Plurimath::Math::Function::Text.new("o"),
              Plurimath::Math::Function::Text.new("d")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #39" do
      let(:string) { "&sum;<sub>prod</sub>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("p"),
              Plurimath::Math::Function::Text.new("r"),
              Plurimath::Math::Function::Text.new("o"),
              Plurimath::Math::Function::Text.new("d")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #40" do
      let(:string) { "2<sub>3</sub>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("3")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #41" do
      let(:string) { "&sum;<sub>3</sub><sup>5</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Number.new("5")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #42" do
      let(:string) { "2<sub>3</sub><sup>5</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Number.new("5"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #43" do
      let(:string) { "2<sub>so</sub><sup>we</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("s"),
              Plurimath::Math::Function::Text.new("o")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("w"),
              Plurimath::Math::Function::Text.new("e")
            ]),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #44" do
      let(:string) { "2<sub>s</sub><sup>we</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("w"),
              Plurimath::Math::Function::Text.new("e")
            ]),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #45" do
      let(:string) { "2<sub>so</sub><sup>w</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("s"),
              Plurimath::Math::Function::Text.new("o")
            ]),
            Plurimath::Math::Function::Text.new("w"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #46" do
      let(:string) { "s<sub>so</sub><sup>w</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("s"),
              Plurimath::Math::Function::Text.new("o")
            ]),
            Plurimath::Math::Function::Text.new("w"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #47" do
      let(:string) { "s<sub>so</sub><sup>we</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("s"),
              Plurimath::Math::Function::Text.new("o")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("w"),
              Plurimath::Math::Function::Text.new("e")
            ]),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #48" do
      let(:string) { "s<sub>s</sub><sup>we</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("w"),
              Plurimath::Math::Function::Text.new("e")
            ]),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #49" do
      let(:string) { "<i>lim</i>(3)(e)" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Lim.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lround.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbols::Paren::Rround.new
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lround.new,
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Symbols::Paren::Rround.new
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #50" do
      let(:string) { "<i>lim</i>(3e)(em)" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Lim.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lround.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Symbols::Paren::Rround.new
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lround.new,
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Function::Text.new("m"),
              Plurimath::Math::Symbols::Paren::Rround.new
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #51" do
      let(:string) { "<i>lim</i>(3am)(rest)" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Lim.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lround.new,
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Function::Text.new("a"),
              Plurimath::Math::Function::Text.new("m"),
              Plurimath::Math::Symbols::Paren::Rround.new
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbols::Paren::Lround.new,
              Plurimath::Math::Function::Text.new("r"),
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Function::Text.new("s"),
              Plurimath::Math::Function::Text.new("t"),
              Plurimath::Math::Symbols::Paren::Rround.new
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #52" do
      let(:string) { "<i>log</i><sub>3</sub><sup>e</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new(
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Function::Text.new("e")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #53" do
      let(:string) { "2<i>mod</i>e" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Function::Text.new("e")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #54" do
      let(:string) { "<i>2</i><i>mod</i><i>e</i>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Function::Text.new("e")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #55" do
      let(:string) { "<i>2a</i><i>mod</i><i>em</i>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("2"),
              Plurimath::Math::Function::Text.new("a")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Function::Text.new("m")
            ])
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #56" do
      let(:string) { "2a<i>mod</i>em" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Function::Text.new("e")
          ),
          Plurimath::Math::Function::Text.new("m")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #57" do
      let(:string) { "<i>a</i><sub><i>n+1</i></sub><sup><i>b</i>+</sup>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbols::Plus.new,
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("b"),
              Plurimath::Math::Symbols::Plus.new,
            ]),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math sin and value example #58" do
      let(:string) { "<i>sin</i><i>b</i>d" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Function::Text.new("b"),
          ),
          Plurimath::Math::Function::Text.new("d")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math sin and multiple values example #59" do
      let(:string) { "<i>sin</i><i>b</i>x+1" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Function::Text.new("b"),
          ),
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Symbols::Plus.new,
          Plurimath::Math::Number.new("1"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math sin wrapped with parenthesis example #60" do
      let(:string) { "<i>(</i><i>sin</i><i>d</i><i>)</i>" }

      it "returns abstract parsed tree" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbols::Paren::Lround.new,
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Function::Text.new("d"),
          ),
          Plurimath::Math::Symbols::Paren::Rround.new,
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "should fail when a tag is not closed" do
      let(:string) { "<sup>sth" }

      it "returns abstract parsed tree" do
        expect{formula}.to raise_error(Parslet::ParseFailed)
      end
    end
  end
end
