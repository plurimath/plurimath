# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Symbol do
  def unit_product(operator)
    Plurimath::Math.parse(<<~XML, :mathml)
      <math xmlns="http://www.w3.org/1998/Math/MathML">
        <mi mathvariant="normal">kg</mi>#{operator}
        <msup><mi mathvariant="normal">kmol</mi><mn>-1</mn></msup>
      </math>
    XML
  end

  it "maps the MathML 4 thick space length to Office Math thick spacing" do
    formula = unit_product('<mo rspace="0.2778em">&#x2062;</mo>')
    document = Nokogiri::XML(formula.to_omml)
    texts = document.xpath("//*[local-name()='t']").map(&:text)

    expect(texts).to eq(["kg", "\u2004", "kmol", "-1"])
    expect(formula.to_mathml).to include('rspace="0.2778em"')
  end

  it "still reads the MathML 3 named thick space from input" do
    formula = unit_product('<mo rspace="thickmathspace">&#x2062;</mo>')
    document = Nokogiri::XML(formula.to_omml)
    texts = document.xpath("//*[local-name()='t']").map(&:text)

    expect(texts).to eq(["kg", "\u2004", "kmol", "-1"])
    expect(document.xpath("//*[local-name()='sSup']").size).to eq(1)
    expect(formula.to_mathml).to include('rspace="thickmathspace"')
  end

  it "keeps ordinary invisible multiplication invisible" do
    formula = unit_product("<mo>&#x2062;</mo>")
    texts = Nokogiri::XML(formula.to_omml).xpath("//*[local-name()='t']").map(&:text)

    expect(texts).to eq(["kg", "kmol", "-1"])
  end

  it "does not introduce spacing for explicit zero rspace" do
    formula = unit_product('<mo rspace="0em">&#x2062;</mo>')
    texts = Nokogiri::XML(formula.to_omml).xpath("//*[local-name()='t']").map(&:text)

    expect(texts).to eq(["kg", "kmol", "-1"])
  end
end
