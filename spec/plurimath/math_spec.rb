require "spec_helper"

RSpec.describe Plurimath::Math do
  describe ".initialize" do
    subject(:formula) { Plurimath::Math.parse(input, type) }

    context "contains incorrect type with parseable input of asciimath" do
      let(:input) { "sin(d)" }
      let(:type) { "wrong_type" }

      it "raises error on wrong type" do
        expect{formula}.to raise_error(Plurimath::Math::InvalidTypeError)
      end
    end

    context "contains correct type with incomplete input of latex" do
      let(:input) { '{\sin{d}' }
      let(:type) { "latex" }

      it "raises error on wrong text input" do
        message = "\\[plurimath-#{Plurimath::VERSION}\\] Error: Failed to parse the following formula with type `#{type}`"
        expect{formula}.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end

    context "contains correct input string and custom invalid formula" do

      it "raises error on wrong text input" do
        formula = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new("d"),
        ])
        expect{formula.to_html}.to raise_error(Plurimath::Math::ParseError)
        expect{formula.to_omml}.to raise_error(Plurimath::Math::ParseError)
        expect{formula.to_latex}.to raise_error(Plurimath::Math::ParseError)
        expect{formula.to_mathml}.to raise_error(Plurimath::Math::ParseError)
        expect{formula.to_asciimath}.to raise_error(Plurimath::Math::ParseError)
        expect{formula.to_unicodemath}.to raise_error(Plurimath::Math::ParseError)
      end
    end
  end
end
