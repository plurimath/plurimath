require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Lcm do

  it 'returns instance of Lcm' do
    lcm = Plurimath::Math::Function::Lcm.new([70, 45])
    expect(lcm).to be_a(Plurimath::Math::Function::Lcm)
  end

  it 'initializes Lcm object' do
    lcm = Plurimath::Math::Function::Lcm.new([70, 45])
    expect(lcm.parameter_one).to eql([70, 45])
  end
end
