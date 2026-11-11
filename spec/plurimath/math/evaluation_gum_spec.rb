require "spec_helper"

RSpec.describe Plurimath::Math::Evaluation::Gum do
  let(:gum) { described_class }

  def normal(variance)
    { variance: variance, distribution: :normal }
  end

  def propagate(**options)
    gum.propagate(independent: true, guard_digits: 40, **options)
  end

  it "distinguishes sample dispersion from uncertainty of the mean" do
    result = gum.type_a(["1", "2", "3"])
    expect(result[:mean]).to eq(2)
    expect(result[:sample_variance]).to eq(1)
    expect(result[:variance]).to eq(1r / 3)
    expect(result[:degrees_of_freedom]).to eq(2)
  end

  it "uses the specified half-width and Student-t scale conventions" do
    expect(gum.component(distribution: :rectangular, half_width: 3)[:variance]).to eq(3)
    expect(gum.component(distribution: :triangular, half_width: 3)[:variance]).to eq(3r / 2)
    expect(gum.component(distribution: :arcsine, half_width: 3)[:variance]).to eq(9r / 2)
    expect(gum.component(distribution: :student_t, scale: 25, degrees_of_freedom: 18)[:variance]).to eq(5625r / 8)
    expect { gum.component(distribution: :student_t, scale: 1, degrees_of_freedom: 2) }.to raise_error(described_class::InvalidInput)
  end

  it "computes LPU and Welch-Satterthwaite without asserting adequacy" do
    result = propagate(estimate: 10, components: [normal(4).merge(degrees_of_freedom: 8), normal(9)], gradient: [1, 2])
    expect(result[:variance]).to eq(40)
    expect(result[:effective_degrees_of_freedom]).to eq(800)
    expect(result[:adequacy]).to eq(:not_assessed)
    expect(result[:engine][:version]).to eq(Plurimath::VERSION)
    expect(result[:standard_uncertainty]).to be_a(BigDecimal)
    expect((result[:standard_uncertainty]**2 - 40).abs).to be < BigDecimal("1e-35")
  end

  it "includes the third derivative term even with a zero Hessian" do
    # f(x)=x+x^3 at x=0: first-order variance u^2, order-four
    # variance correction 6u^4. The exact normal variance additionally
    # has 15u^6, which GUF2 deliberately does not claim to include.
    result = propagate(estimate: 0, components: [normal(1r / 100)], gradient: [1], order: 2,
                       hessian: [[0]], third: [[[6]]], derivatives_complete: true)
    expect(result[:variance]).to eq(53r / 5000)
    expect(result[:estimate]).to eq(0)
  end

  it "includes the mean correction and quadratic variance for x squared" do
    result = propagate(estimate: 4, components: [normal(3)], gradient: [4], order: 2,
                       hessian: [[2]], third: [[[0]]], derivatives_complete: true)
    expect(result[:estimate]).to eq(7)
    expect(result[:variance]).to eq(66)
  end

  it "refuses an unstated joint law, nonnormal GUF2 and incomplete derivatives" do
    base = { estimate: 0, components: [normal(1)], gradient: [1] }
    expect { gum.propagate(**base, independent: false, guard_digits: 20) }.to raise_error(described_class::UnsupportedModel)
    expect { propagate(**base, order: 2) }.to raise_error(described_class::UnsupportedModel)
    expect { propagate(**base.merge(components: [{ variance: 1, distribution: :rectangular }]), order: 2,
                        hessian: [[0]], third: [[[0]]], derivatives_complete: true) }.to raise_error(described_class::UnsupportedModel)
    expect { gum.type_a([1.0, 2.0]) }.to raise_error(described_class::InvalidInput)
  end
  it "matches independently factored amended H.1 variances for four named conventions" do
    fixture = JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum_h1.json", __dir__)))
    fixture.fetch("profiles").each do |profile|
      components = profile.fetch("variance").map { |variance| normal(variance) }
      base = { estimate: fixture.fetch("estimate"), components: components,
               gradient: fixture.fetch("gradient") }
      expect(propagate(**base)[:variance]).to eq(Rational(profile.fetch("first_variance")))
      result = propagate(**base, order: 2, hessian: fixture.fetch("hessian"),
                         third: fixture.fetch("third"), derivatives_complete: true)
      expect(result[:estimate]).to eq(838)
      expect(result[:variance]).to eq(Rational(profile.fetch("second_variance")))
      # Moment-equivalent normals above are an explicit synthetic case.
      # Actual Table 10 / Table 8.1 PDFs include Student-t and rectangles.
      components.first[:distribution] = :student_t
      expect { propagate(**base, order: 2, hessian: fixture.fetch("hessian"),
                         third: fixture.fetch("third"), derivatives_complete: true) }.to raise_error(described_class::UnsupportedModel)
    end
  end

  it "derives third-order sensitivities through the existing Formula evaluator" do
    formula = Plurimath::Math.parse("x+x^3", :asciimath)
    result = gum.analyze(formula, estimates: { x: 0 }, components: { x: normal("0.01") },
                         independent: true, order: 2, guard_digits: 40)
    expect(result[:gradient]).to eq([1])
    expect(result[:hessian]).to eq([[0]])
    expect(result[:third]).to eq([[[6]]])
    expect(result[:variance]).to eq(53r / 5000)
  end

  it "differentiates rational functions analytically and refuses unsupported functions" do
    formula = Plurimath::Math.parse("1/x", :asciimath)
    result = gum.analyze(formula, estimates: { x: 2 }, components: { x: normal(1) },
                         independent: true, guard_digits: 40)
    expect(result[:estimate]).to eq(1r / 2)
    expect(result[:gradient]).to eq([-1r / 4])
    expect(result[:hessian]).to eq([[1r / 4]])
    expect(result[:third]).to eq([[[-3r / 8]]])
    formula = Plurimath::Math.parse("sin(x)", :asciimath)
    expect { gum.analyze(formula, estimates: { x: 1 }, components: { x: normal(1) },
                         independent: true, guard_digits: 40) }.to raise_error(described_class::UnsupportedModel)
  end

  it "matches the H.1 reference through automatic analytic differentiation" do
    fixture = JSON.parse(File.read(File.expand_path("../../fixtures/evaluation/gum_h1.json", __dir__)))
    profile = fixture.fetch("profiles")[1]
    names = %i[s d e f a t v b c]
    values = ["50000623", "215", "0", "0", "0.0000115", "-0.1", "0", "0", "0"]
    formula = Plurimath::Math.parse("s+d+e+f-s*(b*(t+v)+a*c)-50000000", :asciimath)
    result = gum.analyze(formula, estimates: names.zip(values).to_h,
                         components: names.zip(profile.fetch("variance").map { |variance| normal(variance) }).to_h,
                         independent: true, order: 2, guard_digits: 40)
    expect(result[:estimate]).to eq(838)
    expect(result[:gradient]).to eq(fixture.fetch("gradient").map { |value| Rational(value) })
    expect(result[:hessian]).to eq(fixture.fetch("hessian").map { |row| row.map { |value| Rational(value) } })
    expected_third = fixture.fetch("third").map { |plane| plane.map { |row| row.map { |value| Rational(value) } } }
    expect(result[:third]).to eq(expected_third)
    expect(result[:variance]).to eq(Rational(profile.fetch("second_variance")))
  end

  it "uses the uncertain-boundary trapezoid convention from JCGM 101" do
    component = gum.component(distribution: :curvilinear_trapezoid,
                              half_width: "0.05", boundary_half_width: "0.025")
    expect(component[:variance]).to eq(13r / 14400)
    expect { gum.component(distribution: :curvilinear_trapezoid,
                            half_width: 1, boundary_half_width: 2) }.to raise_error(described_class::InvalidInput)
  end

  it "refuses malformed components and nonsymmetric derivative tensors" do
    expect { gum.type_a(nil) }.to raise_error(described_class::InvalidInput)
    expect { propagate(estimate: 0, components: [{}], gradient: [1]) }.to raise_error(described_class::InvalidInput)
    expect { propagate(estimate: 0, components: [normal(1), normal(1)], gradient: [1, 1], order: 2,
                        hessian: [[0, 1], [2, 0]], third: Array.new(2) { Array.new(2) { [0, 0] } },
                        derivatives_complete: true) }.to raise_error(described_class::InvalidInput)
  end

  it "isolates explicit decimal computation from ambient rounding and restores it" do
    options = { estimate: 0, components: [normal(2)], gradient: [1] }
    baseline = propagate(**options)[:standard_uncertainty]
    BigDecimal.save_limit do
      BigDecimal.save_rounding_mode do
        BigDecimal.limit(1)
        BigDecimal.mode(BigDecimal::ROUND_MODE, BigDecimal::ROUND_DOWN)
        expect(propagate(**options)[:standard_uncertainty]).to eq(baseline)
        expect(BigDecimal.limit).to eq(1)
        expect(BigDecimal.mode(BigDecimal::ROUND_MODE)).to eq(BigDecimal::ROUND_DOWN)
      end
    end
  end

  it "selects series windows and axes without confusing dispersion and mean uncertainty" do
    result = gum.series([1, 2, 3, 4], axis: 0, window: [1, 2], guard_digits: 12)
    expect(result[:mean]).to eq(5r / 2)
    expect(result[:sample_variance]).to eq(1r / 2)
    expect(result[:variance]).to eq(1r / 4)
    expect(BigDecimal(result[:standard_uncertainty_of_mean])).to eq(BigDecimal("0.5"))
    matrix = [[1, 10], [2, 20], [3, 30]]
    expect(gum.series(matrix, axis: 0, window: nil, guard_digits: 12).map { |row| row[:mean] }).to eq([2, 20])
    expect(gum.series(matrix, axis: 1, window: nil, guard_digits: 12).map { |row| row[:mean] }).to eq([11r / 2, 11, 33r / 2])
    expect { gum.series(matrix, axis: 0, window: [2, 3], guard_digits: 12) }.to raise_error(described_class::InvalidInput)
  end

end
