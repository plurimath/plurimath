require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Function::Table do

  it 'returns instance of Table' do
    table = Plurimath::Math::Function::Table.new('70')
    expect(table).to be_a(Plurimath::Math::Function::Table)
  end

  it 'initializes Table object' do
    table = Plurimath::Math::Function::Table.new('70')
    expect(table.parameter_one).to eql('70')
  end
end
