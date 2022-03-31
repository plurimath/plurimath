require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Root do

  it 'returns instance of Root' do
    root = Plurimath::Math::Function::Root.new(70, 3)
    expect(root).to be_a(Plurimath::Math::Function::Root)
  end

  it 'initializes Root object' do
    root = Plurimath::Math::Function::Root.new(70, 3)
    expect(root.parameter_one).to eql(70)
    expect(root.parameter_two).to eql(3)
  end
end
