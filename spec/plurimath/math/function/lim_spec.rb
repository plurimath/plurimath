require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Function::Lim do

  subject(:lim) { described_class.new(parameter_one, parameter_two) }

  describe ".initialize" do

    context "initializes object" do
      let(:parameter_one) { '70' }
      let(:parameter_two) { '20' }

      it 'returns instance of Lim' do
        expect(lim).to be_a(Plurimath::Math::Function::Lim)
      end

      it 'initializes Lim object' do
        expect(lim.parameter_one).to eql('70')
        expect(lim.parameter_two).to eql('20')
      end
    end
  end

  describe ".to_asciimath" do
    let(:parameter_one) { Plurimath::Math::Number.new('70') }
    let(:parameter_two) { Plurimath::Math::Number.new('20') }

    context "contains base and exponent values" do
      it "matches with asciimath string" do
        expect(lim.to_asciimath).to eq("lim_(70)^(20)")
      end
    end
  end
end
