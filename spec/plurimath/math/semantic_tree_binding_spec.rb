# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Semantic operand binding" do
  let(:math) { Plurimath::Math }
  let(:error) { Plurimath::Errors::UnsupportedSemanticTreeError }
  let(:backend) { math::SemanticTree.new(:unicodemath, {}) }

  def symbol(value)
    Plurimath::Math::Symbols::Symbol.new(value)
  end

  def number(value)
    Plurimath::Math::Number.new(value.to_s)
  end

  def model(*nodes)
    Plurimath::Math::Formula.new(nodes)
  end

  # Read ownership from the public tree, allowing additional role wrappers and
  # mathematical labels without coupling these regressions to their wording.
  def display_root(formula)
    stack = []
    root = nil
    formula.to_display(:unicodemath, tree: :semantic).lines.drop(1).each do |line|
      match = line.match(/\A(\s*)\|_ (.*)/)
      depth = match[1].length
      node = { label: match[2], children: [] }
      stack.pop while stack.any? && stack.last[0] >= depth
      stack.empty? ? root = node : stack.last[1][:children] << node
      stack << [depth, node]
    end
    root[:label].start_with?("expression ") ? root[:children].fetch(0) : root
  end

  def descendants(node)
    [node] + node[:children].flat_map { |child| descendants(child) }
  end

  def named(node, name)
    descendants(node).find { |child| child[:label].match?(/\b#{Regexp.escape(name)}\b/) }
  end

  def symbol_leaf?(node, value)
    descendants(node).any? { |child| child[:children].empty? && child[:label].include?(value.inspect) }
  end

  it "adopts the existing sibling body of parsed unbounded integrals and sums" do
    { "int x" => "integral", "sum x" => "summation" }.each do |source, kind|
      formula = math.parse(source, :asciimath)
      expect(formula.value.length).to eq(2)
      expect(formula.value.first.parameter_three).to be_nil
      tree = display_root(formula)
      expect(tree[:label]).to include(kind)
      body = named(tree, kind == "integral" ? "integrand" : "body")
      expect(body).not_to be_nil
      expect(symbol_leaf?(body, "x")).to be(true)
      expect(named(tree, "lower limit")).to be_nil
      expect(named(tree, "upper limit")).to be_nil
    end
  end

  it "supports native nary nodes with absent, lower-only and upper-only limits" do
    [math::Function::Int, math::Function::Sum, math::Function::Prod].each do |klass|
      [[nil, nil], [number(0), nil], [nil, number(3)]].each do |lower, upper|
        formula = model(klass.new(lower, upper), symbol("x"))
        tree = display_root(formula)
        body = named(tree, klass == math::Function::Int ? "integrand" : "body")
        expect(symbol_leaf?(body, "x")).to be(true)
        expect(named(tree, "lower limit").nil?).to eq(lower.nil?)
        expect(named(tree, "upper limit").nil?).to eq(upper.nil?)
      end
    end
  end

  it "retains parsed partial limits while attaching the supplied body" do
    ["int_0 x", "int^3 x", "sum_0 x", "sum^3 x"].each do |source|
      formula = math.parse(source, :asciimath)
      tree = display_root(formula)
      body = named(tree, source.start_with?("int") ? "integrand" : "body")
      expect(symbol_leaf?(body, "x")).to be(true)
      role, value = source.include?("_") ? ["lower limit", "0"] : ["upper limit", "3"]
      expect(symbol_leaf?(named(tree, role), value)).to be(true)
    end
  end

  it "binds nested unbounded nary bodies recursively" do
    formula = model(math::Function::Int.new, math::Function::Sum.new, symbol("x"))
    tree = display_root(formula)
    integrand = named(tree, "integrand")
    sum = named(integrand, "summation")
    expect(symbol_leaf?(named(sum, "body"), "x")).to be(true)
  end

  it "binds a parsed powered function's argument inside its power" do
    formula = math.parse("sin^2 x", :asciimath)
    expect(formula.value).to eq([math::Function::Power.new(math::Function::Sin.new, number(2)), symbol("x")])
    expect(backend.normalize_tokens(formula.value)).to eq([
      math::Function::Power.new(math::Function::Sin.new(symbol("x")), number(2)),
    ])
    tree = display_root(formula)
    power = named(tree, "power")
    application = named(power, "apply")
    expect(symbol_leaf?(application, "x")).to be(true)
    expect(symbol_leaf?(application, "2")).to be(false)
    expect(symbol_leaf?(power, "2")).to be(true)
  end

  it "binds a fenced argument as a whole and leaves a following bare factor outside" do
    formula = math.parse("sin^2 (x+y)", :asciimath)
    normalized = backend.normalize_tokens(formula.value)
    function = normalized.first.parameter_one
    expect(function).to be_a(math::Function::Sin)
    expect(function.parameter_one).to eq(formula.value[1])
    expect(function.parameter_one).to be_a(math::Function::Fenced)
    application = named(display_root(formula), "apply")
    expect(symbol_leaf?(application, "x")).to be(true)
    expect(symbol_leaf?(application, "y")).to be(true)

    formula = model(math::Function::Power.new(math::Function::Sin.new, number(2)), symbol("x"), symbol("y"))
    expect(backend.normalize_tokens(formula.value)).to eq([
      math::Function::Power.new(math::Function::Sin.new(symbol("x")), number(2)), symbol("y"),
    ])
    expect(symbol_leaf?(named(display_root(formula), "apply"), "y")).to be(false)
  end

  it "preserves nested powers and explicit function-application markers" do
    function = math::Function::Sin.new(symbol("⁡"))
    power = math::Function::Power.new(math::Function::Power.new(function, number(2)), number(3))
    expected = math::Function::Power.new(
      math::Function::Power.new(math::Function::Sin.new(symbol("x")), number(2)), number(3),
    )
    expect(backend.normalize_tokens([power, symbol("x")])).to eq([expected])
    plain_power = math::Function::Power.new(math::Function::Sin.new, number(2))
    expect(backend.normalize_tokens([plain_power, math::Symbols::Funcapply.new, symbol("x")])).to eq([
      math::Function::Power.new(math::Function::Sin.new(symbol("x")), number(2)),
    ])
  end

  it "allows an unbounded integral to own a powered function body" do
    tree = display_root(math.parse("int sin^2 x", :asciimath))
    integrand = named(tree, "integrand")
    expect(symbol_leaf?(named(integrand, "apply"), "x")).to be(true)
    expect(named(integrand, "power")).not_to be_nil
  end

  it "reports absent or ambiguous body/argument operands without guessing" do
    [
      model(math::Function::Int.new),
      model(math::Function::Sum.new(number(0))),
      model(math::Function::Power.new(math::Function::Sin.new, number(2))),
      model(math::Function::Power.new(math::Function::Sin.new, number(2)), math::Symbols::Plus.new, symbol("x")),
    ].each do |formula|
      expect { display_root(formula) }.to raise_error(error, /missing operand|function application/)
    end
  end

  it "leaves stored models and their ordinary display unchanged after repeated binding" do
    ["int x", "sum_0 x", "sin^2 (x+y)"].each do |source|
      formula = math.parse(source, :asciimath)
      original = Marshal.dump(formula)
      first = formula.to_display(:unicodemath, tree: :semantic)
      expect(Marshal.dump(formula)).to eq(original)
      # The ordinary display writer maintains its own @values cache. Check
      # semantic purity independently on both pristine and cached formulas.
      display = formula.to_display(:asciimath)
      cached = Marshal.dump(formula)
      expect(formula.to_display(:unicodemath, tree: :semantic)).to eq(first)
      expect(Marshal.dump(formula)).to eq(cached)
      expect(formula.to_display(:asciimath)).to eq(display)
    end
  end

  it "preserves numeric rejection of unbounded, partly bounded and powered-function siblings" do
    unsupported = Plurimath::Errors::Evaluation::UnsupportedExpressionError
    ["sum x", "sum_0 x", "int x", "sin^2 x"].each do |source|
      formula = math.parse(source, :asciimath)
      before = begin
        formula.evaluate(x: 2)
      rescue unsupported => exception
        [exception.class, exception.message]
      end
      expect(before).to be_a(Array)
      formula.to_display(:unicodemath, tree: :semantic)
      expect { formula.evaluate(x: 2) }.to raise_error(before[0], before[1])
    end
    expect(math.parse("sum_(i=1)^3 i", :asciimath).evaluate).to eq(6)
    expect(math.parse("sin(1)^2", :asciimath).evaluate).to be_within(0.000001).of(::Math.sin(1)**2)
  end
end
