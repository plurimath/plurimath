require_relative '../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Formula do

  it 'returns instance of Formula' do
    formula = Plurimath::Math::Formula.new('1 + 2')
    expect(formula).to be_a(Plurimath::Math::Formula)
  end

  it 'returns Formula instance' do
    formula = Plurimath::Math::Formula.new('1 + 2')
    expect(formula.text).to eql('1 + 2')
  end
end
