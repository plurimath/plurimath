require "spec_helper"

RSpec.describe Plurimath::UnicodeMath::Parse do
  it "keeps UnicodeMath grammar rules off unrelated parser classes" do
    described_class.new

    [Parsanol::Parser, Parslet::Parser].each do |parser_class|
      expect(parser_class.method_defined?(:atoms)).to be(false)
      expect(parser_class.method_defined?(:op_unary)).to be(false)
    end
  end

  it "defines reusable rules on the module that declares them" do
    expect(described_class.instance_method(:atoms).owner)
      .to eq(Plurimath::UnicodeMath::ParsingRules::CommonRules)
  end

  modes = %i[ruby native].freeze
  [
    ["0xFF", :en, "FF", 16],
    ["1.2", :en, "1.2", nil],
    ["1٫2", :ar, "1٫2", nil],
  ].each do |input, locale, value, base|
    modes.each do |mode|
      context "with the #{mode} engine for #{input}" do
        before do
          skip "Parsanol native engine is unavailable" if mode == :native && !Parsanol::Native.available?
        end

        it "preserves the Formula for #{input}" do
          Plurimath.with_configuration do |config|
            config.locale = locale
            text = Plurimath::UnicodeMath::Parser.new(input).text
            tree = described_class.new.parse(text, mode: mode)
            nodes = Plurimath::UnicodeMath::Transform.new.apply(tree)
            formula = Plurimath::Math::Formula.new(Array(nodes))
            expected = Plurimath::Math::Number.new(value, base: base)

            expect(formula.value).to eq([expected])
          end
        end
      end
    end
  end
end
