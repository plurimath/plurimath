require_relative '../../lib/plurimath/math'

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
        message = "Failed to parse the following formula with type `#{type}`"
        expect{formula}.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end
  end
end
