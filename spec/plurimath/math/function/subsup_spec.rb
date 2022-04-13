require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Subsup do

  it 'returns instance of Subsup' do
    subsup = Plurimath::Math::Function::Subsup.new("sum", "theta", "square")
    expect(subsup).to be_a(Plurimath::Math::Function::Subsup)
  end

  it 'initializes Subsup object' do
    subsup = Plurimath::Math::Function::Subsup.new("sum", "theta", "square")
    expect(subsup.parameter_one).to eql("sum")
    expect(subsup.parameter_two).to eql("theta")
    expect(subsup.parameter_three).to eql("square")
  end
end
