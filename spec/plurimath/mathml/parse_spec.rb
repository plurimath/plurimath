require_relative "../../../lib/plurimath/math"
require_relative "../../../lib/plurimath/mathml/parse"
require_relative "../../../lib/plurimath/mathml/constants"

RSpec.describe Plurimath::Mathml::Parse do

  subject(:formula) { Plurimath::Mathml::Parse.new.parse(exp.gsub("\n", "").gsub(" ", "")) }

  context "contains opening and closing tag" do
    let (:exp) { "<math xmlns='http://www.w3.org/1998/Math/MathML'></math>" }

    it "matches open and close tag" do
      expect(formula[:open]).to eq("math")
      expect(formula[:close]).to eq("math")
    end

    it "matches attributes" do
      expect(formula[:attributes].first[:name]).to eq("xmlns")
      expect(formula[:attributes].last[:value]).to eq("http://www.w3.org/1998/Math/MathML")
    end
  end

  context "contains multiple tags without attributes" do
    let(:exp) { "<math><mstyle></mstyle></math>" }

    it "matches mathml attributes values" do
      expect(formula[:open]).to eq("math")
      expect(formula[:iteration][:tag][:open]).to eq("mstyle")
      expect(formula[:iteration][:tag][:close]).to eq("mstyle")
      expect(formula[:close]).to eq("math")
    end

    it "should match empty array for attributes" do
      expect(formula[:attributes]).to eq([])
      expect(formula[:iteration][:tag][:attributes]).to eq([])
    end
  end

  context "contains mathml string of sum formula" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <munderover>
            <mo>&#x2211;</mo>
            <mrow>
              <mo>1</mo>
            </mrow>
            <mo>&#x22c1;</mo>
          </munderover>
        </math>
      MATHML
    }

    it "returns formula of sum and prod" do
      iteration = formula[:iteration][:tag][:iteration]
      sequence = iteration[:sequence]
      expect(iteration[:tag][:iteration][:symbol]).to eq("&#x2211;")
      expect(sequence[:tag][:iteration][:tag][:iteration][:number]).to eq("1")
      expect(sequence[:sequence][:tag][:iteration][:symbol]).to eq("&#x22c1;")
    end
  end

  context "contains mathml string of sub tag" do
    let(:exp) {
      <<~MATHML
        <math xmlns='http://www.w3.org/1998/Math/MathML'>
          <mrow>
            <msub>
              <mi>xyz</mi>
              <mi>s</mi>
            </msub>
          </mrow>
        </math>
      MATHML
    }
    it "should match values" do
      iteration = formula[:iteration][:tag][:iteration][:tag][:iteration]
      expect(iteration[:tag][:iteration][:text]).to eq("xyz")
      expect(iteration[:sequence][:tag][:iteration][:text]).to eq("s")
    end
  end
end
