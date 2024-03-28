require "spec_helper"

RSpec.describe Plurimath::UnicodeMath do

  it 'returns instance of Unicode' do
    unicode = described_class.new('⎣2.5⎦')
    expect(unicode).to be_a(described_class)
  end

  it 'matches UnicodeMath string' do
    unicode = described_class.new('⎣2.5⎦')
    expect(unicode.text).to eql('⎣2.5⎦')
  end
  describe ".to_unicodemath" do
    subject(:formula) { Plurimath::Math.parse(asciimath_string, :asciimath) }

    context "contains example #01" do
      let(:asciimath_string) { '"unitsml(V*s//A,symbol:V cdot s//A)"' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = "\\mupV ⋅ \\mups ⋅ \\mupA^(− 1)"
        expect(formula.to_unicodemath).to eq(unicodemath)
      end
    end

    context "contains example #02" do
      let(:asciimath_string) { 'log_(1+2+3+4)^("4 terms")' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = 'log_(1 + 2 + 3 + 4)^("4 terms")'
        expect(formula.to_unicodemath).to eq(unicodemath)
      end
    end

    context "contains example #03" do
      let(:asciimath_string) { 'left[[1,3], [1,3], [1,3]right] left(sum_prod^sigmaright)' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = 'ⓢ(1&3@1&3@1&3) ( ∑_(∏)^(σ) )'
        expect(formula.to_unicodemath).to eq(unicodemath)
      end
    end

    context "contains example #04" do
      let(:asciimath_string) { 'hat(ab) bar(xy) ul(A) vec(v)' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = "(a b)̂ (x y)̅ ▁(A) (v)⃗"
        expect(formula.to_unicodemath).to eq(unicodemath)
      end
    end

    context "contains example #05" do
      let(:asciimath_string) { '|(a,b),(c,d)|' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = '⒱(a&b@c&d)'
        expect(formula.to_unicodemath).to eq(unicodemath)
      end
    end

    context "contains example #06" do
      let(:asciimath_string) { 'obrace(sum) ubrace(sum) tilde(d)' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = '⏞(∑) ⏟(∑) (d)̃'
        expect(formula.to_unicodemath).to eq(unicodemath)
      end
    end
  end
end
