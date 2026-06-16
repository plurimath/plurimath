require "spec_helper"

RSpec.describe Plurimath::Math::Formula do
  def evaluate(source, type = :asciimath, bindings = {})
    Plurimath::Math.parse(source, type).evaluate(bindings)
  end

  def expect_numeric_result(actual, expected, tolerance = 0.000001)
    if expected.is_a?(Float)
      expect(actual).to be_within(tolerance).of(expected)
    else
      expect(actual).to eq(expected)
    end
  end

  def expect_sources_to_evaluate(sources, expected, bindings = {})
    aggregate_failures do
      sources.each do |type, source|
        expect_numeric_result(evaluate(source, type, bindings), expected)
      end
    end
  end

  def mathml(content)
    "<math>#{content}</math>"
  end

  def omml(content)
    "<m:oMathPara xmlns:m=\"http://schemas.openxmlformats.org/officeDocument/2006/math\"><m:oMath>#{content}</m:oMath></m:oMathPara>"
  end

  def omml_text(value)
    "<m:r><m:t>#{value}</m:t></m:r>"
  end

  describe "#evaluate" do
    it "evaluates explicit arithmetic from supported input syntaxes" do
      sources = {
        asciimath: "a+b-c*d",
        latex: 'a+b-c\cdot d',
        mathml: mathml(
          "<mrow><mi>a</mi><mo>+</mo><mi>b</mi><mo>&#x2212;</mo><mi>c</mi><mo>&#x22c5;</mo><mi>d</mi></mrow>",
        ),
        unicode: "a+b-c⋅d",
        omml: omml(
          "#{omml_text('a')}#{omml_text('+')}#{omml_text('b')}#{omml_text('-')}#{omml_text('c')}#{omml_text('×')}#{omml_text('d')}",
        ),
        html: "<h4>a+b-c*d</h4>",
      }

      expect_sources_to_evaluate(sources, 9, a: 10, b: 5, c: 2, d: 3)
    end

    it "evaluates operator precedence and associativity" do
      cases = {
        "a+b*c" => 44,
        "a*b+c" => 99,
        "a-b-c" => -7,
        "a/b/c" => 2.0,
        "a+b/c-d*e" => 4.0,
        "2^3^2" => 64,
        "(2^3)^2" => 64,
        "2^(3^2)" => 512,
        "-2^2" => -4,
        "(-2)^2" => 4,
        "2^(-3)" => 0.125,
        "+a" => 8,
      }

      aggregate_failures do
        cases.each do |source, expected|
          expect_numeric_result(
            evaluate(source, :asciimath, a: 8, b: 12, c: 3, d: 2, e: 4),
            expected,
          )
        end
      end
    end

    it "evaluates numeric literals without bindings" do
      cases = {
        "1+2+3" => 6,
        "10-2.5" => 7.5,
        "3.5*2" => 7.0,
        "7/2" => 3.5,
        "1/exp(1000)" => 0.0,
      }

      aggregate_failures do
        cases.each do |source, expected|
          expect_numeric_result(evaluate(source), expected)
        end
      end
    end

    it "evaluates grouped arithmetic" do
      sources = {
        asciimath: "(a+b)*c",
        latex: '(a+b)\cdot c',
        mathml: mathml(
          "<mrow><mrow><mo>(</mo><mi>a</mi><mo>+</mo><mi>b</mi><mo>)</mo></mrow><mo>&#x22c5;</mo><mi>c</mi></mrow>",
        ),
        unicode: "(a+b)⋅c",
      }

      expect_sources_to_evaluate(sources, 20, a: 2, b: 3, c: 4)
    end

    it "evaluates fractions" do
      sources = {
        asciimath: "frac(a+b)(c-d)",
        latex: '\frac{a+b}{c-d}',
        mathml: mathml(
          "<mfrac><mrow><mi>a</mi><mo>+</mo><mi>b</mi></mrow><mrow><mi>c</mi><mo>&#x2212;</mo><mi>d</mi></mrow></mfrac>",
        ),
        unicode: "(a+b)/(c-d)",
        omml: omml(
          "<m:f><m:num>#{omml_text('a')}#{omml_text('+')}#{omml_text('b')}</m:num><m:den>#{omml_text('c')}#{omml_text('-')}#{omml_text('d')}</m:den></m:f>",
        ),
      }

      expect_sources_to_evaluate(sources, 2.0, a: 2, b: 4, c: 10, d: 7)
    end

    it "evaluates powers and square roots" do
      sources = {
        asciimath: "sqrt(a^2+b^2)",
        latex: '\sqrt{a^2+b^2}',
        mathml: mathml(
          "<msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>+</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt>",
        ),
        unicode: "√(a^2+b^2)",
        omml: omml(
          "<m:rad><m:degHide m:val=\"on\"/><m:e><m:sSup><m:e>#{omml_text('a')}</m:e><m:sup>#{omml_text('2')}</m:sup></m:sSup>#{omml_text('+')}<m:sSup><m:e>#{omml_text('b')}</m:e><m:sup>#{omml_text('2')}</m:sup></m:sSup></m:e></m:rad>",
        ),
        html: "<h4>sqrt(a^2+b^2)</h4>",
      }

      expect_sources_to_evaluate(sources, 5.0, a: 3, b: 4)
    end

    it "evaluates LaTeX slash division" do
      expect_numeric_result(evaluate("a/b", :latex, a: 6, b: 3), 2.0)
    end

    it "evaluates logarithms" do
      cases = {
        ["log(100)", :asciimath] => 2.0,
        ["log_2(8)", :asciimath] => 3.0,
        ["log_2^3(8)", :asciimath] => 27.0,
        ['\lg{1000}', :latex] => 3.0,
      }

      aggregate_failures do
        cases.each do |(source, type), expected|
          expect_numeric_result(evaluate(source, type), expected)
        end
      end
    end

    it "raises for bare functions without operands" do
      expect { evaluate('\lg', :latex) }
        .to raise_error(
          Plurimath::Math::Evaluation::UnsupportedExpressionError,
          "unsupported expression: missing operand",
        )
    end

    it "evaluates discrete and aggregate functions" do
      cases = {
        "7 mod 3" => 1,
        "-7 mod 3" => 2,
        "(-7) mod 3" => 2,
        "7 mod (-3)" => -2,
        "max(2,3,1)" => 3,
        "min(2,3,1)" => 1,
        "gcd(12,8)" => 4,
        "lcm(4,6)" => 12,
        "sum_(i=1)^3 i" => 6,
        "prod_(i=1)^4 i" => 24,
        "sum_(i=3)^2 i" => 0,
        "prod_(i=3)^2 i" => 1,
      }

      aggregate_failures do
        cases.each do |source, expected|
          expect_numeric_result(evaluate(source), expected)
        end
      end
    end

    it "scopes iteration indexes without leaking into outer bindings" do
      expect(evaluate("sum_(i=1)^3 (i*x)", :asciimath, x: 2, i: 100)).to eq(12)
    end

    it "evaluates MathML bounded sum and product with a sibling body" do
      sum = mathml(
        "<munderover><mo>&#x2211;</mo><mrow><mi>i</mi><mo>=</mo>" \
        "<mn>1</mn></mrow><mn>3</mn></munderover><msup><mi>i</mi><mn>2</mn></msup>",
      )
      prod = mathml(
        "<munderover><mo>&#x220f;</mo><mrow><mi>i</mi><mo>=</mo>" \
        "<mn>1</mn></mrow><mn>4</mn></munderover><mi>i</mi>",
      )

      aggregate_failures do
        expect(evaluate(sum, :mathml)).to eq(14)
        expect(evaluate(prod, :mathml)).to eq(24)
      end
    end

    it "evaluates nested MathML bounded sums" do
      nested = mathml(
        "<munderover><mo>&#x2211;</mo><mrow><mi>i</mi><mo>=</mo>" \
        "<mn>1</mn></mrow><mn>2</mn></munderover>" \
        "<munderover><mo>&#x2211;</mo><mrow><mi>j</mi><mo>=</mo>" \
        "<mn>1</mn></mrow><mn>2</mn></munderover><mi>j</mi>",
      )

      expect(evaluate(nested, :mathml)).to eq(6)
    end

    it "evaluates OMML bounded sum and product with text indexes" do
      sum = Plurimath::Math.parse("sum_(i=1)^3 i", :asciimath).to_omml
      prod = Plurimath::Math.parse("prod_(i=1)^4 i", :asciimath).to_omml

      aggregate_failures do
        expect(evaluate(sum, :omml)).to eq(6)
        expect(evaluate(prod, :omml)).to eq(24)
      end
    end

    it "identifies variable names only for plain symbols and text values" do
      aggregate_failures do
        expect(Plurimath::Math::Symbols::Symbol.new("k").variable_name).to eq("k")
        expect(Plurimath::Math::Symbols::Symbol.new("").variable_name).to be_nil
        expect(Plurimath::Math::Symbols::Symbol.new(nil).variable_name).to be_nil
        expect(Plurimath::Math::Symbols::Pi.new.variable_name).to be_nil
        expect(Plurimath::Math::Symbols::Plus.new.variable_name).to be_nil
        expect(Plurimath::Math::Function::Text.new("k").variable_name).to eq("k")
        expect(Plurimath::Math::Function::Text.new(" k ").variable_name).to eq("k")
        expect(Plurimath::Math::Function::Text.new("").variable_name).to be_nil
        expect(Plurimath::Math::Function::Text.new(nil).variable_name).to be_nil
        expect(Plurimath::Math::Function::Text.new(%w[a b]).variable_name).to be_nil
      end
    end

    it "resolves iteration indexes from each valid node type and rejects others" do
      build = lambda do |index|
        lower = described_class.new(
          [index, Plurimath::Math::Symbols::Equal.new,
           Plurimath::Math::Number.new("1")],
        )
        described_class.new(
          [Plurimath::Math::Function::Sum.new(
            lower, Plurimath::Math::Number.new("2"),
            Plurimath::Math::Number.new("5")
          )],
        ).evaluate
      end

      aggregate_failures do
        expect(build.call(Plurimath::Math::Symbols::Symbol.new("k"))).to eq(10)
        expect(build.call(Plurimath::Math::Function::Text.new("k"))).to eq(10)

        [Plurimath::Math::Function::Text.new(nil),
         Plurimath::Math::Function::Text.new(%w[a b]),
         Plurimath::Math::Symbols::Symbol.new(""),
         Plurimath::Math::Symbols::Plus.new].each do |index|
          expect { build.call(index) }.to raise_error(
            Plurimath::Math::Evaluation::UnsupportedExpressionError,
            "unsupported expression: malformed iteration bounds",
          )
        end

        expect { build.call(Plurimath::Math::Symbols::Pi.new) }.to raise_error(
          Plurimath::Math::Evaluation::UnsupportedExpressionError,
          "unsupported expression: reserved constant as iteration index",
        )
      end
    end

    it "raises for invalid discrete function arguments" do
      cases = {
        "gcd(2.5,2)" => [
          Plurimath::Math::Evaluation::MathDomainError,
          "gcd requires integer arguments",
        ],
        "7 mod 0" => [
          Plurimath::Math::Evaluation::DivisionByZeroError,
          "divided by 0",
        ],
        "sum_(i=1)^2.5 i" => [
          Plurimath::Math::Evaluation::MathDomainError,
          "iteration bounds must be integers",
        ],
        "sum_(pi=1)^3 2" => [
          Plurimath::Math::Evaluation::UnsupportedExpressionError,
          "unsupported expression: reserved constant as iteration index",
        ],
        "sum_(i=1)^9999999 i" => [
          Plurimath::Math::Evaluation::UnsupportedExpressionError,
          "unsupported expression: iteration range larger than 1000000 steps",
        ],
        "log_0(8)" => [
          Plurimath::Math::Evaluation::MathDomainError,
          "log base must be a positive number other than 1",
        ],
        "log_1(8)" => [
          Plurimath::Math::Evaluation::MathDomainError,
          "log base must be a positive number other than 1",
        ],
        "max 2,3" => [
          Plurimath::Math::Evaluation::UnsupportedExpressionError,
          "unsupported expression: malformed token",
        ],
        "7 mod -3" => [
          Plurimath::Math::Evaluation::UnsupportedExpressionError,
          "unsupported expression: Symbols::Minus",
        ],
      }

      aggregate_failures do
        cases.each do |source, (error, message)|
          expect { evaluate(source) }.to raise_error(error, message)
        end
      end
    end

    it "evaluates supported trigonometric and exponential functions" do
      cases = {
        "sin(0)" => 0.0,
        "cos(0)" => 1.0,
        "tan(0)" => 0.0,
        "ln(1)" => 0.0,
        "exp(0)" => 1.0,
      }

      aggregate_failures do
        cases.each do |source, expected|
          expect_numeric_result(evaluate(source), expected)
        end
      end
    end

    it "evaluates additional numeric functions" do
      cases = {
        "abs(-3)" => 3,
        "floor(3.7)" => 3,
        "ceil(3.2)" => 4,
        "root(3)(27)" => 3.0,
        "arcsin(1)" => Math::PI / 2,
        "arccos(1)" => 0.0,
        "arctan(1)" => Math::PI / 4,
        "sinh(0)" => 0.0,
        "cosh(0)" => 1.0,
        "tanh(0)" => 0.0,
        "sec(0)" => 1.0,
        "csc(pi/2)" => 1.0,
        "cot(pi/4)" => 1.0,
        "sech(0)" => 1.0,
        "csch(1)" => 1.0 / Math.sinh(1),
        "coth(1)" => 1.0 / Math.tanh(1),
      }

      aggregate_failures do
        cases.each do |source, expected|
          expect_numeric_result(evaluate(source), expected)
        end
      end
    end

    it "evaluates functions and constants from math syntaxes" do
      sources = {
        asciimath: "sin(pi/2)",
        latex: '\sin{\frac{\pi}{2}}',
        mathml: mathml(
          "<mrow><mi>sin</mi><mrow><mo>(</mo><mfrac><mi>&#x3c0;</mi><mn>2</mn></mfrac><mo>)</mo></mrow></mrow>",
        ),
        unicode: "sin(π/2)",
        omml: omml(
          "<m:func><m:fName>#{omml_text('sin')}</m:fName><m:e><m:d><m:e><m:f><m:num>#{omml_text('&#x3c0;')}</m:num><m:den>#{omml_text('2')}</m:den></m:f></m:e></m:d></m:e></m:func>",
        ),
      }

      expect_sources_to_evaluate(sources, 1.0)
    end

    it "evaluates nested power trees literally" do
      source = mathml(
        "<msup><msup><mn>2</mn><mn>3</mn></msup><mn>2</mn></msup>",
      )

      expect_numeric_result(evaluate(source, :mathml), 64)
    end

    it "evaluates split MathML function applications" do
      source = mathml(
        "<mrow><mi>ln</mi><mrow><mo>(</mo><mi>exp</mi><mrow><mo>(</mo><mn>1</mn><mo>)</mo></mrow><mo>)</mo></mrow></mrow>",
      )

      expect_numeric_result(evaluate(source, :mathml), 1.0)
    end

    it "accepts string and symbol binding keys" do
      expect(evaluate("a+b", :asciimath, "a" => 2, b: 3)).to eq(5)
    end

    it "keeps variable names case-sensitive" do
      expect(evaluate("a+A", :asciimath, a: 2, A: 5)).to eq(7)
    end

    it "accepts hash-like binding objects" do
      hash_like = Class.new do
        def to_hash
          { a: 2, b: 3 }
        end
      end.new

      formula = Plurimath::Math.parse("a+b", :asciimath)

      expect(formula.evaluate(hash_like)).to eq(5)
    end

    it "lets keyword bindings override positional bindings" do
      formula = Plurimath::Math.parse("a+b", :asciimath)

      expect(formula.evaluate({ "a" => 1, "b" => 2 }, a: 4)).to eq(6)
    end

    it "does not let bindings override reserved constants" do
      cases = [
        ["pi", :asciimath],
        ["<h4>&#x3c0;</h4>", :html],
        ["<h4>π</h4>", :html],
      ]

      aggregate_failures do
        cases.each do |source, type|
          expect_numeric_result(
            evaluate(source, type, pi: 3, "π" => 3),
            Math::PI,
          )
        end
      end
    end

    it "treats plain-text pi names as variables in unicode-capable markups" do
      sources = {
        mathml: mathml("<mi>pi</mi>"),
        omml: omml(omml_text("pi")),
      }

      expect_sources_to_evaluate(sources, 3, pi: 3)
    end

    it "treats HTML letters as individual identifiers" do
      expect_numeric_result(
        evaluate("<h4>pi r^2</h4>", :html, p: 2, i: 3, r: 4),
        96,
      )
    end

    it "requires hash-like bindings" do
      formula = Plurimath::Math.parse("a+b", :asciimath)

      expect { formula.evaluate(nil) }
        .to raise_error(ArgumentError, "bindings must be a Hash-like object")
    end

    it "raises a clear error when a variable binding is missing" do
      expect { evaluate("a+b+c", :asciimath, a: 2, b: 3) }
        .to raise_error(
          Plurimath::Math::Evaluation::MissingVariableError,
          "missing value for variable `c`",
        )
    end

    it "raises when dividing by zero" do
      sources = ["1/0", "a/(b-b)", "frac(1)(0)", "cot(0)", "root(0)(27)", "0^(-1)"]

      aggregate_failures do
        sources.each do |source|
          expect { evaluate(source, :asciimath, a: 1, b: 2) }
            .to raise_error(
              Plurimath::Math::Evaluation::DivisionByZeroError,
              "divided by 0",
            )
        end
      end
    end

    it "raises for math domain violations" do
      sources = ["ln(-1)", "sqrt(-4)", "arcsin(2)"]

      aggregate_failures do
        sources.each do |source|
          expect { evaluate(source) }
            .to raise_error(
              Plurimath::Math::Evaluation::MathDomainError,
              /out of domain/,
            )
        end
      end
    end

    it "raises when evaluation does not produce a finite number" do
      sources = ["ln(0)", "exp(1000)", "floor(exp(1000))"]

      aggregate_failures do
        sources.each do |source|
          expect { evaluate(source) }
            .to raise_error(
              Plurimath::Math::Evaluation::NonFiniteResultError,
              "result is not a finite number",
            )
        end
      end
    end

    it "raises for binding values that are not real numbers" do
      cases = {
        "2" => "String",
        Complex(1, 2) => "Complex",
      }

      aggregate_failures do
        cases.each do |value, class_name|
          expect { evaluate("a+b", :asciimath, a: value, b: 3) }
            .to raise_error(
              Plurimath::Math::Evaluation::InvalidBindingError,
              "wrong value for variable `a` " \
              "(given #{class_name}, expected a real number)",
            )
        end
      end
    end

    it "raises when any subexpression is not a real number" do
      sources = [
        "root(2)(-4)",
        "abs(root(2)(-4))",
        "floor(root(2)(-4))",
        "1/root(2)(-4)",
        "sin(root(2)(-4))",
      ]

      aggregate_failures do
        sources.each do |source|
          expect { evaluate(source) }
            .to raise_error(
              Plurimath::Math::Evaluation::MathDomainError,
              "result is not a real number",
            )
        end
      end
    end

    it "raises for equations instead of solving" do
      expect { evaluate("a+b=c", :asciimath, a: 2, b: 3, c: 5) }
        .to raise_error(
          Plurimath::Math::Evaluation::UnsupportedExpressionError,
          "unsupported expression: equation",
        )
    end

    it "evaluates implicit multiplication by juxtaposition" do
      cases = {
        "2a" => 6,
        "2(a+b)" => 10,
        "(a+b)(a-b)" => 5,
        "2 pi" => 2 * Math::PI,
        "pi r^2" => Math::PI * 16,
        "2cos(0)" => 2.0,
      }

      aggregate_failures do
        cases.each do |source, expected|
          expect_numeric_result(
            evaluate(source, :asciimath, a: 3, b: 2, r: 4),
            expected,
          )
        end
      end
    end

    it "raises for unsupported semantic nodes" do
      expect { evaluate("int_0^1 x dx", :asciimath, x: 1) }
        .to raise_error(
          Plurimath::Math::Evaluation::UnsupportedExpressionError,
          "unsupported expression: Function::Int",
        )
    end

    it "raises when a flat power token produces a non-real number" do
      formula = described_class.new(
        [
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbols::Symbol.new("/"),
          Plurimath::Math::Function::Fenced.new(
            nil, [Plurimath::Math::Number.new("-4")], nil
          ),
          Plurimath::Math::Symbols::Hat.new,
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("1"), Plurimath::Math::Number.new("2")
          ),
        ],
      )

      expect { formula.evaluate }
        .to raise_error(
          Plurimath::Math::Evaluation::MathDomainError,
          "result is not a real number",
        )
    end

    it "raises with clear messages for unsupported token shapes" do
      cases = {
        [Plurimath::Math::Symbols::Paren::Lround.new,
         Plurimath::Math::Number.new("1")] =>
          "unsupported expression: unmatched parenthesis",
        [Plurimath::Math::Symbols::Paren::Lround.new,
         Plurimath::Math::Number.new("2"),
         Plurimath::Math::Symbols::Equal.new,
         Plurimath::Math::Number.new("2"),
         Plurimath::Math::Symbols::Paren::Rround.new] =>
          "unsupported expression: equation",
        [Plurimath::Math::Number.new("2"),
         Plurimath::Math::Number.new("3")] =>
          "unsupported expression: number `3`",
        [Plurimath::Math::Number.new("x")] =>
          "unsupported expression: number `x`",
        [Plurimath::Math::Symbols::Symbol.new("")] =>
          "unsupported expression: Symbols::Symbol",
        [Plurimath::Math::Function::Text.new("")] =>
          "unsupported expression: Function::Text",
      }

      aggregate_failures do
        cases.each do |value, message|
          expect { described_class.new(value).evaluate }
            .to raise_error(
              Plurimath::Math::Evaluation::UnsupportedExpressionError,
              message,
            )
        end
      end
    end

    it "raises for empty expressions" do
      formula = described_class.new([])

      expect { formula.evaluate }
        .to raise_error(
          Plurimath::Math::Evaluation::UnsupportedExpressionError,
          "unsupported expression: empty expression",
        )
    end
  end
end
