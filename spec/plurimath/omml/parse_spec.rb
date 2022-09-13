require_relative "../../../lib/plurimath/math"
require_relative "../../../lib/plurimath/omml/parse"
require_relative "../../../lib/plurimath/omml/constants"

RSpec.describe Plurimath::Omml::Parse do

  subject(:formula) do
    described_class.new.parse_with_debug(
      File.read(file_name).gsub(/\s/, "")
    )
  end

  context "contains #001.omml" do
    let(:file_name) { "spec/plurimath/fixtures/001.omml" }

    it "matches open and close tag" do
      f_tag          = formula[:iteration]
      f_first_value  = f_tag[:first_value][:iteration][:iteration][:sequence][:iteration]
      f_second_value = f_tag[:second_value][:iteration][:iteration][:sequence][:iteration]

      expect(formula[:open]).to eq("oMath")
      expect(formula[:attributes].count).to eq(18)
      expect(formula[:attributes][10][:name]).to eq("xmlns:w10")
      expect(formula[:attributes][11][:name]).to eq("xmlns:w")
      expect(f_tag[:open]).to eq("f")
      expect(f_first_value[:number]).to eq("1")
      expect(f_second_value[:number]).to eq("2")
      expect(f_tag[:close]).to eq("f")
      expect(formula[:close]).to eq("oMath")
    end
  end

  context "contains #002.omml" do
    let(:file_name) { "spec/plurimath/fixtures/002.omml" }

    it "matches open and close tag" do
      f_tag = formula[:iteration][:iteration]
      f_first_value = f_tag[:first_value][:iteration][:iteration][:sequence][:iteration]
      f_second_value = f_tag[:second_value][:iteration][:iteration][:sequence][:iteration]

      expect(formula[:open]).to eq("oMathPara")
      expect(f_tag[:open]).to eq("f")
      expect(f_first_value[:number]).to eq("1")
      expect(f_second_value[:number]).to eq("2")
      expect(f_tag[:close]).to eq("f")
      expect(formula[:close]).to eq("oMathPara")
    end
  end

  context "contains #003.omml" do
    let(:file_name) { "spec/plurimath/fixtures/003.omml" }

    it "matches open and close tag" do
      f_tag = formula[:iteration][:iteration]
      f_first_value = f_tag[:first_value][:iteration][:iteration][:sequence][:iteration]
      f_second_value = f_tag[:second_value][:iteration][:iteration][:sequence][:iteration]

      expect(f_tag[:open]).to eq("f")
      expect(f_first_value[:number]).to eq("1")
      expect(f_second_value[:number]).to eq("2")
      expect(f_tag[:close]).to eq("f")
    end
  end

  context "contains #004.omml" do
    let(:file_name) { "spec/plurimath/fixtures/004.omml" }

    it "matches open and close tag" do
      f_tag = formula[:iteration][:iteration][:iteration][:sequence][:iteration][:sequence]

      expect(f_tag[:open]).to eq("f")
      expect(f_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(f_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(f_tag[:close]).to eq("f")
    end
  end

  context "contains #005.omml" do
    let(:file_name) { "spec/plurimath/fixtures/005.omml" }

    it "matches open and close tag" do
      sup_tag = formula[:iteration][:iteration]

      expect(sup_tag[:open]).to eq("sSup")
      expect(sup_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(sup_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(sup_tag[:close]).to eq("sSup")
    end
  end

  context "contains #006.omml" do
    let(:file_name) { "spec/plurimath/fixtures/006.omml" }

    it "matches open and close tag" do
      sub_tag = formula[:iteration][:iteration][:iteration][:sequence][:sequence]

      expect(formula[:open]).to eq("oMathPara")
      expect(formula[:attributes].count).to eq(18)
      expect(formula[:attributes][10][:name]).to eq("xmlns:w15")
      expect(formula[:attributes][11][:name]).to eq("xmlns:wne")
      expect(sub_tag[:open]).to eq("sub")
      expect(sub_tag[:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(sub_tag[:close]).to eq("sub")
      expect(formula[:close]).to eq("oMathPara")
    end
  end

  context "contains #007.omml" do
    let(:file_name) { "spec/plurimath/fixtures/007.omml" }

    it "matches open and close tag" do
      sub_sup_tag = formula[:iteration][:iteration]

      expect(formula[:open]).to eq("oMathPara")
      expect(formula[:attributes].count).to eq(18)
      expect(formula[:attributes][10][:name]).to eq("xmlns:w15")
      expect(formula[:attributes][11][:name]).to eq("xmlns:wne")
      expect(sub_sup_tag[:open]).to eq("sSubSup")
      expect(sub_sup_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(sub_sup_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(sub_sup_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(sub_sup_tag[:close]).to eq("sSubSup")
      expect(formula[:close]).to eq("oMathPara")
    end
  end
end
