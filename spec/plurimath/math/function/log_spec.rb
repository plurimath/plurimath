require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Log do

  it 'returns instance of Log' do
    log = Plurimath::Math::Function::Log.new(7, 2)
    expect(log).to be_a(Plurimath::Math::Function::Log)
  end

  it 'initializes Log object' do
    log = Plurimath::Math::Function::Log.new(70, 3)
    expect(log.base).to eql(70)
    expect(log.exponent).to eql(3)
  end
end
