# frozen_string_literal: true

require "spec_helper"

# relation1 / logic1 evaluation (plurimath#583): comparisons and connectives
# evaluate to truth values in the in-repo Evaluator, so mode, guard digits
# and the boundary records apply unchanged.
RSpec.describe Plurimath::Math::Formula, "#evaluate relation1 and logic1", engine_loop: :always do
  let(:error) { Plurimath::Errors::Evaluation::UnsupportedExpressionError }

  def run(text, bindings = {}, **options)
    Plurimath::Math.parse(text, :asciimath).evaluate(bindings, **options)
  end

  context "with exact operands" do
    {
      "2 < 3" => true, "3 < 2" => false, "2 <= 2" => true, "3 >= 4" => false,
      "2 > 1" => true, "2 = 2" => true, "2 != 2" => false, "2 != 3" => true,
      "1 + 1 = 2" => true,
      "2 + 3 * 4 < 15" => true
    }.each do |text, verdict|
      it "evaluates `#{text}` to #{verdict} exactly in every mode" do
        [run(text), run(text, {}, mode: :strict)].each do |result|
          expect(result.value).to be(verdict)
          expect(result).to be_exact
          expect(result.boundaries).to be_empty
        end
      end
    end

    it "keeps the boundary-exact verdict for Rational against Float operands" do
      expect(run("x < y", x: Rational(1, 3), y: 0.3333333333333333).value).to be(false)
      expect(run("x = y", x: Rational(1, 10), y: 0.1).value).to be(false)
    end
  end

  context "with limited operands" do
    it "marks a verdict from a limited operand as not exact, without a tolerance" do
      result = run("x < 2", x: 1.5)
      expect(result.value).to be(true)
      expect(result).not_to be_exact
      expect(result.boundaries.map { |boundary| boundary[:operation] }).to eq(["compare"])
      expect(result.boundaries.first).to include(operand_accuracy: :limited_float, result: true)
    end

    it "compares an approximate-mode decimal literal as the float it became" do
      result = run("0.1 + 0.2 = 0.3")
      expect(result.value).to be(false)
      expect(result).not_to be_exact
    end

    it "carries the least precise class through a connective" do
      result = run("(x < 2) ^^ (1 < 2)", x: 1.5)
      expect(result.value).to be(true)
      expect(result).not_to be_exact
    end
  end

  context "in strict mode" do
    it "compares decimal literals exactly as rationals" do
      result = run("0.1 + 0.2 = 0.3", {}, mode: :strict)
      expect(result.value).to be(true)
      expect(result).to be_exact
    end

    it "compares rational quotients exactly" do
      expect(run("1/3 = 2/6", {}, mode: :strict).value).to be(true)
      expect(run("1/3 < 1/2", {}, mode: :strict)).to be_exact
    end

    it "defers at an operand's accuracy boundary with no truth value" do
      result = run("sqrt(2) < 2", {}, mode: :strict)
      expect(result).to be_deferred
      expect(result.value).to be_nil
      expect(result.boundaries.first).to include(operation: "sqrt", action: :deferred)
      expect(result.unevaluated).not_to be_empty
    end

    it "compares guard-digit operands as exact decimals" do
      result = run("sqrt(2) < 3/2", {}, mode: :strict, guard_digits: 20)
      expect(result.value).to be(true)
      expect(result).not_to be_exact
    end
  end

  context "with connectives" do
    {
      "(1 < 2) ^^ (2 < 3)" => true, "(1 < 2) ^^ (3 < 2)" => false,
      "(3 < 2) vv (2 < 3)" => true, "(3 < 2) vv (3 < 2)" => false,
      "not (1 < 2)" => false, "not (2 < 1)" => true,
      "(1 < 2) => (2 < 1)" => false, "(2 < 1) => (1 < 2)" => true
    }.each do |text, verdict|
      it "evaluates `#{text}` to #{verdict}" do
        result = run(text)
        expect(result.value).to be(verdict)
        expect(result).to be_exact
      end
    end

    it "binds and tighter than or, and not tighter than and" do
      expect(run("1 < 2 vv 2 < 1 ^^ 2 < 1").value).to be(true)
      expect(run("not 1 < 2 vv 2 < 3").value).to be(true)
    end

    it "evaluates xor" do
      xor = Plurimath::Math::Symbols::Veebar.new
      numbers = ->(a, b) { [Plurimath::Math::Number.new(a.to_s), Plurimath::Math::Symbols::Less.new, Plurimath::Math::Number.new(b.to_s)] }
      formula = lambda do |left, right|
        described_class.new([*numbers.call(*left), xor, *numbers.call(*right)])
      end
      expect(formula.call([1, 2], [3, 2]).evaluate.value).to be(true)
      expect(formula.call([1, 2], [2, 3]).evaluate.value).to be(false)
    end
  end

  context "when refusing" do
    it "refuses relation1/approx: no Plurimath tolerance is defined" do
      formula = described_class.new(
        [Plurimath::Math::Number.new("2"), Plurimath::Math::Symbols::Approx.new,
         Plurimath::Math::Number.new("2")],
      )
      expect { formula.evaluate }.to raise_error(error, /relation1\/approx/)
      expect { formula.evaluate({}, mode: :strict) }.to raise_error(error, /relation1\/approx/)
    end

    ["(1 < 2) + 1", "1 < 2 < 3", "(1 < 2) < 3", "2 ^^ (1 < 2)", "(1 < 2) ^^ 3",
     "not 2", "sin(1 < 2)", "-(1 < 2)", "(1 < 2) * 3"].each do |text|
      it "refuses mixed boolean/numeric operands in `#{text}`" do
        expect { run(text) }.to raise_error(error, /boolean|logical/)
      end
    end
  end
end
