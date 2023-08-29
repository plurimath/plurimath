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
