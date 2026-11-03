# frozen_string_literal: true

require "spec_helper"

RSpec.describe "accuracy-aware evaluation" do # rubocop:disable RSpec/DescribeClass
  def result(source, bindings = {}, **options)
    Plurimath::Math.parse(source, :asciimath).evaluate(bindings, **options)
  end

  def value(source, bindings = {}, **options)
    result(source, bindings, **options).value
  end

  it "returns a Result whose value is exact when no boundary is crossed" do
    outcome = result("sqrt(4) + 2^-2")

    expect(outcome.value).to eq(Rational(9, 4))
    expect(outcome).to be_exact
    expect(outcome.boundaries).to be_empty
    expect(outcome).not_to be_deferred
  end

  it "keeps rational division exact in strict mode" do
    expect(value("1/3", mode: :strict)).to eq(Rational(1, 3))
  end

  it "records the float crossing in approximate mode" do
    outcome = result("1/3")

    expect(outcome.value).to eq(1.0 / 3.0)
    expect(outcome).not_to be_exact
    expect(outcome.boundaries).to contain_exactly(
      hash_including(operation: "divide", action: :approximated),
    )
  end

  it "treats exact powers as exact in both modes" do
    expect(value("2^-2", mode: :strict)).to eq(Rational(1, 4))
    expect(result("2^-2").boundaries).to be_empty
  end

  it "makes decimal literals exact rationals in strict mode" do
    expect(value("0.1 + 0.2", mode: :strict)).to eq(Rational(3, 10))
    expect(result("0.1 + 0.2", mode: :strict)).to be_exact
  end

  it "reports decimal literals as crossings in approximate mode" do
    outcome = result("0.1 + 0.2")

    expect(outcome.boundaries.count { |b| b[:operation] == "number literal" }).to eq(2)
    expect(outcome.value).to eq(0.30000000000000004)
  end

  it "defers a transcendental on exact operands in strict mode" do
    outcome = result("sin(0)", mode: :strict)

    expect(outcome).to be_deferred
    expect(outcome.value).to be_nil
    expect(outcome.unevaluated).to eq(["sin(0)"])
    expect(outcome.boundaries).to contain_exactly(
      hash_including(operation: "sin", action: :deferred, result: nil),
    )
  end

  it "computes guard digits in strict mode when declared" do
    outcome = result("sin(0)", mode: :strict, guard_digits: 10)

    expect(outcome.value).to be_a(BigDecimal)
    expect(outcome.value.to_s).to start_with("0.0")
    expect(outcome.boundaries).to contain_exactly(
      hash_including(operation: "sin", action: :guarded),
    )
  end

  it "computes exp guard digits to the declared precision" do
    outcome = result("exp(1)", mode: :strict, guard_digits: 12)

    expect(outcome.value.to_s("F")[0, 12]).to eq(BigMath::E(12).to_s("F")[0, 12])
    expect(outcome.boundaries).to contain_exactly(
      hash_including(operation: "exp", action: :guarded),
    )
  end

  it "refuses guard digits for unsupported functions" do
    expect { result("tan(1)", mode: :strict, guard_digits: 10) }
      .to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError,
                      /no guard-digit implementation for `tan`/)
  end

  it "defers irrational roots in strict mode and keeps them approximate otherwise" do
    expect(result("2^0.5", mode: :strict)).to be_deferred
    expect(value("2^0.5")).to eq(Math.sqrt(2))
  end

  it "keeps rational square roots exact in strict mode" do
    outcome = result("sqrt(9/4)", mode: :strict)

    expect(outcome.value).to eq(Rational(3, 2))
    expect(outcome).to be_exact
  end

  it "reports the approximate path of the same expression" do
    outcome = result("sqrt(9/4)")

    expect(outcome.value).to eq(1.5)
    expect(outcome.boundaries.map { |b| b[:operation] })
      .to eq(["divide", "sqrt"])
  end

  it "lets limited operands degrade in strict mode without deferring" do
    outcome = result("sin(x)", { x: 1.5 }, mode: :strict)

    expect(outcome.value).to be_a(Float)
    expect(outcome).not_to be_deferred
    expect(outcome.boundaries).to contain_exactly(
      hash_including(operation: "sin", action: :approximated),
    )
  end

  it "reads exact decimal string bindings as rationals in strict mode" do
    expect(value("x * 2", { x: "0.5" }, mode: :strict)).to eq(Rational(1))
  end

  it "still refuses non-decimal string bindings" do
    expect { result("x", { x: "abc" }) }
      .to raise_error(Plurimath::Errors::Evaluation::InvalidBindingError)
  end

  it "raises a typed error for an unknown mode" do
    expect { result("1", mode: :turbo) }
      .to raise_error(ArgumentError, /mode must be one of/)
  end

  it "raises a typed error for non-positive guard digits" do
    expect { result("sin(1)", mode: :strict, guard_digits: 0) }
      .to raise_error(ArgumentError, /guard_digits must be a positive Integer/)
  end

  it "defers ln(0) in strict mode before the domain error can occur" do
    expect(result("ln(0)", mode: :strict)).to be_deferred
  end

  it "keeps the typed error contract where evaluation proceeds" do
    expect { value("ln(0)") }
      .to raise_error(Plurimath::Errors::Evaluation::NonFiniteResultError)
    expect { value("1/0", mode: :strict) }
      .to raise_error(Plurimath::Errors::Evaluation::DivisionByZeroError)
    expect { value("1/0") }
      .to raise_error(Plurimath::Errors::Evaluation::DivisionByZeroError)
  end

  it "absorbs keyword shorthand bindings while accepting mode options" do
    expect(value("a+b", a: 2, b: 3)).to eq(5)
    expect(value("x * 2", { x: "0.5" }, mode: :strict)).to eq(Rational(1))
  end
end
