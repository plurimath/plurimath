# frozen_string_literal: true

require "spec_helper"

# plurimath#583: numeric-only content-dictionary symbols (arith1 root, sum
# and product; nums1 based_integer; integer1 quotient and remainder) convert
# to Formula nodes the existing numeric evaluator computes, so the common
# accuracy modes, strict mode and typed errors apply unchanged.
RSpec.describe Plurimath::Openmath, engine_loop: :always do
  def openmath(body, version: 2)
    Plurimath::Math.parse(%(<OMOBJ xmlns="http://www.openmath.org/OpenMath">#{body}</OMOBJ>),
                          :openmath, version: version)
  end

  def oma(dict, name, *args)
    %(<OMA><OMS cd="#{dict}" name="#{name}"/>#{args.join}</OMA>)
  end

  def interval(low, high)
    oma("interval1", "interval", "<OMI>#{low}</OMI>", "<OMI>#{high}</OMI>")
  end

  def lambda_over(variable, body)
    %(<OMBIND><OMS cd="fns1" name="lambda"/><OMBVAR><OMV name="#{variable}"/></OMBVAR>#{body}</OMBIND>)
  end

  let(:based_integers) do
    { [16, "ff"] => 255, [2, "1011"] => 11, [36, "z"] => 35, [10, "-42"] => -42, [8, "17"] => 15 }
  end
  let(:floored_divisions) do
    {
      ["quotient", 7, 2] => 3, ["quotient", -7, 2] => -4, ["quotient", 7, -2] => -4,
      ["remainder", 7, 2] => 1, ["remainder", -7, 2] => 1, ["remainder", 7, -2] => -1
    }
  end
  let(:identity_operands) { [[17, 5], [-17, 5], [17, -5], [0, 3]] }
  let(:divisions) { %w[quotient remainder] }

  [2, 3].each do |version|
    context "OpenMath version #{version}" do
      it "evaluates arith1/root as the n-th root of the first argument" do
        formula = openmath(oma("arith1", "root", "<OMI>8</OMI>", "<OMI>3</OMI>"), version: version)
        expect(formula.evaluate.value).to be_within(1e-12).of(2)
        expect(formula.to_asciimath).to eq("root(3)(8)")
        square = openmath(oma("arith1", "root", "<OMI>2</OMI>", "<OMI>2</OMI>"), version: version)
        expect(square.evaluate.value).to be_within(1e-12).of(Math.sqrt(2))
      end

      it "evaluates arith1/sum and arith1/product over a closed integer interval" do
        squares = lambda_over("i", oma("arith1", "times", '<OMV name="i"/>', '<OMV name="i"/>'))
        sum = openmath(oma("arith1", "sum", interval(1, 4), squares), version: version)
        expect(sum.evaluate.value).to eq(30)
        expect(sum.evaluate(mode: :strict).value).to eq(30)
        expect(sum.to_asciimath).to eq("sum_(i = 1)^(4) i * i")

        product = openmath(oma("arith1", "product", interval(1, 4), lambda_over("i", '<OMV name="i"/>')),
                           version: version)
        expect(product.evaluate.value).to eq(24)
      end

      it "binds free variables inside a sum body and its bounds" do
        body = lambda_over("k", oma("arith1", "plus", '<OMV name="k"/>', '<OMV name="x"/>'))
        formula = openmath(oma("arith1", "sum", interval(1, 3), body), version: version)
        expect(formula.evaluate(x: 10).value).to eq(36)
        expect { formula.evaluate }.to raise_error(Plurimath::Errors::Evaluation::MissingVariableError)
      end

      it "decodes nums1/based_integer to the integer value" do
        based_integers.each do |(base, digits), expected|
          formula = openmath(oma("nums1", "based_integer", "<OMI>#{base}</OMI>", "<OMSTR>#{digits}</OMSTR>"),
                             version: version)
          expect(formula.evaluate.value).to eq(expected)
          expect(formula.evaluate(mode: :strict).value).to eq(expected)
        end
      end

      it "evaluates integer1/quotient as the floored quotient and remainder as the floored modulus" do
        floored_divisions.each do |(name, left, right), expected|
          formula = openmath(oma("integer1", name, "<OMI>#{left}</OMI>", "<OMI>#{right}</OMI>"),
                             version: version)
          expect(formula.evaluate.value).to eq(expected)
          expect(formula.evaluate(mode: :strict).value).to eq(expected)
        end
      end

      it "satisfies the quotient/remainder identity for exact operands" do
        identity_operands.each do |left, right|
          quotient = openmath(oma("integer1", "quotient", "<OMI>#{left}</OMI>", "<OMI>#{right}</OMI>"),
                              version: version).evaluate.value
          remainder = openmath(oma("integer1", "remainder", "<OMI>#{left}</OMI>", "<OMI>#{right}</OMI>"),
                               version: version).evaluate.value
          expect((right * quotient) + remainder).to eq(left)
        end
      end

      it "raises the typed division-by-zero error for a zero divisor" do
        divisions.each do |name|
          formula = openmath(oma("integer1", name, "<OMI>7</OMI>", "<OMI>0</OMI>"), version: version)
          expect { formula.evaluate }.to raise_error(Plurimath::Errors::Evaluation::DivisionByZeroError)
        end
      end

      it "applies float literals inside nums1/rounding1 and arithmetic applications" do
        {
          oma("arith1", "plus", '<OMF dec="1.5"/>', "<OMI>1</OMI>") => 2.5,
          oma("arith1", "times", '<OMF dec="0.5"/>', "<OMI>4</OMI>") => 2.0,
          oma("arith1", "divided_by", '<OMF dec="1.5"/>', "<OMI>2</OMI>") => 0.75,
          oma("rounding1", "floor", '<OMF dec="-1.5"/>') => -2,
          oma("rounding1", "ceiling", '<OMF dec="1.5"/>') => 2,
          oma("integer1", "quotient", '<OMF dec="7.5"/>', "<OMI>2</OMI>") => 3,
        }.each do |body, expected|
          expect(openmath(body, version: version).evaluate.value).to eq(expected)
        end
      end

      it "refuses malformed or unsupported forms of the new symbols" do
        squares = lambda_over("i", '<OMV name="i"/>')
        [
          oma("arith1", "root", "<OMI>8</OMI>"),
          oma("integer1", "quotient", "<OMI>8</OMI>"),
          oma("nums1", "based_integer", "<OMI>16</OMI>"),
          oma("nums1", "based_integer", "<OMI>1</OMI>", "<OMSTR>0</OMSTR>"),
          oma("nums1", "based_integer", "<OMI>37</OMI>", "<OMSTR>0</OMSTR>"),
          oma("nums1", "based_integer", "<OMI>2</OMI>", "<OMSTR>102</OMSTR>"),
          oma("nums1", "based_integer", "<OMI>2</OMI>", "<OMI>10</OMI>"),
          oma("nums1", "based_integer", '<OMV name="b"/>', "<OMSTR>10</OMSTR>"),
          oma("arith1", "sum", interval(1, 3)),
          oma("arith1", "sum", oma("set1", "set", "<OMI>1</OMI>"), squares),
          oma("arith1", "sum", oma("interval1", "interval_oo", "<OMI>1</OMI>", "<OMI>3</OMI>"), squares),
          oma("arith1", "product", interval(1, 3), "<OMI>2</OMI>"),
          oma("arith1", "sum", interval(1, 3),
              %(<OMBIND><OMS cd="fns1" name="lambda"/><OMBVAR><OMV name="a"/><OMV name="b"/></OMBVAR><OMV name="a"/></OMBIND>)),
        ].each do |body|
          expect { openmath(body, version: version) }
            .to raise_error(Plurimath::Math::ParseError), "expected a refusal for #{body}"
        end
      end

      it "keeps the original source when an unchanged formula is written back" do
        body = oma("arith1", "root", "<OMI>8</OMI>", "<OMI>3</OMI>")
        formula = openmath(body, version: version)
        expect(Plurimath::Math.parse(formula.to_openmath(version: version), :openmath, version: version)
          .evaluate.value).to be_within(1e-12).of(2)
      end
    end
  end
end
