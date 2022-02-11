require_relative '../../../lib/plurimath/plurimath'

RSpec.describe Unicode do

  it 'returns instance of Unicode' do
    unicode = Unicode.new('unicode')
    expect(unicode).to be_a(Unicode)
  end

  it 'returns Latex instance' do
    unicode = Unicode.new('unicode')
    expect(unicode.text).to eql('unicode')
  end
end
