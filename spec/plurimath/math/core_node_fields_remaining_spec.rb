# frozen_string_literal: true

require "spec_helper"

# The remaining node holders declare their fields through Core.node_fields:
# Formula and its Mrow and Mstyle, Fenced, Text's lang, the attribute and
# option hashes, the Abs family's parens, Uncertainty, Unitsml and the
# Semantics annotations.
RSpec.describe Plurimath::Math::Core, ".node_fields" do
  let(:math) { Plurimath::Math }
  let(:function) { Plurimath::Math::Function }
  let(:one) { math::Number.new("1") }
  let(:x) { math::Symbols::Symbol.new("x") }

  def round_trip(node)
    [node.class.from_hash(node.to_hash), node.class.from_json(node.to_json)]
  end

  def uncertainty
    function::Uncertainty.new(math::Number.new("1.23"), category: :expanded,
                                                        magnitude: math::Number.new("0.04"),
                                                        coverage_factor: math::Number.new("2"),
                                                        unit: function::Unitsml.new("kg"))
  end

  def abs_with_parens
    function::Abs.new(x).tap do |abs|
      abs.open_paren = true
      abs.close_paren = false
    end
  end

  def nodes
    paren = math::Symbols::Paren
    [
      math::Formula.new([function::Sin.new(one), x], false),
      math::Formula::Mrow.new([x, one]),
      math::Formula::Mstyle.new([x]).tap { |style| style.displaystyle = false },
      function::Fenced.new(paren::Lround.new, [x, one], paren::Rsquare.new, { separators: "," }),
      function::Bar.new(x, { accent: true }),
      function::Ddot.new(x, { accent: true }),
      function::Frac.new(x, one, { bevelled: "true" }),
      abs_with_parens,
      function::Ceil.new(one),
      uncertainty,
      function::Unitsml.new("m*s^-1"),
      function::Semantics.new(x, [{ annotation: [math::Symbols::Symbol.new("y")] }]),
      function::Msgroup.new([x, one]),
      function::Sqrt.new(function::Sum.new(x, one, x)),
    ]
  end

  it "round-trips each holder through a hash and JSON" do
    nodes.each do |node|
      expect(round_trip(node)).to all(eq(node))
    end
  end

  it "keeps the fields that == does not compare" do
    text = function::Text.new("abc", lang: :omml)
    round_trip(text).each { |copy| expect(copy.instance_variable_get(:@lang)).to eq(:omml) }

    abs = abs_with_parens
    round_trip(abs).each do |copy|
      expect([copy.open_paren, copy.close_paren]).to eq([true, false])
    end

    formula = math::Formula.new([x], display_style: false)
    formula.input_string = "x"
    round_trip(formula).each do |copy|
      expect([copy.displaystyle, copy.input_string]).to eq([false, "x"])
    end
  end

  it "renders the copies as the originals" do
    nodes.each do |node|
      formula = math::Formula.new([node])
      round_trip(formula).each do |copy|
        expect(copy.to_latex).to eq(formula.to_latex)
        expect(copy.to_mathml).to eq(formula.to_mathml)
      end
    end
  end

  it "keeps an array of nodes held in a single-node field" do
    node = function::Sin.new([x, one])
    round_trip(node).each { |copy| expect(copy.parameter_one).to eq([x, one]) }
  end

  it "keeps attribute hashes and empty arrays held in node fields" do
    td = function::Td.new([], { columnalign: "center" })
    round_trip(td).each do |copy|
      expect(copy.parameter_one).to eq([])
      expect(copy.parameter_two).to eq(columnalign: "center")
    end
  end

  it "keeps symbol keys in symbol options through JSON" do
    symbol = math::Symbols::Symbol.new("x", options: { rspace: "0em" })
    expect(symbol.class.from_json(symbol.to_json).options).to eq(rspace: "0em")
  end

  # F3: a node field may be typed only by the Core hub. A concrete node type
  # would make the class graph cyclic, which lutaml-model resolves slowly.
  it "types every node field of every node class as Core" do
    Plurimath::Catalog.classes # loads the whole function and symbol trees
    holders = [math::Core, *descendants(math::Core)]
    expect(holders.size).to be > 1000
    offenders = holders.flat_map do |holder|
      holder.attributes.filter_map do |name, attribute|
        type = attribute.type
        next unless type.is_a?(Class) && type <= Lutaml::Model::Serializable
        next if type == math::Core

        "#{holder}##{name}: #{type}"
      end
    end
    expect(offenders).to eq([])
  end

  def descendants(klass)
    Array(klass.descendants).flat_map { |sub| [sub, *descendants(sub)] }.uniq
  end
end
