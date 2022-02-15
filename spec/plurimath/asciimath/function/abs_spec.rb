require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Abs do

  it 'returns instance of Abs' do
    abs = Plurimath::Asciimath::Function::Abs.new('70')
    expect(abs).to be_a(Plurimath::Asciimath::Function::Abs)
  end

  it 'initializes Abs object' do
    abs = Plurimath::Asciimath::Function::Abs.new('70')
    expect(abs.value).to eql('70')
  end
end

