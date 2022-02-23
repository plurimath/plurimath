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
    text = StringScanner.new("sin(cos{theta})")
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
    expect(cos_value[0].value).to eql("{")
    expect(cos_value[1].value).to eql("theta")
    expect(cos_value[2].value).to eql("}")
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
    expect(sum_value[0].value).to eql("(")
    expect(sum_value[1].value).to eql("theta")
    expect(sum_value[2].value).to eql(")")
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
    expect(sum_value[0].value).to eql("(")
    expect(sum_value[1].value).to eql("theta")
    expect(sum_value[2].value).to eql(")")
    # sum formula exponent value
    expect(sin_value[1].exponent.value).to eql("3")
  end

  it "returns instance of Formula against the string" do
    text = StringScanner.new("sin(sum_(theta)^sin(theta))")
    asciimath = Plurimath::Asciimath::Parser.new(text).parse

    sin = asciimath.value.first
    sin_value = sin.angle.value
    sum_value = sin_value[1].base.value
    expo_sin_value = sin_value[1].exponent.angle.value

    # sin formula object
    expect(sin.class).to eql(Plurimath::Math::Function::Sin)
    expect(sin_value[0].value).to eq("(")
    expect(sin_value[1].class).to eql(Plurimath::Math::Function::Sum)
    expect(sin_value[2].value).to eq(")")
    # sin => sum formula object
    expect(sum_value[0].value).to eql("(")
    expect(sum_value[1].value).to eql("theta")
    expect(sum_value[2].value).to eql(")")
    # sin => sum => sin formula object
    expect(expo_sin_value[0].value).to eql("(")
    expect(expo_sin_value[1].value).to eql("theta")
    expect(expo_sin_value[2].value).to eql(")")
  end

  it "returns instance of Formula against the string" do
    text = StringScanner.new("sin(sum_(theta)^sin(cong)) = {1+1}")
    asciimath = Plurimath::Asciimath::Parser.new(text).parse

    sin = asciimath.value.first
    sin_value = sin.angle.value
    sum_value = sin_value[1].base.value
    expo_sin_value = sin_value[1].exponent.angle.value

    # sin formula object
    expect(sin.class).to eql(Plurimath::Math::Function::Sin)
    expect(sin_value[0].value).to eq("(")
    expect(sin_value[1].class).to eql(Plurimath::Math::Function::Sum)
    expect(sin_value[2].value).to eq(")")
    # sum formula object
    expect(sum_value[0].value).to eql("(")
    expect(sum_value[1].value).to eql("theta")
    expect(sum_value[2].value).to eql(")")
    expect(expo_sin_value[0].value).to eql("(")
    expect(expo_sin_value[1].value).to eql("cong")
    expect(expo_sin_value[2].value).to eql(")")
    # right part of the formula
    expect(asciimath.value[1].value).to eql("=")
    expect(asciimath.value[2].value).to eql("{")
    expect(asciimath.value[3].value).to eql("1")
    expect(asciimath.value[4].value).to eql("+")
    expect(asciimath.value[5].value).to eql("1")
    expect(asciimath.value[6].value).to eql("}")
  end

  it "returns instance of Formula against the string" do
    text = StringScanner.new("sum_(i=1)^n i^3=sin((n(n+1))/2)^2")
    asciimath = Plurimath::Asciimath::Parser.new(text).parse

    sum = asciimath.value.first
    sum_value = sum.base.value
    sin_value = asciimath.value[5].angle.value

    # sum formula object
    expect(sum.class).to eql(Plurimath::Math::Function::Sum)
    expect(sum_value[0].value).to eq("(")
    expect(sum_value[1].value).to eq("i")
    expect(sum_value[2].value).to eq("=")
    expect(sum_value[3].value).to eq("1")
    expect(sum_value[4].value).to eq(")")
    expect(sum.exponent.value).to eq("n")
    expect(asciimath.value[1].value).to eq("i")
    expect(asciimath.value[2].value).to eq("^")
    expect(asciimath.value[3].value).to eq("3")
    expect(asciimath.value[4].value).to eq("=")
    expect(asciimath.value[5].class).to eql(Plurimath::Math::Function::Sin)
    # sin formula object
    expect(sin_value[0].value).to eq("(")
    expect(sin_value[1].value).to eq("(")
    expect(sin_value[2].value).to eq("n")
    expect(sin_value[3].value).to eq("(")
    expect(sin_value[4].value).to eq("n")
    expect(sin_value[5].value).to eq("+")
    expect(sin_value[6].value).to eq("1")
    expect(sin_value[7].value).to eq(")")
    expect(sin_value[8].value).to eq(")")
    expect(sin_value[9].value).to eq("/")
    expect(sin_value[10].value).to eq("2")
    expect(sin_value[11].value).to eq(")")
    expect(asciimath.value[6].value).to eq("^")
    expect(asciimath.value[7].value).to eq("2")
  end

  it "initializes Plurimath::Asciimath object" do
    asciimath = Plurimath::Asciimath.new("cos(2)")
    expect(asciimath.text).to eql("cos(2)")
  end
end
