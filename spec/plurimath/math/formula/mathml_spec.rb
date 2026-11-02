require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Formula do
  describe ".to_mathml" do
    subject(:formula) do
      exp.to_mathml(display_style: display_style, unary_function_spacing: false)
    end

    let(:display_style) { true }

    it_behaves_like "shared renderer fixture", "formula-mathml-11-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-33-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-61-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-89-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-119-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-145-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-171-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-207-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-243-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-263-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-283-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-303-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-361-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-389-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-415-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-441-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-475-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-503-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-529-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-557-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-597-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-643-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-690-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-714-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-764-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-805-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-846-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-872-1"

    it_behaves_like "shared renderer fixture", "formula-mathml-903-1"
  end
end
