# frozen_string_literal: true

require "spec_helper"

# The :pma input type (docs/pma.adoc): every accepted form of the pma
# specification, the refusals Plurimath adds, and the forms on which pma
# and dialect L (:asciimath) agree.
RSpec.describe Plurimath::Pma do
  def number(text)
    text && Plurimath::Math::Number.new(text)
  end

  def uncertainty(value, category: :standard, unit: nil, **fields)
    numbers = %i[magnitude coverage_factor coverage_probability lower upper]
    options = fields.to_h { |k, v| [k, numbers.include?(k) ? number(v) : v] }
    options[:unit] = Plurimath::Math::Function::Unitsml.new(unit) if unit
    Plurimath::Math::Function::Uncertainty.new(number(value), category: category, **options)
  end

  def node(text, type = :pma)
    formula = Plurimath::Math.parse(text, type)
    expect(formula.value.length).to eq(1)
    formula.value.first
  end

  def writers(text, type)
    formula = Plurimath::Math.parse(text, type)
    {
      asciimath: formula.to_asciimath,
      mathml: formula.to_mathml,
      latex: formula.to_latex,
      unicodemath: formula.to_unicodemath,
      omml: formula.to_omml,
      html: formula.to_html,
    }
  end

  it "is a valid input type" do
    expect(Plurimath::Math::VALID_TYPES).to include(pma: described_class)
    expect(Plurimath::Math::INPUT_ONLY_TYPES).to eq(%i[pma])
  end

  describe "accepted forms" do
    {
      "ustd(1.230, 0.004)" => ["1.230", { magnitude: "0.004" }],
      "ustd(-1.230, 0.004)" => ["-1.230", { magnitude: "0.004" }],
      "uexp(10.0, 0.3, 2)" =>
        ["10.0", { category: :expanded, magnitude: "0.3", coverage_factor: "2" }],
      "uexp(10.0, 0.3, 2, 0.95)" =>
        ["10.0", { category: :expanded, magnitude: "0.3", coverage_factor: "2",
                   coverage_probability: "0.95" }],
      "ucov(1.024, 0.983, 1.088, 0.95)" =>
        ["1.024", { category: :coverage_interval, lower: "0.983", upper: "1.088",
                    coverage_probability: "0.95" }],
      "ucov(1.024, 0.983, 1.088, 0.95, shortest)" =>
        ["1.024", { category: :coverage_interval, lower: "0.983", upper: "1.088",
                    coverage_probability: "0.95", interval_kind: :shortest }],
      "ucov(1.024, 0.983, 1.088, 0.95, symmetric)" =>
        ["1.024", { category: :coverage_interval, lower: "0.983", upper: "1.088",
                    coverage_probability: "0.95",
                    interval_kind: :probabilistically_symmetric }],
      "(10.3 +/- 0.2)" => ["10.3", { magnitude: "0.2" }],
      "(-1.230 +/- 0.004)" => ["-1.230", { magnitude: "0.004" }],
      "( 10.3 +/- 0.2 )" => ["10.3", { magnitude: "0.2" }],
      "(3.85 +/- 0.23)e4" => ["38500", { magnitude: "2300" }],
      "(3.85 +/- 0.23)e+4" => ["38500", { magnitude: "2300" }],
      "(1.024 +/- 0.003)e-3" => ["0.001024", { magnitude: "0.000003" }],
      "(10.3 +/- 2%)" => ["10.3", { magnitude: "0.206" }],
      "(10.3 +/- 0.5%)" => ["10.3", { magnitude: "0.0515" }],
      "(-10.3 +/- 2%)" => ["-10.3", { magnitude: "0.206" }],
      "(10.3 +/- 0.2 ~rect)" => ["10.3", { magnitude: "0.2", distribution: :rect }],
      "(10.3 +/- 0.2~rect)" => ["10.3", { magnitude: "0.2", distribution: :rect }],
      "(10.3 +/- 0.2 ~triang) unit(cm)" =>
        ["10.3", { magnitude: "0.2", distribution: :triang, unit: "cm" }],
      "(3.85 +/- 0.23 ~arcsine)e4" =>
        ["38500", { magnitude: "2300", distribution: :arcsine }],
      "(10.3 +/- 2% ~rect)" => ["10.3", { magnitude: "0.206", distribution: :rect }],
      "(10.3 +/- 0.2) unit(cm)" => ["10.3", { magnitude: "0.2", unit: "cm" }],
      "(10.3+/-0.2)unit(cm)" => ["10.3", { magnitude: "0.2", unit: "cm" }],
      "(3.85 +/- 0.23)e4 unit(m)" => ["38500", { magnitude: "2300", unit: "m" }],
      "(10.3 +/- 2%) unit(cm)" => ["10.3", { magnitude: "0.206", unit: "cm" }],
      "ustd(1.230, 0.004) unit(g)" => ["1.230", { magnitude: "0.004", unit: "g" }],
      "uexp(100.02147, 0.00079, 2) unit(g)" =>
        ["100.02147", { category: :expanded, magnitude: "0.00079",
                        coverage_factor: "2", unit: "g" }],
    }.each do |input, (value, fields)|
      it "reads #{input}" do
        expect(node(input)).to eq(uncertainty(value, **fields))
      end
    end

    it "keeps the distribution tag as a field" do
      expect(node("(10.3 +/- 0.2 ~arcsine)").distribution).to eq(:arcsine)
      expect(node("(10.3 +/- 0.2)").distribution).to be_nil
    end

    %w[m/s^2 kg*m^2].each do |unit|
      it "reads unit(#{unit}) as a unit" do
        expect(node("unit(#{unit})")).to eq(Plurimath::Math::Function::Unitsml.new(unit))
      end
    end
  end

  describe "refused forms" do
    [
      "(10.3 +- 0.2)", "(10.3 pm 0.2)", "(10.3 ± 0.2)", "(x +/- 0.2)",
      "10.3 +/- 0.2", "(10.3 +/- 0.2 ~U)", "(10.3 +/- 0.2 ~gauss)",
      "(10.3 +/- 0.2) ~rect", "ustd(1.2, 0.1 ~rect)", "uexp(10.0, 0.3)",
      "ustd(1.230, 0.004, \"unitsml(g)\")", "10.3(2)", "ustd(1.230(4))",
      "(3.85 +/- 2%)e4", "uexp(1.0, 0.3, 0, 0.95)",
      "diff((5.0 +/- 0.1) unit(K))", "diff((20.0 +/- 0.2) unit(degC))"
    ].each do |input|
      it "refuses #{input}" do
        expect { Plurimath::Math.parse(input, :pma) }
          .to raise_error(Plurimath::Math::ParseError)
      end
    end

    it "takes no locale option" do
      expect { Plurimath::Math.parse("(10.3 +/- 0.2)", :pma, locale: :fr) }
        .to raise_error(Plurimath::Math::ParseOptionError)
    end
  end

  describe "agreement with dialect L" do
    [
      "ustd(1.230, 0.004)", "ustd(-1.230, 0.004)", "uexp(10.0, 0.3, 2)",
      "uexp(10.0, 0.3, 2, 0.95)", "ucov(1.024, 0.983, 1.088, 0.95)",
      "ucov(1.024, 0.983, 1.088, 0.95, shortest)",
      "ucov(1.024, 0.983, 1.088, 0.95, symmetric)"
    ].each do |input|
      it "builds the same node and output for #{input}" do
        expect(node(input)).to eq(node(input, :asciimath))
        expect(writers(input, :pma)).to eq(writers(input, :asciimath))
      end
    end

    {
      "(10.3 +/- 0.2)" => "ustd(10.3, 0.2)",
      "(3.85 +/- 0.23)e4" => "ustd((3.85, 0.23)e4)",
      "ustd(1.230, 0.004) unit(g)" => "ustd(1.230, 0.004, \"unitsml(g)\")",
    }.each do |pma, legacy|
      it "reads #{pma} as :asciimath reads #{legacy}" do
        expect(node(pma)).to eq(node(legacy, :asciimath))
        expect(writers(pma, :pma)).to eq(writers(legacy, :asciimath))
      end
    end

    it "leaves (10.3 +/- 0.2) as ordinary symbols in :asciimath" do
      expect(node("(10.3 +/- 0.2)", :asciimath))
        .not_to be_a(Plurimath::Math::Function::Uncertainty)
    end
  end
end
