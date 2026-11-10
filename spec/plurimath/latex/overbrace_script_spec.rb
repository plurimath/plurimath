require "spec_helper"

RSpec.describe "LaTeX \\overbrace with one script" do
  {
    '\overbrace{x}^{n}' => "obrace(x)^(n)",
    '\overbrace{x}_{n}' => "obrace(x)_(n)",
    '\overbrace{x}_{n}^{m}' => "obrace(x)_(n)^(m)",
  }.each do |latex, asciimath|
    it "reads and writes #{latex}" do
      formula = Plurimath::Math.parse(latex, :latex)
      expect(formula.to_latex).to eq(latex)
      expect(formula.to_asciimath).to eq(asciimath)
      expect { formula.to_mathml }.not_to raise_error
      expect { formula.to_omml }.not_to raise_error
      expect { formula.to_unicodemath }.not_to raise_error
      expect { formula.to_html }.not_to raise_error
    end
  end

  it "builds a Power over an Obrace for a superscript" do
    node = Plurimath::Math.parse('\overbrace{x}^{n}', :latex).value.first
    expect(node).to be_a(Plurimath::Math::Function::Power)
    expect(node.parameter_one).to be_a(Plurimath::Math::Function::Obrace)
  end
end
