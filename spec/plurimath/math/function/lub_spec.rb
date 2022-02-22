require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Lub do

  it 'returns instance of Lub' do
    lub = Plurimath::Math::Function::Lub.new([70, 3])
    expect(lub).to be_a(Plurimath::Math::Function::Lub)
  end

  it 'initializes Lub object' do
    lub = Plurimath::Math::Function::Lub.new([70, 3])
    expect(lub.values).to eql([70, 3])
  end
end
