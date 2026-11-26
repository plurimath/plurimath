# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Math::Function::Color, engine_loop: :always do
  def symbol(value)
    Plurimath::Math::Symbols::Symbol.new(value)
  end

  def runs(nodes)
    Array(nodes).flatten.flat_map do |node|
      next [] unless node.respond_to?(:name)
      next [node] if node.name == "m:r"

      runs(node.nodes)
    end
  end

  def properties(run)
    run.nodes.find { |node| node.respond_to?(:name) && node.name == "w:rPr" }
  end

  def attribute(node, key)
    node[key] || node[key.split(":").last]
  end

  def render(color, content = symbol("y"), options = {})
    described_class.new(symbol(color), content, options)
      .to_omml_without_math_tag(true, options: {})
  end

  { "red" => "FF0000", "blue" => "0000FF", "#1a2b3c" => "1A2B3C", "#abc" => "AABBCC" }.each do |color, hex|
    it "preserves #{color} as a WordprocessingML run property" do
      node = render(color).first
      expect(node.nodes.map(&:name)).to eq(["w:rPr", "m:t"])
      expect(properties(node).nodes.first.name).to eq("w:color")
      expect(attribute(properties(node).nodes.first, "w:val")).to eq(hex)
      expect(node.nodes.last.nodes).to eq(["y"])
    end
  end

  it "colors every run in a fraction while retaining existing math styles" do
    content = Plurimath::Math::Function::Frac.new(
      Plurimath::Math::Function::FontStyle::Bold.new(Plurimath::Math::Number.new("1")), symbol("x")
    )
    nodes = runs(render("red", content))
    expect(nodes.length).to eq(2)
    expect(nodes.map { |run| attribute(properties(run).nodes.first, "w:val") })
      .to eq(["FF0000", "FF0000"])
    expect(nodes.first.nodes.first.name).to eq("m:rPr")
  end

  it "keeps an inner color in preference to its outer color" do
    inner = described_class.new(symbol("blue"), symbol("x"))
    content = Plurimath::Math::Formula.new([inner, symbol("y")])
    expect(runs(render("red", content)).map { |run| attribute(properties(run).nodes.first, "w:val") })
      .to eq(["0000FF", "FF0000"])
  end

  it "writes a background color as shading rather than changing text color" do
    prop = properties(render("red", symbol("x"), backgroundcolor: true).first).nodes.first
    expect(prop.name).to eq("w:shd")
    expect(attribute(prop, "w:fill")).to eq("FF0000")
  end

  it "does not add a visible run for missing content" do
    expect(render("red", nil)).to eq([])
  end

  it "refuses an unrepresentable color instead of silently dropping it" do
    expect { render("transparent") }
      .to raise_error(Plurimath::Error, /Unsupported OMML color/)
  end

  it "declares the WordprocessingML namespace in the complete formula" do
    node = described_class.new(symbol("red"), symbol("y"))
    output = Plurimath::Math::Formula.new([node]).to_omml
    expect(output).to include('xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"')
    expect(output).to include('<w:color w:val="FF0000"')
  end

  it "leaves the source expression unchanged" do
    node = described_class.new(symbol("red"), symbol("y"))
    before = node.to_mathml_without_math_tag(false, options: {})
    node.to_omml_without_math_tag(true, options: {})
    expect(node.to_mathml_without_math_tag(false, options: {})).to eq(before)
  end
end
