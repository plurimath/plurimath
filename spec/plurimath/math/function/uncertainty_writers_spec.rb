# frozen_string_literal: true

require "spec_helper"

# Writer fixes for Math::Function::Uncertainty (plurimath#493): negative values
# in UnicodeMath, units read from markup written back as AsciiMath, and units
# that cannot be written at all.
RSpec.describe Plurimath::Math::Function::Uncertainty do
  let(:invalid) { Plurimath::Errors::InvalidUncertainty }

  def asciimath(text)
    Plurimath::Math.parse(text, :asciimath)
  end

  def single_node(formula)
    expect(formula.value.length).to eq(1)
    node = formula.value.first
    expect(node).to be_a(described_class)
    node
  end

  def num(text)
    Plurimath::Math::Number.new(text)
  end

  def standard_with(unit)
    described_class.new(num("1.230"), category: :standard,
                                      magnitude: num("0.004"), unit: unit)
  end

  describe "negative values through UnicodeMath" do
    {
      "ustd(-1.230, 0.004)" =>
        'ⓘ("standard-uncertainty(-1.230,0.004)"〖-1.230〗(0.004))',
      "ustd(-1.230(4))" =>
        'ⓘ("standard-uncertainty:concise(-1.230,0.004)"〖-1.230〗(4))',
      "uexp(-10.0, 0.3, 2.5, 0.95)" =>
        'ⓘ("expanded-uncertainty(-10.0,0.3,2.5,0.95)"(-10.0±0.3), k=2.5, p=0.95)',
      "ucov(-1.024, 0.983, 1.088, 0.95, shortest)" =>
        'ⓘ("coverage-interval:shortest(-1.024,0.983,1.088,0.95)"' \
        "〖-1.024〗, [0.983, 1.088], p=0.95)",
      "ucov(-1.024, 0.983, 1.088, 0.95)" =>
        'ⓘ("coverage-interval(-1.024,0.983,1.088,0.95)"' \
        "〖-1.024〗, [0.983, 1.088], p=0.95)",
    }.each do |input, expected|
      it "writes #{input} with the marker unchanged and reads it back" do
        original = single_node(asciimath(input))
        written = original.to_unicodemath(options: {})
        expect(written).to eq(expected)

        read = single_node(Plurimath::Math.parse(written, :unicode))
        expect(read).to eq(original)
        expect(read.to_asciimath(options: {})).to eq(input)
      end
    end

    it "leaves a positive value unwrapped" do
      node = single_node(asciimath("ustd(1.230, 0.004)"))
      expect(node.to_unicodemath(options: {}))
        .to eq('ⓘ("standard-uncertainty(1.230,0.004)"1.230(0.004))')
    end
  end

  describe "units read from MathML and OMML, written as AsciiMath" do
    markup_languages = %i[mathml omml]

    {
      "g" => "g",
      "V" => "V",
      "kg*m^2" => "kg*m^2",
      "mol*K" => "mol*K",
      "kg^-1" => "kg^-1",
      "m/s" => "m*s^-1",
    }.each do |unit_text, written_text|
      markup_languages.each do |language|
        it "writes unitsml(#{unit_text}) read from #{language} as " \
           "\"unitsml(#{written_text})\"" do
          source = asciimath(
            %(uexp(100.02147, 0.00079, 2, "unitsml(#{unit_text})")),
          )
          markup = source.public_send(:"to_#{language}")
          read = Plurimath::Math.parse(markup, language)
          expect(single_node(read).unit).to be_a(Plurimath::Math::Formula)

          written = read.to_asciimath
          expect(written).to eq(
            %(uexp(100.02147, 0.00079, 2, "unitsml(#{written_text})")),
          )
          back = single_node(asciimath(written))
          expect(back.unit).to eq(
            Plurimath::Math::Function::Unitsml.new(written_text),
          )
          expect(asciimath(written).to_mathml).to eq(source.to_mathml)
        end
      end
    end

    it "writes a unit that is not UnitsML after the call, so it still parses" do
      unit = Plurimath::Math::Formula.new(
        [Plurimath::Math::Function::FontStyle::Bold.new(
          Plurimath::Math::Symbols::Symbol.new("x"), "bold"
        )],
      )
      written = standard_with(unit).to_asciimath(options: {})
      expect(written).to eq("ustd(1.230, 0.004) mathbf(x)")

      read = asciimath(written)
      expect(read.value.first).to be_a(described_class)
      expect(read.value.first.unit).to be_nil
    end

    it "writes a unit symbol UnitsML does not know after the call" do
      unit = Plurimath::Math::Formula.new(
        [Plurimath::Math::Function::FontStyle::Normal.new(
          Plurimath::Math::Symbols::Symbol.new("zz"), "normal"
        )],
      )
      expect(standard_with(unit).to_asciimath(options: {}))
        .to eq("ustd(1.230, 0.004) rm(zz)")
    end
  end

  describe "units that cannot be written" do
    it "rejects an empty unit formula" do
      expect { standard_with(Plurimath::Math::Formula.new([])) }
        .to raise_error(invalid, /unit must not be empty/)
    end

    it "rejects a unit formula holding only empty formulas" do
      empty = Plurimath::Math::Formula.new([Plurimath::Math::Formula.new([])])
      expect { standard_with(empty) }
        .to raise_error(invalid, /unit must not be empty/)
    end

    it "rejects a unit holding an uncertainty" do
      inner = single_node(asciimath("uexp(10.0, 0.3, 2)"))
      expect { standard_with(Plurimath::Math::Formula.new([inner])) }
        .to raise_error(invalid, /unit must not contain an uncertainty/)
    end

    it "rejects a unit holding an uncertainty deeper down" do
      inner = single_node(asciimath("uexp(10.0, 0.3, 2)"))
      unit = Plurimath::Math::Formula.new(
        [Plurimath::Math::Function::Power.new(inner, num("2"))],
      )
      expect { standard_with(unit) }
        .to raise_error(invalid, /unit must not contain an uncertainty/)
    end
  end
end
