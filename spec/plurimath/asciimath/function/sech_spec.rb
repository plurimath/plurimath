require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Sech do

  it 'returns instance of Sech' do
    sech = Plurimath::Asciimath::Function::Sech.new('70')
    expect(sech).to be_a(Plurimath::Asciimath::Function::Sech)
  end

  it 'initializes Sech object' do
    sech = Plurimath::Asciimath::Function::Sech.new('70')
    expect(sech.angle).to eql('70')
  end
end
