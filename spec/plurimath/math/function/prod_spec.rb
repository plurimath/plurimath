require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Function::Prod do

  it 'returns instance of Prod' do
    prod = Plurimath::Math::Function::Prod.new('70')
    expect(prod).to be_a(Plurimath::Math::Function::Prod)
  end

  it 'initializes Prod object' do
    prod = Plurimath::Math::Function::Prod.new('70')
    expect(prod.base).to eql('70')
  end
end
