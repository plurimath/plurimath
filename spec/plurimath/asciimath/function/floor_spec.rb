require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Floor do

  it 'returns instance of Floor' do
    floor = Plurimath::Asciimath::Function::Floor.new(70.3)
    expect(floor).to be_a(Plurimath::Asciimath::Function::Floor)
  end

  it 'initializes Floor object' do
    floor = Plurimath::Asciimath::Function::Floor.new(70.3)
    expect(floor.value).to eql(70.3)
  end
end
