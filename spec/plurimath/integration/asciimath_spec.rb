require_relative "../../../spec/spec_helper"

RSpec.describe Plurimath::Math do
  describe ".parse" do
    subject(:formula) { described_class.parse(string, :asciimath) }

    context "contains simple cos function with numeric value" do
      let(:string) { "A(ztext(/)overset(~)(gamma)) = sum_(i=1)^M overset(~)(gamma)_j^ia_iz^(-i), text( for ) j=1,2." }

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains simple cos function with numeric value" do
      let(:string) do
        <<~ASCIIMATH
          u^2((hat(ii(A))"e")(i,cc(l))^"meas") = ii(C)(i,cc(l))^2(ii(bb B^**),hat(ii(bb N)),
          hat(ii(bb R))) u^2 (hat(ii(D))(i,cc(l))) + hat(ii(D))(i,cc(l))^2 [((del ii(C)(i,cc(l))(ii(bb B),
          ii(bb N),ii(bb R)))/(del ii(bb Z)))^TT ii(bb V)(ii(bb Z^**)) (del ii(C)(i,cc(l))(ii(bb B),
          ii(bb N),ii(bb R)))/(del ii(bb Z))] |_(ii(bb Z) = ii(bb Z^**))
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains simple cos function with numeric value" do
      let(:string) do
        <<~ASCIIMATH
          {u_{"c"}^2 (ii(A)_x)}/{ii(A)_x^2} =
          {u^2 (ii(A)_{"S"})}/{ii(A)_{"S"}^2} + {u^2(m_{"S"})}/{m_{"S"}^2} +
          {u^2 (m_x)}/{m_x^2} + {u^2 (bar(ii(R))_x)}/{bar(ii(R))_x^2} +
          {u^2 (bar(ii(R))_{"S"})}/{bar(ii(R))_{"S"}^2} - 2r(bar(ii(R))_x,bar(ii(R))_{"S"})
          {u(bar(ii(R))_x) u(bar(ii(R))_{"S"})}/{bar(ii(R))_x bar(ii(R))_{"S"}}
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains ogc example #1" do
      let(:string) do
        <<~ASCIIMATH
          R_z(alpha) = [[cos alpha, - sin alpha, 0],
          [sin alpha, cos alpha, 0],
          [0, 0, 1]]
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains ogc example #2" do
      let(:string) do
        <<~ASCIIMATH
          R_y(beta) = [[cos beta, 0, sin beta],
          [0, 1, 0],
          [-sin beta, 0, cos beta]]
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains ogc example #3" do
      let(:string) do
        <<~ASCIIMATH
          R_x (gamma) = [[1, 0, 0],
          [0, cos gamma, -sin gamma],
          [0, sin gamma, cos gamma]]
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains ogc example #4" do
      let(:string) do
        <<~ASCIIMATH
          R(alpha,beta,gamma) = R_z (alpha) R_y (beta) R_x (gamma) = [[cos alpha cos beta, cos alpha sin beta sin gamma - sin alpha cos gamma, cos alpha sin beta cos gamma + sin alpha sin gamma],
          [sin alpha cos beta, sin alpha sin beta sin gamma + cos alpha cos gamma, sin alpha sin beta cos gamma - cos alpha sin gamma],
          [-sin beta, cos beta sin gamma, cos beta cos gamma]]
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains ogc example #5" do
      let(:string) do
        <<~ASCIIMATH
          "Convert"(x,y,z,p_a,p_o,R,S,T) = R_z(alpha) R_y(beta) R_x(gamma) S(x - a_x, y - a_y, z - a_z) + p_o + T = [[cos⁡ alpha cos beta, cos⁡ alpha sin⁡ beta sin⁡ gamma - sin⁡ alpha cos gamma, cos⁡ alpha sin⁡ beta cos⁡ gamma + sin⁡ alpha sin⁡ gamma],
          [sin⁡ alpha cos⁡ beta, sin⁡ alpha sin⁡ beta sin⁡ gamma + cos⁡ alpha cos⁡ gamma, sin⁡ alpha sin⁡ beta cos⁡ gamma - cos⁡ alpha sin⁡ gamma],
          [-sin⁡ beta, cos⁡ beta sin⁡ gamma, cos⁡ beta cos⁡ gamma]] [[s_x ∗ (x - a_x)],
          [s_y ∗ (y - a_y)],
          [s_z ∗ (z - a_z)]] +
          [[x_0 + t_x],
          [y_0 + t_y],
          [z_0 + t_z]]
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains bipm example #1" do
      let(:string) do
        <<~ASCIIMATH
          1 "unitsml(A)" = ( ((4pi xx 10^(-7)))/((9192631770)(299792458)(1)) )^(1/2) ( (Delta ii(nu)_("Cs")cm_(cc K))/(ii(mu)_0) )^(1/2) = 6.789687... xx 10^(-13) ((Delta ii(nu)_("Cs")c m_(cc K))/(ii(mu)_0))^(1/2)
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains itu example #1" do
      let(:string) do
        <<~ASCIIMATH
          [[A_11,A_12,...,A_(1n)],
          [A_21,A_22,...,A_(2n)],
          [.,.,.,.],[.,.,.,.],
          [.,.,.,.],
          [A_(m1),A_(m2),...,A_(mn)]]
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains jcgm example #1" do
      let(:string) do
        <<~ASCIIMATH
          bb(U_x) = [(u(x_1,x_1),cdots,u(x_1,x_N)),(vdots,ddots,vdots),(u(x_N,x_1),cdots,u(x_N,x_N))],
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains jcgm example #2" do
      let(:string) do
        <<~ASCIIMATH
          bb(U_x) = [({: u^2(x_1) :},{: u(x_1,x_2) :},{: cdots :},{: u(x_1,x_N) :}),
          ({: u(x_2,x_1) :},{: u^2(x_2) :},{: cdots :},{: u(x_2,x_N) :}),
          ({: vdots :},{: vdots :},{: ddots :},{: vdots :}),
          ({: u(x_N,x_1) :},{: u(x_N,x_2) :},{: cdots :},{: u^2(x_N) :})],
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains jcgm example #3" do
      let(:string) do
        <<~ASCIIMATH
          g_X (xi) = {Gamma (n//2)}/{Gamma((n-1)//2)sqrt((n - 1)pi)} times 1/{s//sqrt(n)} (1 + 1/{n - 1} ({xi - bar(x)}/{s//sqrt(n)}))^{-n//2},
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains jcgm example #4" do
      let(:string) do
        <<~ASCIIMATH
          [(x_1),(x_2)], " " [(u^2(x_1),ru(x_1)u(x_2)),(ru(x_1)u(x_2),u^2(x_2))].
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains jcgm example #5" do
      let(:string) do
        <<~ASCIIMATH
          bb(mu) = [(2.0),(3.0)], "    " bb(V) = [(2.0,1.9),(1.9,2.0)] " ",
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :asciimath), :asciimath)
        }.not_to raise_error
      end
    end

    context "contains jcgm example #6" do
      let(:string) do
        <<~ASCIIMATH
          \\mathit{F} ( \\mathit{\\nu}_{\\text{a}} , \\mathit{\\nu}_{\\text{b}} ) = \\frac{s_{\\text{a}}^{2}}{s_{\\text{b}}^{2}} = \\frac{\\mathit{K} s^{2} ( \\overline{\\mathit{V}}_{j} )}{s^{2} ( \\mathit{V} )_{j k}} = \\frac{5 ( 57 \\text{unitsml(uV)} )^{2}}{( 85 \\text{unitsml(uV)} )^{2}} = 2.25
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :latex), :latex)
        }.not_to raise_error
      end
    end

    context "contains jcgm example #7" do
      let(:string) do
        <<~ASCIIMATH
           "\\mathit{Y} = \\frac{P_{M}}{P_{S}} = \\frac{1 - | \\mathit{\\Gamma}_{M} |^{2}}{1 - | \\mathit{\\Gamma}_{S} |^{2}} \\times \\frac{| 1 - \\mathit{\\Gamma}_{S} \\mathit{\\Gamma}_{G} |^{2}}{| 1 - \\mathit{\\Gamma}_{M} \\mathit{\\Gamma}_{G} |^{2}} ,"
        ASCIIMATH
      end

      it 'returns instance of Asciimath' do
        expect{
          convert(string_to_formula(string, :latex), :latex)
        }.not_to raise_error
      end
    end
  end
end


def convert(formula, type)
  re_convert(formula, :omml)
  re_convert(formula, :latex)
  re_convert(formula, :mathml)
  re_convert(formula, :asciimath)
end

def re_convert(formula, type)
  supported_languages = %i[omml latex mathml asciimath]
  supported_languages.map do |lang|
    conversion(
      string_to_formula(
        conversion(formula, lang),
        lang,
      ),
      type,
    )
  end
end

def string_to_formula(string, type)
  described_class.parse(string, type)
end

def conversion(formula, type)
  formula.send("to_#{type}")
end
