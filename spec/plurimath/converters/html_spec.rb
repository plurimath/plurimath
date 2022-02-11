require_relative '../../../lib/plurimath/plurimath'

RSpec.describe Html do

  it 'returns instance of Html' do
    html = Html.new('html')
    expect(html).to be_a(Html)
  end

  it 'returns Asciimath instance' do
    html = Html.new('html')
    expect(html.text).to eql('html')
  end
end
