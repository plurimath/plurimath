require "spec_helper"

RSpec.describe "Declared GUM5 input profiles" do
  let(:gum) { Plurimath::Math::Evaluation::Gum }
  let(:inputs) { JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum5_inputs.json", __dir__))) }
  let(:reference) { JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum5_reference.json", __dir__))) }

  def decimal(value)
    value.is_a?(Rational) ? BigDecimal(value.numerator, 70).div(value.denominator, 70) : BigDecimal(value.to_s)
  end

  def close(actual, expected, tolerance = "1e-45")
    expect((decimal(actual) - decimal(expected)).abs).to be < BigDecimal(tolerance)
  end

  it "propagates an implicit ten-temperature model while retaining shared calibration covariance" do
    data = inputs.fetch("thermometer")
    r0, a, b, rs = %w[R0 A B RS].map { |key| Rational(data.fetch(key)) }
    ratios = data.fetch("W").map { |value| Rational(value) }
    roots = Plurimath::Math::Evaluation::Accuracy.with_decimal_context do
      BigDecimal.limit(90)
      ratios.map do |w|
        t = BigDecimal("20")
        12.times do
          residual = (1 + a*t + b*t*t)*r0 - w*rs
          break if residual.abs < BigDecimal("1e-75")
          t -= residual.div((a + 2*b*t)*r0, 85)
        end
        t.to_r
      end
    end
    size = 4 + ratios.length
    u = data.fetch("standard_uncertainties").map { |value| Rational(value) }
    cov = Array.new(size) { |i| Array.new(size) { |j| i == j ? u[i < 4 ? i : 4]**2 : 0r } }
    3.times { |i| 3.times { |j| cov[i][j] = u[i]*u[j]*Rational(data.fetch("parameter_correlations")[i][j]) } }
    cy = roots.each_index.map { |i| roots.each_index.map { |j| i == j ? (a + 2*b*roots[i])*r0 : 0r } }
    cx = roots.each_with_index.map do |t, i|
      [1+a*t+b*t*t, r0*t, r0*t*t, -ratios[i]] + ratios.each_index.map { |j| i == j ? -rs : 0r }
    end
    residuals = roots.each_with_index.map { |t, i| (1+a*t+b*t*t)*r0-ratios[i]*rs }
    result = gum.propagate_implicit(estimates: roots, output_jacobian: cy,
      input_jacobian: cx, covariance: cov, residuals: residuals,
      residual_tolerance: "1e-70", guard_digits: 65)
    expected = reference.fetch("thermometer")
    roots.each_index do |i|
      close(result[:estimates][i], expected.fetch("estimates")[i])
      close(result[:standard_uncertainties][i], expected.fetch("standard_uncertainties")[i])
      close(result[:estimates][i], data.fetch("published_temperatures")[i], "0.00005")
      close(result[:standard_uncertainties][i], data.fetch("published_uncertainties")[i], "0.00005")
      roots.each_index { |j| close(result[:covariance][i][j], expected.fetch("output_covariance")[i][j]) }
    end
    expect(result[:covariance][5][9]).not_to eq(result[:covariance][5][5])
    expect(result[:covariance][5][9]).not_to eq(0)
    expect(result[:adequacy]).to eq(:not_assessed)
  end

  it "uses exact pivoting and refuses singular Jacobians or unsupported root residuals" do
    args = { estimates: [0,0], output_jacobian: [[0,1],[1,0]], input_jacobian: [[1],[2]], covariance: [[3]], residuals: [0,0], residual_tolerance: 0, guard_digits: 40 }
    result = gum.propagate_implicit(**args)
    expect(result[:input_sensitivities]).to eq([[-2],[-1]])
    expect(result[:covariance]).to eq([[12,6],[6,3]])
    expect { gum.propagate_implicit(**args.merge(output_jacobian: [[1,1],[1,1]])) }.to raise_error(gum::UnsupportedModel, /singular/)
    expect { gum.propagate_implicit(**args.merge(residuals: [1,0])) }.to raise_error(gum::UnsupportedModel, /residual/)
  end

  it "matches all six analytic correlated Gaussian comparison-loss moments, including vanishing first derivatives" do
    reference.fetch("comparison_loss").each do |vector|
      x = Rational(vector.fetch("x1")); rho = Rational(vector.fetch("correlation")); v = Rational(inputs.fetch("comparison_loss").fetch("standard_uncertainty"))**2
      result = gum.propagate_covariance(estimate: x*x, components: [{variance:v,distribution: :normal},{variance:v,distribution: :normal}], gradient: [2*x,0], covariance: [[v,rho*v],[rho*v,v]], joint_distribution: :multivariate_normal, order: 2, hessian: [[2,0],[0,2]], third: [[[0,0],[0,0]],[[0,0],[0,0]]], derivatives_complete: true, guard_digits: 50)
      expect(result[:estimate]).to eq(Rational(vector.fetch("mean")))
      expect(result[:variance]).to eq(Rational(vector.fetch("variance")))
      lpu = gum.propagate_covariance(estimate: x*x, components: [{variance:v},{variance:v}], gradient: [2*x,0], covariance: [[v,rho*v],[rho*v,v]], joint_distribution: :multivariate_normal, guard_digits: 50)
      expect(lpu[:variance]).to eq(Rational(vector.fetch("lpu_variance")))
    end
  end

  it "detects the bromine vanishing-gradient boundary under the source's explicit normal PDF" do
    data = JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum6_bromine.json", __dir__)))
    formula = Plurimath::Math.parse(data.fetch("model"), :asciimath)
    component = gum.component(distribution: :normal, standard_uncertainty: data.fetch("standard_uncertainty"))
    args = { estimates: {x: data.fetch("estimate")}, components: {x: component}, independent: true, guard_digits: 50 }
    lpu = gum.analyze(formula, **args)
    corrected = gum.analyze(formula, **args, order: 2)
    expect(lpu[:variance]).to eq(0)
    expect(corrected[:estimate]).to eq(Rational(reference.fetch("bromine").fetch("mean")))
    expect(corrected[:variance]).to eq(Rational(reference.fetch("bromine").fetch("variance")))
    close(corrected[:estimate], data.fetch("published_estimate"))
    close(corrected[:standard_uncertainty], data.fetch("published_standard_uncertainty"), "0.000005")
    expect(corrected[:adequacy]).to eq(:not_assessed)
  end

  it "retains linear-sum variance under the declared normal and rectangular conventions" do
    reference.fetch("linear_sum").each_with_index do |vector, i|
      values = inputs.fetch("linear_sum").fetch("standard_uncertainties")[i]
      components = values.map { |value| { variance: Rational(value)**2, distribution: vector.fetch("distribution").to_sym } }
      result = gum.propagate(estimate: 0, components: components, gradient: [1,1,1,1], independent: true, guard_digits: 50)
      expect(result[:variance]).to eq(Rational(vector.fetch("variance")))
    end
  end

  it "evaluates mass-calibration LPU with the actual nonnormal components and refuses a normal-only GUF2 substitution" do
    data = inputs.fetch("mass_calibration")
    estimates = %i[p q a w r].zip(data.fetch("mass_means_mg")+data.fetch("density_means_kg_m3")).to_h
    components = %i[p q].zip(data.fetch("mass_standard_uncertainties_mg").map { |u| gum.component(distribution: :normal, standard_uncertainty: u) }).to_h
    components.merge!(%i[a w r].zip(data.fetch("density_half_widths_kg_m3").map { |h| gum.component(distribution: :rectangular, half_width: h) }).to_h)
    formula = Plurimath::Math.parse("(p+q)*(1+(a-1.2)*(1/w-1/r))-100000", :asciimath)
    result = gum.analyze(formula, estimates: estimates, components: components, independent: true, guard_digits: 50)
    close(result[:estimate], reference.fetch("mass_calibration").fetch("mean"))
    close(result[:variance], reference.fetch("mass_calibration").fetch("lpu_variance"))
    expect { gum.analyze(formula, estimates: estimates, components: components, independent: true, order: 2, guard_digits: 50) }.to raise_error(gum::UnsupportedModel, /normal/)
  end
end
