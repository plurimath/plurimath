require_relative "../../../spec/spec_helper"

RSpec.describe Plurimath::Html::Parse do

  describe ".parse" do
    subject(:formula) {
      described_class.new.parse(string.gsub(/\s/, ""))
    }

    context "contains sum symbol in li tag" do
      let(:string) { "<i>&sum;</i>" }
      it "returns abstract parsed tree" do
        expect(formula[:sequence][:sum_prod]).to eq("&sum;")
      end
    end

    context "contains sum symbol in li tag" do
      let(:string) { "&sum;<sub>d</sub><sup>prod</sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:sum_prod]).to eq("&sum;")
        expect(formula[:sub_value][:text]).to eq("d")
        expect(formula[:sup_value][:text]).to eq("p")
        expect(formula[:sup_value][:expression][:text]).to eq("r")
        expect(formula[:sup_value][:expression][:expression][:text]).to eq("o")
        expect(formula[:sup_value][:expression][:expression][:expression][:text]).to eq("d")
      end
    end

    context "contains sub tag" do
      let(:string) { "<div>&sum;<sub>&prod;</sub></div>" }
      it "returns abstract parsed tree" do
        sequence = formula[:sequence]

        expect(sequence[:sub_sup][:sum_prod]).to eq("&sum;")
        expect(sequence[:sub_value][:sum_prod]).to eq("&prod;")
      end
    end

    context "contains sup tag" do
      let(:string) { "<div>&sum;<sup>&prod;</sup></div>" }
      it "returns abstract parsed tree" do
        sequence = formula[:sequence]

        expect(sequence[:sub_sup][:sum_prod]).to eq("&sum;")
        expect(sequence[:sup_value][:sum_prod]).to eq("&prod;")
      end
    end

    context "contains sub and sup tag" do
      let(:string) { "<div>&sum;<sub>&prod;</sub><sup>prod</sup></div>" }
      it "returns abstract parsed tree" do
        sequence = formula[:sequence]

        expect(sequence[:sub_sup][:sum_prod]).to eq("&sum;")
        expect(sequence[:sub_value][:sum_prod]).to eq("&prod;")
        expect(sequence[:sup_value][:text]).to eq("p")
        expect(sequence[:sup_value][:expression][:text]).to eq("r")
        expect(sequence[:sup_value][:expression][:expression][:text]).to eq("o")
        expect(sequence[:sup_value][:expression][:expression][:expression][:text]).to eq("d")
      end
    end

    context "contains complex sub and sup tag" do
      let(:string) {
        <<~HTML
          <div>
            some
            <sup><span>(</span><span>S</span><span>)</span></sup>
            <sub>g</sub>
          </div>
        HTML
      }
      it "returns abstract parsed tree" do
        sequence  = formula[:sequence]
        sup_value = sequence[:expression][:expression][:expression][:sup_value][:parse_parenthesis]
        sub_value = sequence[:expression][:expression][:expression][:sub_value]

        expect(sequence[:text]).to eq("s")
        expect(sequence[:expression][:text]).to eq("o")
        expect(sequence[:expression][:expression][:text]).to eq("m")
        expect(sequence[:expression][:expression][:expression][:sub_sup][:text]).to eq("e")
        expect(sup_value[:lparen]).to eq("(")
        expect(sup_value[:sequence][:text]).to eq("S")
        expect(sup_value[:rparen]).to eq(")")
        expect(sub_value[:text]).to eq("g")
      end
    end

    context "contains HTML math example #1" do
      let(:string) { "abs(3)" }
      it "returns abstract parsed tree" do
        first_value = formula[:unary_function][:first_value]

        expect(formula[:unary_function][:unary]).to eq("abs")
        expect(first_value[:lparen]).to eq("(")
        expect(first_value[:number]).to eq("3")
        expect(first_value[:rparen]).to eq(")")
      end
    end

    context "contains HTML math example #2" do
      let(:string) { "abc[0]" }
      it "returns abstract parsed tree" do
        parse_paren = formula[:expression][:expression][:parse_parenthesis]

        expect(formula[:text]).to eq("a")
        expect(formula[:expression][:text]).to eq("b")
        expect(formula[:expression][:expression][:text]).to eq("c")
        expect(parse_paren[:lparen]).to eq("[")
        expect(parse_paren[:number]).to eq("0")
        expect(parse_paren[:rparen]).to eq("]")
      end
    end

    context "contains HTML math example #3" do
      let(:string) { "abc{0}" }
      it "returns abstract parsed tree" do
        parse_paren = formula[:expression][:expression][:parse_parenthesis]

        expect(formula[:text]).to eq("a")
        expect(formula[:expression][:text]).to eq("b")
        expect(formula[:expression][:expression][:text]).to eq("c")
        expect(parse_paren[:lparen]).to eq("{")
        expect(parse_paren[:number]).to eq("0")
        expect(parse_paren[:rparen]).to eq("}")
      end
    end

    context "contains HTML math example #4" do
      let(:string) { "abc(weatever text [and things])" }
      it "returns abstract parsed tree" do
        parse_paren   = formula[:expression][:expression][:parse_parenthesis]
        parse_paren_2 = parse_paren[:expression][:expression][:expression][:expression][:expression][:expression][:expression][:expression][:expression][:expression][:expression][:parse_parenthesis]

        expect(formula[:text]).to eq("a")
        expect(formula[:expression][:text]).to eq("b")
        expect(formula[:expression][:expression][:text]).to eq("c")
        expect(parse_paren[:lparen]).to eq("(")
        expect(parse_paren[:text]).to eq("w")
        expect(parse_paren[:expression][:text]).to eq("e")
        expect(parse_paren_2[:lparen]).to eq("[")
        expect(parse_paren_2[:text]).to eq("a")
        expect(parse_paren_2[:expression][:text]).to eq("n")
        expect(parse_paren_2[:expression][:expression][:text]).to eq("d")
        expect(parse_paren_2[:rparen]).to eq("]")
        expect(parse_paren[:rparen]).to eq(")")
      end
    end

    context "contains HTML math example #5" do
      let(:string) { "ϑ(t)" }
      it "returns abstract parsed tree" do
        parse_paren = formula[:parse_parenthesis]

        expect(formula[:symbol]).to eq("ϑ")
        expect(parse_paren[:lparen]).to eq("(")
        expect(parse_paren[:text]).to eq("t")
        expect(parse_paren[:rparen]).to eq(")")
      end
    end

    context "contains HTML math example #6" do
      let(:string) { "<i>a</i><sup>2</sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:sequence][:text]).to eq("a")
        expect(formula[:sup_value][:number]).to eq("2")
      end
    end

    context "contains HTML math example #7" do
      let(:string) { "<i>a</i><sub>2</sub>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:sequence][:text]).to eq("a")
        expect(formula[:sub_value][:number]).to eq("2")
      end
    end

    context "contains HTML math example #8" do
      let(:string) { "<i>a</i><sup><i>n</i></sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:sequence][:text]).to eq("a")
        expect(formula[:sup_value][:sequence][:text]).to eq("n")
      end
    end

    context "contains HTML math example #9" do
      let(:string) { "<i>a</i><sub><i>n</i></sub>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:sequence][:text]).to eq("a")
        expect(formula[:sub_value][:sequence][:text]).to eq("n")
      end
    end

    context "contains HTML math example #10" do
      let(:string) { "2<sup>3</sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:number]).to eq("2")
        expect(formula[:sup_value][:number]).to eq("3")
      end
    end

    context "contains HTML math example #11" do
      let(:string) { "2<sup>3+4</sup>" }
      it "returns abstract parsed tree" do
        sup_value  = formula[:sup_value]
        expression = sup_value
        expression = expression[:expression]

        expect(formula[:sub_sup][:number]).to eq("2")
        expect(sup_value[:number]).to eq("3")
        expect(expression[:symbol]).to eq("+")
        expect(expression[:expression][:number]).to eq("4")
      end
    end

    context "contains HTML math example #12" do
      let(:string) { "2<sub>3+4</sub>" }
      it "returns abstract parsed tree" do
        sub_value  = formula[:sub_value]
        expression = sub_value[:expression]

        expect(formula[:sub_sup][:number]).to eq("2")
        expect(sub_value[:number]).to eq("3")
        expect(sub_value[:expression][:symbol]).to eq("+")
        expect(expression[:expression][:number]).to eq("4")
      end
    end

    context "contains HTML math example #13" do
      let(:string) { "<i>a</i><sub><i>b</i>+2</sub>" }
      it "returns abstract parsed tree" do
        sub_value  = formula[:sub_value]
        expression = sub_value[:expression]

        expect(formula[:sub_sup][:sequence][:text]).to eq("a")
        expect(sub_value[:sequence][:text]).to eq("b")
        expect(sub_value[:expression][:symbol]).to eq("+")
        expect(expression[:expression][:number]).to eq("2")
      end
    end

    context "contains HTML math example #14" do
      let(:string) { "<i>a</i><sup>-2</sup>" }
      it "returns abstract parsed tree" do
        sup_value = formula[:sup_value]

        expect(formula[:sub_sup][:sequence][:text]).to eq("a")
        expect(sup_value[:symbol]).to eq("-")
        expect(sup_value[:expression][:number]).to eq("2")
      end
    end

    context "contains HTML math example #15" do
      let(:string) { "<i>a</i><sub>-2</sub>" }
      it "returns abstract parsed tree" do
        sub_value = formula[:sub_value]

        expect(formula[:sub_sup][:sequence][:text]).to eq("a")
        expect(sub_value[:symbol]).to eq("-")
        expect(sub_value[:expression][:number]).to eq("2")
      end
    end

    context "contains HTML math example #16" do
      let(:string) { "<i>a</i><sup>-<i>n</i></sup>" }
      it "returns abstract parsed tree" do
        sup_value = formula[:sup_value]

        expect(formula[:sub_sup][:sequence][:text]).to eq("a")
        expect(sup_value[:symbol]).to eq("-")
        expect(sup_value[:expression][:sequence][:text]).to eq("n")
      end
    end

    context "contains HTML math example #17" do
      let(:string) { "<i>a</i><sub>-<i>n</i></sub>" }
      it "returns abstract parsed tree" do
        sub_value = formula[:sub_value]

        expect(formula[:sub_sup][:sequence][:text]).to eq("a")
        expect(sub_value[:symbol]).to eq("-")
        expect(sub_value[:expression][:sequence][:text]).to eq("n")
      end
    end

    context "contains HTML math example #18" do
      let(:string) { "<i>a</i><sub><i>n</i></sub><sup>2</sup>" }
      it "returns abstract parsed tree" do
        sub_value = formula[:sub_value]
        sup_value = formula[:sup_value]

        expect(formula[:sub_sup][:sequence][:text]).to eq("a")
        expect(sub_value[:sequence][:text]).to eq("n")
        expect(sup_value[:number]).to eq("2")
      end
    end

    context "contains HTML math example #19" do
      let(:string) { "<i>a</i><sub><i>n+1</i></sub><sup><i>b</i>+<i>c</i></sup>" }
      it "returns abstract parsed tree" do
        sub_expression = formula[:sub_value][:sequence]
        sup_expression = formula[:sup_value]

        expect(formula[:sub_sup][:sequence][:text]).to eq("a")
        expect(sub_expression[:text]).to eq("n")
        expect(sub_expression[:expression][:symbol]).to eq("+")
        expect(sub_expression[:expression][:expression][:number]).to eq("1")
        expect(sup_expression[:sequence][:text]).to eq("b")
        expect(sup_expression[:expression][:symbol]).to eq("+")
        expect(sup_expression[:expression][:expression][:sequence][:text]).to eq("c")
      end
    end

    context "contains HTML math example #20" do
      let(:string) { "<i>f</i>(<i>x</x>)" }
      it "returns abstract parsed tree" do
        int_exp = formula[:parse_parenthesis]

        expect(formula[:sequence][:text]).to eq("f")
        expect(int_exp[:lparen]).to eq("(")
        expect(int_exp[:sequence][:text]).to eq("x")
        expect(int_exp[:rparen]).to eq(")")
      end
    end

    context "contains HTML math example #21" do
      let(:string) { "<i>f</i>(<i>g</i>(<i>x</x>))" }
      it "returns abstract parsed tree" do
        first_value        = formula[:parse_parenthesis]
        nested_first_value = first_value[:parse_parenthesis]

        expect(formula[:sequence][:text]).to eq("f")
        expect(first_value[:lparen]).to eq("(")
        expect(first_value[:sequence][:text]).to eq("g")
        expect(nested_first_value[:lparen]).to eq("(")
        expect(nested_first_value[:sequence][:text]).to eq("x")
        expect(nested_first_value[:rparen]).to eq(")")
        expect(first_value[:rparen]).to eq(")")
      end
    end

    context "contains HTML math example #22" do
      let(:string) { "f&sum;(<i>n</i>)(<i>2</i>)" }
      it "returns abstract parsed tree" do
        sequence    = formula[:expression][:sequence]
        parse_paren = sequence[:parse_parenthesis]
        expression  = formula[:expression][:expression][:parse_parenthesis]

        expect(formula[:text]).to eq("f")
        expect(sequence[:symbol]).to eq("&sum;")
        expect(parse_paren[:lparen]).to eq("(")
        expect(parse_paren[:sequence][:text]).to eq("n")
        expect(parse_paren[:rparen]).to eq(")")
        expect(expression[:lparen]).to eq("(")
        expect(expression[:sequence][:number]).to eq("2")
        expect(expression[:rparen]).to eq(")")
      end
    end

    context "contains HTML math example #23" do
      let(:string) { "fib(<i>n</i>)" }
      it "returns abstract parsed tree" do
        expression  = formula[:expression]
        parse_paren = expression[:expression][:parse_parenthesis]

        expect(formula[:text]).to eq("f")
        expect(expression[:text]).to eq("i")
        expect(expression[:expression][:text]).to eq("b")
        expect(parse_paren[:lparen]).to eq("(")
        expect(parse_paren[:sequence][:text]).to eq("n")
        expect(parse_paren[:rparen]).to eq(")")
      end
    end

    context "contains HTML math example #24" do
      let(:string) { "<i>f</i><sub>max</sub>" }
      it "returns abstract parsed tree" do
        sub_value = formula[:sub_value]

        expect(formula[:sub_sup][:sequence][:text]).to eq("f")
        expect(sub_value[:text]).to eq("m")
        expect(sub_value[:expression][:text]).to eq("a")
        expect(sub_value[:expression][:expression][:text]).to eq("x")
      end
    end

    context "contains HTML math example #25" do
      let(:string) { "<i>&omega;</i>" }
      it "returns abstract parsed tree" do
        expect(formula[:sequence][:symbol]).to eq("&omega;")
      end
    end

    context "contains HTML math example #26" do
      let(:string) { "<i>&Omega;</i>" }
      it "returns abstract parsed tree" do
        expect(formula[:sequence][:symbol]).to eq("&Omega;")
      end
    end

    context "contains HTML math example #27" do
      let(:string) { "αβγ" }
      it "returns abstract parsed tree" do
        expression = formula[:expression]

        expect(formula[:symbol]).to eq("α")
        expect(expression[:symbol]).to eq("β")
        expect(expression[:expression][:symbol]).to eq("γ")
      end
    end

    context "contains HTML math example #28" do
      let(:string) { "абг" }
      it "returns abstract parsed tree" do
        expression = formula[:expression]

        expect(formula[:symbol]).to eq("а")
        expect(expression[:symbol]).to eq("б")
        expect(expression[:expression][:symbol]).to eq("г")
      end
    end

    context "contains HTML math example #29" do
      let(:string) { "<i>f</i><sup>-1</sup>(<i>x</x>)" }
      it "returns abstract parsed tree" do
        sup_value   = formula[:sup_value]
        parse_paren = formula[:expression][:parse_parenthesis]

        expect(formula[:sub_sup][:sequence][:text]).to eq("f")
        expect(sup_value[:symbol]).to eq("-")
        expect(sup_value[:expression][:number]).to eq("1")
        expect(parse_paren[:lparen]).to eq("(")
        expect(parse_paren[:sequence][:text]).to eq("x")
        expect(parse_paren[:rparen]).to eq(")")
      end
    end

    context "contains HTML math example #30" do
      let(:string) { "<sub>sth</sub>" }
      it "returns abstract parsed tree" do
        expression = formula[:sequence][:expression]

        expect(formula[:sequence][:text]).to eq("s")
        expect(expression[:text]).to eq("t")
        expect(expression[:expression][:text]).to eq("h")
      end
    end

    context "contains HTML math example #31" do
      let(:string) { "root(<i>sth</i>)" }
      it "returns abstract parsed tree" do
        expression  = formula[:expression][:expression]
        parse_paren = expression[:expression][:parse_parenthesis]

        expect(formula[:text]).to eq("r")
        expect(formula[:expression][:text]).to eq("o")
        expect(expression[:text]).to eq("o")
        expect(expression[:expression][:text]).to eq("t")
        expect(parse_paren[:lparen]).to eq("(")
        expect(parse_paren[:sequence][:text]).to eq("s")
        expect(parse_paren[:sequence][:expression][:text]).to eq("t")
        expect(parse_paren[:sequence][:expression][:expression][:text]).to eq("h")
        expect(parse_paren[:rparen]).to eq(")")
      end
    end

    context "contains HTML math example #32" do
      let(:string) { "<table><tr><td>Something</td></tr></table>" }

      it "returns abstract parsed tree" do
        td_value   = formula[:table_value][:tr_value][:td_value]
        expression = td_value[:expression][:expression][:expression][:expression]

        expect(td_value[:text]).to eq("S")
        expect(td_value[:expression][:text]).to eq("o")
        expect(td_value[:expression][:expression][:text]).to eq("m")
        expect(td_value[:expression][:expression][:expression][:text]).to eq("e")
        expect(td_value[:expression][:expression][:expression][:expression][:text]).to eq("t")
        expect(expression[:expression][:text]).to eq("h")
        expect(expression[:expression][:expression][:text]).to eq("i")
        expect(expression[:expression][:expression][:expression][:text]).to eq("n")
        expect(expression[:expression][:expression][:expression][:expression][:text]).to eq("g")
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
        table_value = formula[:table_value]
        expression  = table_value[:expression][:expression]

        expect(table_value[:tr_value][:td_value][:number]).to eq("4")
        expect(table_value[:expression][:tr_value][:td_value][:number]).to eq("3")
        expect(expression[:tr_value][:td_value][:number]).to eq("2")
        expect(expression[:expression][:tr_value][:td_value][:number]).to eq("1")
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
        table_value = formula[:table_value]
        td_value    = table_value[:tr_value][:td_value]

        expect(td_value[:text]).to eq("s")
        expect(td_value[:expression][:text]).to eq("o")
      end
    end

    context "contains HTML math example #35" do
      let(:string) { "&sum;<sub>drop</sub><sup>prod</sup>" }
      it "returns abstract parsed tree" do
        sub_value = formula[:sub_value]
        sup_value = formula[:sup_value]

        expect(sub_value[:text]).to eq("d")
        expect(sub_value[:expression][:text]).to eq("r")
        expect(sub_value[:expression][:expression][:text]).to eq("o")
        expect(sub_value[:expression][:expression][:expression][:text]).to eq("p")
        expect(sup_value[:text]).to eq("p")
        expect(sup_value[:expression][:text]).to eq("r")
        expect(sup_value[:expression][:expression][:text]).to eq("o")
        expect(sup_value[:expression][:expression][:expression][:text]).to eq("d")
      end
    end

    context "contains HTML math example #36" do
      let(:string) { "&sum;<sub>drop</sub><sup>p</sup>" }
      it "returns abstract parsed tree" do
        sub_value = formula[:sub_value]
        sup_value = formula[:sup_value]

        expect(formula[:sub_sup][:sum_prod]).to eq("&sum;")
        expect(sup_value[:text]).to eq("p")
        expect(sub_value[:text]).to eq("d")
        expect(sub_value[:expression][:text]).to eq("r")
        expect(sub_value[:expression][:expression][:text]).to eq("o")
        expect(sub_value[:expression][:expression][:expression][:text]).to eq("p")
      end
    end

    context "contains HTML math example #37" do
      let(:string) { "&sum;<sup>p</sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:sum_prod]).to eq("&sum;")
        expect(formula[:sup_value][:text]).to eq("p")
      end
    end

    context "contains HTML math example #38" do
      let(:string) { "&sum;<sup>prod</sup>" }
      it "returns abstract parsed tree" do
        sup_value  = formula[:sup_value]
        expression = sup_value[:expression]

        expect(formula[:sub_sup][:sum_prod]).to eq("&sum;")
        expect(sup_value[:text]).to eq("p")
        expect(sup_value[:expression][:text]).to eq("r")
        expect(expression[:expression][:text]).to eq("o")
        expect(expression[:expression][:expression][:text]).to eq("d")
      end
    end

    context "contains HTML math example #39" do
      let(:string) { "&sum;<sub>prod</sub>" }
      it "returns abstract parsed tree" do
        sub_value = formula[:sub_value]

        expect(formula[:sub_sup][:sum_prod]).to eq("&sum;")
        expect(sub_value[:text]).to eq("p")
        expect(sub_value[:expression][:text]).to eq("r")
        expect(sub_value[:expression][:expression][:text]).to eq("o")
        expect(sub_value[:expression][:expression][:expression][:text]).to eq("d")
      end
    end

    context "contains HTML math example #40" do
      let(:string) { "2<sub>3</sub>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:number]).to eq("2")
        expect(formula[:sub_value][:number]).to eq("3")
      end
    end

    context "contains HTML math example #41" do
      let(:string) { "&sum;<sub>3</sub><sup>5</sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:sum_prod]).to eq("&sum;")
        expect(formula[:sub_value][:number]).to eq("3")
        expect(formula[:sup_value][:number]).to eq("5")
      end
    end

    context "contains HTML math example #42" do
      let(:string) { "2<sub>3</sub><sup>5</sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:number]).to eq("2")
        expect(formula[:sub_value][:number]).to eq("3")
      end
    end

    context "contains HTML math example #43" do
      let(:string) { "2<sub>so</sub><sup>we</sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:number]).to eq("2")
        expect(formula[:sub_value][:text]).to eq("s")
        expect(formula[:sub_value][:expression][:text]).to eq("o")
        expect(formula[:sup_value][:text]).to eq("w")
        expect(formula[:sup_value][:expression][:text]).to eq("e")
      end
    end

    context "contains HTML math example #44" do
      let(:string) { "2<sub>s</sub><sup>we</sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:number]).to eq("2")
        expect(formula[:sub_value][:text]).to eq("s")
        expect(formula[:sup_value][:text]).to eq("w")
        expect(formula[:sup_value][:expression][:text]).to eq("e")
      end
    end

    context "contains HTML math example #45" do
      let(:string) { "2<sub>so</sub><sup>w</sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:number]).to eq("2")
        expect(formula[:sub_value][:text]).to eq("s")
        expect(formula[:sub_value][:expression][:text]).to eq("o")
        expect(formula[:sup_value][:text]).to eq("w")
      end
    end

    context "contains HTML math example #46" do
      let(:string) { "s<sub>so</sub><sup>w</sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:text]).to eq("s")
        expect(formula[:sub_value][:text]).to eq("s")
        expect(formula[:sub_value][:expression][:text]).to eq("o")
        expect(formula[:sup_value][:text]).to eq("w")
      end
    end

    context "contains HTML math example #47" do
      let(:string) { "s<sub>so</sub><sup>we</sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:text]).to eq("s")
        expect(formula[:sub_value][:text]).to eq("s")
        expect(formula[:sub_value][:expression][:text]).to eq("o")
        expect(formula[:sup_value][:text]).to eq("w")
        expect(formula[:sup_value][:expression][:text]).to eq("e")
      end
    end

    context "contains HTML math example #48" do
      let(:string) { "s<sub>s</sub><sup>we</sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:text]).to eq("s")
        expect(formula[:sub_value][:text]).to eq("s")
        expect(formula[:sup_value][:text]).to eq("w")
        expect(formula[:sup_value][:expression][:text]).to eq("e")
      end
    end

    context "contains HTML math example #49" do
      let(:string) { "<i>lim</i>(3)(e)" }
      it "returns abstract parsed tree" do
        first_value = formula[:first_value]
        second_value = formula[:second_value]

        expect(formula[:binary]).to eq("lim")
        expect(first_value[:lparen]).to eq("(")
        expect(first_value[:number]).to eq("3")
        expect(first_value[:rparen]).to eq(")")
        expect(second_value[:lparen]).to eq("(")
        expect(second_value[:text]).to eq("e")
        expect(second_value[:rparen]).to eq(")")
      end
    end

    context "contains HTML math example #50" do
      let(:string) { "<i>lim</i>(3e)(em)" }
      it "returns abstract parsed tree" do
        first_value = formula[:first_value]
        second_value = formula[:second_value]

        expect(formula[:binary]).to eq("lim")
        expect(first_value[:lparen]).to eq("(")
        expect(first_value[:number]).to eq("3")
        expect(first_value[:expression][:text]).to eq("e")
        expect(first_value[:rparen]).to eq(")")
        expect(second_value[:lparen]).to eq("(")
        expect(second_value[:text]).to eq("e")
        expect(second_value[:expression][:text]).to eq("m")
        expect(second_value[:rparen]).to eq(")")
      end
    end

    context "contains HTML math example #51" do
      let(:string) { "<i>lim</i>(3am)(rest)" }
      it "returns abstract parsed tree" do
        first_value = formula[:first_value]
        second_value = formula[:second_value]

        expect(formula[:binary]).to eq("lim")
        expect(first_value[:lparen]).to eq("(")
        expect(first_value[:number]).to eq("3")
        expect(first_value[:expression][:text]).to eq("a")
        expect(first_value[:expression][:expression][:text]).to eq("m")
        expect(first_value[:rparen]).to eq(")")
        expect(second_value[:lparen]).to eq("(")
        expect(second_value[:text]).to eq("r")
        expect(second_value[:expression][:text]).to eq("e")
        expect(second_value[:expression][:expression][:text]).to eq("s")
        expect(second_value[:expression][:expression][:expression][:text]).to eq("t")
        expect(second_value[:rparen]).to eq(")")
      end
    end

    context "contains HTML math example #52" do
      let(:string) { "<i>log</i><sub>3</sub><sup>e</sup>" }
      it "returns abstract parsed tree" do
        expect(formula[:sub_sup][:sequence][:sum_prod]).to eq("log")
        expect(formula[:sub_value][:number]).to eq("3")
        expect(formula[:sup_value][:text]).to eq("e")
      end
    end

    context "contains HTML math example #53" do
      let(:string) { "2<i>mod</i>e" }
      it "returns abstract parsed tree" do
        expect(formula[:first_value][:number]).to eq("2")
        expect(formula[:binary]).to eq("mod")
        expect(formula[:second_value][:text]).to eq("e")
      end
    end

    context "contains HTML math example #54" do
      let(:string) { "<i>2</i><i>mod</i><i>e</i>" }
      it "returns abstract parsed tree" do
        expect(formula[:first_value][:sequence][:number]).to eq("2")
        expect(formula[:binary]).to eq("mod")
        expect(formula[:second_value][:sequence][:text]).to eq("e")
      end
    end

    context "contains HTML math example #55" do
      let(:string) { "<i>2a</i><i>mod</i><i>em</i>" }
      it "returns abstract parsed tree" do
        expect(formula[:first_value][:sequence][:number]).to eq("2")
        expect(formula[:first_value][:sequence][:expression][:text]).to eq("a")
        expect(formula[:binary]).to eq("mod")
        expect(formula[:second_value][:sequence][:text]).to eq("e")
        expect(formula[:second_value][:sequence][:expression][:text]).to eq("m")
      end
    end

    context "contains HTML math example #55" do
      let(:string) { "2a<i>mod</i>em" }
      it "returns abstract parsed tree" do
        expression = formula[:sequence][:expression]

        expect(formula[:sequence][:number]).to eq("2")
        expect(expression[:first_value][:text]).to eq("a")
        expect(expression[:binary]).to eq("mod")
        expect(expression[:second_value][:text]).to eq("e")
        expect(formula[:expression][:text]).to eq("m")
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
