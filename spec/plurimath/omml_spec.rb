require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Omml do
  describe ".initialize" do
    subject(:omml) { described_class.new(string) }

    context "contains simple OMML value" do
      let(:string) do
        "<m:oMathPara><m:oMath><m:r><m:t>dy</m:t></m:r></m:oMath></m:oMathPara>"
      end

      it "returns instance of Omml" do
        expect(omml).to be_a(described_class)
      end

      it "returns Mathml instance" do
        expect(omml.text).to eql(string)
      end
    end
  end

  describe ".to_latex, to_mathml, to_asciimath" do
    subject(:formula) { described_class.new(string).to_formula }

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-26-1"

    # Built here rather than through the memoized subject: the suite reruns
    # each example for Ox and Oga on the same instance, so a memoized formula
    # would be parsed once and an engine-specific regression would slip by.
    it_behaves_like "shared renderer fixture", "renderer-omml-omml-41-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-65-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-83-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-144-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-188-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-244-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-300-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-356-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-412-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-449-1"
    it_behaves_like "shared renderer fixture", "renderer-omml-omml-449-2"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-474-1"
    it_behaves_like "shared renderer fixture", "renderer-omml-omml-474-2"
    it_behaves_like "shared renderer fixture", "renderer-omml-omml-474-3"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-501-1"
    it_behaves_like "shared renderer fixture", "renderer-omml-omml-501-2"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-518-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-541-1"
    it_behaves_like "shared renderer fixture", "renderer-omml-omml-541-2"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-570-1"

    it_behaves_like "shared renderer fixture", "renderer-omml-omml-597-1"
  end

  describe ".to_omml" do
    it_behaves_like "shared renderer fixture", "renderer-omml-omml-625-1"
  end

  it_behaves_like "shared renderer fixture", "renderer-omml-operand-ubrace"
  it_behaves_like "shared renderer fixture", "renderer-omml-operand-obrace"
  it_behaves_like "shared renderer fixture", "renderer-omml-operand-vec"
  it_behaves_like "shared renderer fixture", "renderer-omml-operand-ddot"
  it_behaves_like "shared renderer fixture", "renderer-omml-operand-overleftrightarrow"
  it_behaves_like "shared renderer fixture", "renderer-omml-operand-tilde"
  it_behaves_like "shared renderer fixture", "renderer-omml-operand-dot"
  it_behaves_like "shared renderer fixture", "renderer-omml-operand-ul"
  it_behaves_like "shared renderer fixture", "renderer-omml-operand-hat"
  it_behaves_like "shared renderer fixture", "renderer-omml-compound-1"
  it_behaves_like "shared renderer fixture", "renderer-omml-compound-2"
  it_behaves_like "shared renderer fixture", "renderer-omml-compound-3"
end
