require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Underover do

  it 'returns instance of Underover' do
    underover = Plurimath::Math::Function::Underover.new(7)
    expect(underover).to be_a(Plurimath::Math::Function::Underover)
  end

  it 'initializes Underover object' do
    underover = Plurimath::Math::Function::Underover.new(70)
    expect(underover.parameter_one).to eql(70)
  end
end
