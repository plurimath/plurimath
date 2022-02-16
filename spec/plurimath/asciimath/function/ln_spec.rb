require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Ln do

  it 'returns instance of Ln' do
    ln = Plurimath::Asciimath::Function::Ln.new(45)
    expect(ln).to be_a(Plurimath::Asciimath::Function::Ln)
  end

  it 'initializes Ln object' do
    ln = Plurimath::Asciimath::Function::Ln.new(70)
    expect(ln.exponent).to eql(70)
  end
end
