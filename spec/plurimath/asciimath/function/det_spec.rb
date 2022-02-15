require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Det do

  it 'returns instance of Det' do
    det = Plurimath::Asciimath::Function::Det.new('ad-bc')
    expect(det).to be_a(Plurimath::Asciimath::Function::Det)
  end

  it 'initializes Det object' do
    det = Plurimath::Asciimath::Function::Det.new('ad-bc')
    expect(det.scalar).to eql('ad-bc')
  end
end
