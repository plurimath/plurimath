require 'spec_helper'

RSpec.describe Plurimath::Math::Formula do
  describe ".to_mathml(unitsml_xml: boolean)" do
    let(:mathml) { described_class.new(exp).to_mathml(unitsml_xml: unitsml_xml) }

    context "contains mathml with unitsml semantics" do
      let(:unitsml_xml) { true }
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("9"),
          Plurimath::Unitsml.new("C^3*A").to_formula,
        ])
      end

      it 'matches instance of Unitsml and input text' do
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
                  <Unit xmlns="https://schema.unitsml.org/unitsml/1.0" id="U_C3.A" dimensionURL="#D_M3I4">
                    <UnitSystem name="SI" type="SI_derived" lang="en-US"/>
                    <UnitName lang="en">C^3*A</UnitName>
                    <UnitSymbol type="HTML">C
                      <sup>3</sup>⋅A</UnitSymbol>
                    <UnitSymbol type="MathMl">
                      <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
                        <msup>
                          <mrow>
                            <mi mathvariant="normal">C</mi>
                          </mrow>
                          <mrow>
                            <mn>3</mn>
                          </mrow>
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
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(mathml).to eql(expected_value)
      end
    end
    context "contains mathml with unitsml semantics" do
      let(:unitsml_xml) { true }
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("9"),
          Plurimath::Unitsml.new("C^3*A").to_formula,
          Plurimath::Math::Number.new("9"),
          Plurimath::Unitsml.new("C^2*m").to_formula,
        ])
      end

      it 'matches instance of Unitsml and input text' do
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
                  <Unit xmlns="https://schema.unitsml.org/unitsml/1.0" id="U_C3.A" dimensionURL="#D_M3I4">
                    <UnitSystem name="SI" type="SI_derived" lang="en-US"/>
                    <UnitName lang="en">C^3*A</UnitName>
                    <UnitSymbol type="HTML">C
                      <sup>3</sup>⋅A</UnitSymbol>
                    <UnitSymbol type="MathMl">
                      <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
                        <msup>
                          <mrow>
                            <mi mathvariant="normal">C</mi>
                          </mrow>
                          <mrow>
                            <mn>3</mn>
                          </mrow>
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
                  <Unit xmlns="https://schema.unitsml.org/unitsml/1.0" id="U_C2.m" dimensionURL="#D_LM2I2">
                    <UnitSystem name="SI" type="SI_derived" lang="en-US"/>
                    <UnitName lang="en">C^2*m</UnitName>
                    <UnitSymbol type="HTML">C
                      <sup>2</sup>⋅m</UnitSymbol>
                    <UnitSymbol type="MathMl">
                      <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
                        <msup>
                          <mrow>
                            <mi mathvariant="normal">C</mi>
                          </mrow>
                          <mrow>
                            <mn>2</mn>
                          </mrow>
                        </msup>
                        <mo>⋅</mo>
                        <mi mathvariant="normal">m</mi>
                      </math>
                    </UnitSymbol>
                    <RootUnits>
                      <EnumeratedRootUnit unit="coulomb" powerNumerator="2"/>
                      <EnumeratedRootUnit unit="meter"/>
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
        expect(mathml).to eql(expected_value)
      end
    end

    context "contains mathml without unitsml semantics" do
      let(:unitsml_xml) { false }
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("9"),
          Plurimath::Unitsml.new("C^3*A").to_formula,
        ])
      end

      it 'matches instance of Unitsml and input text' do
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
                  <mo>&#x22c5;</mo>
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
  end
end
