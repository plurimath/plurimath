require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Function::Sum do

  it 'returns instance of Sum' do
    sum = Plurimath::Math::Function::Sum.new('70', '20')
    expect(sum).to be_a(Plurimath::Math::Function::Sum)
  end

  it 'initializes Sum object' do
    sum = Plurimath::Math::Function::Sum.new('70', '20')
    expect(sum.parameter_one).to eql('70')
    expect(sum.parameter_two).to eql('20')
  end
end
