require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Bar do

  it 'returns instance of Bar' do
    bar = Plurimath::Math::Function::Bar.new('70')
    expect(bar).to be_a(Plurimath::Math::Function::Bar)
  end

  it 'initializes Bar object' do
    bar = Plurimath::Math::Function::Bar.new('70')
    expect(bar.parameter_one).to eql('70')
  end
end
