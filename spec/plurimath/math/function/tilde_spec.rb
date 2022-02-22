require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Tilde do

  it 'returns instance of Tilde' do
    tilde = Plurimath::Math::Function::Tilde.new('70')
    expect(tilde).to be_a(Plurimath::Math::Function::Tilde)
  end

  it 'initializes Tilde object' do
    tilde = Plurimath::Math::Function::Tilde.new('70')
    expect(tilde.value).to eql('70')
  end
end
