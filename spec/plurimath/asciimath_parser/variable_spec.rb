require_relative '../../../lib/plurimath/asciimath_parser'

RSpec.describe Plurimath::AsciimathParser::Variable do

  it 'returns instance of Variable' do
    variable = Plurimath::AsciimathParser::Variable.new('variable')
    expect(variable).to be_a(Plurimath::AsciimathParser::Variable)
  end

  it 'initializes Variable object' do
    variable = Plurimath::AsciimathParser::Variable.new('variable')
    expect(variable.value).to eql('variable')
  end
end

