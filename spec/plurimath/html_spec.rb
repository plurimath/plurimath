require_relative '../../lib/plurimath/math'

RSpec.describe Plurimath::Html do

  describe ".to_formula" do
    subject(:formula) { Plurimath::Html.new(string.gsub(/\s/, "")).to_html }

    it 'matches the class object' do
      html = Plurimath::Html.new('<h4> 1 + 3 </h4>')
      expect(html).to be_a(Plurimath::Html)
    end

    it 'contains passed html string' do
      html = Plurimath::Html.new('<h4> 1 + 3 </h4>')
      expect(html.text).to eql('<h4> 1 + 3 </h4>')
    end
  end

  describe ".to_formula" do
    subject(:formula) { Plurimath::Html.new(string.gsub(/\s/, "")).to_formula }

    context "contains basic simple html math equation and" do
      let(:string) { '<h4> 1 + 3 </h4>' }
      it 'returns parsed HTML to Formula' do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Number.new("3")
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
