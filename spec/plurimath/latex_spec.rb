require_relative '../../lib/plurimath/math'

RSpec.describe Plurimath::Latex do
  it 'returns instance of Latex' do
    latex = Plurimath::Latex.new('\cos_{45}')
    expect(latex).to be_a(Plurimath::Latex)
  end

  it 'returns Mathml instance' do
    latex = Plurimath::Latex.new('\cos_{45}')
    expect(latex.text).to eql('\cos_{45}')
  end
end
