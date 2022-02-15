require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Dim do

  it 'returns instance of Dim' do
    dim = Plurimath::Asciimath::Function::Dim.new('Q')
    expect(dim).to be_a(Plurimath::Asciimath::Function::Dim)
  end

  it 'initializes Dim object' do
    dim = Plurimath::Asciimath::Function::Dim.new('Q')
    expect(dim.dimensions).to eql('Q')
  end
end
