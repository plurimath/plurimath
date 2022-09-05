require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Left do

  describe ".initialize" do
    subject(:left) { described_class.new(string)  }

    context "contains simple text to match Object and field value" do

      it 'returns instance of Left' do
        left = Plurimath::Math::Function::Left.new('70')
        expect(left).to be_a(Plurimath::Math::Function::Left)
      end

      it 'initializes Left object' do
        left = Plurimath::Math::Function::Left.new('70')
        expect(left.parameter_one).to eql('70')
      end
    end
  end

  describe ".to_asciimath" do
    subject(:left) { described_class.new(string).to_asciimath  }

    context "contains opening bracket" do
      let(:string) { "(" }

      it 'returns instance of Left' do
        expect(left).to eq("left(")
      end
    end
  end

  describe ".to_latex" do
    subject(:left) { described_class.new(string).to_latex  }

    context "contains opening bracket" do
      let(:string) { "(" }

      it 'returns instance of Left' do
        expect(left).to eq("\\left(")
      end
    end

    context "contains curly opening bracket" do
      let(:string) { "{" }

      it 'returns instance of Left' do
        expect(left).to eq("\\left\\{")
      end
    end
  end
end
