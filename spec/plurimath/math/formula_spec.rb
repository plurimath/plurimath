require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Formula do
  describe ".initialize" do
    subject(:formula) { described_class.new(exp) }

    context "contains simple string" do
      let(:exp) { "theta" }

      it "returns true" do
        expected_value = described_class.new("theta")
        expect(formula).to eq(expected_value)
      end
    end

    context "contains simple string" do
      let(:exp) { "Theta" }

      expected_value = described_class.new("theta")
      it "returns false" do
        expect(formula).not_to eq(expected_value)
      end
    end
  end

  describe ".type_error!" do
    subject(:formula) { Plurimath::Math.parse(string, :asciimath) }

    context "raises invalid type error when to_display is called with unsupported type plurimath#310" do
      let(:string) { "theta" }

      it "raises an error" do
        expect { formula.to_display(:html) }.to raise_error(
          Plurimath::Math::InvalidTypeError,
          "Invalid type provided: html. Must be one of omml, latex, mathml, asciimath, unicodemath, formula.",
        )
      end
    end
  end

  describe ".==" do
    subject(:formula) { described_class.new(exp) }

    context "contains simple string" do
      let(:exp) { "theta" }

      it "returns true" do
        expected_value = described_class.new("theta")
        expect(formula).to eq(expected_value)
      end
    end

    context "contains simple string" do
      let(:exp) { "Theta" }

      it "returns false" do
        expected_value = described_class.new("theta")
        expect(formula).not_to eq(expected_value)
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { Plurimath::Asciimath::Parser.new(exp).parse.to_asciimath }

    context "contains string" do
      it "returns Formula object" do
        expected_value = described_class.new("1 + 2")
        expect(expected_value).to be_a(described_class)
      end
    end

    context "contains string" do
      it "returns Formula object" do
        expected_value = described_class.new("1 + 2")
        expect(expected_value.value).to eql(["1 + 2"])
      end
    end

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-77-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-85-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-93-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-101-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-109-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-117-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-125-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-133-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-141-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-149-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-157-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-165-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-173-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-181-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-189-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-197-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-205-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-213-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-221-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-229-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-237-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-245-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-253-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-261-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-269-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-277-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-285-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-293-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-301-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-309-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-317-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-325-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-333-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-341-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-349-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-357-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-365-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-373-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-381-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-389-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-397-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-405-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-413-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-421-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-429-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-437-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-445-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-453-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-461-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-469-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-477-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-485-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-493-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-501-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-509-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-517-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-525-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-533-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-541-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-549-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-557-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-565-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-573-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-581-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-589-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-597-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-605-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-613-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-621-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-629-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-637-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-645-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-653-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-661-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-669-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-677-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-685-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-693-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-701-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-709-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-717-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-725-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-733-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-741-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-749-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-757-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-765-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-773-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-781-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-789-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-797-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-805-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-813-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-821-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-829-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-837-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-845-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-853-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-861-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-869-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-877-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-885-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-893-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-901-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-909-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-917-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-925-1"

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-943-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      described_class.new(exp).to_mathml(unary_function_spacing: false)
    end

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-967-1"
  end

  describe ".validate_function_formula" do
    subject(:formula) { described_class.new(exp).validate_function_formula }

    context "contains array of values left, right and value" do
      let(:exp) do
        [
          Plurimath::Math::Function::Left.new("("),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Function::Right.new(")"),
        ]
      end

      it "expects false in return" do
        expect(formula).to be(false)
      end
    end

    context "contains array of values only left and right" do
      let(:exp) do
        [
          Plurimath::Math::Function::Text.new(")"),
        ]
      end

      it "expects true in return" do
        expect(formula).to be(true)
      end
    end
  end

  context "contains formatter option's conversion" do
    describe ".to_mathml(formatter:)" do
      subject(:formula) do
        described_class.new(exp).to_mathml(formatter: formatter)
      end

      context "contains array of numbers only" do
        let(:exp) do
          [
            Plurimath::Math::Number.new("331.4677"),
            Plurimath::Math::Number.new("123.4567"),
          ]
        end

        it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-1090-1"

        context "with compact formatter" do
          let(:formatter) { FormulaSpecFormatters::CustomFormatter.new }

          it "returns mathml string with formatted numbers using compact formatter" do
            expected_value = <<~MATHML
              <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
                <mstyle displaystyle="true">
                  <mn>3&gt;3&gt;1^46;77</mn>
                  <mn>1&gt;2&gt;3^45;67</mn>
                </mstyle>
              </math>
            MATHML
            expect(formula).to be_xml_equivalent_to(expected_value)
          end
        end
      end
    end

    describe ".to_omml(formatter:)" do
      subject(:formula) do
        described_class.new(exp).to_omml(formatter: formatter)
      end

      context "contains array of numbers only" do
        let(:exp) do
          [
            Plurimath::Math::Number.new("331.4677"),
            Plurimath::Math::Number.new("123.4567"),
          ]
        end

        it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-1137-1"

        context "with compact formatter" do
          let(:formatter) { FormulaSpecFormatters::CustomFormatter.new }

          it "returns OMML string with formatted numbers using compact formatter" do
            expected_value = <<~OMML
              <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
                <m:oMath>
                  <m:r>
                    <m:t>3&gt;3&gt;1^46;77</m:t>
                  </m:r>
                  <m:r>
                    <m:t>1&gt;2&gt;3^45;67</m:t>
                  </m:r>
                </m:oMath>
              </m:oMathPara>
            OMML
            expect(formula).to be_xml_equivalent_to(expected_value)
          end
        end
      end
    end

    describe ".to_html(formatter:)" do
      subject(:formula) do
        described_class.new(exp).to_html(formatter: formatter)
      end

      context "contains array of numbers only" do
        let(:exp) do
          [
            Plurimath::Math::Number.new("331.4677"),
            Plurimath::Math::Number.new("123.4567"),
          ]
        end

        it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-1192-1"

        context "with compact formatter" do
          let(:formatter) { FormulaSpecFormatters::CustomFormatter.new }

          it "returns html string with formatted numbers using compact formatter" do
            expected_value = "3>3>1^46;77 1>2>3^45;67"
            expect(formula).to be_xml_equivalent_to(expected_value)
          end
        end
      end
    end

    describe ".to_unicodemath(formatter:)" do
      subject(:formula) do
        described_class.new(exp).to_unicodemath(formatter: formatter)
      end

      context "contains array of numbers only" do
        let(:exp) do
          [
            Plurimath::Math::Number.new("331.4677"),
            Plurimath::Math::Number.new("123.4567"),
          ]
        end

        it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-1225-1"

        context "with compact formatter" do
          let(:formatter) { FormulaSpecFormatters::CustomFormatter.new }

          it "returns unicodemath string with formatted numbers using compact formatter" do
            expected_value = "3>3>1^46;77 1>2>3^45;67"
            expect(formula).to be_xml_equivalent_to(expected_value)
          end
        end
      end
    end

    describe ".to_latex(formatter:)" do
      subject(:formula) do
        described_class.new(exp).to_latex(formatter: formatter)
      end

      context "contains array of numbers only" do
        let(:exp) do
          [
            Plurimath::Math::Number.new("331.4677"),
            Plurimath::Math::Number.new("123.4567"),
          ]
        end

        it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-1258-1"

        context "with compact formatter" do
          let(:formatter) { FormulaSpecFormatters::CustomFormatter.new }

          it "returns latex string with formatted numbers using compact formatter" do
            expected_value = "3>3>1^46;77 1>2>3^45;67"
            expect(formula).to be_xml_equivalent_to(expected_value)
          end
        end
      end
    end

    describe ".to_asciimath(formatter:)" do
      subject(:formula) do
        described_class.new(exp).to_asciimath(formatter: formatter)
      end

      context "contains array of numbers only" do
        let(:exp) do
          [
            Plurimath::Math::Number.new("331.4677"),
            Plurimath::Math::Number.new("123.4567"),
          ]
        end

        it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-1291-1"

        context "with compact formatter" do
          let(:formatter) { FormulaSpecFormatters::CustomFormatter.new }

          it "returns asciimath string with formatted numbers using compact formatter" do
            expected_value = "3>3>1^46;77 1>2>3^45;67"
            expect(formula).to be_xml_equivalent_to(expected_value)
          end
        end
      end
    end
  end

  context "contextual number formatting (issue #294)" do
    let(:exp) do
      [
        Plurimath::Math::Number.new("2024"),
        Plurimath::Math::Symbols::Symbol.new("+"),
        Plurimath::Math::Number.new("1000000"),
      ]
    end
    let(:formula_obj) { described_class.new(exp) }

    describe "formatter receives formula and number node" do
      let(:received_formula) { [] }
      let(:received_numbers) { [] }
      let(:spy) do
        FormulaSpecFormatters::SpyFormatter.new(
          on_format: proc { |formula, number|
            received_formula << formula
            received_numbers << number
          },
        )
      end

      it "passes the root formula and number nodes to format_number" do
        formula_obj.to_latex(formatter: spy)

        expect(received_formula.first).to be_a(described_class)
        expect(received_formula.first).to eq(formula_obj)
        expect(received_numbers.first).to be_a(Plurimath::Math::Number)
        expect(received_numbers.first.value).to eq("2024")
        expect(received_numbers[1].value).to eq("1000000")
      end

      it "passes the formula via to_latex" do
        formula_obj.to_latex(formatter: spy)
        expect(received_formula.first).to eq(formula_obj)
      end

      it "passes the formula via to_asciimath" do
        formula_obj.to_asciimath(formatter: spy)
        expect(received_formula.first).to eq(formula_obj)
      end

      it "passes the formula via to_html" do
        formula_obj.to_html(formatter: spy)
        expect(received_formula.first).to eq(formula_obj)
      end

      it "passes the formula via to_unicodemath" do
        formula_obj.to_unicodemath(formatter: spy)
        expect(received_formula.first).to eq(formula_obj)
      end

      it "passes the formula via to_mathml" do
        formula_obj.to_mathml(formatter: spy)
        expect(received_formula.first).to eq(formula_obj)
      end

      it "passes the formula via to_omml" do
        formula_obj.to_omml(formatter: spy)
        expect(received_formula.first).to eq(formula_obj)
      end
    end

    describe "year formatter example from issue #294" do
      let(:year_formatter) { FormulaSpecFormatters::YearFormatter.new }

      it "skips formatting for year-like numbers" do
        result = formula_obj.to_latex(formatter: year_formatter)
        expect(result).to eq("2024 + 1,000,000")
      end

      it "formats all numbers when none are years" do
        non_year_exp = [
          Plurimath::Math::Number.new("50000"),
          Plurimath::Math::Symbols::Symbol.new("+"),
          Plurimath::Math::Number.new("1000000"),
        ]
        formula_obj = described_class.new(non_year_exp)
        result = formula_obj.to_latex(formatter: year_formatter)
        expect(result).to eq("50,000 + 1,000,000")
      end

      it "handles boundary values correctly" do
        { "1800" => "1,800", "1801" => "1801", "2199" => "2199",
          "2200" => "2,200" }.each do |input, expected|
          formula_obj = described_class.new([Plurimath::Math::Number.new(input)])
          result = formula_obj.to_latex(formatter: year_formatter)
          expect(result).to eq(expected),
                            "Expected #{input} -> #{expected}, got #{result}"
        end
      end
    end

    it_behaves_like "shared renderer fixture", "renderer-math-formula-formula-1405-1"
  end
end

module FormulaSpecFormatters
  class CustomFormatter < Plurimath::Formatter::Standard
    DEFAULT_OPTIONS = {
      fraction_group_digits: 2,
      fraction_group: ";",
      group_digits: 1,
      decimal: "^",
      group: ">",
    }.freeze
  end

  class YearFormatter < Plurimath::Formatter::Standard
    def format_number(_formula, number, format: {})
      int_value = Integer(number.value, exception: false)
      if int_value && int_value > 1800 && int_value < 2200
        number.value.to_s
      else
        localized_number(number.value.to_s, format: format)
      end
    end
  end

  class SpyFormatter < Plurimath::Formatter::Standard
    def initialize(on_format: nil)
      super()
      @on_format = on_format
    end

    def format_number(formula, number, format: {})
      @on_format&.call(formula, number)
      localized_number(number.value.to_s, format: format)
    end
  end
end
