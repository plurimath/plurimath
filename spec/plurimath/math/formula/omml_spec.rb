require_relative "../../../spec_helper"
require_relative "../../../../lib/plurimath/math"
require_relative "../../fixtures/expected_values"

RSpec.describe Plurimath::Math::Formula do
  describe ".to_omml" do
    subject(:formula) { exp.to_omml.gsub(/\s/, "") }
    subject(:entities) { HTMLEntities.new }

    context "contains #001.omml" do
      let(:file_name) { "spec/plurimath/fixtures/001.omml" }
      let(:exp) { ExpectedValues::EX_001 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #002.omml" do
      let(:file_name) { "spec/plurimath/fixtures/002.omml" }
      let(:exp) { ExpectedValues::EX_002 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to match(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #003.omml" do
      let(:file_name) { "spec/plurimath/fixtures/003.omml" }
      let(:exp) { ExpectedValues::EX_003 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #004.omml" do
      let(:file_name) { "spec/plurimath/fixtures/004.omml" }
      let(:exp) { ExpectedValues::EX_004 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #005.omml" do
      let(:file_name) { "spec/plurimath/fixtures/005.omml" }
      let(:exp) { ExpectedValues::EX_005 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #006.omml" do
      let(:file_name) { "spec/plurimath/fixtures/006.omml" }
      let(:exp) { ExpectedValues::EX_006 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #007.omml" do
      let(:file_name) { "spec/plurimath/fixtures/007.omml" }
      let(:exp) { ExpectedValues::EX_007 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #008.omml" do
      let(:file_name) { "spec/plurimath/fixtures/008.omml" }
      let(:exp) { ExpectedValues::EX_008 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #009.omml" do
      let(:file_name) { "spec/plurimath/fixtures/009.omml" }
      let(:exp) { ExpectedValues::EX_009 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #010.omml" do
      let(:file_name) { "spec/plurimath/fixtures/010.omml" }
      let(:exp) { ExpectedValues::EX_010 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #011.omml" do
      let(:file_name) { "spec/plurimath/fixtures/011.omml" }
      let(:exp) { ExpectedValues::EX_011 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #012.omml" do
      let(:file_name) { "spec/plurimath/fixtures/012.omml" }
      let(:exp) { ExpectedValues::EX_012 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #013.omml" do
      let(:file_name) { "spec/plurimath/fixtures/013.omml" }
      let(:exp) { ExpectedValues::EX_013 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #014.omml" do
      let(:file_name) { "spec/plurimath/fixtures/014.omml" }
      let(:exp) { ExpectedValues::EX_014 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #015.omml" do
      let(:file_name) { "spec/plurimath/fixtures/015.omml" }
      let(:exp) { ExpectedValues::EX_015 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #016.omml" do
      let(:file_name) { "spec/plurimath/fixtures/016.omml" }
      let(:exp) { ExpectedValues::EX_016 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #017.omml" do
      let(:file_name) { "spec/plurimath/fixtures/017.omml" }
      let(:exp) { ExpectedValues::EX_017 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #018.omml" do
      let(:file_name) { "spec/plurimath/fixtures/018.omml" }
      let(:exp) { ExpectedValues::EX_018 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #019.omml" do
      let(:file_name) { "spec/plurimath/fixtures/019.omml" }
      let(:exp) { ExpectedValues::EX_019 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #020.omml" do
      let(:file_name) { "spec/plurimath/fixtures/020.omml" }
      let(:exp) { ExpectedValues::EX_020 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #021.omml" do
      let(:file_name) { "spec/plurimath/fixtures/021.omml" }
      let(:exp) { ExpectedValues::EX_021 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #022.omml" do
      let(:file_name) { "spec/plurimath/fixtures/022.omml" }
      let(:exp) { ExpectedValues::EX_022 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #023.omml" do
      let(:file_name) { "spec/plurimath/fixtures/023.omml" }
      let(:exp) { ExpectedValues::EX_023 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #024.omml" do
      let(:file_name) { "spec/plurimath/fixtures/024.omml" }
      let(:exp) { ExpectedValues::EX_024 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #025.omml" do
      let(:file_name) { "spec/plurimath/fixtures/025.omml" }
      let(:exp) { ExpectedValues::EX_025 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #026.omml" do
      let(:file_name) { "spec/plurimath/fixtures/026.omml" }
      let(:exp) { ExpectedValues::EX_026 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #027.omml" do
      let(:file_name) { "spec/plurimath/fixtures/027.omml" }
      let(:exp) { ExpectedValues::EX_027 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #028.omml" do
      let(:file_name) { "spec/plurimath/fixtures/028.omml" }
      let(:exp) { ExpectedValues::EX_028 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #029.omml" do
      let(:file_name) { "spec/plurimath/fixtures/029.omml" }
      let(:exp) { ExpectedValues::EX_029 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #030.omml" do
      let(:file_name) { "spec/plurimath/fixtures/030.omml" }
      let(:exp) { ExpectedValues::EX_030 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #031.omml" do
      let(:file_name) { "spec/plurimath/fixtures/031.omml" }
      let(:exp) { ExpectedValues::EX_031 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #032.omml" do
      let(:file_name) { "spec/plurimath/fixtures/032.omml" }
      let(:exp) { ExpectedValues::EX_032 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #033.omml" do
      let(:file_name) { "spec/plurimath/fixtures/033.omml" }
      let(:exp) { ExpectedValues::EX_033 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(
          entities.decode(formula)
        ).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #034.omml" do
      let(:file_name) { "spec/plurimath/fixtures/034.omml" }
      let(:exp) { ExpectedValues::EX_034 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #035.omml" do
      let(:file_name) { "spec/plurimath/fixtures/035.omml" }
      let(:exp) { ExpectedValues::EX_035 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #036.omml" do
      let(:file_name) { "spec/plurimath/fixtures/036.omml" }
      let(:exp) { ExpectedValues::EX_036 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #037.omml" do
      let(:file_name) { "spec/plurimath/fixtures/037.omml" }
      let(:exp) { ExpectedValues::EX_037 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #038.omml" do
      let(:file_name) { "spec/plurimath/fixtures/038.omml" }
      let(:exp) { ExpectedValues::EX_038 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(entities.decode(formula)).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #039.omml" do
      let(:file_name) { "spec/plurimath/fixtures/039.omml" }
      let(:exp) { ExpectedValues::EX_039 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #040.omml" do
      let(:file_name) { "spec/plurimath/fixtures/040.omml" }
      let(:exp) { ExpectedValues::EX_040 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #041.omml" do
      let(:file_name) { "spec/plurimath/fixtures/041.omml" }
      let(:exp) { ExpectedValues::EX_041 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #042.omml" do
      let(:file_name) { "spec/plurimath/fixtures/042.omml" }
      let(:exp) { ExpectedValues::EX_042 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #043.omml" do
      let(:file_name) { "spec/plurimath/fixtures/043.omml" }
      let(:exp) { ExpectedValues::EX_043 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #044.omml" do
      let(:file_name) { "spec/plurimath/fixtures/044.omml" }
      let(:exp) { ExpectedValues::EX_044 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #045.omml" do
      let(:file_name) { "spec/plurimath/fixtures/045.omml" }
      let(:exp) { ExpectedValues::EX_045 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #046.omml" do
      let(:file_name) { "spec/plurimath/fixtures/046.omml" }
      let(:exp) { ExpectedValues::EX_046 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #047.omml" do
      let(:file_name) { "spec/plurimath/fixtures/047.omml" }
      let(:exp) { ExpectedValues::EX_047 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(
          entities.decode(formula)
        ).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #048.omml" do
      let(:file_name) { "spec/plurimath/fixtures/048.omml" }
      let(:exp) { ExpectedValues::EX_048 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #049.omml" do
      let(:file_name) { "spec/plurimath/fixtures/049.omml" }
      let(:exp) { ExpectedValues::EX_049 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #050.omml" do
      let(:file_name) { "spec/plurimath/fixtures/050.omml" }
      let(:exp) { ExpectedValues::EX_050 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #051.omml" do
      let(:file_name) { "spec/plurimath/fixtures/051.omml" }
      let(:exp) { ExpectedValues::EX_051 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #052.omml" do
      let(:file_name) { "spec/plurimath/fixtures/052.omml" }
      let(:exp) { ExpectedValues::EX_052 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #053.omml" do
      let(:file_name) { "spec/plurimath/fixtures/053.omml" }
      let(:exp) { ExpectedValues::EX_053 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #054.omml" do
      let(:file_name) { "spec/plurimath/fixtures/054.omml" }
      let(:exp) { ExpectedValues::EX_054 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #055.omml" do
      let(:file_name) { "spec/plurimath/fixtures/055.omml" }
      let(:exp) { ExpectedValues::EX_055 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #056.omml" do
      let(:file_name) { "spec/plurimath/fixtures/056.omml" }
      let(:exp) { ExpectedValues::EX_056 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #057.omml" do
      let(:file_name) { "spec/plurimath/fixtures/057.omml" }
      let(:exp) { ExpectedValues::EX_057 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #058.omml" do
      let(:file_name) { "spec/plurimath/fixtures/058.omml" }
      let(:exp) { ExpectedValues::EX_058 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #059.omml" do
      let(:file_name) { "spec/plurimath/fixtures/059.omml" }
      let(:exp) { ExpectedValues::EX_059 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #060.omml" do
      let(:file_name) { "spec/plurimath/fixtures/060.omml" }
      let(:exp) { ExpectedValues::EX_060 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #061.omml" do
      let(:file_name) { "spec/plurimath/fixtures/061.omml" }
      let(:exp) { ExpectedValues::EX_061 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #062.omml" do
      let(:file_name) { "spec/plurimath/fixtures/062.omml" }
      let(:exp) { ExpectedValues::EX_062 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #063.omml" do
      let(:file_name) { "spec/plurimath/fixtures/063.omml" }
      let(:exp) { ExpectedValues::EX_063 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #064.omml" do
      let(:file_name) { "spec/plurimath/fixtures/064.omml" }
      let(:exp) { ExpectedValues::EX_064 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #065.omml" do
      let(:file_name) { "spec/plurimath/fixtures/065.omml" }
      let(:exp) { ExpectedValues::EX_065 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #066.omml" do
      let(:file_name) { "spec/plurimath/fixtures/066.omml" }
      let(:exp) { ExpectedValues::EX_066 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #067.omml" do
      let(:file_name) { "spec/plurimath/fixtures/067.omml" }
      let(:exp) { ExpectedValues::EX_067 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #068.omml" do
      let(:file_name) { "spec/plurimath/fixtures/068.omml" }
      let(:exp) { ExpectedValues::EX_068 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #069.omml" do
      let(:file_name) { "spec/plurimath/fixtures/069.omml" }
      let(:exp) { ExpectedValues::EX_069 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #070.omml" do
      let(:file_name) { "spec/plurimath/fixtures/070.omml" }
      let(:exp) { ExpectedValues::EX_070 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(
          entities.decode(formula)
        ).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #071.omml" do
      let(:file_name) { "spec/plurimath/fixtures/071.omml" }
      let(:exp) { ExpectedValues::EX_071 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #072.omml" do
      let(:file_name) { "spec/plurimath/fixtures/072.omml" }
      let(:exp) { ExpectedValues::EX_072 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #073.omml" do
      let(:file_name) { "spec/plurimath/fixtures/073.omml" }
      let(:exp) { ExpectedValues::EX_073 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #074.omml" do
      let(:file_name) { "spec/plurimath/fixtures/074.omml" }
      let(:exp) { ExpectedValues::EX_074 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #075.omml" do
      let(:file_name) { "spec/plurimath/fixtures/075.omml" }
      let(:exp) { ExpectedValues::EX_075 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #076.omml" do
      let(:file_name) { "spec/plurimath/fixtures/076.omml" }
      let(:exp) { ExpectedValues::EX_076 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #077.omml" do
      let(:file_name) { "spec/plurimath/fixtures/077.omml" }
      let(:exp) { ExpectedValues::EX_077 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #078.omml" do
      let(:file_name) { "spec/plurimath/fixtures/078.omml" }
      let(:exp) { ExpectedValues::EX_078 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #079.omml" do
      let(:file_name) { "spec/plurimath/fixtures/079.omml" }
      let(:exp) { ExpectedValues::EX_079 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #080.omml" do
      let(:file_name) { "spec/plurimath/fixtures/080.omml" }
      let(:exp) { ExpectedValues::EX_080 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #081.omml" do
      let(:file_name) { "spec/plurimath/fixtures/081.omml" }
      let(:exp) { ExpectedValues::EX_081 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #082.omml" do
      let(:file_name) { "spec/plurimath/fixtures/082.omml" }
      let(:exp) { ExpectedValues::EX_082 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #083.omml" do
      let(:file_name) { "spec/plurimath/fixtures/083.omml" }
      let(:exp) { ExpectedValues::EX_083 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #084.omml" do
      let(:file_name) { "spec/plurimath/fixtures/084.omml" }
      let(:exp) { ExpectedValues::EX_084 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #085.omml" do
      let(:file_name) { "spec/plurimath/fixtures/085.omml" }
      let(:exp) { ExpectedValues::EX_085 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #086.omml" do
      let(:file_name) { "spec/plurimath/fixtures/086.omml" }
      let(:exp) { ExpectedValues::EX_086 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #087.omml" do
      let(:file_name) { "spec/plurimath/fixtures/087.omml" }
      let(:exp) { ExpectedValues::EX_087 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #088.omml" do
      let(:file_name) { "spec/plurimath/fixtures/088.omml" }
      let(:exp) { ExpectedValues::EX_088 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #089.omml" do
      let(:file_name) { "spec/plurimath/fixtures/089.omml" }
      let(:exp) { ExpectedValues::EX_089 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #090.omml" do
      let(:file_name) { "spec/plurimath/fixtures/090.omml" }
      let(:exp) { ExpectedValues::EX_090 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #091.omml" do
      let(:file_name) { "spec/plurimath/fixtures/091.omml" }
      let(:exp) { ExpectedValues::EX_091 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #092.omml" do
      let(:file_name) { "spec/plurimath/fixtures/092.omml" }
      let(:exp) { ExpectedValues::EX_092 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #093.omml" do
      let(:file_name) { "spec/plurimath/fixtures/093.omml" }
      let(:exp) { ExpectedValues::EX_093 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #094.omml" do
      let(:file_name) { "spec/plurimath/fixtures/094.omml" }
      let(:exp) { ExpectedValues::EX_094 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #095.omml" do
      let(:file_name) { "spec/plurimath/fixtures/095.omml" }
      let(:exp) { ExpectedValues::EX_095 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #096.omml" do
      let(:file_name) { "spec/plurimath/fixtures/096.omml" }
      let(:exp) { ExpectedValues::EX_096 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #097.omml" do
      let(:file_name) { "spec/plurimath/fixtures/097.omml" }
      let(:exp) { ExpectedValues::EX_097 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #098.omml" do
      let(:file_name) { "spec/plurimath/fixtures/098.omml" }
      let(:exp) { ExpectedValues::EX_098 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #099.omml" do
      let(:file_name) { "spec/plurimath/fixtures/099.omml" }
      let(:exp) { ExpectedValues::EX_099 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #100.omml" do
      let(:file_name) { "spec/plurimath/fixtures/100.omml" }
      let(:exp) { ExpectedValues::EX_100 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #101.omml" do
      let(:file_name) { "spec/plurimath/fixtures/101.omml" }
      let(:exp) { ExpectedValues::EX_101 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #102.omml" do
      let(:file_name) { "spec/plurimath/fixtures/102.omml" }
      let(:exp) { ExpectedValues::EX_102 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #103.omml" do
      let(:file_name) { "spec/plurimath/fixtures/103.omml" }
      let(:exp) { ExpectedValues::EX_103 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #104.omml" do
      let(:file_name) { "spec/plurimath/fixtures/104.omml" }
      let(:exp) { ExpectedValues::EX_104 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #105.omml" do
      let(:file_name) { "spec/plurimath/fixtures/105.omml" }
      let(:exp) { ExpectedValues::EX_105 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #106.omml" do
      let(:file_name) { "spec/plurimath/fixtures/106.omml" }
      let(:exp) { ExpectedValues::EX_106 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #107.omml" do
      let(:file_name) { "spec/plurimath/fixtures/107.omml" }
      let(:exp) { ExpectedValues::EX_107 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #108.omml" do
      let(:file_name) { "spec/plurimath/fixtures/108.omml" }
      let(:exp) { ExpectedValues::EX_108 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #109.omml" do
      let(:file_name) { "spec/plurimath/fixtures/109.omml" }
      let(:exp) { ExpectedValues::EX_109 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #110.omml" do
      let(:file_name) { "spec/plurimath/fixtures/110.omml" }
      let(:exp) { ExpectedValues::EX_110 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #111.omml" do
      let(:file_name) { "spec/plurimath/fixtures/111.omml" }
      let(:exp) { ExpectedValues::EX_111 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #112.omml" do
      let(:file_name) { "spec/plurimath/fixtures/112.omml" }
      let(:exp) { ExpectedValues::EX_112 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #113.omml" do
      let(:file_name) { "spec/plurimath/fixtures/113.omml" }
      let(:exp) { ExpectedValues::EX_113 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #114.omml" do
      let(:file_name) { "spec/plurimath/fixtures/114.omml" }
      let(:exp) { ExpectedValues::EX_114 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #115.omml" do
      let(:file_name) { "spec/plurimath/fixtures/115.omml" }
      let(:exp) { ExpectedValues::EX_115 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #116.omml" do
      let(:file_name) { "spec/plurimath/fixtures/116.omml" }
      let(:exp) { ExpectedValues::EX_116 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #117.omml" do
      let(:file_name) { "spec/plurimath/fixtures/117.omml" }
      let(:exp) { ExpectedValues::EX_117 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #118.omml" do
      let(:file_name) { "spec/plurimath/fixtures/118.omml" }
      let(:exp) { ExpectedValues::EX_118 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #119.omml" do
      let(:file_name) { "spec/plurimath/fixtures/119.omml" }
      let(:exp) { ExpectedValues::EX_119 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #120.omml" do
      let(:file_name) { "spec/plurimath/fixtures/120.omml" }
      let(:exp) { ExpectedValues::EX_120 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #121.omml" do
      let(:file_name) { "spec/plurimath/fixtures/121.omml" }
      let(:exp) { ExpectedValues::EX_121 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #122.omml" do
      let(:file_name) { "spec/plurimath/fixtures/122.omml" }
      let(:exp) { ExpectedValues::EX_122 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #123.omml" do
      let(:file_name) { "spec/plurimath/fixtures/123.omml" }
      let(:exp) { ExpectedValues::EX_123 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #124.omml" do
      let(:file_name) { "spec/plurimath/fixtures/124.omml" }
      let(:exp) { ExpectedValues::EX_124 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #125.omml" do
      let(:file_name) { "spec/plurimath/fixtures/125.omml" }
      let(:exp) { ExpectedValues::EX_125 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #126.omml" do
      let(:file_name) { "spec/plurimath/fixtures/126.omml" }
      let(:exp) { ExpectedValues::EX_126 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(entities.decode(formula)).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #127.omml" do
      let(:file_name) { "spec/plurimath/fixtures/127.omml" }
      let(:exp) { ExpectedValues::EX_127 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #128.omml" do
      let(:file_name) { "spec/plurimath/fixtures/128.omml" }
      let(:exp) { ExpectedValues::EX_128 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(entities.decode(formula)).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #129.omml" do
      let(:file_name) { "spec/plurimath/fixtures/129.omml" }
      let(:exp) { ExpectedValues::EX_129 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #130.omml" do
      let(:file_name) { "spec/plurimath/fixtures/130.omml" }
      let(:exp) { ExpectedValues::EX_130 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #131.omml" do
      let(:file_name) { "spec/plurimath/fixtures/131.omml" }
      let(:exp) { ExpectedValues::EX_131 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #132.omml" do
      let(:file_name) { "spec/plurimath/fixtures/132.omml" }
      let(:exp) { ExpectedValues::EX_132 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #133.omml" do
      let(:file_name) { "spec/plurimath/fixtures/133.omml" }
      let(:exp) { ExpectedValues::EX_133 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #134.omml" do
      let(:file_name) { "spec/plurimath/fixtures/134.omml" }
      let(:exp) { ExpectedValues::EX_134 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #135.omml" do
      let(:file_name) { "spec/plurimath/fixtures/135.omml" }
      let(:exp) { ExpectedValues::EX_135 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #136.omml" do
      let(:file_name) { "spec/plurimath/fixtures/136.omml" }
      let(:exp) { ExpectedValues::EX_136 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #137.omml" do
      let(:file_name) { "spec/plurimath/fixtures/137.omml" }
      let(:exp) { ExpectedValues::EX_137 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #138.omml" do
      let(:file_name) { "spec/plurimath/fixtures/138.omml" }
      let(:exp) { ExpectedValues::EX_138 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #139.omml" do
      let(:file_name) { "spec/plurimath/fixtures/139.omml" }
      let(:exp) { ExpectedValues::EX_139 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #140.omml" do
      let(:file_name) { "spec/plurimath/fixtures/140.omml" }
      let(:exp) { ExpectedValues::EX_140 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #141.omml" do
      let(:file_name) { "spec/plurimath/fixtures/141.omml" }
      let(:exp) { ExpectedValues::EX_141 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #142.omml" do
      let(:file_name) { "spec/plurimath/fixtures/142.omml" }
      let(:exp) { ExpectedValues::EX_142 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #143.omml" do
      let(:file_name) { "spec/plurimath/fixtures/143.omml" }
      let(:exp) { ExpectedValues::EX_143 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #144.omml" do
      let(:file_name) { "spec/plurimath/fixtures/144.omml" }
      let(:exp) { ExpectedValues::EX_144 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #145.omml" do
      let(:file_name) { "spec/plurimath/fixtures/145.omml" }
      let(:exp) { ExpectedValues::EX_145 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #146.omml" do
      let(:file_name) { "spec/plurimath/fixtures/146.omml" }
      let(:exp) { ExpectedValues::EX_146 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #147.omml" do
      let(:file_name) { "spec/plurimath/fixtures/147.omml" }
      let(:exp) { ExpectedValues::EX_147 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #148.omml" do
      let(:file_name) { "spec/plurimath/fixtures/148.omml" }
      let(:exp) { ExpectedValues::EX_148 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #149.omml" do
      let(:file_name) { "spec/plurimath/fixtures/149.omml" }
      let(:exp) { ExpectedValues::EX_149 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #150.omml" do
      let(:file_name) { "spec/plurimath/fixtures/150.omml" }
      let(:exp) { ExpectedValues::EX_150 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #151.omml" do
      let(:file_name) { "spec/plurimath/fixtures/151.omml" }
      let(:exp) { ExpectedValues::EX_151 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #152.omml" do
      let(:file_name) { "spec/plurimath/fixtures/152.omml" }
      let(:exp) { ExpectedValues::EX_152 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #153.omml" do
      let(:file_name) { "spec/plurimath/fixtures/153.omml" }
      let(:exp) { ExpectedValues::EX_153 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #154.omml" do
      let(:file_name) { "spec/plurimath/fixtures/154.omml" }
      let(:exp) { ExpectedValues::EX_154 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #155.omml" do
      let(:file_name) { "spec/plurimath/fixtures/155.omml" }
      let(:exp) { ExpectedValues::EX_155 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #156.omml" do
      let(:file_name) { "spec/plurimath/fixtures/156.omml" }
      let(:exp) { ExpectedValues::EX_156 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #157.omml" do
      let(:file_name) { "spec/plurimath/fixtures/157.omml" }
      let(:exp) { ExpectedValues::EX_157 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #158.omml" do
      let(:file_name) { "spec/plurimath/fixtures/158.omml" }
      let(:exp) { ExpectedValues::EX_158 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #159.omml" do
      let(:file_name) { "spec/plurimath/fixtures/159.omml" }
      let(:exp) { ExpectedValues::EX_159 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #160.omml" do
      let(:file_name) { "spec/plurimath/fixtures/160.omml" }
      let(:exp) { ExpectedValues::EX_160 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #161.omml" do
      let(:file_name) { "spec/plurimath/fixtures/161.omml" }
      let(:exp) { ExpectedValues::EX_161 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #162.omml" do
      let(:file_name) { "spec/plurimath/fixtures/162.omml" }
      let(:exp) { ExpectedValues::EX_162 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #163.omml" do
      let(:file_name) { "spec/plurimath/fixtures/163.omml" }
      let(:exp) { ExpectedValues::EX_163 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #164.omml" do
      let(:file_name) { "spec/plurimath/fixtures/164.omml" }
      let(:exp) { ExpectedValues::EX_164 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #165.omml" do
      let(:file_name) { "spec/plurimath/fixtures/165.omml" }
      let(:exp) { ExpectedValues::EX_165 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #166.omml" do
      let(:file_name) { "spec/plurimath/fixtures/166.omml" }
      let(:exp) { ExpectedValues::EX_166 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #167.omml" do
      let(:file_name) { "spec/plurimath/fixtures/167.omml" }
      let(:exp) { ExpectedValues::EX_167 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #168.omml" do
      let(:file_name) { "spec/plurimath/fixtures/168.omml" }
      let(:exp) { ExpectedValues::EX_168 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #169.omml" do
      let(:file_name) { "spec/plurimath/fixtures/169.omml" }
      let(:exp) { ExpectedValues::EX_169 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #170.omml" do
      let(:file_name) { "spec/plurimath/fixtures/170.omml" }
      let(:exp) { ExpectedValues::EX_170 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #171.omml" do
      let(:file_name) { "spec/plurimath/fixtures/171.omml" }
      let(:exp) { ExpectedValues::EX_171 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #172.omml" do
      let(:file_name) { "spec/plurimath/fixtures/172.omml" }
      let(:exp) { ExpectedValues::EX_172 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #173.omml" do
      let(:file_name) { "spec/plurimath/fixtures/173.omml" }
      let(:exp) { ExpectedValues::EX_173 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #174.omml" do
      let(:file_name) { "spec/plurimath/fixtures/174.omml" }
      let(:exp) { ExpectedValues::EX_174 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #175.omml" do
      let(:file_name) { "spec/plurimath/fixtures/175.omml" }
      let(:exp) { ExpectedValues::EX_175 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #176.omml" do
      let(:file_name) { "spec/plurimath/fixtures/176.omml" }
      let(:exp) { ExpectedValues::EX_176 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #177.omml" do
      let(:file_name) { "spec/plurimath/fixtures/177.omml" }
      let(:exp) { ExpectedValues::EX_177 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #178.omml" do
      let(:file_name) { "spec/plurimath/fixtures/178.omml" }
      let(:exp) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Limits.new(
            Plurimath::Math::Function::Int.new,
            Plurimath::Math::Number.new("0"),
            Plurimath::Math::Function::PowerBase.new(
              Plurimath::Math::Symbol.new("&#x3C0;"),
              Plurimath::Math::Number.new("2221"),
              Plurimath::Math::Symbol.new("&#x2221;"),
            ),
          )
        ])
      end

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(entities.decode(formula)).to eq(expected_value.gsub(/\s/, ""))
      end
    end

    context "contains #issue-158.omml" do
      let(:file_name) { "spec/plurimath/fixtures/issue-158.omml" }
      let(:exp) { ExpectedValues::EXIssue158 }

      it "matches open and close tag" do
        expected_value = File.read(file_name)
        expect(formula).to eq(expected_value.gsub(/\s/, ""))
      end
    end
  end
end
