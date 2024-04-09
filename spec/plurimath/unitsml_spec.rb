require "spec_helper"

RSpec.describe Plurimath::Unitsml do

  describe ".initialize" do
    let(:unitsml) { described_class.new(input_text) }
    unitsml_strings = [
      '"unitsml(cd*sr*kg^(-1)*m^(-2)*s^3)"',
      '"unitsml(F)" = "unitsml(kg^(-1)*m^(-2)*s^4*A^2)"',
      '"unitsml(Gy)" = "unitsml(m^2*s^(-2))"',
      '"unitsml(H)" = "unitsml(kg*m^2*s^(-2)*A^(-2))"',
      '"unitsml(J)" = "unitsml(kg*m^2*s^(-2))"',
      '"unitsml(J)" = "unitsml(m^2*kg*s^(-2))"',
      '"unitsml(J*K^(-1)*kg^(-1))"',
      '"unitsml(J*K^(-1)*mol^(-1))"',
      '"unitsml(kg*m^(-1)*s^(-1))"',
      '"unitsml(kg*m^(-1)*s^(-2))"',
      '"unitsml(kg*m^(-2)*s^(-1))"',
      '"unitsml(kg*m^2*s^(-1))"',
      '"unitsml(kg*m^2*s^(-2))"',
      '"unitsml(kg*m^2*s^(-2)*K^(-1))"',
      '"unitsml(kg*m^2*s^(-2)*mol^(-1))"',
      '"unitsml(kg*m^2*s^(-2)*mol^(-1)*K^(-1))"',
      '"unitsml(kg*m^2*s^(-3))"',
      '"unitsml(kg^(-1)*m^(-3)*s^4*A^2)"',
      '"unitsml(lm)" = "unitsml(cd*m^2*m^(-2))" = "unitsml(cd*sr)"',
      '"unitsml(m^(-2)*kg^(-1)*s^3*cd*sr)"',
      '"unitsml(m^2*kg*s^(-1))"',
      '"unitsml(m^2*kg*s^(-2)*K^(-1))"',
      '"unitsml(m^2*s^(-2))"',
      '"unitsml(m^2*s^(-2)*K^(-1))"',
      '"unitsml(m^2*s^(-3))"',
      '"unitsml(m^2//s)"',
      '"unitsml(m^3*kg^(-1))"',
      '"unitsml(mol*s^(-1)*m^(-3))"',
      '"unitsml(N*s//m^2,symbol:N cdot s//m^2)"',
      '"unitsml(Ohm)" = "unitsml(kg*m^2*s^(-3)*A^(-2))"',
      '"unitsml(Pa)" = "unitsml(kg*m^(-1)*s^(-2))"',
      '"unitsml(S)" = "unitsml(kg^(-1)*m^(-2)*s^3*A^2)"',
      '"unitsml(sr)" = "unitsml(m^2/m^2)"',
      '"unitsml(Sv)" = "unitsml(m^2*s^(-2))"',
      '"unitsml(V)" = "unitsml(kg*m^2*s^(-3)*A^(-1))"',
      '"unitsml(W)" = "unitsml(kg*m^2*s^(-3))"',
      '"unitsml(W)" = "unitsml(m^2*kg*s^(-3))"',
      '"unitsml(W*sr^(-1)*m^(-2))"',
      '"unitsml(Wb)" = "unitsml(kg*m^2*s^(-2)*A^(-1))"',
      '1 "unitsml(cd)" = (ii(K)_("cd")/683) "unitsml(kg*m^2*s^(-3)*sr^(-1))"',
      '1 "unitsml(K)" = ((1.380649 xx 10^(-23))/k) "unitsml(kg*m^2*s^(-2))"',
      '1 "unitsml(kg)" = (h/(6.62607015 xx 10^(-34))) "unitsml(m^(-2)*s)"',
      'h = 6.62607015 xx 10^(−34) "unitsml(kg*m^2*s^(-1))"',
      'ii(K)_("cd") = 683 "unitsml(cd*sr*kg^(-1)*m^(-2)*s^3)"',
      'k = 1.380649 xx 10^(−23) "unitsml(kg*m^2*s^(-2)*K^(-1))"',
    ].freeze

    context "contains valid equation" do
      let(:input_text) { 'mm^3' }

      it 'matches instance of Unitsml and input text' do
        expect(unitsml).to be_a(described_class)
        expect(unitsml.text).to eql('mm^3')
      end

      it 'expects to not raise an error' do
        expect{unitsml}.not_to raise_error
      end
    end

    context "contains positive exponent variable invalid equation" do
      let(:input_text) { 'mm^(b)' }

      it 'expects error message indicating invalid exponent value' do
        message = "The use of a variable as an exponent is not valid."
        expect{unitsml}.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end

    context "contains negative exponent variable invalid equation" do
      let(:input_text) { 'mm^(-b)' }

      it 'expects error message indicating invalid exponent value' do
        message = "The use of a variable as an exponent is not valid."
        expect{unitsml}.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end

    context "contains negative exponent alphanumeric variable invalid equation" do
      let(:input_text) { 'mm^(-2b)' }

      it 'expects error message indicating invalid exponent value' do
        message = "The use of a variable as an exponent is not valid."
        expect{unitsml}.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end

    unitsml_strings.each.with_index(1) do |string, index|
      context "contains multiple valid equations from source plurimath/issues#236 ##{index}" do
        let(:input_text) { string }

        it "expects no error message indicating valid value##{index}" do
          expect{unitsml}.not_to raise_error
        end
      end
    end
  end
end
