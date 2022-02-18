require_relative '../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Number do

  it 'returns instance of Number' do
    number = Plurimath::Math::Number.new(100)
    expect(number).to be_a(Plurimath::Math::Number)
  end

  it 'initializes Number object' do
    number = Plurimath::Math::Number.new(100)
    expect(number.value).to eql(100)
  end
end
