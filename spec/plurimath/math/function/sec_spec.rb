require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Sec do

  it 'returns instance of Sec' do
    sec = Plurimath::Math::Function::Sec.new('70')
    expect(sec).to be_a(Plurimath::Math::Function::Sec)
  end

  it 'initializes Sec object' do
    sec = Plurimath::Math::Function::Sec.new('70')
    expect(sec.angle).to eql('70')
  end
end
