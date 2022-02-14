require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Tan do

  it 'returns instance of Tan' do
    tan = Plurimath::Asciimath::Function::Tan.new('70')
    expect(tan).to be_a(Plurimath::Asciimath::Function::Tan)
  end

  it 'initializes Tan object' do
    tan = Plurimath::Asciimath::Function::Tan.new('70')
    expect(tan.angle).to eql('70')
  end
end

