require_relative '../../lib/plurimath/math'

RSpec.describe Plurimath::Html do

  it 'returns instance of Html' do
    html = Plurimath::Html.new('<h4> 1 + 3 </h4>')
    expect(html).to be_a(Plurimath::Html)
  end

  it 'returns Asciimath instance' do
    html = Plurimath::Html.new('<h4> 1 + 3 </h4>')
    expect(html.text).to eql('<h4> 1 + 3 </h4>')
  end
end
