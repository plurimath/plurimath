require_relative '../../../lib/plurimath/asciimath_parser'

RSpec.describe Plurimath::AsciimathParser::Theta do

  it 'returns instance of Theta' do
    theta = Plurimath::AsciimathParser::Theta.new('theta')
    expect(theta).to be_a(Plurimath::AsciimathParser::Theta)
  end

  it 'initializes Theta object' do
    theta = Plurimath::AsciimathParser::Theta.new('theta')
    expect(theta.angle).to eql('theta')
  end
end

