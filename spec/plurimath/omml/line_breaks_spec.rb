require_relative "../../spec_helper"
require_relative "../fixtures/formula_modules/line_break_values.rb"

RSpec.describe Plurimath::Omml::Parser do
  subject(:omml) { expected_value.to_omml }
  subject(:file) { File.read(file_name) }

  context "contains #line-break-001.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-001.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_001 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-002.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-002.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_002 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-003.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-003.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_003 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-004.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-004.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_004 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-005.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-005.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_005 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-006.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-006.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_006 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-007.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-007.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_007 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-008.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-008.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_008 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-009.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-009.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_009 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-010.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-010.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_010 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-011.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-011.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_011 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-012.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-012.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_012 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-013.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-013.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_013 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-014.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-014.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_014 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-015.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-015.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_015 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-016.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-016.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_016 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-017.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-017.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_017 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-018.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-018.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_018 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-019.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-019.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_019 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-020.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-020.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_020 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-021.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-021.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_021 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-022.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-022.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_022 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-023.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-023.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_023 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-024.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-024.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_024 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-025.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-025.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_025 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-026.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-026.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_026 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-027.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-027.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_027 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-028.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-028.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_028 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-029.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-029.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_029 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-030.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-030.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_030 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-031.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-031.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_031 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-032.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-032.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_032 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-033.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-033.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_033 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-034.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-034.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_034 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-035.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-035.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_035 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-036.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-036.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_036 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-037.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-037.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_037 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-038.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-038.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_038 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-039.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-039.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_039 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-040.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-040.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_040 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-041.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-041.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_041 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-042.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-042.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_042 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-043.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-043.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_043 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-044.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-044.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_044 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-045.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-045.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_045 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-046.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-046.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_046 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-047.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-047.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_047 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-048.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-048.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_048 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-049.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-049.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_049 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-050.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-050.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_050 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-051.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-051.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_051 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-052.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-052.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_052 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-053.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-053.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_053 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-054.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-054.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_054 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-055.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-055.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_055 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-056.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-056.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_056 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-057.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-057.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_057 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-058.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-058.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_058 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-059.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-059.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_059 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-060.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-060.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_060 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-061.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-061.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_061 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-062.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-062.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_062 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-063.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-063.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_063 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-064.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-064.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_064 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-065.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-065.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_065 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-066.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-066.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_066 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-067.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-067.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_067 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-068.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-068.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_068 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-069.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-069.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_069 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-070.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-070.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_070 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-071.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-071.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_071 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-072.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-072.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_072 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-073.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-073.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_073 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-074.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-074.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_074 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-075.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-075.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_075 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-076.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-076.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_076 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-077.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-077.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_077 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-078.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-078.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_078 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-079.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-079.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_079 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-080.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-080.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_080 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-081.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-081.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_081 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-082.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-082.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_082 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-083.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-083.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_083 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-084.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-084.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_084 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end

  context "contains #line-break-085.omml" do
    let(:file_name) { "spec/plurimath/fixtures/omml/line_break/line-break-085.omml" }
    let(:expected_value) { LineBreakValues::LineBreak_085 }

    it "matches OMML equations" do
      expect(omml).to eq(file)
    end
  end
end
