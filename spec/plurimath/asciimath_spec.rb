require_relative '../../lib/plurimath/math'

RSpec.describe Plurimath::Asciimath do

  it 'returns instance of Asciimath' do
    asciimath = Plurimath::Asciimath.new('cos(2)')
    expect(asciimath).to be_a(Plurimath::Asciimath)
  end

  it 'initializes Plurimath::Asciimath object' do
    asciimath = Plurimath::Asciimath.new('cos(2)')
    expect(asciimath.text).to eql('cos(2)')
  end
end

