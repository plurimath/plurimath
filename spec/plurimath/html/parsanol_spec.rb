# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Html::Parser do
  let(:parser) { Plurimath::Html::Parse.new }
  let(:x_squared) do
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Symbols::Symbol.new("x"),
      Plurimath::Math::Number.new("2"),
    )
  end
  let(:inputs) do
    [
      html_of(Plurimath::Math::Number.new("2")),
      html_of(Plurimath::Math::Function::Text.new("abc")),
      html_of(x_squared),
    ]
  end

  def html_of(*nodes)
    Plurimath::Math::Formula.new(nodes).to_html.gsub(/\s/, "")
  end

  def children_of(node)
    return node if node.is_a?(Array)

    %i[value parameter_one parameter_two parameter_three].filter_map do |reader|
      node.public_send(reader) if node.respond_to?(reader)
    end
  end

  def collect(node, klass)
    return [] unless node.is_a?(Array) || node.is_a?(Plurimath::Math::Core)

    found = node.is_a?(klass) ? [node] : []
    found + children_of(node).flat_map { |child| collect(child, klass) }
  end

  def tree_for(input, mode)
    parser.parse(input, mode: mode)
  end

  def formula_for(tree)
    result = Plurimath::Html::Transform.new.apply(tree)
    result.is_a?(Plurimath::Math::Formula) ? result : Plurimath::Math::Formula.new(result)
  end

  describe "Plurimath::Math.parse(text, :html)" do
    it "retains the existing JSON nesting refusal" do
      expect do
        Plurimath::Math.parse("x" * 101, :html)
      end.to raise_error(Plurimath::Math::ParseError)
    end

    it "keeps Number values as Strings" do
      formula = Plurimath::Math.parse(html_of(Plurimath::Math::Number.new("2")), :html)
      values = collect(formula, Plurimath::Math::Number).map(&:value)

      expect(values).to eq(["2"])
      expect(values).to all(be_an_instance_of(String))
    end

    it "keeps Text values as Strings" do
      formula = Plurimath::Math.parse(html_of(Plurimath::Math::Function::Text.new("abc")), :html)
      values = collect(formula, Plurimath::Math::Function::Text).map(&:parameter_one)

      expect(values).to eq(%w[a b c])
      expect(values).to all(be_an_instance_of(String))
    end

    it "preserves sup formatting through an HTML round trip" do
      html = html_of(x_squared)

      expect(Plurimath::Math.parse(html, :html).to_html.gsub(/\s/, "")).to eq(html)
    end

    it "gives named, decimal and hex entities the same output" do
      outputs = %w[&alpha; &#945; &#x3b1;].map do |entity|
        Plurimath::Math.parse(entity, :html).to_mathml
      end

      expect(outputs.uniq.size).to eq(1)
    end
  end

  describe "matching closing-tag diagnostics" do
    let(:rejections) do
      ["<i>a</b>", "<i><b>a</i></b>", "&#x3b1;<i>a</b>", "α<i>a</b>"]
    end

    def rejection_position(input, mode)
      parser.parse(input, mode: mode)
      raise "expected mismatched closing tag to fail"
    rescue Parsanol::ParseFailed => e
      pending = [e.parse_failure_cause]
      positions = []
      until pending.empty?
        cause = pending.pop
        if cause.children.empty?
          positions << cause.position
        else
          pending.concat(cause.children)
        end
      end
      positions.max
    end

    it "preserves closing-tag failure positions with the Ruby backend" do
      expect(rejections.map { |input| rejection_position(input, :ruby) }).to eq([6, 9, 13, 8])
    end

    it "preserves closing-tag failure positions through actual native dispatch" do
      skip "Parsanol native backend unavailable" unless Parsanol::Native.available?
      allow(parser.root).to receive(:run_with_context).and_call_original

      expect(rejections.map { |input| rejection_position(input, :native) }).to eq([6, 9, 13, 8])
      expect(parser.root).not_to have_received(:run_with_context)
    end
  end

  describe "parser backends" do
    it "parses with the Ruby backend without native dispatch" do
      allow(Parsanol::Native).to receive(:parse).and_call_original
      inputs.each do |input|
        expect(formula_for(tree_for(input, :ruby)).to_html.gsub(/\s/, "")).to eq(input)
      end
      expect(Parsanol::Native).not_to have_received(:parse)
    end

    it "matches the Ruby backend through real native dispatch" do
      unless Parsanol::Native.available?
        skip "Parsanol native backend unavailable"
      end
      expect(parser.native_expressible?).to be(true)
      allow(Parsanol::Native).to receive(:parse).and_call_original
      inputs.each do |input|
        native = tree_for(input, :native)
        ruby = tree_for(input, :ruby)

        expect(native).to eq(ruby)
        expect(formula_for(native).to_mathml).to eq(formula_for(ruby).to_mathml)
      end
      expect(Parsanol::Native).to have_received(:parse).exactly(inputs.size).times
    end
  end
end
