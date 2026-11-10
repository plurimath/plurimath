require "spec_helper"

RSpec.describe Plurimath::Math::Evaluation::Evaluator do
  let(:formula) do
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Sqrt.new(Plurimath::Math::Number.new("2"))
    ])
  end

  it "uses the explicit deferred representation without rendering the formula" do
    ast = { "type" => "sqrt", "argument" => { "type" => "number", "value" => "2" } }
    expect(formula).not_to receive(:to_asciimath)
    result = described_class.new(formula, {}, mode: :strict, unevaluated: [ast]).evaluate
    expect(result.value).to be_nil
    expect(result.unevaluated).to eq([ast])
  end

  it "preserves the legacy rendered representation by default" do
    expect(formula).to receive(:to_asciimath).and_return("sqrt(2)")
    expect(described_class.new(formula, {}, mode: :strict).evaluate.unevaluated).to eq(["sqrt(2)"])
  end

  it "requires an array or nil and accepts an explicit empty representation" do
    expect { described_class.new(formula, {}, unevaluated: {}) }.to raise_error(ArgumentError)
    expect(formula).not_to receive(:to_asciimath)
    expect(described_class.new(formula, {}, mode: :strict, unevaluated: []).evaluate.unevaluated).to eq([])
  end
end
