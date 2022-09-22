require_relative "../../../lib/plurimath/math"
require_relative "../../../lib/plurimath/omml/parser"
require_relative "../../../lib/plurimath/omml/constants"

RSpec.describe Plurimath::Omml::Parser do

  subject(:formula) do
    described_class.new(File.read(file_name)).parse
  end

  context "contains #001.omml" do
    let(:file_name) { "spec/plurimath/fixtures/001.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Number.new("2"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #002.omml" do
    let(:file_name) { "spec/plurimath/fixtures/002.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Number.new("2"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #003.omml" do
    let(:file_name) { "spec/plurimath/fixtures/003.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Number.new("2"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #004.omml" do
    let(:file_name) { "spec/plurimath/fixtures/004.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Number.new("2"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #005.omml" do
    let(:file_name) { "spec/plurimath/fixtures/005.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Number.new("2"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #006.omml" do
    let(:file_name) { "spec/plurimath/fixtures/006.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Base.new(
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Number.new("2"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #007.omml" do
    let(:file_name) { "spec/plurimath/fixtures/007.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::PowerBase.new(
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Number.new("2"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #008.omml" do
    let(:file_name) { "spec/plurimath/fixtures/008.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Multiscript.new(
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Number.new("1"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #009.omml" do
    let(:file_name) { "spec/plurimath/fixtures/009.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Sqrt.new(
          Plurimath::Math::Number.new("1")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #010.omml" do
    let(:file_name) { "spec/plurimath/fixtures/010.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Root.new(
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Number.new("1"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #011.omml" do
    let(:file_name) { "spec/plurimath/fixtures/011.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Root.new(
          Plurimath::Math::Number.new("2"),
          Plurimath::Math::Number.new("3"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #012.omml" do
    let(:file_name) { "spec/plurimath/fixtures/012.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Root.new(
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Number.new("1"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #013.omml" do
    let(:file_name) { "spec/plurimath/fixtures/013.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("∫"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1"),
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #014.omml" do
    let(:file_name) { "spec/plurimath/fixtures/014.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("∫"),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("3"),
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #015.omml" do
    let(:file_name) { "spec/plurimath/fixtures/015.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Symbol.new("∫"),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("3"),
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #016.omml" do
    let(:file_name) { "spec/plurimath/fixtures/016.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("∬"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1"),
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #017.omml" do
    let(:file_name) { "spec/plurimath/fixtures/017.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("∬"),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("3")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #018.omml" do
    let(:file_name) { "spec/plurimath/fixtures/018.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Symbol.new("∬"),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("3")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #019.omml" do
    let(:file_name) { "spec/plurimath/fixtures/019.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("∭"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #020.omml" do
    let(:file_name) { "spec/plurimath/fixtures/020.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("∭"),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("3")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #021.omml" do
    let(:file_name) { "spec/plurimath/fixtures/021.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Symbol.new("∭"),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("3")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #022.omml" do
    let(:file_name) { "spec/plurimath/fixtures/022.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("∮"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #023.omml" do
    let(:file_name) { "spec/plurimath/fixtures/023.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("∮"),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("3")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #024.omml" do
    let(:file_name) { "spec/plurimath/fixtures/024.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Symbol.new("∮"),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("3")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #025.omml" do
    let(:file_name) { "spec/plurimath/fixtures/025.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("∯"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #026.omml" do
    let(:file_name) { "spec/plurimath/fixtures/026.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("∯"),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("3")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #027.omml" do
    let(:file_name) { "spec/plurimath/fixtures/027.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Symbol.new("∯"),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("3")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #028.omml" do
    let(:file_name) { "spec/plurimath/fixtures/028.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("∰"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #029.omml" do
    let(:file_name) { "spec/plurimath/fixtures/029.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("∰"),
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("3")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #030.omml" do
    let(:file_name) { "spec/plurimath/fixtures/030.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Symbol.new("∰"),
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Number.new("2"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("3")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #031.omml" do
    let(:file_name) { "spec/plurimath/fixtures/031.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Text.new("dx"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #032.omml" do
    let(:file_name) { "spec/plurimath/fixtures/032.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Text.new("dy"),
      ])
      expect(formula).to eq(expected_value)
    end
  end
end
