require_relative '../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Formula do

  describe ".to_asciimath" do
    subject(:formula) { Plurimath::Asciimath::Parser.new(string).parse.to_asciimath }

    context "contains string" do
      it 'returns Formula object' do
        formula = Plurimath::Math::Formula.new('1 + 2')
        expect(formula).to be_a(Plurimath::Math::Formula)
      end
    end

    context "contains string" do
      it 'returns Formula object' do
        formula = Plurimath::Math::Formula.new('1 + 2')
        expect(formula.value).to eql(['1 + 2'])
      end
    end

    context "contains cos formula string" do
      let(:string) { "cos(2)" }
      it 'converts cos string back from formula' do
        expect(formula).to eql("cos(2)")
      end
    end

    context "contains sin formula string with cos" do
      let(:string) { "sin(cos{theta})" }
      it 'converts sin string back from formula' do
        expect(formula).to eql("sin(cos(theta))")
      end
    end

    context "contains sin formula string with sum" do
      let(:string) { "sin(sum_(theta))" }
      it 'converts sin string back from formula' do
        expect(formula).to eql("sin(sum_(theta))")
      end
    end

    context "contains sin formula string with sum power base" do
      let(:string) { "sin(sum_(theta)^3)" }
      it 'converts formula back to Asciimath string for sin function' do
        expect(formula).to eql("sin(sum_(theta)^(3))")
      end
    end

    context "contains sinh formula string with sum power base" do
      let(:string) { "sinh(sum_(theta)^sin(theta))" }
      it 'converts formula back to Asciimath string for sinh function' do
        expect(formula).to eql("sinh(sum_(theta)^(sin(theta)))")
      end
    end

    context "contains csc formula string with sum power base" do
      let(:string) { "csc(sum_(theta)^sin(cong)) = {1+1}" }
      it 'converts formula back to Asciimath string for csc function' do
        expect(formula).to eql("csc(sum_(theta)^(sin(cong)))=1+1")
      end
    end

    context "contains int formula string with sum power base" do
      let(:string) { "int_(i=1)^ni^3=sin((n(n+1))/2)^2" }
      it 'converts formula back to Asciimath string for int function' do
        expect(formula).to eql("int_(i=1)^(n)i^3=sin(nn+1/2)^2")
      end
    end

    context "contains sum formula string with sum power base" do
      let(:string) { "sum_(i=frac{1}{3})^33" }
      it 'converts formula back to Asciimath string for sum function' do
        expect(formula).to eql("sum_(i=frac(1)(3))^(33)")
      end
    end

    context "contains sum formula string with frac power base" do
      let(:string) { "sum_(i=frac{13})^33" }
      it 'converts formula back to Asciimath string for sum function' do
        expect(formula).to eql("sum_(i=frac(13))^(33)")
      end
    end

    context "contains sum formula string with color green" do
      let(:string) { "sum_(i=color{green}{3})^33" }
      it 'converts formula back to Asciimath string for color function' do
        expect(formula).to eql("sum_(i=color(g(r)een)(3))^(33)")
      end
    end

    context "contains sum formula string with color and text power base" do
      let(:string) { "sum_(i=color{text(blue)})^33" }
      it 'converts formula back to Asciimath string for color function' do
        expect(formula).to eql('sum_(i=color("blue"))^(33)')
      end
    end

    context "contains sum formula string with color power number base" do
      let(:string) { "sum_(i=color{\"blue\"})^33" }
      it 'converts formula back to Asciimath string for color function' do
        expect(formula).to eql('sum_(i=color("blue"))^(33)')
      end
    end

    context "contains int formula string with color power base" do
      let(:string) { "int_0^1 f(x)dx" }
      it 'converts formula back to Asciimath string for simple text' do
        expect(formula).to eql('int_(0)^(1)f(x)dx')
      end
    end

    context "contains sum formula string with color power base" do
      let(:string) { "obrace(1+2+3+4)^(\"4 terms\")" }
      it 'converts formula back to Asciimath string for obrace function' do
        expect(formula).to eql('obrace(1+2+3+4)^"4 terms"')
      end
    end

    context "contains obrace formula string with text" do
      let(:string) { "obrace(1+2+3+4)^text(4 terms)" }
      it 'converts formula back to Asciimath string for obrace function' do
        expect(formula).to eql('obrace(1+2+3+4)^"4 terms"')
      end
    end

    context "contains obrace formula string with text" do
      let(:string) { "obrace(1+2+3+4)" }
      it 'converts formula back to Asciimath string for obrace function' do
        expect(formula).to eql('obrace(1+2+3+4)')
      end
    end

    context "contains log formula string with text" do
      let(:string) { "log(1+2+3+4)^(\"4 terms\")" }
      it 'converts formula back to Asciimath string for log function' do
        expect(formula).to eql('log_(1+2+3+4)^"4 terms"')
      end
    end

    context "contains oint formula string with text" do
      let(:string) { "oint(1+2+3+4)^(text(4 terms))" }
      it 'converts formula back to Asciimath string for oint function' do
        expect(formula).to eql('oint_(1+2+3+4)^"4 terms"')
      end
    end

    context "contains abs formula string" do
      let(:string) { "abs(1+2+3+4)" }
      it 'converts formula back to Asciimath string for log function' do
        expect(formula).to eql('abs(1+2+3+4)')
      end
    end

    context "contains root formula string" do
      let(:string) { "root1234(i)" }
      it 'converts formula back to Asciimath string for root function' do
        expect(formula).to eql('root(1234)(i)')
      end
    end

    context "contains bar formula string" do
      let(:string) { "bar(1234)(i)" }
      it 'converts formula back to Asciimath string for bar function' do
        expect(formula).to eql('bar(1234)i')
      end
    end

    context "contains overset formula string" do
      let(:string) { "overset(1234)(i)" }
      it 'converts formula back to Asciimath string for overset function' do
        expect(formula).to eql('overset(1234)(i)')
      end
    end

    context "contains arccos formula string" do
      let(:string) { "arccos1234(i)" }
      it 'converts formula back to Asciimath string for arccos function' do
        expect(formula).to eql('arccos(1234)i')
      end
    end

    context "contains underset formula string" do
      let(:string) { "underset(sum(sin(theta)))(i)" }
      it 'converts formula back to Asciimath string for underset function' do
        expect(formula).to eql('underset(sum_(sin(theta)))(i)')
      end
    end

    context "contains arcsin formula string" do
      let(:string) { "arcsin1234(i)" }
      it 'converts formula back to Asciimath string for arcsin function' do
        expect(formula).to eql('arcsin(1234)i')
      end
    end

    context "contains mod formula string" do
      let(:string) { "12mod1234(i)" }
      it 'converts formula back to Asciimath string for mod function' do
        expect(formula).to eql('(12)mod(1234)i')
      end
    end

    context "contains arctan formula string" do
      let(:string) { "12arctan(1234)(i)" }
      it 'converts formula back to Asciimath string for arctan function' do
        expect(formula).to eql('12arctan(1234)i')
      end
    end

    context "contains mod formula string with sin" do
      let(:string) { "12mod(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for mod function' do
        expect(formula).to eql('(12)mod(sin(theta))i')
      end
    end

    context "contains ceil formula string with sin" do
      let(:string) { "ceil(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for ceil function' do
        expect(formula).to eql('ceil(sin(theta))i')
      end
    end

    context "contains ceil formula string" do
      let(:string) { "ceil_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for ceil function' do
        expect(formula).to eql('ceil_sin(theta)i')
      end
    end

    context "contains abs formula string" do
      let(:string) { "abs(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for abs function' do
        expect(formula).to eql('abs(sin(theta))i')
      end
    end

    context "contains abs formula string with sin" do
      let(:string) { "abs_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for abs function' do
        expect(formula).to eql('abs_sin(theta)i')
      end
    end

    context "contains arccos formula string with sin function" do
      let(:string) { "arccos(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for arccos function' do
        expect(formula).to eql('arccos(sin(theta))i')
      end
    end

    context "contains arccos formula string with underscore and sin function" do
      let(:string) { "arccos_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for arccos function' do
        expect(formula).to eql('arccos_sin(theta)i')
      end
    end

    context "contains arcsin formula string with sin function" do
      let(:string) { "arcsin(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for arcsin function' do
        expect(formula).to eql('arcsin(sin(theta))i')
      end
    end

    context "contains arcsin formula string with underscore and sin function" do
      let(:string) { "arcsin_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for arcsin function' do
        expect(formula).to eql('arcsin_sin(theta)i')
      end
    end

    context "contains arctan formula string with sin function" do
      let(:string) { "arctan(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for arctan function' do
        expect(formula).to eql('arctan(sin(theta))i')
      end
    end

    context "contains arctan formula string with underscore and sin function" do
      let(:string) { "arctan_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for arctan function' do
        expect(formula).to eql('arctan_sin(theta)i')
      end
    end

    context "contains bar formula string with sin function" do
      let(:string) { "bar(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for bar function' do
        expect(formula).to eql('bar(sin(theta))i')
      end
    end

    context "contains bar formula string with underscore and sin function" do
      let(:string) { "bar_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for bar function' do
        expect(formula).to eql('bar_sin(theta)i')
      end
    end

    context "contains cancel formula string with sin function" do
      let(:string) { "cancel(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for cancel function' do
        expect(formula).to eql('cancel(sin(theta))i')
      end
    end

    context "contains cancel formula string with underscore and sin function" do
      let(:string) { "cancel_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for cancel function' do
        expect(formula).to eql('cancel_sin(theta)i')
      end
    end

    context "contains cos formula string with sin function" do
      let(:string) { "cos(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for cos function' do
        expect(formula).to eql('cos(sin(theta))i')
      end
    end

    context "contains cos formula string with underscore and sin function" do
      let(:string) { "cos_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for cos function' do
        expect(formula).to eql('cos_sin(theta)i')
      end
    end

    context "contains cosh formula string with sin function" do
      let(:string) { "cosh(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for cosh function' do
        expect(formula).to eql('cosh(sin(theta))i')
      end
    end

    context "contains cosh formula string with underscore and sin function" do
      let(:string) { "cosh_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for cosh function' do
        expect(formula).to eql('cosh_sin(theta)i')
      end
    end

    context "contains cot formula string with sin function" do
      let(:string) { "cot(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for cot function' do
        expect(formula).to eql('cot(sin(theta))i')
      end
    end

    context "contains cot formula string with underscore and sin function" do
      let(:string) { "cot_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for cot function' do
        expect(formula).to eql('cot_sin(theta)i')
      end
    end

    context "contains coth formula string with sin function" do
      let(:string) { "coth(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for coth function' do
        expect(formula).to eql('coth(sin(theta))i')
      end
    end

    context "contains coth formula string with underscore and sin function" do
      let(:string) { "coth_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for coth function' do
        expect(formula).to eql('coth_sin(theta)i')
      end
    end

    context "contains csc formula string with underscore and sin function" do
      let(:string) { "csc(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for csc function' do
        expect(formula).to eql('csc(sin(theta))i')
      end
    end

    context "contains coth formula string with underscore and sin function" do
      let(:string) { "csc_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for csc function' do
        expect(formula).to eql('csc_sin(theta)i')
      end
    end

    context "contains coth formula string with sin function" do
      let(:string) { "csch(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for csch function' do
        expect(formula).to eql('csch(sin(theta))i')
      end
    end

    context "contains coth formula string with underscore and sin function" do
      let(:string) { "csch_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for csch function' do
        expect(formula).to eql('csch_sin(theta)i')
      end
    end

    context "contains ddot formula string with sin function" do
      let(:string) { "ddot(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for ddot function' do
        expect(formula).to eql('ddot(sin(theta))i')
      end
    end

    context "contains ddot formula string with underscore and sin function" do
      let(:string) { "ddot_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for ddot function' do
        expect(formula).to eql('ddot_sin(theta)i')
      end
    end

    context "contains det formula string with sin function" do
      let(:string) { "det(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for det function' do
        expect(formula).to eql('det(sin(theta))i')
      end
    end

    context "contains det formula string with underscore and sin function" do
      let(:string) { "det_(sin(theta)) (i)" }
      it 'converts formula back to Asciimath string for det function' do
        expect(formula).to eql('det_sin(theta)i')
      end
    end

    context "contains dim formula string with sin function" do
      let(:string) { "dim(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for dim function' do
        expect(formula).to eql('dim(sin(theta))i')
      end
    end

    context "contains dim formula string with underscore and sin function" do
      let(:string) { "dim_(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for dim function' do
        expect(formula).to eql('dim_sin(theta)i')
      end
    end

    context "contains dot formula string with sin function" do
      let(:string) { "dot(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for dot function' do
        expect(formula).to eql('dot(sin(theta))i')
      end
    end

    context "contains dot formula string with underscore and sin function" do
      let(:string) { "dot_(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for dot function' do
        expect(formula).to eql('dot_sin(theta)i')
      end
    end

    context "contains exp formula string with power and sin function" do
      let(:string) { "exp^(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for exp function' do
        expect(formula).to eql('exp^sin(theta)i')
      end
    end

    context "contains exp formula string with underscore and sin function" do
      let(:string) { "exp_(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for exp function' do
        expect(formula).to eql('exp_sin(theta)i')
      end
    end

    context "contains floor formula string with power and sin function" do
      let(:string) { "floor^(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for floor function' do
        expect(formula).to eql('floor^sin(theta)i')
      end
    end

    context "contains floor formula string with underscore and sin function" do
      let(:string) { "floor_(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for floor function' do
        expect(formula).to eql('floor_sin(theta)i')
      end
    end

    context "contains g formula string with power" do
      let(:string) { "g^(theta)(i)" }
      it 'converts formula back to Asciimath string for g function' do
        expect(formula).to eql('g^thetai')
      end
    end

    context "contains g formula string with underscore" do
      let(:string) { "g_(theta)(i)" }
      it 'converts formula back to Asciimath string for g function' do
        expect(formula).to eql('g_thetai')
      end
    end

    context "contains gcd formula string with power" do
      let(:string) { "gcd^(theta)(i)" }
      it 'converts formula back to Asciimath string for gcd function' do
        expect(formula).to eql('gcd^thetai')
      end
    end

    context "contains gcd formula string with underscore" do
      let(:string) { "gcd_(theta)(i)" }
      it 'converts formula back to Asciimath string for gcd function' do
        expect(formula).to eql('gcd_thetai')
      end
    end

    context "contains glb formula string with power" do
      let(:string) { "glb^(theta)(i)" }
      it 'converts formula back to Asciimath string for glb function' do
        expect(formula).to eql('glb^thetai')
      end
    end

    context "contains glb formula string with underscore" do
      let(:string) { "glb_(theta)(i)" }
      it 'converts formula back to Asciimath string for glb function' do
        expect(formula).to eql('glb_thetai')
      end
    end

    context "contains hat formula string with power" do
      let(:string) { "hat^(theta)(i)" }
      it 'converts formula back to Asciimath string for hat function' do
        expect(formula).to eql('hat^thetai')
      end
    end

    context "contains hat formula string with underscore" do
      let(:string) { "hat_(theta) (i)" }
      it 'converts formula back to Asciimath string for hat function' do
        expect(formula).to eql('hat_thetai')
      end
    end

    context "contains lcm formula string with power" do
      let(:string) { "lcm^(theta)(i)" }
      it 'converts formula back to Asciimath string for lcm function' do
        expect(formula).to eql('lcm^thetai')
      end
    end

    context "contains lcm formula string with underscore" do
      let(:string) { "lcm_(theta)(i)" }
      it 'converts formula back to Asciimath string for lcm function' do
        expect(formula).to eql('lcm_thetai')
      end
    end

    context "contains ln formula string with power" do
      let(:string) { "ln^(theta)(i)" }
      it 'converts formula back to Asciimath string for ln function' do
        expect(formula).to eql('ln^thetai')
      end
    end

    context "contains ln formula string with underscore" do
      let(:string) { "ln_(theta)(i)" }
      it 'converts formula back to Asciimath string for ln function' do
        expect(formula).to eql('ln_thetai')
      end
    end

    context "contains lub formula string with power" do
      let(:string) { "lub^(theta)(i)" }
      it 'converts formula back to Asciimath string for lub function' do
        expect(formula).to eql('lub^thetai')
      end
    end

    context "contains lub formula string with underscore" do
      let(:string) { "lub_(theta)(i)" }
      it 'converts formula back to Asciimath string for lub function' do
        expect(formula).to eql('lub_thetai')
      end
    end

    context "contains mathbb formula string" do
      let(:string) { "mathbb(theta)(i)" }
      it 'converts formula back to Asciimath string for mathbb function' do
        expect(formula).to eql('mathbb(theta)i')
      end
    end

    context "contains mathbf formula string" do
      let(:string) { "mathbf(theta)(i)" }
      it 'converts formula back to Asciimath string for mathbf function' do
        expect(formula).to eql('mathbf(theta)i')
      end
    end

    context "contains mathcal formula string" do
      let(:string) { "mathcal(theta)(i)" }
      it 'converts formula back to Asciimath string for mathcal function' do
        expect(formula).to eql('mathcal(theta)i')
      end
    end

    context "contains mathfrak formula string" do
      let(:string) { "mathfrak(theta)(i)" }
      it 'converts formula back to Asciimath string for mathfrak function' do
        expect(formula).to eql('mathfrak(theta)i')
      end
    end

    context "contains mathsf formula string" do
      let(:string) { "mathsf(theta)(i)" }
      it 'converts formula back to Asciimath string for mathsf function' do
        expect(formula).to eql('mathsf(theta)i')
      end
    end

    context "contains mathtt formula string" do
      let(:string) { "mathtt(theta)(i)" }
      it 'converts formula back to Asciimath string for mathtt function' do
        expect(formula).to eql('mathtt(theta)i')
      end
    end

    context "contains max formula string with underscore" do
      let(:string) { "max_(theta)(i)" }
      it 'converts formula back to Asciimath string for max function' do
        expect(formula).to eql('max_thetai')
      end
    end

    context "contains max formula string with power" do
      let(:string) { "max^(theta)(i)" }
      it 'converts formula back to Asciimath string for max function' do
        expect(formula).to eql('max^thetai')
      end
    end

    context "contains min formula string with power" do
      let(:string) { "min^(theta)(i)" }
      it 'converts formula back to Asciimath string for min function' do
        expect(formula).to eql('min^thetai')
      end
    end

    context "contains min formula string with underscore" do
      let(:string) { "min_(theta)(i)" }
      it 'converts formula back to Asciimath string for min function' do
        expect(formula).to eql('min_thetai')
      end
    end

    context "contains norm formula string with sin function" do
      let(:string) { "norm(sin(theta))(i)" }
      it 'converts formula back to Asciimath string for norm function' do
        expect(formula).to eql('norm(sin(theta))i')
      end
    end

    context "contains norm formula string" do
      let(:string) { "norm(theta) (i)" }
      it 'converts formula back to Asciimath string for norm function' do
        expect(formula).to eql('norm(theta)i')
      end
    end

    context "contains prod formula string" do
      let(:string) { "prod_(theta)^(i)" }
      it 'converts formula back to Asciimath string for prod function' do
        expect(formula).to eql('prod_(theta)^(i)')
      end
    end

    context "contains prod formula string with underscore only" do
      let(:string) { "prod_(theta) (i)" }
      it 'converts formula back to Asciimath string for prod function' do
        expect(formula).to eql('prod_(theta)i')
      end
    end

    context "contains sec formula string" do
      let(:string) { "sec(theta)(i)" }
      it 'converts formula back to Asciimath string for sec function' do
        expect(formula).to eql('sec(theta)i')
      end
    end

    context "contains sech formula string" do
      let(:string) { "sech(theta) (i)" }
      it 'converts formula back to Asciimath string for sech function' do
        expect(formula).to eql('sech(theta)i')
      end
    end

    context "contains sinh formula string" do
      let(:string) { "sinh(theta)(i)" }
      it 'converts formula back to Asciimath string for sinh function' do
        expect(formula).to eql('sinh(theta)i')
      end
    end

    context "contains sqrt formula string" do
      let(:string) { "sqrt(3) (i)" }
      it 'converts formula back to Asciimath string for sqrt function' do
        expect(formula).to eql('sqrt(3)i')
      end
    end

    context "contains tan formula string" do
      let(:string) { "tan(theta)(i)" }
      it 'converts formula back to Asciimath string for tan function' do
        expect(formula).to eql('tan(theta)i')
      end
    end

    context "contains tanh formula string" do
      let(:string) { "tanh(theta)(i)" }
      it 'converts formula back to Asciimath string for tanh function' do
        expect(formula).to eql('tanh(theta)i')
      end
    end

    context "contains tilde formula string" do
      let(:string) { "tilde(theta)(i)" }
      it 'converts formula back to Asciimath string for tilde function' do
        expect(formula).to eql('tilde(theta)i')
      end
    end

    context "contains ubrace formula string" do
      let(:string) { "ubrace(theta) (i)" }
      it 'converts formula back to Asciimath string for ubrace function' do
        expect(formula).to eql('ubrace(theta)i')
      end
    end

    context "contains ul formula string" do
      let(:string) { "ul(theta)(i)" }
      it 'converts formula back to Asciimath string for ul function' do
        expect(formula).to eql('ul(theta)i')
      end
    end

    context "contains vec formula string" do
      let(:string) { "vec(theta) (i)" }
      it 'converts formula back to Asciimath string for vec function' do
        expect(formula).to eql('vec(theta)i')
      end
    end
  end
end
