require "spec_helper"

RSpec.describe Plurimath::Mathml::Parser do

  subject(:formula) { Plurimath::Mathml::Parser.new(exp).parse }

  context "contains mathml v3 #3 example #3" do
    let(:exp) {
      <<~MATHML
        <math>
          <mi> x </mi>
          <mi> D </mi>
          <mi> sin </mi>
          <mi mathvariant='script'> L </mi>
          <mi></mi>
        </math>
      MATHML
    }
    it "returns formula of sin from mathml string" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Symbol.new(" x "),
        Plurimath::Math::Symbol.new(" D "),
        Plurimath::Math::Function::Sin.new,
        Plurimath::Math::Function::FontStyle::Script.new(
          Plurimath::Math::Symbol.new(" L "),
          "script",
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #4" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi> sin </mi>
            <mo> &#x2061;<!--FUNCTION APPLICATION--> </mo>
            <mi> x </mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Symbol.new(" &#x2061; "),
          ),
          Plurimath::Math::Number.new(" x "),
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #5" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mn> 1 </mn>
            <mo> + </mo>
            <mi> &#x2026;<!--HORIZONTAL ELLIPSIS--> </mi>
            <mo> + </mo>
            <mi> n </mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new(" 1 "),
          Plurimath::Math::Symbol.new(" + "),
          Plurimath::Math::Symbol.new(" &#x2026; "),
          Plurimath::Math::Symbol.new(" + "),
          Plurimath::Math::Symbol.new(" n ")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #6" do
    let(:exp) {
      <<~MATHML
        <math>
          <mi> &#x3C0;<!--GREEK SMALL LETTER PI--> </mi>
          <mi> &#x2148;<!--DOUBLE-STRUCK ITALIC SMALL I--> </mi>
          <mi> &#x2147;<!--DOUBLE-STRUCK ITALIC SMALL E--> </mi>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Symbol.new(" &#x3c0; "),
        Plurimath::Math::Symbol.new(" &#x2148; "),
        Plurimath::Math::Symbol.new(" &#x2147; "),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #7" do
    let(:exp) {
      <<~MATHML
        <math>
          <mn> 2 </mn>
          <mn> 0.123 </mn>
          <mn> 1,000,000 </mn>
          <mn> 2.1e10 </mn>
          <mn> 0xFFEF </mn>
          <mn> MCMLXIX </mn>
          <mn> twenty one </mn>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Symbol.new(" 2 "),
        Plurimath::Math::Symbol.new(" 0.123 "),
        Plurimath::Math::Symbol.new(" 1,000,000 "),
        Plurimath::Math::Symbol.new(" 2.1e10 "),
        Plurimath::Math::Symbol.new(" 0xFFEF "),
        Plurimath::Math::Symbol.new(" MCMLXIX "),
        Plurimath::Math::Symbol.new(" twenty one "),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #8" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mn> 2 </mn>
            <mo> + </mo>
            <mrow>
              <mn> 3 </mn>
              <mo> &#x2062;<!--INVISIBLE TIMES--> </mo>
              <mi> &#x2148;<!--DOUBLE-STRUCK ITALIC SMALL I--> </mi>
            </mrow>
          </mrow>
          <mfrac> <mn> 1 </mn> <mn> 2 </mn> </mfrac>
          <mi> &#x3C0;<!--GREEK SMALL LETTER PI--> </mi>
          <mi> &#x2147;<!--DOUBLE-STRUCK ITALIC SMALL E--> </mi>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new(" 2 "),
          Plurimath::Math::Symbol.new(" + "),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new(" 3 "),
            Plurimath::Math::Symbol.new(" &#x2062; "),
            Plurimath::Math::Symbol.new(" &#x2148; ")
          ])
        ]),
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Symbol.new(" 1 "),
          Plurimath::Math::Symbol.new(" 2 ")
        ),
        Plurimath::Math::Symbol.new(" &#x3c0; "),
        Plurimath::Math::Symbol.new(" &#x2147; ")
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #9" do
    let(:exp) {
      <<~MATHML
        <math>
          <mo> + </mo>
          <mo> &lt; </mo>
          <mo> &#x2264;<!--LESS-THAN OR EQUAL TO--> </mo>
          <mo> &lt;= </mo>
          <mo> ++ </mo>
          <mo> &#x2211;<!--N-ARY SUMMATION--> </mo>
          <mo> .NOT. </mo>
          <mo> and </mo>
          <mo> &#x2062;<!--INVISIBLE TIMES--> </mo>
          <mo mathvariant='bold'> + </mo>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Symbol.new(" + "),
        Plurimath::Math::Symbol.new(" &#x3c; "),
        Plurimath::Math::Symbol.new(" &#x2264; "),
        Plurimath::Math::Symbol.new(" &#x3c;= "),
        Plurimath::Math::Symbol.new(" ++ "),
        Plurimath::Math::Function::Sum.new,
        Plurimath::Math::Symbol.new(" .NOT. "),
        Plurimath::Math::Symbol.new(" and "),
        Plurimath::Math::Symbol.new(" &#x2062; "),
        Plurimath::Math::Function::FontStyle::Bold.new(
          Plurimath::Math::Symbol.new(" + "),
          "bold",
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #10" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo> ( </mo>
            <mrow>
              <mi> a </mi>
              <mo> + </mo>
              <mi> b </mi>
            </mrow>
            <mo> ) </mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new(" ( "),
          [
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(" a "),
              Plurimath::Math::Symbol.new(" + "),
              Plurimath::Math::Symbol.new(" b ")
            ])
          ],
          Plurimath::Math::Symbol.new(" ) ")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #11" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo> [ </mo>
            <mrow>
              <mn> 0 </mn>
              <mo> , </mo>
              <mn> 1 </mn>
            </mrow>
            <mo> ) </mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new(" [ "),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new(" 0 "),
            Plurimath::Math::Symbol.new(" , "),
            Plurimath::Math::Number.new(" 1 ")
          ]),
          Plurimath::Math::Symbol.new(" ) ")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #12" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi> f </mi>
            <mo> &#x2061;<!--FUNCTION APPLICATION--> </mo>
            <mrow>
              <mo> ( </mo>
              <mrow>
                <mi> x </mi>
                <mo> , </mo>
                <mi> y </mi>
              </mrow>
              <mo> ) </mo>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new(" f "),
          Plurimath::Math::Symbol.new(" &#x2061; "),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new(" ( "),
            [
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new(" x "),
                Plurimath::Math::Symbol.new(" , "),
                Plurimath::Math::Symbol.new(" y ")
              ])
            ],
            Plurimath::Math::Symbol.new(" ) ")
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #13" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi> sin </mi>
            <mo> &#x2061;<!--FUNCTION APPLICATION--> </mo>
            <mi> x </mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Symbol.new(" &#x2061; "),
          ),
          Plurimath::Math::Symbol.new(" x ")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #14" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi> x </mi>
            <mo> &#x2062;<!--INVISIBLE TIMES--> </mo>
            <mi> y </mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new(" x "),
          Plurimath::Math::Symbol.new(" &#x2062; "),
          Plurimath::Math::Symbol.new(" y ")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #15" do
    let(:exp) {
      <<~MATHML
        <math>
          <msub>
            <mi> m </mi>
            <mrow>
              <mn> 1 </mn>
              <mo> &#x2063;<!--INVISIBLE SEPARATOR--> </mo>
              <mn> 2 </mn>
            </mrow>
          </msub>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Base.new(
          Plurimath::Math::Symbol.new(" m "),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new(" 1 "),
            Plurimath::Math::Symbol.new(" &#x2063; "),
            Plurimath::Math::Symbol.new(" 2 ")
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #16" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mn> 2 </mn>
            <mo> &#x2064;<!--INVISIBLE PLUS--> </mo>
            <mfrac>
              <mn> 3 </mn>
              <mn> 4 </mn>
            </mfrac>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new(" 2 "),
          Plurimath::Math::Symbol.new(" &#x2064; "),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Symbol.new(" 3 "),
            Plurimath::Math::Symbol.new(" 4 "),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #17" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfrac>
            <mo> &#x2146;<!--DOUBLE-STRUCK ITALIC SMALL D--> </mo>
            <mrow>
              <mo> &#x2146;<!--DOUBLE-STRUCK ITALIC SMALL D--> </mo>
              <mi> x </mi>
            </mrow>
          </mfrac>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Symbol.new(" &#x2146; "),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new(" &#x2146; "),
            Plurimath::Math::Symbol.new(" x ")
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #18" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <munder>
              <mo> ( </mo>
              <mo> &#x5F;<!--LOW LINE--> </mo>
            </munder>
            <mfrac>
              <mi> a </mi>
              <mi> b </mi>
            </mfrac>
            <mover>
              <mo> ) </mo>
              <mo> &#x203E;<!--OVERLINE--> </mo>
            </mover>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Ul.new(
            Plurimath::Math::Symbol.new(" ( ")
          ),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Symbol.new(" a "),
            Plurimath::Math::Symbol.new(" b ")
          ),
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Symbol.new(" &#x203e; "),
            Plurimath::Math::Symbol.new(" ) ")
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #19" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo maxsize="100%"> ( </mo>
            <mfrac>
              <mi> a </mi> <mi> b </mi>
            </mfrac>
            <mo minsize="100%"> ) </mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new(" ( "),
          [
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Symbol.new(" a "),
              Plurimath::Math::Symbol.new(" b ")
            )
          ],
          Plurimath::Math::Symbol.new(" ) ")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #20" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new(" x "),
          Plurimath::Math::Function::Vec.new(
            Plurimath::Math::Function::Text.new(" maps to "),
          ),
          Plurimath::Math::Symbol.new(" y ")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #21" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("f"),
            Plurimath::Math::Symbol.new("&#x2061;"),
            Plurimath::Math::Symbol.new("("),
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Symbol.new(")")
          ]),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Function::Fenced.new(
                Plurimath::Math::Symbol.new("("),
                [
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new("x"),
                    Plurimath::Math::Symbol.new("+"),
                    Plurimath::Math::Symbol.new("1")
                  ])
                ],
                Plurimath::Math::Symbol.new(")")
              ),
              Plurimath::Math::Symbol.new("4")
            ),
            Plurimath::Math::Function::Linebreak.new(
              Plurimath::Math::Symbol.new("="),
              { linebreak: "newline", linebreakstyle: "before" },
            ),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Power.new(
                Plurimath::Math::Symbol.new("x"),
                Plurimath::Math::Symbol.new("4")
              ),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("4"),
                Plurimath::Math::Symbol.new("&#x2062;"),
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Symbol.new("3")
                )
              ]),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("6"),
                Plurimath::Math::Symbol.new("&#x2062;"),
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbol.new("x"),
                  Plurimath::Math::Symbol.new("2")
                )
              ]),
              Plurimath::Math::Function::Linebreak.new(
                Plurimath::Math::Symbol.new("+"),
                { linebreak: "newline", linebreakstyle: "before" },
              ),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("4"),
                Plurimath::Math::Symbol.new("&#x2062;"),
                Plurimath::Math::Symbol.new("x")
              ]),
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Symbol.new("1")
            ])
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #22" do
    let(:exp) {
      <<~MATHML
        <math>
          <mtext> Theorem 1: </mtext>
          <mtext> &#x2009;<!--THIN SPACE--> </mtext>
          <mtext> &#x205F;&#x200A;<!--space of width 5/18 em-->&#x205F;&#x200A;<!--space of width 5/18 em--> </mtext>
          <mtext> /* a comment */ </mtext>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Text.new(" Theorem 1: "),
        Plurimath::Math::Function::Text.new(" &#x2009; "),
        Plurimath::Math::Function::Text.new(" &#x205f;&#x200a;&#x205f;&#x200a; "),
        Plurimath::Math::Function::Text.new(" /* a comment */ ")
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #23" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo> there exists </mo>
            <mrow>
              <mrow>
                <mi> &#x3B4;<!--GREEK SMALL LETTER DELTA--> </mi>
                <mo> &gt; </mo>
                <mn> 0 </mn>
              </mrow>
              <mo> such that </mo>
              <mrow>
                <mrow>
                  <mi> f </mi>
                  <mo> &#x2061;<!--FUNCTION APPLICATION--> </mo>
                  <mrow>
                    <mo> ( </mo>
                    <mi> x </mi>
                    <mo> ) </mo>
                  </mrow>
                </mrow>
                <mo> &lt; </mo>
                <mn> 1 </mn>
              </mrow>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new(" there exists "),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(" &#x3b4; "),
              Plurimath::Math::Symbol.new(" &#x3e; "),
              Plurimath::Math::Symbol.new(" 0 ")
            ]),
            Plurimath::Math::Symbol.new(" such that "),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new(" f "),
                Plurimath::Math::Symbol.new(" &#x2061; "),
                Plurimath::Math::Function::Fenced.new(
                  Plurimath::Math::Symbol.new(" ( "),
                  [
                    Plurimath::Math::Symbol.new(" x "),
                  ],
                  Plurimath::Math::Symbol.new(" ) ")
                ),
              ]),
              Plurimath::Math::Symbol.new(" &#x3c; "),
              Plurimath::Math::Symbol.new(" 1 ")
            ]),
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #24" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("b"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Symbol.new("c")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #25" do
    let(:exp) {
      <<~MATHML
        <math>
          <msup>
            <mi> x </mi>
            <malignmark edge="right"/>
            <mn> 2 </mn>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Symbol.new(" x ")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #26" do
    let(:exp) {
      <<~MATHML
        <math>
          <msup>
            <mrow>
              <mi> x </mi>
              <malignmark edge="right"/>
            </mrow>
            <mn> 2 </mn>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Symbol.new(" x "),
          Plurimath::Math::Symbol.new(" 2 ")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #27" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mrow>
              <mn> 2 </mn>
              <mo> &#x2062;<!--INVISIBLE TIMES--> </mo>
              <mi> x </mi>
            </mrow>
            <mo> + </mo>
            <mi> y </mi>
            <mo> - </mo>
            <mi> z </mi>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new(" 2 "),
            Plurimath::Math::Symbol.new(" &#x2062; "),
            Plurimath::Math::Symbol.new(" x ")
          ]),
          Plurimath::Math::Symbol.new(" + "),
          Plurimath::Math::Symbol.new(" y "),
          Plurimath::Math::Symbol.new(" - "),
          Plurimath::Math::Symbol.new(" z ")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #28" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo> ( </mo>
            <mrow>
              <mi> x </mi>
              <mo> , </mo>
              <mi> y </mi>
            </mrow>
            <mo> ) </mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new(" ( "),
          [
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(" x "),
              Plurimath::Math::Symbol.new(" , "),
              Plurimath::Math::Symbol.new(" y ")
            ])
          ],
          Plurimath::Math::Symbol.new(" ) ")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #29" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new(" ( "),
          [
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Symbol.new(" a "),
              Plurimath::Math::Symbol.new(" b ")
            )
          ],
          Plurimath::Math::Symbol.new(" ) ")
        ),
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Symbol.new(" a "),
            Plurimath::Math::Symbol.new(" b ")
          ),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Symbol.new(" c "),
            Plurimath::Math::Symbol.new(" d ")
          )
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #30" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Symbol.new(" 1 "),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new(" x "),
              Plurimath::Math::Symbol.new(" 3 ")
            ),
            Plurimath::Math::Symbol.new(" + "),
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Symbol.new(" x "),
              Plurimath::Math::Symbol.new(" 3 ")
            )
          ])
        ),
        Plurimath::Math::Symbol.new(" = "),
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Symbol.new(" 1 "),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new(" x "),
              Plurimath::Math::Symbol.new(" 3 ")
            ),
            Plurimath::Math::Symbol.new(" + "),
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Symbol.new(" x "),
              Plurimath::Math::Symbol.new(" 3 ")
            )
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #31" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfrac>
            <mrow>
              <mn>1 </mn>
              <mo>+ </mo>
              <msqrt>
                <mn>5 </mn>
              </msqrt>
            </mrow>
            <mn>2 </mn>
          </mfrac>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("1 "),
            Plurimath::Math::Symbol.new("+ "),
            Plurimath::Math::Function::Sqrt.new(
              Plurimath::Math::Symbol.new("5 ")
            )
          ]),
          Plurimath::Math::Symbol.new("2 ")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #32" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo maxsize="100%"> ( </mo>
            <mfrac> <mi> a </mi> <mi> b </mi> </mfrac>
            <mo maxsize="100%"> ) </mo>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new(" ( "),
          [
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Symbol.new(" a "),
              Plurimath::Math::Symbol.new(" b ")
            )
          ],
          Plurimath::Math::Symbol.new(" ) ")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #33" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstyle maxsize="100%">
            <mrow>
              <mo> ( </mo>
              <mfrac> <mi> a </mi> <mi> b </mi> </mfrac>
              <mo> ) </mo>
            </mrow>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new(" ( "),
          [
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Symbol.new(" a "),
              Plurimath::Math::Symbol.new(" b ")
            )
          ],
          Plurimath::Math::Symbol.new(" ) ")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #34" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfraction>
            <mrow>
              <mn> 1 </mn>
              <mo> + </mo>
              <msqrt>
                <mn> 5 </mn>
              </msqrt>
            </mrow>
            <mn> 2 </mn>
          </mfraction>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new(" 1 "),
            Plurimath::Math::Symbol.new(" + "),
            Plurimath::Math::Function::Sqrt.new(
              Plurimath::Math::Symbol.new(" 5 ")
            )
          ]),
          Plurimath::Math::Symbol.new(" 2 ")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #35" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("x"),
          Plurimath::Math::Symbol.new("y"),
          Plurimath::Math::Symbol.new("z")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #36" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfrac>
            <mrow>
              <mi> x </mi>
              <mo> + </mo>
              <mi> y </mi>
              <mo> + </mo>
              <mi> z </mi>
            </mrow>
            <mrow>
              <mi> x </mi>
              <mphantom>
                <mo form="infix"> + </mo>
                <mi> y </mi>
              </mphantom>
              <mo> + </mo>
              <mi> z </mi>
            </mrow>
          </mfrac>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new(" x "),
            Plurimath::Math::Symbol.new(" + "),
            Plurimath::Math::Symbol.new(" y "),
            Plurimath::Math::Symbol.new(" + "),
            Plurimath::Math::Symbol.new(" z ")
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new(" x "),
            Plurimath::Math::Function::Phantom.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new(" + "),
                Plurimath::Math::Symbol.new(" y ")
              ]),
            ),
            Plurimath::Math::Symbol.new(" + "),
            Plurimath::Math::Symbol.new(" z ")
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #37" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfrac>
            <mrow>
              <mi> x </mi>
              <mo> + </mo>
              <mi> y </mi>
              <mo> + </mo>
              <mi> z </mi>
            </mrow>
            <mrow>
              <mi> x </mi>
              <mphantom>
                <mo> + </mo>
              </mphantom>
              <mphantom>
                <mi> y </mi>
              </mphantom>
              <mo> + </mo>
              <mi> z </mi>
            </mrow>
          </mfrac>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new(" x "),
            Plurimath::Math::Symbol.new(" + "),
            Plurimath::Math::Symbol.new(" y "),
            Plurimath::Math::Symbol.new(" + "),
            Plurimath::Math::Symbol.new(" z ")
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new(" x "),
            Plurimath::Math::Function::Phantom.new(
              Plurimath::Math::Symbol.new(" + "),
            ),
            Plurimath::Math::Function::Phantom.new(
              Plurimath::Math::Symbol.new(" y "),
            ),
            Plurimath::Math::Symbol.new(" + "),
            Plurimath::Math::Symbol.new(" z ")
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #38" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mo> ( </mo>
            <mrow>
              <mi>x</mi>
              <mo>,</mo>
              <mi>y</mi>
            </mrow>
            <mo> ) </mo>
          </mrow>
          <mfenced>
            <mi>x</mi>
            <mi>y</mi>
          </mfenced>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new(" ( "),
          [
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("x"),
              Plurimath::Math::Symbol.new(","),
              Plurimath::Math::Symbol.new("y")
            ])
          ],
          Plurimath::Math::Symbol.new(" ) ")
        ),
         Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          [
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Symbol.new("y")
          ],
          Plurimath::Math::Symbol.new(")"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #39" do
    let(:exp) {
      <<~MATHML
        <math>
          <mfenced open="[">
            <mn> 0 </mn>
            <mn> 1 </mn>
          </mfenced>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("["),
          [
            Plurimath::Math::Symbol.new(" 0 "),
            Plurimath::Math::Symbol.new(" 1 ")
          ],
          nil,
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #40" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mi> f </mi>
            <mo> &#x2061;<!--FUNCTION APPLICATION--> </mo>
            <mfenced>
              <mi> x </mi>
              <mi> y </mi>
            </mfenced>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new(" f "),
          Plurimath::Math::Symbol.new(" &#x2061; "),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Symbol.new(" x "),
              Plurimath::Math::Symbol.new(" y ")
            ],
            Plurimath::Math::Symbol.new(")"),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #41" do
    let(:exp) {
      <<~MATHML
        <math>
          <menclose notation='circle box'>
            <mi> x </mi>
            <mo> + </mo>
            <mi> y </mi>
          </menclose>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Menclose.new(
          "circle box",
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new(" x "),
            Plurimath::Math::Symbol.new(" + "),
            Plurimath::Math::Symbol.new(" y ")
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #42" do
    let(:exp) {
      <<~MATHML
        <math>
          <menclose>
            <mi> x </mi>
            <mo> + </mo>
            <mi> y </mi>
          </menclose>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Menclose.new(
          nil,
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new(" x "),
            Plurimath::Math::Symbol.new(" + "),
            Plurimath::Math::Symbol.new(" y ")
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #43" do
    let(:exp) {
      <<~MATHML
        <math>
          <msub>
            <mi>a</mi>
            <mrow>
              <menclose notation='actuarial'>
                <mi>n</mi>
              </menclose>
              <mo>&#x2063;<!--INVISIBLE SEPARATOR--></mo>
              <mi>i</mi>
            </mrow>
          </msub>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Base.new(
          Plurimath::Math::Symbol.new("a"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Menclose.new(
              "actuarial",
              Plurimath::Math::Symbol.new("n")
            ),
            Plurimath::Math::Symbol.new("&#x2063;"),
            Plurimath::Math::Symbol.new("i")
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #44" do
    let(:exp) {
      <<~MATHML
        <math>
          <mi>C</mi>
          <mrow>
            <menclose notation='phasorangle'>
              <mrow>
                <mo>&#x2212;<!--MINUS SIGN--></mo>
                <mfrac>
                  <mi>&#x3C0;<!--GREEK SMALL LETTER PI--></mi>
                  <mn>2</mn>
                </mfrac>
              </mrow>
            </menclose>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Symbol.new("C"),
        Plurimath::Math::Function::Menclose.new(
          "phasorangle",
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("&#x2212;"),
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Symbol.new("&#x3c0;"),
              Plurimath::Math::Symbol.new("2"),
            )
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #45" do
    let(:exp) {
      <<~MATHML
        <math>
          <msup>
            <mrow>
              <mo> ( </mo>
              <mrow>
                <mi> x </mi>
                <mo> + </mo>
                <mi> y </mi>
              </mrow>
              <mo> ) </mo>
            </mrow>
            <mn> 2 </mn>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new(" ( "),
            [
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new(" x "),
                Plurimath::Math::Symbol.new(" + "),
                Plurimath::Math::Symbol.new(" y ")
              ])
            ],
            Plurimath::Math::Symbol.new(" ) ")
          ),
          Plurimath::Math::Symbol.new(" 2 ")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #46" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <msubsup>
              <mo> &#x222B;<!--INTEGRAL--> </mo>
              <mn> 0 </mn>
              <mn> 1 </mn>
            </msubsup>
            <mrow>
              <msup>
                <mi> &#x2147;<!--DOUBLE-STRUCK ITALIC SMALL E--> </mi>
                <mi> x </mi>
              </msup>
              <mo> &#x2062;<!--INVISIBLE TIMES--> </mo>
              <mrow>
                <mo> &#x2146;<!--DOUBLE-STRUCK ITALIC SMALL D--> </mo>
                <mi> x </mi>
              </mrow>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Int.new(
          Plurimath::Math::Symbol.new(" 0 "),
          Plurimath::Math::Symbol.new(" 1 "),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Power.new(
              Plurimath::Math::Symbol.new(" &#x2147; "),
              Plurimath::Math::Symbol.new(" x ")
            ),
            Plurimath::Math::Symbol.new(" &#x2062; "),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(" &#x2146; "),
              Plurimath::Math::Symbol.new(" x ")
            ])
          ])
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #47" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Ubrace.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(" x "),
              Plurimath::Math::Symbol.new(" + "),
              Plurimath::Math::Symbol.new(" y "),
              Plurimath::Math::Symbol.new(" + "),
              Plurimath::Math::Symbol.new(" z ")
            ]),
            { accentunder: true }
          ),
          Plurimath::Math::Function::Text.new("&#xa0;versus&#xa0;"),
          Plurimath::Math::Function::Ubrace.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(" x "),
              Plurimath::Math::Symbol.new(" + "),
              Plurimath::Math::Symbol.new(" y "),
              Plurimath::Math::Symbol.new(" + "),
              Plurimath::Math::Symbol.new(" z ")
            ]),
            { accentunder: false },
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #48" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Symbol.new(" x "),
            { accent: true },
          ),
          Plurimath::Math::Function::Text.new("&#xa0;versus&#xa0;"),
          Plurimath::Math::Function::Hat.new(
            Plurimath::Math::Symbol.new(" x "),
            { accent: false },
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #49" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Obrace.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(" x "),
              Plurimath::Math::Symbol.new(" + "),
              Plurimath::Math::Symbol.new(" y "),
              Plurimath::Math::Symbol.new(" + "),
              Plurimath::Math::Symbol.new(" z ")
            ]),
            { accent: true },
          ),
          Plurimath::Math::Function::Text.new("&#xa0;versus&#xa0;"),
          Plurimath::Math::Function::Obrace.new(
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(" x "),
              Plurimath::Math::Symbol.new(" + "),
              Plurimath::Math::Symbol.new(" y "),
              Plurimath::Math::Symbol.new(" + "),
              Plurimath::Math::Symbol.new(" z ")
            ]),
            { accent: false },
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #50" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Symbol.new(" &#x221e; "),
            Plurimath::Math::Function::Int.new(
              Plurimath::Math::Symbol.new(" 0 "),
            )
          ),
          Plurimath::Math::Function::Text.new("&#xa0;versus&#xa0;"),
          Plurimath::Math::Function::Int.new(
            Plurimath::Math::Symbol.new(" 0 "),
            Plurimath::Math::Symbol.new(" &#x221e; "),
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #51" do
    let(:exp) {
      <<~MATHML
        <math>
          <mrow>
            <mmultiscripts>
              <mi> F </mi>
              <mn> 1 </mn>
              <none/>
              <mprescripts/>
              <mn> 0 </mn>
              <none/>
            </mmultiscripts>
            <mo> &#x2061;<!--FUNCTION APPLICATION--> </mo>
            <mrow>
              <mo> ( </mo>
              <mrow>
                <mo> ; </mo>
                <mi> a </mi>
                <mo> ; </mo>
                <mi> z </mi>
              </mrow>
              <mo> ) </mo>
            </mrow>
          </mrow>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Multiscript.new(
            Plurimath::Math::Function::PowerBase.new(
              Plurimath::Math::Symbol.new(" F "),
              Plurimath::Math::Symbol.new(" 1 "),
            ),
            Plurimath::Math::Symbol.new(" 0 "),
          ),
          Plurimath::Math::Symbol.new(" &#x2061; "),
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new(" ( "),
            [
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new(" ; "),
                Plurimath::Math::Symbol.new(" a "),
                Plurimath::Math::Symbol.new(" ; "),
                Plurimath::Math::Symbol.new(" z "),
              ])
            ],
            Plurimath::Math::Symbol.new(" ) ")
          )
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #52" do
    let(:exp) {
      <<~MATHML
        <math>
          <mmultiscripts>
            <mi> R </mi>
            <mi> i </mi>
            <none/>
            <none/>
            <mi> j </mi>
            <mi> k </mi>
            <none/>
            <mi> l </mi>
            <none/>
          </mmultiscripts>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Multiscript.new(
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new(" R "),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(" i "),
              Plurimath::Math::Symbol.new(" k ")
            ]),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new(" j "),
              Plurimath::Math::Symbol.new(" l ")
            ]),
          ),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #53" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstyle dir="rtl">
            <mmultiscripts><mo>&#x0644;<!--ARABIC LETTER LAM--></mo>
              <mn>12</mn><none/>
              <mprescripts/>
              <none/><mn>5</mn>
            </mmultiscripts>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Multiscript.new(
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("&#x644;"),
            Plurimath::Math::Symbol.new("12")
          ),
          Plurimath::Math::Symbol.new("5")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #54" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Table.new(
          [
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("1")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("0")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("0")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("0")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("1")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("0")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("0")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("0")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("1")
              ])
            ])
          ],
          " ( ",
          " ) "
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #55" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Table.new([
          Plurimath::Math::Function::Tr.new([
            Plurimath::Math::Function::Td.new([
              Plurimath::Math::Function::Text.new(" (2.1) ")
            ]),
            Plurimath::Math::Function::Td.new([
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("E"),
                Plurimath::Math::Symbol.new("="),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new("m"),
                  Plurimath::Math::Symbol.new("&#x2062;"),
                  Plurimath::Math::Function::Power.new(
                    Plurimath::Math::Symbol.new("c"),
                    Plurimath::Math::Symbol.new("2")
                  )
                ])
              ])
            ])
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #56" do
    let(:exp) {
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
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Table.new([
          Plurimath::Math::Function::Tr.new([
            Plurimath::Math::Function::Td.new([
              Plurimath::Math::Formula.new([
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new(" 8.44 "),
                    Plurimath::Math::Symbol.new(" &#x2062; "),
                    Plurimath::Math::Symbol.new(" x ")
                  ]),
                  Plurimath::Math::Symbol.new(" + "),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new(" 55 "),
                    Plurimath::Math::Symbol.new(" &#x2062; "),
                    Plurimath::Math::Symbol.new(" y ")
                  ])
                ]),
                Plurimath::Math::Symbol.new(" = "),
                Plurimath::Math::Symbol.new(" 0 ")
              ])
            ])
          ]),
          Plurimath::Math::Function::Tr.new([
            Plurimath::Math::Function::Td.new([
              Plurimath::Math::Formula.new([
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new(" 3.1 "),
                    Plurimath::Math::Symbol.new(" &#x2062; "),
                    Plurimath::Math::Symbol.new(" x ")
                  ]),
                  Plurimath::Math::Symbol.new(" - "),
                  Plurimath::Math::Formula.new([
                    Plurimath::Math::Symbol.new(" 0.7 "),
                    Plurimath::Math::Symbol.new(" &#x2062; "),
                    Plurimath::Math::Symbol.new(" y ")
                  ])
                ]),
                Plurimath::Math::Symbol.new(" = "),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Symbol.new(" - "),
                  Plurimath::Math::Symbol.new(" 1.1 ")
                ])
              ])
            ])
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #57" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstack>
            <mn>424</mn>
            <msrow>
              <mo>+</mo>
              <mn>33</mn>
            </msrow>
            <msline/>
          </mstack>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Stackrel.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("424"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("+"),
              Plurimath::Math::Symbol.new("33")
            ]),
            Plurimath::Math::Function::Msline.new
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #58" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstack>
            <mn>123</mn>
            <msrow>
              <mn>456</mn>
              <mo>+</mo>
            </msrow>
            <msline/>
            <mn>579</mn>
          </mstack>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Stackrel.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("123"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("456"),
              Plurimath::Math::Symbol.new("+")
            ]),
            Plurimath::Math::Function::Msline.new,
            Plurimath::Math::Symbol.new("579")
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #59" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstack>
            <msrow>
              <mn>456</mn>
              <mo>+</mo>
            </msrow>
            <msline/>
          </mstack>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Stackrel.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("456"),
              Plurimath::Math::Symbol.new("+")
            ]),
            Plurimath::Math::Function::Msline.new
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #60" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstack>
            <mscarries crossout='updiagonalstrike'>
              <mn>2</mn>
              <mn>12</mn>
              <mscarry crossout='none'>
                <none/>
              </mscarry>
            </mscarries>
            <mn>2,327</mn>
            <msrow>
              <mo>-</mo>
              <mn> 1,156</mn>
            </msrow>
            <msline/>
            <mn>1,171</mn>
          </mstack>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Stackrel.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Scarries.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("2"),
                Plurimath::Math::Symbol.new("12")
              ])
            ),
            Plurimath::Math::Symbol.new("2,327"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Symbol.new(" 1,156")
            ]),
            Plurimath::Math::Function::Msline.new,
            Plurimath::Math::Symbol.new("1,171")
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #61" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstack>
            <mscarries location='nw'>
              <none/>
              <mscarry crossout='updiagonalstrike' location='n'> <mn>2</mn> </mscarry>
              <mn>1</mn>
              <none/>
            </mscarries>
            <mn>2,327</mn>
            <msrow> <mo>-</mo> <mn> 1,156</mn> </msrow>
            <msline/>
            <mn>1,171</mn>
          </mstack>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Stackrel.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Scarries.new(
              Plurimath::Math::Symbol.new("1")
            ),
            Plurimath::Math::Symbol.new("2,327"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Symbol.new(" 1,156")
            ]),
            Plurimath::Math::Function::Msline.new,
            Plurimath::Math::Symbol.new("1,171")
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #62" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstack>
            <mscarries>
              <mscarry crossout='updiagonalstrike'><none/></mscarry>
              <menclose notation='bottom'> <mn>10</mn> </menclose>
            </mscarries>
            <mn>52</mn>
            <msrow> <mo>-</mo> <mn> 7</mn> </msrow>
            <msline/>
            <mn>45</mn>
          </mstack>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Stackrel.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Scarries.new(
              Plurimath::Math::Function::Menclose.new(
                "bottom",
                Plurimath::Math::Symbol.new("10")
              )
            ),
            Plurimath::Math::Symbol.new("52"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Symbol.new(" 7")
            ]),
            Plurimath::Math::Function::Msline.new,
            Plurimath::Math::Symbol.new("45")
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #63" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstack>
            <msgroup>
              <mn>123</mn>
              <msrow><mo>&#xD7;<!--MULTIPLICATION SIGN--></mo><mn>321</mn></msrow>
            </msgroup>
            <msline/>
            <msgroup shift="1">
              <mn>123</mn>
              <mn>246</mn>
              <mn>369</mn>
            </msgroup>
            <msline/>
          </mstack>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Stackrel.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Msgroup.new([
              Plurimath::Math::Symbol.new("123"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("&#xd7;"),
                Plurimath::Math::Symbol.new("321")
              ])
            ]),
            Plurimath::Math::Function::Msline.new,
            Plurimath::Math::Function::Msgroup.new([
              Plurimath::Math::Symbol.new("123"),
              Plurimath::Math::Symbol.new("246"),
              Plurimath::Math::Symbol.new("369")
            ]),
            Plurimath::Math::Function::Msline.new
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #64" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstack>
            <mscarries><mn>1</mn><mn>1</mn><none/></mscarries>
            <mscarries><mn>1</mn><mn>1</mn><none/></mscarries>
            <mn>1,234</mn>
            <msrow><mo>&#xD7;<!--MULTIPLICATION SIGN--></mo><mn>4,321</mn></msrow>
            <msline/>

            <mscarries position='2'>
              <mn>1</mn>
              <none/>
              <mn>1</mn>
              <mn>1</mn>
              <mn>1</mn>
              <none/>
              <mn>1</mn>
            </mscarries>
            <msgroup shift="1">
              <mn>1,234</mn>
              <mn>24,68</mn>
              <mn>370,2</mn>
              <msrow position="1"> <mn>4,936</mn> </msrow>
            </msgroup>
            <msline/>

            <mn>5,332,114</mn>
          </mstack>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Stackrel.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Scarries.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("1"),
                Plurimath::Math::Symbol.new("1")
              ])
            ),
            Plurimath::Math::Function::Scarries.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("1"),
                Plurimath::Math::Symbol.new("1")
              ])
            ),
            Plurimath::Math::Symbol.new("1,234"),
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("&#xd7;"),
              Plurimath::Math::Symbol.new("4,321")
            ]),
            Plurimath::Math::Function::Msline.new,
            Plurimath::Math::Function::Scarries.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("1"),
                Plurimath::Math::Symbol.new("1"),
                Plurimath::Math::Symbol.new("1"),
                Plurimath::Math::Symbol.new("1"),
                Plurimath::Math::Symbol.new("1")
              ])
            ),
            Plurimath::Math::Function::Msgroup.new([
              Plurimath::Math::Symbol.new("1,234"),
              Plurimath::Math::Symbol.new("24,68"),
              Plurimath::Math::Symbol.new("370,2"),
              Plurimath::Math::Formula.new([
                Plurimath::Math::Symbol.new("4,936")
              ])
            ]),
            Plurimath::Math::Function::Msline.new,
            Plurimath::Math::Symbol.new("5,332,114")
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #65" do
    let(:exp) {
      <<~MATHML
        <math>
          <mlongdiv longdivstyle="lefttop">
            <mn> 3 </mn>
            <mn> 435.3</mn>

            <mn> 1306</mn>

            <msgroup position="2" shift="-1">
              <msgroup>
                <mn> 12</mn>
                <msline length="2"/>
              </msgroup>
              <msgroup>
                <mn> 10</mn>
                <mn> 9</mn>
                <msline length="2"/>
              </msgroup>
              <msgroup>
                <mn> 16</mn>
                <mn> 15</mn>
                <msline length="2"/>
                <mn> 1.0</mn>           <!-- aligns on '.', not the right edge ('0') -->
              </msgroup>
              <msgroup position='-1'>   <!-- extra shift to move to the right of the "." -->
                 <mn> 9</mn>
                <msline length="3"/>
                <mn> 1</mn>
              </msgroup>
            </msgroup>
          </mlongdiv>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Longdiv.new([
          Plurimath::Math::Symbol.new(" 3 "),
          Plurimath::Math::Symbol.new(" 435.3"),
          Plurimath::Math::Symbol.new(" 1306"),
          Plurimath::Math::Function::Msgroup.new([
            Plurimath::Math::Function::Msgroup.new([
              Plurimath::Math::Symbol.new(" 12"),
              Plurimath::Math::Function::Msline.new
            ]),
            Plurimath::Math::Function::Msgroup.new([
              Plurimath::Math::Symbol.new(" 10"),
              Plurimath::Math::Symbol.new(" 9"),
              Plurimath::Math::Function::Msline.new
            ]),
            Plurimath::Math::Function::Msgroup.new([
              Plurimath::Math::Symbol.new(" 16"),
              Plurimath::Math::Symbol.new(" 15"),
              Plurimath::Math::Function::Msline.new,
              Plurimath::Math::Symbol.new(" 1.0")
            ]),
            Plurimath::Math::Function::Msgroup.new([
              Plurimath::Math::Symbol.new(" 9"),
              Plurimath::Math::Function::Msline.new,
              Plurimath::Math::Symbol.new(" 1")
            ])
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #66" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstyle decimalpoint="&#x066B;"><!--ARABIC DECIMAL SEPARATOR-->
            <mlongdiv longdivstyle="stackedleftlinetop">
              <mn> &#x0663;<!--ARABIC-INDIC DIGIT THREE--> </mn>
              <mn> &#x0664;<!--ARABIC-INDIC DIGIT FOUR-->&#x0663;<!--ARABIC-INDIC DIGIT THREE-->&#x0665;<!--ARABIC-INDIC DIGIT FIVE-->&#x066B;<!--ARABIC DECIMAL SEPARATOR-->&#x0663;<!--ARABIC-INDIC DIGIT THREE--></mn>

              <mn> &#x0661;<!--ARABIC-INDIC DIGIT ONE-->&#x0663;<!--ARABIC-INDIC DIGIT THREE-->&#x0660;<!--ARABIC-INDIC DIGIT ZERO-->&#x0666;<!--ARABIC-INDIC DIGIT SIX--></mn>
              <msgroup position="2" shift="-1">
                <msgroup>
                  <mn> &#x0661;<!--ARABIC-INDIC DIGIT ONE-->&#x0662;<!--ARABIC-INDIC DIGIT TWO--></mn>
                  <msline length="2"/>
                </msgroup>
                <msgroup>
                  <mn> &#x0661;<!--ARABIC-INDIC DIGIT ONE-->&#x0660;<!--ARABIC-INDIC DIGIT ZERO--></mn>
                  <mn> &#x0669;<!--ARABIC-INDIC DIGIT NINE--></mn>
                  <msline length="2"/>
                </msgroup>
                <msgroup>
                  <mn> &#x0661;<!--ARABIC-INDIC DIGIT ONE-->&#x0666;<!--ARABIC-INDIC DIGIT SIX--></mn>
                  <mn> &#x0661;<!--ARABIC-INDIC DIGIT ONE-->&#x0665;<!--ARABIC-INDIC DIGIT FIVE--></mn>
                  <msline length="2"/>
                    <mn> &#x0661;<!--ARABIC-INDIC DIGIT ONE-->&#x066B;<!--ARABIC DECIMAL SEPARATOR-->&#x0660;<!--ARABIC-INDIC DIGIT ZERO--></mn>
               </msgroup>
               <msgroup position='-1'>
                   <mn> &#x0669;<!--ARABIC-INDIC DIGIT NINE--></mn>
                  <msline length="3"/>
                  <mn> &#x0661;<!--ARABIC-INDIC DIGIT ONE--></mn>
                </msgroup>
              </msgroup>
            </mlongdiv>
          </mstyle>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Longdiv.new([
          Plurimath::Math::Number.new(" &#x663; "),
          Plurimath::Math::Number.new(" &#x664;&#x663;&#x665;&#x66b;&#x663;"),
          Plurimath::Math::Number.new(" &#x661;&#x663;&#x660;&#x666;"),
          Plurimath::Math::Function::Msgroup.new([
            Plurimath::Math::Function::Msgroup.new([
              Plurimath::Math::Number.new(" &#x661;&#x662;"),
              Plurimath::Math::Function::Msline.new
            ]),
            Plurimath::Math::Function::Msgroup.new([
              Plurimath::Math::Number.new(" &#x661;&#x660;"),
              Plurimath::Math::Number.new(" &#x669;"),
              Plurimath::Math::Function::Msline.new
            ]),
            Plurimath::Math::Function::Msgroup.new([
              Plurimath::Math::Number.new(" &#x661;&#x666;"),
              Plurimath::Math::Number.new(" &#x661;&#x665;"),
              Plurimath::Math::Function::Msline.new,
              Plurimath::Math::Number.new(" &#x661;&#x66b;&#x660;")
            ]),
            Plurimath::Math::Function::Msgroup.new([
              Plurimath::Math::Number.new(" &#x669;"),
              Plurimath::Math::Function::Msline.new,
              Plurimath::Math::Number.new(" &#x661;")
            ])
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #67" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstack stackalign="right">
            <msline length="1"/>
            <mn> 0.3333 </mn>
          </mstack>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Stackrel.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Msline.new,
            Plurimath::Math::Symbol.new(" 0.3333 ")
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #68" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstack stackalign="right">
            <msline length="6"/>
            <mn> 0.142857 </mn>
          </mstack>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Stackrel.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Msline.new,
            Plurimath::Math::Symbol.new(" 0.142857 ")
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #69" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstack stackalign="right">
            <mn> 0.142857 </mn>
            <msline length="6"/>
          </mstack>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Stackrel.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new(" 0.142857 "),
            Plurimath::Math::Function::Msline.new,
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #3 example #70" do
    let(:exp) {
      <<~MATHML
        <math>
          <mstack stackalign="right">
            <msrow>
              <mo>.</mo>
              <none/><none/>
              <none/><none/>
              <mo>.</mo>
            </msrow>
            <mn> 0.142857 </mn>
          </mstack>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Stackrel.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("."),
              Plurimath::Math::Symbol.new(".")
            ]),
            Plurimath::Math::Symbol.new(" 0.142857 ")
          ]),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end
end
