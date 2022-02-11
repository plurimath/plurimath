require_relative '../../../../lib/plurimath/converters/asciimath/parser'

RSpec.describe Plurimath::Math::Number do

  it 'returns instance of Number' do
    number = Plurimath::Math::Number.new('number')
    expect(number).to be_a(Plurimath::Math::Number)
  end

  it 'initializes Number object' do
    number = Plurimath::Math::Number.new('number')
    expect(number.value).to eql('number')
  end
end
