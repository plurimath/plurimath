require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Csch do

  it 'returns instance of Csch' do
    csch = Plurimath::Asciimath::Function::Csch.new('70')
    expect(csch).to be_a(Plurimath::Asciimath::Function::Csch)
  end

  it 'initializes Csch object' do
    csch = Plurimath::Asciimath::Function::Csch.new('70')
    expect(csch.angle).to eql('70')
  end
end
