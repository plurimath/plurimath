require_relative '../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Variable do

  it 'returns instance of Variable' do
    variable = Plurimath::Math::Variable.new('variable')
    expect(variable).to be_a(Plurimath::Math::Variable)
  end

  it 'initializes Variable object' do
    variable = Plurimath::Math::Variable.new('variable')
    expect(variable.value).to eql('variable')
  end
end

