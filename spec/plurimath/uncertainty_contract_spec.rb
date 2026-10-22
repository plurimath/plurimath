# frozen_string_literal: true

require "spec_helper"
require "yaml"

# Builds nodes and renders cells for the uncertainty acceptance contract,
# spec/plurimath/fixtures/uncertainty/contract.yml (plurimath#493).
module UncertaintyContract
  PATH = File.join(__dir__, "fixtures", "uncertainty", "contract.yml")
  CONTRACT = YAML.safe_load_file(PATH)
  EXAMPLES = CONTRACT["cases"].flat_map { |c| c["examples"] }
    .to_h { |example| [example["id"], example] }
  UNCERTAINTY = "Plurimath::Math::Function::Uncertainty"
  NUMBER_FIELDS = %w[value magnitude coverage_factor coverage_probability
                     lower upper].freeze

  module_function

  def number(text)
    text && Plurimath::Math::Number.new(text)
  end

  def unit(spec)
    case spec
    when nil then nil
    when Hash
      unless spec["class"] == "Plurimath::Math::Function::Unitsml"
        raise "unsupported unit class #{spec['class']}"
      end

      Plurimath::Math::Function::Unitsml.new(spec["text"])
    when /\APlurimath::Math::Symbols::Symbol\((.*)\)\z/
      Plurimath::Math::Symbols::Symbol.new(Regexp.last_match(1))
    else
      raise "unsupported unit #{spec.inspect}"
    end
  end

  def uncertainty(fields)
    kwargs = {
      category: fields["category"].to_sym,
      magnitude: number(fields["magnitude"]),
      coverage_factor: number(fields["coverage_factor"]),
      coverage_probability: number(fields["coverage_probability"]),
      lower: number(fields["lower"]),
      upper: number(fields["upper"]),
      interval_kind: fields["interval_kind"]&.to_sym,
      unit: unit(fields["unit"]),
    }
    kwargs[:notation] = fields["notation"]&.to_sym if fields.key?("notation")
    Plurimath::Math::Function::Uncertainty.new(number(fields["value"]),
                                               **kwargs)
  end

  # An ordinary-content case: build its Formula from the model when every
  # item is spelled out, otherwise read its (pre-existing) AsciiMath input.
  def ordinary_formula(example)
    values = example["model"]["value"].map do |item|
      case item
      when /\APlurimath::Math::Number\((.*)\)\z/
        Plurimath::Math::Number.new(Regexp.last_match(1))
      when "Plurimath::Math::Symbols::Pm"
        Plurimath::Math::Symbols::Pm.new
      end
    end
    return Plurimath::Math::Formula.new(values) if values.all?

    Plurimath::Math.parse(example.dig("inputs", "asciimath"), :asciimath)
  end

  def formula(example)
    if uncertainty?(example)
      Plurimath::Math::Formula.new([uncertainty(example["model"])])
    else
      ordinary_formula(example)
    end
  end

  def uncertainty?(example)
    example.dig("model", "class") == UNCERTAINTY
  end

  def render(formula, format)
    case format
    when "omml" then omml_math(formula.to_omml)
    else formula.public_send(:"to_#{format}")
    end
  end

  # outputs.omml is the m:oMath element of Formula#to_omml, unindented by
  # the two spaces of the m:oMathPara wrapper.
  def omml_math(document)
    lines = document.lines
    first = lines.index { |line| line.strip == "<m:oMath>" }
    last = lines.rindex { |line| line.strip == "</m:oMath>" }
    lines[first..last].map { |line| line.delete_prefix("  ") }.join.chomp
  end
end

# Output cells are asserted against nodes built from each case's `model`.
# Input cells belong to the readers (B3) and AsciiMath (B4) and are skipped.
RSpec.describe Plurimath::Math::Function::Uncertainty do
  it "is built against the expected contract revision" do
    expect(UncertaintyContract::CONTRACT["schema_version"]).to eq(1)
    expect(UncertaintyContract::CONTRACT["cases"].map { |c| c["id"] }).to eq(
      %w[standard expanded asymmetric concise_digits absolute_parentheses
         units invalid ordinary_pm],
    )
  end

  UncertaintyContract::CONTRACT["cases"].each do |contract_case|
    describe contract_case["id"] do
      contract_case["examples"].each do |example|
        describe example["id"] do
          if UncertaintyContract.uncertainty?(example)
            subject(:node) { UncertaintyContract.uncertainty(example["model"]) }

            it "holds the model fields" do
              fields = example["model"]
              expect(node.category).to eq(fields["category"].to_sym)
              UncertaintyContract::NUMBER_FIELDS.each do |field|
                expect(node.public_send(field)&.value).to eq(fields[field])
              end
              expect(node.notation).to eq(fields["notation"]&.to_sym)
              expect(node.interval_kind).to eq(fields["interval_kind"]&.to_sym)
            end

            Array(contract_case["not_equal_to"]).each do |other_id|
              it "is not equal to #{other_id}" do
                other = UncertaintyContract::EXAMPLES[other_id]["model"]
                expect(node).not_to eq(UncertaintyContract.uncertainty(other))
              end
            end
          end

          (example["outputs"] || {}).each do |format, expected|
            it "writes #{format}" do
              formula = UncertaintyContract.formula(example)
              expect(UncertaintyContract.render(formula, format)).to eq(expected)
            end
          end

          if example["constructor"]
            it "raises #{example['error']}" do
              expect { UncertaintyContract.uncertainty(example["constructor"]) }
                .to raise_error(Object.const_get(example["error"]))
            end
          end

          (example["inputs"] || {}).each_key do |format|
            it "reads #{format}" do
              phase = format == "asciimath" ? "B4 (amath)" : "B3 (readers)"
              skip "input cells belong to the #{phase} lane, not the model lane"
            end
          end
        end
      end
    end
  end
end
