require "spec_helper"

RSpec.describe "Certified rational MCM" do
  let(:gum) { Plurimath::Math::Evaluation::Gum }

  it "evaluates the actual reciprocal rather than a truncated Taylor approximation" do
    formula = Plurimath::Math.parse("1/x", :asciimath)
    model = Plurimath::Math::Evaluation::RationalSamplingCompiler.new(formula,["x"],[Rational(3,2)],[{distribution: :rectangular,lower: 1,upper: 2}]).compile(formula)
    expect(model.denominator_interval).to eq([1,2])
    [-0.5,-0.25,0,0.25,0.5].each do |deviation|
      expected = Rational(1,1)/(Rational(3,2)+deviation.to_r)-Rational(2,3)
      expect(model.call([deviation])).to be_within(1e-15).of(expected.to_f)
    end
  end

  it "refuses support crossing zero and unbounded normal denominators" do
    formula = Plurimath::Math.parse("1/x", :asciimath)
    compiler = Plurimath::Math::Evaluation::RationalSamplingCompiler
    expect { compiler.new(formula,["x"],[0r],[{distribution: :rectangular,lower: -1,upper: 1}]).compile(formula) }.to raise_error(gum::UnsupportedModel, /includes zero/)
    expect { compiler.new(formula,["x"],[1r],[{distribution: :normal,location: 1,sd: "0.01"}]).compile(formula) }.to raise_error(gum::UnsupportedModel, /finite output moments/)
  end

  it "matches the actual mixed-PDF mass-calibration population at declared one-digit adaptive precision" do
    inputs = JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum5_inputs.json", __dir__))).fetch("mass_calibration")
    reference = JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum5_reference.json", __dir__))).fetch("mass_calibration")
    pdfs = {}
    %i[p q].each_with_index { |name,i| pdfs[name] = {distribution: :normal,location: inputs.fetch("mass_means_mg")[i],sd: inputs.fetch("mass_standard_uncertainties_mg")[i]} }
    %i[a w r].each_with_index do |name,i|
      center = Rational(inputs.fetch("density_means_kg_m3")[i]); half = Rational(inputs.fetch("density_half_widths_kg_m3")[i])
      pdfs[name] = {distribution: :rectangular,lower: center-half,upper: center+half}
    end
    formula = Plurimath::Math.parse("(p+q)*(1+(a-1.2)*(1/w-1/r))-100000", :asciimath)
    result = gum.monte_carlo(formula,inputs: pdfs,independent: true,seeds: [12345,23456,34567,45678],probability: "0.95",interval: :both,significant_digits: 1,guard_digits: 10,max_samples: 100000)
    expect((BigDecimal(result[:estimate])-BigDecimal(reference.fetch("mean"))).abs).to be < BigDecimal("0.005")
    expect((BigDecimal(result[:standard_uncertainty])-BigDecimal(reference.fetch("standard_uncertainty"))).abs).to be < BigDecimal("0.005")
    expect(result[:engine][:numeric_backend]).to eq("binary64-centered-certified-rational")
    expect(result[:engine][:certificate]).to eq("exact-rectangular-support-interval-v1")
    expect(result[:stabilized]).to eq(true)
  end
end
