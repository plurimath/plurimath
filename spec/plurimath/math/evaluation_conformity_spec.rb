require "spec_helper"

RSpec.describe Plurimath::Math::Evaluation::Conformity do
  let(:gum) { Plurimath::Math::Evaluation::Gum }
  let(:reference) { JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum_statistics.json", __dir__))) }

  def assess(**options)
    gum.conformity(estimate: 0, standard_uncertainty: 1, distribution: :normal,
                   knowledge: :measurement_only, tolerance: [-2, 2], rule: :simple,
                   coverage_factor: 2, guard_ratio: 0, guard_digits: 12, **options)
  end

  it "matches the exact probabilities at the rounded z values in JCGM106 Table1" do
    reference.fetch("jcgm106_table1").each do |vector|
      result = assess(estimate: vector.fetch("published_rounded_z"), tolerance: [0, nil])
      expect((BigDecimal(result[:conformance_probability]) - BigDecimal(vector.fetch("pc_at_rounded_z"))).abs).to be < BigDecimal("1e-12")
    end
  end

  it "reproduces both one-sided examples with their unrounded inputs" do
    %w[diode burst].each do |id|
      vector = reference.fetch("conformity").find { |row| row.fetch("id") == id }
      result = assess(estimate: vector.fetch("estimate"), standard_uncertainty: vector.fetch("u"),
                      tolerance: [vector.fetch("lower"), vector.fetch("upper")])
      expect((BigDecimal(result[:conformance_probability]) - BigDecimal(vector.fetch("pc"))).abs).to be < BigDecimal("1e-12")
    end
  end

  it "computes exact two-tail risk instead of assuming an unconditional2.3percent ceiling" do
    vector = reference.fetch("conformity").find { |row| row.fetch("id") == "iso_cm1" }
    result = assess(rule: :iso14253_style, guard_ratio: 1)
    expect(result[:decision]).to eq(:accept)
    expect(result[:boundary]).to be(true)
    expect(Rational(result[:measurement_capability_index])).to eq(1)
    expect((BigDecimal(result[:specific_consumer_risk]) - BigDecimal(vector.fetch("nonconformance"))).abs).to be < BigDecimal("1e-12")
    expect(result[:iso_2p3_percent_ceiling_holds]).to be(false)
    expect { assess(rule: :iso14253_style, guard_ratio: 1, consumer_risk_ceiling: "0.023") }.to raise_error(gum::UnsupportedModel, /geometry/)
    wide = assess(estimate: 2, tolerance: [-4, 4], rule: :iso14253_style, guard_ratio: 1, consumer_risk_ceiling: "0.023")
    expect(wide[:iso_2p3_percent_ceiling_holds]).to be(true)
    expect(Rational(wide[:measurement_capability_index])).to eq(2)
  end

  it "assigns specific producer risk only for a rejection" do
    vector = reference.fetch("conformity").find { |row| row.fetch("id") == "guarded_rejection" }
    result = assess(estimate: 3, tolerance: [nil, 0], rule: :guarded_rejection, guard_ratio: 1)
    expect(result[:decision]).to eq(:reject)
    expect(result[:specific_consumer_risk]).to be_nil
    expect((BigDecimal(result[:specific_producer_risk]) - BigDecimal(vector.fetch("pc"))).abs).to be < BigDecimal("1e-12")
    expect(Rational(result[:signed_guard_band])).to eq(-2)
  end

  it "represents a boundary-conditional three-zone outcome and signed residuals" do
    result = assess(estimate: 3, rule: :three_zone, coverage_factor: 1, guard_ratio: 1)
    expect(result[:decision]).to eq(:conditional)
    expect(result[:boundary]).to be(true)
    expect(Rational(result[:upper_residual])).to eq(-1)
    expect(result[:specific_consumer_risk]).to be_nil
    expect(result[:specific_producer_risk]).to be_nil
    expect(assess(estimate: "3.1", rule: :three_zone, coverage_factor: 1, guard_ratio: 1)[:decision]).to eq(:reject)
  end

  it "refuses global risks and unprovided prior/non-normal models" do
    expect { assess(risk_scope: :global) }.to raise_error(gum::UnsupportedModel, /joint PDF/)
    expect { assess(distribution: :student_t) }.to raise_error(gum::UnsupportedModel)
    expect { assess(knowledge: :informative_prior) }.to raise_error(gum::UnsupportedModel)
    result = assess(tolerance: [-1, 1], rule: :iso14253_style, guard_ratio: 1)
    expect(result[:acceptance_possible]).to be(false)
    expect(result[:decision]).to eq(:reject)
    expect(result[:maximum_specific_consumer_risk_if_accepted]).to be_nil
  end
end
