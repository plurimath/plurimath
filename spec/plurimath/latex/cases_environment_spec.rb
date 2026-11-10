# frozen_string_literal: true

require "spec_helper"

RSpec.describe "LaTeX cases environment" do
  let(:rows) { '1 & x>0\\\\0 & x\le 0' }
  let(:cases_latex) { "\\begin{cases}1 & x > 0 \\\\ 0 & x \\le 0\\end{cases}" }

  describe "the bare environment" do
    subject(:formula) { Plurimath::Math.parse("\\begin{cases}#{rows}\\end{cases}", :latex) }

    it "reads as one Table::Cases of two rows" do
      table = formula.value.first
      expect(formula.value.size).to eq(1)
      expect(table).to be_a(Plurimath::Math::Function::Table::Cases)
      expect(table.value.size).to eq(2)
      expect(table.value.map { |tr| tr.parameter_one.size }).to eq([2, 2])
      expect(table.open_paren).to be_a(Plurimath::Math::Symbols::Paren::Lcurly)
    end

    it "writes every format" do
      expect(formula.to_latex).to eq(cases_latex)
      expect(formula.to_asciimath).to eq("{[1, x gt 0], [0, x le 0]:}")
      expect(formula.to_unicodemath).to eq("Ⓒ(1&x>0@0&x≤0)")
      expect(formula.to_html).to eq(
        "<table><tr><td>1</td><td>x&#x3e;0</td></tr><tr><td>0</td><td>x&#x2264;0</td></tr></table>",
      )
      mathml = formula.to_mathml
      expect(mathml.scan("<mtr>").size).to eq(2)
      expect(mathml.scan("<mtd>").size).to eq(4)
      expect(mathml).to include("<mo>&#x2264;</mo>")
      omml = formula.to_omml
      expect(omml.scan("<m:mr>").size).to eq(2)
      expect(omml).to include("<m:t>&#x2264;</m:t>")
    end

    it "round-trips through LaTeX" do
      again = Plurimath::Math.parse(formula.to_latex, :latex)
      expect(again.value.first).to be_a(Plurimath::Math::Function::Table::Cases)
      expect(again.to_latex).to eq(cases_latex)
    end
  end

  describe "after an equation head" do
    subject(:formula) do
      Plurimath::Math.parse("f(x)=\\begin{cases}#{rows}\\end{cases}", :latex)
    end

    it "keeps the head and reads the environment as Table::Cases" do
      expect(formula.value.last).to be_a(Plurimath::Math::Function::Table::Cases)
      expect(formula.value.size).to eq(4)
    end

    it "writes every format" do
      expect(formula.to_latex).to eq("f ( x ) = #{cases_latex}")
      expect(formula.to_asciimath).to eq("f (x) = {[1, x gt 0], [0, x le 0]:}")
      expect(formula.to_unicodemath).to eq("f (x) = Ⓒ(1&x>0@0&x≤0)")
      expect(formula.to_html).to start_with("f <i>(</i>x<i>)</i> = <table>")
      expect(formula.to_mathml).to include("<mi>f</mi>").and include("<mtable>")
      expect(formula.to_omml).to include("<m:t>f</m:t>").and include("<m:m>")
    end

    it "round-trips through LaTeX" do
      expect(Plurimath::Math.parse(formula.to_latex, :latex).to_latex).to eq(formula.to_latex)
    end
  end
end
