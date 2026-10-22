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

    def parslet_tree(raw)
      text = Plurimath::Asciimath::Parser.new(raw).text
      [Plurimath::Asciimath::Parse.new.parse(text), text]
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

      it "rejects a leaf whose offset is not a byte offset into the input" do
        char_offset_leaf = Parsanol::Slice.new(1, "β", "αβ")

        expect { described_class.convert(char_offset_leaf, "αβ") }
          .to raise_error(described_class::OffsetError, /byte 1/)
      end
    end

    describe ".convert parity with Asciimath::Parse" do
      [
        "", "  ", "a", "x+ ", 'a ""', "text(αβ) ", "sin x  ", "αβ + γ ",
        "a\n b ", "a_ ", "x^", "1,2, 3", "(a) ", "mat(1,2) b", "ubrace(x) ",
        "{: a :}", "(: x :)", "|: x :|", "0x1F + 0b101", "sum_(i=1)^n i^2",
        "lim_(x->∞) 1/x", "bb \"A\" ℝ", "obrace(1+2)^\"3\"", "a/b\n\nc"
      ].each do |raw|
        it "rebuilds the Parslet tree for #{raw.inspect}" do
          tree, text = parslet_tree(raw)
          converted = described_class.convert(parsanol_tree(tree, text), text)

          expect(snapshot(converted)).to eq(snapshot(tree))
        end
      end
    end
  end

  describe Plurimath::Asciimath::Parser do
    around do |example|
      saved = ENV.fetch(described_class::ENGINE_ENV, nil)
      example.run
    ensure
      if saved.nil?
        ENV.delete(described_class::ENGINE_ENV)
      else
        ENV[described_class::ENGINE_ENV] = saved
      end
    end

    describe ".engine" do
      it "defaults to parslet" do
        ENV.delete(described_class::ENGINE_ENV)

        expect(described_class.engine).to eq("parslet")
      end

      it "rejects an unknown engine" do
        ENV[described_class::ENGINE_ENV] = "treetop"

        expect { described_class.engine }.to raise_error(ArgumentError, /treetop/)
      end
    end

    describe "#parse with PLURIMATH_ASCIIMATH_ENGINE=amath" do
      # Stands in for the amath gem until it is published: answers with the
      # Parsanol-shaped tree for the same input and records the options.
      let(:fake_amath) do
        Module.new do
          class << self
            attr_reader :calls

            def parse(text, **options)
              (@calls ||= []) << [text, options]
              tree = Plurimath::Asciimath::Parse.new.parse(text)
              to_parsanol(tree, text)
            end

            def to_parsanol(node, input)
              case node
              when Hash then node.to_h { |k, v| [k, to_parsanol(v, input)] }
              when Array then node.map { |v| to_parsanol(v, input) }
              when Parslet::Slice
                node.to_s.empty? ? "" : Parsanol::Slice.new(node.position.bytepos, node.to_s, input)
              else node
              end
            end
          end
        end
      end

      before { stub_const("Amath", fake_amath) }

      [
        "sum_(i=1)^n i^2", "αβ + γ", "text(a b) {: x :}", "", "1.5 + 2,3",
        "mat(1,2;3,4)", "f(x) = sin x / cos x"
      ].each do |raw|
        it "builds the same formula as the parslet engine for #{raw.inspect}" do
          ENV[described_class::ENGINE_ENV] = "parslet"
          expected = described_class.new(raw).parse
          ENV[described_class::ENGINE_ENV] = "amath"
          actual = described_class.new(raw).parse

          expect(actual).to eq(expected)
          expect(Amath.calls.last.first).to eq(described_class.new(raw).text)
        end
      end

      it "passes the configured decimal marker to amath" do
        ENV[described_class::ENGINE_ENV] = "amath"
        locale = Plurimath.configuration.locale
        Plurimath.configuration.locale = :fr

        described_class.new("1,5").parse

        expect(Amath.calls.last.last).to eq(decimal: ",")
      ensure
        Plurimath.configuration.locale = locale
      end
    end
  end
end
