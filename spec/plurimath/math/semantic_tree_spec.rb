require "spec_helper"
require "json"

RSpec.describe "Semantic display trees" do
  let(:math) { Plurimath::Math }
  let(:error) { Plurimath::Errors::UnsupportedSemanticTreeError }
  let(:languages) { %i[omml latex mathml asciimath unicodemath] }
  let(:issue_source) { '1/(2pi) int_0^(2pi) (bbb"d" theta) / (a + b sin⁡ theta) = 1/sqrt(a^2−b^2)' }

  def model(*nodes)
    Plurimath::Math::Formula.new(nodes)
  end

  def symbol(value)
    Plurimath::Math::Symbols::Symbol.new(value)
  end

  def number(value)
    Plurimath::Math::Number.new(value.to_s)
  end

  # Parse only the public indentation/quoted-label format. The expected role
  # trees below are specified from the issue, independently of the renderer.
  def tree(source, language = :unicodemath)
    formula = source.is_a?(String) ? math.parse(source, :asciimath) : source
    output = formula.to_display(language, tree: :semantic)
    expect(output.lines.first.chomp).to eq("|_ Semantic tree")
    stack = []
    root = nil
    output.lines.drop(1).each do |line|
      match = line.match(/\A(\s*)\|_ (.*)/)
      role, separator, label = match[2].partition(' "')
      node = { role: role, math: separator.empty? ? nil : JSON.parse('"' + label), children: [] }
      stack.pop while stack.any? && stack.last[0] >= match[1].length
      stack.empty? ? root = node : stack.last[1][:children] << node
      stack << [match[1].length, node]
    end
    root
  end

  def expression(source, language = :unicodemath)
    root = tree(source, language)
    expect(root[:role]).to eq("expression")
    expect(root[:math]).not_to be_empty
    root[:children].fetch(0)
  end

  def role_tree(node, depth = 0)
    (["#{'  ' * depth}#{node[:role]}"] + node[:children].map { |child| role_tree(child, depth + 1) }).join("\n")
  end

  def descendants(node)
    [node] + node[:children].flat_map { |child| descendants(child) }
  end

  def first_role(node, role)
    descendants(node).find { |child| child[:role] == role }
  end

  def leaves(node)
    descendants(node).select { |child| %w[number symbol].include?(child[:role]) }.map { |child| child[:math] }
  end

  def fragment(node, language)
    copy = node.cloned_objects
    options = { formatter: nil, unitsml: {}, unary_function_spacing: true, formula: model(copy) }
    case language
    when :mathml then copy.dump_mathml(copy, false, options: options).to_s
    when :omml then copy.dump_omml(copy, true, options: options).to_s
    else copy.public_send("to_#{language}", options: options).to_s
    end
  end

  it "resolves explicit and implicit multiplication before addition without evaluating" do
    ["a+b*c", "a+bc"].each do |source|
      node = expression(source)
      expect(node[:role]).to eq("add")
      expect(node[:children].map { |child| child[:role] }).to eq(["symbol", source.include?("*") ? "multiply" : "implicit multiply"])
      expect(leaves(node)).to eq(%w[a b c])
    end
  end

  it "retains explicit grouping and native parenthesis ownership" do
    node = expression("(a+b)c")
    expect(role_tree(node)).to eq("implicit multiply\n  group\n    add\n      symbol\n      symbol\n  symbol")
    native = model(math::Symbols::Paren::Lround.new, symbol("a"), symbol("+"), symbol("b"), math::Symbols::Paren::Rround.new, symbol("/"), symbol("c"))
    expect(role_tree(expression(native))).to eq("divide\n  group\n    add\n      symbol\n      symbol\n  symbol")
  end

  it "preserves the shared parser's subtraction and power-chain associativity" do
    expect(role_tree(expression("a-b-c"))).to eq("subtract\n  subtract\n    symbol\n    symbol\n  symbol")
    node = expression("2^3^2")
    expect(role_tree(node)).to eq("power\n  base\n    power\n      base\n        number\n      script\n        number\n  script\n    number")
    expect(leaves(node)).to eq(%w[2 3 2])
  end

  it "retains unary signs, power precedence and negated mod ownership" do
    node = expression(model(symbol("-"), symbol("a"), symbol("^"), number(2)))
    expect(node[:role]).to eq("negative")
    expect(node[:children].first[:role]).to eq("power")
    expect(expression(model(symbol("+"), symbol("a")))[:role]).to eq("positive")
    node = expression(model(symbol("-"), math::Function::Mod.new(number(7), number(3))))
    expect(role_tree(node)).to eq("mod\n  negative\n    number\n  number")
  end

  it "puts relations above arithmetic and preserves relation-chain order" do
    node = expression("a+b=c")
    expect(node[:role]).to eq("relation")
    expect(node[:children].map { |child| child[:role] }).to eq(%w[add symbol])
    expect(role_tree(expression("a=b=c"))).to eq("relation\n  relation\n    symbol\n    symbol\n  symbol")
    %w[= < > <= >= !=].each do |operator|
      expect(expression(model(symbol("a"), symbol(operator), symbol("b")))[:math]).to eq(operator)
    end
    %w[lt gt le ge ne].each { |operator| expect(expression("a #{operator} b")[:role]).to eq("relation") }
  end

  it "exposes a function name and argument for ordinary and explicit application" do
    node = expression("sin(theta)")
    expect(node[:role]).to eq("apply")
    expect(node[:children].map { |child| child[:role] }).to eq(["function name", "argument"])
    expect(node[:children].first[:math]).to eq("sin")
    expect(node[:children].last[:children].first[:role]).to eq("group")
    ["sin⁡ theta", model(math::Function::Sin.new, math::Symbols::Funcapply.new, symbol("θ"))].each do |source|
      node = expression(source)
      expect(role_tree(node)).to eq("apply\n  function name\n  argument\n    symbol")
      expect(first_role(node, "argument")[:math]).to eq("θ")
    end
  end

  it "retains fraction, subscript, root-index and implicit square-root degree roles" do
    node = expression(model(math::Function::Frac.new(
      math::Function::Base.new(symbol("a"), number(1)),
      math::Function::Root.new(number(3), math::Function::Sqrt.new(symbol("b"))),
    )))
    expect(role_tree(node)).to eq(<<~TREE.chomp)
      fraction
        numerator
          subscript
            base
              symbol
            script
              number
        denominator
          root
            index
              number
            radicand
              square root
                degree
                radicand
                  symbol
    TREE
    expect(first_role(node, "degree")[:math]).to eq("⬚")
    expect(leaves(node)).to eq(%w[a 1 3 b])
    node = expression(model(math::Function::PowerBase.new(symbol("a"), number(1), number(2))))
    expect(node[:children].map { |child| child[:role] }).to eq(%w[base subscript superscript])
    expect(leaves(node)).to eq(%w[a 1 2])
  end

  it "attaches integral bounds and body and logarithm base/argument to their owners" do
    node = expression(model(math::Function::Int.new(number(0), number(1)), symbol("x")))
    expect(node[:children].map { |child| child[:role] }).to eq(["lower limit", "upper limit", "integrand"])
    expect(leaves(node)).to eq(%w[0 1 x])
    node = expression(model(math::Function::Log.new(number(2)), math::Function::Fenced.new(nil, [symbol("x")], nil)))
    expect(node[:children].map { |child| child[:role] }).to eq(["function name", "base", "argument"])
    expect(leaves(node)).to eq(%w[2 x])
  end

  it "matches the role and operand hierarchy of the complete original issue example" do
    node = expression(issue_source)
    expect(role_tree(node)).to eq(<<~TREE.chomp)
      relation
        implicit multiply
          fraction
            numerator
              number
            denominator
              implicit multiply
                number
                symbol
          integral
            lower limit
              number
            upper limit
              implicit multiply
                number
                symbol
            integrand
              fraction
                numerator
                  implicit multiply
                    symbol
                    symbol
                denominator
                  add
                    symbol
                    implicit multiply
                      symbol
                      apply
                        function name
                        argument
                          symbol
        fraction
          numerator
            number
          denominator
            square root
              degree
              radicand
                subtract
                  power
                    base
                      symbol
                    script
                      number
                  power
                    base
                      symbol
                    script
                      number
    TREE
    expect(leaves(node)).to eq(["1", "2", "π", "0", "2", "π", '\\Bbb"d"', "θ", "a", "b", "θ", "1", "a", "2", "b", "2"])
    expect(first_role(node, "function name")[:math]).to eq("sin")
    expect(first_role(node, "degree")[:math]).to eq("⬚")
  end

  it "uses each selected notation for primitive labels" do
    expected = { asciimath: "theta", latex: '\\theta', unicodemath: "θ", mathml: "<mi>&#x3b8;</mi>", omml: "<m:t>&#x3b8;</m:t>" }
    expected.each { |language, label| expect(expression("theta", language)[:math]).to eq(label) }
  end

  it "labels composite expressions and roles with their selected existing notation writer" do
    numerator = number(1)
    radicand = symbol("x")
    denominator = math::Function::Sqrt.new(radicand)
    fraction = math::Function::Frac.new(numerator, denominator)
    languages.each do |language|
      root = tree(model(fraction), language)
      node = root[:children].first
      expect(root[:math]).to eq(fragment(fraction, language))
      expect(node[:math]).to eq(fragment(fraction, language))
      expect(first_role(node, "numerator")[:math]).to eq(fragment(numerator, language))
      expect(first_role(node, "denominator")[:math]).to eq(fragment(denominator, language))
      expect(first_role(node, "radicand")[:math]).to eq(fragment(radicand, language))
      expect(first_role(node, "degree")[:math]).to eq("⬚")
    end
  end

  it "is repeatable and does not mutate stored models or ordinary language displays" do
    formula = math.parse(issue_source, :asciimath)
    before = Marshal.dump(formula)
    outputs = languages.to_h { |language| [language, formula.to_display(language, tree: :semantic)] }
    expect(Marshal.dump(formula)).to eq(before)
    outputs.each { |language, output| expect(formula.to_display(language, tree: :semantic)).to eq(output) }
    expect(Marshal.dump(formula)).to eq(before)
    languages.each do |language|
      simple = math.parse("a+b", :asciimath)
      expect(simple.to_display(language)).to eq(simple.to_display(language, tree: :display))
    end
  end

  it "reports unsupported, malformed and out-of-contract constructs explicitly" do
    [model, model(symbol("a"), symbol("+")), model(number(2), number(3)),
     model(math::Function::Frac.new(number(1), nil)), model(math::Function::Text.new("words")),
     model(math::Function::Table.new), model(math::Function::Sin.new(symbol("⁡"))),
     model(symbol("a"), math::Symbols::Equal.new),
     model(math::Function::Fenced.new(math::Symbols::Paren::Lround.new, [symbol("a")], nil)),
     model(symbol("a"), math::Symbols::Comma.new, symbol("b"))].each do |formula|
      expect { formula.to_display(:unicodemath, tree: :semantic) }.to raise_error(error)
    end
    expect { expression("[a,b]") }.to raise_error(error, /Fenced/)
    expect { expression(model(math::Symbols::Paren::Lround.new, symbol("a"))) }.to raise_error(error, /unmatched parenthesis/)
    expect { expression("a") }.not_to raise_error
    expect { model(symbol("a")).to_display(:unicodemath, tree: :other) }.to raise_error(ArgumentError, /Unknown display tree/)
    %i[formula html].each { |language| expect { expression(model(symbol("a")), language) }.to raise_error(error, /label language/) }
    expect(error).to be < Plurimath::Error
  end

  it "keeps Ruby-object trees separate and preserves numeric folds and errors" do
    formula = math.parse("a+b", :asciimath)
    expect(formula.to_display(:formula)).to start_with("Plurimath::Math::Formula\n")
    expect(formula.to_display(:formula, tree: :display)).to eq(formula.to_display(:formula))
    expect { formula.to_display(:formula, tree: :semantic) }.to raise_error(error)
    expect { formula.to_display(:formula, tree: :other) }.to raise_error(ArgumentError)
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
