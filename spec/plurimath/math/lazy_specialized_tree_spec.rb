require "spec_helper"
require "open3"
require "rbconfig"

RSpec.describe "Specialized display-tree loading", if: RUBY_ENGINE != "opal", engine_loop: :once do
  %w[ox oga].product(%w[asciimath latex mathml omml unicodemath unitsml]).each do |engine, type|
    it "loads specialized #{type} writers on first use with #{engine}" do
      code = <<~'CODE'
        require "json"
        require "plurimath"
        math = Plurimath::Math
        functions = math::Function
        symbol = ->(value = "x") { math::Symbols::Symbol.new(value) }
        cell = -> { functions::Td.new([symbol.call]) }
        unitsml_only = ARGV.fetch(0) == "unitsml"
        # Unitsml loads its converter and unit catalog. Exercise its delegates
        # together in one cold process per engine instead of loading it for
        # every unrelated specialized writer.
        nodes = unitsml_only ? [functions::Unitsml.new("m")] : [
          functions::Color.new(symbol.call("red"), symbol.call),
          functions::Fenced.new("(", [symbol.call], ")"),
          functions::FontStyle.new(symbol.call, "bold"),
          functions::Left.new("("), functions::Right.new(")"),
          functions::Msgroup.new([symbol.call]),
          functions::Table.new([functions::Tr.new([cell.call])]),
          cell.call, functions::Text.new("alpha text"),
          functions::Tr.new([cell.call]),
          functions::Uncertainty.new(math::Number.new("2"),
            category: :standard, magnitude: math::Number.new("0.1")),
          functions::Vec.new(symbol.call),
        ]
        loaded = -> { $LOADED_FEATURES.grep(%r{/function/(color|fenced|font_style|left|right|msgroup|table|td|text|tr|uncertainty|unitsml|vec)/display_tree_methods\.rb$}) }
        cold = loaded.call
        # Normal conversion and intent must keep these tree modules unloaded.
        # Build the semantic tree directly: parser startup is covered by its
        # own stage specs and would be repeated for every writer/engine here.
        ordinary = math::Formula.new([
          functions::Sin.new(symbol.call), math::Symbols::Plus.new,
          functions::Frac.new(math::Number.new("1"), math::Number.new("2")),
        ])
        before = %i[to_asciimath to_latex to_mathml to_omml to_html to_unicodemath]
          .map { |writer| ordinary.public_send(writer) }
        ordinary.to_mathml(intent: true)
        converted = loaded.call
        types = unitsml_only ? %w[asciimath latex mathml omml unicodemath] : [ARGV.fetch(0)]
        result = types.flat_map do |type|
          method = :"to_#{type}_math_zone"
          nodes.reject! { |node| node.is_a?(functions::Color) && type != "omml" }
          nodes.reject! { |node| node.is_a?(functions::Vec) && type == "unicodemath" }
          nodes.map do |node|
            options = { options: {} }
            options[:display_style] = false if type == "omml" && !unitsml_only
            invoke = -> {
              begin
                node.public_send(method, "|_ ", true, false, **options)
              rescue NoMethodError => error
                # Existing FontStyle and Unitsml Unicode trees lack this helper.
                raise unless type == "unicodemath" && error.name == :dump_unicodemath
                { error: error.name }
              rescue ArgumentError => error
                # Unitsml's existing tree delegate omits the required style keyword.
                raise unless type == "omml" && unitsml_only &&
                  error.message == "missing keyword: :display_style"
                { error: error.message }
              end
            }
            first = invoke.call
            repeated = invoke.call
            node.singleton_class.prepend(Module.new do
              define_method(method) { |*args, **keywords| super(*args, **keywords) }
            end)
            via_super = invoke.call
            stage = node.class.const_get(:DisplayTreeMethods, false)
            [first == repeated && first == via_super,
             node.class.ancestors.count { |ancestor| ancestor == stage }]
          end
        end
        # Protected Formula helpers also support direct first use and stay protected.
        formula = math::Formula.new([symbol.call])
        formula.left_right_wrapper = true
        spacing = formula.send(:new_space, "", true)
        # A parsed unit delegates to a FontStyle tree as well as its own stage.
        puts JSON.generate(cold: cold, converted: converted, results: result,
          loaded: loaded.call.size, expected: unitsml_only ? 2 : nodes.size, spacing: spacing,
          protected: %i[new_space wrapable?].all? { |name| math::Formula.protected_method_defined?(name) },
          before: before, after: %i[to_asciimath to_latex to_mathml to_omml to_html to_unicodemath]
            .map { |writer| ordinary.public_send(writer) })
      CODE
      out, err, status = Open3.capture3(
        { "PLURIMATH_OGA" => engine == "oga" ? "1" : nil, "PLURIMATH_LEPTRIS" => nil },
        RbConfig.ruby, "-Ilib", "-e", code, type,
      )
      expect(status).to be_success, err
      result = JSON.parse(out)
      expect(result.values_at("cold", "converted")).to eq([[], []])
      expect(result.fetch("results")).to all(eq([true, 1]))
      expect(result.fetch("loaded")).to eq(result.fetch("expected"))
      expect(result.fetch("spacing")).to eq("|_ ")
      expect(result.fetch("protected")).to be(true)
      expect(result.fetch("after")).to eq(result.fetch("before"))
    end
  end

  %w[ox oga].each do |engine|
    it "loads Core diagnostics directly and keeps their helper private with #{engine}" do
      code = <<~'CODE'
        require "json"
        require "plurimath"
        core = Plurimath::Math::Core
        node = Plurimath::Math::Function::Sin.new(Plurimath::Math::Symbols::Symbol.new("x"))
        loaded = -> { $LOADED_FEATURES.grep(%r{/core/tree_helpers\.rb$}).size }
        cold = loaded.call
        values = node.to_ms_value
        variables = node.pretty_print_instance_variables
        puts JSON.generate(cold: cold, loaded: loaded.call, values: values,
          variables: variables, private: core.private_method_defined?(:parameters_to_ms_value),
          public: node.respond_to?(:parameters_to_ms_value))
      CODE
      out, err, status = Open3.capture3(
        { "PLURIMATH_OGA" => engine == "oga" ? "1" : nil, "PLURIMATH_LEPTRIS" => nil },
        RbConfig.ruby, "-Ilib", "-e", code,
      )
      expect(status).to be_success, err
      result = JSON.parse(out)
      expect(result.values_at("cold", "loaded")).to eq([0, 1])
      expect(result.fetch("values")).to eq([["x"]])
      expect(result.fetch("variables")).to include("@parameter_one")
      expect(result.fetch("private")).to be(true)
      expect(result.fetch("public")).to be(false)
    end
  end

  it "preserves inherited text overrides using super" do
    child = Class.new(Plurimath::Math::Function::Text) do
      def to_asciimath_math_zone(...)
        super
      end
    end
    expect(child.new("hello").to_asciimath_math_zone("|_ ", false, true, options: {}))
      .to eq("|_ \"hello\" text\n")
  end
end
