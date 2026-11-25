require "spec_helper"
require "open3"
require "rbconfig"

RSpec.describe "Display-tree helper loading", if: RUBY_ENGINE != "opal", engine_loop: :once do
  %w[ox oga].each do |engine|
    it "loads helpers only on tree use with #{engine}" do
      code = <<~'CODE'
        require "json"
        require "plurimath"
        loaded = -> { $LOADED_FEATURES.grep(%r{/(core|model_helper)/tree_helpers\.rb$}) }
        cold = loaded.call
        formula = Plurimath::Math.parse("sin(x) + frac(1)(2)", :asciimath)
        writers = %i[to_asciimath to_latex to_mathml to_omml to_html to_unicodemath]
        before = writers.to_h { |writer| [writer, formula.public_send(writer)] }
        formula.to_mathml(intent: true)
        helper = Plurimath::Math::ModelHelper
        helper.validate_left_right([formula])
        helper.notations_to_mask("box")
        converted = loaded.call
        tree = formula.to_display(:asciimath)
        repeated = formula.to_display(:asciimath)
        core = Plurimath::Math::Core
        child = Class.new(core) do
          def gsub_spacing(...)
            super
          end
        end
        child_helper = Class.new(helper) do
          def self.validate_math_zone(...)
            super
          end
        end
        puts JSON.generate(cold: cold, converted: converted,
          tree: tree, repeated: repeated, loaded: loaded.call.size,
          before: before, after: writers.to_h { |writer| [writer, formula.public_send(writer)] },
          spacing: child.new.gsub_spacing("|_", true),
          nil_zone: child_helper.validate_math_zone(nil, lang: :asciimath),
          copies: [core.ancestors.count { |mod| mod == core::TreeHelpers },
                   helper.singleton_class.ancestors.count { |mod| mod == helper::TreeHelpers }],
          public_private_helpers: %i[symbol_to_text math_display_text_objects].map { |name| helper.respond_to?(name) },
          private_helpers: %i[symbol_to_text math_display_text_objects].map { |name| helper.singleton_class.private_method_defined?(name) })
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
      expect(result.fetch("loaded")).to eq(2)
      expect(result.fetch("copies")).to eq([1, 1])
      expect(result.fetch("spacing")).to eq("  ")
      expect(result.fetch("nil_zone")).to be(false)
      expect(result.fetch("public_private_helpers")).to eq([false, false])
      expect(result.fetch("private_helpers")).to eq([true, true])
    end
  end

  it "keeps private helpers inaccessible through their public receiver" do
    helper = Plurimath::Math::ModelHelper
    expect { helper.symbol_to_text(nil, lang: :asciimath, options: {}) }
      .to raise_error(NoMethodError, /private method/)
    expect(helper.filter_math_zone_values(nil, lang: :asciimath)).to eq([])
    expect { helper.math_display_text_objects(nil) }
      .to raise_error(NoMethodError, /private method/)
  end
end
