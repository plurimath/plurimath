require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Root do

  it 'returns instance of Root' do
    root = Plurimath::Asciimath::Function::Root.new(70, 3)
    expect(root).to be_a(Plurimath::Asciimath::Function::Root)
  end

  it 'initializes Root object' do
    root = Plurimath::Asciimath::Function::Root.new(70, 3)
    expect(root.index).to eql(70)
    expect(root.number).to eql(3)
  end
end
