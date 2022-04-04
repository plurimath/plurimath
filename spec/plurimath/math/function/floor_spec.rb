require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Floor do

  it 'returns instance of Floor' do
    floor = Plurimath::Math::Function::Floor.new(70.3)
    expect(floor).to be_a(Plurimath::Math::Function::Floor)
  end

  it 'initializes Floor object' do
    floor = Plurimath::Math::Function::Floor.new(70.3)
    expect(floor.parameter_one).to eql(70.3)
  end
end
