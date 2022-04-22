require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Function::Tr do

  describe ".initialize" do
    subject(:tr) { Plurimath::Math::Function::Tr.new(first) }

    context "initialize Tr object" do
      let(:first) { "70" }

      it 'returns instance of Tr' do
        expect(tr).to be_a(Plurimath::Math::Function::Tr)
      end

      it 'initialize Tr object' do
        tr = Plurimath::Math::Function::Tr.new('70')
        expect(tr.parameter_one).to eql('70')
      end
    end
  end

  describe ".to_asciimath" do
    subject(:tr) { Plurimath::Math::Function::Tr.new([first]).to_asciimath }

    context "returns instance of Tr" do
      let(:first) { Plurimath::Math::Symbol.new("theta") }

      it 'matches epxected value of Tr' do
        expect(tr).to eq("[theta]")
      end

      it "doesn't match epxected value of Tr" do
        expect(tr).not_to eq("[Theta]")
      end
    end
  end
end
