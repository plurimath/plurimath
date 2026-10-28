# frozen_string_literal: true

require "spec_helper"
require "yaml"

RSpec.describe "AsciiMath shared-exponent uncertainty" do
  let(:math) { Plurimath::Math }
  let(:transform) { Plurimath::Asciimath::Transform.new }
  let(:invalid) { Plurimath::Errors::InvalidUncertainty }

  def read(source)
    Plurimath::Math.parse(source, :asciimath)
  end

  def model_fields(node)
    %i[value magnitude lower upper coverage_factor coverage_probability].to_h do |field|
      [field, node.public_send(field)&.value]
    end
  end

  # Exact results are specified independently of the decimal-shift helper.
  {
    "ustd((3.85,0.23)e4)" => ["38500", "2300"],
    "ustd((-3.850,0.230)e+2)" => ["-385.0", "23.0"],
    "ustd((3.85,0.23)e-4)" => ["0.000385", "0.000023"],
    "ustd((03.850,00.230)e0)" => ["03.850", "00.230"],
    "ustd((1.230,0.004)e1)" => ["12.30", "0.04"],
    "ustd(680(41)e-3)" => ["0.680", "0.041"],
    "ustd(1.230(4)e+4)" => ["12300", "40"],
    "ustd(-1.230(4)e-1)" => ["-0.1230", "0.0004"],
    "ustd((9007199254740993.125,0.001)e2)" => ["900719925474099312.5", "0.1"],
  }.each do |source, (value, magnitude)|
    it "reads #{source} without floating-point conversion" do
      formula = read(source)
      expect(formula.value.length).to eq(1)
      node = formula.value.first
      expect(node).to be_a(math::Function::Uncertainty)
      expect(node.category).to eq(:standard)
      expect(node.value.value).to eq(value)
      expect(node.magnitude.value).to eq(magnitude)
      expect(node.notation).to eq(source.include?("(4)") || source.include?("(41)") ? :concise : :absolute)
      expect(read(formula.to_asciimath)).to eq(formula)
    end
  end

  it "matches every exact-decimal model expectation in the shipped amath corpus" do
    path = File.join(Gem.loaded_specs.fetch("amath").full_gem_path,
                     "corpora", "uncertainty-shared-exponent.yml")
    corpus = YAML.safe_load_file(path)
    expect(corpus.fetch("schema_version")).to eq(1)
    corpus.fetch("cases").each do |entry|
      node = read(entry.fetch("input")).value.fetch(0)
      entry.fetch("normalized_model_text").each do |field, text|
        expect(node.public_send(field).value).to eq(text), entry.fetch("id")
      end
    end
  end

  it "scales expanded value and magnitude while retaining dimensionless k and p" do
    formula = read("uexp((3.850,0.230)e2,2,0.95)")
    node = formula.value.first
    expect(model_fields(node)).to eq(value: "385.0", magnitude: "23.0", lower: nil,
                                    upper: nil, coverage_factor: "2", coverage_probability: "0.95")
    expect(node.category).to eq(:expanded)
    expect(read(formula.to_asciimath)).to eq(formula)
  end

  it "scales interval endpoints while retaining probability, interval kind and unit" do
    formula = read('ucov((1.024,0.983,1.088)e3,0.95,shortest,"unitsml(g)")')
    node = formula.value.first
    expect(model_fields(node)).to eq(value: "1024", magnitude: nil, lower: "983",
                                    upper: "1088", coverage_factor: nil, coverage_probability: "0.95")
    expect(node.category).to eq(:coverage_interval)
    expect(node.interval_kind).to eq(:shortest)
    expect(node.unit).to eq(math::Function::Unitsml.new("g"))
    expect(read(formula.to_asciimath)).to eq(formula)
  end

  it "preserves unit attachment and following expression operands" do
    formula = read('ustd((3.85,0.23)e4,"unitsml(kg)")+x')
    expect(formula.value.map(&:class)).to eq([math::Function::Uncertainty, math::Symbols::Plus, math::Symbols::Symbol])
    expect(formula.value.first.unit).to eq(math::Function::Unitsml.new("kg"))
    expect(formula.value.last.value).to eq("x")
  end

  it "keeps malformed exponents, spaces and negative magnitudes outside uncertainty syntax" do
    ["ustd((3.85,0.23) e4)", "ustd((3.85,0.23)e)", "ustd((3.85,0.23)e+)",
     "ustd((3.85,-0.23)e4)", "ustd((3.85,0.23)e4x)"].each do |source|
      expect(read(source).value).not_to include(a_kind_of(math::Function::Uncertainty))
    end
  end

  it "validates shared exponent text at the transform boundary" do
    ["", "4.0", "e4", " 4", "--2"].each do |exponent|
      expect do
        transform.apply(uncertainty: { uncertainty_class: "ustd", value: "3.85", magnitude: "0.23", shared_exponent: exponent })
      end.to raise_error(invalid, /shared exponent/)
    end
  end

  it "retains magnitude validation when a supplied tree bypasses the grammar" do
    expect do
      transform.apply(uncertainty: { uncertainty_class: "ustd", value: "3.85", magnitude: "-0.23", shared_exponent: "2" })
    end.to raise_error(invalid)
  end

  it "rejects an impractical expansion before allocating its decimal string" do
    expect do
      transform.apply(uncertainty: { uncertainty_class: "ustd", value: "1", magnitude: "0.1", shared_exponent: "1000000000" })
    end.to raise_error(invalid, /expands beyond/)
  end

  it "retains legacy explicit calls and ordinary plus-minus expressions" do
    expect(read("ustd(1.230,0.004)").value.first.value.value).to eq("1.230")
    expect(read("1.230 +- 0.004").value).not_to include(a_kind_of(math::Function::Uncertainty))
    expect(read("1.230(4)").value).not_to include(a_kind_of(math::Function::Uncertainty))
  end
end
