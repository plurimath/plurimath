require_relative '../../lib/plurimath/math'

RSpec.describe Plurimath::Math do
  describe ".initialize" do
    subject(:formula) { Plurimath::Math.parse(input, type: type) }

    context "contains incorrect type with parseable input of asciimath" do
      let(:input) { "sin(d)" }
      let(:type) { "wrong_type" }

      it "raises error on wrong type" do
        expect{formula}.to raise_error(Plurimath::Math::Error)
      end
    end

    context "contains correct type with incomplete input of latex" do
      let(:input) { "{\\sin{d}" }
      let(:type) { "latex" }

      it "raises error on wrong text input" do
        error_message = "An error occurred while processing the input. "\
                        "Please check your input to ensure it is valid "\
                        "or open an issue on Github If you believe the input is correct."
        expect{formula}.to raise_error(Plurimath::Math::Error, Regexp.compile(error_message))
      end
    end
  end
end
