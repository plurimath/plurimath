require "spec_helper"
require "nokogiri"
require "plurimath/fixtures/formula_modules/line_break_values"

RSpec.describe Plurimath::Math::Formula, "#to_omml helper operand order" do
  let(:base) { Plurimath::Math::Function::Text.new("body", lang: :omml) }
  let(:subscript) { Plurimath::Math::Function::Text.new("lower", lang: :omml) }
  let(:superscript) { Plurimath::Math::Function::Text.new("upper", lang: :omml) }
  let(:namespaces) { { "m" => "http://schemas.openxmlformats.org/officeDocument/2006/math" } }

  { Ubrace: "⏟", Obrace: "⏞", Vec: "→", Ddot: "..", Overleftrightarrow: "\u20e1",
    Tilde: "~", Dot: ".", Ul: "\u0332", Hat: "\u0302" }.each do |function, script|
    it "keeps the expression as the base for #{function}" do
      formula = described_class.new([
                                      Plurimath::Math::Function.const_get(function).new(base),
                                    ])
      document = Nokogiri::XML(formula.to_omml, &:noblanks)
      expect(document.at_xpath("//m:limUpp/m:e | //m:limLow/m:e", namespaces).text).to eq("body")
      expect(document.at_xpath("//m:limUpp/m:lim | //m:limLow/m:lim", namespaces).text).to eq(script)
    end
  end

  it "keeps both limits around a binary function name" do
    formula = described_class.new([
                                    Plurimath::Math::Function::Lim.new(subscript, superscript),
                                  ])
    document = Nokogiri::XML(formula.to_omml, &:noblanks)
    expect(document.at_xpath("//m:limLow/m:lim", namespaces).text).to eq("lower")
    expect(document.at_xpath("//m:limLow/m:e/m:limUpp/m:lim", namespaces).text).to eq("upper")
    expect(document.at_xpath("//m:limLow/m:e/m:limUpp/m:e", namespaces).text).to eq("lim")
  end

  it "keeps both limits around a ternary base expression" do
    formula = described_class.new([
                                    Plurimath::Math::Function::Underover.new(base, subscript, superscript),
                                  ])
    document = Nokogiri::XML(formula.to_omml, &:noblanks)
    expect(document.at_xpath("//m:limLow/m:lim", namespaces).text).to eq("lower")
    expect(document.at_xpath("//m:limLow/m:e/m:limUpp/m:lim", namespaces).text).to eq("upper")
    expect(document.at_xpath("//m:limLow/m:e/m:limUpp/m:e", namespaces).text).to eq("body")
  end

  it "keeps the continuation of a split hat expression as a base" do
    document = Nokogiri::XML(LineBreakValues::LineBreak_019.to_omml(split_on_linebreak: true), &:noblanks)
    bases = document.xpath("//m:limUpp/m:e", namespaces).map(&:text)
    expect(bases).to eq(["as", "df"])
  end
end
