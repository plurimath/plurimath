require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Sinh do

  it 'returns instance of Sinh' do
    sinh = Plurimath::Math::Function::Sinh.new('70')
    expect(sinh).to be_a(Plurimath::Math::Function::Sinh)
  end

  it 'initializes Sinh object' do
    sinh = Plurimath::Math::Function::Sinh.new('70')
    expect(sinh.angle).to eql('70')
  end
end
