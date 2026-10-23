# frozen_string_literal: true

require "spec_helper"
require "yaml"

# OMML input for measurement uncertainty (plurimath#493, B3.2).
# Expected values come from spec/plurimath/fixtures/uncertainty/contract.yml.
RSpec.describe Plurimath::Omml do
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

  # The unit is restored as its rendered content (an upright run), not as a
  # Unitsml node.
  def rendered_unit(model)
    return unless model["unit"]

    Plurimath::Math::Formula.new(
      [
        Plurimath::Math::Function::FontStyle::Normal.new(
          Plurimath::Math::Function::Text.new(model["unit"]["text"], lang: :omml),
          "mathrm",
        ),
      ],
    )
  end

  def run(text, upright: false)
    style = upright ? "<m:rPr><m:sty m:val=\"p\"/></m:rPr>" : ""
    "<m:r>#{style}<m:t>#{text}</m:t></m:r>"
  end

  def phantom(text, show: "off")
    <<~XML
      <m:phant>
        <m:phantPr>
          <m:show m:val="#{show}"/>
          <m:zeroWid m:val="on"/>
          <m:zeroAsc m:val="on"/>
          <m:zeroDesc m:val="on"/>
        </m:phantPr>
        <m:e>#{run(text, upright: true)}</m:e>
      </m:phant>
    XML
  end

  def wrap(body)
    <<~XML
      <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math">
        <m:oMath>#{body}</m:oMath>
      </m:oMathPara>
    XML
  end

  def box(*children)
    "<m:box><m:e>#{children.join}</m:e></m:box>"
  end

  context "with the contract input cells" do
    contract_examples.each do |entry|
      next unless entry.dig("inputs", "omml")
      next unless entry.dig("model", "class") == "Plurimath::Math::Function::Uncertainty"

      it "reads #{entry['id']} as one Uncertainty node", contract_id: entry["id"] do |ex|
        example = contract_example(ex.metadata[:contract_id])
        model = example["model"]

        expect(read(example["inputs"]["omml"]).value)
          .to eq([build_node(model, rendered_unit(model))])
      end

      it "reads #{entry['id']} back from its own OMML output", contract_id: entry["id"] do |ex|
        example = contract_example(ex.metadata[:contract_id])
        node = read(example["inputs"]["omml"]).value.first
        output = Plurimath::Math::Formula.new([node]).to_omml

        expect(read(output).value).to eq([node])
      end

      it "reads #{entry['id']} from the OMML written for the model", contract_id: entry["id"] do |ex|
        model = contract_example(ex.metadata[:contract_id])["model"]
        unit = model["unit"] && Plurimath::Math::Function::Unitsml.new(model["unit"]["text"])
        output = Plurimath::Math::Formula.new([build_node(model, unit)]).to_omml

        expect(read(output).value).to eq([build_node(model, rendered_unit(model))])
      end
    end

    # Baseline defect recorded in the contract: OMML reads the numbers as
    # Symbol. Only the absence of an Uncertainty node is asserted here.
    it "keeps ordinary_pm.numbers as plain content around Pm" do
      input = contract_example("ordinary_pm.numbers")["inputs"]["omml"]
      values = read(input).value

      expect(values.length).to eq(3)
      expect(values[1]).to eq(Plurimath::Math::Symbols::Pm.new)
      expect(values.map(&:class)).not_to include(node_class)
    end
  end

  context "with ordinary content" do
    it "keeps a box whose phantom is visible as ordinary content" do
      input = wrap(box(phantom("standard-uncertainty(1.230,0.004)", show: "on"), run("1.230")))

      expect(read(input).value.map(&:class)).not_to include(node_class)
    end

    it "keeps a box without a phantom as ordinary content" do
      input = wrap(box(run("standard-uncertainty(1.230,0.004)")))

      expect(read(input).value.map(&:class)).not_to include(node_class)
    end

    it "keeps a hidden phantom with other text as ordinary content" do
      input = wrap(box(phantom("mass"), run("1.230")))

      expect(read(input).value.map(&:class)).not_to include(node_class)
    end

    it "keeps a marker phantom outside a box as ordinary content" do
      input = wrap(phantom("standard-uncertainty(1.230,0.004)") + run("1.230"))

      expect(read(input).value.map(&:class)).not_to include(node_class)
    end
  end

  context "with a malformed marker" do
    {
      "a missing coverage factor" => "expanded-uncertainty(10.0,0.3)",
      "a number that is not plain decimal" => "standard-uncertainty(1.230,abc)",
      "an unknown property" => "coverage-interval:widest(1.024,0.983,1.088,0.95)",
      "a coverage interval without p" => "coverage-interval(1.024,0.983,1.088)",
      "a $unit reference with no unit box" => "expanded-uncertainty(10.0,0.3,2,$unit)",
    }.each do |description, marker|
      it "rejects #{description}", marker: marker do |ex|
        input = wrap(box(phantom(ex.metadata[:marker]), run("10.0")))

        expect { read(input) }.to raise_error(Plurimath::Errors::InvalidUncertainty)
        expect { Plurimath::Math.parse(input, :omml) }.to raise_error(Plurimath::Error)
      end
    end

    it "rejects two inner boxes when the marker refers to $unit" do
      input = wrap(
        box(
          phantom("expanded-uncertainty(10.0,0.3,2,$unit)"),
          box(run("g", upright: true)),
          box(run("kg", upright: true)),
        ),
      )

      expect { read(input) }.to raise_error(Plurimath::Errors::InvalidUncertainty)
    end
  end

  it "reads a marker split over several runs" do
    input = wrap(
      box(
        "<m:phant><m:phantPr><m:show m:val=\"off\"/></m:phantPr><m:e>",
        run("standard-uncertainty("),
        run("1.230,0.004)"),
        "</m:e></m:phant>",
        run("1.230"),
      ),
    )

    expect(read(input).value).to eq(
      [node_class.new(number("1.230"), category: :standard, magnitude: number("0.004"))],
    )
  end
end
