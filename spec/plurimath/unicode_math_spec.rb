require "spec_helper"

RSpec.describe Plurimath::UnicodeMath do

  describe "#described_class" do
    it 'returns instance of Unicode' do
      unicode = described_class.new('⎣2.5⎦')
      expect(unicode).to be_a(described_class)
    end

    it 'matches UnicodeMath string' do
      unicode = described_class.new('⎣2.5⎦')
      expect(unicode.text).to eql('⎣2.5⎦')
    end
  end

  describe "#to_unicodemath AsciiMath" do
    subject(:formula) { Plurimath::Math.parse(asciimath_string, :asciimath) }
    subject(:string) { formula.to_unicodemath }

    context "contains example #01" do
      let(:asciimath_string) { '"unitsml(V*s//A,symbol:V cdot s//A)"' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = "\\mupV ⋅ \\mups ⋅ \\mupA^(− 1)"
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #02" do
      let(:asciimath_string) { 'log_(1+2+3+4)^("4 terms")' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = 'log_(1 + 2 + 3 + 4)^("4 terms")'
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #03" do
      let(:asciimath_string) { 'left[[1,3], [1,3], [1,3]right] left(sum_prod^sigmaright)' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = 'ⓢ(1&3@1&3@1&3) ( ∑_(∏)^(σ) )'
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #04" do
      let(:asciimath_string) { 'hat(ab) bar(xy) ul(A) vec(v)' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = "(a b)̂ (x y)̅ ▁(A) (v)⃗"
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #05" do
      let(:asciimath_string) { '|(a,b),(c,d)|' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = '⒱(a&b@c&d)'
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #06" do
      let(:asciimath_string) { 'obrace(sum) ubrace(sum) tilde(d)' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = '⏞(∑) ⏟(∑) (d)̃'
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #07" do
      let(:asciimath_string) { 'lcm(d) exp(d) gcd(d) glb(d) ln(d) lub(d) max(d) min(d) floor(d) norm(d) ceil(d) dot(d) cancel(d)' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = 'lcm⁡(d) exp⁡(d) gcd⁡(d) glb⁡(d) ln⁡(d) lub⁡(d) max⁡(d) min⁡(d) ⌊d⌋ ‖d‖ ⌈d⌉ (d)̇ ╱(d)'
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #08" do
      let(:asciimath_string) { 'ubrace_d^2 bigwedge_2^d 1 mod 3' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = '⏟_(d)^(2) ⋀_(2)^(d) 1mod3'
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #09" do
      let(:asciimath_string) { '[(cos{:y_2:},sin y_2),(-(sin y_2)//y_1,(cos y_2)//y_1)] .' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = 'ⓢ(cos⁡├y_(2)┤&sin⁡y_(2)@-(sin⁡y_(2))/y_(1)&(cos⁡y_(2))/y_(1)) .'
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #10" do
      let(:asciimath_string) { '[(cos{:y_2:},sin y_2),(-(sin y_2)//y_1,(cos y_2)//y_1)] .' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = 'ⓢ(cos⁡├y_(2)┤&sin⁡y_(2)@-(sin⁡y_(2))/y_(1)&(cos⁡y_(2))/y_(1)) .'
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #11" do
      let(:asciimath_string) { 'stackrel(70)(n)' }

      it 'matches parsed Asciimath string to UnicodeMath' do
        unicodemath = '(n)┴(70)'
        expect(string).to eq(unicodemath)
      end
    end
  end

  describe "#to_unicodemath LaTeX" do
    subject(:formula) { Plurimath::Math.parse(latex_string, :latex) }
    subject(:string) { formula.to_unicodemath }

    context "contains example #1" do
      let(:latex_string) { '\sum_{\substack{1\le i\le n \\\\ i\ne j}}' }

      it 'matches parsed LaTeX string to UnicodeMath' do
        unicodemath = '∑_(■(1≤i≤n@i≠j))'
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #2" do
      let(:latex_string) { '\int\limits_{0}^{\pi}' }

      it 'matches parsed LaTeX string to UnicodeMath' do
        unicodemath = '∫┴(π)┬(0)'
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #3" do
      let(:latex_string) { '\inf_{x > s}f(x)' }

      it 'matches parsed LaTeX string to UnicodeMath' do
        unicodemath = 'inf_(x > s) f (x)'
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #4" do
      let(:latex_string) { '\rule[-1mm]{5mm}{1cm} \mbox{symmentic}' }

      it 'matches parsed LaTeX string to UnicodeMath' do
        unicodemath = ' "symmentic"'
        expect(string).to eq(unicodemath)
      end
    end

    context "contains example #5" do
      let(:latex_string) { '{1 \over 2}' }

      it 'matches parsed LaTeX string to UnicodeMath' do
        unicodemath = '(1)/(2)'
        expect(string).to eq(unicodemath)
      end
    end
  end
end
