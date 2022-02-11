require_relative '../../lib/plurimath/plurimath'

RSpec.describe Plurimath do

  test_record = {
    unicode: 'unicode',
    asciimath: 'asciimath',
    omml: 'omml',
    mathml: 'mathml',
    html: 'html',
    latex: 'latex'
  }

  it 'Converts all entries successfully' do
    test_record.each do |type, record|
      expect(Plurimath.parse(record, type).text).to eql(record)
    end
  end

  it "raises error on wrong type" do
    expect{Plurimath.parse("asdf", type: 'wrong_type')}.to raise_error(Plurimath::Error)
  end
end
