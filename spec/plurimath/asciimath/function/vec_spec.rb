require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Vec do

  it 'returns instance of Vec' do
    vec = Plurimath::Asciimath::Function::Vec.new('70')
    expect(vec).to be_a(Plurimath::Asciimath::Function::Vec)
  end

  it 'initializes Vec object' do
    vec = Plurimath::Asciimath::Function::Vec.new('70')
    expect(vec.value).to eql('70')
  end
end
