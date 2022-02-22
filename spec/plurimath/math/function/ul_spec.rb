require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Ul do

  it 'returns instance of Ul' do
    ul = Plurimath::Math::Function::Ul.new('70')
    expect(ul).to be_a(Plurimath::Math::Function::Ul)
  end

  it 'initializes Ul object' do
    ul = Plurimath::Math::Function::Ul.new('70')
    expect(ul.value).to eql('70')
  end
end
