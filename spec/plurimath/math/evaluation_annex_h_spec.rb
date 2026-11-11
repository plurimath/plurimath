require "spec_helper"

RSpec.describe "GUM Annex H calculations from declared input profiles" do
  let(:gum) { Plurimath::Math::Evaluation::Gum }
  let(:inputs) { JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum_annex_h.json", __dir__))) }
  let(:reference) { JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum_annex_reference.json", __dir__))) }

  def numeric(source, bindings)
    @models ||= {}
    @models[source] ||= Plurimath::Math.parse(source, :asciimath)
    @models[source].evaluate(bindings, mode: :strict, guard_digits: 60).value
  end

  def decimal(value)
    value.is_a?(Rational) ? BigDecimal(value.numerator, 70).div(value.denominator, 70) : BigDecimal(value.to_s)
  end

  def close(actual, expected, tolerance = "1e-28")
    expect((decimal(actual)-decimal(expected)).abs).to be < BigDecimal(tolerance)
  end

  it "H.2 propagates paired input covariance and retains both output approaches" do
    paired = gum.type_a_covariance(inputs.fetch("h2").fetch("observations"))
    v,i,p = paired[:means]
    bindings = {v:v,i:i,p:p}
    expressions = ["1000*v/i*cos(p)", "1000*v/i*sin(p)", "1000*v/i"]
    estimates = expressions.map { |source| numeric(source, bindings) }
    gradients = [["1000*cos(p)/i","-1000*v*cos(p)/i^2","-1000*v*sin(p)/i"],
                 ["1000*sin(p)/i","-1000*v*sin(p)/i^2","1000*v*cos(p)/i"],
                 ["1000/i","-1000*v/i^2","0"]].map { |row| row.map { |source| numeric(source, bindings) } }
    result = gum.propagate_vector(estimates:estimates,jacobian:gradients,covariance:paired[:covariance_of_mean],guard_digits:50)
    expected = reference.fetch("h2").fetch("approach1")
    3.times do |j|
      close(result[:estimates][j], expected.fetch("estimates")[j])
      close(result[:standard_uncertainties][j], expected.fetch("uncertainties")[j])
    end
    summary_covariance = reference.fetch("h2").fetch("rounded_summary_input_covariance")
    rounded = gum.propagate_vector(estimates:estimates,jacobian:gradients,covariance:summary_covariance,guard_digits:50)
    3.times do |j|
      close(rounded[:standard_uncertainties][j], reference.fetch("h2").fetch("rounded_summary_uncertainties")[j])
    end
    output_rows = inputs.fetch("h2").fetch("observations").map do |row|
      values = row.map { |value| Rational(value) }
      expressions.map { |source| numeric(source, %i[v i p].zip(values).to_h) }
    end
    second = gum.type_a_covariance(output_rows)
    3.times { |j| close(second[:means][j],reference.fetch("h2").fetch("approach2").fetch("estimates")[j]) }
    correlations = gum.correlation_matrix(result[:covariance],guard_digits:50)
    3.times { |j| 3.times { |k| close(correlations[j][k],expected.fetch("correlations")[j][k]) } }
  end

  it "H.4 corrects background/decay before averaging and includes shared-rate covariance once" do
    h = inputs.fetch("h4")
    rates = h.fetch("observations").map do |row|
      ts,cs,tb,cb,tx,cx = row.map { |value| Rational(value) }
      common = {b:cb,t:Rational(h.fetch("counting_time_min")),l:Rational(h.fetch("decay_constant_per_min"))}
      [numeric("(c-b)/t*exp(l*x)",common.merge(c:cx,x:tx)),
       numeric("(c-b)/t*exp(l*x)",common.merge(c:cs,x:ts))]
    end
    paired = gum.type_a_covariance(rates)
    a,m,n = %w[standard_activity_Bq_per_g standard_mass_g sample_mass_g].map { |key| Rational(h.fetch(key)) }
    au,mu,nu = %w[standard_activity_u standard_mass_u sample_mass_u].map { |key| Rational(h.fetch(key)) }
    x,s = paired[:means]
    bindings = {a:a,m:m,n:n,x:x,s:s}
    estimate = numeric("a*m/n*x/s",bindings)
    gradient = ["m/n*x/s","a/n*x/s","-a*m/n^2*x/s","a*m/(n*s)","-a*m/n*x/s^2"].map { |source| numeric(source,bindings) }
    variances = [au**2,mu**2,nu**2,paired[:covariance_of_mean][0][0],paired[:covariance_of_mean][1][1]]
    covariance = Array.new(5) { |j| Array.new(5) { |k| j==k ? variances[j] : 0 } }
    covariance[3][4] = covariance[4][3] = paired[:covariance_of_mean][0][1]
    first = gum.propagate_covariance(estimate:estimate,components:variances.map { |variance| {variance:variance} },gradient:gradient,
              covariance:covariance,joint_distribution: :unspecified,guard_digits:50)
    close(first[:estimate],reference.fetch("h4").fetch("approach1").fetch("estimate"))
    close(first[:standard_uncertainty],reference.fetch("h4").fetch("approach1").fetch("u"))
    ratios = gum.type_a(rates.map { |rx,rs| rx/rs })
    parameters = {a:a,m:m,n:n,r:ratios[:mean]}
    components = {a:{variance:au**2,degrees_of_freedom: :unknown},m:{variance:mu**2,degrees_of_freedom: :unknown},
                  n:{variance:nu**2,degrees_of_freedom: :unknown},r:ratios}
    second = gum.analyze(Plurimath::Math.parse("a*m/n*r",:asciimath),estimates:parameters,components:components,independent:true,guard_digits:50)
    close(second[:estimate],reference.fetch("h4").fetch("approach2").fetch("estimate"))
    close(second[:standard_uncertainty],reference.fetch("h4").fetch("approach2").fetch("u"))
    expect(second[:degrees_of_freedom_status]).to eq(:unknown)
    close(first[:standard_uncertainty],h.fetch("published_approach1_u"),"0.00005")
    close(second[:standard_uncertainty],h.fetch("published_approach2_u"),"0.00005")
  end

  it "H.5 distinguishes the explicitly chosen day-effect and no-day-effect models" do
    h = inputs.fetch("h5")
    parameters = {group_means:h.fetch("group_means_V"),group_sample_variances:h.fetch("group_sample_sds_microV").map { |x| (Rational(x)/1_000_000)**2 },
                  observations_per_group:h.fetch("observations_per_group"),guard_digits:50}
    grouped = gum.grouped_type_a(**parameters,variance_model: :random_group_effect)
    pooled = gum.grouped_type_a(**parameters,variance_model: :no_group_effect)
    expected = reference.fetch("h5")
    expect(grouped[:mean]).to eq(Rational(expected.fetch("mean")))
    expect(grouped[:variance]).to eq(Rational(expected.fetch("random_group_variance")))
    expect(pooled[:variance]).to eq(Rational(expected.fetch("no_group_variance")))
    expect(grouped[:degrees_of_freedom]).to eq(9)
    expect(pooled[:degrees_of_freedom]).to eq(49)
    expect(grouped[:f_degrees_of_freedom]).to eq([9,40])
    expect(grouped[:f_statistic]).to eq(Rational(expected.fetch("F")))
    rounded_f = Rational(h.fetch("observations_per_group"))*Rational(h.fetch("rounded_group_mean_sd_microV"))**2/Rational(h.fetch("rounded_pooled_within_sd_microV"))**2
    expect(rounded_f).to eq(Rational(expected.fetch("rounded_intermediate_F")))
    close(rounded_f,h.fetch("published_F"),"0.005")
    expect(grouped[:f_statistic]).to be > Rational(h.fetch("published_F_critical_95"))
    expect(grouped[:f_statistic]).to be < Rational(h.fetch("published_F_critical_975"))
    expect { gum.grouped_type_a(**parameters.merge(group_means:Array.new(10,1)),variance_model: :random_group_effect) }.to raise_error(gum::UnsupportedModel,/negative estimated/)
  end

  it "H.6 keeps resolution rectangular, transfer variation triangular, and unknown degrees explicit" do
    h = inputs.fetch("h6")
    d,sd,resolution,standard,calibration,fractional,national = %w[mean_depth_scale_units pooled_sd_scale_units resolution_scale_units standard_average_sd_scale_units calibration_average_sd_scale_units fractional_variation national_definition_u_scale_units].map { |key| Rational(h.fetch(key)) }
    resolution_component = gum.component(distribution: :rectangular,half_width:resolution/2)
    transfer_component = gum.component(distribution: :triangular,half_width:fractional*d/2)
    parts = [{variance:sd**2/5+resolution_component[:variance],degrees_of_freedom: :unknown},
             {variance:standard**2/h.fetch("standard_series_count")+calibration**2/h.fetch("calibration_series_count"),degrees_of_freedom: :unknown},
             transfer_component,{variance:national**2,degrees_of_freedom: :unknown}]
    result = gum.analyze(Plurimath::Math.parse("100-d-c-b-s",:asciimath),estimates:{d:d,c:0,b:0,s:0},
               components:%i[d c b s].zip(parts).to_h,independent:true,guard_digits:50)
    expected = reference.fetch("h6")
    expect(result[:estimate]).to eq(Rational(expected.fetch("estimate")))
    expect(result[:variance]).to eq(Rational(expected.fetch("variance")))
    close(result[:standard_uncertainty],expected.fetch("u"))
    close(result[:standard_uncertainty],h.fetch("published_uncertainty_scale_units"),"0.005")
    expect(result[:degrees_of_freedom_status]).to eq(:unknown)
  end
end
