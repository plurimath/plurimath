require_relative '../../lib/plurimath/plurimath'

RSpec.describe Plurimath::Html do

  it 'returns instance of Html' do
    html = Plurimath::Html.new('html')
    expect(html).to be_a(Plurimath::Html)
  end

  it 'returns Asciimath instance' do
    html = Plurimath::Html.new('html')
    expect(html.text).to eql('html')
  end
end
