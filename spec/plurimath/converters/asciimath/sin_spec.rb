require_relative '../../../../lib/plurimath/converters/asciimath/parser'

RSpec.describe Plurimath::Math::Sin do

  it 'returns instance of Sin' do
    sin = Plurimath::Math::Sin.new('sin')
    expect(sin).to be_a(Plurimath::Math::Sin)
  end

  it 'initializes Sin object' do
    sin = Plurimath::Math::Sin.new('sin')
    expect(sin.angle).to eql('sin')
  end
end

