require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Formula do
  describe ".to_mathml(unitsml: {})" do
    let(:mathml) { described_class.new(exp).to_mathml(unitsml: unitsml) }

    it_behaves_like "shared renderer fixture", "formula-unitsml-7-1"

    it_behaves_like "shared renderer fixture", "formula-unitsml-67-1"

    it_behaves_like "shared renderer fixture", "formula-unitsml-168-1"

    # A composed unit inserts one multiplier spacer per separator, on top of
    # the leading spacer. Those inner spacers used to be emitted as
    # `<mi rspace="...">`, which no MathML 4 profile admits.
    # plurimath/plurimath#476
    # Scoped to the presentation tree: the embedded UnitsML `UnitSymbol`
    # carries its own MathML, whose spacers are the unitsml gem's output and
    # not what this example is about.
    it_behaves_like "shared renderer fixture", "formula-unitsml-spacers-identifiers"
    it_behaves_like "shared renderer fixture", "formula-unitsml-spacers-count"
  end
end
