require "spec_helper"
require "plurimath/fixtures/formula_modules/line_break_values.rb"

RSpec.describe Plurimath::Mathml::Parser do
  subject(:mathml) { expected_value.to_mathml(split_on_linebreak: true) }
  subject(:file) { File.read(file_name) }

  context "contains #line-break-001.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-001.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_001 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-002.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-002.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_002 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-003.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-003.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_003 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-004.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-004.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_004 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-005.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-005.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_005 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-006.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-006.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_006 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-007.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-007.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_007 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-008.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-008.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_008 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-009.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-009.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_009 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-010.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-010.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_010 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-011.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-011.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_011 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-012.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-012.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_012 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-013.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-013.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_013 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-014.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-014.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_014 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-015.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-015.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_015 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-016.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-016.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_016 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-017.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-017.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_017 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-018.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-018.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_018 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-019.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-019.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_019 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-020.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-020.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_020 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-021.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-021.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_021 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-022.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-022.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_022 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-023.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-023.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_023 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-024.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-024.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_024 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-025.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-025.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_025 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-026.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-026.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_026 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-027.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-027.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_027 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-028.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-028.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_028 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-029.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-029.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_029 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-030.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-030.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_030 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-031.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-031.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_031 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-032.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-032.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_032 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-033.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-033.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_033 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-034.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-034.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_034 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-035.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-035.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_035 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-036.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-036.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_036 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-037.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-037.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_037 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-038.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-038.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_038 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-039.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-039.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_039 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-040.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-040.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_040 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-041.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-041.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_041 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-042.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-042.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_042 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-043.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-043.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_043 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-044.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-044.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_044 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-045.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-045.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_045 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-046.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-046.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_046 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-047.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-047.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_047 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-048.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-048.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_048 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-049.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-049.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_049 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-050.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-050.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_050 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-051.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-051.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_051 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-052.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-052.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_052 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-053.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-053.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_053 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-054.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-054.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_054 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-055.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-055.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_055 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-056.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-056.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_056 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-057.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-057.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_057 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-058.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-058.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_058 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-059.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-059.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_059 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-060.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-060.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_060 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-061.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-061.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_061 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-062.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-062.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_062 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-063.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-063.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_063 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-064.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-064.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_064 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-065.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-065.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_065 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-066.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-066.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_066 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-067.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-067.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_067 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-068.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-068.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_068 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-069.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-069.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_069 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-070.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-070.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_070 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-071.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-071.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_071 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-072.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-072.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_072 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-073.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-073.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_073 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-074.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-074.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_074 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-075.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-075.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_075 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-076.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-076.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_076 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-077.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-077.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_077 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-078.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-078.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_078 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-079.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-079.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_079 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-080.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-080.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_080 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-081.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-081.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_081 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-082.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-082.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_082 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-083.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-083.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_083 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-084.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-084.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_084 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-085.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-085.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_085 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-086.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-086.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_086 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-087.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-087.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_087 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-088.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-088.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_088 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end

  context "contains #line-break-089.mathml" do
    let(:file_name) { "spec/plurimath/fixtures/mathml/line_break/line-break-089.mathml" }
    let(:expected_value) { LineBreakValues::LineBreak_089 }

    it "matches mathml equations" do
      expect(mathml).to eq(file)
    end
  end
end
