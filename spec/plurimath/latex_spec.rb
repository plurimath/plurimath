require_relative '../../lib/plurimath/plurimath'

RSpec.describe Plurimath::Latex do
  it 'returns instance of Latex' do
    latex = Plurimath::Latex.new('latex')
    expect(latex).to be_a(Plurimath::Latex)
  end

  it 'returns Mathml instance' do
    latex = Plurimath::Latex.new('latex')
    expect(latex.text).to eql('latex')
  end
end
