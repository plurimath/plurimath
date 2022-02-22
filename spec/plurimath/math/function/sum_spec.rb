require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Function::Sum do

  it 'returns instance of Sum' do
    sum = Plurimath::Math::Function::Sum.new('70')
    expect(sum).to be_a(Plurimath::Math::Function::Sum)
  end

  it 'initializes Sum object' do
    sum = Plurimath::Math::Function::Sum.new('70')
    expect(sum.base).to eql('70')
  end
end
