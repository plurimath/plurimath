require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Ceil do

  it 'returns instance of Ceil' do
    ceil = Plurimath::Asciimath::Function::Ceil.new(70.3)
    expect(ceil).to be_a(Plurimath::Asciimath::Function::Ceil)
  end

  it 'initializes Ceil object' do
    ceil = Plurimath::Asciimath::Function::Ceil.new(70.4)
    expect(ceil.value).to eql(70.4)
  end
end
