require_relative '../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Formula do

  describe ".initialize" do
    subject(:formula) { described_class.new(exp) }

    context "contains simple string" do
      let(:exp) { "theta" }
      it "returns true" do
        expected_value = described_class.new("theta")
        expect(formula).to eq(expected_value)
      end
    end

    context "contains simple string" do
      let(:exp) { "Theta" }
      expected_value = described_class.new("theta")
      it "returns false" do
        expect(formula).to_not eq(expected_value)
      end
    end
  end

  describe ".==" do
    subject(:formula) { described_class.new(exp) }

    context "contains simple string" do
      let(:exp) { "theta" }
      it "returns true" do
        expected_value = described_class.new("theta")
        expect(formula).to eq(expected_value)
      end
    end

    context "contains simple string" do
      let(:exp) { "Theta" }
      it "returns false" do
        expected_value = described_class.new("theta")
        expect(formula).to_not eq(expected_value)
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { Plurimath::Asciimath::Parser.new(exp).parse.to_asciimath }

    context "contains string" do
      it 'returns Formula object' do
        expected_value = described_class.new('1 + 2')
        expect(expected_value).to be_a(Plurimath::Math::Formula)
      end
    end

    context "contains string" do
      it 'returns Formula object' do
        expected_value = described_class.new('1 + 2')
        expect(expected_value.value).to eql(['1 + 2'])
      end
    end

    context "contains cos formula string" do
      let(:exp) { "cos(2)" }
      it 'converts cos string back from formula' do
        expect(formula).to eql("cos(2)")
      end
    end

    context "contains sin formula string with cos" do
      let(:exp) { "sin(cos{theta})" }
      it 'converts sin string back from formula' do
        expect(formula).to eql("sin(cos(theta))")
      end
    end

    context "contains sin formula string with sum" do
      let(:exp) { "sin(sum_(theta))" }
      it 'converts sin string back from formula' do
        expect(formula).to eql("sin(sum_(theta))")
      end
    end

    context "contains sin formula string with sum power base" do
      let(:exp) { "sin(sum_(theta)^3)" }
      it 'converts formula back to Asciimath string for sin function' do
        expect(formula).to eql("sin(sum_(theta)^(3))")
      end
    end

    context "contains sinh formula string with sum power base" do
      let(:exp) { "sinh(sum_(theta)^sin(theta))" }
      it 'converts formula back to Asciimath string for sinh function' do
        expect(formula).to eql("sinh(sum_(theta)^(sin(theta)))")
      end
    end

    context "contains csc formula string with sum power base" do
      let(:exp) { "csc(sum_(theta)^sin(cong)) = {1+1}" }
      it 'converts formula back to Asciimath string for csc function' do
        expect(formula).to eql("csc(sum_(theta)^(sin(~=)))={1+1}")
      end
    end

    context "contains int formula string with sum power base" do
      let(:exp) { "int_(i=1)^ni^3=sin((n(n+1))/2)^2" }
      it 'converts formula back to Asciimath string for int function' do
        expect(formula).to eql("int_(i=1)^(n)i^(3)=sin(frac(n(n+1))(2))^(2)")
      end
    end

    context "contains sum formula string with sum power base" do
      let(:exp) { "sum_(i=frac{1}{3})^33" }
      it 'converts formula back to Asciimath string for sum function' do
        expect(formula).to eql("sum_(i=frac(1)(3))^(33)")
      end
    end

    context "contains sum formula string with frac power base" do
      let(:exp) { "sum_(i=frac{13})^33" }
      it 'converts formula back to Asciimath string for sum function' do
        expect(formula).to eql("sum_(i=frac(13))^(33)")
      end
    end

    context "contains sum formula string with color green" do
      let(:exp) { "sum_(i=color{green}{3})^33" }
      it 'converts formula back to Asciimath string for color function' do
        expect(formula).to eql("sum_(i=color(\"green\")(3))^(33)")
      end
    end

    context "contains sum formula string with color and text power base" do
      let(:exp) { "sum_(i=color{text(blue)})^33" }
      it 'converts formula back to Asciimath string for color function' do
        expect(formula).to eql("sum_(i=color(\"text(blue)\"))^(33)")
      end
    end

    context "contains sum formula string with color power number base" do
      let(:exp) { "sum_(i=color{\"blue\"})^33" }
      it 'converts formula back to Asciimath string for color function' do
        expect(formula).to eql('sum_(i=color(""blue""))^(33)')
      end
    end

    context "contains int formula string with color power base" do
      let(:exp) { "int_0^1 f(x)dx" }
      it 'converts formula back to Asciimath string for simple text' do
        expect(formula).to eql('int_(0)^(1)f(x)dx')
      end
    end

    context "contains sum formula string with color power base" do
      let(:exp) { "obrace(1+2+3+4)^(\"4 terms\")" }
      it 'converts formula back to Asciimath string for obrace function' do
        expect(formula).to eql('obrace(1+2+3+4)^("4 terms")')
      end
    end

    context "contains obrace formula string with text" do
      let(:exp) { "obrace(1+2+3+4)^text(4 terms)" }
      it 'converts formula back to Asciimath string for obrace function' do
        expect(formula).to eql("obrace(1+2+3+4)^(\"4 terms\")")
      end
    end

    context "contains obrace formula string with text" do
      let(:exp) { "obrace(1+2+3+4)" }
      it 'converts formula back to Asciimath string for obrace function' do
        expect(formula).to eql('obrace(1+2+3+4)')
      end
    end

    context "contains log formula string with text" do
      let(:exp) { "log(1+2+3+4)^(\"4 terms\")" }
      it 'converts formula back to Asciimath string for log function' do
        expect(formula).to eql('log(1+2+3+4)^("4 terms")')
      end
    end

    context "contains oint formula string with text" do
      let(:exp) { "oint(1+2+3+4)^(text(4 terms))" }
      it 'converts formula back to Asciimath string for oint function' do
        expect(formula).to eql("oint(1+2+3+4)^(\"4 terms\")")
      end
    end

    context "contains abs formula string" do
      let(:exp) { "abs(1+2+3+4)" }
      it 'converts formula back to Asciimath string for log function' do
        expect(formula).to eql('abs(1+2+3+4)')
      end
    end

    context "contains root formula string" do
      let(:exp) { "root1234(i)" }
      it 'converts formula back to Asciimath string for root function' do
        expect(formula).to eql('root(1234)(i)')
      end
    end

    context "contains bar formula string" do
      let(:exp) { "bar(1234)(i)" }
      it 'converts formula back to Asciimath string for bar function' do
        expect(formula).to eql('bar(1234)(i)')
      end
    end

    context "contains overset formula string" do
      let(:exp) { "overset(1234)(i)" }
      it 'converts formula back to Asciimath string for overset function' do
        expect(formula).to eql('overset(1234)(i)')
      end
    end

    context "contains arccos formula string" do
      let(:exp) { "arccos1234(i)" }
      it 'converts formula back to Asciimath string for arccos function' do
        expect(formula).to eql('arccos(1234)(i)')
      end
    end

    context "contains underset formula string" do
      let(:exp) { "underset(sum(sin(theta)))(i)" }
      it 'converts formula back to Asciimath string for underset function' do
        expect(formula).to eql('underset(sum(sin(theta)))(i)')
      end
    end

    context "contains arcsin formula string" do
      let(:exp) { "arcsin1234(i)" }
      it 'converts formula back to Asciimath string for arcsin function' do
        expect(formula).to eql('arcsin(1234)(i)')
      end
    end

    context "contains mod formula string" do
      let(:exp) { "12mod1234(i)" }
      it 'converts formula back to Asciimath string for mod function' do
        expect(formula).to eql('(12)mod(1234)(i)')
      end
    end

    context "contains arctan formula string" do
      let(:exp) { "12arctan(1234)(i)" }
      it 'converts formula back to Asciimath string for arctan function' do
        expect(formula).to eql('12arctan(1234)(i)')
      end
    end

    context "contains mod formula string with sin" do
      let(:exp) { "12mod(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for mod function' do
        expect(formula).to eql('(12)mod(sin(theta))(i)')
      end
    end

    context "contains ceil formula string with sin" do
      let(:exp) { "ceil(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for ceil function' do
        expect(formula).to eql('ceil(sin(theta))(i)')
      end
    end

    context "contains ceil formula string" do
      let(:exp) { "ceil_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for ceil function' do
        expect(formula).to eql('ceil_(sin(theta))(i)')
      end
    end

    context "contains abs formula string" do
      let(:exp) { "abs(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for abs function' do
        expect(formula).to eql('abs(sin(theta))(i)')
      end
    end

    context "contains abs formula string with sin" do
      let(:exp) { "abs_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for abs function' do
        expect(formula).to eql('abs_(sin(theta))(i)')
      end
    end

    context "contains arccos formula string with sin function" do
      let(:exp) { "arccos(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for arccos function' do
        expect(formula).to eql('arccos(sin(theta))(i)')
      end
    end

    context "contains arccos formula string with underscore and sin function" do
      let(:exp) { "arccos_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for arccos function' do
        expect(formula).to eql('arccos_(sin(theta))(i)')
      end
    end

    context "contains arcsin formula string with sin function" do
      let(:exp) { "arcsin(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for arcsin function' do
        expect(formula).to eql('arcsin(sin(theta))(i)')
      end
    end

    context "contains arcsin formula string with underscore and sin function" do
      let(:exp) { "arcsin_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for arcsin function' do
        expect(formula).to eql('arcsin_(sin(theta))(i)')
      end
    end

    context "contains arctan formula string with sin function" do
      let(:exp) { "arctan(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for arctan function' do
        expect(formula).to eql('arctan(sin(theta))(i)')
      end
    end

    context "contains arctan formula string with underscore and sin function" do
      let(:exp) { "arctan_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for arctan function' do
        expect(formula).to eql('arctan_(sin(theta))(i)')
      end
    end

    context "contains bar formula string with sin function" do
      let(:exp) { "bar(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for bar function' do
        expect(formula).to eql('bar(sin(theta))(i)')
      end
    end

    context "contains bar formula string with underscore and sin function" do
      let(:exp) { "bar_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for bar function' do
        expect(formula).to eql('bar_(sin(theta))(i)')
      end
    end

    context "contains cancel formula string with sin function" do
      let(:exp) { "cancel(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for cancel function' do
        expect(formula).to eql('cancel(sin(theta))(i)')
      end
    end

    context "contains cancel formula string with underscore and sin function" do
      let(:exp) { "cancel_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for cancel function' do
        expect(formula).to eql('cancel_(sin(theta))(i)')
      end
    end

    context "contains cos formula string with sin function" do
      let(:exp) { "cos(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for cos function' do
        expect(formula).to eql('cos(sin(theta))(i)')
      end
    end

    context "contains cos formula string with underscore and sin function" do
      let(:exp) { "cos_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for cos function' do
        expect(formula).to eql('cos_(sin(theta))(i)')
      end
    end

    context "contains cosh formula string with sin function" do
      let(:exp) { "cosh(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for cosh function' do
        expect(formula).to eql('cosh(sin(theta))(i)')
      end
    end

    context "contains cosh formula string with underscore and sin function" do
      let(:exp) { "cosh_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for cosh function' do
        expect(formula).to eql('cosh_(sin(theta))(i)')
      end
    end

    context "contains cot formula string with sin function" do
      let(:exp) { "cot(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for cot function' do
        expect(formula).to eql('cot(sin(theta))(i)')
      end
    end

    context "contains cot formula string with underscore and sin function" do
      let(:exp) { "cot_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for cot function' do
        expect(formula).to eql('cot_(sin(theta))(i)')
      end
    end

    context "contains coth formula string with sin function" do
      let(:exp) { "coth(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for coth function' do
        expect(formula).to eql('coth(sin(theta))(i)')
      end
    end

    context "contains coth formula string with underscore and sin function" do
      let(:exp) { "coth_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for coth function' do
        expect(formula).to eql('coth_(sin(theta))(i)')
      end
    end

    context "contains csc formula string with underscore and sin function" do
      let(:exp) { "csc(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for csc function' do
        expect(formula).to eql('csc(sin(theta))(i)')
      end
    end

    context "contains coth formula string with underscore and sin function" do
      let(:exp) { "csc_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for csc function' do
        expect(formula).to eql('csc_(sin(theta))(i)')
      end
    end

    context "contains coth formula string with sin function" do
      let(:exp) { "csch(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for csch function' do
        expect(formula).to eql('csch(sin(theta))(i)')
      end
    end

    context "contains coth formula string with underscore and sin function" do
      let(:exp) { "csch_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for csch function' do
        expect(formula).to eql('csch_(sin(theta))(i)')
      end
    end

    context "contains ddot formula string with sin function" do
      let(:exp) { "ddot(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for ddot function' do
        expect(formula).to eql('ddot(sin(theta))(i)')
      end
    end

    context "contains ddot formula string with underscore and sin function" do
      let(:exp) { "ddot_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for ddot function' do
        expect(formula).to eql('ddot_(sin(theta))(i)')
      end
    end

    context "contains det formula string with sin function" do
      let(:exp) { "det(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for det function' do
        expect(formula).to eql('det(sin(theta))(i)')
      end
    end

    context "contains det formula string with underscore and sin function" do
      let(:exp) { "det_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for det function' do
        expect(formula).to eql('det_(sin(theta))(i)')
      end
    end

    context "contains dim formula string with sin function" do
      let(:exp) { "dim(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for dim function' do
        expect(formula).to eql('dim(sin(theta))(i)')
      end
    end

    context "contains dim formula string with underscore and sin function" do
      let(:exp) { "dim_(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for dim function' do
        expect(formula).to eql('dim_(sin(theta))(i)')
      end
    end

    context "contains dot formula string with sin function" do
      let(:exp) { "dot(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for dot function' do
        expect(formula).to eql('dot(sin(theta))(i)')
      end
    end

    context "contains dot formula string with underscore and sin function" do
      let(:exp) { "dot_(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for dot function' do
        expect(formula).to eql('dot_(sin(theta))(i)')
      end
    end

    context "contains exp formula string with power and sin function" do
      let(:exp) { "exp^(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for exp function' do
        expect(formula).to eql('exp^(sin(theta))(i)')
      end
    end

    context "contains exp formula string with underscore and sin function" do
      let(:exp) { "exp_(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for exp function' do
        expect(formula).to eql('exp_(sin(theta))(i)')
      end
    end

    context "contains floor formula string with power and sin function" do
      let(:exp) { "floor^(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for floor function' do
        expect(formula).to eql('floor^(sin(theta))(i)')
      end
    end

    context "contains floor formula string with underscore and sin function" do
      let(:exp) { "floor_(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for floor function' do
        expect(formula).to eql('floor_(sin(theta))(i)')
      end
    end

    context "contains g formula string with power" do
      let(:exp) { "g^(theta)(i)" }
      it 'converts formula back to Asciimath string for g function' do
        expect(formula).to eql('g^(theta)(i)')
      end
    end

    context "contains g formula string with underscore" do
      let(:exp) { "g_(theta)(i)" }
      it 'converts formula back to Asciimath string for g function' do
        expect(formula).to eql('g_(theta)(i)')
      end
    end

    context "contains gcd formula string with power" do
      let(:exp) { "gcd^(theta)(i)" }
      it 'converts formula back to Asciimath string for gcd function' do
        expect(formula).to eql('gcd^(theta)(i)')
      end
    end

    context "contains gcd formula string with underscore" do
      let(:exp) { "gcd_(theta)(i)" }
      it 'converts formula back to Asciimath string for gcd function' do
        expect(formula).to eql('gcd_(theta)(i)')
      end
    end

    context "contains glb formula string with power" do
      let(:exp) { "glb^(theta)(i)" }
      it 'converts formula back to Asciimath string for glb function' do
        expect(formula).to eql('glb^(theta)(i)')
      end
    end

    context "contains glb formula string with underscore" do
      let(:exp) { "glb_(theta)(i)" }
      it 'converts formula back to Asciimath string for glb function' do
        expect(formula).to eql('glb_(theta)(i)')
      end
    end

    context "contains hat formula string with power" do
      let(:exp) { "hat^(theta)(i)" }
      it 'converts formula back to Asciimath string for hat function' do
        expect(formula).to eql('hat^(theta)(i)')
      end
    end

    context "contains hat formula string with underscore" do
      let(:exp) { "hat_(theta) (i)" }
      it 'converts formula back to Asciimath string for hat function' do
        expect(formula).to eql('hat_(theta)(i)')
      end
    end

    context "contains lcm formula string with power" do
      let(:exp) { "lcm^(theta)(i)" }
      it 'converts formula back to Asciimath string for lcm function' do
        expect(formula).to eql('lcm^(theta)(i)')
      end
    end

    context "contains lcm formula string with underscore" do
      let(:exp) { "lcm_(theta)(i)" }
      it 'converts formula back to Asciimath string for lcm function' do
        expect(formula).to eql('lcm_(theta)(i)')
      end
    end

    context "contains ln formula string with power" do
      let(:exp) { "ln^(theta)(i)" }
      it 'converts formula back to Asciimath string for ln function' do
        expect(formula).to eql('ln^(theta)(i)')
      end
    end

    context "contains ln formula string with underscore" do
      let(:exp) { "ln_(theta)(i)" }
      it 'converts formula back to Asciimath string for ln function' do
        expect(formula).to eql('ln_(theta)(i)')
      end
    end

    context "contains lub formula string with power" do
      let(:exp) { "lub^(theta)(i)" }
      it 'converts formula back to Asciimath string for lub function' do
        expect(formula).to eql('lub^(theta)(i)')
      end
    end

    context "contains lub formula string with underscore" do
      let(:exp) { "lub_(theta)(i)" }
      it 'converts formula back to Asciimath string for lub function' do
        expect(formula).to eql('lub_(theta)(i)')
      end
    end

    context "contains mathbb formula string" do
      let(:exp) { "mathbb(theta)(i)" }
      it 'converts formula back to Asciimath string for mathbb function' do
        expect(formula).to eql('mathbb(theta)(i)')
      end
    end

    context "contains mathbf formula string" do
      let(:exp) { "mathbf(theta)(i)" }
      it 'converts formula back to Asciimath string for mathbf function' do
        expect(formula).to eql('mathbf(theta)(i)')
      end
    end

    context "contains mathcal formula string" do
      let(:exp) { "mathcal(theta)(i)" }
      it 'converts formula back to Asciimath string for mathcal function' do
        expect(formula).to eql('mathcal(theta)(i)')
      end
    end

    context "contains mathfrak formula string" do
      let(:exp) { "mathfrak(theta)(i)" }
      it 'converts formula back to Asciimath string for mathfrak function' do
        expect(formula).to eql('fr(theta)(i)')
      end
    end

    context "contains mathsf formula string" do
      let(:exp) { "mathsf(theta)(i)" }
      it 'converts formula back to Asciimath string for mathsf function' do
        expect(formula).to eql('mathsf(theta)(i)')
      end
    end

    context "contains mathtt formula string" do
      let(:exp) { "mathtt(theta)(i)" }
      it 'converts formula back to Asciimath string for mathtt function' do
        expect(formula).to eql('mathtt(theta)(i)')
      end
    end

    context "contains max formula string with underscore" do
      let(:exp) { "max_(theta)(i)" }
      it 'converts formula back to Asciimath string for max function' do
        expect(formula).to eql('max_(theta)(i)')
      end
    end

    context "contains max formula string with power" do
      let(:exp) { "max^(theta)(i)" }
      it 'converts formula back to Asciimath string for max function' do
        expect(formula).to eql('max^(theta)(i)')
      end
    end

    context "contains min formula string with power" do
      let(:exp) { "min^(theta)(i)" }
      it 'converts formula back to Asciimath string for min function' do
        expect(formula).to eql('min^(theta)(i)')
      end
    end

    context "contains min formula string with underscore" do
      let(:exp) { "min_(theta)(i)" }
      it 'converts formula back to Asciimath string for min function' do
        expect(formula).to eql('min_(theta)(i)')
      end
    end

    context "contains norm formula string with sin function" do
      let(:exp) { "norm(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for norm function' do
        expect(formula).to eql('norm(sin(theta))(i)')
      end
    end

    context "contains norm formula string" do
      let(:exp) { "norm(theta) (i)" }
      it 'converts formula back to Asciimath string for norm function' do
        expect(formula).to eql('norm(theta)(i)')
      end
    end

    context "contains prod formula string" do
      let(:exp) { "prod_(theta)^(i)" }
      it 'converts formula back to Asciimath string for prod function' do
        expect(formula).to eql('prod_(theta)^(i)')
      end
    end

    context "contains prod formula string with underscore only" do
      let(:exp) { "prod_(theta) (i)" }
      it 'converts formula back to Asciimath string for prod function' do
        expect(formula).to eql('prod_(theta)(i)')
      end
    end

    context "contains sec formula string" do
      let(:exp) { "sec(theta)(i)" }
      it 'converts formula back to Asciimath string for sec function' do
        expect(formula).to eql('sec(theta)(i)')
      end
    end

    context "contains sech formula string" do
      let(:exp) { "sech(theta) (i)" }
      it 'converts formula back to Asciimath string for sech function' do
        expect(formula).to eql('sech(theta)(i)')
      end
    end

    context "contains sinh formula string" do
      let(:exp) { "sinh(theta)(i)" }
      it 'converts formula back to Asciimath string for sinh function' do
        expect(formula).to eql('sinh(theta)(i)')
      end
    end

    context "contains sqrt formula string" do
      let(:exp) { "sqrt(3) (i)" }
      it 'converts formula back to Asciimath string for sqrt function' do
        expect(formula).to eql('sqrt(3)(i)')
      end
    end

    context "contains tan formula string" do
      let(:exp) { "tan(theta)(i)" }
      it 'converts formula back to Asciimath string for tan function' do
        expect(formula).to eql('tan(theta)(i)')
      end
    end

    context "contains tanh formula string" do
      let(:exp) { "tanh(theta)(i)" }
      it 'converts formula back to Asciimath string for tanh function' do
        expect(formula).to eql('tanh(theta)(i)')
      end
    end

    context "contains tilde formula string" do
      let(:exp) { "tilde(theta)(i)" }
      it 'converts formula back to Asciimath string for tilde function' do
        expect(formula).to eql('tilde(theta)(i)')
      end
    end

    context "contains ubrace formula string" do
      let(:exp) { "ubrace(theta) (i)" }
      it 'converts formula back to Asciimath string for ubrace function' do
        expect(formula).to eql('ubrace(theta)(i)')
      end
    end

    context "contains ul formula string" do
      let(:exp) { "ul(theta)(i)" }
      it 'converts formula back to Asciimath string for ul function' do
        expect(formula).to eql('ul(theta)(i)')
      end
    end

    context "contains vec formula string" do
      let(:exp) { "vec(theta) (i)" }
      it 'converts formula back to Asciimath string for vec function' do
        expect(formula).to eql('vec(theta)(i)')
      end
    end

    context "contains table formula string" do
      let(:exp) { "([1,3], [1,3], [1,3])" }
      it 'converts formula back to Asciimath string for vec function' do
        expect(formula).to eql('([1,3],[1,3],[1,3])')
      end
    end

    context "contains left right with table string" do
      let(:exp) { "left([1,3], [1,3], [1,3]right)" }
      it 'converts formula back to Asciimath string for vec function' do
        expect(formula).to eql('left([1,3],[1,3],[1,3]right)')
      end
    end

    context "contains Plurimath Formula #1" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("Δ"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("ν")
            ])
          ])
        ])
      end
      it 'converts from formula to asciimath string' do
        expected_value = "Δν"
        expect(exp.to_asciimath).to eq(expected_value)
      end
    end

    context "contains Plurimath Formula #2" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("&#x2215;"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#x3bd;")
            ])
          ])
        ])
      end
      it 'converts from formula to asciimath string' do
        expected_value = "slashnu"
        expect(exp.to_asciimath).to eq(expected_value)
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) { described_class.new(exp).to_mathml }

    context "contains left right with table string" do
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Left.new("("),
          Plurimath::Math::Function::Table.new(
            [
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("3")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("3")
                ])
              ]),
              Plurimath::Math::Function::Tr.new([
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("1")
                ]),
                Plurimath::Math::Function::Td.new([
                  Plurimath::Math::Number.new("3")
                ])
              ])
            ],
            "",
            "",
          ),
          Plurimath::Math::Function::Right.new(")")
        ])
      end
      it 'converts formula back to Asciimath string for vec function' do
        expected_value =
        <<~MATHML.gsub(/\s/, "")
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mi>(</mi>
                <mtable>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd>
                      <mn>3</mn>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd>
                      <mn>3</mn>
                    </mtd>
                  </mtr>
                  <mtr>
                    <mtd>
                      <mn>1</mn>
                    </mtd>
                    <mtd>
                      <mn>3</mn>
                    </mtd>
                  </mtr>
                </mtable>
                <mi>)</mi>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.gsub(/\s/, "")).to eql(expected_value)
      end
    end
  end
end
