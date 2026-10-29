require "spec_helper"
require_relative "../support/shared_facade_examples"

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
      let(:input_text) { "mm^3" }

      it "matches instance of Unitsml and input text" do
        expect(unitsml).to be_a(described_class)
        expect(unitsml.text).to eql("mm^3")
      end

      it_behaves_like "shared facade expectation", "facade-unitsml-63"
    end

    context "contains positive exponent variable invalid equation" do
      let(:input_text) { "mm^(b)" }

      it_behaves_like "shared facade expectation", "facade-unitsml-71"
    end

    context "contains negative exponent variable invalid equation" do
      let(:input_text) { "mm^(-b)" }

      it_behaves_like "shared facade expectation", "facade-unitsml-82"
    end

    context "contains negative exponent alphanumeric variable invalid equation" do
      let(:input_text) { "mm^(-2b)" }

      it_behaves_like "shared facade expectation", "facade-unitsml-93"
    end

    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-1"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-2"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-3"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-4"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-5"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-6"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-7"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-8"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-9"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-10"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-11"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-12"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-13"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-14"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-15"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-16"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-17"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-18"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-19"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-20"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-21"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-22"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-23"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-24"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-25"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-26"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-27"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-28"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-29"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-30"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-31"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-32"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-33"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-34"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-35"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-36"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-37"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-38"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-39"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-40"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-41"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-42"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-43"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-44"
    it_behaves_like "shared facade expectation", "facade-unitsml-105-iteration-45"
  end

  # Regression for unitsml/unitsdb#123. An accent name ("bar") rendered by
  # UnitsML as a bare <mi> must stay a literal identifier, not be re-parsed as
  # the overline accent. (Named-function unit names like "min"/"sec" are a
  # separate, ambiguous case and are intentionally not addressed by this rule.)
  describe "an accent-named unit (unitsml/unitsdb#123)" do
    it_behaves_like "shared facade expectation", "facade-unitsml-117"
  end
end
