require_relative '../../../lib/plurimath/plurimath'

RSpec.describe Latex do
  it 'returns instance of Latex' do
    latex = Latex.new('latex')
    expect(latex).to be_a(Latex)
  end

  it 'returns Mathml instance' do
    latex = Latex.new('latex')
    expect(latex.text).to eql('latex')
  end
end
