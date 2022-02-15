require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Lub do

  it 'returns instance of Lub' do
    lub = Plurimath::Asciimath::Function::Lub.new([70, 3])
    expect(lub).to be_a(Plurimath::Asciimath::Function::Lub)
  end

  it 'initializes Lub object' do
    lub = Plurimath::Asciimath::Function::Lub.new([70, 3])
    expect(lub.values).to eql([70, 3])
  end
end
