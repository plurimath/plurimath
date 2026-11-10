# frozen_string_literal: true

require "spec_helper"

# MathML 3 section 3.7.1: an maction is read as the child it renders.
RSpec.describe Plurimath::Mathml::Parser do
  describe "maction" do
    def read(body)
      Plurimath::Math.parse(
        "<math xmlns='http://www.w3.org/1998/Math/MathML'>#{body}</math>",
        :mathml,
      )
    end

    it "reads the first child when selection is absent" do
      formula = read("<maction actiontype='toggle'><mi>x</mi><mi>y</mi></maction>")

      expect(formula.to_asciimath).to eq("x")
    end

    it "reads the child named by selection" do
      formula = read(
        "<maction actiontype='toggle' selection='2'><mi>x</mi><mi>y</mi></maction>",
      )

      expect(formula.to_asciimath).to eq("y")
    end

    it "falls back to the first child when selection is out of range" do
      %w[0 3 two].each do |selection|
        formula = read(
          "<maction actiontype='toggle' selection='#{selection}'>" \
          "<mi>x</mi><mi>y</mi></maction>",
        )

        expect(formula.to_asciimath).to eq("x")
      end
    end

    it "keeps the selected child's structure among its siblings" do
      formula = read(
        "<mi>a</mi><mo>+</mo><maction actiontype='statusline'>" \
        "<mfrac><mi>x</mi><mn>2</mn></mfrac><mtext>half of x</mtext></maction>",
      )

      expect(formula.to_asciimath).to eq("a + frac(x)(2)")
    end

    it "reads an empty maction as nothing" do
      expect(read("<mi>a</mi><maction></maction>").to_asciimath).to eq("a")
    end
  end
end
