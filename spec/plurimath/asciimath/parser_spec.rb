require_relative "../../../lib/plurimath/math"
require "strscan"

RSpec.describe Plurimath::Asciimath::Parser do

  it "returns instance of Cos formula against the string" do
    asciimath = init_spec_resp("cos(2)")
    # initializing common used values in respective named variables
    cos = asciimath.value.first
    cos_value = cos.angle.value
    # cos formula
    expect(cos.class).to eql(Plurimath::Math::Function::Cos)
    expect(cos_value[0].value).to eq("(")
    expect(cos_value[1].value).to eq("2")
    expect(cos_value[2].value).to eq(")")
  end

  it "returns instance of Sum formula against the string" do
    asciimath = init_spec_resp("sum(2)")
    # initializing common used values in respective named variables
    sum = asciimath.value.first
    sum_value = sum.content.value
    # sum formula
    expect(sum.class).to eql(Plurimath::Math::Function::Sum)
    expect(sum_value[0].value).to eq("(")
    expect(sum_value[1].value).to eq("2")
    expect(sum_value[2].value).to eq(")")
  end

  it "returns instance of Sin Formula against the string" do
    asciimath = init_spec_resp("sin(cos{theta})")
    # initializing common used values in respective named variables
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

  it "returns instance of Sin Formula against the string" do
    asciimath = init_spec_resp("sin(sum_(theta))")
    # initializing common used values in respective named variables
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

  it "returns instance of Sin Formula against the string" do
    asciimath = init_spec_resp("sin(sum_(theta)^3)")
    # initializing common used values in respective named variables
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
    expect(sin_value[1].exponent.value[0].value).to eql("3")
  end

  it "returns instance of Sin Formula against the string" do
    asciimath = init_spec_resp("sin(sum_(theta)^sin(theta))")
    # initializing common used values in respective named variables
    sin = asciimath.value.first
    sin_value = sin.angle.value
    sum_value = sin_value[1].base.value
    expo_sin_value = sin_value[1].exponent.value[0].angle.value
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

  it "returns instance of Sin Formula against the string" do
    asciimath = init_spec_resp("sin(sum_(theta)^sin(cong)) = {1+1}")
    # initializing common used values in respective named variables
    sin = asciimath.value.first
    sin_value = sin.angle.value
    sum_value = sin_value[1].base.value
    expo_sin_value = sin_value[1].exponent.value[0].angle.value
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

  it "returns instance of Sum Formula against the string" do
    asciimath = init_spec_resp("sum_(i=1)^n i^3=sin((n(n+1))/2)^2")
    # initializing common used values in respective named variables
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
    expect(sum.exponent.value[0].value).to eq("n")
    expect(asciimath.value[1].value).to eq("i")
    expect(asciimath.value[2].value).to eq("^")
    expect(asciimath.value[3].value).to eq("3")
    expect(asciimath.value[4].value).to eq("=")
    # sin formula object
    expect(asciimath.value[5].class).to eql(Plurimath::Math::Function::Sin)
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

  it "returns instance of Frac Formula against the string" do
    asciimath = init_spec_resp("sum_(i=frac{1}{3})^33")
    # initializing common used values in respective named variables
    sum = asciimath.value.first
    sum_value = sum.base.value
    dividend_value = sum_value[3].dividend.value
    divisor_value = sum_value[3].divisor.value
    # sum formula object
    expect(sum.class).to eql(Plurimath::Math::Function::Sum)
    expect(sum_value[0].value).to eq("(")
    expect(sum_value[1].value).to eq("i")
    expect(sum_value[2].value).to eq("=")
    # frac formula
    expect(sum_value[3].class).to eq(Plurimath::Math::Function::Frac)
    expect(dividend_value[0].value).to eq("{")
    expect(dividend_value[1].value).to eq("1")
    expect(dividend_value[2].value).to eq("}")
    expect(divisor_value[0].value).to eq("{")
    expect(divisor_value[1].value).to eq("3")
    expect(divisor_value[2].value).to eq("}")
    expect(sum.exponent.value[0].value).to eq("33")
  end

  it "returns instance of Frac Formula against the string" do
    asciimath = init_spec_resp("sum_(i=frac{13})^33")
    # initializing common used values in respective named variables
    sum = asciimath.value.first
    sum_value = sum.base.value
    dividend_value = sum_value[3].dividend.value
    # sum formula object
    expect(sum.class).to eql(Plurimath::Math::Function::Sum)
    expect(sum_value[0].value).to eq("(")
    expect(sum_value[1].value).to eq("i")
    expect(sum_value[2].value).to eq("=")
    # frac formula
    expect(sum_value[3].class).to eq(Plurimath::Math::Function::Frac)
    expect(dividend_value[0].value).to eq("{")
    expect(dividend_value[1].value).to eq("13")
    expect(dividend_value[2].value).to eq("}")
    expect(sum_value[3].divisor).to be_nil
    expect(sum.exponent.value[0].value).to eq("33")
  end

  it "returns instance of Color Formula against the string" do
    asciimath = init_spec_resp("sum_(i=color{1}{3})^33")
    # initializing common used values in respective named variables
    sum = asciimath.value.first
    sum_value = sum.base.value
    color = sum_value[3].color.value
    color_value = sum_value[3].value.value
    # sum formula object
    expect(sum.class).to eql(Plurimath::Math::Function::Sum)
    expect(sum_value[0].value).to eq("(")
    expect(sum_value[1].value).to eq("i")
    expect(sum_value[2].value).to eq("=")
    # color formula
    expect(sum_value[3].class).to eq(Plurimath::Math::Function::Color)
    expect(color[0].value).to eq("{")
    expect(color[1].value).to eq("1")
    expect(color[2].value).to eq("}")
    expect(color_value[0].value).to eq("{")
    expect(color_value[1].value).to eq("3")
    expect(color_value[2].value).to eq("}")
    expect(sum.exponent.value[0].value).to eq("33")
  end

  it "returns instance of Color Formula against the string" do
    asciimath = init_spec_resp('sum_(i=color{"blue"})^33')
    # initializing common used values in respective named variables
    sum = asciimath.value.first
    sum_value = sum.base.value
    color_value = sum_value[3].color.value
    # sum formula object
    expect(sum.class).to eql(Plurimath::Math::Function::Sum)
    expect(sum_value[0].value).to eq("(")
    expect(sum_value[1].value).to eq("i")
    expect(sum_value[2].value).to eq("=")
    # color formula
    expect(sum_value[3].class).to eq(Plurimath::Math::Function::Color)
    expect(color_value[0].value).to eq("{")
    expect(color_value[1].string).to eq("blue")
    expect(color_value[2].value).to eq("}")
    expect(sum_value[3].value).to be_nil
    expect(sum.exponent.value[0].value).to eq("33")
  end

  it "returns instance of Formula against the string without formula" do
    asciimath = init_spec_resp("int_0^1 f(x)dx")
    # initializing common used values in respective named variables
    formula = asciimath.value
    f_value = formula[5].value.value
    # formula object
    expect(formula[0].value).to eq("int")
    expect(formula[1].value).to eq("_")
    expect(formula[2].value).to eq("0")
    expect(formula[3].value).to eq("^")
    expect(formula[4].value).to eq("1")
    expect(formula[6].value).to eq('d')
    expect(formula[7].value).to eq('x')
    # F formula object
    expect(f_value[0].value).to eq("(")
    expect(f_value[1].value).to eq("x")
    expect(f_value[2].value).to eq(")")
  end

  it "returns instance of Obrace Formula against the string" do
    asciimath = init_spec_resp('obrace(1+2+3+4)^("4 terms")')
    # initializing common used values in respective named variables
    obrace_value = asciimath.value[0].value.value
    formula_value = asciimath.value
    # obrace formula object
    expect(asciimath.value[0].class).to eql(Plurimath::Math::Function::Obrace)
    expect(obrace_value[0].value).to eq("(")
    expect(obrace_value[1].value).to eq("1")
    expect(obrace_value[2].value).to eq("+")
    expect(obrace_value[3].value).to eq("2")
    expect(obrace_value[4].value).to eq("+")
    expect(obrace_value[5].value).to eq("3")
    expect(obrace_value[6].value).to eq("+")
    expect(obrace_value[7].value).to eq("4")
    expect(obrace_value[8].value).to eq(")")
    # formula object
    expect(formula_value[1].value).to eq('^')
    expect(formula_value[2].value).to eq('(')
    expect(formula_value[3].string).to eq('4 terms')
    expect(formula_value[4].value).to eq(')')
  end

  it "returns instance of Obrace Formula against the string" do
    asciimath = init_spec_resp('obrace(1+2+3+4)')
    # initializing common used values in respective named variables
    obrace_value = asciimath.value[0].value.value
    formula_value = asciimath.value
    # obrace formula object
    expect(asciimath.value[0].class).to eql(Plurimath::Math::Function::Obrace)
    expect(obrace_value[0].value).to eq("(")
    expect(obrace_value[1].value).to eq("1")
    expect(obrace_value[2].value).to eq("+")
    expect(obrace_value[3].value).to eq("2")
    expect(obrace_value[4].value).to eq("+")
    expect(obrace_value[5].value).to eq("3")
    expect(obrace_value[6].value).to eq("+")
    expect(obrace_value[7].value).to eq("4")
    expect(obrace_value[8].value).to eq(")")
  end

  it "returns instance of Log Formula against the string" do
    asciimath = init_spec_resp('log_(1+2+3+4)^("4 terms")')
    # initializing common used values in respective named variables
    log_base_value = asciimath.value[0].base.value
    log_exponent_value = asciimath.value[0].exponent.value
    formula_value = asciimath.value
    # log formula object
    expect(asciimath.value[0].class).to eql(Plurimath::Math::Function::Log)
    # log base value
    expect(log_base_value[0].value).to eq("(")
    expect(log_base_value[1].value).to eq("1")
    expect(log_base_value[2].value).to eq("+")
    expect(log_base_value[3].value).to eq("2")
    expect(log_base_value[4].value).to eq("+")
    expect(log_base_value[5].value).to eq("3")
    expect(log_base_value[6].value).to eq("+")
    expect(log_base_value[7].value).to eq("4")
    expect(log_base_value[8].value).to eq(")")
    # log exponent value
    expect(log_exponent_value[0].value).to eq("(")
    expect(log_exponent_value[1].string).to eq("4 terms")
    expect(log_exponent_value[2].value).to eq(")")
  end

  it "returns instance of Log Formula against the string" do
    asciimath = init_spec_resp('log_(1+2+3+4)')
    # initializing common used values in respective named variables
    log_base_value = asciimath.value[0].base.value
    formula_value = asciimath.value
    # log formula object
    expect(asciimath.value[0].class).to eql(Plurimath::Math::Function::Log)
    # log base value
    expect(log_base_value[0].value).to eq("(")
    expect(log_base_value[1].value).to eq("1")
    expect(log_base_value[2].value).to eq("+")
    expect(log_base_value[3].value).to eq("2")
    expect(log_base_value[4].value).to eq("+")
    expect(log_base_value[5].value).to eq("3")
    expect(log_base_value[6].value).to eq("+")
    expect(log_base_value[7].value).to eq("4")
    expect(log_base_value[8].value).to eq(")")
    # log exponent value
    expect(asciimath.value[0].exponent).to be_nil
  end

  it "returns instance of Root Formula against the string" do
    asciimath = init_spec_resp('root1234(i)')
    # initializing common used values in respective named variables
    root_index_value = asciimath.value[0].index.value
    root_number_value = asciimath.value[0].number.value
    formula_value = asciimath.value
    # root formula object
    expect(asciimath.value[0].class).to eql(Plurimath::Math::Function::Root)
    # root index value
    expect(root_index_value[0].value).to eq("1234")
    # root number value
    expect(root_number_value[0].value).to eq("(")
    expect(root_number_value[1].value).to eq("i")
    expect(root_number_value[2].value).to eq(")")
  end

  it "returns instance of Root Formula against the string" do
    asciimath = init_spec_resp('root(1234)(i)')
    # initializing common used values in respective named variables
    root_index_value = asciimath.value[0].index.value
    root_number_value = asciimath.value[0].number.value
    formula_value = asciimath.value
    # root formula object
    expect(asciimath.value[0].class).to eql(Plurimath::Math::Function::Root)
    # root index value
    expect(root_index_value[0].value).to eq("(")
    expect(root_index_value[1].value).to eq("1234")
    expect(root_index_value[2].value).to eq(")")
    # root number value
    expect(root_number_value[0].value).to eq("(")
    expect(root_number_value[1].value).to eq("i")
    expect(root_number_value[2].value).to eq(")")
  end

  it "returns instance of Overset Formula against the string" do
    asciimath = init_spec_resp('overset(1234)(i)')
    # initializing common used values in respective named variables
    overset_index_value = asciimath.value[0].value.value
    overset_number_value = asciimath.value[0].symbol.value
    formula_value = asciimath.value
    # overset formula object
    expect(asciimath.value[0].class).to eql(Plurimath::Math::Function::Overset)
    # overset index value
    expect(overset_index_value[0].value).to eq("(")
    expect(overset_index_value[1].value).to eq("1234")
    expect(overset_index_value[2].value).to eq(")")
    # overset symbol value
    expect(overset_number_value[0].value).to eq("(")
    expect(overset_number_value[1].value).to eq("i")
    expect(overset_number_value[2].value).to eq(")")
  end

  it "returns instance of Overset Formula against the string" do
    asciimath = init_spec_resp('overset1234(i)')
    # initializing common used values in respective named variables
    overset_number_value = asciimath.value[0].symbol.value
    formula_value = asciimath.value
    # overset formula object
    expect(asciimath.value[0].class).to eql(Plurimath::Math::Function::Overset)
    # overset index value
    expect(asciimath.value[0].value.value[0].value).to eq("1234")
    # overset symbol value
    expect(overset_number_value[0].value).to eq("(")
    expect(overset_number_value[1].value).to eq("i")
    expect(overset_number_value[2].value).to eq(")")
  end

  it "returns instance of Underset Formula against the string" do
    asciimath = init_spec_resp('underset(1234)(i)')
    # initializing common used values in respective named variables
    overset_index_value = asciimath.value[0].value.value
    overset_number_value = asciimath.value[0].symbol.value
    formula_value = asciimath.value
    # underset formula object
    expect(asciimath.value[0].class).to eql(Plurimath::Math::Function::Underset)
    # underset index value
    expect(overset_index_value[0].value).to eq("(")
    expect(overset_index_value[1].value).to eq("1234")
    expect(overset_index_value[2].value).to eq(")")
    # underset symbol value
    expect(overset_number_value[0].value).to eq("(")
    expect(overset_number_value[1].value).to eq("i")
    expect(overset_number_value[2].value).to eq(")")
  end

  it "returns instance of Underset Formula against the string" do
    asciimath = init_spec_resp('underset1234(i)')
    # initializing common used values in respective named variables
    overset_number_value = asciimath.value[0].symbol.value
    formula_value = asciimath.value
    # underset formula object
    expect(asciimath.value[0].class).to eql(Plurimath::Math::Function::Underset)
    # underset index value
    expect(asciimath.value[0].value.value[0].value).to eq("1234")
    # underset symbol value
    expect(overset_number_value[0].value).to eq("(")
    expect(overset_number_value[1].value).to eq("i")
    expect(overset_number_value[2].value).to eq(")")
  end

  it "returns instance of Mod Formula against the string" do
    asciimath = init_spec_resp('12mod1234(i)')
    # initializing common used values in respective named variables
    formula_object = asciimath.value
    # mod formula object
    expect(formula_object[0].class).to eql(Plurimath::Math::Function::Mod)
    # mod object value
    expect(formula_object[0].dividend.value).to eq("12")
    expect(formula_object[0].divisor.value[0].value).to eq("1234")
    # formula values
    expect(formula_object[1].value).to eq("(")
    expect(formula_object[2].value).to eq("i")
    expect(formula_object[3].value).to eq(")")
  end

  it "returns instance of Mod Formula against the string" do
    asciimath = init_spec_resp('12mod(1234)(i)')
    # initializing common used values in respective named variables
    formula_object = asciimath.value
    divisor_value = formula_object[0].divisor.value
    # mod formula object
    expect(formula_object[0].class).to eql(Plurimath::Math::Function::Mod)
    # mod dividend value
    expect(formula_object[0].dividend.value).to eq("12")
    # mod divisor value
    expect(divisor_value[0].value).to eq("(")
    expect(divisor_value[1].value).to eq("1234")
    expect(divisor_value[2].value).to eq(")")
    # formula object values
    expect(formula_object[1].value).to eq("(")
    expect(formula_object[2].value).to eq("i")
    expect(formula_object[3].value).to eq(")")
  end

  it "initializes Plurimath::Asciimath Cos object" do
    asciimath = Plurimath::Asciimath.new("cos(2)")
    expect(asciimath.text).to eql("cos(2)")
  end
end

# initializing string for parsing and calling asciimath's parser method
def init_spec_resp(equation)
  text = StringScanner.new(equation)
  Plurimath::Asciimath::Parser.new(text).parse
end
