require "spec_helper"

RSpec.describe Plurimath::UnicodeMath do

  it 'returns instance of Unicode' do
    unicode = Plurimath::UnicodeMath.new('⎣2.5⎦')
    expect(unicode).to be_a(Plurimath::UnicodeMath)
  end

  it 'returns Latex instance' do
    unicode = Plurimath::UnicodeMath.new('⎣2.5⎦')
    expect(unicode.text).to eql('⎣2.5⎦')
  end
end
