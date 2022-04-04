require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Vec do

  it 'returns instance of Vec' do
    vec = Plurimath::Math::Function::Vec.new('70')
    expect(vec).to be_a(Plurimath::Math::Function::Vec)
  end

  it 'initializes Vec object' do
    vec = Plurimath::Math::Function::Vec.new('70')
    expect(vec.parameter_one).to eql('70')
  end
end
