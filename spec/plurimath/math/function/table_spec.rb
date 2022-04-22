require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Function::Table do

  describe ".initialize" do
    subject(:table) { Plurimath::Math::Function::Table.new(first) }

    context "initialize Table object" do
      let(:first) { '70' }
      it 'returns instance of Table' do
        expect(table).to be_a(Plurimath::Math::Function::Table)
      end

      it 'initializes Table object' do
        expect(table.parameter_one).to eql('70')
      end
    end
  end

  describe ".to_asciimath" do
    subject(:table) { Plurimath::Math::Function::Table.new([first]).to_asciimath }

    context "initialize Table object" do
      let(:first) { Plurimath::Math::Number.new("1") }

      it 'returns instance of Table' do
        expected_value = "[1]"
        expect(table).to eq(expected_value)
      end

      it "doesn't return expected value" do
        expected_value = "[1"
        expect(table).not_to eq(expected_value)
      end
    end
  end
end
