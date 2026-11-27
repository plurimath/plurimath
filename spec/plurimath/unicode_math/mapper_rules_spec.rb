require "spec_helper"
require "umath"

RSpec.describe Plurimath::UnicodeMath::Mapper::Rules do
  # A subclass inherits the rules but none of the recorded keys, so it tries
  # every rule on every node: the full scan Parsanol::Transform does.
  let(:full_scan) { Class.new(described_class) }

  def tree(input)
    Plurimath::UnicodeMath::Parser.load_umath
    Plurimath::UnicodeMath::Mapper.new.call(Umath.parse(input))
  end

  it "builds the same Formula nodes as the full rule scan" do
    [
      "a+b=c",
      "x_a^b",
      "_a^b x",
      "(a+b)^2",
      "√(a+b)",
      "∑_(i=1)^n i",
      "ⅆy/ⅆx=[y-G(x)]/a(x,y)",
      "1|x|={█(&x&\"if \"x≥0@-&x&\"if \"x<0)〗",
    ].each do |input|
      expect(described_class.new.apply(tree(input))).to eq(full_scan.new.apply(tree(input)))
    end
  end

  it "tries only the rules whose Hash pattern has the node's keys" do
    candidates = described_class.candidate_rules(%i[td])
    expect(candidates.size).to be < described_class.class_rules.size
    expect(candidates).to eq(described_class.class_rules & candidates)
    expect(described_class.candidate_rules(%i[sup base sub]))
      .to eq(described_class.candidate_rules(%i[base sub sup]))
  end

  it "keeps the full scan for rules it did not see defined" do
    expect(full_scan.candidate_rules(%i[td])).to eq(full_scan.class_rules)
  end
end
