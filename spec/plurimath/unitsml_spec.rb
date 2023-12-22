require "spec_helper"

RSpec.describe Plurimath::Unitsml do

  describe ".initialize" do
    let(:unitsml) { described_class.new(input_text) }

    context "contains valid equation" do
      let(:input_text) { 'mm^3' }

      it 'matches instance of Unitsml and input text' do
        expect(unitsml).to be_a(described_class)
        expect(unitsml.text).to eql('mm^3')
      end

      it 'expects to not raise an error' do
        expect{unitsml}.not_to raise_error
      end
    end

    context "contains positive exponent variable invalid equation" do
      let(:input_text) { 'mm^(b)' }

      it 'expects error message indicating invalid exponent value' do
        message = "The use of a variable as an exponent is not valid."
        expect{unitsml}.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end

    context "contains negative exponent variable invalid equation" do
      let(:input_text) { 'mm^(-b)' }

      it 'expects error message indicating invalid exponent value' do
        message = "The use of a variable as an exponent is not valid."
        expect{unitsml}.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end

    context "contains negative exponent alphanumeric variable invalid equation" do
      let(:input_text) { 'mm^(-2b)' }

      it 'expects error message indicating invalid exponent value' do
        message = "The use of a variable as an exponent is not valid."
        expect{unitsml}.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end
  end
end
