require_relative "../../../lib/plurimath/math"
require "byebug"
require "strscan"

RSpec.describe Plurimath::Asciimath::Parser do

  it "returns instance of Formula against the string" do
    text = StringScanner.new("cos(2)")
    asciimath = Plurimath::Asciimath::Parser.new(text).parse
    expect(asciimath.value.first.class).to eql(Plurimath::Math::Function::Cos)
    expect(asciimath.value.first.angle.value[0].value).to eq("(")
    expect(asciimath.value.first.angle.value[1].value).to eq("2")
    expect(asciimath.value.first.angle.value[2].value).to eq(")")
  end

  it "returns instance of Formula against the string" do
    text = StringScanner.new("sin(cos(theta))")
    asciimath = Plurimath::Asciimath::Parser.new(text).parse

    sin = asciimath.value.first
    sin_value = sin.angle.value
    cos_value = sin_value[1].angle.value
    # sin formula
    expect(sin.class).to eql(Plurimath::Math::Function::Sin)
    expect(sin_value[0].value).to eq("(")
    expect(sin_value[1].class).to eql(Plurimath::Math::Function::Cos)
    expect(sin_value[2].value).to eq(")")
    # cos fomula object
    expect(cos_value[0].value).to eql("(")
    expect(cos_value[1].value).to eql("theta")
    expect(cos_value[2].value).to eql(")")
  end

  it "returns instance of Formula against the string" do
    text = StringScanner.new("sin(sum_(theta))")
    asciimath = Plurimath::Asciimath::Parser.new(text).parse

    sin = asciimath.value.first
    sin_value = sin.angle.value
    sum_value = sin_value[1].base.value
    # sin formula object
    expect(sin.class).to eql(Plurimath::Math::Function::Sin)
    expect(sin_value[0].value).to eq("(")
    expect(sin_value[1].class).to eql(Plurimath::Math::Function::Sum)
    expect(sin_value[2].value).to eq(")")
    # sum formula object
    expect(sum_value[0].value).to eql("_")
    expect(sum_value[1].value).to eql("(")
    expect(sum_value[2].value).to eql("theta")
    expect(sum_value[3].value).to eql(")")
  end

  it "returns instance of Formula against the string" do
    text = StringScanner.new("sin(sum_(theta)^3)")
    asciimath = Plurimath::Asciimath::Parser.new(text).parse

    sin = asciimath.value.first
    sin_value = sin.angle.value
    sum_value = sin_value[1].base.value
    # sin formula object
    expect(sin.class).to eql(Plurimath::Math::Function::Sin)
    expect(sin_value[0].value).to eq("(")
    expect(sin_value[1].class).to eql(Plurimath::Math::Function::Sum)
    expect(sin_value[2].value).to eq(")")
    # sum formula object
    expect(sum_value[0].value).to eql("_")
    expect(sum_value[1].value).to eql("(")
    expect(sum_value[2].value).to eql("theta")
    expect(sum_value[3].value).to eql(")")
    expect(sin_value[1].exponent.value).to eql("^")
    expect(sin_value[1].exponent.value).to eql("^")
  end

  it "initializes Plurimath::Asciimath object" do
    asciimath = Plurimath::Asciimath.new("cos(2)")
    expect(asciimath.text).to eql("cos(2)")
  end
end
