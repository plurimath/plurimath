# frozen_string_literal: true

require "spec_helper"
require "yaml"

# MathML input for measurement uncertainty (plurimath#493, B3.1).
# Expected values come from spec/plurimath/fixtures/uncertainty/contract.yml.
RSpec.describe Plurimath::Mathml do
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

  # The unit is restored as its rendered content, not as a Unitsml node.
  def rendered_unit(model)
    return unless model["unit"]

    Plurimath::Math::Formula.new(
      [
        Plurimath::Math::Function::FontStyle::Normal.new(
          Plurimath::Math::Symbols::Symbol.new(model["unit"]["text"]),
          "normal",
        ),
      ],
    )
  end

  def wrap(body)
    <<~MATHML
      <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
        <mstyle displaystyle="true">
          #{body}
        </mstyle>
      </math>
    MATHML
  end

  context "with the contract input cells" do
    contract_examples.each do |entry|
      next unless entry.dig("inputs", "mathml")

      if entry["error"]
        it "rejects #{entry['id']} with #{entry['error']}", contract_id: entry["id"] do |ex|
          example = contract_example(ex.metadata[:contract_id])
          input = example["inputs"]["mathml"]

          expect { read(input) }.to raise_error(Object.const_get(example["error"]))
          expect { Plurimath::Math.parse(input, :mathml) }
            .to raise_error(Plurimath::Error)
        end

        next
      end

      next unless entry.dig("model", "class") == "Plurimath::Math::Function::Uncertainty"

      it "reads #{entry['id']} as one Uncertainty node", contract_id: entry["id"] do |ex|
        example = contract_example(ex.metadata[:contract_id])
        model = example["model"]

        expect(read(example["inputs"]["mathml"]).value)
          .to eq([build_node(model, rendered_unit(model))])
      end

      it "reads #{entry['id']} back from its own MathML output", contract_id: entry["id"] do |ex|
        example = contract_example(ex.metadata[:contract_id])
        node = read(example["inputs"]["mathml"]).value.first
        output = Plurimath::Math::Formula.new([node]).to_mathml

        expect(read(output).value).to eq([node])
      end

      it "reads #{entry['id']} from the MathML written for the model", contract_id: entry["id"] do |ex|
        model = contract_example(ex.metadata[:contract_id])["model"]
        unit = model["unit"] && Plurimath::Math::Function::Unitsml.new(model["unit"]["text"])
        output = Plurimath::Math::Formula.new([build_node(model, unit)]).to_mathml

        expect(read(output).value).to eq([build_node(model, rendered_unit(model))])
      end
    end

    it "keeps ordinary_pm.numbers as Number, Pm, Number" do
      input = contract_example("ordinary_pm.numbers")["inputs"]["mathml"]

      expect(read(input).value).to eq(
        [number("1.23"), Plurimath::Math::Symbols::Pm.new, number("0.04")],
      )
    end
  end

  context "with ordinary content" do
    it "keeps any other intent as Function::Intent" do
      formula = read(wrap(<<~XML))
        <mrow intent="standard-uncertainty-like(1.230,0.004)">
          <mn>1.230</mn>
          <mo>&#xb1;</mo>
          <mn>0.004</mn>
        </mrow>
      XML

      expect(formula.value.first).to be_a(Plurimath::Math::Function::Intent)
      expect(formula.value.first.parameter_two.parameter_one)
        .to eq("standard-uncertainty-like(1.230,0.004)")
    end

    it "keeps a bracketed number after a number as ordinary content" do
      formula = read(wrap("<mn>1.230</mn><mrow><mo>(</mo><mn>4</mn><mo>)</mo></mrow>"))

      expect(formula.value.map(&:class)).not_to include(node_class)
    end
  end

  context "with a malformed marker" do
    {
      "a wrong argument count" => "standard-uncertainty(1.230)",
      "a missing coverage factor" => "expanded-uncertainty(10.0,0.3)",
      "too many arguments" => "expanded-uncertainty(10.0,0.3,2,0.95,1)",
      "a number that is not plain decimal" => "standard-uncertainty(1.230,abc)",
      "an exponent" => "standard-uncertainty(1.230e-3,0.004)",
      "a negative magnitude" => "standard-uncertainty(1.230,-0.004)",
      "an unknown property" => "standard-uncertainty:short(1.230,0.004)",
      "a property on an expanded result" => "expanded-uncertainty:concise(10.0,0.3,2)",
      "a concise form that cannot be written" => "standard-uncertainty:concise(1.2,0.004)",
      "a probability out of range" => "expanded-uncertainty(10.0,0.3,2,95)",
      "reversed interval endpoints" => "coverage-interval(1.024,1.088,0.983,0.95)",
      "no arguments" => "standard-uncertainty",
      "an empty argument" => "standard-uncertainty(1.230,)",
      "a reference that is not last" => "expanded-uncertainty(10.0,$unit,0.3,2)",
      "an unknown reference" => "expanded-uncertainty(10.0,0.3,2,$mass)",
      "trailing text" => "standard-uncertainty(1.230,0.004) extra",
      "a $unit reference with no unit child" => "expanded-uncertainty(10.0,0.3,2,$unit)",
    }.each do |description, marker|
      it "rejects #{description}", marker: marker do |ex|
        input = wrap("<mrow intent=\"#{ex.metadata[:marker]}\"><mn>10.0</mn><mn>0.3</mn></mrow>")

        expect { read(input) }.to raise_error(Plurimath::Errors::InvalidUncertainty)
      end
    end

    it "rejects two arg=\"unit\" children" do
      input = wrap(<<~XML)
        <mrow intent="expanded-uncertainty(10.0,0.3,2,$unit)">
          <mrow arg="unit"><mi>g</mi></mrow>
          <mrow arg="unit"><mi>kg</mi></mrow>
        </mrow>
      XML

      expect { read(input) }.to raise_error(Plurimath::Errors::InvalidUncertainty)
    end
  end

  it "trusts the marker over the visible content" do
    input = wrap(<<~XML)
      <mrow intent="standard-uncertainty(1.230,0.004)">
        <mn>9.999</mn>
        <mrow><mo>(</mo><mn>1</mn><mo>)</mo></mrow>
      </mrow>
    XML

    expect(read(input).value).to eq(
      [node_class.new(number("1.230"), category: :standard, magnitude: number("0.004"))],
    )
  end
end
