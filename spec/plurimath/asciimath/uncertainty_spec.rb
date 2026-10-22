# frozen_string_literal: true

require "spec_helper"
require "yaml"

# Transform side of AsciiMath uncertainty input (plurimath#493). The trees are
# built by hand in the shape of docs/uncertainty-asciimath-tree.md, because the
# grammar that produces them is not written yet.
module AsciimathUncertaintyTrees
  CONTRACT = YAML.safe_load_file(
    File.expand_path("../fixtures/uncertainty/contract.yml", __dir__),
  )
  UNCERTAINTY = "Plurimath::Math::Function::Uncertainty"

  # The tree the grammar must give for each AsciiMath input cell.
  TREES = {
    "standard.default" =>
      { uncertainty_class: "ustd", value: "1.230", magnitude: "0.004" },
    "expanded.k_only" =>
      { uncertainty_class: "uexp", value: "10.0", magnitude: "0.3",
        coverage_factor: "2" },
    "expanded.k_and_p" =>
      { uncertainty_class: "uexp", value: "100.02147", magnitude: "0.00079",
        coverage_factor: "2", coverage_probability: "0.95" },
    "asymmetric.shortest_interval" =>
      { uncertainty_class: "ucov", value: "1.024", lower: "0.983",
        upper: "1.088", coverage_probability: "0.95",
        interval_kind: "shortest" },
    "concise_digits.two_places" =>
      { uncertainty_class: "ustd", value: "1.23", concise_digits: "4" },
    "concise_digits.three_places" =>
      { uncertainty_class: "ustd", value: "1.230", concise_digits: "4" },
    "concise_digits.gum_mass" =>
      { uncertainty_class: "ustd", value: "100.02147", concise_digits: "35" },
    "absolute_parentheses.plan" =>
      { uncertainty_class: "ustd", value: "1.23", magnitude: "0.04" },
    "absolute_parentheses.gum_mass" =>
      { uncertainty_class: "ustd", value: "100.02147", magnitude: "0.00035" },
    "units.expanded_gram" =>
      { uncertainty_class: "uexp", value: "100.02147", magnitude: "0.00079",
        coverage_factor: "2", unit: "g" },
    "invalid.asciimath_missing_k" =>
      { uncertainty_class: "uexp", value: "10.0", magnitude: "0.3" },
  }.freeze

  # Every cell with an AsciiMath input that is (or fails to be) an
  # uncertainty; the ordinary_pm cells are plain content, not this tree.
  CELLS = CONTRACT["cases"].flat_map { |c| c["examples"] }.select do |example|
    example.dig("inputs", "asciimath") &&
      (example.dig("model", "class") == UNCERTAINTY ||
       example["phase"] == "B4")
  end.to_h { |example| [example["id"], example] }.freeze
end

RSpec.describe Plurimath::Asciimath::Transform do
  def slice(text)
    Parslet::Slice.new(Parslet::Position.new(text, 0), text)
  end

  def tree_of(fields)
    { uncertainty: fields.transform_values { |text| slice(text) } }
  end

  def number(text)
    text && Plurimath::Math::Number.new(text)
  end

  def node_of(model)
    unit = model["unit"] &&
      Plurimath::Math::Function::Unitsml.new(model["unit"]["text"])
    Plurimath::Math::Function::Uncertainty.new(
      number(model["value"]),
      category: model["category"].to_sym,
      magnitude: number(model["magnitude"]),
      coverage_factor: number(model["coverage_factor"]),
      coverage_probability: number(model["coverage_probability"]),
      lower: number(model["lower"]),
      upper: number(model["upper"]),
      interval_kind: model["interval_kind"]&.to_sym,
      notation: model["notation"]&.to_sym || :absolute,
      unit: unit,
    )
  end

  # Math.parse with the grammar replaced by the hand-built tree.
  def parse_with_tree(input, fields)
    grammar = instance_double(Plurimath::Asciimath::Parse)
    allow(grammar).to receive(:parse).with(input)
      .and_return({ expr: { sequence: tree_of(fields) } })
    allow(Plurimath::Asciimath::Parse).to receive(:new).and_return(grammar)
    Plurimath::Math.parse(input, :asciimath)
  end

  it "has a tree for every uncertainty AsciiMath input cell" do
    expect(AsciimathUncertaintyTrees::CELLS.keys)
      .to match_array(AsciimathUncertaintyTrees::TREES.keys)
  end

  AsciimathUncertaintyTrees::CELLS.each do |id, example|
    context "with #{id}: #{example['inputs']['asciimath']}" do
      let(:input) { AsciimathUncertaintyTrees::CELLS[id]["inputs"]["asciimath"] }
      let(:fields) { AsciimathUncertaintyTrees::TREES.fetch(id) }

      if example["error"]
        it "raises InvalidUncertainty from the transform" do
          expect { described_class.new.apply(tree_of(fields)) }
            .to raise_error(Plurimath::Errors::InvalidUncertainty)
        end

        it "raises #{example['error']} from Math.parse" do
          expect { parse_with_tree(input, fields) }
            .to raise_error(Plurimath::Math::ParseError)
        end
      else
        let(:expected) { node_of(AsciimathUncertaintyTrees::CELLS[id]["model"]) }

        it "transforms the tree into the model" do
          expect(described_class.new.apply(tree_of(fields))).to eq(expected)
        end

        it "reads back through Math.parse" do
          expect(parse_with_tree(input, fields))
            .to eq(Plurimath::Math::Formula.new([expected]))
        end
      end
    end
  end

  context "with the symmetric interval kind" do
    it "reads symmetric as probabilistically symmetric" do
      node = described_class.new.apply(
        tree_of(uncertainty_class: "ucov", value: "1.024", lower: "0.983",
                upper: "1.088", coverage_probability: "0.95",
                interval_kind: "symmetric"),
      )
      expect(node.interval_kind).to eq(:probabilistically_symmetric)
    end

    it "accepts an interval without a kind" do
      node = described_class.new.apply(
        tree_of(uncertainty_class: "ucov", value: "1.024", lower: "0.983",
                upper: "1.088", coverage_probability: "0.95"),
      )
      expect(node.interval_kind).to be_nil
    end
  end

  context "with concise digits" do
    {
      ["12", "3"] => "3",
      ["1.2", "15"] => "1.5",
      ["-1.230", "04"] => "0.004",
      ["1.2", "150"] => "15.0",
    }.each do |(value, digits), magnitude|
      it "reads #{value}(#{digits}) as magnitude #{magnitude}" do
        node = described_class.new.apply(
          tree_of(uncertainty_class: "ustd", value: value,
                  concise_digits: digits),
        )
        expect([node.magnitude.value, node.notation])
          .to eq([magnitude, :concise])
      end
    end
  end

  context "with malformed trees" do
    {
      "an unknown class" => { uncertainty_class: "uvar", value: "1.0",
                              magnitude: "0.1" },
      "a key from another class" => { uncertainty_class: "ustd", value: "1.0",
                                      magnitude: "0.1",
                                      coverage_factor: "2" },
      "magnitude and concise digits" => { uncertainty_class: "ustd",
                                          value: "1.0", magnitude: "0.1",
                                          concise_digits: "1" },
      "non-digit concise digits" => { uncertainty_class: "ustd",
                                      value: "1.0", concise_digits: "x" },
      "an unknown interval kind" => { uncertainty_class: "ucov",
                                      value: "1.024", lower: "0.983",
                                      upper: "1.088",
                                      coverage_probability: "0.95",
                                      interval_kind: "widest" },
      "a bad number" => { uncertainty_class: "ustd", value: "1.0",
                          magnitude: "abc" },
    }.each do |name, fields|
      it "raises InvalidUncertainty for #{name}" do
        expect { described_class.new.apply(tree_of(fields)) }
          .to raise_error(Plurimath::Errors::InvalidUncertainty)
      end
    end

    it "raises InvalidUncertainty for a non-text leaf" do
      tree = { uncertainty: { uncertainty_class: slice("ustd"),
                              value: { number: slice("1.0") },
                              magnitude: slice("0.1") } }
      expect { described_class.new.apply(tree) }
        .to raise_error(Plurimath::Errors::InvalidUncertainty)
    end
  end
end
