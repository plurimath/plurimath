# frozen_string_literal: true

require "spec_helper"
require "parsanol"

RSpec.describe Plurimath::Asciimath do
  describe Plurimath::Asciimath::SliceAdapter do
    # Every observable property of a Parslet::Slice the Plurimath consumers or
    # error reporting can reach.
    def leaf_facts(slice)
      {
        class: slice.class,
        str: slice.to_s,
        to_str: slice.to_str,
        to_sym: slice.to_s.empty? ? nil : slice.to_sym,
        to_i: slice.to_i,
        to_f: slice.to_f,
        size: slice.size,
        offset: slice.offset,
        bytepos: slice.position.bytepos,
        line_and_column: slice.line_and_column,
        inspect: slice.inspect,
      }
    end

    # Deep structural snapshot: key order, array order, nil, and leaf facts.
    def snapshot(node)
      case node
      when Hash then node.map { |key, value| [key, snapshot(value)] }
      when Array then [:array, node.map { |value| snapshot(value) }]
      when Parslet::Slice then leaf_facts(node)
      else node
      end
    end

    # What amath (Parsanol) returns for the same parse: byte-offset
    # Parsanol::Slice leaves, and a bare "" for an empty match.
    def parsanol_tree(node, input)
      case node
      when Hash then node.to_h { |key, value| [key, parsanol_tree(value, input)] }
      when Array then node.map { |value| parsanol_tree(value, input) }
      when Parslet::Slice
        if node.to_s.empty?
          ""
        else
          Parsanol::Slice.new(node.position.bytepos, node.to_s, input)
        end
      else node
      end
    end

    def leaves(node, found = [])
      case node
      when Hash then node.each_value { |value| leaves(value, found) }
      when Array then node.each { |value| leaves(value, found) }
      else found << node
      end
      found
    end

    def keys(node, found = [])
      case node
      when Hash
        found.concat(node.keys)
        node.each_value { |value| keys(value, found) }
      when Array then node.each { |value| keys(value, found) }
      end
      found
    end

    describe ".convert on hand-built Parsanol trees" do
      let(:input) { "αβ + x_2\n1.5 y" }

      it "turns every leaf into a Parslet::Slice with a character offset" do
        tree = {
          expr: {
            sequence: { symbol: Parsanol::Slice.new(2, "β", input) },
            expr: { sequence: { number: Parsanol::Slice.new(11, "1.5", input) } },
          },
        }

        converted = described_class.convert(tree, input)
        beta = converted[:expr][:sequence][:symbol]
        number = converted[:expr][:expr][:sequence][:number]

        expect(beta).to be_an_instance_of(Parslet::Slice)
        expect(beta.offset).to eq(1)
        expect(beta.position.bytepos).to eq(2)
        expect(beta.line_and_column).to eq([1, 3])
        expect(number.offset).to eq(9)
        expect(number.line_and_column).to eq([2, 1])
        expect(number.to_f).to eq(1.5)
        expect(number.to_i).to eq(1)
        expect(number.inspect).to eq(%("1.5"@9))
      end

      it "behaves like the slice Parslet builds for the same text" do
        source = Parslet::Source.new(input)
        source.bytepos = 2
        parslet = source.consume(1)
        converted = described_class.convert(Parsanol::Slice.new(2, "β", input), input)

        expect(leaf_facts(converted)).to eq(leaf_facts(parslet))
        expect(converted).to eq("β")
        expect(converted).to eq(parslet)
        expect(converted.to_sym).to eq(:β)
      end

      it "gives a plain empty-input result as \"\"@0" do
        converted = described_class.convert("", "")

        expect(converted).to be_an_instance_of(Parslet::Slice)
        expect(converted.to_s).to eq("")
        expect(converted.offset).to eq(0)
        expect(converted.line_and_column).to eq([1, 1])
      end

      it "places a plain \"\" at the end of the previous leaf" do
        tree = { expr: { symbol: Parsanol::Slice.new(0, "αβ", "αβ"), rest: "" } }
        converted = described_class.convert(tree, "αβ")

        expect(converted[:expr][:rest].offset).to eq(2)
        expect(converted[:expr][:rest].position.bytepos).to eq(4)
      end

      it "keeps [], nil, key order and existing Parslet slices" do
        parslet = Parslet::Slice.new(Parslet::Position.new("ab", 1), "b", nil)
        tree = { "z" => [], a: nil, b: [Parsanol::Slice.new(0, "a", "ab"), parslet] }
        converted = described_class.convert(tree, "ab")

        expect(converted.keys).to eq(%i[z a b])
        expect(converted[:z]).to eq([])
        expect(converted[:a]).to be_nil
        expect(converted[:b].map(&:class)).to eq([Parslet::Slice, Parslet::Slice])
        expect(converted[:b].last).to equal(parslet)
      end

      it "keeps leaf positions and order through deeply nested containers" do
        text = "αβ"
        nested = Parsanol::Slice.new(2, "β", text)
        10_000.times { nested = { "expr" => [nested] } }

        converted = described_class.convert({ deep: nested, tail: "" }, text)
        leaf = converted[:deep]
        10_000.times { leaf = leaf.fetch(:expr).fetch(0) }

        expect(leaf).to be_an_instance_of(Parslet::Slice)
        expect(leaf.to_s).to eq("β")
        expect(leaf.offset).to eq(1)
        expect(converted[:tail].position.bytepos).to eq(4)
      end

      it "rejects a leaf whose offset is not a byte offset into the input" do
        char_offset_leaf = Parsanol::Slice.new(1, "β", "αβ")

        expect { described_class.convert(char_offset_leaf, "αβ") }
          .to raise_error(described_class::OffsetError, /byte 1/)
      end
    end

    describe ".convert on amath trees" do
      [
        "", "  ", "a", "x+ ", 'a ""', "text(αβ) ", "sin x  ", "αβ + γ ",
        "a\n b ", "a_ ", "x^", "1,2, 3", "(a) ", "mat(1,2) b", "ubrace(x) ",
        "{: a :}", "(: x :)", "|: x :|", "0x1F + 0b101", "sum_(i=1)^n i^2",
        "lim_(x->∞) 1/x", "bb \"A\" ℝ", "obrace(1+2)^\"3\"", "a/b\n\nc"
      ].each do |raw|
        it "gives Symbol keys and Parslet slices at their input offsets for #{raw.inspect}" do
          text = Plurimath::Asciimath::Parser.new(raw).text
          converted = described_class.convert(Amath.parse(text), text)

          expect(keys(converted)).to all(be_a(Symbol))
          leaves(converted).each do |leaf|
            expect(leaf).to be_an_instance_of(Parslet::Slice)
            bytepos = leaf.position.bytepos
            expect(text.byteslice(bytepos, leaf.to_s.bytesize)).to eq(leaf.to_s)
            expect(leaf.offset).to eq(text.byteslice(0, bytepos).length)
          end
        end
      end
    end
  end

  describe Plurimath::Asciimath::Parser do
    # Records each Amath.parse call and answers with the real amath result.
    let(:amath_calls) { [] }

    before do
      allow(Amath).to receive(:parse).and_wrap_original do |original, text, **options|
        amath_calls << [text, options]
        original.call(text, **options)
      end
    end

    it "parses the preprocessed text with amath" do
      raw = "text(a b) {: x :} + sum_(i=1)^n i^2"
      formula = described_class.new(raw).parse

      expect(formula).to be_a(Plurimath::Math::Formula)
      expect(amath_calls.last.first).to eq(described_class.new(raw).text)
      expect(formula.to_asciimath).to include("sum_(i = 1)^(n)")
    end

    it "passes the configured decimal marker to amath" do
      locale = Plurimath.configuration.locale
      Plurimath.configuration.locale = :fr

      described_class.new("1,5").parse

      expect(amath_calls.last.last).to eq(decimal: ",")
    ensure
      Plurimath.configuration.locale = locale
    end
  end

  it "reports an input amath rejects as Plurimath::Math::ParseError" do
    expect { Plurimath::Math.parse("a/", :asciimath) }
      .to raise_error(Plurimath::Math::ParseError)
  end
end
