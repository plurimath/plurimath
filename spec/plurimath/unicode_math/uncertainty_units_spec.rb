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

  # A unit of more than one character is written as quoted upright text,
  # \mup"kg", because UnicodeMath reads \mupkg as an upright k followed by g.
  # One-letter units keep the \mupg form, which already reads back whole.
  context "with a unit written to UnicodeMath and read back" do
    sources = %i[from_asciimath from_mathml]
    cases = {
      "g" => ["\\mupg", %w[g], 'ustd(1.2, 0.1, "unitsml(g)")'],
      "m" => ["\\mupm", %w[m], 'ustd(1.2, 0.1, "unitsml(m)")'],
      "kg" => ['\\mup"kg"', %w[kg], 'ustd(1.2, 0.1, "unitsml(kg)")'],
      "mol" => ['\\mup"mol"', %w[mol], 'ustd(1.2, 0.1, "unitsml(mol)")'],
      "um" => ['\\mup"µm"', %w[µm], 'ustd(1.2, 0.1) rm("&#xb5;m")'],
      "m*s^-1" => ["\\mupm ⋅ \\mups^(− 1)", %w[m s], 'ustd(1.2, 0.1, "unitsml(m*s^-1)")'],
      "kg*m^2" => ['\\mup"kg" ⋅ \\mupm^(2)', %w[kg m], 'ustd(1.2, 0.1, "unitsml(kg*m^2)")'],
    }

    # The text of each upright run in a unit, in order.
    def upright_runs(node)
      case node
      when math::Function::FontStyle::Normal
        inner = node.parameter_one
        text = inner.is_a?(math::Function::Text) ? inner.parameter_one : inner.value
        [Plurimath::Utility.html_entity_to_unicode(text)]
      when math::Formula then node.value.flat_map { |part| upright_runs(part) }
      when math::Function::Power then upright_runs(node.parameter_one)
      else []
      end
    end

    def from_asciimath(unit)
      math.parse("ustd(1.2, 0.1, \"unitsml(#{unit})\")", :asciimath)
    end

    def from_mathml(unit)
      math.parse(from_asciimath(unit).to_mathml, :mathml)
    end

    cases.each do |unit, (written, runs, asciimath)|
      sources.each do |source|
        context "with #{unit} #{source.to_s.tr('_', ' ')}" do
          let(:formula) { public_send(source, unit) }
          let(:output) { formula.to_unicodemath }
          let(:read_back) { math.parse(output, :unicode) }

          it "writes the unit as #{written}" do
            marker = "ⓘ(\"standard-uncertainty(1.2,0.1,$unit)\"1.2(0.1)ⓐ(unit "
            expect(output).to eq("#{marker}#{written}))")
          end

          it "reads the unit back as the same upright runs" do
            node = read_back.value.first

            expect(read_back.value.length).to eq(1)
            expect(node).to be_a(math::Function::Uncertainty)
            expect(upright_runs(node.unit)).to eq(runs)
          end

          it "writes the same UnicodeMath and AsciiMath after reading it back" do
            expect(read_back.to_unicodemath).to eq(output)
            expect(read_back.to_asciimath).to eq(asciimath)
          end
        end
      end
    end

    it "writes a UnitsML unit outside an uncertainty in the same way" do
      expect(math.parse('1 "unitsml(kg)"', :asciimath).to_unicodemath)
        .to eq('1 \\mup"kg"')
      expect(math.parse('1 "unitsml(g)"', :asciimath).to_unicodemath)
        .to eq("1 \\mupg")
    end

    it "keeps a multi-letter upright symbol outside a unit unchanged" do
      formula = math::Formula.new(
        [math::Function::FontStyle::Normal.new(math::Symbols::Symbol.new("kg"))],
      )

      expect(formula.to_unicodemath).to eq("\\mupkg")
    end
  end
end
