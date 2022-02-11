require_relative '../../lib/plurimath/plurimath'

RSpec.describe Plurimath::Unicode do

  it 'returns instance of Unicode' do
    unicode = Plurimath::Unicode.new('⎣2.5⎦')
    expect(unicode).to be_a(Plurimath::Unicode)
  end

  it 'returns Latex instance' do
    unicode = Plurimath::Unicode.new('⎣2.5⎦')
    expect(unicode.text).to eql('⎣2.5⎦')
  end
end
