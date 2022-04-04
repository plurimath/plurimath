require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Function::Tan do

  it 'returns instance of Tan' do
    tan = Plurimath::Math::Function::Tan.new('70')
    expect(tan).to be_a(Plurimath::Math::Function::Tan)
  end

  it 'initializes Tan object' do
    tan = Plurimath::Math::Function::Tan.new('70')
    expect(tan.parameter_one).to eql('70')
  end
end
