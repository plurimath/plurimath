require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Power do

  it 'returns instance of Power' do
    power = Plurimath::Math::Function::Power.new("sum", "theta")
    expect(power).to be_a(Plurimath::Math::Function::Power)
  end

  it 'initializes Power object' do
    power = Plurimath::Math::Function::Power.new("sum", "theta")
    expect(power.parameter_one).to eql("sum")
    expect(power.parameter_two).to eql("theta")
  end
end
