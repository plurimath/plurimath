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

  # msub, msup, mfrac and friends take a fixed number of arguments, so the
  # multiplier spacer must not be added next to a unit that is one of them.
  # It goes inside the unit's own mrow instead.
  describe "multiplier spacer under fixed-arity elements" do
    {
      '3 "unitsml(m)"^2' => "msup",
      'Delta_"unitsml(m)"' => "msub",
      'x_"unitsml(m)"^"unitsml(s)"' => "msubsup",
      '1/"unitsml(s)"' => "mfrac",
      'root(3)("unitsml(m)")' => "mroot",
    }.each do |input, element|
      it "keeps the #{element} arity for #{input}" do
        mathml = Plurimath::Math.parse(input, :asciimath)
          .to_mathml(unitsml: { xml: false, multiplier: :space })
        document = Nokogiri::XML(mathml)
        arity = element == "msubsup" ? 3 : 2
        scripts = document.xpath("//*[local-name()='#{element}']")
        spacers = document.xpath("//*[local-name()='mo'][@rspace='0.2778em']")

        expect(scripts.map { |node| node.element_children.size }).to all(eq(arity))
        expect(spacers).not_to be_empty
        expect(spacers.map { |node| node.parent.name }).to all(eq("mrow"))
      end
    end

    it "still adds the spacer as a sibling in a plain row" do
      mathml = Plurimath::Math.parse('9 "unitsml(kg)"', :asciimath)
        .to_mathml(unitsml: { xml: true, multiplier: :space })
      spacer = Nokogiri::XML(mathml)
        .at_xpath("//*[local-name()='mo'][@rspace='0.2778em']")

      expect(spacer.previous_element.name).to eq("mn")
    end
  end
end
