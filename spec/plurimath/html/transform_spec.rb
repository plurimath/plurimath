require "spec_helper"

RSpec.describe Plurimath::Html::Transform do
  # A subclass inherits the rules but none of the recorded keys, so it tries
  # every rule on every node: the full scan Parsanol::Transform does.
  let(:full_scan) { Class.new(described_class) }

  def tree(input)
    parser = Plurimath::Html::Parser.new(input)
    nodes = Plurimath::Html::Parse.new.parse(parser.send(:normalized_text))
    JSON.parse(parser.send(:normalized_nodes, nodes).to_json, symbolize_names: true)
  end

  it "builds the same Formula nodes as the full rule scan" do
    [
      "a+b=c",
      "<i>x</i><sub>a</sub><sup>b</sup>",
      "(a+b)<sup>2</sup>",
      "&sum;<sub>i=1</sub><sup>n</sup>i",
      "<table><tr><td>a</td><td>b</td></tr></table>",
      "sin(x)",
      "0x1F",
    ].each do |input|
      expect(described_class.new.apply(tree(input))).to eq(full_scan.new.apply(tree(input)))
    end
  end

  it "tries only the rules whose Hash pattern has the node's keys" do
    candidates = described_class.candidate_rules(%i[text])
    expect(candidates.size).to be < described_class.class_rules.size
    expect(candidates).to eq(described_class.class_rules & candidates)
    expect(described_class.candidate_rules(%i[sub_sup sub_value sup_value]))
      .to eq(described_class.candidate_rules(%i[sup_value sub_sup sub_value]))
  end

  it "keeps the full scan for rules it did not see defined" do
    expect(full_scan.candidate_rules(%i[text])).to eq(full_scan.class_rules)
  end
end
