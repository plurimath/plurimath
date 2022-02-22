require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Det do

  it 'returns instance of Det' do
    det = Plurimath::Math::Function::Det.new('ad-bc')
    expect(det).to be_a(Plurimath::Math::Function::Det)
  end

  it 'initializes Det object' do
    det = Plurimath::Math::Function::Det.new('ad-bc')
    expect(det.scalar).to eql('ad-bc')
  end
end
