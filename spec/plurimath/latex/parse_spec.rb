require_relative "../../../lib/plurimath/math"
require_relative "../../../lib/plurimath/latex/parse"
require_relative "../../../lib/plurimath/latex/constants"

RSpec.describe Plurimath::Latex::Parse do

  describe ".parse" do
    subject(:formula) {
      described_class.new.parse(string.squeeze(" ").gsub(" ", "").gsub("\n", ""))
    }

    context "contains command with single argument" do
      let(:string) {
        <<~LATEX
          {3}\\cos{\\beta}
        LATEX
      }
      it "returns abstract parsed tree" do
        sequence = formula[:sequence]
        unary = formula[:expression][:unary_functions]

        expect(sequence[:lparen]).to eq("{")
        expect(sequence[:expression][:number]).to eq("3")
        expect(sequence[:rparen]).to eq("}")
        expect(unary[:unary]).to eq("cos")
        expect(unary[:first_value][:lparen]).to eq("{")
        expect(unary[:first_value][:expression][:symbols]).to eq("beta")
        expect(unary[:first_value][:rparen]).to eq("}")
      end
    end

    context "contains only nested values" do
      let(:string) {
        <<~LATEX
          {a+{b}}
        LATEX
      }
      it "returns abstract parsed tree" do
        expression = formula[:expression]

        expect(formula[:lparen]).to eq("{")
        expect(expression[:sequence][:text]).to eq("a")
        expect(expression[:expression][:sequence][:operant]).to eq("+")
        expect(expression[:expression][:expression][:lparen]).to eq("{")
        expect(expression[:expression][:expression][:expression][:text]).to eq("b")
        expect(expression[:expression][:expression][:rparen]).to eq("}")
        expect(formula[:rparen]).to eq("}")
      end
    end

    context "contains command with multiple arguments" do
      let(:string) {
        <<~LATEX
          \\left(\\beta\\slash{t}\\right)
        LATEX
      }
      it "returns parsed tree" do
        left_right = formula[:left_right]

        expect(left_right[:lparen]).to eq("(")
        expect(left_right[:sequence][:symbols]).to eq("beta")
        expect(left_right[:expression][:sequence][:symbols]).to eq("slash")
        expect(left_right[:expression][:expression][:expression][:text]).to eq("t")
        expect(left_right[:rparen]).to eq(")")
      end
    end

    context "contains sqrt commands" do
      let(:string) {
        <<~LATEX
          \\sqrt {\\sqrt {\\left( t{3}\\right) v}}
        LATEX
      }
      it "returns parsed tree" do
        binary = formula[:binary][:intermediate_exp][:expression][:binary]

        expect(formula[:binary][:sqrt]).to eq("sqrt")
        expect(binary[:sqrt]).to eq("sqrt")
        expect(binary[:intermediate_exp][:expression][:sequence][:left_right][:sequence][:text]).to eq("t")
        expect(binary[:intermediate_exp][:expression][:expression][:text]).to eq("v")
      end
    end

    context "contains overline commands" do
      let(:string) {
        <<~LATEX
          \\overline{v}
        LATEX
      }
      it "returns parsed tree" do
        expect(formula[:unary_functions][:unary]).to eq("overline")
        expect(formula[:unary_functions][:first_value][:expression][:text]).to eq("v")
      end
    end

    context "contains empty subscript" do
      let(:string) {
        <<~LATEX
          1_{}
        LATEX
      }
      it "returns parsed tree" do
        expect(formula[:base][:number]).to eq("1")
        expect(formula[:base][:subscript][:lparen]).to eq("{")
        expect(formula[:base][:subscript][:rparen]).to eq("}")
      end
    end

    context "contains sum with sub and sup script" do
      let(:string) {
        <<~LATEX
          \\sum_{n=1}^{\\infty}
        LATEX
      }
      it "returns parsed tree" do
        binary = formula[:power_base]
        expression = binary[:subscript][:expression]

        expect(binary[:binary]).to eq("sum")
        expect(expression[:sequence][:text]).to eq("n")
        expect(expression[:expression][:sequence][:operant]).to eq("=")
        expect(expression[:expression][:expression][:number]).to eq("1")
        expect(binary[:supscript][:expression][:symbols]).to eq("infty")
      end
    end

    context "contains prod with sup and sub script" do
      let(:string) {
        <<~LATEX
          \\prod^{\\infty}_{n=1}
        LATEX
      }
      it "returns parsed tree" do
        power_base = formula[:power_base]

        expect(power_base[:binary]).to eq("prod")
        expect(power_base[:supscript][:expression][:symbols]).to eq("infty")
        expect(power_base[:subscript][:expression][:sequence][:text]).to eq("n")
        expect(power_base[:subscript][:expression][:expression][:sequence][:operant]).to eq("=")
        expect(power_base[:subscript][:expression][:expression][:expression][:number]).to eq("1")
      end
    end

    context "contains bmod with two arguments" do
      let(:string) {
        <<~LATEX
          {a}\\bmod{b}
        LATEX
      }
      it "returns parsed tree" do
        expect(formula[:under_over][:first_value][:expression][:text]).to eq("a")
        expect(formula[:under_over][:binary]).to eq("bmod")
        expect(formula[:under_over][:second_value][:expression][:text]).to eq("b")
      end
    end

    context "contains pmod with two arguments" do
      let(:string) {
        <<~LATEX
          {a}\\pmod{b}
        LATEX
      }
      it "returns parsed tree" do
        expect(formula[:under_over][:first_value][:expression][:text]).to eq("a")
        expect(formula[:under_over][:binary]).to eq("pmod")
        expect(formula[:under_over][:second_value][:expression][:text]).to eq("b")
      end
    end

    context "contains simple math equation" do
      let(:string) {
        <<~LATEX
          3x-5y+4z=0
        LATEX
      }
      it "returns parsed tree" do
        expect(formula[:sequence][:number]).to eq("3")
        expect(formula[:expression][:sequence][:text]).to eq("x")
        expect(formula[:expression][:expression][:sequence][:operant]).to eq("-")
      end
    end

    context "contains simple multiplication math equation" do
      let(:string) {
        <<~LATEX
          3x*2
        LATEX
      }
      it "returns parsed tree" do
        expression = formula[:expression]
        expect(formula[:sequence][:number]).to eq("3")
        expect(expression[:sequence][:text]).to eq("x")
        expect(expression[:expression][:sequence][:operant]).to eq("*")
        expect(expression[:expression][:expression][:number]).to eq("2")
      end
    end

    context "contains simple use of over" do
      let(:string) {
        <<~LATEX
          1 \\over 2
        LATEX
      }
      it "returns parsed tree" do
        expect(formula[:under_over][:first_value][:number]).to eq("1")
        expect(formula[:under_over][:binary]).to eq("over")
        expect(formula[:under_over][:second_value][:number]).to eq("2")
      end
    end

    context "contains array environment and math equation" do
      let(:string) {
        <<~LATEX
          \\begin{array}{l}{3x-5y+4z=0}\\end{array}
        LATEX
      }
      it "returns parsed tree" do
        environment = formula[:environment]
        opening = environment[:begining]
        ending = environment[:ending]

        expect(opening[:expression][:environment]).to eq("array")
        expect(environment[:args][:text]).to eq("l")
        expect(ending[:expression][:environment]).to eq("array")
      end
    end

    context "contains matix environment and subscript math equation" do
      let(:string) {
        <<~LATEX
          \\begin{matrix}a_{1} & b_{2} \\\\ \\end{matrix}
        LATEX
      }
      it "returns parsed tree" do
        environment = formula[:environment]
        begining = environment[:begining]
        table_data = environment[:table_data]
        base = table_data[:sequence][:base]

        expect(begining[:expression][:environment]).to eq("matrix")
        expect(base[:text]).to eq("a")
        expect(base[:subscript][:expression][:number]).to eq("1")
        expect(table_data[:expression][:sequence][:operant]).to eq("&")
        expect(table_data[:expression][:expression][:expression]["\\\\"]).to eq("\\\\")
      end
    end

    context "contains binom command" do
      let(:string) {
        <<~LATEX
          \\binom{2}{3}
        LATEX
      }
      it "returns parsed tree" do
        binary = formula[:binary]

        expect(binary[:binary]).to eq("binom")
        expect(binary[:first_value][:expression][:number]).to eq("2")
        expect(binary[:second_value][:expression][:number]).to eq("3")
      end
    end

    context "contains inline matrix" do
      let(:string) {
        <<~LATEX
          \\matrix{a & b}
        LATEX
      }
      it "returns parsed tree" do
        table_data = formula[:table_data]

        expect(table_data[:environment]).to eq("matrix")
        expect(table_data[:lparen]).to eq("{")
        expect(table_data[:expression][:sequence][:text]).to eq("a")
        expect(table_data[:expression][:expression][:sequence][:operant]).to eq("&")
        expect(table_data[:expression][:expression][:expression][:text]).to eq("b")
      end
    end

    context "contains matrix with simple two letters" do
      let(:string) {
        <<~LATEX
          \\begin{matrix} a & b \\end{matrix}
        LATEX
      }
      it "returns parsed tree" do
        environment = formula[:environment]
        table_data = environment[:table_data]

        expect(environment[:begining][:expression][:environment]).to eq("matrix")
        expect(table_data[:sequence][:text]).to eq("a")
        expect(table_data[:expression][:sequence][:operant]).to eq("&")
        expect(table_data[:expression][:expression][:text]).to eq("b")
        expect(environment[:ending][:expression][:environment]).to eq("matrix")
      end
    end

    context "contains matrix with negative value" do
      let(:string) {
        <<~LATEX
          \\begin{Bmatrix}-a & b \\\\ c & d \\end{Bmatrix}
        LATEX
      }
      it "returns parsed tree" do
        environment = formula[:environment]
        table_data = environment[:table_data]
        expression = table_data[:expression][:expression]

        expect(environment[:begining][:expression][:environment]).to eq("Bmatrix")
        expect(table_data[:sequence][:operant]).to eq("-")
        expect(table_data[:expression][:sequence][:text]).to eq("a")
        expect(expression[:sequence][:operant]).to eq("&")
        expect(expression[:expression][:sequence][:text]).to eq("b")
        expect(environment[:ending][:expression][:environment]).to eq("Bmatrix")
      end
    end

    context "contains pmatrix with simple letters" do
      let(:string) {
        <<~LATEX
          \\begin{pmatrix}a & b \\end{pmatrix}
        LATEX
      }
      it "returns parsed tree" do
        environment = formula[:environment]

        expect(environment[:begining][:expression][:environment]).to eq("pmatrix")
        expect(environment[:table_data][:sequence][:text]).to eq("a")
        expect(environment[:ending][:expression][:environment]).to eq("pmatrix")
      end
    end

    context "contains array environment without args list separator" do
      let(:string) {
        <<~LATEX
          \\begin{array}{c|r}
            1 & 2 \\hline \\\\ 3 & 4
          \\end{array}
        LATEX
      }
      it "returns parsed tree" do
        environment = formula[:environment]
        table_data = environment[:table_data]

        expect(environment[:begining][:expression][:environment]).to eq("array")
        expect(environment[:args][:sequence][:text]).to eq("c")
        expect(environment[:args][:expression][:sequence][:operant]).to eq("|")
        expect(environment[:args][:expression][:expression][:text]).to eq("r")
        expect(table_data[:expression][:expression][:expression][:sequence][:symbols]).to eq("hline")
        expect(environment[:ending][:expression][:environment]).to eq("array")
      end
    end

    context "contains bmatrix environment without args list separator" do
      let(:string) {
        <<~LATEX
          \\begin{bmatrix}
            a_{1,2} & \\vdots & \\cdots & \\ddots \\\\
          \\end{bmatrix}
        LATEX
      }
      it "returns parsed tree" do
        environment = formula[:environment]
        table_data = environment[:table_data]
        base = table_data[:sequence][:base]
        expression = base[:subscript][:expression]

        expect(environment[:begining][:expression][:environment]).to eq("bmatrix")
        expect(base[:text]).to eq("a")
        expect(expression[:sequence][:number]).to eq("1")
        expect(expression[:expression][:sequence][:operant]).to eq(",")
        expect(expression[:expression][:expression][:number]).to eq("2")
        expect(table_data[:expression][:sequence][:operant]).to eq("&")
        expect(table_data[:expression][:expression][:sequence][:symbols]).to eq("vdots")
        expect(environment[:ending][:expression][:environment]).to eq("bmatrix")
      end
    end

    context "contains vmatrix with sqrt complete equation" do
      let(:string) {
        <<~LATEX
          \\begin{Vmatrix}
            \\sqrt{(-25)^{2}} = \\pm 25
          \\end{Vmatrix}
        LATEX
      }
      it "returns parsed tree" do
        environment = formula[:environment]
        table_data = formula[:environment][:table_data]
        power = table_data[:sequence][:binary][:intermediate_exp][:expression][:power]

        expect(environment[:begining][:expression][:environment]).to eq("Vmatrix")
        expect(table_data[:sequence][:binary][:sqrt]).to eq("sqrt")
        expect(power[:expression][:sequence][:operant]).to eq("-")
        expect(power[:expression][:expression][:number]).to eq("25")
        expect(power[:supscript][:expression][:number]).to eq("2")
        expect(environment[:ending][:expression][:environment]).to eq("Vmatrix")
      end
    end

    context "contains log with subscript" do
      let(:string) {
        <<~LATEX
          \\log_2{x}
        LATEX
      }
      it "returns parsed tree" do
        base = formula[:sequence][:base]
        expression = formula[:expression]
        expect(base[:binary]).to eq("log")
        expect(base[:subscript][:number]).to eq("2")
        expect(expression[:lparen]).to eq("{")
        expect(expression[:expression][:text]).to eq("x")
        expect(expression[:rparen]).to eq("}")
      end
    end

    context "contains lim with subscript and f" do
      let(:string) {
        <<~LATEX
          \\lim_{x\\to +\\infty} f(x)
        LATEX
      }
      it "returns parsed tree" do
        binary = formula[:sequence][:base]
        expression = binary[:subscript][:expression][:expression]

        expect(binary[:binary]).to eq("lim")
        expect(binary[:subscript][:expression][:sequence][:text]).to eq("x")
        expect(expression[:sequence][:symbols]).to eq("to")
        expect(expression[:expression][:sequence][:operant]).to eq("+")
        expect(expression[:expression][:expression][:symbols]).to eq("infty")
        expect(formula[:expression][:sequence][:text]).to eq("f")
        expect(formula[:expression][:expression][:expression][:text]).to eq("x")
      end
    end

    context "contains lim with subscript and f" do
      let(:string) {
        <<~LATEX
          \\left( \\begin{array}{c}
              V_x  \\\\
              V_y  \\end{array} \\right)
        LATEX
      }
      it "returns parsed tree" do
        environment = formula[:left_right][:environment]
        sequence = environment[:table_data][:sequence]
        expression = environment[:table_data][:expression][:expression]

        expect(formula[:left_right][:lparen]).to eq("(")
        expect(environment[:begining][:expression][:environment]).to eq("array")
        expect(environment[:args][:text]).to eq("c")
        expect(sequence[:base][:text]).to eq("V")
        expect(sequence[:base][:subscript][:text]).to eq("x")
        expect(expression[:base][:text]).to eq("V")
        expect(expression[:base][:subscript][:text]).to eq("y")
      end
    end

    context "contains mbox" do
      let(:string) {
        <<~LATEX
          \\mbox{a+b}
        LATEX
      }
      it "returns formula" do
        expect(formula[:unary_functions][:text]).to eq("a+b")
      end
    end
  end
end
