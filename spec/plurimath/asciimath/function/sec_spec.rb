require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Sec do

  it 'returns instance of Sec' do
    sec = Plurimath::Asciimath::Function::Sec.new('70')
    expect(sec).to be_a(Plurimath::Asciimath::Function::Sec)
  end

  it 'initializes Sec object' do
    sec = Plurimath::Asciimath::Function::Sec.new('70')
    expect(sec.angle).to eql('70')
  end
end
