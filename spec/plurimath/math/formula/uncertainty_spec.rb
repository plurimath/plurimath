# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Math::Formula do
  def num(text)
    Plurimath::Math::Number.new(text)
  end

  def symbol(text)
    Plurimath::Math::Symbols::Symbol.new(text)
  end

  let(:uncertainty) do
    Plurimath::Math::Function::Uncertainty.new(
      num("100.02147"),
      category: :expanded,
      magnitude: num("0.00079"),
      coverage_factor: num("2"),
      unit: Plurimath::Math::Function::Unitsml.new("g"),
    )
  end
  let(:formula) do
    described_class.new([symbol("m"), Plurimath::Math::Symbols::Equal.new,
                         uncertainty])
  end

  describe "an uncertainty nested in a formula" do
    it "writes text formats around the node" do
      expect(formula.to_asciimath)
        .to eq('m = uexp(100.02147, 0.00079, 2, "unitsml(g)")')
      expect(formula.to_latex)
        .to eq("m = (100.02147 \\pm 0.00079) \\mathrm{g},\\ k = 2")
      expect(formula.to_html)
        .to eq("m = (100.02147 &#xb1; 0.00079) g, k = 2")
      expect(formula.to_unicodemath).to eq(
        "m = ⓘ(\"expanded-uncertainty(100.02147,0.00079,2,$unit)\"" \
        "(100.02147±0.00079)ⓐ(unit \\mupg), k=2)",
      )
    end

    it "keeps the marker and the unit space through intent post-processing" do
      [true, false].each do |intent|
        mathml = formula.to_mathml(intent: intent)
        expect(mathml).to include(
          '<mrow intent="expanded-uncertainty(100.02147,0.00079,2,$unit)">',
        )
        expect(mathml).to match(
          %r{<mo rspace="thickmathspace">&#x2062;</mo>\s*<mrow arg="unit">},
        )
        expect(mathml).not_to include("unitsml=")
      end
    end

    it "writes one OMML box inside m:oMath" do
      omml = formula.to_omml
      expect(omml.scan("<m:phant>").length).to eq(1)
      expect(omml).to include(
        "<m:t>expanded-uncertainty(100.02147,0.00079,2,$unit)</m:t>",
      )
    end

    it "lists the node in the math zone display" do
      expect(formula.to_display(:asciimath)).to include(
        '|_ "uexp(100.02147, 0.00079, 2, "unitsml(g)")" uncertainty',
      )
    end

    it "does not turn an ordinary plus-minus into a measurement" do
      plain = described_class.new([num("10.0"), Plurimath::Math::Symbols::Pm.new,
                                   num("0.3")])
      expect(plain.to_mathml).not_to include("intent=")
      expect(plain.to_asciimath).to eq("10.0 pm 0.3")
    end
  end

  describe "#==" do
    it "compares the nested node" do
      other_node = Plurimath::Math::Function::Uncertainty.new(
        num("100.02147"),
        category: :expanded,
        magnitude: num("0.00079"),
        coverage_factor: num("2"),
      )
      other = described_class.new([symbol("m"), Plurimath::Math::Symbols::Equal.new,
                                   other_node])
      expect(formula).not_to eq(other)
      expect(formula).to eq(formula.cloned_objects)
    end
  end

  describe "#cloned_objects" do
    it "clones the nested node independently" do
      clone = formula.cloned_objects
      cloned_node = clone.value.last
      expect(cloned_node).to eq(uncertainty)
      expect(cloned_node).not_to equal(uncertainty)
      expect(cloned_node.value).not_to equal(uncertainty.value)
      expect(cloned_node.unit).not_to equal(uncertainty.unit)

      cloned_node.magnitude.value = "0.9"
      expect(uncertainty.magnitude.value).to eq("0.00079")
    end
  end

  describe "line breaking" do
    it "splits around the node and leaves it whole" do
      broken = described_class.new(
        [uncertainty, Plurimath::Math::Function::Linebreak.new, symbol("x")],
      )
      lines = broken.new_line_support
      expect(lines.length).to eq(2)
      expect(lines.first.value).to include(uncertainty)
      expect(broken.to_mathml(split_on_linebreak: true).scan("<math ").length)
        .to eq(2)
      expect(broken.value.first).to eq(uncertainty)
    end
  end
end
