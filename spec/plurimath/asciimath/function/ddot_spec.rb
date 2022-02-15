require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Ddot do

  it 'returns instance of Ddot' do
    ddot = Plurimath::Asciimath::Function::Ddot.new('70')
    expect(ddot).to be_a(Plurimath::Asciimath::Function::Ddot)
  end

  it 'initializes Ddot object' do
    ddot = Plurimath::Asciimath::Function::Ddot.new('70')
    expect(ddot.value).to eql('70')
  end
end

