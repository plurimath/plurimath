require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Lcm do

  it 'returns instance of Lcm' do
    lcm = Plurimath::Asciimath::Function::Lcm.new([70, 45])
    expect(lcm).to be_a(Plurimath::Asciimath::Function::Lcm)
  end

  it 'initializes Lcm object' do
    lcm = Plurimath::Asciimath::Function::Lcm.new([70, 45])
    expect(lcm.values).to eql([70, 45])
  end
end
