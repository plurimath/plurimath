require_relative '../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Formula do

  it 'returns instance of Formula' do
    formula = Plurimath::Math::Formula.new('1 + 2')
    expect(formula).to be_a(Plurimath::Math::Formula)
  end

  it 'returns Formula instance' do
    formula = Plurimath::Math::Formula.new('1 + 2')
    expect(formula.value).to eql('1 + 2')
  end

  it 'converts formula back to Asciimath string for cos function' do
    asciimath = call_asciimath("cos(2)")
    expect(asciimath).to eql("cos(2)")
  end

  it 'converts formula back to Asciimath string for sin function' do
    asciimath = call_asciimath("sin(cos{theta})")
    expect(asciimath).to eql("sin(cos{theta})")
  end

  it 'converts formula back to Asciimath string for sin function' do
    asciimath = call_asciimath("sin(sum_(theta))")
    expect(asciimath).to eql("sin(sum_(theta))")
  end

  it 'converts formula back to Asciimath string for sin function' do
    asciimath = call_asciimath("sin(sum_(theta)^3)")
    expect(asciimath).to eql("sin(sum_(theta)^3)")
  end

  it 'converts formula back to Asciimath string for sin function' do
    asciimath = call_asciimath("sin(sum_(theta)^sin(theta))")
    expect(asciimath).to eql("sin(sum_(theta)^sin(theta))")
  end

  it 'converts formula back to Asciimath string for sum function' do
    asciimath = call_asciimath("sin(sum_(theta)^sin(cong)) = {1+1}")
    expect(asciimath).to eql("sin(sum_(theta)^sin(cong))={1+1}")
  end

  it 'converts formula back to Asciimath string for sum function' do
    asciimath = call_asciimath("sum_(i=1)^ni^3=sin((n(n+1))/2)^2")
    expect(asciimath).to eql("sum_(i=1)^ni^3=sin((n(n+1))/2)^2")
  end

  it 'converts formula back to Asciimath string for frac function' do
    asciimath = call_asciimath("sum_(i=frac{1}{3})^33")
    expect(asciimath).to eql("sum_(i=frac{1}{3})^33")
  end

  it 'converts formula back to Asciimath string for frac function' do
    asciimath = call_asciimath("sum_(i=frac{13})^33")
    expect(asciimath).to eql("sum_(i=frac{13})^33")
  end

  it 'converts formula back to Asciimath string for color function' do
    asciimath = call_asciimath("sum_(i=color{green}{3})^33")
    expect(asciimath).to eql("sum_(i=color{green}{3})^33")
  end

  it 'converts formula back to Asciimath string for color function' do
    asciimath = call_asciimath('sum_(i=color{text(blue)})^33')
    expect(asciimath).to eql('sum_(i=color{text(blue)})^33')
  end

  it 'converts formula back to Asciimath string for color function' do
    asciimath = call_asciimath('sum_(i=color{"blue"})^33')
    expect(asciimath).to eql('sum_(i=color{text(blue)})^33')
  end

  it 'converts formula back to Asciimath string for simple text' do
    asciimath = call_asciimath('int_0^1 f(x)dx')
    expect(asciimath).to eql('int_0^1f(x)dx')
  end

  it 'converts formula back to Asciimath string for obrace function' do
    asciimath = call_asciimath('obrace(1+2+3+4)^("4 terms")')
    expect(asciimath).to eql('obrace(1+2+3+4)^(text(4 terms))')
  end

  it 'converts formula back to Asciimath string for obrace function' do
    asciimath = call_asciimath('obrace(1+2+3+4)^text(4 terms)')
    expect(asciimath).to eql('obrace(1+2+3+4)^text(4 terms)')
  end

  it 'converts formula back to Asciimath string for obrace function' do
    asciimath = call_asciimath('obrace(1+2+3+4)')
    expect(asciimath).to eql('obrace(1+2+3+4)')
  end

  it 'converts formula back to Asciimath string for log function' do
    asciimath = call_asciimath('log(1+2+3+4)^("4 terms")')
    expect(asciimath).to eql('log(1+2+3+4)(text(4 terms))')
  end

  it 'converts formula back to Asciimath string for log function' do
    asciimath = call_asciimath('log(1+2+3+4)^(text(4 terms))')
    expect(asciimath).to eql('log(1+2+3+4)(text(4 terms))')
  end

  it 'converts formula back to Asciimath string for log function' do
    asciimath = call_asciimath('log(1+2+3+4)')
    expect(asciimath).to eql('log(1+2+3+4)')
  end

  it 'converts formula back to Asciimath string for root function' do
    asciimath = call_asciimath('root1234(i)')
    expect(asciimath).to eql('root1234(i)')
  end

  it 'converts formula back to Asciimath string for root function' do
    asciimath = call_asciimath('root(1234)(i)')
    expect(asciimath).to eql('root(1234)(i)')
  end

  it 'converts formula back to Asciimath string for overset function' do
    asciimath = call_asciimath('overset(1234)(i)')
    expect(asciimath).to eql('overset(1234)(i)')
  end

  it 'converts formula back to Asciimath string for overset function' do
    asciimath = call_asciimath('overset1234(i)')
    expect(asciimath).to eql('overset1234(i)')
  end

  it 'converts formula back to Asciimath string for underset function' do
    asciimath = call_asciimath('underset(sum(sin(theta)))(i)')
    expect(asciimath).to eql('underset(sum(sin(theta)))(i)')
  end

  it 'converts formula back to Asciimath string for underset function' do
    asciimath = call_asciimath('underset1234(i)')
    expect(asciimath).to eql('underset1234(i)')
  end

  it 'converts formula back to Asciimath string for mod function' do
    asciimath = call_asciimath('12mod1234(i)')
    expect(asciimath).to eql('12mod1234(i)')
  end

  it 'converts formula back to Asciimath string for mod function' do
    asciimath = call_asciimath('12mod(1234)(i)')
    expect(asciimath).to eql('12mod(1234)(i)')
  end

  it 'converts formula back to Asciimath string for mod function' do
    asciimath = call_asciimath('12mod(sin(theta))(i)')
    expect(asciimath).to eql('12mod(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for ceil function' do
    asciimath = call_asciimath('ceil(sin(theta))(i)')
    expect(asciimath).to eql('ceil(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for ceil function' do
    asciimath = call_asciimath('ceil_(sin(theta)) (i)')
    expect(asciimath).to eql('ceil_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for abs function' do
    asciimath = call_asciimath('abs(sin(theta))(i)')
    expect(asciimath).to eql('abs(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for abs function' do
    asciimath = call_asciimath('abs_(sin(theta)) (i)')
    expect(asciimath).to eql('abs_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for arccos function' do
    asciimath = call_asciimath('arccos(sin(theta))(i)')
    expect(asciimath).to eql('arccos(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for arccos function' do
    asciimath = call_asciimath('arccos_(sin(theta)) (i)')
    expect(asciimath).to eql('arccos_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for arcsin function' do
    asciimath = call_asciimath('arcsin(sin(theta))(i)')
    expect(asciimath).to eql('arcsin(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for arcsin function' do
    asciimath = call_asciimath('arcsin_(sin(theta)) (i)')
    expect(asciimath).to eql('arcsin_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for arctan function' do
    asciimath = call_asciimath('arctan(sin(theta))(i)')
    expect(asciimath).to eql('arctan(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for arctan function' do
    asciimath = call_asciimath('arctan_(sin(theta)) (i)')
    expect(asciimath).to eql('arctan_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for bar function' do
    asciimath = call_asciimath('bar(sin(theta))(i)')
    expect(asciimath).to eql('bar(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for bar function' do
    asciimath = call_asciimath('bar_(sin(theta)) (i)')
    expect(asciimath).to eql('bar_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for cancel function' do
    asciimath = call_asciimath('cancel(sin(theta))(i)')
    expect(asciimath).to eql('cancel(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for cancel function' do
    asciimath = call_asciimath('cancel_(sin(theta)) (i)')
    expect(asciimath).to eql('cancel_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for cos function' do
    asciimath = call_asciimath('cos(sin(theta))(i)')
    expect(asciimath).to eql('cos(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for cos function' do
    asciimath = call_asciimath('cos_(sin(theta)) (i)')
    expect(asciimath).to eql('cos_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for cosh function' do
    asciimath = call_asciimath('cosh(sin(theta))(i)')
    expect(asciimath).to eql('cosh(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for cosh function' do
    asciimath = call_asciimath('cosh_(sin(theta)) (i)')
    expect(asciimath).to eql('cosh_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for cot function' do
    asciimath = call_asciimath('cot(sin(theta))(i)')
    expect(asciimath).to eql('cot(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for cot function' do
    asciimath = call_asciimath('cot_(sin(theta)) (i)')
    expect(asciimath).to eql('cot_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for coth function' do
    asciimath = call_asciimath('coth(sin(theta))(i)')
    expect(asciimath).to eql('coth(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for coth function' do
    asciimath = call_asciimath('coth_(sin(theta)) (i)')
    expect(asciimath).to eql('coth_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for csc function' do
    asciimath = call_asciimath('csc(sin(theta))(i)')
    expect(asciimath).to eql('csc(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for csc function' do
    asciimath = call_asciimath('csc_(sin(theta)) (i)')
    expect(asciimath).to eql('csc_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for csch function' do
    asciimath = call_asciimath('csch(sin(theta))(i)')
    expect(asciimath).to eql('csch(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for csch function' do
    asciimath = call_asciimath('csch_(sin(theta)) (i)')
    expect(asciimath).to eql('csch_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for ddot function' do
    asciimath = call_asciimath('ddot(sin(theta))(i)')
    expect(asciimath).to eql('ddot(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for ddot function' do
    asciimath = call_asciimath('ddot_(sin(theta)) (i)')
    expect(asciimath).to eql('ddot_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for det function' do
    asciimath = call_asciimath('det(sin(theta))(i)')
    expect(asciimath).to eql('det(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for det function' do
    asciimath = call_asciimath('det_(sin(theta)) (i)')
    expect(asciimath).to eql('det_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for dim function' do
    asciimath = call_asciimath('dim(sin(theta))(i)')
    expect(asciimath).to eql('dim(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for dim function' do
    asciimath = call_asciimath('dim_(sin(theta)) (i)')
    expect(asciimath).to eql('dim_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for dot function' do
    asciimath = call_asciimath('dot(sin(theta))(i)')
    expect(asciimath).to eql('dot(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for dot function' do
    asciimath = call_asciimath('dot_(sin(theta)) (i)')
    expect(asciimath).to eql('dot_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for exp function' do
    asciimath = call_asciimath('exp^(sin(theta))(i)')
    expect(asciimath).to eql('exp^(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for exp function' do
    asciimath = call_asciimath('exp_(sin(theta)) (i)')
    expect(asciimath).to eql('exp_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for floor function' do
    asciimath = call_asciimath('floor^(sin(theta))(i)')
    expect(asciimath).to eql('floor^(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for floor function' do
    asciimath = call_asciimath('floor_(sin(theta)) (i)')
    expect(asciimath).to eql('floor_(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for g function' do
    asciimath = call_asciimath('g^(theta)(i)')
    expect(asciimath).to eql('g^(theta)(i)')
  end

  it 'converts formula back to Asciimath string for g function' do
    asciimath = call_asciimath('g_(theta) (i)')
    expect(asciimath).to eql('g_(theta)(i)')
  end

  it 'converts formula back to Asciimath string for gcd function' do
    asciimath = call_asciimath('gcd^(theta)(i)')
    expect(asciimath).to eql('gcd^(theta)(i)')
  end

  it 'converts formula back to Asciimath string for gcd function' do
    asciimath = call_asciimath('gcd_(theta) (i)')
    expect(asciimath).to eql('gcd_(theta)(i)')
  end

  it 'converts formula back to Asciimath string for glb function' do
    asciimath = call_asciimath('glb^(theta)(i)')
    expect(asciimath).to eql('glb^(theta)(i)')
  end

  it 'converts formula back to Asciimath string for glb function' do
    asciimath = call_asciimath('glb_(theta) (i)')
    expect(asciimath).to eql('glb_(theta)(i)')
  end

  it 'converts formula back to Asciimath string for hat function' do
    asciimath = call_asciimath('hat^(theta)(i)')
    expect(asciimath).to eql('hat^(theta)(i)')
  end

  it 'converts formula back to Asciimath string for hat function' do
    asciimath = call_asciimath('hat_(theta) (i)')
    expect(asciimath).to eql('hat_(theta)(i)')
  end

  it 'converts formula back to Asciimath string for lcm function' do
    asciimath = call_asciimath('lcm^(theta)(i)')
    expect(asciimath).to eql('lcm^(theta)(i)')
  end

  it 'converts formula back to Asciimath string for lcm function' do
    asciimath = call_asciimath('lcm_(theta) (i)')
    expect(asciimath).to eql('lcm_(theta)(i)')
  end

  it 'converts formula back to Asciimath string for ln function' do
    asciimath = call_asciimath('ln^(theta)(i)')
    expect(asciimath).to eql('ln^(theta)(i)')
  end

  it 'converts formula back to Asciimath string for ln function' do
    asciimath = call_asciimath('ln_(theta) (i)')
    expect(asciimath).to eql('ln_(theta)(i)')
  end

  it 'converts formula back to Asciimath string for lub function' do
    asciimath = call_asciimath('lub^(theta)(i)')
    expect(asciimath).to eql('lub^(theta)(i)')
  end

  it 'converts formula back to Asciimath string for lub function' do
    asciimath = call_asciimath('lub_(theta) (i)')
    expect(asciimath).to eql('lub_(theta)(i)')
  end

  it 'converts formula back to Asciimath string for mathbb function' do
    asciimath = call_asciimath('mathbb(theta)(i)')
    expect(asciimath).to eql('mathbb(theta)(i)')
  end

  it 'converts formula back to Asciimath string for mathbf function' do
    asciimath = call_asciimath('mathbf(theta)(i)')
    expect(asciimath).to eql('mathbf(theta)(i)')
  end

  it 'converts formula back to Asciimath string for mathcal function' do
    asciimath = call_asciimath('mathcal(theta) (i)')
    expect(asciimath).to eql('mathcal(theta)(i)')
  end

  it 'converts formula back to Asciimath string for mathfrak function' do
    asciimath = call_asciimath('mathfrak(theta)(i)')
    expect(asciimath).to eql('mathfrak(theta)(i)')
  end

  it 'converts formula back to Asciimath string for mathsf function' do
    asciimath = call_asciimath('mathsf(theta) (i)')
    expect(asciimath).to eql('mathsf(theta)(i)')
  end

  it 'converts formula back to Asciimath string for mathtt function' do
    asciimath = call_asciimath('mathtt(theta)(i)')
    expect(asciimath).to eql('mathtt(theta)(i)')
  end

  it 'converts formula back to Asciimath string for max function' do
    asciimath = call_asciimath('max_(theta) (i)')
    expect(asciimath).to eql('max_(theta)(i)')
  end

  it 'converts formula back to Asciimath string for max function' do
    asciimath = call_asciimath('max^(theta)(i)')
    expect(asciimath).to eql('max^(theta)(i)')
  end

  it 'converts formula back to Asciimath string for min function' do
    asciimath = call_asciimath('min^(theta)(i)')
    expect(asciimath).to eql('min^(theta)(i)')
  end

  it 'converts formula back to Asciimath string for min function' do
    asciimath = call_asciimath('min_(theta) (i)')
    expect(asciimath).to eql('min_(theta)(i)')
  end

  it 'converts formula back to Asciimath string for norm function' do
    asciimath = call_asciimath('norm(sin(theta))(i)')
    expect(asciimath).to eql('norm(sin(theta))(i)')
  end

  it 'converts formula back to Asciimath string for norm function' do
    asciimath = call_asciimath('norm(theta) (i)')
    expect(asciimath).to eql('norm(theta)(i)')
  end

  it 'converts formula back to Asciimath string for prod function' do
    asciimath = call_asciimath('prod_(theta)^(i)')
    expect(asciimath).to eql('prod_(theta)^(i)')
  end

  it 'converts formula back to Asciimath string for prod function' do
    asciimath = call_asciimath('prod_(theta) (i)')
    expect(asciimath).to eql('prod_(theta)(i)')
  end

  it 'converts formula back to Asciimath string for sec function' do
    asciimath = call_asciimath('sec(theta)(i)')
    expect(asciimath).to eql('sec(theta)(i)')
  end

  it 'converts formula back to Asciimath string for sech function' do
    asciimath = call_asciimath('sech(theta) (i)')
    expect(asciimath).to eql('sech(theta)(i)')
  end

  it 'converts formula back to Asciimath string for sinh function' do
    asciimath = call_asciimath('sinh(theta)(i)')
    expect(asciimath).to eql('sinh(theta)(i)')
  end

  it 'converts formula back to Asciimath string for sqrt function' do
    asciimath = call_asciimath('sqrt(3) (i)')
    expect(asciimath).to eql('sqrt(3)(i)')
  end

  it 'converts formula back to Asciimath string for tan function' do
    asciimath = call_asciimath('tan(theta)(i)')
    expect(asciimath).to eql('tan(theta)(i)')
  end

  it 'converts formula back to Asciimath string for tanh function' do
    asciimath = call_asciimath('tanh(theta) (i)')
    expect(asciimath).to eql('tanh(theta)(i)')
  end

  it 'converts formula back to Asciimath string for tilde function' do
    asciimath = call_asciimath('tilde(theta)(i)')
    expect(asciimath).to eql('tilde(theta)(i)')
  end

  it 'converts formula back to Asciimath string for ubrace function' do
    asciimath = call_asciimath('ubrace(theta) (i)')
    expect(asciimath).to eql('ubrace(theta)(i)')
  end

  it 'converts formula back to Asciimath string for ul function' do
    asciimath = call_asciimath('ul(theta)(i)')
    expect(asciimath).to eql('ul(theta)(i)')
  end

  it 'converts formula back to Asciimath string for vec function' do
    asciimath = call_asciimath('vec(theta) (i)')
    expect(asciimath).to eql('vec(theta)(i)')
  end
end

def call_asciimath(string)
  text = StringScanner.new(string)
  parsed = Plurimath::Asciimath::Parser.new(text).parse
  parsed.to_asciimath
end
