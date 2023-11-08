require "spec_helper"

RSpec.describe Plurimath::Math::Formula do
  describe ".to_html" do
    subject(:formula) { exp.to_html.gsub(/\s/, "") }

    context "basic parse rules for single character tag" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>&sum;</i>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains sum with sub and sup values" do
      let(:exp) do
        Plurimath::Math::Formula.new([
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
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>&sum;</i><sub>d</sub><sup>prod</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains sub tag" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Function::Prod.new,
            nil
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>&sum;</i><sub><i>&prod;</i></sub>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains sub and sup tag" do
      let(:exp) do
        Plurimath::Math::Formula.new([
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
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>&sum;</i><sub><i>&prod;</i></sub><sup>prod</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains complex sub and sup tag" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("s"),
          Plurimath::Math::Function::Text.new("o"),
          Plurimath::Math::Function::Text.new("m"),
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("e"),
            Plurimath::Math::Function::Text.new("g"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Function::Text.new("S"),
              Plurimath::Math::Symbol.new(")")
            ]),
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value =
        <<~HTML
          som
          <i>e</i>
          <sub>g</sub>
          <sup>(S)</sup>
        HTML
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains HTML math example #1" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Abs.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new(")")
            ])
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>abs</i><i>(3)</i>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #2" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Function::Text.new("b"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("["),
              Plurimath::Math::Number.new("0"),
              Plurimath::Math::Symbol.new("]")
            ])
          ])
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "abc[0]"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #3" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Function::Text.new("b"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("{"),
              Plurimath::Math::Number.new("0"),
              Plurimath::Math::Symbol.new("}")
            ])
          ])
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "abc{0}"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #4" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Function::Text.new("b"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("c"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
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
                  Plurimath::Math::Symbol.new("["),
                  Plurimath::Math::Function::Text.new("a"),
                  Plurimath::Math::Function::Text.new("n"),
                  Plurimath::Math::Function::Text.new("d"),
                  Plurimath::Math::Function::Text.new("t"),
                  Plurimath::Math::Function::Text.new("h"),
                  Plurimath::Math::Function::Text.new("i"),
                  Plurimath::Math::Function::Text.new("n"),
                  Plurimath::Math::Function::Text.new("g"),
                  Plurimath::Math::Function::Text.new("s"),
                  Plurimath::Math::Symbol.new("]")
                ])
              ]),
              Plurimath::Math::Symbol.new(")")
            ])
          ])
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "abc(weatevertext[andthings])"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #5" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("ϑ"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("("),
            Plurimath::Math::Function::Text.new("t"),
            Plurimath::Math::Symbol.new(")")
          ])
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "ϑ(t)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #6" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Number.new("2")
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>a</i><sup>2</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #7" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Number.new("2")
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>a</i><sub>2</sub>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #8" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Function::Text.new("n")
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>a</i><sup>n</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #9" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Function::Text.new("n")
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>a</i><sub>n</sub>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #10" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("3")
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>2</i><sup>3</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #11" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("4")
            ])
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>2</i><sup>3+4</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #12" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("4")
            ])
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>2</i><sub>3+4</sub>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #13" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("b"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("2")
            ])
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>a</i><sub>b+2</sub>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #14" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Number.new("2")
            ])
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>a</i><sup>-2</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #15" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Number.new("2")
            ])
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>a</i><sub>-2</sub>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #16" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Function::Text.new("n")
            ])
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>a</i><sup>-n</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #17" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Function::Text.new("n")
            ])
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>a</i><sub>-n</sub>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #18" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Function::Text.new("n"),
            Plurimath::Math::Number.new("2"),
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>a</i><sub>n</sub><sup>2</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #19" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Number.new("1")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("b"),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Function::Text.new("c")
            ]),
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value =
        <<~HTML
          <i>a</i>
          <sub>
            n+1
          </sub>
          <sup>
            b+c
          </sup>
        HTML
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains HTML math example #20" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("("),
            Plurimath::Math::Function::Text.new("x"),
            Plurimath::Math::Symbol.new(")")
          ])
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "f(x)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #21" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("("),
            Plurimath::Math::Function::Text.new("g"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Function::Text.new("x"),
              Plurimath::Math::Symbol.new(")")
            ]),
            Plurimath::Math::Symbol.new(")")
          ]),
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "f(g(x))"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #22" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("f"),
            Plurimath::Math::Function::Sum.new,
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new(")")
            ])
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("("),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Symbol.new(")")
          ])
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "f<i>&sum;</i>(n)(2)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #23" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Function::Text.new("i"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("b"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Symbol.new(")")
            ])
          ])
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "fib(n)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #24" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("f"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("m"),
              Plurimath::Math::Function::Text.new("a"),
              Plurimath::Math::Function::Text.new("x")
            ])
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>f</i><sub>max</sub>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #25" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&omega;")
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "&omega;"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #26" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("&Omega;")
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "&Omega;"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #27" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("α"),
          Plurimath::Math::Symbol.new("β"),
          Plurimath::Math::Symbol.new("γ")
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "αβγ"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #28" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("а"),
          Plurimath::Math::Symbol.new("б"),
          Plurimath::Math::Symbol.new("г")
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "абг"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #29" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("f"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("-"),
            Plurimath::Math::Number.new("1")
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("("),
            Plurimath::Math::Function::Text.new("x"),
            Plurimath::Math::Symbol.new(")")
          ])
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "f-1(x)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #30" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("s"),
          Plurimath::Math::Function::Text.new("t"),
          Plurimath::Math::Function::Text.new("h")
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "sth"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #31" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Text.new("r"),
          Plurimath::Math::Function::Text.new("o"),
          Plurimath::Math::Function::Text.new("o"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("t"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Text.new("s"),
                Plurimath::Math::Function::Text.new("t"),
                Plurimath::Math::Function::Text.new("h")
              ]),
              Plurimath::Math::Symbol.new(")")
            ])
          ])
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "root(sth)"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #32" do
      let(:exp) do
        Plurimath::Math::Formula.new([
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
                Plurimath::Math::Function::Text.new("g"),
              ])
            ])
          ])
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<table><tr><td>Something</td></tr></table>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #33" do
      let(:exp) do
        Plurimath::Math::Formula.new([
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
      end
      it "returns abstract parsed tree" do
        expected_value =
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
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains HTML math example #34" do
      let(:exp) do
        Plurimath::Math::Formula.new([
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
      end
      it "returns abstract parsed tree" do
        expected_value =
        <<~HTML
          <table>
            <tr>
              <td>so</td>
            </tr>
            <tr>
              <td>es</td>
            </tr>
            <tr>
              <td><i>&sum;</i></td>
            </tr>
            <tr>
              <td><i>&prod;</i></td>
            </tr>
          </table>
        HTML
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains HTML math example #35" do
      let(:exp) do
        Plurimath::Math::Formula.new([
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
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>&sum;</i><sub>drop</sub><sup>prod</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #36" do
      let(:exp) do
        Plurimath::Math::Formula.new([
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
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>&sum;</i><sub>drop</sub><sup>p</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #37" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            nil,
            Plurimath::Math::Function::Text.new("p")
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>&sum;</i><sup>p</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #38" do
      let(:exp) do
        Plurimath::Math::Formula.new([
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
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>&sum;</i><sup>prod</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #39" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("p"),
              Plurimath::Math::Function::Text.new("r"),
              Plurimath::Math::Function::Text.new("o"),
              Plurimath::Math::Function::Text.new("d")
            ])
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>&sum;</i><sub>prod</sub>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #40" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("3")
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>2</i><sub>3</sub>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #41" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Number.new("5")
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>&sum;</i><sub>3</sub><sup>5</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #42" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Number.new("5"),
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>2</i><sub>3</sub><sup>5</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #43" do
      let(:exp) do
        Plurimath::Math::Formula.new([
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
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>2</i><sub>so</sub><sup>we</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #44" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("w"),
              Plurimath::Math::Function::Text.new("e")
            ]),
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>2</i><sub>s</sub><sup>we</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #45" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("s"),
              Plurimath::Math::Function::Text.new("o")
            ]),
            Plurimath::Math::Function::Text.new("w"),
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>2</i><sub>so</sub><sup>w</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #46" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("s"),
              Plurimath::Math::Function::Text.new("o")
            ]),
            Plurimath::Math::Function::Text.new("w"),
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>s</i><sub>so</sub><sup>w</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #47" do
      let(:exp) do
        Plurimath::Math::Formula.new([
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
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>s</i><sub>so</sub><sup>we</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #48" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Function::Text.new("s"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("w"),
              Plurimath::Math::Function::Text.new("e")
            ]),
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>s</i><sub>s</sub><sup>we</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #49" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Lim.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Symbol.new(")")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Symbol.new(")")
            ])
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>(3)</i><i>(e)</i>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #50" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Lim.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Symbol.new(")")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Function::Text.new("m"),
              Plurimath::Math::Symbol.new(")")
            ])
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>(3e)</i><i>(em)</i>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #51" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Lim.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Number.new("3"),
              Plurimath::Math::Function::Text.new("a"),
              Plurimath::Math::Function::Text.new("m"),
              Plurimath::Math::Symbol.new(")")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("("),
              Plurimath::Math::Function::Text.new("r"),
              Plurimath::Math::Function::Text.new("e"),
              Plurimath::Math::Function::Text.new("s"),
              Plurimath::Math::Function::Text.new("t"),
              Plurimath::Math::Symbol.new(")")
            ])
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>(3am)</i><i>(rest)</i>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #52" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Log.new(
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Function::Text.new("e")
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>log</i><sub>3</sub><sup>e</sup>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #53" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Function::Text.new("e")
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>2</i><i>mod</i><i>e</i>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #54" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Function::Text.new("e")
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>2</i><i>mod</i><i>e</i>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #55" do
      let(:exp) do
        Plurimath::Math::Formula.new([
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
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>2a</i><i>mod</i><i>em</i>"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #56" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Function::Text.new("a"),
            Plurimath::Math::Function::Text.new("e")
          ),
          Plurimath::Math::Function::Text.new("m")
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "2<i>a</i><i>mod</i><i>e</i>m"
        expect(formula).to eq(expected_value)
      end
    end

    context "contains HTML math example #57" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Text.new("A"),
              Plurimath::Math::Number.new("1"),
            ]),
            Plurimath::Math::Symbol.new("ϑ"),
            Plurimath::Math::Symbol.new("&"),
          )
        ])
      end
      it "returns abstract parsed tree" do
        expected_value = "<i>A1</i><i>ϑ</i><i>&</i>"
        expect(formula).to eq(expected_value)
      end
    end
  end
end
