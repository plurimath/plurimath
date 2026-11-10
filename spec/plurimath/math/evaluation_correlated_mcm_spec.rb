require "spec_helper"

RSpec.describe "Explicit joint-normal MCM" do
  let(:gum) { Plurimath::Math::Evaluation::Gum }
  let(:definitions) { [{distribution: :normal,location: 0,sd: "0.005"},{distribution: :normal,location: 0,sd: "0.005"}] }
  let(:variance) { Rational("0.005")**2 }

  it "preserves exactly singular positive and negative correlation without jitter" do
    [1,-1].each do |sign|
      generator = Plurimath::Math::Evaluation::WichmannHill.new([12345,23456,34567,45678])
      sampler = Plurimath::Math::Evaluation::CorrelatedNormalSampler.new(definitions, [[variance,sign*variance],[sign*variance,variance]], generator)
      100.times do
        x,y = sampler.draw
        expect(y).to eq(sign*x)
      end
    end
  end

  it "refuses inconsistent or indefinite covariance and nonnormal marginals" do
    generator = Plurimath::Math::Evaluation::WichmannHill.new([12345,23456,34567,45678])
    [ [[variance,2*variance],[2*variance,variance]], [[variance,0],[0,variance*2]], [[variance,1],[0,variance]] ].each do |matrix|
      expect { Plurimath::Math::Evaluation::CorrelatedNormalSampler.new(definitions,matrix,generator) }.to raise_error(gum::InvalidInput)
    end
    expect { Plurimath::Math::Evaluation::CorrelatedNormalSampler.new([{distribution: :rectangular},definitions[1]],[[variance,0],[0,variance]],generator) }.to raise_error(gum::UnsupportedModel)
  end

  it "matches the correlated comparison-loss population at declared one-digit adaptive precision" do
    formula = Plurimath::Math.parse("x^2+y^2", :asciimath)
    result = gum.monte_carlo(formula, inputs: {x:definitions[0],y:definitions[1]}, independent: false,
      joint_distribution: :multivariate_normal, joint_covariance: [[variance,variance*9/10],[variance*9/10,variance]],
      seeds: [12345,23456,34567,45678], probability: "0.95", interval: :both,
      significant_digits: 1, guard_digits: 10, max_samples: 100000)
    expected_mean = BigDecimal((2*variance).numerator,40).div((2*variance).denominator,40)
    exact_variance = 4*variance**2*(1+Rational(9,10)**2)
    expected_u = BigDecimal(exact_variance.numerator,40).div(exact_variance.denominator,40).sqrt(40)
    expect((BigDecimal(result[:estimate])-expected_mean).abs).to be < BigDecimal("0.000005")
    expect((BigDecimal(result[:standard_uncertainty])-expected_u).abs).to be < BigDecimal("0.000005")
    expect(result[:stabilized]).to eq(true)
    expect(result[:engine][:joint_distribution]).to eq(:multivariate_normal)
    expect(result[:engine][:joint_sampler]).to eq("exact-LDL-binary64-normal-v1")
    expect(result[:engine][:covariance]).to eq([[variance.to_s,(variance*9/10).to_s],[(variance*9/10).to_s,variance.to_s]])
    expect(result[:intervals].keys).to eq([:symmetric,:shortest])
  end
end
