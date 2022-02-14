require_relative '../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Variable do

  it 'returns instance of Variable' do
    variable = Plurimath::Asciimath::Variable.new('variable')
    expect(variable).to be_a(Plurimath::Asciimath::Variable)
  end

  it 'initializes Variable object' do
    variable = Plurimath::Asciimath::Variable.new('variable')
    expect(variable.value).to eql('variable')
  end
end

