require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Function::Sin do

  it 'returns instance of Sin' do
    sin = Plurimath::Math::Function::Sin.new('70')
    expect(sin).to be_a(Plurimath::Math::Function::Sin)
  end

  it 'initializes Sin object' do
    sin = Plurimath::Math::Function::Sin.new('70')
    expect(sin.parameter_one).to eql('70')
  end
end
