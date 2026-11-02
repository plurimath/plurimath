# frozen_string_literal: true

require "spec_helper"

# SliceAdapter::Walker#walk and Asciimath::Transform#apply keep their own
# stack instead of recursing. These specs hold them to the recursive versions
# they replace, and check that a very deep tree no longer overflows.
RSpec.describe Plurimath::Asciimath do
  describe "iterative tree traversal" do
    # The recursive walk the iterative one replaced.
    let(:recursive_walker) do
      Class.new(Plurimath::Asciimath::SliceAdapter::Walker) do
        def walk(node)
          case node
          when Hash then node.to_h { |key, value| [symbol_key(key), walk(value)] }
          when Array then node.map { |value| walk(value) }
          else leaf(node)
          end
        end
      end
    end

    # Parslet's own recursive Transform#apply, with the same rules.
    let(:recursive_transform) do
      Class.new(Plurimath::Asciimath::Transform) do
        def apply(obj, context = nil)
          Parslet::Transform.instance_method(:apply).bind_call(self, obj, context)
        end
      end
    end

    def amath_tree(text)
      require "amath"
      Amath.parse(text, decimal: Plurimath.configuration.decimal)
    end

    def recursive_convert(tree, text)
      line_cache = Parslet::Source::LineCache.new
      line_cache.scan_for_line_endings(0, text)
      recursive_walker.new(text, line_cache).walk(tree)
    end

    # Key order, array order, nil, and where each slice sits in the input.
    def snapshot(node)
      case node
      when Hash then [:hash, node.map { |key, value| [key, snapshot(value)] }]
      when Array then [:array, node.map { |value| snapshot(value) }]
      when Parslet::Slice
        [:slice, node.to_s, node.position.bytepos, node.line_and_column]
      else [node.class, node]
      end
    end

    # Parser's text preprocessing, then amath's raw tree.
    def preprocessed(text)
      Plurimath::Asciimath::Parser.new(text).text
    end

    inputs = [
      "",
      "x",
      "1 + 2 - 3",
      "x + y + z + w + v",
      "sum_(i=1)^n i^2",
      "prod_(k=0)^oo a_k",
      "int_0^1 f(x) dx",
      "lim_(x->0) sin x / x",
      "frac(a)(b) + 1/2",
      "(a+b)/(c-d)",
      "sqrt(x^2 + y^2)",
      "root(3)(27)",
      "[[1, 2], [3, 4]]",
      "((a, b), (c, d))",
      "{(x, x >= 0), (-x, x < 0):}",
      "|x| + ||v||",
      "text(if ) x > 0 text( then) y",
      '"quoted text" + 1',
      "color(red)(x + y)",
      "bb(A) + cc(B) + mathfrak(C)",
      "hat(x) + bar(y) + vec(z) + dot(w)",
      "ustd(1.2, 0.1)",
      "uexp(10.0, 0.3)",
      "ucov(5, 4.9, 5.2)",
      "x = ustd(1.2, 0.1) + uexp(10.0, 0.3)",
      "left( x/2 right)",
      "left[ a right]",
      "sin^2 theta + cos^2 theta = 1",
      "alpha + beta + gamma -> delta",
      "e^(i pi) + 1 = 0",
      "obrace(1+2)^(3) + ubrace(a+b)_(c)",
      "x_1^2 + x_2^2 + cdots + x_n^2",
      "a \\ b, a in A, AA x EE y",
    ]

    inputs.each do |input|
      context "with #{input.inspect}" do
        let(:text) { preprocessed(input) }
        let(:tree) { amath_tree(text) }

        it "converts the amath tree as the recursive walk does" do
          expect(snapshot(Plurimath::Asciimath::SliceAdapter.convert(tree, text)))
            .to eq(snapshot(recursive_convert(tree, text)))
        end

        it "transforms the tree as Parslet's recursive apply does" do
          nodes = Plurimath::Asciimath::Parse.new.parse(text)
          iterative = Plurimath::Asciimath::Transform.new.apply(nodes)
          recursive = recursive_transform.new.apply(nodes)

          expect(iterative).to eq(recursive)
          expect(iterative.class).to eq(recursive.class)
          if recursive.respond_to?(:to_mathml)
            expect(iterative.to_mathml).to eq(recursive.to_mathml)
          end
        end
      end
    end

    it "applies child and node rules in Parslet's order" do
      calls = ->(transform_class) do
        seen = []
        transform = transform_class.new
        transform.define_singleton_method(:transform_elt) do |obj, context|
          seen << obj.inspect
          super(obj, context)
        end
        transform.apply({ a: [{ b: "x" }, "y"], c: { d: nil } }, { k: 1 })
        seen
      end

      expect(calls.call(Plurimath::Asciimath::Transform))
        .to eq(calls.call(recursive_transform))
    end

    context "with a tree 5000 levels deep" do
      let(:depth) { 5000 }

      def depth_of(node)
        levels = 0
        while node.is_a?(Hash) || node.is_a?(Array)
          node = node.is_a?(Hash) ? node.fetch(node.keys.first) : node.first
          levels += 1
        end
        [levels, node]
      end

      it "converts it with SliceAdapter without a SystemStackError" do
        tree = depth.times.reduce("") do |inner, level|
          level.even? ? { "zz_nested" => inner } : [inner]
        end
        result = Plurimath::Asciimath::SliceAdapter.convert(tree, "")
        levels, leaf = depth_of(result)

        expect(levels).to eq(depth)
        expect(leaf).to be_a(Parslet::Slice)
        expect(leaf.to_s).to eq("")
      end

      # Nested expr: [...] levels, the shape a long sum takes; each level
      # matches the expr rule, which flattens it.
      it "applies the Transform without a SystemStackError" do
        tree = (depth / 2).times.reduce(:leaf) { |inner, _| { expr: [inner] } }
        result = Plurimath::Asciimath::Transform.new.apply(tree)

        expect(result).to eq([:leaf])
      end
    end
  end
end
