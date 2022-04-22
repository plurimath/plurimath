require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Underover do

  it 'returns instance of Underover' do
    underover = Plurimath::Math::Function::Underover.new("sum", "theta", "square")
    expect(underover).to be_a(Plurimath::Math::Function::Underover)
  end

  it 'initializes Underover object' do
    underover = Plurimath::Math::Function::Underover.new("sum", "theta", "square")
    expect(underover.parameter_one).to eql("sum")
    expect(underover.parameter_two).to eql("theta")
    expect(underover.parameter_three).to eql("square")
  end
end
