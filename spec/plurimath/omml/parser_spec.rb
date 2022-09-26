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

  context "contains #033.omml" do
    let(:file_name) { "spec/plurimath/fixtures/033.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Text.new("dθ"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #034.omml" do
    let(:file_name) { "spec/plurimath/fixtures/034.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("∑"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #035.omml" do
    let(:file_name) { "spec/plurimath/fixtures/035.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Symbol.new("∑"),
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("2")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #036.omml" do
    let(:file_name) { "spec/plurimath/fixtures/036.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("∑"),
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("2")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #037.omml" do
    let(:file_name) { "spec/plurimath/fixtures/037.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Symbol.new("∑"),
            Plurimath::Math::Number.new("2"),
            nil,
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #038.omml" do
    let(:file_name) { "spec/plurimath/fixtures/038.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("∑"),
            Plurimath::Math::Number.new("1"),
            nil,
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("2")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #039.omml" do
    let(:file_name) { "spec/plurimath/fixtures/039.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("∏"),
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("2")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #040.omml" do
    let(:file_name) { "spec/plurimath/fixtures/040.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Symbol.new("∐"),
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("2")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #041.omml" do
    let(:file_name) { "spec/plurimath/fixtures/041.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Symbol.new("⋃"),
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

  context "contains #042.omml" do
    let(:file_name) { "spec/plurimath/fixtures/042.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("⋂"),
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Number.new("1"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("2")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #043.omml" do
    let(:file_name) { "spec/plurimath/fixtures/043.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("⋁"),
            Plurimath::Math::Number.new("1"),
            nil,
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("2")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #044.omml" do
    let(:file_name) { "spec/plurimath/fixtures/044.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("⋀"),
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

  context "contains #045.omml" do
    let(:file_name) { "spec/plurimath/fixtures/045.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("∑"),
            Plurimath::Math::Function::Text.new("k"),
            nil,
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Fenced.new(
              nil,
              [
                Plurimath::Math::Function::Frac.new(
                  Plurimath::Math::Function::Text.new("n"),
                  Plurimath::Math::Function::Text.new("k"),
                ),
              ],
              nil,
            )
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #046.omml" do
    let(:file_name) { "spec/plurimath/fixtures/046.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("∑"),
            Plurimath::Math::Function::Text.new("i=0"),
            Plurimath::Math::Function::Text.new("n"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("x")
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #047.omml" do
    let(:file_name) { "spec/plurimath/fixtures/047.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("∑"),
            Plurimath::Math::Function::Table.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("0≤ i ≤ m")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("0<j<n ")
                  ])
                ])
              ],
              nil,
              nil,
            ),
            nil,
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Text.new("P"),
            Plurimath::Math::Function::Fenced.new(
              nil,
              [
                Plurimath::Math::Function::Text.new("i,j"),
              ],
              nil,
            ),
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #048.omml" do
    let(:file_name) { "spec/plurimath/fixtures/048.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("∏"),
            Plurimath::Math::Function::Text.new("k=1"),
            Plurimath::Math::Function::Text.new("n"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Base.new(
              Plurimath::Math::Function::Text.new("A"),
              Plurimath::Math::Function::Text.new("k")
            )
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #049.omml" do
    let(:file_name) { "spec/plurimath/fixtures/049.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            Plurimath::Math::Symbol.new("⋃"),
            Plurimath::Math::Function::Text.new("n=1"),
            Plurimath::Math::Function::Text.new("m"),
          ),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Fenced.new(
              nil,
              [
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("X"),
                  Plurimath::Math::Function::Text.new("n")
                ),
                Plurimath::Math::Symbol.new("∩"),
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("Y"),
                  Plurimath::Math::Function::Text.new("n")
                )
              ],
              nil,
            )
          ])
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #050.omml" do
    let(:file_name) { "spec/plurimath/fixtures/050.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          nil,
          [
            Plurimath::Math::Symbol.new("1"),
          ],
          nil,
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #051.omml" do
    let(:file_name) { "spec/plurimath/fixtures/051.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("["),
          [
            Plurimath::Math::Number.new("2"),
          ],
          Plurimath::Math::Symbol.new("]"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #052.omml" do
    let(:file_name) { "spec/plurimath/fixtures/052.omml" }

    it "matches open and close tag" do
      expected_value =Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
        Plurimath::Math::Symbol.new("{"),
        [
          Plurimath::Math::Symbol.new("3"),
        ],
        Plurimath::Math::Symbol.new("}"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #053.omml" do
    let(:file_name) { "spec/plurimath/fixtures/053.omml" }

    it "matches open and close tag" do
      expected_value =Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
        Plurimath::Math::Symbol.new("〈"),
        [
          Plurimath::Math::Symbol.new("4"),
        ],
        Plurimath::Math::Symbol.new("〉"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #054.omml" do
    let(:file_name) { "spec/plurimath/fixtures/054.omml" }

    it "matches open and close tag" do
      expected_value =Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
        Plurimath::Math::Symbol.new("⌊"),
        [
          Plurimath::Math::Symbol.new("5"),
        ],
        Plurimath::Math::Symbol.new("⌋"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #055.omml" do
    let(:file_name) { "spec/plurimath/fixtures/055.omml" }

    it "matches open and close tag" do
      expected_value =Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
        Plurimath::Math::Symbol.new("⌈"),
        [
          Plurimath::Math::Symbol.new("6"),
        ],
        Plurimath::Math::Symbol.new("⌉"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #056.omml" do
    let(:file_name) { "spec/plurimath/fixtures/056.omml" }

    it "matches open and close tag" do
      expected_value =Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
        Plurimath::Math::Symbol.new("|"),
        [
          Plurimath::Math::Symbol.new("7"),
        ],
        Plurimath::Math::Symbol.new("|"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #057.omml" do
    let(:file_name) { "spec/plurimath/fixtures/057.omml" }

    it "matches open and close tag" do
      expected_value =Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
        Plurimath::Math::Symbol.new("‖"),
        [
          Plurimath::Math::Symbol.new("8"),
        ],
        Plurimath::Math::Symbol.new("‖"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #058.omml" do
    let(:file_name) { "spec/plurimath/fixtures/058.omml" }

    it "matches open and close tag" do
      expected_value =Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
        Plurimath::Math::Symbol.new("["),
        [
          Plurimath::Math::Symbol.new("9"),
        ],
        Plurimath::Math::Symbol.new("["),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #059.omml" do
    let(:file_name) { "spec/plurimath/fixtures/059.omml" }

    it "matches open and close tag" do
      expected_value =Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
        Plurimath::Math::Symbol.new("]"),
        [
          Plurimath::Math::Symbol.new("0"),
        ],
        Plurimath::Math::Symbol.new("]"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #060.omml" do
    let(:file_name) { "spec/plurimath/fixtures/060.omml" }

    it "matches open and close tag" do
      expected_value =Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
        Plurimath::Math::Symbol.new("]"),
        [
          Plurimath::Math::Symbol.new("1"),
        ],
        Plurimath::Math::Symbol.new("["),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #061.omml" do
    let(:file_name) { "spec/plurimath/fixtures/061.omml" }

    it "matches open and close tag" do
      expected_value =Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
        Plurimath::Math::Symbol.new("⟦"),
        [
          Plurimath::Math::Symbol.new("2"),
        ],
        Plurimath::Math::Symbol.new("⟧"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #062.omml" do
    let(:file_name) { "spec/plurimath/fixtures/062.omml" }

    it "matches open and close tag" do
      expected_value =Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
        nil,
        [
          Plurimath::Math::Symbol.new("1"),
          Plurimath::Math::Symbol.new("2"),
        ],
        nil,
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #063.omml" do
    let(:file_name) { "spec/plurimath/fixtures/063.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("{"),
          [
            Plurimath::Math::Number.new("3"),
            Plurimath::Math::Number.new("4"),
          ],
          Plurimath::Math::Symbol.new("}"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #064.omml" do
    let(:file_name) { "spec/plurimath/fixtures/064.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("⟨"),
          [
            Plurimath::Math::Number.new("5"),
            Plurimath::Math::Number.new("6"),
          ],
          Plurimath::Math::Symbol.new("⟩"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #065.omml" do
    let(:file_name) { "spec/plurimath/fixtures/065.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("⟨"),
          [
            Plurimath::Math::Number.new("7"),
            Plurimath::Math::Number.new("8"),
            Plurimath::Math::Number.new("9"),
          ],
          Plurimath::Math::Symbol.new("⟩"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #066.omml" do
    let(:file_name) { "spec/plurimath/fixtures/066.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("{"),
          [
            Plurimath::Math::Function::Table.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("1"),
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("2"),
                  ])
                ])
              ],
              nil,
              nil,
            )
          ],
          Plurimath::Math::Symbol.new(""),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #067.omml" do
    let(:file_name) { "spec/plurimath/fixtures/067.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("{"),
          [
            Plurimath::Math::Function::Table.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("1")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("2")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Number.new("3")
                  ])
                ])
              ],
              nil,
              nil
            )
          ],
          Plurimath::Math::Symbol.new(""),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #068.omml" do
    let(:file_name) { "spec/plurimath/fixtures/068.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Function::Text.new("b"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #069.omml" do
    let(:file_name) { "spec/plurimath/fixtures/069.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          nil,
          [
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Function::Text.new("m"),
            )
          ],
          nil,
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #070.omml" do
    let(:file_name) { "spec/plurimath/fixtures/070.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Text.new("f"),
        Plurimath::Math::Function::Fenced.new(
          nil,
          [
            Plurimath::Math::Function::Text.new("x")
          ],
          nil,
        ),
        Plurimath::Math::Symbol.new("="),
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("{"),
          [
            Plurimath::Math::Function::Table.new(
              [
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("-x, &x<0")
                  ])
                ]),
                Plurimath::Math::Function::Tr.new([
                  Plurimath::Math::Function::Td.new([
                    Plurimath::Math::Function::Text.new("x, &x≥0")
                  ])
                ])
              ],
              nil,
              nil,
            )
          ],
          Plurimath::Math::Symbol.new(""),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #071.omml" do
    let(:file_name) { "spec/plurimath/fixtures/071.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          nil,
          [
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Function::Text.new("k"),
            )
          ],
          nil,
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #072.omml" do
    let(:file_name) { "spec/plurimath/fixtures/072.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("⟨"),
          [
            Plurimath::Math::Function::Frac.new(
              Plurimath::Math::Function::Text.new("n"),
              Plurimath::Math::Function::Text.new("k"),
            )
          ],
          Plurimath::Math::Symbol.new("⟩"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #073.omml" do
    let(:file_name) { "spec/plurimath/fixtures/073.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Sin.new(
          Plurimath::Math::Function::Text.new("x")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #074.omml" do
    let(:file_name) { "spec/plurimath/fixtures/074.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Cos.new(
          Plurimath::Math::Function::Text.new("x")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #075.omml" do
    let(:file_name) { "spec/plurimath/fixtures/075.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Tan.new(
          Plurimath::Math::Function::Text.new("x")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #076.omml" do
    let(:file_name) { "spec/plurimath/fixtures/076.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Csc.new(
          Plurimath::Math::Function::Text.new("x")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #077.omml" do
    let(:file_name) { "spec/plurimath/fixtures/077.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Sec.new(
          Plurimath::Math::Function::Text.new("x")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #078.omml" do
    let(:file_name) { "spec/plurimath/fixtures/078.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Cot.new(
          Plurimath::Math::Function::Text.new("x")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #079.omml" do
    let(:file_name) { "spec/plurimath/fixtures/079.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("sin"),
            Plurimath::Math::Symbol.new("-1")
          ),
          Plurimath::Math::Function::Text.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #080.omml" do
    let(:file_name) { "spec/plurimath/fixtures/080.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("cos"),
            Plurimath::Math::Symbol.new("-1")
          ),
          Plurimath::Math::Function::Text.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #081.omml" do
    let(:file_name) { "spec/plurimath/fixtures/081.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("tan"),
            Plurimath::Math::Symbol.new("-1")
          ),
          Plurimath::Math::Function::Text.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #082.omml" do
    let(:file_name) { "spec/plurimath/fixtures/082.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("csc"),
            Plurimath::Math::Symbol.new("-1")
          ),
          Plurimath::Math::Function::Text.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #083.omml" do
    let(:file_name) { "spec/plurimath/fixtures/083.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("sec"),
            Plurimath::Math::Symbol.new("-1")
          ),
          Plurimath::Math::Function::Text.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #084.omml" do
    let(:file_name) { "spec/plurimath/fixtures/084.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("cot"),
            Plurimath::Math::Symbol.new("-1")
          ),
          Plurimath::Math::Function::Text.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #085.omml" do
    let(:file_name) { "spec/plurimath/fixtures/085.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Sinh.new(
          Plurimath::Math::Function::Text.new("x")
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #086.omml" do
    let(:file_name) { "spec/plurimath/fixtures/086.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Cosh.new(
          Plurimath::Math::Function::Text.new("x")
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #087.omml" do
    let(:file_name) { "spec/plurimath/fixtures/087.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Tanh.new(
          Plurimath::Math::Function::Text.new("x")
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #088.omml" do
    let(:file_name) { "spec/plurimath/fixtures/088.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Csch.new(
          Plurimath::Math::Function::Text.new("x")
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #089.omml" do
    let(:file_name) { "spec/plurimath/fixtures/089.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Sech.new(
          Plurimath::Math::Function::Text.new("x")
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #090.omml" do
    let(:file_name) { "spec/plurimath/fixtures/090.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Coth.new(
          Plurimath::Math::Function::Text.new("x")
        ),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #091.omml" do
    let(:file_name) { "spec/plurimath/fixtures/091.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("sinh"),
            Plurimath::Math::Symbol.new("-1")
          ),
          Plurimath::Math::Function::Text.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #092.omml" do
    let(:file_name) { "spec/plurimath/fixtures/092.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("cosh"),
            Plurimath::Math::Symbol.new("-1")
          ),
          Plurimath::Math::Function::Text.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #093.omml" do
    let(:file_name) { "spec/plurimath/fixtures/093.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("tanh"),
            Plurimath::Math::Symbol.new("-1")
          ),
          Plurimath::Math::Function::Text.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #094.omml" do
    let(:file_name) { "spec/plurimath/fixtures/094.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("csch"),
            Plurimath::Math::Symbol.new("-1")
          ),
          Plurimath::Math::Function::Text.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #095.omml" do
    let(:file_name) { "spec/plurimath/fixtures/095.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("sech"),
            Plurimath::Math::Symbol.new("-1")
          ),
          Plurimath::Math::Function::Text.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #096.omml" do
    let(:file_name) { "spec/plurimath/fixtures/096.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Function::Text.new("coth"),
            Plurimath::Math::Symbol.new("-1")
          ),
          Plurimath::Math::Function::Text.new("x")
        ])
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #097.omml" do
    let(:file_name) { "spec/plurimath/fixtures/097.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Sin.new(
          Plurimath::Math::Symbol.new("θ")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #098.omml" do
    let(:file_name) { "spec/plurimath/fixtures/098.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Cos.new(
          Plurimath::Math::Function::Text.new("2x")
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #099.omml" do
    let(:file_name) { "spec/plurimath/fixtures/099.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Tan.new(
          Plurimath::Math::Symbol.new("θ")
        ),
        Plurimath::Math::Symbol.new("="),
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Symbol.new("θ")
          ),
          Plurimath::Math::Function::Cos.new(
            Plurimath::Math::Symbol.new("θ")
          )
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #100.omml" do
    let(:file_name) { "spec/plurimath/fixtures/100.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Symbol.new("̇"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #101.omml" do
    let(:file_name) { "spec/plurimath/fixtures/101.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Symbol.new("̈"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #102.omml" do
    let(:file_name) { "spec/plurimath/fixtures/102.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Symbol.new("⃛"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #103.omml" do
    let(:file_name) { "spec/plurimath/fixtures/103.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Function::Text.new("a"),
          Plurimath::Math::Symbol.new("^"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #104.omml" do
    let(:file_name) { "spec/plurimath/fixtures/104.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Function::Text.new("b"),
          Plurimath::Math::Symbol.new("̌"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #105.omml" do
    let(:file_name) { "spec/plurimath/fixtures/105.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Function::Text.new("b"),
          Plurimath::Math::Symbol.new("́"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #106.omml" do
    let(:file_name) { "spec/plurimath/fixtures/106.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Function::Text.new("b"),
          Plurimath::Math::Symbol.new("̀"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #107.omml" do
    let(:file_name) { "spec/plurimath/fixtures/107.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Function::Text.new("b"),
          Plurimath::Math::Symbol.new("̆"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #108.omml" do
    let(:file_name) { "spec/plurimath/fixtures/108.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Function::Text.new("c"),
          Plurimath::Math::Symbol.new("̃"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #109.omml" do
    let(:file_name) { "spec/plurimath/fixtures/109.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Function::Text.new("c"),
          Plurimath::Math::Symbol.new("̅"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #110.omml" do
    let(:file_name) { "spec/plurimath/fixtures/110.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Function::Text.new("c"),
          Plurimath::Math::Symbol.new("̿"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #111.omml" do
    let(:file_name) { "spec/plurimath/fixtures/111.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Function::Text.new("c"),
          Plurimath::Math::Symbol.new("⏞"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #112.omml" do
    let(:file_name) { "spec/plurimath/fixtures/112.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Underset.new(
          Plurimath::Math::Symbol.new("⏟"),
          Plurimath::Math::Function::Text.new("d"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains #113.omml" do
    let(:file_name) { "spec/plurimath/fixtures/113.omml" }

    it "matches open and close tag" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Overset.new(
          Plurimath::Math::Function::Overset.new(
            Plurimath::Math::Function::Text.new("e"),
            Plurimath::Math::Symbol.new("⏞")
          ),
          Plurimath::Math::Function::Text.new("d"),
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end
end
