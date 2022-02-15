require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Power do

  it 'returns instance of Power' do
    power = Plurimath::Asciimath::Function::Power.new(7, 70)
    expect(power).to be_a(Plurimath::Asciimath::Function::Power)
  end

  it 'initializes Power object' do
    power = Plurimath::Asciimath::Function::Power.new(70, 7)
    expect(power.base).to eql(70)
    expect(power.exponent).to eql(7)
  end
end
