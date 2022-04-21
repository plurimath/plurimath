require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Function::Td do

  it 'returns instance of Td' do
    td = Plurimath::Math::Function::Td.new('70')
    expect(td).to be_a(Plurimath::Math::Function::Td)
  end

  it 'initializes Td object' do
    td = Plurimath::Math::Function::Td.new('70')
    expect(td.parameter_one).to eql('70')
  end
end
