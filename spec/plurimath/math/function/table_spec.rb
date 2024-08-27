require "spec_helper"

RSpec.describe Plurimath::Math::Function::Table do

  describe ".initialize" do
    subject(:table) { Plurimath::Math::Function::Table.new(table_values, '{', '}') }

    context "initialize Table object" do
      let(:table_values) { ['70'] }

      it 'returns instance of Table' do
        expect(table).to be_a(Plurimath::Math::Function::Table)
      end

      it 'initializes Table object' do
        expect(table.value).to eql(['70'])
        expect(table.open_paren).to eq(Plurimath::Math::Symbols::Paren::Lcurly.new)
        expect(table.close_paren).to eq(Plurimath::Math::Symbols::Paren::Rcurly.new)
        expect(table.options).to eql({})
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new([first_value]).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) do
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Symbols::Kappa.new,
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Symbols::Symbol.new("n"),
          ])
        ])
      end

      it "returns asciimath string" do
        expect(formula).to eq("[[kappa, n]]")
      end
    end

    context "contains Number as value" do
      let(:first_value) do
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Symbols::Kappa.new,
          ])
        ])
      end

      it "returns asciimath string" do
        expect(formula).to eq("[[kappa]]")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Symbols::Kappa.new,
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Sum.new(
                Plurimath::Math::Symbols::Ampersand.new,
                Plurimath::Math::Function::Text.new("so"),
              )
            ])
          ])
        ])
      end

      it "returns asciimath string" do
        expect(formula).to eq("[[kappa, sum_(&)^(\"so\")]]")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new([first_value]).
          to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Symbol as value" do
      let(:first_value) do
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Symbols::Kappa.new,
          ]),
        ])
      end

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mtable>
            <mtr>
              <mtd>
                <mi>&#x3ba;</mi>
              </mtd>
            </mtr>
          </mtable>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) do
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Symbols::Kappa.new,
            Plurimath::Math::Number.new("70"),
          ]),
        ])
      end

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mtable>
            <mtr>
              <mtd>
                <mi>&#x3ba;</mi>
                <mn>70</mn>
              </mtd>
            </mtr>
          </mtable>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Symbols::Kappa.new,
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Sum.new(
                Plurimath::Math::Symbols::Ampersand.new,
                Plurimath::Math::Function::Text.new("so"),
              )
            ])
          ])
        ])
      end

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mtable>
            <mtr>
              <mtd>
                <mi>&#x3ba;</mi>
              </mtd>
              <mtd>
                <mrow>
                  <munderover>
                    <mo>&#x2211;</mo>
                    <mo>&</mo>
                    <mtext>so</mtext>
                  </munderover>
                </mrow>
              </mtd>
            </mtr>
          </mtable>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new([first_value]).to_latex }

    context "contains Symbol as value" do
      let(:first_value) do
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Symbols::Kappa.new,
          ]),
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("\\left .\\begin{matrix}{a}\\kappa\\end{matrix}\\right .")
      end
    end

    context "contains Number as value" do
      let(:first_value) do
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Symbols::Kappa.new,
            Plurimath::Math::Number.new("70"),
          ]),
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("\\left .\\begin{matrix}{a}\\kappa 70\\end{matrix}\\right .")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Symbols::Kappa.new,
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Sum.new(
                Plurimath::Math::Symbols::Ampersand.new,
                Plurimath::Math::Function::Text.new("so"),
              )
            ])
          ])
        ])
      end
      it "returns mathml string" do
        expect(formula).to eql("\\left .\\begin{matrix}{aa}\\kappa & \\sum_{\\&}^{\\text{so}}\\end{matrix}\\right .")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new([first_value]).to_html }

    context "contains Tr and Td as value" do
      let(:first_value) do
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Symbols::Kappa.new,
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Sum.new(
                Plurimath::Math::Symbols::Ampersand.new,
                Plurimath::Math::Function::Text.new("so"),
              )
            ])
          ])
        ])
      end

      it "returns mathml string" do
        expected_value = <<~HTML
          <table>
            <tr>
              <td>&#x3ba;</td>
              <td>
                <i>&sum;</i>
                <sub>&</sub>
                <sup>so</sup>
              </td>
            </tr>
          </table>
        HTML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Formula and no tr or td" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      it "returns mathml string" do
        expected_value = <<~HTML
          <table>
            <i>&sum;</i>
            <sub>&</sub>
            <sup>so</sup>
          </table>
        HTML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end
end
