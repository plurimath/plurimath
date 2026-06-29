# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Base-prefixed number parsing" do
  before do
    @previous_formatter = Plurimath.configuration.number_formatter
    Plurimath.configuration.number_formatter = Plurimath::Formatter::Standard.new
  end

  after { Plurimath.configuration.number_formatter = @previous_formatter }

  shared_examples "parses base-prefixed numbers" do |type|
    it "parses hex (0x) with correct value and base", :aggregate_failures do
      number = Plurimath::Math.parse("0xFF", type).value.first
      expect(number).to be_a(Plurimath::Math::Number)
      expect(number.value).to eq("FF")
      expect(number.base).to eq(16)
    end

    it "parses uppercase hex (0X) prefix" do
      number = Plurimath::Math.parse("0XAB", type).value.first
      expect(number).to be_a(Plurimath::Math::Number)
      expect(number.base).to eq(16)
    end

    it "parses lowercase hex digits" do
      number = Plurimath::Math.parse("0xff", type).value.first
      expect(number.value).to eq("ff")
      expect(number.base).to eq(16)
    end

    it "parses binary (0b) with decimal value stored" do
      number = Plurimath::Math.parse("0b1010", type).value.first
      expect(number).to be_a(Plurimath::Math::Number)
      expect(number.value).to eq("10")
      expect(number.base).to eq(2)
    end

    it "parses uppercase binary (0B) prefix" do
      number = Plurimath::Math.parse("0B111", type).value.first
      expect(number.value).to eq("7")
      expect(number.base).to eq(2)
    end

    it "parses octal (0o) with decimal value stored" do
      number = Plurimath::Math.parse("0o17", type).value.first
      expect(number).to be_a(Plurimath::Math::Number)
      expect(number.value).to eq("15")
      expect(number.base).to eq(8)
    end

    it "parses uppercase octal (0O) prefix" do
      number = Plurimath::Math.parse("0O77", type).value.first
      expect(number.value).to eq("63")
      expect(number.base).to eq(8)
    end

    it "does not attach base to plain decimal numbers" do
      number = Plurimath::Math.parse("255", type).value.first
      expect(number).to be_a(Plurimath::Math::Number)
      expect(number.base).to be_nil
    end

    it "parses zero as plain decimal" do
      number = Plurimath::Math.parse("0", type).value.first
      expect(number.base).to be_nil
    end
  end

  describe "AsciiMath" do
    it_behaves_like "parses base-prefixed numbers", :asciimath
  end

  describe "LaTeX" do
    it_behaves_like "parses base-prefixed numbers", :latex
  end

  describe "UnicodeMath" do
    it_behaves_like "parses base-prefixed numbers", :unicode
  end

  describe "HTML" do
    it_behaves_like "parses base-prefixed numbers", :html
  end

  describe "round-trip rendering" do
    it "renders hex back to structured AsciiMath" do
      formula = Plurimath::Math.parse("0xFF", :asciimath)
      expect(formula.to_asciimath).to eq("ff_(16)")
    end

    it "renders hex back to structured LaTeX" do
      formula = Plurimath::Math.parse("0xFF", :asciimath)
      expect(formula.to_latex).to eq("\\mathrm{ff}_{16}")
    end

    it "renders hex back to structured HTML" do
      formula = Plurimath::Math.parse("0xFF", :asciimath)
      expect(formula.to_html).to eq("ff<sub>16</sub>")
    end

    it "renders binary back to structured AsciiMath" do
      formula = Plurimath::Math.parse("0b1010", :asciimath)
      expect(formula.to_asciimath).to eq("1,010_(2)")
    end

    it "renders octal back to structured AsciiMath" do
      formula = Plurimath::Math.parse("0o17", :asciimath)
      expect(formula.to_asciimath).to eq("17_(8)")
    end

    it "renders hex with MathML msub structure" do
      formula = Plurimath::Math.parse("0xFF", :asciimath)
      number = formula.value.first
      xml = Plurimath.xml_engine.dump(
        number.to_mathml_without_math_tag(false,
                                          options: { formatter: Plurimath::Formatter::Standard.new }),
        indent: 2,
      )
      expect(xml).to be_xml_equivalent_to("<msub><mn>ff</mn><mn>16</mn></msub>")
    end
  end
end
