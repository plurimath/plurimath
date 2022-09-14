require_relative "../../../lib/plurimath/math"
require_relative "../../../lib/plurimath/omml/parse"
require_relative "../../../lib/plurimath/omml/constants"

RSpec.describe Plurimath::Omml::Parse do

  subject(:formula) do
    described_class.new.parse(
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

  context "contains #008.omml" do
    let(:file_name) { "spec/plurimath/fixtures/008.omml" }

    it "matches open and close tag" do
      spre_tag = formula[:iteration][:iteration]

      expect(spre_tag[:open]).to eq("sPre")
      expect(spre_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(spre_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(spre_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(spre_tag[:close]).to eq("sPre")
    end
  end

  context "contains #009.omml" do
    let(:file_name) { "spec/plurimath/fixtures/009.omml" }

    it "matches open and close tag" do
      sqrt_tag = formula[:iteration][:iteration]

      expect(sqrt_tag[:open]).to eq("rad")
      expect(sqrt_tag[:fonts][:open]).to eq("radPr")
      expect(sqrt_tag[:fonts][:close]).to eq("radPr")
      expect(sqrt_tag[:first_value][:omission]).to eq("deg")
      expect(sqrt_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(sqrt_tag[:close]).to eq("rad")
    end
  end

  context "contains #010.omml" do
    let(:file_name) { "spec/plurimath/fixtures/010.omml" }

    it "matches open and close tag" do
      sqrt_tag = formula[:iteration][:iteration]

      expect(sqrt_tag[:open]).to eq("rad")
      expect(sqrt_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(sqrt_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(sqrt_tag[:close]).to eq("rad")
    end
  end

  context "contains #011.omml" do
    let(:file_name) { "spec/plurimath/fixtures/011.omml" }

    it "matches open and close tag" do
      sqrt_tag = formula[:iteration][:iteration]

      expect(sqrt_tag[:open]).to eq("rad")
      expect(sqrt_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(sqrt_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(sqrt_tag[:close]).to eq("rad")
    end
  end

  context "contains #012.omml" do
    let(:file_name) { "spec/plurimath/fixtures/012.omml" }

    it "matches open and close tag" do
      sqrt_tag = formula[:iteration][:iteration]

      expect(sqrt_tag[:open]).to eq("rad")
      expect(sqrt_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(sqrt_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(sqrt_tag[:close]).to eq("rad")
    end
  end

  context "contains #013.omml" do
    let(:file_name) { "spec/plurimath/fixtures/013.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:omission]).to eq("sub")
      expect(nary_tag[:second_value][:omission]).to eq("sup")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #014.omml" do
    let(:file_name) { "spec/plurimath/fixtures/014.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(nary_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #015.omml" do
    let(:file_name) { "spec/plurimath/fixtures/015.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(nary_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #016.omml" do
    let(:file_name) { "spec/plurimath/fixtures/016.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:omission]).to eq("sub")
      expect(nary_tag[:second_value][:omission]).to eq("sup")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #017.omml" do
    let(:file_name) { "spec/plurimath/fixtures/017.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(nary_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #018.omml" do
    let(:file_name) { "spec/plurimath/fixtures/018.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(nary_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #019.omml" do
    let(:file_name) { "spec/plurimath/fixtures/019.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:omission]).to eq("sub")
      expect(nary_tag[:second_value][:omission]).to eq("sup")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #020.omml" do
    let(:file_name) { "spec/plurimath/fixtures/020.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(nary_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #021.omml" do
    let(:file_name) { "spec/plurimath/fixtures/021.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(nary_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #022.omml" do
    let(:file_name) { "spec/plurimath/fixtures/022.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:omission]).to eq("sub")
      expect(nary_tag[:second_value][:omission]).to eq("sup")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #023.omml" do
    let(:file_name) { "spec/plurimath/fixtures/023.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(nary_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #024.omml" do
    let(:file_name) { "spec/plurimath/fixtures/024.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(nary_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #025.omml" do
    let(:file_name) { "spec/plurimath/fixtures/025.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:omission]).to eq("sub")
      expect(nary_tag[:second_value][:omission]).to eq("sup")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #026.omml" do
    let(:file_name) { "spec/plurimath/fixtures/026.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(nary_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #027.omml" do
    let(:file_name) { "spec/plurimath/fixtures/027.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(nary_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #028.omml" do
    let(:file_name) { "spec/plurimath/fixtures/028.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:omission]).to eq("sub")
      expect(nary_tag[:second_value][:omission]).to eq("sup")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #029.omml" do
    let(:file_name) { "spec/plurimath/fixtures/029.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(nary_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #030.omml" do
    let(:file_name) { "spec/plurimath/fixtures/030.omml" }

    it "matches open and close tag" do
      nary_tag = formula[:iteration][:iteration]

      expect(nary_tag[:open]).to eq("nary")
      expect(nary_tag[:first_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("1")
      expect(nary_tag[:second_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("2")
      expect(nary_tag[:third_value][:iteration][:iteration][:sequence][:iteration][:number]).to eq("3")
      expect(nary_tag[:close]).to eq("nary")
    end
  end

  context "contains #031.omml" do
    let(:file_name) { "spec/plurimath/fixtures/031.omml" }

    it "matches open and close tag" do
      iteration = formula[:iteration][:iteration][:iteration][:sequence][:iteration]

      expect(iteration[:iteration][:sequence][:iteration][0][:text]).to eq("d")
      expect(iteration[:iteration][:sequence][:iteration][1][:text]).to eq("x")
    end
  end

  context "contains #032.omml" do
    let(:file_name) { "spec/plurimath/fixtures/032.omml" }

    it "matches open and close tag" do
      iteration = formula[:iteration][:iteration][:iteration][:sequence][:iteration]

      expect(iteration[:iteration][:sequence][:iteration][0][:text]).to eq("d")
      expect(iteration[:iteration][:sequence][:iteration][1][:text]).to eq("y")
    end
  end
end
