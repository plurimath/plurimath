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
      sources = {
        asciimath: "pi",
        mathml: mathml("<mi>pi</mi>"),
        omml: omml(omml_text("pi")),
      }

      expect_sources_to_evaluate(sources, Math::PI, pi: 3)
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
          "Missing value for variable `c`.",
        )
    end

    it "raises when dividing by zero" do
      sources = ["1/0", "a/(b-b)", "frac(1)(0)", "cot(0)", "root(0)(27)", "0^(-1)"]

      aggregate_failures do
        sources.each do |source|
          expect { evaluate(source, :asciimath, a: 1, b: 2) }
            .to raise_error(
              Plurimath::Math::Evaluation::DivisionByZeroError,
              "Cannot divide by zero.",
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
              /\AMath domain error: /,
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
              "Evaluation did not produce a finite number.",
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
              "Value for variable `a` must be a real number, got #{class_name}.",
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
              "Math domain error: result is not a real number.",
            )
        end
      end
    end

    it "raises for equations instead of solving" do
      expect { evaluate("a+b=c", :asciimath, a: 2, b: 3, c: 5) }
        .to raise_error(
          Plurimath::Math::Evaluation::UnsupportedExpressionError,
          "Unsupported expression: equation.",
        )
    end

    it "raises for implicit multiplication instead of guessing" do
      expect { evaluate("2a", :asciimath, a: 3) }
        .to raise_error(
          Plurimath::Math::Evaluation::UnsupportedExpressionError,
          "Unsupported expression: symbol `a`.",
        )
    end

    it "raises for unsupported semantic nodes" do
      expect { evaluate("sum_(i=1)^3 i", :asciimath, i: 1) }
        .to raise_error(
          Plurimath::Math::Evaluation::UnsupportedExpressionError,
          "Unsupported expression: Function::Sum.",
        )
    end

    it "raises for empty expressions" do
      formula = described_class.new([])

      expect { formula.evaluate }
        .to raise_error(
          Plurimath::Math::Evaluation::UnsupportedExpressionError,
          "Unsupported expression: empty expression.",
        )
    end
  end
end
