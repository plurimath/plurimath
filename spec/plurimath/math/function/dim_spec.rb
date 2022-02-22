require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Dim do

  it 'returns instance of Dim' do
    dim = Plurimath::Math::Function::Dim.new('Q')
    expect(dim).to be_a(Plurimath::Math::Function::Dim)
  end

  it 'initializes Dim object' do
    dim = Plurimath::Math::Function::Dim.new('Q')
    expect(dim.dimensions).to eql('Q')
  end
end
