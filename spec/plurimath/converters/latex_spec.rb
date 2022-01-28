require_relative '../../../lib/plurimath/plurimath'

RSpec.describe Latex do

  it 'returns instance of Latex' do
    expect(Latex.new('rspec')).to be_a(Latex)
  end

  it 'returns Mathml instance' do
    expect(Latex.new('rspec').to_mathml).to be_a(Mathml)
  end

  it 'converts latex to mathml' do
    converted_str = <<~EOS.gsub("\n", '').gsub('  ', '')
      <math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\">
        <mrow>
          <mi>&#x00072;</mi>
          <mi>&#x00073;</mi>
          <mi>&#x00070;</mi>
          <mi>&#x00065;</mi>
          <mi>&#x00063;</mi>
        </mrow>
      </math>
    EOS
    expect(Latex.new('rspec').to_mathml.text).to eql(converted_str)
  end
end

