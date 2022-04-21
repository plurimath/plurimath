require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Fenced do

  it 'returns instance of Fenced' do
    fenced = Plurimath::Math::Function::Fenced.new("sum", "theta", "square")
    expect(fenced).to be_a(Plurimath::Math::Function::Fenced)
  end

  it 'initializes Fenced object' do
    fenced = Plurimath::Math::Function::Fenced.new("sum", "theta", "square")
    expect(fenced.parameter_one).to eql("sum")
    expect(fenced.parameter_two).to eql("theta")
    expect(fenced.parameter_three).to eql("square")
  end
end
