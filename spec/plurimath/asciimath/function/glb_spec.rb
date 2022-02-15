require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Glb do

  it 'returns instance of Glb' do
    glb = Plurimath::Asciimath::Function::Glb.new([70, 45])
    expect(glb).to be_a(Plurimath::Asciimath::Function::Glb)
  end

  it 'initializes Glb object' do
    glb = Plurimath::Asciimath::Function::Glb.new([70, 45])
    expect(glb.values).to eql([70, 45])
  end
end
