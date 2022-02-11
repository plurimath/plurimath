require_relative '../../lib/plurimath/plurimath'

RSpec.describe Plurimath::Formula do

  it 'returns instance of Formula' do
    formula = Plurimath::Formula.new('formula')
    expect(formula).to be_a(Plurimath::Formula)
  end

  it 'returns Formula instance' do
    formula = Plurimath::Formula.new('formula')
    expect(formula.text).to eql('formula')
  end
end
