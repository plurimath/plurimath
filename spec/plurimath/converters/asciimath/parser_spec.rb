require_relative '../../../../lib/plurimath/converters/asciimath/parser'

RSpec.describe Plurimath::Math::Parser do

  it 'returns instance of Parser' do
    parser = Plurimath::Math::Parser.new('parser')
    expect(parser).to be_a(Plurimath::Math::Parser)
  end

  it 'initializes Parser object' do
    parser = Plurimath::Math::Parser.new('parser')
    expect(parser.string).to eql('parser')
  end
end

