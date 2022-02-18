require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Glb do

  it 'returns instance of Glb' do
    glb = Plurimath::Math::Function::Glb.new([70, 45])
    expect(glb).to be_a(Plurimath::Math::Function::Glb)
  end

  it 'initializes Glb object' do
    glb = Plurimath::Math::Function::Glb.new([70, 45])
    expect(glb.values).to eql([70, 45])
  end
end
