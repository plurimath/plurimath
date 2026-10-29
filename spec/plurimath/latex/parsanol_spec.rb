# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Latex::Parser do
  let(:base_numbers) do
    { "0xFF" => ["FF", 16], "0b10" => ["2", 2], "0o17" => ["15", 8] }
  end
  let(:locale_numbers) { { fr: "1,5", ar: "1٫5" } }

  def ruby_formula(input)
    text = described_class.new(input).text
    tree = Plurimath::Latex::Parse.new.parse(text, mode: :ruby)
    value = Plurimath::Latex::Transform.new.apply(tree)
    Plurimath::Math::Formula.new(value)
  end

  context "when native parsing is available" do
    before do
      skip "Parsanol native extension unavailable" unless Parsanol::Native.available?
    end

    it "uses the native engine through the public parse entrypoint" do
      allow(Parsanol::Native).to receive(:parse).and_call_original

      formula = Plurimath::Math.parse('\\frac{1}{2}', :latex)

      expect(formula.to_latex).to eq('\\frac{1}{2}')
      expect(Parsanol::Native).to have_received(:parse)
    end

    it "preserves text and shared-prefix function output" do
      [
        '\\sinh{1}',
        '\\sin{1}',
        '\\text{hello world}',
      ].each do |input|
        expect(described_class.new(input).parse.to_latex).to eq(input)
      end
    end

    it "preserves Ruby model and rendered output for scalar and based numbers", :ruby_fallback do
      ["x", "12", "0xFF"].each do |input|
        native = described_class.new(input).parse
        ruby = ruby_formula(input)

        expect(native).to eq(ruby), input
        expect(native.to_latex).to eq(ruby.to_latex), input
        expect(native.to_mathml).to eq(ruby.to_mathml), input
      end
    end

    it "preserves the Ruby model and output for a fraction", :complex_fallback, :ruby_fallback do
      input = '\\frac{1}{2}'
      native = described_class.new(input).parse
      ruby = ruby_formula(input)

      expect(native).to eq(ruby)
      expect(native.to_latex).to eq(ruby.to_latex)
      expect(native.to_mathml).to eq(ruby.to_mathml)
    end
  end

  [true, false].each do |native|
    context(native ? "with the native engine" : "without the native extension", ruby_fallback: !native) do
      before do
        if native
          skip "Parsanol native extension unavailable" unless Parsanol::Native.available?
        else
          allow(Parsanol::Native).to receive(:available?).and_return(false)
        end
        allow(Parsanol::Native).to receive(:parse).and_call_original
      end

      it "retains base-prefixed numbers in the model" do
        base_numbers.each do |input, (value, base)|
          formula = described_class.new(input).parse

          expect(formula.value).to eq([Plurimath::Math::Number.new(value, base: base)])
        end
        expect(Parsanol::Native).not_to have_received(:parse) unless native
      end

      it "retains locale decimals after entity preprocessing" do
        locale_numbers.each do |locale, input|
          Plurimath.with_configuration do |config|
            config.locale = locale
            formula = described_class.new(input).parse

            expect(formula.value).to eq([Plurimath::Math::Number.new(input)])
          end
        end
        expect(Parsanol::Native).not_to have_received(:parse) unless native
      end

      it "rejects incomplete fractions with the parser error contract" do
        expect do
          described_class.new('\\frac{1}{').parse
        end.to raise_error(Parsanol::ParseFailed)
        expect(Parsanol::Native).not_to have_received(:parse) unless native
      end
    end
  end
end
