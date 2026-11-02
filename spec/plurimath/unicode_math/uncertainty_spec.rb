# frozen_string_literal: true

require "spec_helper"
require "yaml"

# UnicodeMath input for measurement uncertainty (plurimath#493, B3.3).
# Expected values come from spec/plurimath/fixtures/uncertainty/contract.yml.
RSpec.describe Plurimath::UnicodeMath do
  def self.contract_examples
    @contract_examples ||= YAML.load_file(
      File.expand_path("../fixtures/uncertainty/contract.yml", __dir__),
    )["cases"].flat_map { |entry| entry["examples"] }
  end

  def contract_example(id)
    self.class.contract_examples.find { |entry| entry["id"] == id }
  end

  def read(input)
    described_class.new(input).to_formula
  end

  def node_class
    Plurimath::Math::Function::Uncertainty
  end

  def number(text)
    Plurimath::Math::Number.new(text)
  end

  def build_node(model, unit)
    options = { category: model["category"].to_sym, unit: unit }
    %w[magnitude coverage_factor coverage_probability lower upper].each do |field|
      options[field.to_sym] = number(model[field]) if model[field]
    end
    options[:notation] = model["notation"].to_sym if model["notation"]
    options[:interval_kind] = model["interval_kind"].to_sym if model["interval_kind"]
    node_class.new(number(model["value"]), **options)
  end

  # The unit is restored as its rendered content (\mup), not as a Unitsml
  # node.
  def rendered_unit(model)
    return unless model["unit"]

    Plurimath::Math::Formula.new(
      [
        Plurimath::Math::Function::FontStyle::Normal.new(
          Plurimath::Math::Symbols::Symbol.new(model["unit"]["text"]),
          "rm",
        ),
      ],
    )
  end

  context "with the contract input cells" do
    contract_examples.each do |entry|
      next unless entry.dig("inputs", "unicodemath")

      if entry["error"]
        it "rejects #{entry['id']} with #{entry['error']}", contract_id: entry["id"] do |ex|
          example = contract_example(ex.metadata[:contract_id])
          input = example["inputs"]["unicodemath"]

          expect { read(input) }.to raise_error(Object.const_get(example["error"]))
          expect { Plurimath::Math.parse(input, :unicode) }
            .to raise_error(Plurimath::Error)
        end

        next
      end

      next unless entry.dig("model", "class") == "Plurimath::Math::Function::Uncertainty"

      it "reads #{entry['id']} as one Uncertainty node", contract_id: entry["id"] do |ex|
        example = contract_example(ex.metadata[:contract_id])
        model = example["model"]

        expect(read(example["inputs"]["unicodemath"]).value)
          .to eq([build_node(model, rendered_unit(model))])
      end

      it "reads #{entry['id']} back from its own UnicodeMath output", contract_id: entry["id"] do |ex|
        example = contract_example(ex.metadata[:contract_id])
        node = read(example["inputs"]["unicodemath"]).value.first
        output = Plurimath::Math::Formula.new([node]).to_unicodemath

        expect(read(output).value).to eq([node])
      end

      it "reads #{entry['id']} from the UnicodeMath written for the model", contract_id: entry["id"] do |ex|
        model = contract_example(ex.metadata[:contract_id])["model"]
        unit = model["unit"] && Plurimath::Math::Function::Unitsml.new(model["unit"]["text"])
        output = Plurimath::Math::Formula.new([build_node(model, unit)]).to_unicodemath

        expect(read(output).value).to eq([build_node(model, rendered_unit(model))])
      end
    end

    it "keeps ordinary_pm.numbers as Number, Pm, Number" do
      input = contract_example("ordinary_pm.numbers")["inputs"]["unicodemath"]

      expect(read(input).value).to eq(
        [number("1.23"), Plurimath::Math::Symbols::Pm.new, number("0.04")],
      )
    end
  end

  context "with ordinary content" do
    it "keeps any other intent as Function::Intent" do
      formula = read("ⓘ(\"mass\"1.230(0.004))")

      expect(formula.value.first).to be_a(Plurimath::Math::Function::Intent)
    end

    it "keeps a name that only starts like a marker as Function::Intent" do
      formula = read("ⓘ(\"standard-uncertainty-like(1.230,0.004)\"1.230(0.004))")

      expect(formula.value.first).to be_a(Plurimath::Math::Function::Intent)
    end

    it "keeps a bracketed number after a number as ordinary content" do
      expect(read("1.230(4)").value.map(&:class)).not_to include(node_class)
    end

    it "keeps an intent with an arg operator and a comma list as Function::Intent" do
      formula = read("ⓘ(\"mass\"(1±2)ⓐ(unit \\mupg), k=2)")

      expect(formula.value.first).to be_a(Plurimath::Math::Function::Intent)
    end
  end

  context "with a malformed marker" do
    {
      "a missing coverage factor" => "ⓘ(\"expanded-uncertainty(10.0,0.3)\"(10.0±0.3))",
      "a wrong argument count" => "ⓘ(\"standard-uncertainty(1.230)\"1.230(0.004))",
      "an unknown property" => "ⓘ(\"standard-uncertainty:short(1.230,0.004)\"1.230(4))",
      "a coverage factor of zero" => "ⓘ(\"expanded-uncertainty(10.0,0.3,0)\"(10.0±0.3), k=0)",
      "reversed interval endpoints" =>
        "ⓘ(\"coverage-interval(1.024,1.088,0.983,0.95)\"1.024, [1.088, 0.983], p=0.95)",
      "a $unit reference with no unit argument" =>
        "ⓘ(\"expanded-uncertainty(10.0,0.3,2,$unit)\"(10.0±0.3), k=2)",
      "two unit arguments" =>
        "ⓘ(\"expanded-uncertainty(10.0,0.3,2,$unit)\"(10.0±0.3)ⓐ(unit \\mupg)ⓐ(unit \\mupg), k=2)",
    }.each do |description, input|
      it "rejects #{description}", input: input do |ex|
        expect { read(ex.metadata[:input]) }
          .to raise_error(Plurimath::Errors::InvalidUncertainty)
      end
    end
  end

  it "trusts the marker over the visible content" do
    expect(read("ⓘ(\"standard-uncertainty(1.230,0.004)\"9.999(1))").value).to eq(
      [node_class.new(number("1.230"), category: :standard, magnitude: number("0.004"))],
    )
  end
end
