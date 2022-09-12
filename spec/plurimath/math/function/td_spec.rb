require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Function::Td do

  describe ".initialize" do
    subject(:td) { Plurimath::Math::Function::Td.new(first) }

    context "initialize Td object" do
      let(:first) { "70" }

      it 'returns instance of Td' do
        expect(td).to be_a(Plurimath::Math::Function::Td)
      end

      it 'initialize Td object' do
        td = Plurimath::Math::Function::Td.new('70')
        expect(td.parameter_one).to eql('70')
      end
    end
  end

  describe ".to_asciimath" do
    subject(:single_value_td) { Plurimath::Math::Function::Td.new([first]).to_asciimath }
    subject(:double_value_td) { Plurimath::Math::Function::Td.new([first, second]).to_asciimath }

    context "returns instance of Td" do
      let(:first) { Plurimath::Math::Symbol.new("theta") }

      it 'matches epxected value of Td' do
        expect(single_value_td).to eq("theta")
      end

      it "doesn't match epxected value of Td" do
        expect(single_value_td).not_to eq("[Theta]")
      end
    end

    context "returns instance of Td" do
      let(:first) { Plurimath::Math::Symbol.new("theta") }
      let(:second) { Plurimath::Math::Symbol.new("Theta") }

      it 'matches epxected value of Td' do
        expect(double_value_td).to eq("[theta,Theta]")
      end

      it "doesn't match epxected value of Td" do
        expect(double_value_td).not_to eq("[Theta]")
      end
    end
  end
end
