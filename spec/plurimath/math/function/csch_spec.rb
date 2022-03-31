require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Csch do

  it 'returns instance of Csch' do
    csch = Plurimath::Math::Function::Csch.new('70')
    expect(csch).to be_a(Plurimath::Math::Function::Csch)
  end

  it 'initializes Csch object' do
    csch = Plurimath::Math::Function::Csch.new('70')
    expect(csch.parameter_one).to eql('70')
  end
end
