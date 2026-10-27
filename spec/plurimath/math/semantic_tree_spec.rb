require "spec_helper"

RSpec.describe "Semantic display trees" do
  let(:math) { Plurimath::Math }
  let(:error) { Plurimath::Errors::UnsupportedSemanticTreeError }
  let(:languages) { %i[omml latex mathml asciimath unicodemath] }
  let(:issue_source) do
    '1/(2pi) int_0^(2pi) (bbb"d" theta) / (a + b sin⁡ theta) = 1/sqrt(a^2−b^2)'
  end

  def semantic(source, language = :unicodemath)
    Plurimath::Math.parse(source, :asciimath).to_display(language, tree: :semantic)
  end

  def model(*nodes)
    Plurimath::Math::Formula.new(nodes)
  end

  def symbol(value)
    Plurimath::Math::Symbols::Symbol.new(value)
  end

  def number(value)
    Plurimath::Math::Number.new(value.to_s)
  end

  it "uses multiplication precedence without evaluating or binding variables" do
    expect(semantic("a+b*c")).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ add "+"
            |_ symbol "a"
            |_ multiply
               |_ symbol "b"
               |_ symbol "c"
    TREE
    expect(semantic("a+bc")).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ add "+"
            |_ symbol "a"
            |_ implicit multiply
               |_ symbol "b"
               |_ symbol "c"
    TREE
  end

  it "preserves explicit grouping above an implicit multiplication" do
    expect(semantic("(a+b)c")).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ implicit multiply
            |_ group
               |_ add "+"
                  |_ symbol "a"
                  |_ symbol "b"
            |_ symbol "c"
    TREE
    native = model(math::Symbols::Paren::Lround.new, symbol("a"), symbol("+"), symbol("b"), math::Symbols::Paren::Rround.new, symbol("/"), symbol("c"))
    expect(native.to_display(:unicodemath, tree: :semantic)).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ divide
            |_ group
               |_ add "+"
                  |_ symbol "a"
                  |_ symbol "b"
            |_ symbol "c"
    TREE
  end

  it "keeps subtraction and power chains left nested" do
    expect(semantic("a-b-c")).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ subtract "−"
            |_ subtract "−"
               |_ symbol "a"
               |_ symbol "b"
            |_ symbol "c"
    TREE
    expect(semantic("2^3^2")).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ power
            |_ power
               |_ number "2"
               |_ number "3"
            |_ number "2"
    TREE
  end

  it "retains unary signs and the parser's power precedence" do
    expect(model(symbol("-"), symbol("a"), symbol("^"), number(2)).to_display(:unicodemath, tree: :semantic)).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ negative
            |_ power
               |_ symbol "a"
               |_ number "2"
    TREE
    expect(model(symbol("+"), symbol("a")).to_display(:unicodemath, tree: :semantic)).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ positive
            |_ symbol "a"
    TREE
    expect(model(symbol("-"), math::Function::Mod.new(number(7), number(3))).to_display(:unicodemath, tree: :semantic)).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ mod
            |_ negative
               |_ number "7"
            |_ number "3"
    TREE
  end

  it "puts relations above arithmetic and retains relation-chain order" do
    expect(semantic("a+b=c")).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ relation "="
            |_ add "+"
               |_ symbol "a"
               |_ symbol "b"
            |_ symbol "c"
    TREE
    expect(semantic("a=b=c")).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ relation "="
            |_ relation "="
               |_ symbol "a"
               |_ symbol "b"
            |_ symbol "c"
    TREE
    %w[< > <= >= !=].each do |operator|
      output = model(symbol("a"), symbol(operator), symbol("b")).to_display(:unicodemath, tree: :semantic)
      expect(output).to eq("|_ Semantic tree\n   |_ relation #{operator.inspect}\n      |_ symbol \"a\"\n      |_ symbol \"b\"")
    end
    %w[lt gt le ge ne].each do |operator|
      expect(semantic("a #{operator} b")).to start_with("|_ Semantic tree\n   |_ relation ")
    end
  end

  it "binds ordinary and explicit function application without multiplying the argument" do
    expect(semantic("sin(theta)")).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ apply "sin⁡"
            |_ group
               |_ symbol "θ"
    TREE
    expected = <<~TREE.chomp
      |_ Semantic tree
         |_ apply "sin⁡"
            |_ symbol "θ"
    TREE
    expect(semantic("sin⁡ theta")).to eq(expected)
    explicit = model(math::Function::Sin.new, math::Symbols::Funcapply.new, symbol("θ"))
    expect(explicit.to_display(:unicodemath, tree: :semantic)).to eq(expected)
  end

  it "retains fraction, radical, root index and script roles in native models" do
    expression = model(math::Function::Frac.new(
      math::Function::Base.new(symbol("a"), number(1)),
      math::Function::Root.new(number(3), math::Function::Sqrt.new(symbol("b"))),
    ))
    expect(expression.to_display(:unicodemath, tree: :semantic)).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ fraction
            |_ subscript
               |_ symbol "a"
               |_ number "1"
            |_ root
               |_ index
                  |_ number "3"
               |_ radicand
                  |_ square root
                     |_ symbol "b"
    TREE
    expression = model(math::Function::PowerBase.new(symbol("a"), number(1), number(2)))
    expect(expression.to_display(:unicodemath, tree: :semantic)).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ subsup
            |_ base
               |_ symbol "a"
            |_ subscript
               |_ number "1"
            |_ superscript
               |_ number "2"
    TREE
  end

  it "binds a sibling integral body while retaining both limits" do
    expression = model(math::Function::Int.new(number(0), number(1)), symbol("x"))
    expect(expression.to_display(:unicodemath, tree: :semantic)).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ integral
            |_ lower limit
               |_ number "0"
            |_ upper limit
               |_ number "1"
            |_ integrand
               |_ symbol "x"
    TREE
  end

  it "binds logarithm arguments without evaluating or inventing a base" do
    expression = model(math::Function::Log.new, math::Function::Fenced.new(nil, [symbol("x")], nil))
    expect(expression.to_display(:unicodemath, tree: :semantic)).to eq(<<~TREE.chomp)
      |_ Semantic tree
         |_ apply "log"
            |_ argument
               |_ group
                  |_ symbol "x"
    TREE
  end

  it "renders the complete original issue expression with operand ownership" do
    expect(semantic(issue_source)).to eq(<<~'TREE'.chomp)
      |_ Semantic tree
         |_ relation "="
            |_ implicit multiply
               |_ fraction
                  |_ number "1"
                  |_ implicit multiply
                     |_ number "2"
                     |_ symbol "π"
               |_ integral
                  |_ lower limit
                     |_ number "0"
                  |_ upper limit
                     |_ implicit multiply
                        |_ number "2"
                        |_ symbol "π"
                  |_ integrand
                     |_ fraction
                        |_ implicit multiply
                           |_ symbol "\\Bbb\"d\""
                           |_ symbol "θ"
                        |_ add "+"
                           |_ symbol "a"
                           |_ implicit multiply
                              |_ symbol "b"
                              |_ apply "sin⁡"
                                 |_ symbol "θ"
            |_ fraction
               |_ number "1"
               |_ square root
                  |_ subtract "−"
                     |_ power
                        |_ symbol "a"
                        |_ number "2"
                     |_ power
                        |_ symbol "b"
                        |_ number "2"
    TREE
  end

  it "uses each existing language writer for labels" do
    expected = {
      asciimath: 'symbol "theta"',
      latex: 'symbol "\\\\theta"',
      unicodemath: 'symbol "θ"',
      mathml: 'symbol "<mi>&#x3b8;</mi>"',
      omml: 'symbol "<m:t>&#x3b8;</m:t>"',
    }
    expected.each do |language, label|
      expect(semantic("theta", language)).to eq("|_ Semantic tree\n   |_ #{label}")
    end
  end

  it "keeps ordinary display output unchanged and rendering repeatable without mutation" do
    formula = math.parse(issue_source, :asciimath)
    before = Marshal.dump(formula)
    outputs = languages.to_h do |language|
      [language, formula.to_display(language, tree: :semantic)]
    end
    expect(Marshal.dump(formula)).to eq(before)
    outputs.each do |language, output|
      expect(formula.to_display(language, tree: :semantic)).to eq(output)
    end
    expect(Marshal.dump(formula)).to eq(before)

    languages.each do |language|
      simple = math.parse("a+b", :asciimath)
      expect(simple.to_display(language)).to eq(simple.to_display(language, tree: :display))
    end
  end

  it "reports unsupported and malformed constructs with a dedicated typed error" do
    [
      [model, "empty expression"],
      [model(symbol("a"), symbol("+")), "empty expression"],
      [model(number(2), number(3)), "number"],
      [model(math::Function::Frac.new(number(1), nil)), "missing operand"],
      [model(math::Function::Text.new("words")), "Function::Text"],
      [model(math::Function::Table.new), "Function::Table"],
      [model(math::Function::Sin.new(symbol("⁡"))), "function application"],
      [model(symbol("a"), math::Symbols::Equal.new), "empty expression"],
      [model(math::Function::Fenced.new(math::Symbols::Paren::Lround.new, [symbol("a")], nil)), "Fenced"],
      [model(symbol("a"), math::Symbols::Comma.new, symbol("b")), "Symbols::Comma"],
    ].each do |formula, construct|
      expect { formula.to_display(:unicodemath, tree: :semantic) }.to raise_error(error, /#{Regexp.escape(construct)}/i)
    end
    expect { semantic("[a,b]") }.to raise_error(error, /Fenced/)
    expect { model(math::Symbols::Paren::Lround.new, symbol("a")).to_display(:unicodemath, tree: :semantic) }.to raise_error(error, /unmatched parenthesis/)
    expect { semantic("a") }.not_to raise_error
    expect { model(symbol("a")).to_display(:unicodemath, tree: :other) }.to raise_error(ArgumentError, /Unknown display tree/)
    expect { model(symbol("a")).to_display(:formula, tree: :semantic) }.to raise_error(error, /label language :formula/)
    expect { model(symbol("a")).to_display(:html, tree: :semantic) }.to raise_error(error, /label language :html/)
    expect(error).to be < Plurimath::Error
  end

  it "keeps the Ruby class view separate from semantic language labels" do
    formula = math.parse("a+b", :asciimath)
    class_view = formula.to_display(:formula)

    expect(class_view).to start_with("Plurimath::Math::Formula\n")
    expect(formula.to_display(:formula, tree: :display)).to eq(class_view)
    expect { formula.to_display(:formula, tree: :semantic) }.to raise_error(error, /label language :formula/)
    expect { formula.to_display(:formula, tree: :other) }.to raise_error(ArgumentError, /Unknown display tree/)
  end

  it "preserves numeric folds and numeric-only error behavior" do
    expect(math.parse("2+3*4", :asciimath).evaluate).to eq(14)
    expect(math.parse("-7 mod 3", :asciimath).evaluate).to eq(2)
    expect(math.parse("2^3^2", :asciimath).evaluate).to eq(64)
    expect { math.parse("a=b", :asciimath).evaluate }.to raise_error(Plurimath::Errors::Evaluation::MissingVariableError)
    expect { math.parse("a=b", :asciimath).evaluate(a: 1, b: 2) }.to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError, /equation/)
    expect { math.parse("int_0^1 x", :asciimath).evaluate }.to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError, /Int/)
    expect { model(math::Function::Sin.new, math::Symbols::Funcapply.new, number(1)).evaluate }.to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError, /missing operand/)
    expect { math.parse("sin⁡ theta", :asciimath).evaluate }.to raise_error(Plurimath::Errors::Evaluation::MissingVariableError, /⁡/)
    expect { math.parse("a^2−b^2", :asciimath).evaluate(a: 2, b: 1) }.to raise_error(Plurimath::Errors::Evaluation::MissingVariableError, /−/)
  end
end
