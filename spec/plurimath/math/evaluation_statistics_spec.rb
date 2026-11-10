require "spec_helper"

RSpec.describe Plurimath::Math::Evaluation::Statistics do
  let(:gum) { Plurimath::Math::Evaluation::Gum }
  let(:reference) { JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum_statistics.json", __dir__))) }

  it "matches independent80-digit normal and Student-t quantiles, including fractional dof" do
    reference.fetch("coverage").each do |vector|
      result = gum.coverage(standard_uncertainty: 2, probability: vector.fetch("probability"),
                            degrees_of_freedom: vector.fetch("degrees_of_freedom"), guard_digits: 8)
      expected = BigDecimal(vector.fetch("factor"))
      actual = BigDecimal(result.fetch(:coverage_factor))
      expect((actual - expected).abs / expected).to be < BigDecimal("6e-8")
      expanded = BigDecimal(vector.fetch("expanded_u2"))
      expect((BigDecimal(result.fetch(:expanded_uncertainty)) - expanded).abs / expanded).to be < BigDecimal("6e-8")
      expect(result[:precision_convention]).to eq(:significant_digits)
    end
  end

  it "refuses requests outside the verified numerical domain" do
    expect { gum.coverage(standard_uncertainty: 1, probability: "0.9999", degrees_of_freedom: nil, guard_digits: 8) }.to raise_error(gum::UnsupportedModel)
    expect { gum.coverage(standard_uncertainty: 1, probability: "0.95", degrees_of_freedom: "0.5", guard_digits: 8) }.to raise_error(gum::UnsupportedModel)
    expect { gum.coverage(standard_uncertainty: 1, probability: "0.95", degrees_of_freedom: nil, guard_digits: 9) }.to raise_error(gum::InvalidInput)
  end

  it "rounds decimal wire values explicitly, including carry and exact large offsets" do
    expect(gum.decimal_output(1r / 3, 8)).to eq("0.33333333")
    expect(gum.decimal_output(9999r / 1000, 3)).to eq("10")
    expect(gum.decimal_output(-125r / 100, 2)).to eq("-1.3")
    expect(gum.decimal_output(10**400, 8)).to eq("1" + "0"*400)
    expect(gum.decimal_places_output(1r / 4, 1)).to eq("0.3")
  end
end
