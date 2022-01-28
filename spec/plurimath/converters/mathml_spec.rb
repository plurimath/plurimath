require_relative '../../../lib/plurimath/plurimath'

RSpec.describe Mathml do

  it 'returns instance of Mathml' do
    raw_text = "<math xmlns='http://www.w3.org/1998/Math/MathML'><matrix><matrixrow><cn> 0 </cn> <cn> 1 </cn> <cn> 0 </cn></matrixrow><matrixrow><cn> 0 </cn> <cn> 0 </cn> <cn> 1 </cn></matrixrow><matrixrow><cn> 1 </cn> <cn> 0 </cn> <cn> 0 </cn></matrixrow></matrix></math>"
    expect(Mathml.new(raw_text)).to be_a(Mathml)
  end

  it 'returns Mathml instance' do
    raw_text = "<math xmlns='http://www.w3.org/1998/Math/MathML'><matrix><matrixrow><cn> 0 </cn> <cn> 1 </cn> <cn> 0 </cn></matrixrow><matrixrow><cn> 0 </cn> <cn> 0 </cn> <cn> 1 </cn></matrixrow><matrixrow><cn> 1 </cn> <cn> 0 </cn> <cn> 0 </cn></matrixrow></matrix></math>"
    expect(Mathml.new(raw_text).to_asciimath).to be_a(Asciimath)
  end

  it 'converts Mathml to mathml' do
    raw_text = "<math xmlns='http://www.w3.org/1998/Math/MathML'><matrix><matrixrow><cn> 0 </cn> <cn> 1 </cn> <cn> 0 </cn></matrixrow><matrixrow><cn> 0 </cn> <cn> 0 </cn> <cn> 1 </cn></matrixrow><matrixrow><cn> 1 </cn> <cn> 0 </cn> <cn> 0 </cn></matrixrow></matrix></math>"
    converted_str = "<math xmlns=\"http://www.w3.org/1998/Math/MathML\"><matrix>\n <matrixrow>\n <cn> 0 </cn>\n <cn> 1 </cn>\n <cn> 0 </cn>\n </matrixrow>\n <matrixrow>\n <cn> 0 </cn>\n <cn> 0 </cn>\n <cn> 1 </cn>\n </matrixrow>\n <matrixrow>\n <cn> 1 </cn>\n <cn> 0 </cn>\n <cn> 0 </cn>\n </matrixrow>\n</matrix></math>"
    expect(Mathml.new(raw_text).to_asciimath.text).to eql(converted_str)
  end
end
