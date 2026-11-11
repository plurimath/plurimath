require "spec_helper"
require "unitsml"

RSpec.describe "quantity-aware evaluation" do
  def quantity(value, unit)
    Unitsml::Quantity.new(value: value, unit: unit)
  end

  def result(source, bindings)
    Plurimath::Math.parse(source, :asciimath).evaluate_quantity(bindings)
  end

  it "normalizes unlike units before delegating addition" do
    outcome = result("x+y", x: quantity(1, "m"), y: quantity(50, "cm"))
    expect(outcome.value.value).to eq(3r / 2)
    expect(outcome.value.norm_text).to eq("m")
    expect(outcome).to be_exact
  end

  it "composes voltage and current and delegates conversion to watts" do
    outcome = result("v*i", v: quantity(2, "kV"), i: quantity(3, "A"))
    converted = outcome.value.convert_to("kW")
    expect(converted.value).to eq(6)
  end

  it "preserves rational magnitude division and powers" do
    outcome = result("x/3", x: quantity(1, "m"))
    expect(outcome.value.value).to eq(1r / 3)
    squared = result("x^2", x: quantity(2, "m"))
    expect(squared.value.value).to eq(4)
    expect(squared.value.dimension_vector.values).to include(2)
  end

  it "preserves native dimension and absolute interval scale refusals" do
    expect { result("x+y", x: quantity(1, "m"), y: quantity(1, "s")) }.to raise_error(Unitsml::Errors::DimensionMismatchError)
    expect { result("x*y", x: quantity(20, "degC"), y: quantity(2, "m")) }.to raise_error(Unitsml::Errors::ScaleOperationError)
  end

  it "refuses unsupported function semantics explicitly" do
    expect { result("sin(x)", x: quantity(1, "m")) }.to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError)
  end
  it "retains limited source accuracy when conversion rationalizes a magnitude" do
    outcome = result("x+y", x: quantity(1, "m"), y: quantity(50.0, "cm"))
    expect(outcome.value.value).to eq(3r / 2)
    expect(outcome.accuracy).to eq(:limited_float)
    expect(outcome).not_to be_exact
  end

  it "reports unavailable quantity support without breaking older numeric hosts" do
    allow(Unitsml).to receive(:const_defined?).with(:Quantity).and_return(false)
    expect { result("1+2", {}) }.to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError, /requires UnitsML Quantity/)
    expect(Plurimath::Math.parse("1+2", :asciimath).evaluate.value).to eq(3)
  end

end
