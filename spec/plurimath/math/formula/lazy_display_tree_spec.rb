require "spec_helper"
require "open3"
require "rbconfig"

RSpec.describe "Display-tree stage loading", if: RUBY_ENGINE != "opal", engine_loop: :once do
  it "preserves errors from the public display entrypoint" do
    formula = Plurimath::Math.parse("x", :asciimath)
    expect { formula.to_display(:html) }
      .to raise_error(Plurimath::Math::InvalidTypeError, /Invalid type provided: html/)
    expect { formula.to_display(:asciimath, tree: :unknown) }
      .to raise_error(ArgumentError, "Unknown display tree: :unknown")
  end

  %w[ox oga].each do |engine|
    it "defers tree writers through ordinary and intent conversion with #{engine}" do
      code = <<~'CODE'
        require "json"
        require "plurimath"
        loaded = -> { $LOADED_FEATURES.grep(%r{/display_tree_methods\.rb$}) }
        cold = loaded.call
        formula = Plurimath::Math.parse("sin(x) + frac(1)(2)", :asciimath)
        writers = %i[to_asciimath to_latex to_mathml to_omml to_html to_unicodemath]
        before = writers.to_h { |writer| [writer, formula.public_send(writer)] }
        formula.to_mathml(intent: true)
        converted = loaded.call
        subclass = Class.new(Plurimath::Math::Formula) do
          def to_display(...)
            super
          end
        end
        child = subclass.new(formula.value)
        tree = child.to_display(:asciimath)
        repeated = child.to_display(:asciimath)
        classes = [Plurimath::Math::Formula,
                   Plurimath::Math::Function::UnaryFunction,
                   Plurimath::Math::Function::BinaryFunction,
                   Plurimath::Math::Function::TernaryFunction,
                   Plurimath::Math::Symbols::Symbol]
        # Exercise the shared writers directly as parser stages can choose
        # specialized nodes for the equivalent input text.
        leaf = Plurimath::Math::Symbols::Symbol.new("x")
        nodes = [leaf, Plurimath::Math::Function::Sin.new(leaf),
                 Plurimath::Math::Function::Frac.new(leaf, Plurimath::Math::Number.new("2")),
                 Plurimath::Math::Function::Int.new(leaf)]
        nodes.each { |node| node.to_asciimath_math_zone("", false, true, options: {}) }
        puts JSON.generate(cold: cold, converted: converted,
          tree: tree, repeated: repeated,
          after: writers.to_h { |writer| [writer, formula.public_send(writer)] },
          before: before, loaded: loaded.call.size,
          copies: classes.map { |klass| klass.ancestors.count { |mod| mod == klass.const_get(:DisplayTreeMethods, false) } })
      CODE
      out, err, status = Open3.capture3(
        { "PLURIMATH_OGA" => engine == "oga" ? "1" : nil, "PLURIMATH_LEPTRIS" => nil },
        RbConfig.ruby, "-Ilib", "-e", code,
      )
      expect(status).to be_success, err
      result = JSON.parse(out)
      expect(result.values_at("cold", "converted")).to eq([[], []])
      expect(result.fetch("tree")).to include("|_ Math zone", "function apply")
      expect(result.fetch("repeated")).to eq(result.fetch("tree"))
      expect(result.fetch("after")).to eq(result.fetch("before"))
      expect(result.fetch("loaded")).to eq(5)
      expect(result.fetch("copies")).to eq([1, 1, 1, 1, 1])
    end
  end
end
