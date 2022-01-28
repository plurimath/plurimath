require_relative '../../../lib/plurimath/plurimath'

RSpec.describe Html do

  it 'returns instance of Html' do
    expect(Html.new('<h3>rspec</h3>')).to be_a(Html)
  end

  it 'returns Asciimath instance' do
    expect(Html.new('<h3>rspec</h3>').to_asciimath).to be_a(Asciimath)
  end

  it 'converts html to asciimath' do
    converted_str = "\"rspec\""
    expect(Html.new('<h3>rspec</h3>').to_asciimath.text).to eql(converted_str)
  end
end

