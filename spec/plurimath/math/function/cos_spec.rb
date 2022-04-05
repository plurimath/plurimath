require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Function::Cos do

  it 'returns instance of Cos' do
    cos = Plurimath::Math::Function::Cos.new('70')
    expect(cos).to be_a(Plurimath::Math::Function::Cos)
  end

  it 'initializes Cos object' do
    cos = Plurimath::Math::Function::Cos.new('70')
    expect(cos.parameter_one).to eql('70')
  end
end
