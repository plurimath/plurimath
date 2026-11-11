require "spec_helper"

RSpec.describe Plurimath::Math::Evaluation::MonteCarlo do
  it "preserves every Welford prefix bit when batches replace historical rescans" do
    evaluator = Plurimath::Math::Evaluation::MonteCarlo.allocate
    values = Array.new(30000) { |i| ((i*7919)%10007-5003).to_f/97 }
    state = {count: 0, estimate: 0.0, sum: 0.0}
    values.each_slice(10000).with_index do |batch,index|
      actual = evaluator.send(:moments,batch,state: state)
      expected = evaluator.send(:moments,values.first((index+1)*10000))
      actual.each { |key,value| expect([value].pack("G")).to eq([expected.fetch(key)].pack("G")) }
      expect(state[:count]).to eq((index+1)*10000)
    end
  end

  let(:gum) { Plurimath::Math::Evaluation::Gum }
  let(:seeds) { [12_345, 23_456, 34_567, 45_678] }

  def request(formula, **options)
    gum.monte_carlo(formula, inputs: { x: { distribution: :normal, location: 3, sd: 2 } },
                    independent: true, seeds: seeds, probability: "0.95", interval: :both,
                    significant_digits: 1, guard_digits: 12, max_samples: 100_000, **options)
  end

  it "matches the independently computed 32-bit recurrence with the 64-bit implementation" do
    fixture = JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/wichmann_hill.json", __dir__)))
    generator = Plurimath::Math::Evaluation::WichmannHill.new(fixture.fetch("seeds"))
    fixture.fetch("draws").each do |draw|
      value = generator.uniform
      expect(generator.state).to eq(draw.fetch("state"))
      expect(value).to be_within(1e-15).of(Rational(draw.fetch("uniform")).to_f)
    end
    expect(generator.draws).to eq(16)
    expect { Plurimath::Math::Evaluation::WichmannHill.new([0, 1, 1, 1]) }.to raise_error(gum::InvalidInput)
  end

  it "uses equation18's significant-digit tolerance, including decimal carries" do
    expect(described_class.numerical_tolerance("0.00035", 2)).to eq(BigDecimal("0.000005"))
    expect(described_class.numerical_tolerance("0.00035", 1)).to eq(BigDecimal("0.00005"))
    expect(described_class.numerical_tolerance("2", 1)).to eq(BigDecimal("0.5"))
    expect(described_class.numerical_tolerance("9.99", 2)).to eq(BigDecimal("0.5"))
  end

  it "retains the one-based r and r+q endpoint convention from7.7.2" do
    expect(described_class.coverage((1..10).to_a, 4r / 5, :symmetric)).to eq([1, 9])
    expect(described_class.coverage([0,1,2,3,4,5,6,7,8,100], 4r / 5, :shortest)).to eq([0, 8])
  end

  it "stabilizes both interval kinds deterministically and emits decimal strings" do
    formula = Plurimath::Math.parse("x", :asciimath)
    result = request(formula)
    expect(result).to eq(request(formula))
    expect(result[:stabilized]).to be(true)
    expect(result[:samples]).to be >= 20_000
    expect(result[:estimate]).to be_a(String)
    expect(result[:estimate].to_f).to be_within(0.08).of(3)
    expect(result[:standard_uncertainty].to_f).to be_within(0.08).of(2)
    reference = JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum_statistics.json", __dir__))).fetch("normal_identity_mcm")
    expect(result[:intervals][:symmetric][0].to_f).to be_within(0.15).of(reference.fetch("lower").to_f)
    expect(result[:intervals][:symmetric][1].to_f).to be_within(0.15).of(reference.fetch("upper").to_f)
    widths = result[:intervals].transform_values { |limits| limits[1].to_f - limits[0].to_f }
    expect(widths[:shortest]).to be <= widths[:symmetric] + 1e-9
    expect(result[:twice_standard_errors].values.map(&:to_f).max).to be <= result[:numerical_tolerance].to_f
    expect(result[:engine][:initial_seeds]).to eq(seeds)
    expect(result[:engine][:numeric_backend]).to eq("binary64-centered-exact-polynomial")
  end

  it "refuses unsupported moments and reports failure to stabilize within the cap" do
    formula = Plurimath::Math.parse("x", :asciimath)
    expect { request(Plurimath::Math.parse("x^2", :asciimath), inputs: { x: { distribution: :student_t, location: 0, scale: 1, degrees_of_freedom: 3 } }) }.to raise_error(gum::UnsupportedModel, /variance/)
    linear = Plurimath::Math::Evaluation::DistributionSampler.new(
      [{ distribution: :student_t, location: 0, scale: 1, degrees_of_freedom: 3 }],
      Plurimath::Math::Evaluation::WichmannHill.new(seeds), degrees: [1])
    expect(linear.draw.first).to be_finite
    expect { request(formula, significant_digits: 12, max_samples: 20_000) }.to raise_error(gum::ConvergenceError) { |error|
      expect(error.details[:samples]).to eq(20_000)
      expect(error.details[:numerical_tolerance]).not_to be_nil
      expect(error.details[:twice_standard_errors].keys).to include(:estimate,:standard_uncertainty)
      expect(error.details[:final_state]).to have_attributes(length: 4)
    }
    expect { request(Plurimath::Math.parse("1/x", :asciimath)) }.to raise_error(gum::UnsupportedModel, /finite output moments/)
  end

  it "checks the declared PDF scale and shape conventions against independent moments" do
    definitions = [
      { distribution: :normal, location: 0, sd: 1 },
      { distribution: :rectangular, lower: -1, upper: 1 },
      { distribution: :triangular, lower: -1, upper: 1 },
      { distribution: :arcsine, lower: -1, upper: 1 },
      { distribution: :student_t, location: 0, scale: 2, degrees_of_freedom: 8 },
      { distribution: :curvilinear_trapezoid, lower: "-0.05", upper: "0.05", boundary_half_width: "0.025" }
    ]
    sampler = Plurimath::Math::Evaluation::DistributionSampler.new(definitions,
              Plurimath::Math::Evaluation::WichmannHill.new(seeds), degrees: [1]*6)
    sums = Array.new(6, 0.0)
    squares = Array.new(6, 0.0)
    100_000.times do
      sampler.draw.each_with_index { |x, i| sums[i] += x; squares[i] += x*x }
    end
    variances = squares.each_with_index.map { |sum, i| (sum - sums[i]**2/100_000)/99_999 }
    expected = [1.0, 1.0/3, 1.0/6, 0.5, 16.0/3, 13.0/14_400]
    tolerances = [0.04, 0.008, 0.006, 0.01, 0.2, 0.00005]
    variances.zip(expected, tolerances).each { |actual, target, tolerance| expect(actual).to be_within(tolerance).of(target) }
  end
  it "centers polynomial algebra exactly before sampling large offsets" do
    formula = Plurimath::Math.parse("x^2-20000000000000000*x+100000000000000000000000000000000", :asciimath)
    result = request(formula, inputs: { x: { distribution: :normal, location: "10000000000000000", sd: 1 } })
    expect(result[:estimate].to_f).to be_within(0.08).of(1)
    expect(result[:standard_uncertainty].to_f).to be_within(0.08).of(Math.sqrt(2))
  end

  it "validates an LPU interval only against suitably tighter adaptive MCM" do
    formula = Plurimath::Math.parse("x", :asciimath)
    mc = request(formula, significant_digits: 2, interval: :symmetric, max_samples: 200_000)
    reference = JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum_statistics.json", __dir__))).fetch("normal_identity_mcm")
    options = { guf_standard_uncertainty: 2, significant_digits: 1, probability: "0.95",
                interval: :symmetric, monte_carlo: mc }
    validated = gum.validate_coverage(guf_interval: [reference.fetch("lower"), reference.fetch("upper")], **options)
    expect(validated[:adequacy]).to eq(:validated)
    expect(gum.validate_coverage(guf_interval: [2, 4], **options)[:adequacy]).to eq(:not_validated)
    expect { gum.validate_coverage(guf_interval: [reference.fetch("lower"), reference.fetch("upper")],
                                   **options.merge(significant_digits: 2)) }.to raise_error(gum::UnsupportedModel, /five times tighter/)
  end

end
