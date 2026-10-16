require "spec_helper"

RSpec.describe Plurimath::Math::Formula do
  describe ".to_mathml(unitsml: {})" do
    let(:mathml) { described_class.new(exp).to_mathml(unitsml: unitsml) }

    context "contains mathml with unitsml semantics" do
      let(:unitsml) { { xml: true, multiplier: "X" } }
      let(:exp) do
        described_class.new([
                              Plurimath::Math::Number.new("9"),
                              Plurimath::Unitsml.new("C^3*A").to_formula,
                            ])
      end

      it "matches instance of Unitsml and input text" do
        expected_value = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mn>9</mn>
                <mo rspace="thickmathspace">&#x2062;</mo>
                <mrow xref="U_C3.A">
                  <msup>
                    <mstyle mathvariant="normal">
                      <mi>C</mi>
                    </mstyle>
                    <mn>3</mn>
                  </msup>
                  <mi>X</mi>
                  <mstyle mathvariant="normal">
                    <mi>A</mi>
                  </mstyle>
                  <Unit xmlns="https://schema.unitsml.org/unitsml/1.0" dimensionURL="#D_M3I4" id="U_C3.A">
                    <UnitSystem name="SI" type="SI_derived" lang="en"/>
                    <UnitName lang="en">C^3*A</UnitName>
                    <UnitSymbol type="HTML">C
                      <sup>3</sup>XA</UnitSymbol>
                    <UnitSymbol type="MathMl">
                      <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
                        <msup>
                          <mi mathvariant="normal">C</mi>
                          <mn>3</mn>
                        </msup>
                        <mo>X</mo>
                        <mi mathvariant="normal">A</mi>
                      </math>
                    </UnitSymbol>
                    <RootUnits>
                      <EnumeratedRootUnit unit="coulomb" powerNumerator="3"/>
                      <EnumeratedRootUnit unit="ampere"/>
                    </RootUnits>
                  </Unit>
                  <Dimension xmlns="https://schema.unitsml.org/unitsml/1.0" id="D_M3I4">
                    <Mass symbol="M" powerNumerator="3"/>
                    <ElectricCurrent symbol="I" powerNumerator="4"/>
                  </Dimension>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(mathml).to be_xml_equivalent_to(expected_value)
      end
    end

    context "contains mathml with unitsml semantics" do
      let(:unitsml) { { xml: true } }
      let(:exp) do
        described_class.new([
                              Plurimath::Math::Number.new("9"),
                              Plurimath::Unitsml.new("C^3*A").to_formula,
                              Plurimath::Math::Number.new("9"),
                              Plurimath::Unitsml.new("C^2*m").to_formula,
                            ])
      end

      it "matches instance of Unitsml and input text" do
        expected_value = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mn>9</mn>
                <mo rspace="thickmathspace">&#x2062;</mo>
                <mrow xref="U_C3.A">
                  <msup>
                    <mstyle mathvariant="normal">
                      <mi>C</mi>
                    </mstyle>
                    <mn>3</mn>
                  </msup>
                  <mo>&#x22c5;</mo>
                  <mstyle mathvariant="normal">
                    <mi>A</mi>
                  </mstyle>
                  <Unit xmlns="https://schema.unitsml.org/unitsml/1.0" dimensionURL="#D_M3I4" id="U_C3.A">
                    <UnitSystem name="SI" type="SI_derived" lang="en"/>
                    <UnitName lang="en">C^3*A</UnitName>
                    <UnitSymbol type="HTML">C
                      <sup>3</sup>⋅A</UnitSymbol>
                    <UnitSymbol type="MathMl">
                      <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
                        <msup>
                          <mi mathvariant="normal">C</mi>
                          <mn>3</mn>
                        </msup>
                        <mo>⋅</mo>
                        <mi mathvariant="normal">A</mi>
                      </math>
                    </UnitSymbol>
                    <RootUnits>
                      <EnumeratedRootUnit unit="coulomb" powerNumerator="3"/>
                      <EnumeratedRootUnit unit="ampere"/>
                    </RootUnits>
                  </Unit>
                  <Dimension xmlns="https://schema.unitsml.org/unitsml/1.0" id="D_M3I4">
                    <Mass symbol="M" powerNumerator="3"/>
                    <ElectricCurrent symbol="I" powerNumerator="4"/>
                  </Dimension>
                </mrow>
                <mn>9</mn>
                <mo rspace="thickmathspace">&#x2062;</mo>
                <mrow xref="U_C2.m">
                  <msup>
                    <mstyle mathvariant="normal">
                      <mi>C</mi>
                    </mstyle>
                    <mn>2</mn>
                  </msup>
                  <mo>&#x22c5;</mo>
                  <mstyle mathvariant="normal">
                    <mi>m</mi>
                  </mstyle>
                  <Unit xmlns="https://schema.unitsml.org/unitsml/1.0" dimensionURL="#D_LM2I2" id="U_C2.m">
                    <UnitSystem name="SI" type="SI_derived" lang="en"/>
                    <UnitName lang="en">C^2*m</UnitName>
                    <UnitSymbol type="HTML">C
                      <sup>2</sup>⋅m</UnitSymbol>
                    <UnitSymbol type="MathMl">
                      <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
                        <msup>
                          <mi mathvariant="normal">C</mi>
                          <mn>2</mn>
                        </msup>
                        <mo>⋅</mo>
                        <mi mathvariant="normal">m</mi>
                      </math>
                    </UnitSymbol>
                    <RootUnits>
                      <EnumeratedRootUnit unit="coulomb" powerNumerator="2"/>
                      <EnumeratedRootUnit unit="metre"/>
                    </RootUnits>
                  </Unit>
                  <Dimension xmlns="https://schema.unitsml.org/unitsml/1.0" id="D_LM2I2">
                    <Length symbol="L" powerNumerator="1"/>
                    <Mass symbol="M" powerNumerator="2"/>
                    <ElectricCurrent symbol="I" powerNumerator="2"/>
                  </Dimension>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(mathml).to be_xml_equivalent_to(expected_value)
      end
    end

    context "contains mathml without unitsml semantics" do
      let(:unitsml) { { xml: false, multiplier: :space } }
      let(:exp) do
        described_class.new([
                              Plurimath::Math::Number.new("9"),
                              Plurimath::Unitsml.new("C^3*A").to_formula,
                            ])
      end

      it "matches instance of Unitsml and input text" do
        expected_value = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mn>9</mn>
                <mo rspace="thickmathspace">&#x2062;</mo>
                <mrow>
                  <msup>
                    <mstyle mathvariant="normal">
                      <mi>C</mi>
                    </mstyle>
                    <mn>3</mn>
                  </msup>
                  <mo rspace="thickmathspace">&#x2062;</mo>
                  <mstyle mathvariant="normal">
                    <mi>A</mi>
                  </mstyle>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(mathml).to eql(expected_value)
      end
    end

    # A composed unit inserts one multiplier spacer per separator, on top of
    # the leading spacer. Those inner spacers used to be emitted as
    # `<mi rspace="...">`, which no MathML 4 profile admits.
    # plurimath/plurimath#476
    context "contains a composed unit whose spacers must stay operators" do
      let(:unitsml) { { xml: true, multiplier: :space } }
      let(:exp) do
        described_class.new([
                              Plurimath::Math::Number.new("9"),
                              Plurimath::Unitsml.new("kg*m/s^2").to_formula,
                            ])
      end

      # Scoped to the presentation tree: the embedded UnitsML `UnitSymbol`
      # carries its own MathML, whose spacers are the unitsml gem's output and
      # not what this example is about.
      let(:presentation) do
        doc = Nokogiri::XML(mathml)
        doc.xpath("//*[namespace-uri()='https://schema.unitsml.org/unitsml/1.0']")
          .each(&:remove)
        doc
      end

      it "emits no identifier carrying an rspace" do
        expect(presentation.xpath("//*[local-name()='mi'][@rspace]")).to be_empty
      end

      it "emits an operator spacer for the leading and both separators" do
        spacers = presentation
          .xpath("//*[local-name()='mo'][@rspace='thickmathspace']")
        expect(spacers.size).to eq(3)
        expect(spacers.map(&:text).uniq).to eq(["⁢"])
      end
    end
  end
end
