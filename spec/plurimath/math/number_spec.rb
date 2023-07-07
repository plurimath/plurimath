require_relative '../../../spec/spec_helper'

RSpec.describe Plurimath::Math::Number do

  describe ".initialize" do
    it 'returns instance of Number' do
      number = Plurimath::Math::Number.new(100)
      expect(number).to be_a(Plurimath::Math::Number)
    end

    it 'initializes Number object' do
      number = Plurimath::Math::Number.new(100)
      expect(number.value).to eql(100)
    end
  end

  describe ".to_asciimath" do
    subject(:number) { described_class.new(value) }

    context "contains a number string" do
      let(:value) { "1" }

      it 'returns string' do
        expect(number.to_asciimath).to eq(value)
      end
    end
  end

  describe ".==" do
    subject(:number) { Plurimath::Math::Number.new(value) }

    context "contains a number string" do
      let(:value) { "1" }
      expected_value = Plurimath::Math::Number.new("1")

      it 'returns string' do
        expect(number == expected_value).to be_truthy
      end
    end

    context "contains a nil string" do
      let(:value) { "" }
      expected_value = Plurimath::Math::Number.new("1")

      it 'returns string' do
        expect(number == expected_value).to be_falsey
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value).to_asciimath }

    context "contains Single Number as value" do
      let(:first_value) { "1" }

      it "returns asciimath string" do
        expect(formula).to eq("1")
      end
    end

    context "contains Decimal Number as value" do
      let(:first_value) { "70.8" }

      it "returns asciimath string" do
        expect(formula).to eq("70.8")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Ox.dump(
        described_class.new(first_value).
          to_mathml_without_math_tag,
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns mathml string" do
        expect(formula).to be_equivalent_to("<mn>70</mn>")
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex }

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "returns mathml string" do
        expect(formula).to eql("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns mathml string" do
        expect(formula).to eql("70")
      end
    end
  end

  describe ".to_omml" do
    subject(:formula) do
      Ox.dump(
        described_class.new(first_value).
          to_omml_without_math_tag.first,
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns mathml string" do
        expect(formula).to be_equivalent_to("<m:t>70</m:t>")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "returns mathml string" do
        expect(formula).to be_equivalent_to("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns mathml string" do
        expect(formula).to be_equivalent_to("70")
      end
    end
  end
end
