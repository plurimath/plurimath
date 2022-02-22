require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Ddot do

  it 'returns instance of Ddot' do
    ddot = Plurimath::Math::Function::Ddot.new('70')
    expect(ddot).to be_a(Plurimath::Math::Function::Ddot)
  end

  it 'initializes Ddot object' do
    ddot = Plurimath::Math::Function::Ddot.new('70')
    expect(ddot.value).to eql('70')
  end
end

