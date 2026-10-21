require "spec_helper"
require_relative "../../support/shared_xml_parser_examples"

RSpec.describe Plurimath::Mathml::Parser do
  subject(:formula) { described_class.new(exp).parse }

  it_behaves_like "shared XML parser models", "mathml/layout", %w[
    mathml-layout-001
    mathml-layout-002
    mathml-layout-003
    mathml-layout-004
    mathml-layout-005
    mathml-layout-006
    mathml-layout-007
  ]
  # mathml-over-under-016: a bare <mo>frac</mo> is a literal Symbol, not
  # Function::Frac; an actual fraction uses <mfrac>. See PR #450.
  it_behaves_like "shared XML parser models", "mathml/over-under", %w[
    mathml-over-under-002
    mathml-over-under-003
    mathml-over-under-005
    mathml-over-under-006
    mathml-over-under-007
    mathml-over-under-008
    mathml-over-under-009
    mathml-over-under-010
    mathml-over-under-011
    mathml-over-under-012
    mathml-over-under-013
    mathml-over-under-014
    mathml-over-under-016
    mathml-over-under-017
  ]
  it_behaves_like "shared XML parser models", "mathml/scripts", %w[
    mathml-scripts-001
    mathml-scripts-002
    mathml-scripts-003
    mathml-scripts-005
    mathml-scripts-009
    mathml-scripts-011
  ]
  it_behaves_like "shared XML parser models", "mathml/tokens", %w[
    mathml-tokens-003
    mathml-tokens-004
    mathml-tokens-005
    mathml-tokens-006
    mathml-tokens-007
    mathml-tokens-009
    mathml-tokens-010
  ]
  it_behaves_like "shared XML parser models", "mathml/roots", %w[
    mathml-roots-001
    mathml-roots-002
    mathml-roots-003
  ]
  it_behaves_like "shared XML parser models", "mathml/partial-render", %w[
    mathml-partial-001
    mathml-partial-002
    mathml-partial-005
    mathml-partial-006
    mathml-partial-007
  ]
  it_behaves_like "shared XML parser models", "mathml/fractions", ["mathml-fractions-001"]

  context "contains a combining tilde in an mover accent position" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mover accent='true'><mi>c</mi><mo>&#x303;</mo></mover>
        </math>
      MATHML
    end

    it "resolves the combining tilde to the Tilde function" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Tilde.new(
                                                        Plurimath::Math::Symbols::Symbol.new("c"),
                                                        { accent: true },
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end

    it "renders the tilde accent in LaTeX" do
      expect(formula.to_latex).to eq("\\tilde{c}")
    end
  end

  # A text run round-trips a letter through its UNICODE_SYMBOLS name, and
  # Hash#invert keeps only the last key for a duplicated name. Two Greek names
  # were each shared by two different letters: ς sat on "beta" with β, and Ω sat
  # on "omega" with ω — so a real β came back as ς, and a lowercase ω came back
  # as a capital Ω. (Other names are still shared — "hat", "bar", "ul" — but
  # those are alternate spellings of one concept rather than mislabelled
  # letters, and belong with the wider Text placeholder issue.)
  context "contains a Greek letter whose name was shared" do
    {
      "beta" => "&#x3b2;",
      "final sigma" => "&#x3c2;",
      "omega" => "&#x3c9;",
      "capital omega" => "&#x3a9;",
    }.each do |name, entity|
      it "round-trips #{name} through a text run as itself" do
        mathml = "<math xmlns='http://www.w3.org/1998/Math/MathML'><mtext>a#{entity}b</mtext></math>"

        expect(described_class.new(mathml).parse.to_mathml)
          .to include("<mtext>a#{entity}b</mtext>")
      end
    end
  end

  # The promotion above must stay confined to accent positions: outside one, a
  # combining tilde is ordinary content and has to survive untouched.
  context "contains a combining tilde outside an accent position" do
    it "leaves it alone inside a text run" do
      mathml = "<math xmlns='http://www.w3.org/1998/Math/MathML'><mtext>a&#x303;b</mtext></math>"
      expect(described_class.new(mathml).parse.to_latex).to eq("\\text{a&#x303;b}")
    end

    it "leaves a bare mo as a plain symbol" do
      mathml = "<math xmlns='http://www.w3.org/1998/Math/MathML'><mo>&#x303;</mo></math>"
      expect(described_class.new(mathml).parse).to eq(
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Symbols::Symbol.new("&#x303;"),
                                     ]),
      )
    end

    it "leaves a bare mi as a plain symbol" do
      mathml = "<math xmlns='http://www.w3.org/1998/Math/MathML'><mi>&#x303;</mi></math>"
      expect(described_class.new(mathml).parse).to eq(
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Symbols::Symbol.new("&#x303;"),
                                     ]),
      )
    end
  end

  context "contains mathml string of sum with text formula" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <munderover>
            <mo>&#x2211;</mo>
            <mrow>
              <mi>s</mi>
              <mi>x</mi>
            </mrow>
            <mrow>
              <mi>s</mi>
              <mi>w</mi>
            </mrow>
          </munderover>
          <mtext>something</mtext>
        </math>
      MATHML
    end

    it "returns formula of sum" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Sum.new(
                                                        Plurimath::Math::Formula.new([
                                                                                       Plurimath::Math::Symbols::Symbol.new("s"),
                                                                                       Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                     ]),
                                                        Plurimath::Math::Formula.new([
                                                                                       Plurimath::Math::Symbols::Symbol.new("s"),
                                                                                       Plurimath::Math::Symbols::Symbol.new("w"),
                                                                                     ]),
                                                      ),
                                                      Plurimath::Math::Function::Text.new("something"),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of simple text formula" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mtext>sinsumsom&#x393;gamma</mtext>
        </math>
      MATHML
    end

    it "returns formula of text" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Text.new("sinsumsomunicode[:Gamma]gamma"),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of simple text formula multiple unicodes" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mtext>sinsumsom&#x393;&#x3B3;</mtext>
        </math>
      MATHML
    end

    it "returns formula of text" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Text.new("sinsumsomunicode[:Gamma]unicode[:gamma]"),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of log text formula" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msubsup>
            <mi>log</mi>
            <mn>4</mn>
            <mtext>4 terms</mtext>
          </msubsup>
        </math>
      MATHML
    end

    it "returns formula of log and text" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Log.new(
                                                        Plurimath::Math::Number.new("4"),
                                                        Plurimath::Math::Function::Text.new("4 terms"),
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of symbols and text formula" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msubsup>
            <mo>a</mo>
            <mtable>
              <mtr>
                <mtd>
                  <mn>1</mn>
                </mtd>
              </mtr>
            </mtable>
            <mtext>4 terms</mtext>
          </msubsup>
        </math>
      MATHML
    end

    it "returns formula of symbols and text" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::PowerBase.new(
                                                        Plurimath::Math::Symbols::Symbol.new("a"),
                                                        Plurimath::Math::Function::Table.new([
                                                                                               Plurimath::Math::Function::Tr.new([
                                                                                                                                   Plurimath::Math::Function::Td.new([
                                                                                                                                                                       Plurimath::Math::Number.new("1"),
                                                                                                                                                                     ]),
                                                                                                                                 ]),
                                                                                             ]),
                                                        Plurimath::Math::Function::Text.new("4 terms"),
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml mfenced tag and solid columnlines for table formula" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msubsup>
            <mo>a</mo>
            <mfenced open='{' close='}'>
              <mtable columnlines="solid">
                <mtr>
                  <mtd>
                    <mn>1</mn>
                    <mn>1</mn>
                  </mtd>
                </mtr>
              </mtable>
            </mfenced>
            <mtext>4 terms</mtext>
          </msubsup>
        </math>
      MATHML
    end

    it "returns formula of symbol" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::PowerBase.new(
                                                        Plurimath::Math::Symbols::Symbol.new("a"),
                                                        Plurimath::Math::Function::Fenced.new(
                                                          Plurimath::Math::Symbols::Paren::Lcurly.new,
                                                          [
                                                            Plurimath::Math::Function::Table.new(
                                                              [
                                                                Plurimath::Math::Function::Tr.new([
                                                                                                    Plurimath::Math::Function::Td.new([
                                                                                                                                        Plurimath::Math::Number.new("1"),
                                                                                                                                        Plurimath::Math::Number.new("1"),
                                                                                                                                      ]),
                                                                                                    Plurimath::Math::Function::Td.new([
                                                                                                                                        Plurimath::Math::Symbols::Paren::Vert.new,
                                                                                                                                      ]),
                                                                                                  ]),
                                                              ],
                                                              nil,
                                                              nil,
                                                              { columnlines: "solid" },
                                                            ),
                                                          ],
                                                          Plurimath::Math::Symbols::Paren::Rcurly.new,
                                                        ),
                                                        Plurimath::Math::Function::Text.new("4 terms"),
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml mfenced tag and solid columnlines for table formula" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msubsup>
            <mo>a</mo>
            <mfenced open='{' close='}'>
              <mtable columnlines="none">
                <mtr>
                  <mtd>
                    <mn>1</mn>
                    <mn>1</mn>
                  </mtd>
                </mtr>
              </mtable>
            </mfenced>
            <mtext>4 terms</mtext>
          </msubsup>
        </math>
      MATHML
    end

    it "returns formula of symbol" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::PowerBase.new(
                                                        Plurimath::Math::Symbols::Symbol.new("a"),
                                                        Plurimath::Math::Function::Fenced.new(
                                                          Plurimath::Math::Symbols::Paren::Lcurly.new,
                                                          [
                                                            Plurimath::Math::Function::Table.new([
                                                                                                   Plurimath::Math::Function::Tr.new([
                                                                                                                                       Plurimath::Math::Function::Td.new([
                                                                                                                                                                           Plurimath::Math::Number.new("1"),
                                                                                                                                                                           Plurimath::Math::Number.new("1"),
                                                                                                                                                                         ]),
                                                                                                                                     ]),
                                                                                                 ]),
                                                          ],
                                                          Plurimath::Math::Symbols::Paren::Rcurly.new,
                                                        ),
                                                        Plurimath::Math::Function::Text.new("4 terms"),
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of log and text formula" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msup>
            <mrow>
              <mi>log</mi>
              <mn>4</mn>
            </mrow>
            <mrow>
              <mtext>4 terms</mtext>
            </mrow>
          </msup>
        </math>
      MATHML
    end

    it "returns formula of log and text" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Power.new(
                                                        Plurimath::Math::Formula.new([
                                                                                       Plurimath::Math::Function::Log.new,
                                                                                       Plurimath::Math::Number.new("4"),
                                                                                     ]),
                                                        Plurimath::Math::Function::Text.new("4 terms"),
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of sum and ne formula" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <munderover>
            <mo>&#x2211;</mo>
            <mrow>
              <mi>i</mi>
              <mo>=</mo>
              <mstyle mathcolor='blue'>
                <mo>&#x2260;</mo>
              </mstyle>
            </mrow>
            <mn>33</mn>
          </munderover>
        </math>
      MATHML
    end

    it "returns formula of sum and ne" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Sum.new(
                                                        Plurimath::Math::Formula.new([
                                                                                       Plurimath::Math::Symbols::Symbol.new("i"),
                                                                                       Plurimath::Math::Symbols::Equal.new,
                                                                                       Plurimath::Math::Function::Color.new(
                                                                                         Plurimath::Math::Function::Text.new("blue"),
                                                                                         Plurimath::Math::Symbols::Ne.new,
                                                                                       ),
                                                                                     ]),
                                                        Plurimath::Math::Number.new("33"),
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of random string as font style fraktur formula" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle mathcolor="red" mathvariant="fraktur">
            <mi>d</mi>
          </mstyle>
        </math>
      MATHML
    end

    it "returns FontStyle with second value asci" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::FontStyle::Fraktur.new(
                                                        Plurimath::Math::Function::Color.new(
                                                          Plurimath::Math::Function::Text.new("red"),
                                                          Plurimath::Math::Symbols::Symbol.new("d"),
                                                        ),
                                                        "fraktur",
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of random string as font style asci formula" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mstyle mathcolor="red" mathvariant="asci">
            <mi>d</mi>
          </mstyle>
        </math>
      MATHML
    end

    it "returns FontStyle with second value asci" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Color.new(
                                                        Plurimath::Math::Function::Text.new("red"),
                                                        Plurimath::Math::Symbols::Symbol.new("d"),
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of Mathbf formula" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msgroup>
            <mi>33</mi>
            <mtext>dd</mtext>0
          </msgroup>
        </math>
      MATHML
    end

    it "returns formula of Mathbf" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Msgroup.new([
                                                                                               Plurimath::Math::Symbols::Symbol.new("33"),
                                                                                               Plurimath::Math::Function::Text.new("dd"),
                                                                                               Plurimath::Math::Function::Text.new("0\n  "),
                                                                                             ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of Mathbf formula" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msgroup>
            <mi>33</mi>
            <mi>dd</mi>0
          </msgroup>
        </math>
      MATHML
    end

    it "returns formula of Mathbf" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Msgroup.new([
                                                                                               Plurimath::Math::Symbols::Symbol.new("33"),
                                                                                               Plurimath::Math::Symbols::Symbol.new("dd"),
                                                                                               Plurimath::Math::Function::Text.new("0\n  "),
                                                                                             ]),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string of comma decimal values only" do
    let(:exp) do
      <<~MATHML
        <math>
          <msub>
            <mrow>
              <mover accent="true">
                <mrow>
                  <mi>e</mi>
                </mrow>
                <mo>^</mo>
              </mover>
            </mrow>
            <mrow>
              <mi>r</mi>
            </mrow>
          </msub>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Base.new(
                                                        Plurimath::Math::Function::Hat.new(
                                                          Plurimath::Math::Symbols::Symbol.new("e"),
                                                          { accent: true },
                                                        ),
                                                        Plurimath::Math::Symbols::Symbol.new("r"),
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml empty text tag with slash" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msup>
            <mtext/>
            <mn>12</mn>
          </msup>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Power.new(
                                                        Plurimath::Math::Function::Text.new(""),
                                                        Plurimath::Math::Number.new("12"),
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml empty text tag" do
    let(:exp) do
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <msup>
            <mtext></mtext>
            <mn>12</mn>
          </msup>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Power.new(
                                                        Plurimath::Math::Function::Text.new(""),
                                                        Plurimath::Math::Number.new("12"),
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string from metanorma/mn-samples-bipm" do
    let(:exp) do
      <<~MATHML
        <math xmlns="http://www.w3.org/1998/Math/MathML">
          <mstyle scriptminsize="6pt">
            <msub>
              <mrow>
                <mstyle mathvariant="italic">
                  <mi>T</mi>
                </mstyle>
              </mrow>
              <mrow>
                <mn>90</mn>
              </mrow>
            </msub>
            <mo stretchy="false" lspace="0.1em" rspace="0em">/</mo>
            <mrow xref="U_NISTu5">
              <mi mathvariant="normal">K</mi>
            </mrow>
            <mo>=</mo>
            <msub>
              <mrow>
                <mstyle mathvariant="italic">
                  <mi>A</mi>
                </mstyle>
              </mrow>
              <mrow>
                <mn>0</mn>
              </mrow>
            </msub>
            <mo>+</mo>
            <munderover>
              <mrow>
                <mo>∑</mo>
              </mrow>
              <mrow>
                <mrow>
                  <mi>i</mi>
                  <mo>=</mo>
                  <mn>1</mn>
                </mrow>
              </mrow>
              <mrow>
                <mn>9</mn>
              </mrow>
            </munderover>
            <msub>
              <mrow>
                <mstyle mathvariant="italic">
                  <mi>A</mi>
                </mstyle>
              </mrow>
              <mrow>
                <mi>i</mi>
              </mrow>
            </msub>
            <msup>
              <mrow>
                <mfenced open="[" close="]" separators="">
                  <mspace width="-0.15em"/>
                  <mrow>
                    <mfenced open="(" close=")" separators="">
                      <mspace width="-0.15em"/>
                      <mrow>
                        <mi>ln</mi>
                        <mo rspace="-0.35em"/>
                        <mfenced open="(" close=")" separators="">
                          <mspace width="-0.15em"/>
                          <mrow>
                            <mi>p</mi>
                            <mo stretchy="false" lspace="0em" rspace="0em">/</mo>
                            <mrow xref="U_NISTu12">
                              <mi mathvariant="normal">Pa</mi>
                            </mrow>
                          </mrow>
                          <mspace width="-0.1em"/>
                        </mfenced>
                        <mo>—</mo>
                        <mstyle mathvariant="italic">
                          <mi>B</mi>
                        </mstyle>
                      </mrow>
                      <mspace width="-0.1em"/>
                    </mfenced>
                    <mo stretchy="false" lspace="0em" rspace="0em">/</mo>
                    <mstyle mathvariant="italic">
                      <mi>C</mi>
                    </mstyle>
                  </mrow>
                  <mspace width="-0.1em"/>
                </mfenced>
              </mrow>
              <mrow>
                <mi>i</mi>
              </mrow>
            </msup>
            <mo>.</mo>
          </mstyle>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Base.new(
                                                        Plurimath::Math::Function::FontStyle::Italic.new(
                                                          Plurimath::Math::Symbols::Symbol.new("T"),
                                                          "italic",
                                                        ),
                                                        Plurimath::Math::Number.new("90"),
                                                      ),
                                                      Plurimath::Math::Symbols::Symbol.new(
                                                        "/", options: { rspace: "0em" }
                                                      ),
                                                      Plurimath::Math::Function::FontStyle::Normal.new(
                                                        Plurimath::Math::Symbols::Symbol.new("K"),
                                                        "normal",
                                                      ),
                                                      Plurimath::Math::Symbols::Equal.new,
                                                      Plurimath::Math::Function::Base.new(
                                                        Plurimath::Math::Function::FontStyle::Italic.new(
                                                          Plurimath::Math::Symbols::Symbol.new("A"),
                                                          "italic",
                                                        ),
                                                        Plurimath::Math::Number.new("0"),
                                                      ),
                                                      Plurimath::Math::Symbols::Plus.new,
                                                      Plurimath::Math::Function::Sum.new(
                                                        Plurimath::Math::Formula.new([
                                                                                       Plurimath::Math::Symbols::Symbol.new("i"),
                                                                                       Plurimath::Math::Symbols::Equal.new,
                                                                                       Plurimath::Math::Number.new("1"),
                                                                                     ]),
                                                        Plurimath::Math::Number.new("9"),
                                                      ),
                                                      Plurimath::Math::Function::Base.new(
                                                        Plurimath::Math::Function::FontStyle::Italic.new(
                                                          Plurimath::Math::Symbols::Symbol.new("A"),
                                                          "italic",
                                                        ),
                                                        Plurimath::Math::Symbols::Symbol.new("i"),
                                                      ),
                                                      Plurimath::Math::Function::Power.new(
                                                        Plurimath::Math::Function::Fenced.new(
                                                          Plurimath::Math::Symbols::Paren::Lsquare.new,
                                                          [
                                                            Plurimath::Math::Formula.new([
                                                                                           Plurimath::Math::Function::Fenced.new(
                                                                                             Plurimath::Math::Symbols::Paren::Lround.new,
                                                                                             [
                                                                                               Plurimath::Math::Formula.new([
                                                                                                                              Plurimath::Math::Function::Ln.new(
                                                                                                                                Plurimath::Math::Symbols::Symbol.new(nil,
                                                                                                                                                                     options: { rspace: "-0.35em" }),
                                                                                                                              ),
                                                                                                                              Plurimath::Math::Function::Fenced.new(
                                                                                                                                Plurimath::Math::Symbols::Paren::Lround.new,
                                                                                                                                [
                                                                                                                                  Plurimath::Math::Formula.new([
                                                                                                                                                                 Plurimath::Math::Symbols::Symbol.new("p"),
                                                                                                                                                                 Plurimath::Math::Symbols::Symbol.new("/",
                                                                                                                                                                                                      options: { rspace: "0em" }),
                                                                                                                                                                 Plurimath::Math::Function::FontStyle::Normal.new(
                                                                                                                                                                   Plurimath::Math::Symbols::Symbol.new("Pa"),
                                                                                                                                                                   "normal",
                                                                                                                                                                 ),
                                                                                                                                                               ]),
                                                                                                                                ],
                                                                                                                                Plurimath::Math::Symbols::Paren::Rround.new,
                                                                                                                                { separators: "" },
                                                                                                                              ),
                                                                                                                              Plurimath::Math::Symbols::Symbol.new("&#x2014;"),
                                                                                                                              Plurimath::Math::Function::FontStyle::Italic.new(
                                                                                                                                Plurimath::Math::Symbols::Symbol.new("B"),
                                                                                                                                "italic",
                                                                                                                              ),
                                                                                                                            ]),
                                                                                             ],
                                                                                             Plurimath::Math::Symbols::Paren::Rround.new,
                                                                                             { separators: "" },
                                                                                           ),
                                                                                           Plurimath::Math::Symbols::Symbol.new("/",
                                                                                                                                options: { rspace: "0em" }),
                                                                                           Plurimath::Math::Function::FontStyle::Italic.new(
                                                                                             Plurimath::Math::Symbols::Symbol.new("C"),
                                                                                             "italic",
                                                                                           ),
                                                                                         ]),
                                                          ],
                                                          Plurimath::Math::Symbols::Paren::Rsquare.new,
                                                          { separators: "" },
                                                        ),
                                                        Plurimath::Math::Symbols::Symbol.new("i"),
                                                      ),
                                                      Plurimath::Math::Symbols::Period.new,
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string from metanorma/mn-samples-bipm" do
    let(:exp) do
      <<~MATHML
        <math>
          <semantics>
            <mrow>
              <mstyle displaystyle='true'>
                <mrow>
                  <msubsup>
                    <mo>∫</mo>
                    <mrow>
                      <msub>
                        <mi>t</mi>
                        <mn>2</mn>
                      </msub>
                    </mrow>
                    <mrow>
                      <msub>
                        <mi>t</mi>
                        <mn>1</mn>
                      </msub>
                    </mrow>
                  </msubsup>
                  <mrow>
                    <mi>f</mi>
                    <mo stretchy='false'>(</mo>
                    <mi>t</mi>
                    <mo stretchy='false'>)</mo>
                    <mo>d</mo>
                    <mi>t</mi>
                  </mrow>
                </mrow>
              </mstyle>
            </mrow>
            <annotation encoding='MathType-MTEF'>MathType@MTEF@5@5@+= feaagKart1ev2aaatCvAUfeBSjuyZL2yd9gzLbvyNv2CaerbbjxAHX garuavP1wzZbItLDhis9wBH5garmWu51MyVXgarqqtubsr4rNCHbGe aGqipG0dh9qqWrVepG0dbbL8F4rqqrVepeea0xe9LqFf0xc9q8qqaq Fn0lXdHiVcFbIOFHK8Feea0dXdar=Jb9hs0dXdHuk9fr=xfr=xfrpe WZqaaeaaciWacmGadaGadeaabaGaaqaaaOqaamaapedabaGaamOzai aacIcacaWG0bGaaiykaKqzaeGaaiizaOGaamiDaaWcbaGaamiDamaa BaaameaacaaIYaaabeaaaSqaaiaadshadaWgaaadbaGaaGymaaqaba aaniabgUIiYdaaaa@40DD@ </annotation>
          </semantics>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Semantics.new(
                                                        Plurimath::Math::Function::Int.new(
                                                          Plurimath::Math::Function::Base.new(
                                                            Plurimath::Math::Symbols::Symbol.new("t"),
                                                            Plurimath::Math::Number.new("2"),
                                                          ),
                                                          Plurimath::Math::Function::Base.new(
                                                            Plurimath::Math::Symbols::Symbol.new("t"),
                                                            Plurimath::Math::Number.new("1"),
                                                          ),
                                                          Plurimath::Math::Formula.new([
                                                                                         Plurimath::Math::Symbols::Symbol.new("f"),
                                                                                         Plurimath::Math::Symbols::Paren::Lround.new,
                                                                                         Plurimath::Math::Symbols::Symbol.new("t"),
                                                                                         Plurimath::Math::Symbols::Paren::Rround.new,
                                                                                         Plurimath::Math::Symbols::Symbol.new("d"),
                                                                                         Plurimath::Math::Symbols::Symbol.new("t"),
                                                                                       ]),
                                                        ),
                                                        [
                                                          {
                                                            annotation: [
                                                              Plurimath::Math::Symbols::Symbol.new("MathType@MTEF@5@5@+= feaagKart1ev2aaatCvAUfeBSjuyZL2yd9gzLbvyNv2CaerbbjxAHX garuavP1wzZbItLDhis9wBH5garmWu51MyVXgarqqtubsr4rNCHbGe aGqipG0dh9qqWrVepG0dbbL8F4rqqrVepeea0xe9LqFf0xc9q8qqaq Fn0lXdHiVcFbIOFHK8Feea0dXdar=Jb9hs0dXdHuk9fr=xfr=xfrpe WZqaaeaaciWacmGadaGadeaabaGaaqaaaOqaamaapedabaGaamOzai aacIcacaWG0bGaaiykaKqzaeGaaiizaOGaamiDaaWcbaGaamiDamaa BaaameaacaaIYaaabeaaaSqaaiaadshadaWgaaadbaGaaGymaaqaba aaniabgUIiYdaaaa@40DD@ "),
                                                            ],
                                                          },
                                                        ],
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml string from issue #89 Exp #2" do
    let(:exp) do
      <<~MATHML
        <math xmlns="http://www.w3.org/1998/Math/MathML">
          <mstyle mathcolor="#ff0000">
            <mtext>Assigned value</mtext>
          </mstyle>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Color.new(
                                                        Plurimath::Math::Function::Text.new("#ff0000"),
                                                        Plurimath::Math::Function::Text.new("Assigned value"),
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains metanorma mathml string Exp #1" do
    let(:exp) do
      <<~MATHML
        <math xmlns="http://www.w3.org/1998/Math/MathML">
          <mstyle scriptminsize="6pt">
            <msub>
              <mrow>
                <mstyle mathvariant="italic">
                  <mi>W</mi>
                </mstyle>
              </mrow>
              <mrow>
                <mi>t</mi>
              </mrow>
            </msub>
            <mo rspace="-0.35em"/>
            <mfenced open="(" close=")" separators="">
              <mspace width="-0.15em"/>
              <mrow>
                <msub>
                  <mrow>
                    <mstyle mathvariant="italic">
                      <mi>T</mi>
                    </mstyle>
                  </mrow>
                  <mrow>
                    <mn>90</mn>
                  </mrow>
                </msub>
              </mrow>
              <mspace width="-0.1em"/>
            </mfenced>
          </mstyle>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Base.new(
                                                        Plurimath::Math::Function::FontStyle::Italic.new(
                                                          Plurimath::Math::Symbols::Symbol.new("W"),
                                                          "italic",
                                                        ),
                                                        Plurimath::Math::Symbols::Symbol.new("t"),
                                                      ),
                                                      Plurimath::Math::Symbols::Symbol.new(nil,
                                                                                           options: { rspace: "-0.35em" }),
                                                      Plurimath::Math::Function::Fenced.new(
                                                        Plurimath::Math::Symbols::Paren::Lround.new,
                                                        [
                                                          Plurimath::Math::Function::Base.new(
                                                            Plurimath::Math::Function::FontStyle::Italic.new(
                                                              Plurimath::Math::Symbols::Symbol.new("T"),
                                                              "italic",
                                                            ),
                                                            Plurimath::Math::Number.new("90"),
                                                          ),
                                                        ],
                                                        Plurimath::Math::Symbols::Paren::Rround.new,
                                                        { separators: "" },
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml equation with intent attribute as input" do
    let(:exp) do
      <<~MATHML
        <math xmlns="http://www.w3.org/1998/Math/MathML">
          <mrow intent="plus(x, y)">
            <mi>x</mi>
            <mo>+</mo>
            <mi>y</mi>
          </mrow>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Intent.new(
                                                        Plurimath::Math::Formula.new([
                                                                                       Plurimath::Math::Symbols::Symbol.new("x"),
                                                                                       Plurimath::Math::Symbols::Plus.new,
                                                                                       Plurimath::Math::Symbols::Symbol.new("y"),
                                                                                     ]),
                                                        Plurimath::Math::Function::Text.new("plus(x, y)"),
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml equation dot and ddot with theta as their value" do
    let(:exp) do
      <<~MATHML
        <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
          <mstyle displaystyle="true">
            <mover>
              <mi>&#x3b8;</mi>
              <mo>.</mo>
            </mover>
            <mo>&#x2260;</mo>
            <mover accent="true">
              <mi>&#x3b8;</mi>
              <mo>..</mo>
            </mover>
          </mstyle>
        </math>
      MATHML
    end

    it "returns formula containing dot and ddot with theta as their value" do
      expected_value = Plurimath::Math::Formula.new([
                                                      Plurimath::Math::Function::Dot.new(
                                                        Plurimath::Math::Symbols::Theta.new,
                                                      ),
                                                      Plurimath::Math::Symbols::Ne.new,
                                                      Plurimath::Math::Function::Ddot.new(
                                                        Plurimath::Math::Symbols::Theta.new,
                                                        { attributes: { accent: true } },
                                                      ),
                                                    ])
      expect(formula).to eq(expected_value)
    end
  end
end
