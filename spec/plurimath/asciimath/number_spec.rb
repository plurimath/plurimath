require_relative '../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Number do

  it 'returns instance of Number' do
    number = Plurimath::Asciimath::Number.new(100)
    expect(number).to be_a(Plurimath::Asciimath::Number)
  end

  it 'initializes Number object' do
    number = Plurimath::Asciimath::Number.new(100)
    expect(number.value).to eql(100)
  end
end
