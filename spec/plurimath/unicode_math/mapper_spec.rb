require "spec_helper"
require "umath"

RSpec.describe Plurimath::UnicodeMath::Mapper do
  # Every Hash's keys, in order, depth first.
  def key_orders(tree, into = [])
    case tree
    when Hash
      into << tree.keys
      tree.each_value { |value| key_orders(value, into) }
    when Array then tree.each { |value| key_orders(value, into) }
    end
    into
  end

  def mapped(input)
    Plurimath::UnicodeMath::Parser.load_umath
    described_class.new.call(Umath.parse(input))
  end

  def grammar_tree(input)
    Plurimath::UnicodeMath::Parse.new.parse(Plurimath::UnicodeMath::Parser.new(input).text)
  end

  describe "capture order" do
    [
      "1M_1 M_2",
      "a+b=c",
      "1\\mitBbbd\\equiv\\dd",
      "sin a + cos▒² α",
      "ⅆy/ⅆx=[y-G(x)]/a(x,y)",
      "(a+b)^2",
      "x_a^b",
      "_a^b x",
      "1|x|={█(&x&\"if \"x≥0@-&x&\"if \"x<0)〗",
    ].each do |input|
      it "lists each Hash's keys in the grammar's capture order for #{input}" do
        expect(key_orders(mapped(input))).to eq(key_orders(grammar_tree(input)))
      end
    end

    it "keeps the grammar's fixed order where it allows only one" do
      # Declared alphabetically these would be expr before factor, and
      # operator after expr.
      tree = mapped("a+b")
      expect(tree.keys).to eq(%i[factor expr])
      expect(tree[:expr].keys).to eq(%i[operator expr])
    end

    it "uses the declared order where the grammar allows either and the model does not say" do
      # x^b_a captures sup before sub, x_a^b sub before sup; both give the
      # same model, so both map with sub first.
      expect(Umath.parse("x^b_a")).to eq(Umath.parse("x_a^b"))
      expect(mapped("x^b_a")[:subsup_exp].keys).to eq(%i[base sub sup])
    end
  end
end
