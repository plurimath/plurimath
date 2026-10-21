require "spec_helper"
require_relative "../../../support/shared_xml_parser_examples"

RSpec.describe Plurimath::Mathml::Parser do
  subject(:formula) { described_class.new(exp).parse }

  it_behaves_like "shared XML parser models", "mathml/tokens", %w[
    mathml-tokens-014
    mathml-tokens-015
    mathml-tokens-016
    mathml-tokens-017
    mathml-tokens-018
    mathml-tokens-019
    mathml-tokens-020
    mathml-tokens-021
    mathml-tokens-022
    mathml-tokens-023
    mathml-tokens-024
    mathml-tokens-025
    mathml-tokens-026
  ]
  it_behaves_like "shared XML parser models", "mathml/fractions", %w[
    mathml-fractions-002
    mathml-fractions-003
    mathml-fractions-004
    mathml-fractions-005
    mathml-fractions-007
    mathml-fractions-008
    mathml-fractions-009
    mathml-fractions-010
    mathml-fractions-011
  ]
  it_behaves_like "shared XML parser models", "mathml/scripts", %w[
    mathml-scripts-013
    mathml-scripts-015
    mathml-scripts-016
    mathml-scripts-018
    mathml-scripts-019
    mathml-scripts-020
  ]
  it_behaves_like "shared XML parser models", "mathml/over-under", ["mathml-over-under-021"]
  it_behaves_like "shared XML parser models", "mathml/partial-render", %w[
    mathml-partial-009
    mathml-partial-010
    mathml-partial-011
    mathml-partial-012
    mathml-partial-013
    mathml-partial-014
    mathml-partial-016
    mathml-partial-017
    mathml-partial-018
    mathml-partial-019
  ]
  it_behaves_like "shared XML parser models", "mathml/fences", %w[
    mathml-fences-001
    mathml-fences-002
    mathml-fences-003
  ]
  it_behaves_like "shared XML parser models", "mathml/enclose", ["mathml-enclose-001"]
  it_behaves_like "shared XML parser models", "mathml/elementary-math", %w[
    mathml-elementary-math-001
    mathml-elementary-math-002
    mathml-elementary-math-003
    mathml-elementary-math-004
    mathml-elementary-math-005
    mathml-elementary-math-006
    mathml-elementary-math-007
    mathml-elementary-math-008
    mathml-elementary-math-009
    mathml-elementary-math-010
  ]

  context "contains mathml v3 #3 example #20" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <mi> x </mi>
            <munder>
              <mo> &#x2192;<!--RIGHTWARDS ARROW--> </mo>
              <mtext> maps to </mtext>
            </munder>
            <mi> y </mi>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Formula.new([
                                                                                     Plurimath::Math::Symbols::Symbol.new(" x "),
                                                                                     Plurimath::Math::Function::Vec.new(
                                                                                       Plurimath::Math::Function::Text.new(" maps to "),
                                                                                     ),
                                                                                     Plurimath::Math::Symbols::Symbol.new(" y "),
                                                                                   ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #21" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <mrow>  <mi>f</mi> <mo>&#x2061;<!--FUNCTION APPLICATION--></mo> <mo>(</mo> <mi>x</mi> <mo>)</mo>  </mrow>

            <mo id='eq1-equals'>=</mo>
            <mrow>
             <msup>
              <mrow> <mo>(</mo> <mrow> <mi>x</mi> <mo>+</mo> <mn>1</mn> </mrow> <mo>)</mo> </mrow>
              <mn>4</mn>
             </msup>
             <mo linebreak='newline' linebreakstyle='before'
                               indentalign='id' indenttarget='eq1-equals'>=</mo>
             <mrow>
              <msup> <mi>x</mi> <mn>4</mn> </msup>
              <mo id='eq1-plus'>+</mo>
              <mrow>  <mn>4</mn> <mo>&#x2062;<!--INVISIBLE TIMES--></mo> <msup> <mi>x</mi> <mn>3</mn> </msup>  </mrow>
              <mo>+</mo>
              <mrow>  <mn>6</mn> <mo>&#x2062;<!--INVISIBLE TIMES--></mo> <msup> <mi>x</mi> <mn>2</mn> </msup>  </mrow>

              <mo linebreak='newline' linebreakstyle='before'
                                indentalignlast='id' indenttarget='eq1-plus'>+</mo>
              <mrow>  <mn>4</mn> <mo>&#x2062;<!--INVISIBLE TIMES--></mo> <mi>x</mi>  </mrow>
              <mo>+</mo>
              <mn>1</mn>
             </mrow>
            </mrow>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Formula.new([
                                                                                     Plurimath::Math::Formula.new([
                                                                                                                    Plurimath::Math::Symbols::Symbol.new("f"),
                                                                                                                    Plurimath::Math::Symbols::Funcapply.new,
                                                                                                                    Plurimath::Math::Symbols::Paren::Lround.new,
                                                                                                                    Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                    Plurimath::Math::Symbols::Paren::Rround.new,
                                                                                                                  ]),
                                                                                     Plurimath::Math::Symbols::Equal.new,
                                                                                     Plurimath::Math::Formula.new([
                                                                                                                    Plurimath::Math::Function::Power.new(
                                                                                                                      Plurimath::Math::Function::Fenced.new(
                                                                                                                        Plurimath::Math::Symbols::Paren::Lround.new,
                                                                                                                        [
                                                                                                                          Plurimath::Math::Formula.new([
                                                                                                                                                         Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                         Plurimath::Math::Symbols::Plus.new,
                                                                                                                                                         Plurimath::Math::Number.new("1"),
                                                                                                                                                       ]),
                                                                                                                        ],
                                                                                                                        Plurimath::Math::Symbols::Paren::Rround.new,
                                                                                                                      ),
                                                                                                                      Plurimath::Math::Number.new("4"),
                                                                                                                    ),
                                                                                                                    Plurimath::Math::Function::Linebreak.new(
                                                                                                                      Plurimath::Math::Symbols::Equal.new,
                                                                                                                      {
                                                                                                                        linebreak: "newline", linebreakstyle: "before"
                                                                                                                      },
                                                                                                                    ),
                                                                                                                    Plurimath::Math::Formula.new([
                                                                                                                                                   Plurimath::Math::Function::Power.new(
                                                                                                                                                     Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                     Plurimath::Math::Number.new("4"),
                                                                                                                                                   ),
                                                                                                                                                   Plurimath::Math::Symbols::Plus.new,
                                                                                                                                                   Plurimath::Math::Formula.new([
                                                                                                                                                                                  Plurimath::Math::Number.new("4"),
                                                                                                                                                                                  Plurimath::Math::Symbols::Symbol.new("&#x2062;"),
                                                                                                                                                                                  Plurimath::Math::Function::Power.new(
                                                                                                                                                                                    Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                                                    Plurimath::Math::Number.new("3"),
                                                                                                                                                                                  ),
                                                                                                                                                                                ]),
                                                                                                                                                   Plurimath::Math::Symbols::Plus.new,
                                                                                                                                                   Plurimath::Math::Formula.new([
                                                                                                                                                                                  Plurimath::Math::Number.new("6"),
                                                                                                                                                                                  Plurimath::Math::Symbols::Symbol.new("&#x2062;"),
                                                                                                                                                                                  Plurimath::Math::Function::Power.new(
                                                                                                                                                                                    Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                                                    Plurimath::Math::Number.new("2"),
                                                                                                                                                                                  ),
                                                                                                                                                                                ]),
                                                                                                                                                   Plurimath::Math::Function::Linebreak.new(
                                                                                                                                                     Plurimath::Math::Symbols::Plus.new,
                                                                                                                                                     {
                                                                                                                                                       linebreak: "newline", linebreakstyle: "before"
                                                                                                                                                     },
                                                                                                                                                   ),
                                                                                                                                                   Plurimath::Math::Formula.new([
                                                                                                                                                                                  Plurimath::Math::Number.new("4"),
                                                                                                                                                                                  Plurimath::Math::Symbols::Symbol.new("&#x2062;"),
                                                                                                                                                                                  Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                                                                                                                ]),
                                                                                                                                                   Plurimath::Math::Symbols::Plus.new,
                                                                                                                                                   Plurimath::Math::Number.new("1"),
                                                                                                                                                 ]),
                                                                                                                  ]),
                                                                                   ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #22" do
    let(:exp) do
      <<~MATHML
        <math>
          <mtext> Theorem 1: </mtext>
          <mtext> &#x2009;<!--THIN SPACE--> </mtext>
          <mtext> &#x205F;&#x200A;<!--space of width 5/18 em-->&#x205F;&#x200A;<!--space of width 5/18 em--> </mtext>
          <mtext> /* a comment */ </mtext>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Text.new(" Theorem 1: "),
                                                      Plurimath::Math::Function::Text.new(" &#x2009; "),
                                                      Plurimath::Math::Function::Text.new(" &#x205f;&#x200a;&#x205f;&#x200a; "),
                                                      Plurimath::Math::Function::Text.new(" /* a comment */ "),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #24" do
    let(:exp) do
      <<~MATHML
        <math>
          <mspace height="3ex" depth="2ex"/>

          <mrow>
            <mi>a</mi>
            <mo id="firstop">+</mo>
            <mi>b</mi>
            <mspace linebreak="newline" indentalign="id" indenttarget="firstop"/>
            <mo>+</mo>
            <mi>c</mi>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Formula.new([
                                                                                     Plurimath::Math::Symbols::Symbol.new("a"),
                                                                                     Plurimath::Math::Symbols::Plus.new,
                                                                                     Plurimath::Math::Symbols::Symbol.new("b"),
                                                                                     Plurimath::Math::Function::Linebreak.new(
                                                                                       nil,
                                                                                       { linebreak: "newline" },
                                                                                     ),
                                                                                     Plurimath::Math::Symbols::Plus.new,
                                                                                     Plurimath::Math::Symbols::Symbol.new("c"),
                                                                                   ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #29" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
             <mo> ( </mo>
             <mfrac linethickness="0">
                <mi> a </mi>
                <mi> b </mi>
             </mfrac>
             <mo> ) </mo>
          </mrow>
          <mfrac linethickness="200%">
             <mfrac>
                <mi> a </mi>
                <mi> b </mi>
             </mfrac>
             <mfrac>
                <mi> c </mi>
                <mi> d </mi>
             </mfrac>
          </mfrac>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Fenced.new(
                                                        Plurimath::Math::Symbols::Paren::Lround.new,
                                                        [
                                                          Plurimath::Math::Function::Frac.new(
                                                            Plurimath::Math::Symbols::Symbol.new(" a "),
                                                            Plurimath::Math::Symbols::Symbol.new(" b "),
                                                            { linethickness: "0" },
                                                          ),
                                                        ],
                                                        Plurimath::Math::Symbols::Paren::Rround.new,
                                                      ),
                                                      Plurimath::Math::Function::Frac.new(
                                                        Plurimath::Math::Function::Frac.new(
                                                          Plurimath::Math::Symbols::Symbol.new(" a "),
                                                          Plurimath::Math::Symbols::Symbol.new(" b "),
                                                        ),
                                                        Plurimath::Math::Function::Frac.new(
                                                          Plurimath::Math::Symbols::Symbol.new(" c "),
                                                          Plurimath::Math::Symbols::Symbol.new(" d "),
                                                        ),
                                                        { linethickness: "200%" },
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #30" do
    let(:exp) do
      <<~MATHML
        <math>
          <mfrac>
            <mn> 1 </mn>
            <mrow>
              <msup>
                <mi> x </mi>
                <mn> 3 </mn>
              </msup>
              <mo> + </mo>
              <mfrac>
                <mi> x </mi>
                <mn> 3 </mn>
              </mfrac>
            </mrow>
          </mfrac>
          <mo> = </mo>
          <mfrac bevelled="true">
            <mn> 1 </mn>
            <mrow>
              <msup>
                <mi> x </mi>
                <mn> 3 </mn>
              </msup>
              <mo> + </mo>
              <mfrac>
                <mi> x </mi>
                <mn> 3 </mn>
              </mfrac>
            </mrow>
          </mfrac>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Frac.new(
                                                        Plurimath::Math::Number.new(" 1 "),
                                                        Plurimath::Math::Formula.new([
                                                                                       Plurimath::Math::Function::Power.new(
                                                                                         Plurimath::Math::Symbols::Symbol.new(" x "),
                                                                                         Plurimath::Math::Number.new(" 3 "),
                                                                                       ),
                                                                                       Plurimath::Math::Symbols::Plus.new,
                                                                                       Plurimath::Math::Function::Frac.new(
                                                                                         Plurimath::Math::Symbols::Symbol.new(" x "),
                                                                                         Plurimath::Math::Number.new(" 3 "),
                                                                                       ),
                                                                                     ]),
                                                      ),
                                                      Plurimath::Math::Symbols::Equal.new,
                                                      Plurimath::Math::Function::Frac.new(
                                                        Plurimath::Math::Number.new(" 1 "),
                                                        Plurimath::Math::Formula.new([
                                                                                       Plurimath::Math::Function::Power.new(
                                                                                         Plurimath::Math::Symbols::Symbol.new(" x "),
                                                                                         Plurimath::Math::Number.new(" 3 "),
                                                                                       ),
                                                                                       Plurimath::Math::Symbols::Plus.new,
                                                                                       Plurimath::Math::Function::Frac.new(
                                                                                         Plurimath::Math::Symbols::Symbol.new(" x "),
                                                                                         Plurimath::Math::Number.new(" 3 "),
                                                                                       ),
                                                                                     ]),
                                                        { bevelled: "true" },
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #35" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <mi>x</mi>
            <mpadded lspace="0.2em" voffset="0.3ex">
              <mi>y</mi>
            </mpadded>
            <mi>z</mi>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Formula.new([
                                                                                     Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                     Plurimath::Math::Function::Mpadded.new(
                                                                                       Plurimath::Math::Symbols::Symbol.new("y"),
                                                                                     ),
                                                                                     Plurimath::Math::Symbols::Symbol.new("z"),
                                                                                   ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #47" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <munder accentunder="true">
              <mrow>
                <mi> x </mi>
                <mo> + </mo>
                <mi> y </mi>
                <mo> + </mo>
                <mi> z </mi>
              </mrow>
              <mo> &#x23DF;<!--BOTTOM CURLY BRACKET--> </mo>
            </munder>
            <mtext>&#xA0;<!--NO-BREAK SPACE-->versus&#xA0;<!--NO-BREAK SPACE--></mtext>
            <munder accentunder="false">
              <mrow>
                <mi> x </mi>
                <mo> + </mo>
                <mi> y </mi>
                <mo> + </mo>
                <mi> z </mi>
              </mrow>
              <mo> &#x23DF;<!--BOTTOM CURLY BRACKET--> </mo>
            </munder>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Formula.new([
                                                                                     Plurimath::Math::Function::Ubrace.new(
                                                                                       Plurimath::Math::Formula.new([
                                                                                                                      Plurimath::Math::Symbols::Symbol.new(" x "),
                                                                                                                      Plurimath::Math::Symbols::Plus.new,
                                                                                                                      Plurimath::Math::Symbols::Symbol.new(" y "),
                                                                                                                      Plurimath::Math::Symbols::Plus.new,
                                                                                                                      Plurimath::Math::Symbols::Symbol.new(" z "),
                                                                                                                    ]),
                                                                                       { accentunder: true },
                                                                                     ),
                                                                                     Plurimath::Math::Function::Text.new("&#xa0;versus&#xa0;"),
                                                                                     Plurimath::Math::Function::Ubrace.new(
                                                                                       Plurimath::Math::Formula.new([
                                                                                                                      Plurimath::Math::Symbols::Symbol.new(" x "),
                                                                                                                      Plurimath::Math::Symbols::Plus.new,
                                                                                                                      Plurimath::Math::Symbols::Symbol.new(" y "),
                                                                                                                      Plurimath::Math::Symbols::Plus.new,
                                                                                                                      Plurimath::Math::Symbols::Symbol.new(" z "),
                                                                                                                    ]),
                                                                                       { accentunder: false },
                                                                                     ),
                                                                                   ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #48" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <mover accent="true">
              <mi> x </mi>
              <mo> &#x5E;<!--CIRCUMFLEX ACCENT--> </mo>
            </mover>
            <mtext>&#xA0;<!--NO-BREAK SPACE-->versus&#xA0;<!--NO-BREAK SPACE--></mtext>
            <mover accent="false">
              <mi> x </mi>
              <mo> &#x5E;<!--CIRCUMFLEX ACCENT--> </mo>
            </mover>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Formula.new([
                                                                                     Plurimath::Math::Function::Hat.new(
                                                                                       Plurimath::Math::Symbols::Symbol.new(" x "),
                                                                                       { accent: true },
                                                                                     ),
                                                                                     Plurimath::Math::Function::Text.new("&#xa0;versus&#xa0;"),
                                                                                     Plurimath::Math::Function::Hat.new(
                                                                                       Plurimath::Math::Symbols::Symbol.new(" x "),
                                                                                       { accent: false },
                                                                                     ),
                                                                                   ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #49" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <mover accent="true">
              <mrow>
                <mi> x </mi>
                <mo> + </mo>
                <mi> y </mi>
                <mo> + </mo>
                <mi> z </mi>
              </mrow>
              <mo> &#x23DE;<!--TOP CURLY BRACKET--> </mo>
            </mover>
            <mtext>&#xA0;<!--NO-BREAK SPACE-->versus&#xA0;<!--NO-BREAK SPACE--></mtext>
            <mover accent="false">
              <mrow>
                <mi> x </mi>
                <mo> + </mo>
                <mi> y </mi>
                <mo> + </mo>
                <mi> z </mi>
              </mrow>
              <mo> &#x23DE;<!--TOP CURLY BRACKET--> </mo>
            </mover>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Formula.new([
                                                                                     Plurimath::Math::Function::Obrace.new(
                                                                                       Plurimath::Math::Formula.new([
                                                                                                                      Plurimath::Math::Symbols::Symbol.new(" x "),
                                                                                                                      Plurimath::Math::Symbols::Plus.new,
                                                                                                                      Plurimath::Math::Symbols::Symbol.new(" y "),
                                                                                                                      Plurimath::Math::Symbols::Plus.new,
                                                                                                                      Plurimath::Math::Symbols::Symbol.new(" z "),
                                                                                                                    ]),
                                                                                       { accent: true },
                                                                                     ),
                                                                                     Plurimath::Math::Function::Text.new("&#xa0;versus&#xa0;"),
                                                                                     Plurimath::Math::Function::Obrace.new(
                                                                                       Plurimath::Math::Formula.new([
                                                                                                                      Plurimath::Math::Symbols::Symbol.new(" x "),
                                                                                                                      Plurimath::Math::Symbols::Plus.new,
                                                                                                                      Plurimath::Math::Symbols::Symbol.new(" y "),
                                                                                                                      Plurimath::Math::Symbols::Plus.new,
                                                                                                                      Plurimath::Math::Symbols::Symbol.new(" z "),
                                                                                                                    ]),
                                                                                       { accent: false },
                                                                                     ),
                                                                                   ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #50" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <mover>
              <munder>
                <mo> &#x222B;<!--INTEGRAL--> </mo>
                <mn> 0 </mn>
              </munder>
              <mi> &#x221E;<!--INFINITY--> </mi>
            </mover>
            <mtext>&#xA0;<!--NO-BREAK SPACE-->versus&#xA0;<!--NO-BREAK SPACE--></mtext>
            <munderover>
              <mo> &#x222B;<!--INTEGRAL--> </mo>
              <mn> 0 </mn>
              <mi> &#x221E;<!--INFINITY--> </mi>
            </munderover>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Formula.new([
                                                                                     Plurimath::Math::Function::Overset.new(
                                                                                       Plurimath::Math::Symbols::Oo.new,
                                                                                       Plurimath::Math::Function::Int.new(
                                                                                         Plurimath::Math::Number.new(" 0 "),
                                                                                       ),
                                                                                     ),
                                                                                     Plurimath::Math::Function::Text.new("&#xa0;versus&#xa0;"),
                                                                                     Plurimath::Math::Function::Int.new(
                                                                                       Plurimath::Math::Number.new(" 0 "),
                                                                                       Plurimath::Math::Symbols::Oo.new,
                                                                                     ),
                                                                                   ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #54" do
    let(:exp) do
      <<~MATHML
        <math>
          <mrow>
            <mo> ( </mo>
            <mtable>
              <mtr>
                <mtd> <mn>1</mn> </mtd>
                <mtd> <mn>0</mn> </mtd>
                <mtd> <mn>0</mn> </mtd>
              </mtr>
              <mtr>
                <mtd> <mn>0</mn> </mtd>
                <mtd> <mn>1</mn> </mtd>
                <mtd> <mn>0</mn> </mtd>
              </mtr>
              <mtr>
                <mtd> <mn>0</mn> </mtd>
                <mtd> <mn>0</mn> </mtd>
                <mtd> <mn>1</mn> </mtd>
              </mtr>
            </mtable>
            <mo> ) </mo>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Table.new(
                                                        [
                                                          Plurimath::Math::Function::Tr.new([
                                                                                              Plurimath::Math::Function::Td.new([
                                                                                                                                  Plurimath::Math::Number.new("1"),
                                                                                                                                ]),
                                                                                              Plurimath::Math::Function::Td.new([
                                                                                                                                  Plurimath::Math::Number.new("0"),
                                                                                                                                ]),
                                                                                              Plurimath::Math::Function::Td.new([
                                                                                                                                  Plurimath::Math::Number.new("0"),
                                                                                                                                ]),
                                                                                            ]),
                                                          Plurimath::Math::Function::Tr.new([
                                                                                              Plurimath::Math::Function::Td.new([
                                                                                                                                  Plurimath::Math::Number.new("0"),
                                                                                                                                ]),
                                                                                              Plurimath::Math::Function::Td.new([
                                                                                                                                  Plurimath::Math::Number.new("1"),
                                                                                                                                ]),
                                                                                              Plurimath::Math::Function::Td.new([
                                                                                                                                  Plurimath::Math::Number.new("0"),
                                                                                                                                ]),
                                                                                            ]),
                                                          Plurimath::Math::Function::Tr.new([
                                                                                              Plurimath::Math::Function::Td.new([
                                                                                                                                  Plurimath::Math::Number.new("0"),
                                                                                                                                ]),
                                                                                              Plurimath::Math::Function::Td.new([
                                                                                                                                  Plurimath::Math::Number.new("0"),
                                                                                                                                ]),
                                                                                              Plurimath::Math::Function::Td.new([
                                                                                                                                  Plurimath::Math::Number.new("1"),
                                                                                                                                ]),
                                                                                            ]),
                                                        ],
                                                        Plurimath::Math::Symbols::Paren::Lround.new,
                                                        Plurimath::Math::Symbols::Paren::Rround.new,
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #55" do
    let(:exp) do
      <<~MATHML
        <math>
          <mtable>
            <mlabeledtr id='e-is-m-c-square'>
              <mtd>
                <mtext> (2.1) </mtext>
              </mtd>
              <mtd>
               <mrow>
                 <mi>E</mi>
                 <mo>=</mo>
                 <mrow>
                  <mi>m</mi>
                  <mo>&#x2062;<!--INVISIBLE TIMES--></mo>
                  <msup>
                   <mi>c</mi>
                   <mn>2</mn>
                  </msup>
                 </mrow>
               </mrow>
              </mtd>
            </mlabeledtr>
          </mtable>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Table.new([
                                                                                             Plurimath::Math::Function::Mlabeledtr.new(
                                                                                               [
                                                                                                 Plurimath::Math::Function::Td.new([
                                                                                                                                     Plurimath::Math::Function::Text.new(" (2.1) "),
                                                                                                                                   ]),
                                                                                                 Plurimath::Math::Function::Td.new([
                                                                                                                                     Plurimath::Math::Formula.new([
                                                                                                                                                                    Plurimath::Math::Symbols::Symbol.new("E"),
                                                                                                                                                                    Plurimath::Math::Symbols::Equal.new,
                                                                                                                                                                    Plurimath::Math::Formula.new([
                                                                                                                                                                                                   Plurimath::Math::Symbols::Symbol.new("m"),
                                                                                                                                                                                                   Plurimath::Math::Symbols::Symbol.new("&#x2062;"),
                                                                                                                                                                                                   Plurimath::Math::Function::Power.new(
                                                                                                                                                                                                     Plurimath::Math::Symbols::Symbol.new("c"),
                                                                                                                                                                                                     Plurimath::Math::Number.new("2"),
                                                                                                                                                                                                   ),
                                                                                                                                                                                                 ]),
                                                                                                                                                                  ]),
                                                                                                                                   ]),
                                                                                               ],
                                                                                               Plurimath::Math::Function::Text.new("e-is-m-c-square"),
                                                                                             ),
                                                                                           ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #56" do
    let(:exp) do
      <<~MATHML
        <math>
          <mtable groupalign=
                   "{decimalpoint left left decimalpoint left left decimalpoint}">
            <mtr>
              <mtd>
                <mrow>
                  <mrow>
                    <mrow>
                      <maligngroup/>
                      <mn> 8.44 </mn>
                      <mo> &#x2062;<!--INVISIBLE TIMES--> </mo>
                      <maligngroup/>
                      <mi> x </mi>
                    </mrow>
                    <maligngroup/>
                    <mo> + </mo>
                    <mrow>
                      <maligngroup/>
                      <mn> 55 </mn>
                      <mo> &#x2062;<!--INVISIBLE TIMES--> </mo>
                      <maligngroup/>
                      <mi> y </mi>
                    </mrow>
                  </mrow>
                <maligngroup/>
                <mo> = </mo>
                <maligngroup/>
                <mn> 0 </mn>
              </mrow>
              </mtd>
            </mtr>
            <mtr>
              <mtd>
                <mrow>
                  <mrow>
                    <mrow>
                      <maligngroup/>
                      <mn> 3.1 </mn>
                      <mo> &#x2062;<!--INVISIBLE TIMES--> </mo>
                      <maligngroup/>
                      <mi> x </mi>
                    </mrow>
                    <maligngroup/>
                    <mo> - </mo>
                    <mrow>
                      <maligngroup/>
                      <mn> 0.7 </mn>
                      <mo> &#x2062;<!--INVISIBLE TIMES--> </mo>
                      <maligngroup/>
                      <mi> y </mi>
                    </mrow>
                  </mrow>
                  <maligngroup/>
                  <mo> = </mo>
                  <maligngroup/>
                  <mrow>
                    <mo> - </mo>
                    <mn> 1.1 </mn>
                  </mrow>
                </mrow>
              </mtd>
            </mtr>
          </mtable>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Table.new([
                                                                                             Plurimath::Math::Function::Tr.new([
                                                                                                                                 Plurimath::Math::Function::Td.new([
                                                                                                                                                                     Plurimath::Math::Formula.new([
                                                                                                                                                                                                    Plurimath::Math::Formula.new([
                                                                                                                                                                                                                                   Plurimath::Math::Formula.new([
                                                                                                                                                                                                                                                                  Plurimath::Math::Number.new(" 8.44 "),
                                                                                                                                                                                                                                                                  Plurimath::Math::Symbols::Symbol.new(" &#x2062; "),
                                                                                                                                                                                                                                                                  Plurimath::Math::Symbols::Symbol.new(" x "),
                                                                                                                                                                                                                                                                ]),
                                                                                                                                                                                                                                   Plurimath::Math::Symbols::Plus.new,
                                                                                                                                                                                                                                   Plurimath::Math::Formula.new([
                                                                                                                                                                                                                                                                  Plurimath::Math::Number.new(" 55 "),
                                                                                                                                                                                                                                                                  Plurimath::Math::Symbols::Symbol.new(" &#x2062; "),
                                                                                                                                                                                                                                                                  Plurimath::Math::Symbols::Symbol.new(" y "),
                                                                                                                                                                                                                                                                ]),
                                                                                                                                                                                                                                 ]),
                                                                                                                                                                                                    Plurimath::Math::Symbols::Equal.new,
                                                                                                                                                                                                    Plurimath::Math::Number.new(" 0 "),
                                                                                                                                                                                                  ]),
                                                                                                                                                                   ]),
                                                                                                                               ]),
                                                                                             Plurimath::Math::Function::Tr.new([
                                                                                                                                 Plurimath::Math::Function::Td.new([
                                                                                                                                                                     Plurimath::Math::Formula.new([
                                                                                                                                                                                                    Plurimath::Math::Formula.new([
                                                                                                                                                                                                                                   Plurimath::Math::Formula.new([
                                                                                                                                                                                                                                                                  Plurimath::Math::Number.new(" 3.1 "),
                                                                                                                                                                                                                                                                  Plurimath::Math::Symbols::Symbol.new(" &#x2062; "),
                                                                                                                                                                                                                                                                  Plurimath::Math::Symbols::Symbol.new(" x "),
                                                                                                                                                                                                                                                                ]),
                                                                                                                                                                                                                                   Plurimath::Math::Symbols::Minus.new,
                                                                                                                                                                                                                                   Plurimath::Math::Formula.new([
                                                                                                                                                                                                                                                                  Plurimath::Math::Number.new(" 0.7 "),
                                                                                                                                                                                                                                                                  Plurimath::Math::Symbols::Symbol.new(" &#x2062; "),
                                                                                                                                                                                                                                                                  Plurimath::Math::Symbols::Symbol.new(" y "),
                                                                                                                                                                                                                                                                ]),
                                                                                                                                                                                                                                 ]),
                                                                                                                                                                                                    Plurimath::Math::Symbols::Equal.new,
                                                                                                                                                                                                    Plurimath::Math::Formula.new([
                                                                                                                                                                                                                                   Plurimath::Math::Symbols::Minus.new,
                                                                                                                                                                                                                                   Plurimath::Math::Number.new(" 1.1 "),
                                                                                                                                                                                                                                 ]),
                                                                                                                                                                                                  ]),
                                                                                                                                                                   ]),
                                                                                                                               ]),
                                                                                           ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end
end
