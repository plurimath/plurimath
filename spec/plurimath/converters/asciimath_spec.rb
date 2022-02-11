require_relative '../../../lib/plurimath/plurimath'

RSpec.describe Asciimath do

  it 'returns instance of Asciimath' do
    asciimath = Asciimath.new('asciimath')
    expect(asciimath).to be_a(Asciimath)
  end

  it 'initializes Asciimath object' do
    asciimath = Asciimath.new('asciimath')
    expect(asciimath.text).to eql('asciimath')
  end
end

