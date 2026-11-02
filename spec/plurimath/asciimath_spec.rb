require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Asciimath do
  describe ".initialize" do
    subject(:asciimath) { described_class.new(string) }

    context "contains simple cos function with numeric value" do
      let(:string) { "cos(2)" }

      it "returns instance of Asciimath" do
        expect(asciimath).to be_a(described_class)
      end

      it "initializes Plurimath::Asciimath object" do
        expect(asciimath.text).to eql("cos(2)")
      end
    end
  end

  describe ".to_latex, to_mathml, to_asciimath" do
    subject(:formula) { described_class.new(string).to_formula }

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-23-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-49-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-103-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-140-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-170-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-199-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-234-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-267-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-297-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-328-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-350-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-372-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-394-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-448-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-473-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-501-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-523-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-556-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-613-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-653-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-679-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-705-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-762-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-800-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-866-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-909-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-960-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1015-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1058-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1098-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1132-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1178-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1233-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1313-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1337-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1373-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1392-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1426-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1502-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1532-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1554-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1586-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1622-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1655-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1701-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1747-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1798-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-1858-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-2046-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-2202-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-2267-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-2591-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-2706-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-2808-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-2845-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3126-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3273-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3353-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3420-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3463-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3527-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3654-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3717-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3751-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3782-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3803-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3833-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3866-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3899-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-3932-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4015-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4049-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4070-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4093-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4116-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4138-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4168-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4200-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4226-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4248-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4267-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4286-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4310-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4333-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4357-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4381-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4417-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4439-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4592-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4682-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4755-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4825-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4942-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-4987-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5031-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5057-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5132-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5221-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5270-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5301-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5326-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5346-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5403-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5440-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5475-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5500-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5560-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5592-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5620-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5653-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5682-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5707-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5732-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5805-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5863-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-5991-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-6127-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-6229-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-6306-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-6349-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-6370-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-6391-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-6433-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-6479-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-6502-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-6529-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-6674-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-6814-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-6995-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7038-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7081-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7125-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7170-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7216-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7261-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7306-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7350-1"

    # testing MathML conversion's behaviour to add `unary_function_spacing: true` by default
    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7394-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7421-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7537-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7560-1"
  end

  describe ".to_omml" do
    subject(:formula) do
      described_class.new(string).to_formula.to_omml(display_style: display_style)
    end

    let(:display_style) { true }

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7593-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7619-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7723-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7816-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7863-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7920-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7971-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-7999-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-8025-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-8045-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-8109-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-8146-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-8242-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-8353-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-8519-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-8598-1"

    it_behaves_like "shared renderer fixture", "renderer-asciimath-asciimath-8638-1"
  end
end
