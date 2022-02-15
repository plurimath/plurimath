require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Ul do

  it 'returns instance of Ul' do
    ul = Plurimath::Asciimath::Function::Ul.new('70')
    expect(ul).to be_a(Plurimath::Asciimath::Function::Ul)
  end

  it 'initializes Ul object' do
    ul = Plurimath::Asciimath::Function::Ul.new('70')
    expect(ul.value).to eql('70')
  end
end
