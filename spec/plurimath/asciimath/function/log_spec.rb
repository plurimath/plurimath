require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Log do

  it 'returns instance of Log' do
    log = Plurimath::Asciimath::Function::Log.new(7, 2)
    expect(log).to be_a(Plurimath::Asciimath::Function::Log)
  end

  it 'initializes Log object' do
    log = Plurimath::Asciimath::Function::Log.new(70, 3)
    expect(log.base).to eql(70)
    expect(log.exponent).to eql(3)
  end
end
