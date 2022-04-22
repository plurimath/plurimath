require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Base do

  it 'returns instance of Base' do
    base = Plurimath::Math::Function::Base.new("sum", "theta")
    expect(base).to be_a(Plurimath::Math::Function::Base)
  end

  it 'initializes Base object' do
    base = Plurimath::Math::Function::Base.new("sum", "theta")
    expect(base.parameter_one).to eql("sum")
    expect(base.parameter_two).to eql("theta")
  end
end
