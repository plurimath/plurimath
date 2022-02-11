require_relative '../../lib/plurimath/plurimath'

RSpec.describe Plurimath::Asciimath do

  it 'returns instance of Asciimath' do
    asciimath = Plurimath::Asciimath.new('asciimath')
    expect(asciimath).to be_a(Plurimath::Asciimath)
  end

  it 'initializes Plurimath::Asciimath object' do
    asciimath = Plurimath::Asciimath.new('asciimath')
    expect(asciimath.text).to eql('asciimath')
  end
end

