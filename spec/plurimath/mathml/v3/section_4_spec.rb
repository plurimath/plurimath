require "spec_helper"
require_relative "../../../support/shared_xml_parser_examples"

RSpec.describe Plurimath::Mathml::Parser do
  subject(:formula) { described_class.new(exp).parse }

  it_behaves_like "shared XML parser models", "mathml/tokens", %w[
    mathml-tokens-027
    mathml-tokens-028
    mathml-tokens-029
    mathml-tokens-030
    mathml-tokens-031
    mathml-tokens-032
    mathml-tokens-033
    mathml-tokens-034
    mathml-tokens-035
    mathml-tokens-036
    mathml-tokens-037
    mathml-tokens-038
    mathml-tokens-039
    mathml-tokens-040
    mathml-tokens-041
    mathml-tokens-042
    mathml-tokens-043
    mathml-tokens-044
    mathml-tokens-045
    mathml-tokens-046
    mathml-tokens-047
    mathml-tokens-048
    mathml-tokens-049
    mathml-tokens-050
    mathml-tokens-051
    mathml-tokens-052
    mathml-tokens-053
    mathml-tokens-054
    mathml-tokens-055
    mathml-tokens-056
    mathml-tokens-057
    mathml-tokens-058
    mathml-tokens-059
    mathml-tokens-060
    mathml-tokens-061
    mathml-tokens-062
    mathml-tokens-063
    mathml-tokens-064
    mathml-tokens-065
    mathml-tokens-066
    mathml-tokens-067
    mathml-tokens-068
    mathml-tokens-069
    mathml-tokens-070
    mathml-tokens-071
    mathml-tokens-072
    mathml-tokens-073
    mathml-tokens-074
    mathml-tokens-075
    mathml-tokens-076
    mathml-tokens-077
    mathml-tokens-078
    mathml-tokens-079
    mathml-tokens-080
    mathml-tokens-081
    mathml-tokens-082
    mathml-tokens-083
    mathml-tokens-084
    mathml-tokens-085
    mathml-tokens-086
    mathml-tokens-087
  ]
  it_behaves_like "shared XML parser models", "mathml/scripts", %w[
    mathml-scripts-021
    mathml-scripts-022
    mathml-scripts-023
    mathml-scripts-024
    mathml-scripts-025
    mathml-scripts-026
    mathml-scripts-027
    mathml-scripts-028
    mathml-scripts-029
    mathml-scripts-030
    mathml-scripts-031
    mathml-scripts-032
    mathml-scripts-033
    mathml-scripts-034
    mathml-scripts-035
    mathml-scripts-036
    mathml-scripts-037
    mathml-scripts-038
    mathml-scripts-039
    mathml-scripts-040
    mathml-scripts-041
    mathml-scripts-042
    mathml-scripts-043
    mathml-scripts-044
    mathml-scripts-045
    mathml-scripts-046
    mathml-scripts-047
    mathml-scripts-048
    mathml-scripts-049
  ]
  it_behaves_like "shared XML parser models", "mathml/fences", %w[
    mathml-fences-004
    mathml-fences-005
    mathml-fences-006
    mathml-fences-007
    mathml-fences-008
    mathml-fences-009
    mathml-fences-010
    mathml-fences-011
    mathml-fences-012
    mathml-fences-013
    mathml-fences-014
    mathml-fences-015
    mathml-fences-016
    mathml-fences-018
    mathml-fences-019
    mathml-fences-020
    mathml-fences-021
    mathml-fences-022
    mathml-fences-023
    mathml-fences-024
    mathml-fences-025
    mathml-fences-026
    mathml-fences-027
    mathml-fences-028
    mathml-fences-029
    mathml-fences-030
    mathml-fences-031
  ]
  it_behaves_like "shared XML parser models", "mathml/partial-render", %w[
    mathml-partial-020
    mathml-partial-024
    mathml-partial-025
    mathml-partial-026
  ]
  it_behaves_like "shared XML parser models", "mathml/over-under", %w[
    mathml-over-under-027
    mathml-over-under-028
    mathml-over-under-029
    mathml-over-under-030
    mathml-over-under-031
    mathml-over-under-032
    mathml-over-under-033
    mathml-over-under-034
  ]
  it_behaves_like "shared XML parser models", "mathml/roots", ["mathml-roots-004"]
  it_behaves_like "shared XML parser models", "mathml/fractions", ["mathml-fractions-013"]

  context "contains mathml v3 #4 example #81" do
    let(:exp) do
      <<~MATHML
        <math>
          <merror>
            <mtext>DivisionByZero:&#160;</mtext>
            <mfrac>
              <mi>x</mi>
              <mn>0</mn>
            </mfrac>
          </merror>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Merror.new(
                                                        Plurimath::Math::Formula.new([
                                                                                       Plurimath::Math::Function::Text.new("DivisionByZero:&#xa0;"),
                                                                                       Plurimath::Math::Function::Frac.new(
                                                                                         Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                         Plurimath::Math::Number.new("0"),
                                                                                       ),
                                                                                     ]),
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #96" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <mo>{</mo>
            <mtable>
              <mtr>
                <mtd>
                  <mrow>
                    <mo>&#x2212;<!--MINUS SIGN--></mo>
                    <mi>x</mi>
                  </mrow>
                </mtd>
                <mtd columnalign="left">
                  <mtext>&#xa0;<!--NO-BREAK SPACE--> if &#xa0;<!--NO-BREAK SPACE--></mtext>
                </mtd>
                <mtd>
                  <mrow>
                    <mi>x</mi>
                    <mo>&lt;</mo>
                    <mn>0</mn>
                  </mrow>
                </mtd>
              </mtr>
              <mtr>
                <mtd>
                  <mn>0</mn>
                </mtd>
                <mtd columnalign="left">
                  <mtext>&#xa0;<!--NO-BREAK SPACE--> if &#xa0;<!--NO-BREAK SPACE--></mtext>
                </mtd>
                <mtd>
                  <mrow>
                    <mi>x</mi>
                    <mo>=</mo>
                    <mn>0</mn>
                  </mrow>
                </mtd>
              </mtr>
              <mtr>
                <mtd>
                  <mi>x</mi>
                </mtd>
                <mtd columnalign="left">
                  <mtext>&#xa0;<!--NO-BREAK SPACE--> if &#xa0;<!--NO-BREAK SPACE--></mtext>
                </mtd>
                <mtd>
                  <mrow>
                    <mi>x</mi>
                    <mo>&gt;</mo>
                    <mn>0</mn>
                  </mrow>
                </mtd>
              </mtr>
            </mtable>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Formula.new([
                                                                                     Plurimath::Math::Symbols::Paren::Lcurly.new,
                                                                                     Plurimath::Math::Function::Table.new(
                                                                                       [
                                                                                         Plurimath::Math::Function::Tr.new([
                                                                                                                             Plurimath::Math::Function::Td.new([
                                                                                                                                                                 Plurimath::Math::Formula.new([
                                                                                                                                                                                                Plurimath::Math::Symbols::Minus.new,
                                                                                                                                                                                                Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                                                              ]),
                                                                                                                                                               ]),
                                                                                                                             Plurimath::Math::Function::Td.new([
                                                                                                                                                                 Plurimath::Math::Function::Text.new("&#xa0; if &#xa0;"),
                                                                                                                                                               ]),
                                                                                                                             Plurimath::Math::Function::Td.new([
                                                                                                                                                                 Plurimath::Math::Formula.new([
                                                                                                                                                                                                Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                                                                Plurimath::Math::Symbols::Less.new,
                                                                                                                                                                                                Plurimath::Math::Number.new("0"),
                                                                                                                                                                                              ]),
                                                                                                                                                               ]),
                                                                                                                           ]),
                                                                                         Plurimath::Math::Function::Tr.new([
                                                                                                                             Plurimath::Math::Function::Td.new([
                                                                                                                                                                 Plurimath::Math::Number.new("0"),
                                                                                                                                                               ]),
                                                                                                                             Plurimath::Math::Function::Td.new([
                                                                                                                                                                 Plurimath::Math::Function::Text.new("&#xa0; if &#xa0;"),
                                                                                                                                                               ]),
                                                                                                                             Plurimath::Math::Function::Td.new([
                                                                                                                                                                 Plurimath::Math::Formula.new([
                                                                                                                                                                                                Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                                                                Plurimath::Math::Symbols::Equal.new,
                                                                                                                                                                                                Plurimath::Math::Number.new("0"),
                                                                                                                                                                                              ]),
                                                                                                                                                               ]),
                                                                                                                           ]),
                                                                                         Plurimath::Math::Function::Tr.new([
                                                                                                                             Plurimath::Math::Function::Td.new([
                                                                                                                                                                 Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                               ]),
                                                                                                                             Plurimath::Math::Function::Td.new([
                                                                                                                                                                 Plurimath::Math::Function::Text.new("&#xa0; if &#xa0;"),
                                                                                                                                                               ]),
                                                                                                                             Plurimath::Math::Function::Td.new([
                                                                                                                                                                 Plurimath::Math::Formula.new([
                                                                                                                                                                                                Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                                                                Plurimath::Math::Symbols::Greater.new,
                                                                                                                                                                                                Plurimath::Math::Number.new("0"),
                                                                                                                                                                                              ]),
                                                                                                                                                               ]),
                                                                                                                           ]),
                                                                                       ],
                                                                                     ),
                                                                                   ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #113" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <munderover>
              <mo>&#x22C0;<!--N-ARY LOGICAL AND--></mo>
              <mrow>
                <mi>i</mi>
                <mo>=</mo>
                <mn>0</mn>
              </mrow>
              <mi>n</mi>
            </munderover>
            <mrow>
              <mo>(</mo>
              <msub>
                <mi>a</mi>
                <mi>i</mi>
              </msub>
              <mo>&gt;</mo>
              <mn>0</mn>
              <mo>)</mo>
            </mrow>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Nary.new(
                                                        Plurimath::Math::Symbols::Bigwedge.new,
                                                        Plurimath::Math::Formula.new([
                                                                                       Plurimath::Math::Symbols::Symbol.new("i"),
                                                                                       Plurimath::Math::Symbols::Equal.new,
                                                                                       Plurimath::Math::Number.new("0"),
                                                                                     ]),
                                                        Plurimath::Math::Symbols::Symbol.new("n"),
                                                        Plurimath::Math::Function::Fenced.new(
                                                          Plurimath::Math::Symbols::Paren::Lround.new,
                                                          [
                                                            Plurimath::Math::Function::Base.new(
                                                              Plurimath::Math::Symbols::Symbol.new("a"),
                                                              Plurimath::Math::Symbols::Symbol.new("i"),
                                                            ),
                                                            Plurimath::Math::Symbols::Greater.new,
                                                            Plurimath::Math::Number.new("0"),
                                                          ],
                                                          Plurimath::Math::Symbols::Paren::Rround.new,
                                                        ),
                                                        { type: "undOvr" },
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #122" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <mo>&#x2203;<!--THERE EXISTS--></mo>
            <mi>x</mi>
            <mo>.</mo>
            <mfenced separators="">
              <mrow>
                <mi>x</mi>
                <mo>&#x2208;<!--ELEMENT OF--></mo>
                <mi mathvariant="double-struck">Z</mi>
              </mrow>
              <mo>&#x2227;<!--LOGICAL AND--></mo>
              <mrow>
                <mrow>
                  <mi>f</mi>
                  <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
                  <mfenced>
                    <mi>x</mi>
                  </mfenced>
                </mrow>
                <mo>=</mo>
                <mn>0</mn>
              </mrow>
            </mfenced>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Formula.new([
                                                                                     Plurimath::Math::Symbols::Ee.new,
                                                                                     Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                     Plurimath::Math::Symbols::Period.new,
                                                                                     Plurimath::Math::Function::Fenced.new(
                                                                                       Plurimath::Math::Symbols::Paren::Lround.new,
                                                                                       [
                                                                                         Plurimath::Math::Formula.new([
                                                                                                                        Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                        Plurimath::Math::Symbols::In.new,
                                                                                                                        Plurimath::Math::Function::FontStyle::DoubleStruck.new(
                                                                                                                          Plurimath::Math::Symbols::Symbol.new("Z"),
                                                                                                                          "double-struck",
                                                                                                                        ),
                                                                                                                      ]),
                                                                                         Plurimath::Math::Symbols::Land.new,
                                                                                         Plurimath::Math::Formula.new([
                                                                                                                        Plurimath::Math::Formula.new([
                                                                                                                                                       Plurimath::Math::Symbols::Symbol.new("f"),
                                                                                                                                                       Plurimath::Math::Symbols::Funcapply.new,
                                                                                                                                                       Plurimath::Math::Function::Fenced.new(
                                                                                                                                                         Plurimath::Math::Symbols::Paren::Lround.new,
                                                                                                                                                         [
                                                                                                                                                           Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                         ],
                                                                                                                                                         Plurimath::Math::Symbols::Paren::Rround.new,
                                                                                                                                                       ),
                                                                                                                                                     ]),
                                                                                                                        Plurimath::Math::Symbols::Equal.new,
                                                                                                                        Plurimath::Math::Number.new("0"),
                                                                                                                      ]),
                                                                                       ],
                                                                                       Plurimath::Math::Symbols::Paren::Rround.new,
                                                                                       { separators: "" },
                                                                                     ),
                                                                                   ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #153" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <mi>div</mi>
            <mo>⁡<!--FUNCTION APPLICATION--></mo>
            <mo>(</mo>
            <mtable>
              <mtr>
                <mtd>
                  <mi>x</mi>
                  <mo>↦<!--RIGHTWARDS ARROW FROM BAR--></mo>
                  <mrow>
                    <mi>x</mi>
                    <mo>+</mo>
                    <mi>y</mi>
                  </mrow>
                </mtd>
              </mtr>
              <mtr>
                <mtd>
                  <mi>y</mi>
                  <mo>↦<!--RIGHTWARDS ARROW FROM BAR--></mo>
                  <mrow>
                    <mi>x</mi>
                    <mo>+</mo>
                    <mi>z</mi>
                  </mrow>
                </mtd>
              </mtr>
              <mtr>
                <mtd>
                  <mi>z</mi>
                  <mo>↦<!--RIGHTWARDS ARROW FROM BAR--></mo>
                  <mrow>
                    <mi>z</mi>
                    <mo>+</mo>
                    <mi>y</mi>
                  </mrow>
                </mtd>
              </mtr>
            </mtable>
            <mo>)</mo>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Formula.new([
                                                                                     Plurimath::Math::Symbols::Symbol.new("div"),
                                                                                     Plurimath::Math::Symbols::Funcapply.new,
                                                                                     Plurimath::Math::Symbols::Paren::Lround.new,
                                                                                     Plurimath::Math::Function::Table.new(
                                                                                       [
                                                                                         Plurimath::Math::Function::Tr.new([
                                                                                                                             Plurimath::Math::Function::Td.new([
                                                                                                                                                                 Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                                 Plurimath::Math::Symbols::Mapsto.new,
                                                                                                                                                                 Plurimath::Math::Formula.new([
                                                                                                                                                                                                Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                                                                Plurimath::Math::Symbols::Plus.new,
                                                                                                                                                                                                Plurimath::Math::Symbols::Symbol.new("y"),
                                                                                                                                                                                              ]),
                                                                                                                                                               ]),
                                                                                                                           ]),
                                                                                         Plurimath::Math::Function::Tr.new([
                                                                                                                             Plurimath::Math::Function::Td.new([
                                                                                                                                                                 Plurimath::Math::Symbols::Symbol.new("y"),
                                                                                                                                                                 Plurimath::Math::Symbols::Mapsto.new,
                                                                                                                                                                 Plurimath::Math::Formula.new([
                                                                                                                                                                                                Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                                                                Plurimath::Math::Symbols::Plus.new,
                                                                                                                                                                                                Plurimath::Math::Symbols::Symbol.new("z"),
                                                                                                                                                                                              ]),
                                                                                                                                                               ]),
                                                                                                                           ]),
                                                                                         Plurimath::Math::Function::Tr.new([
                                                                                                                             Plurimath::Math::Function::Td.new([
                                                                                                                                                                 Plurimath::Math::Symbols::Symbol.new("z"),
                                                                                                                                                                 Plurimath::Math::Symbols::Mapsto.new,
                                                                                                                                                                 Plurimath::Math::Formula.new([
                                                                                                                                                                                                Plurimath::Math::Symbols::Symbol.new("z"),
                                                                                                                                                                                                Plurimath::Math::Symbols::Plus.new,
                                                                                                                                                                                                Plurimath::Math::Symbols::Symbol.new("y"),
                                                                                                                                                                                              ]),
                                                                                                                                                               ]),
                                                                                                                           ]),
                                                                                       ],
                                                                                       nil,
                                                                                       nil,
                                                                                     ),
                                                                                     Plurimath::Math::Symbols::Paren::Rround.new,
                                                                                   ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #168" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <munder>
              <mo>&#x22c3;<!--N-ARY UNION--></mo>
              <mi>L</mi>
            </munder>
            <mi>S</mi>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Nary.new(
                                                        Plurimath::Math::Symbols::Duni.new,
                                                        Plurimath::Math::Symbols::Symbol.new("L"),
                                                        nil,
                                                        Plurimath::Math::Symbols::Symbol.new("S"),
                                                        { type: "undOvr" },
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #170" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <munder>
              <mo>&#x22c2;<!--N-ARY INTERSECTION--></mo>
              <mi>L</mi>
            </munder>
            <mi>S</mi>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Nary.new(
                                                        Plurimath::Math::Symbols::Dint.new,
                                                        Plurimath::Math::Symbols::Symbol.new("L"),
                                                        nil,
                                                        Plurimath::Math::Symbols::Symbol.new("S"),
                                                        { type: "undOvr" },
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #4 example #188" do
    let(:exp) do
      <<~MATHML
        <math>
          <mfenced>
            <mtable>
              <mtr>
                <mtd>
                  <mi>x</mi>
                </mtd>
              </mtr>
              <mtr>
                <mtd>
                  <mi>y</mi>
                </mtd>
              </mtr>
            </mtable>
          </mfenced>
          <mo>&#x2192;<!--RIGHTWARDS ARROW--></mo>
          <mfenced>
            <mtable>
              <mtr>
                <mtd>
                  <mi>f</mi>
                  <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
                  <mfenced>
                    <mi>x</mi>
                    <mi>y</mi>
                  </mfenced>
                </mtd>
              </mtr>
              <mtr>
                <mtd>
                  <mi>g</mi>
                  <mo>&#x2061;<!--FUNCTION APPLICATION--></mo>
                  <mfenced>
                    <mi>x</mi>
                    <mi>y</mi>
                  </mfenced>
                </mtd>
              </mtr>
            </mtable>
          </mfenced>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Fenced.new(
                                                        Plurimath::Math::Symbols::Paren::Lround.new,
                                                        [
                                                          Plurimath::Math::Function::Table.new(
                                                            [
                                                              Plurimath::Math::Function::Tr.new([
                                                                                                  Plurimath::Math::Function::Td.new([
                                                                                                                                      Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                    ]),
                                                                                                ]),
                                                              Plurimath::Math::Function::Tr.new([
                                                                                                  Plurimath::Math::Function::Td.new([
                                                                                                                                      Plurimath::Math::Symbols::Symbol.new("y"),
                                                                                                                                    ]),
                                                                                                ]),
                                                            ],
                                                            nil,
                                                            nil,
                                                          ),
                                                        ],
                                                        Plurimath::Math::Symbols::Paren::Rround.new,
                                                      ),
                                                      Plurimath::Math::Function::Vec.new,
                                                      Plurimath::Math::Function::Fenced.new(
                                                        Plurimath::Math::Symbols::Paren::Lround.new,
                                                        [
                                                          Plurimath::Math::Function::Table.new(
                                                            [
                                                              Plurimath::Math::Function::Tr.new([
                                                                                                  Plurimath::Math::Function::Td.new([
                                                                                                                                      Plurimath::Math::Symbols::Symbol.new("f"),
                                                                                                                                      Plurimath::Math::Symbols::Funcapply.new,
                                                                                                                                      Plurimath::Math::Function::Fenced.new(
                                                                                                                                        Plurimath::Math::Symbols::Paren::Lround.new,
                                                                                                                                        [
                                                                                                                                          Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                          Plurimath::Math::Symbols::Symbol.new("y"),
                                                                                                                                        ],
                                                                                                                                        Plurimath::Math::Symbols::Paren::Rround.new,
                                                                                                                                      ),
                                                                                                                                    ]),
                                                                                                ]),
                                                              Plurimath::Math::Function::Tr.new([
                                                                                                  Plurimath::Math::Function::Td.new([
                                                                                                                                      Plurimath::Math::Symbols::Symbol.new("g"),
                                                                                                                                      Plurimath::Math::Symbols::Funcapply.new,
                                                                                                                                      Plurimath::Math::Function::Fenced.new(
                                                                                                                                        Plurimath::Math::Symbols::Paren::Lround.new,
                                                                                                                                        [
                                                                                                                                          Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                          Plurimath::Math::Symbols::Symbol.new("y"),
                                                                                                                                        ],
                                                                                                                                        Plurimath::Math::Symbols::Paren::Rround.new,
                                                                                                                                      ),
                                                                                                                                    ]),
                                                                                                ]),
                                                            ],
                                                            nil,
                                                            nil,
                                                          ),
                                                        ],
                                                        Plurimath::Math::Symbols::Paren::Rround.new,
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end
end
