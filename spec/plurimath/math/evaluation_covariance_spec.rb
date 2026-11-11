require "spec_helper"

RSpec.describe Plurimath::Math::Evaluation::Covariance do
  let(:gum) { Plurimath::Math::Evaluation::Gum }
  let(:reference) { JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum_annex_reference.json", __dir__))) }

  it "preserves paired covariance of means and exact singular covariance" do
    data = gum.type_a_covariance([[1,2],[2,4],[3,6]])
    expect(data[:means]).to eq([2,4])
    expect(data[:covariance_of_mean]).to eq([[1r/3,2r/3],[2r/3,4r/3]])
    result = gum.propagate_covariance(estimate: 0, components: [{variance:1r/3},{variance:4r/3}],
                gradient: [2,-1], covariance: data[:covariance_of_mean], joint_distribution: :unspecified, guard_digits: 40)
    expect(result[:variance]).to eq(0)
    expect(result[:degrees_of_freedom_status]).to eq(:not_evaluated_for_correlated_inputs)
  end

  it "retains the covariance between vector outputs" do
    result = gum.propagate_vector(estimates: [0,0], jacobian: [[1,2],[3,4]], covariance: [[1,0],[0,1]], guard_digits: 40)
    expect(result[:covariance]).to eq([[5,11],[11,25]])
  end

  it "matches independently expanded joint Gaussian moments including cross third derivatives" do
    reference.fetch("gaussian_covariance").each do |vector|
      result = gum.propagate_covariance(estimate: vector.fetch("estimate"),
                 components: [{variance:1,distribution: :normal},{variance:1,distribution: :normal}],
                 gradient: vector.fetch("gradient"), covariance: vector.fetch("covariance"),
                 joint_distribution: :multivariate_normal, order: 2,
                 hessian: vector.fetch("hessian"), third: vector.fetch("third"),
                 derivatives_complete: true, guard_digits: 40)
      expect(result[:estimate]).to eq(Rational(vector.fetch("corrected_mean")))
      expect(result[:variance]).to eq(Rational(vector.fetch("variance_through_covariance_order2")))
    end
  end

  it "does not infer joint normality from normal marginals and zero covariance" do
    expect { gum.propagate_covariance(estimate: 0,
      components: [{variance:1,distribution: :normal},{variance:1,distribution: :normal}],
      gradient: [0,0], covariance: [[1,0],[0,1]], joint_distribution: :unspecified,
      order: 2, hessian: [[0,1],[1,0]], third: [[[0,0],[0,0]],[[0,0],[0,0]]],
      derivatives_complete: true, guard_digits: 40) }.to raise_error(gum::UnsupportedModel, /joint multivariate normal/)
  end

  it "refuses asymmetric or indefinite covariance without adding diagonal jitter" do
    [[[1,2],[2,1]],[[0,1],[1,1]],[[1,1],[0,1]]].each do |covariance|
      expect { gum.propagate_vector(estimates: [0], jacobian: [[1,1]], covariance: covariance, guard_digits: 40) }.to raise_error(gum::InvalidInput)
    end
  end

  it "keeps Student-t PDF shape separate from variance-estimate degrees of freedom" do
    component = gum.component(distribution: :student_t, scale: 1, pdf_degrees_of_freedom: 3)
    expect(component[:variance]).to eq(3)
    expect(component[:pdf_degrees_of_freedom]).to eq(3)
    expect(component[:degrees_of_freedom]).to eq(:unknown)
    result = gum.propagate(estimate: 0, components: [component], gradient: [1], independent: true, guard_digits: 40)
    expect(result[:effective_degrees_of_freedom]).to be_nil
    expect(result[:degrees_of_freedom_status]).to eq(:unknown)
    known = gum.component(distribution: :student_t, scale: 1, pdf_degrees_of_freedom: 3, variance_degrees_of_freedom: 10)
    expect(gum.propagate(estimate:0,components:[known],gradient:[1],independent:true,guard_digits:40)[:effective_degrees_of_freedom]).to eq(10)
  end
end
