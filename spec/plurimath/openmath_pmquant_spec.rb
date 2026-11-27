# frozen_string_literal: true

require "spec_helper"

# plurimath#583: the pmquant content dictionary binds the PM 1002 quantity
# constructors through the openmath gem's binding table.
RSpec.describe Plurimath::Openmath::Evaluation do
  def parse(body, version: 2)
    Plurimath::Math.parse(%(<OMOBJ xmlns="http://www.openmath.org/OpenMath">#{body}</OMOBJ>),
                          :openmath, version: version)
  end

  def app(name, *args)
    %(<OMA><OMS cd="pmquant" name="#{name}"/>#{args.join}</OMA>)
  end

  def num(text)
    %(<OMF dec="#{text}"/>)
  end

  [2, 3].each do |version|
    context "OpenMath #{version}" do
      it "evaluates ustd to a standard-uncertainty quantity" do
        result = parse(app("ustd", num("10.3"), num("0.2")), version: version).evaluate
        expect(result.value).to eq(10.3)
        expect(result.quantity.category).to eq(:standard)
        expect(result.quantity.magnitude).to eq(0.2)
      end

      it "evaluates uexp with coverage factor and probability" do
        result = parse(app("uexp", num("10.3"), num("0.5"), "<OMI>2</OMI>", num("0.95")),
                       version: version).evaluate
        expect(result.quantity.category).to eq(:expanded)
        expect(result.quantity.coverage_factor).to eq(2)
        expect(result.quantity.coverage_probability).to eq(0.95)
      end

      it "evaluates ucov with endpoints and interval kind" do
        result = parse(app("ucov", num("10.3"), num("9.9"), num("10.7"), num("0.95"),
                           "<OMSTR>shortest</OMSTR>"), version: version).evaluate
        expect(result.quantity.category).to eq(:coverage)
        expect([result.quantity.lower, result.quantity.upper]).to eq([9.9, 10.7])
        expect(result.quantity.interval_kind).to eq("shortest")
      end

      it "extracts the reported value with value(q)" do
        inner = app("ustd", "<OMI>10</OMI>", "<OMI>1</OMI>")
        result = parse(app("value", inner), version: version).evaluate
        expect(result.value).to eq(10)
        expect(result.quantity).to be_nil
        expect(result).to be_exact
      end

      it "keeps exact operands exact inside the quantity" do
        result = parse(app("ustd", "<OMI>10</OMI>", "<OMI>1</OMI>"), version: version).evaluate
        expect(result.quantity.value).to be_a(Integer)
        expect(result.quantity.magnitude).to be_a(Integer)
      end

      it "binds variables from the evaluation bindings" do
        formula = parse(app("ustd", %(<OMV name="x"/>), num("0.2")), version: version)
        expect(formula.evaluate({ "x" => 5 }).quantity.value).to eq(5)
        expect(formula.evaluate(x: 6).value).to eq(6)
      end

      it "refuses a missing variable with the typed error" do
        formula = parse(app("ustd", %(<OMV name="x"/>), num("0.2")), version: version)
        expect { formula.evaluate }
          .to raise_error(Plurimath::Errors::Evaluation::MissingVariableError, /`x`/)
      end

      it "refuses a negative standard magnitude" do
        formula = parse(app("ustd", num("1"), num("-0.2")), version: version)
        expect { formula.evaluate }
          .to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError, /magnitude/)
      end

      it "refuses a non-positive coverage factor" do
        formula = parse(app("uexp", num("1"), num("0.5"), "<OMI>0</OMI>"), version: version)
        expect { formula.evaluate }
          .to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError, /coverage factor/)
      end

      it "refuses a coverage probability outside (0, 1)" do
        formula = parse(app("uexp", num("1"), num("0.5"), "<OMI>2</OMI>", num("1")),
                        version: version)
        expect { formula.evaluate }
          .to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError)
      end

      it "refuses an inverted coverage interval" do
        formula = parse(app("ucov", num("1"), num("2"), num("1")), version: version)
        expect { formula.evaluate }
          .to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError, /interval/)
      end

      it "refuses an unknown interval kind" do
        formula = parse(app("ucov", num("1"), num("0"), num("2"), num("0.9"),
                            "<OMSTR>widest</OMSTR>"), version: version)
        expect { formula.evaluate }
          .to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError, /interval kind/)
      end

      it "refuses an unbound pmquant symbol at parse, naming the symbol" do
        expect { parse(app("nosuch", num("1")), version: version) }
          .to raise_error(Plurimath::Openmath::UnsupportedError, /pmquant\/nosuch/)
      end

      it "accepts the pmquant CD base" do
        body = %(<OMA><OMS cdbase="http://www.plurimath.org/cd" cd="pmquant" name="ustd"/>#{num('1')}#{num('0.2')}</OMA>)
        expect(parse(body, version: version).evaluate.quantity.category).to eq(:standard)
      end

      it "refuses presentation of a pmquant application like any unbound symbol" do
        formula = parse(app("ustd", num("1"), num("0.2")), version: version)
        expect { formula.to_asciimath }.to raise_error(Plurimath::Openmath::UnsupportedError)
      end

      it "still round-trips the retained source" do
        formula = parse(app("ustd", num("1"), num("0.2")), version: version)
        expect(formula.to_openmath(version: version)).to include("pmquant")
      end
    end
  end

  it "leaves ordinary OpenMath evaluation on the scalar evaluator" do
    formula = parse(%(<OMA><OMS cd="arith1" name="plus"/><OMI>1</OMI><OMI>2</OMI></OMA>))
    result = formula.evaluate
    expect(result.value).to eq(3)
    expect(result.quantity).to be_nil
  end
end
