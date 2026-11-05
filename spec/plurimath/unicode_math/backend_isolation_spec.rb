require "spec_helper"
require "unicodemath"

RSpec.describe Plurimath::UnicodeMath::Parse do
  it "parses through the unicodemath gem, with no in-tree grammar or transform" do
    expect(described_class.ancestors).not_to include(Parsanol::Parser)
    expect(Plurimath::UnicodeMath.const_defined?(:Transform, false)).to be(false)
    expect(Plurimath::UnicodeMath.const_defined?(:ParsingRules, false)).to be(false)

    allow(Unicodemath).to receive(:parse).and_call_original
    Plurimath::Math.parse("a/b", :unicode)

    expect(Unicodemath).to have_received(:parse).once
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
            nodes = Plurimath::UnicodeMath::Mapper::Rules.new.apply(tree)
            formula = Plurimath::Math::Formula.new(Array(nodes))
            expected = Plurimath::Math::Number.new(value, base: base)

            expect(formula.value).to eq([expected])
          end
        end
      end
    end
  end
end
