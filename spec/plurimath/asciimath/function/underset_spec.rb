require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Underset do

  it 'returns instance of Underset' do
    underset = Plurimath::Asciimath::Function::Underset.new('70', '=')
    expect(underset).to be_a(Plurimath::Asciimath::Function::Underset)
  end

  it 'initializes Underset object' do
    underset = Plurimath::Asciimath::Function::Underset.new('70', '=')
    expect(underset.value).to eql('70')
    expect(underset.symbol).to eql('=')
  end
end
