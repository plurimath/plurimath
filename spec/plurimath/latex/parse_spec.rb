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
        unary    = formula[:expression][:unary_functions]
        sequence = formula[:sequence]

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
        expect(expression[:sequence][:symbols]).to eq("a")
        expect(expression[:expression][:sequence][:operant]).to eq("+")
        expect(expression[:expression][:expression][:lparen]).to eq("{")
        expect(expression[:expression][:expression][:expression][:symbols]).to eq("b")
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
        expression = left_right[:expression]

        expect(left_right[:lparen]).to eq("(")
        expect(expression[:sequence][:symbols]).to eq("beta")
        expect(left_right[:expression][:expression][:sequence][:symbols]).to eq("slash")
        expect(left_right[:expression][:expression][:expression][:expression][:symbols]).to eq("t")
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
        expect(binary[:intermediate_exp][:expression][:sequence][:left_right][:expression][:sequence][:symbols]).to eq("t")
        expect(binary[:intermediate_exp][:expression][:expression][:symbols]).to eq("v")
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
        expect(formula[:unary_functions][:first_value][:expression][:symbols]).to eq("v")
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
        expect(expression[:sequence][:symbols]).to eq("n")
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
        expect(power_base[:subscript][:expression][:sequence][:symbols]).to eq("n")
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
        expect(formula[:under_over][:first_value][:expression][:symbols]).to eq("a")
        expect(formula[:under_over][:binary]).to eq("bmod")
        expect(formula[:under_over][:second_value][:expression][:symbols]).to eq("b")
      end
    end

    context "contains pmod with two arguments" do
      let(:string) {
        <<~LATEX
          {a}\\pmod{b}
        LATEX
      }
      it "returns parsed tree" do
        expect(formula[:under_over][:first_value][:expression][:symbols]).to eq("a")
        expect(formula[:under_over][:binary]).to eq("pmod")
        expect(formula[:under_over][:second_value][:expression][:symbols]).to eq("b")
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
        expect(formula[:expression][:sequence][:symbols]).to eq("x")
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
        expect(expression[:sequence][:symbols]).to eq("x")
        expect(expression[:expression][:sequence][:operant]).to eq("*")
        expect(expression[:expression][:expression][:number]).to eq("2")
      end
    end

    context "contains simple use of over" do
      let(:string) {
        <<~LATEX
          {1 \\over 2}
        LATEX
      }
      it "returns parsed tree" do
        expect(formula[:over][:dividend].first[:number]).to eq("1")
        expect(formula[:over][:divisor].first[:number]).to eq("2")
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
        expect(environment[:args][:symbols]).to eq("l")
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
        expect(base[:symbols]).to eq("a")
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
        expect(table_data[:expression][:sequence][:symbols]).to eq("a")
        expect(table_data[:expression][:expression][:sequence][:operant]).to eq("&")
        expect(table_data[:expression][:expression][:expression][:symbols]).to eq("b")
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
        expect(table_data[:sequence][:symbols]).to eq("a")
        expect(table_data[:expression][:sequence][:operant]).to eq("&")
        expect(table_data[:expression][:expression][:symbols]).to eq("b")
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
        expect(table_data[:expression][:sequence][:symbols]).to eq("a")
        expect(expression[:sequence][:operant]).to eq("&")
        expect(expression[:expression][:sequence][:symbols]).to eq("b")
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
        expect(environment[:table_data][:sequence][:symbols]).to eq("a")
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
        expect(environment[:args][:sequence][:symbols]).to eq("c")
        expect(environment[:args][:expression][:sequence][:operant]).to eq("|")
        expect(environment[:args][:expression][:expression][:symbols]).to eq("r")
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
        expect(base[:symbols]).to eq("a")
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
        expect(expression[:expression][:symbols]).to eq("x")
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
        expect(binary[:subscript][:expression][:sequence][:symbols]).to eq("x")
        expect(expression[:sequence][:symbols]).to eq("to")
        expect(expression[:expression][:sequence][:operant]).to eq("+")
        expect(expression[:expression][:expression][:symbols]).to eq("infty")
        expect(formula[:expression][:sequence][:symbols]).to eq("f")
        expect(formula[:expression][:expression][:expression][:symbols]).to eq("x")
      end
    end

    context "contains array environment with simple equation" do
      let(:string) {
        <<~LATEX
          \\left( \\begin{array}{c}
              V_x  \\\\
              V_y  \\end{array} \\right)
        LATEX
      }
      it "returns parsed tree" do
        environment = formula[:left_right][:expression][:environment]
        sequence = environment[:table_data][:sequence]
        expression = environment[:table_data][:expression][:expression]

        expect(formula[:left_right][:lparen]).to eq("(")
        expect(environment[:begining][:expression][:environment]).to eq("array")
        expect(environment[:args][:symbols]).to eq("c")
        expect(sequence[:base][:symbols]).to eq("V")
        expect(sequence[:base][:subscript][:symbols]).to eq("x")
        expect(expression[:base][:symbols]).to eq("V")
        expect(expression[:base][:subscript][:symbols]).to eq("y")
      end
    end

    context "contains mbox" do
      let(:string) {
        <<~LATEX
          \\mbox{a+b}
        LATEX
      }
      it "returns formula" do
        first_value = formula[:unary_functions][:first_value][:expression]

        expect(formula[:unary_functions][:unary]).to eq("mbox")
        expect(first_value[:sequence][:symbols]).to eq("a")
        expect(first_value[:expression][:sequence][:operant]).to eq("+")
        expect(first_value[:expression][:expression][:symbols]).to eq("b")
      end
    end

    context "contains complex base equation" do
      let(:string) {
        <<~LATEX
          \\vec{F} = F_x \\hat{e}_x + F_y \\hat{e}_y + F_z
          \\hat{e}_z = \\int \\vec{f} \\ ,dA,
        LATEX
      }
      it "returns formula" do
        vec = formula[:sequence][:unary_functions]
        base = formula[:expression][:expression][:sequence][:base]

        expect(vec[:unary]).to eq("vec")
        expect(vec[:first_value][:expression][:symbols]).to eq("F")
        expect(formula[:expression][:sequence][:operant]).to eq("=")
        expect(base[:symbols]).to eq("F")
        expect(base[:subscript][:symbols]).to eq("x")
      end
    end

    context "contains second complex base equation" do
      let(:string) {
        <<~LATEX
          \\vec{M} = M_x \\hat{e}_x + M_y \\hat{e}_y + M_z
          \\hat{e}_z = \\int (\\vec{r} - \\vec{r}_0) \\times \\vec{f} \\,dA.
        LATEX
      }
      it "returns formula" do
        vec = formula[:sequence][:unary_functions]
        base = formula[:expression][:expression][:sequence][:base]
        hat = formula[:expression][:expression][:expression][:sequence][:base][:unary_functions]

        expect(vec[:unary]).to eq("vec")
        expect(vec[:first_value][:expression][:symbols]).to eq("M")
        expect(formula[:expression][:sequence][:operant]).to eq("=")
        expect(base[:symbols]).to eq("M")
        expect(base[:subscript][:symbols]).to eq("x")
        expect(hat[:unary]).to eq("hat")
        expect(hat[:first_value][:expression][:symbols]).to eq("e")
      end
    end

    context "contains third complex base equation" do
      let(:string) {
        <<~LATEX
          L = \\vec{F} \\cdot \\hat{L}  \\qquad
          D = \\vec{F} \\cdot \\hat{D}
        LATEX
      }
      it "returns formula" do
        expression = formula[:expression][:expression]
        unary_function = expression[:sequence][:unary_functions]

        expect(formula[:sequence][:symbols]).to eq("L")
        expect(formula[:expression][:sequence][:operant]).to eq("=")
        expect(unary_function[:unary]).to eq("vec")
        expect(unary_function[:first_value][:expression][:symbols]).to eq("F")
        expect(expression[:expression][:sequence][:symbols]).to eq("cdot")
      end
    end

    context "contains fourth complex base equation" do
      let(:string) {
        <<~LATEX
          \\vec{M} = M_\\xi \\hat{e}_{\\xi} + M_\\eta \\hat{e}_{\\eta} + M_\\zeta
          \\hat{e}_{\\zeta} = \\int (\\vec{r} - \\vec{r}_0) \\times \\vec{f} \\,dA.
        LATEX
      }
      it "returns formula" do
        expression = formula[:expression][:expression]
        unary_function = expression[:sequence][:base]

        expect(formula[:sequence][:unary_functions][:unary]).to eq("vec")
        expect(formula[:sequence][:unary_functions][:first_value][:expression][:symbols]).to eq("M")
        expect(formula[:expression][:sequence][:operant]).to eq("=")
        expect(unary_function[:symbols]).to eq("M")
        expect(unary_function[:subscript][:symbols]).to eq("xi")
      end
    end

    context "contains fifth complex split environment" do
      let(:string) {
        <<~LATEX
          \\begin{split}
            C_L &= {L \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 S} \\\\ \\\\
            C_D &= {D \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 S} \\\\ \\\\
            \\vec{C}_M &= {\\beta \\vec{M} \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 c_\\textrm{ref} S_\\textrm{ref}},
          \\end{split}
        LATEX
      }
      it "returns formula" do
        environment = formula[:environment]
        table_data = environment[:table_data]

        expect(environment[:begining][:expression][:environment]).to eq("split")
        expect(table_data[:sequence][:base][:symbols]).to eq("C")
        expect(table_data[:sequence][:base][:subscript][:symbols]).to eq("L")
        expect(table_data[:expression][:sequence][:operant]).to eq("&")
        expect(environment[:ending][:expression][:environment]).to eq("split")
      end
    end

    context "contains sixth complex equation" do
      let(:string) {
        <<~LATEX
          c_l = {L' \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 c_\\textrm{ref}} \\qquad
          c_d = {D' \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 c_\\textrm{ref}} \\qquad
          \\vec{c}_m = {\\vec{M}' \\over {1\\over2} \\rho_\\textrm{ref} q_\\textrm{ref}^2 c_\\textrm{ref}^2},
        LATEX
      }
      it "returns formula" do
        over = formula[:expression][:expression][:sequence][:over]
        divisor = over[:divisor][0]

        expect(formula[:sequence][:base][:symbols]).to eq("c")
        expect(formula[:sequence][:base][:subscript][:symbols]).to eq("l")
        expect(formula[:expression][:sequence][:operant]).to eq("=")
        expect(over[:dividend][0][:sequence][:symbols]).to eq("L")
        expect(over[:dividend][0][:expression][:operant]).to eq("'")
        expect(divisor[:sequence][:over][:dividend][0][:number]).to eq("1")
        expect(divisor[:sequence][:over][:divisor][0][:number]).to eq("2")
      end
    end
  end
end
