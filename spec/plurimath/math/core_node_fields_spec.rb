# frozen_string_literal: true

require "spec_helper"

# The common Function holders declare their node fields through
# lutaml-model. Each field is a polymorphic Core view of the existing
# instance variable, so writers keep reading the same storage.
RSpec.describe Plurimath::Math::Core, ".node_fields" do
  let(:math) { Plurimath::Math }
  let(:function) { Plurimath::Math::Function }
  let(:one) { math::Number.new("1") }
  let(:x) { math::Symbols::Symbol.new("x") }

  def nodes
    fn = function
    row = fn::Tr.new([fn::Td.new([one]), fn::Td.new([x])])
    [
      fn::Sin.new(one),
      fn::Frac.new(x, fn::Sin.new(one)),
      fn::Log.new(one, x),
      fn::Sum.new(fn::Frac.new(x, one), one, fn::Cos.new(x)),
      fn::Nary.new(x, one, one, x, { type: "subSup" }),
      fn::Table.new([row], "(", ")", {}),
      fn::Table::Matrix.new([fn::Tr.new([fn::Td.new([one])])]),
      fn::Text.new("abc"),
      fn::FontStyle::Bold.new(x, "bold"),
    ]
  end

  it "round-trips nested nodes through a hash and JSON" do
    nodes.each do |node|
      expect(node.class.from_hash(node.to_hash)).to eq(node)
      expect(node.class.from_json(node.to_json)).to eq(node)
    end
  end

  it "brings back the same node classes" do
    sum = nodes[3]
    copy = sum.class.from_json(sum.to_json)
    expect(copy.parameter_one).to be_a(function::Frac)
    expect(copy.parameter_three).to be_a(function::Cos)
  end

  it "keeps the Table parens and options" do
    table = function::Table.new([], "(", ")", { a: 1 })
    copy = table.class.from_json(table.to_json)
    expect(copy.open_paren).to eq(table.open_paren)
    expect(copy.close_paren).to eq(table.close_paren)
    expect(copy.options).to eq(a: 1)
  end

  it "keeps String values in the text key" do
    expect(function::Text.new("abc").to_hash).to include("parameter_one_text" => "abc")
  end

  it "computes the discriminator and never stores it" do
    node = function::Sin.new(one)
    expect(node.to_hash["__class"]).to eq("Plurimath::Math::Function::Sin")
    expect(node.variables).to eq(%i[@parameter_one])
  end

  it "resolves only node class names" do
    map = math::Core::NODE_CLASS_MAP
    expect(map["Plurimath::Math::Function::Sin"]).to eq("Plurimath::Math::Function::Sin")
    expect(map["Plurimath::Math::Utility"]).to be_nil
    expect(map["Kernel"]).to be_nil
  end

  # Concrete node types on attributes would make the class graph cyclic
  # (a Frac holding a Frac), which lutaml-model resolves very slowly.
  it "types every node field as Core, so the class graph has no cycle" do
    holders = [function::UnaryFunction, function::BinaryFunction,
               function::TernaryFunction, function::Nary, function::Table,
               function::Tr, function::Td, function::Multiscript]
    holders.each do |holder|
      types = holder.attributes.values.map(&:type)
      node_types = types.select { |type| type.is_a?(Class) && type <= math::Core }
      expect(node_types).to all(eq(math::Core))
    end
  end
end
