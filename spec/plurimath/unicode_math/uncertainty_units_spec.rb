# frozen_string_literal: true

require "spec_helper"

# Uncertainty units read back from UnicodeMath (plurimath#493): the
# ⓐ(unit ...) argument must survive for units of more than one letter.
RSpec.describe Plurimath::UnicodeMath do
  # Units that Unitsml.new accepts; every one is written by to_unicodemath
  # and read back here.
  units = %w[
    g m kg s mol cd K A Hz N Pa J W C V F S Wb T H lm lx Bq Gy Sv kat
    km mg mm ms ns kW MHz m^2 m*s^-1 kg*m^2 m/s
  ]
  categories = %i[expanded standard]

  def math
    Plurimath::Math
  end

  def read(input)
    described_class.new(input).to_formula
  end

  def expanded(unit)
    math::Function::Uncertainty.new(
      math::Number.new("1.0"),
      category: :expanded,
      magnitude: math::Number.new("0.1"),
      coverage_factor: math::Number.new("2"),
      unit: unit,
    )
  end

  def standard(unit)
    math::Function::Uncertainty.new(
      math::Number.new("1.230"),
      category: :standard,
      magnitude: math::Number.new("0.004"),
      unit: unit,
    )
  end

  def without_unit(node)
    %i[value category magnitude coverage_factor coverage_probability
       lower upper interval_kind notation].map { |field| node.public_send(field) }
  end

  context "with a Unitsml unit written by to_unicodemath" do
    units.each do |text|
      categories.each do |category|
        it "keeps the #{text} unit of a #{category} uncertainty" do
          node = public_send(category, math::Function::Unitsml.new(text))
          output = math::Formula.new([node]).to_unicodemath
          value = math.parse(output, :unicode).value

          expect(value.length).to eq(1)
          expect(value.first).to be_a(math::Function::Uncertainty)
          expect(value.first.unit).to be_a(math::Formula)
          expect(without_unit(value.first)).to eq(without_unit(node))
        end
      end
    end
  end

  context "with a unit read from OMML" do
    %w[g kg kg*m^2].each do |text|
      it "round-trips the #{text} unit written as \\mup\"...\"" do
        node = expanded(math::Function::Unitsml.new(text))
        omml_node = math.parse(math::Formula.new([node]).to_omml, :omml)
          .value.find { |value| value.is_a?(math::Function::Uncertainty) }
        output = math::Formula.new([omml_node]).to_unicodemath

        expect(output).to include("ⓐ(unit \\mup\"")
        expect(math.parse(output, :unicode).value).to eq([omml_node])
      end
    end

    it "reads \\mup\"g\" as an upright text font" do
      expect(read("\\mup\"g\"").value).to eq(
        [
          math::Function::FontStyle::Normal.new(
            math::Function::Text.new("g"),
          ),
        ],
      )
    end
  end

  context "with other ⓐ uses" do
    it "keeps a single-term argument as before" do
      expect(read("ⓐ(x y)").value).to eq(
        [
          math::Function::Arg.new(
            math::Symbols::Symbol.new("y"),
            math::Symbols::Symbol.new("x"),
          ),
        ],
      )
    end

    it "keeps a single upright unit as before" do
      value = read("ⓐ(unit \\mupg)").value

      expect(value.map(&:class)).to eq([math::Function::Arg])
      expect(value.first.parameter_one).to be_a(math::Function::FontStyle::Normal)
    end

    it "reads a multi-term argument as one Arg between its neighbours" do
      value = read("xⓐ(unit \\mupkg)y").value

      expect(value.map(&:class)).to eq(
        [math::Symbols::Symbol, math::Function::Arg, math::Symbols::Symbol],
      )
      expect(value[1].parameter_one).to be_a(math::Formula)
      expect(value[1].parameter_one.value.length).to eq(2)
    end

    ["ⓐ", "ⓐx", "ⓐ(x)", "ⓐ(unit)"].each do |input|
      it "raises a ParseError for #{input.inspect} instead of keeping the raw tree" do
        expect { math.parse(input, :unicode) }.to raise_error(math::ParseError)
      end
    end
  end
end
