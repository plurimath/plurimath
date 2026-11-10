require "spec_helper"

RSpec.describe Plurimath::Math::Evaluation::Calibration do
  let(:gum) { Plurimath::Math::Evaluation::Gum }
  let(:inputs) { JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum_annex_h.json", __dir__))).fetch("h3") }
  let(:reference) { JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum_annex_reference.json", __dir__))).fetch("h3") }

  def fit(reference_temperature = "20")
    gum.linear_calibration(temperatures: inputs.fetch("temperatures_C"), corrections: inputs.fetch("corrections_C"),
      reference_temperature: reference_temperature, abscissa_uncertainty: :negligible,
      residual_model: :independent_common_variance, guard_digits: 40)
  end

  it "matches the independent centered least-squares H.3 calculation" do
    result = fit
    expect(result[:intercept]).to eq(Rational(reference.fetch("intercept")))
    expect(result[:slope]).to eq(Rational(reference.fetch("slope")))
    expected = reference.fetch("covariance").map { |row| row.map { |value| Rational(value) } }
    expect(result[:covariance]).to eq(expected)
    expect(result[:degrees_of_freedom]).to eq(9)
    correlation = gum.correlation_matrix(result[:covariance], guard_digits: 40)[0][1]
    expect((correlation-BigDecimal(reference.fetch("correlation"))).abs).to be < BigDecimal("1e-35")
  end

  it "preserves predictions under a change of reference temperature" do
    first = gum.predict_calibration(fit, temperature: 30, target: :mean_correction, temperature_uncertainty: :negligible, guard_digits: 40)
    second = gum.predict_calibration(fit("24.0085"), temperature: 30, target: :mean_correction, temperature_uncertainty: :negligible, guard_digits: 40)
    expect(first[:estimate]).to eq(Rational(reference.fetch("prediction")))
    expect(first[:variance]).to eq(Rational(reference.fetch("prediction_variance")))
    expect(first[:estimate]).to eq(second[:estimate])
    expect(first[:variance]).to eq(second[:variance])
    expect(first[:outside_calibration_range]).to be(true)
    observation = gum.predict_calibration(fit, temperature: 30, target: :new_observation, temperature_uncertainty: :negligible, guard_digits: 40)
    expect(observation[:variance]-first[:variance]).to eq(fit[:residual_variance])
  end

  it "refuses an unprovided errors-in-variables model or singular design" do
    expect { gum.linear_calibration(temperatures:[1,1,1],corrections:[1,2,3],reference_temperature:0,
      abscissa_uncertainty: :negligible,residual_model: :independent_common_variance,guard_digits:40) }.to raise_error(gum::InvalidInput)
    expect { gum.linear_calibration(temperatures:[1,2,3],corrections:[1,2,3],reference_temperature:0,
      abscissa_uncertainty: :significant,residual_model: :independent_common_variance,guard_digits:40) }.to raise_error(gum::UnsupportedModel)
  end
end
