require "spec_helper"
require "open3"
require "rbconfig"

# Each child starts before Formula loads: the parent engine loop and other
# intent examples must not hide an eager load of the optional stage.
RSpec.describe "Formula intent stage loading", if: RUBY_ENGINE != "opal", engine_loop: :once do
  %w[ox oga].each do |engine|
    it "defers intent processing until first use with #{engine}" do
      code = <<~'RUBY'
        require "json"
        require "plurimath"
        formula = Plurimath::Math.parse("ⅆf/ⅆx", :unicode)
        loaded = -> { $LOADED_FEATURES.any? { |file| file.end_with?("/formula/intent_processing.rb") } }
        before = loaded.call
        ordinary = formula.to_mathml
        %i[to_asciimath to_latex to_omml to_html to_unicodemath].each { |writer| formula.public_send(writer) }
        after_conversion = loaded.call
        intent = formula.to_mathml(intent: true)
        repeated = formula.to_mathml(intent: true)
        subclass = Class.new(Plurimath::Math::Formula)
        child = subclass.new(formula.value)
        puts JSON.generate(
          before: before, after_conversion: after_conversion, after_intent: loaded.call,
          ordinary: ordinary, intent: intent, repeated: repeated,
          default_after_intent: formula.to_mathml, subclass_intent: child.to_mathml(intent: true),
          copies: Plurimath::Math::Formula.ancestors.count { |ancestor| ancestor == Plurimath::Math::Formula::IntentProcessing },
          protected: Plurimath::Math::Formula.protected_method_defined?(:intent_post_processing)
        )
      RUBY
      out, err, status = Open3.capture3(
        { "PLURIMATH_OGA" => engine == "oga" ? "1" : nil, "PLURIMATH_LEPTRIS" => nil },
        RbConfig.ruby, "-Ilib", "-e", code,
      )
      expect(status).to be_success, err
      result = JSON.parse(out)
      expect(result.values_at("before", "after_conversion", "after_intent")).to eq([false, false, true])
      expect(result.fetch("intent")).to include('intent=":derivative(1,f,x)"')
      expect(result.fetch("repeated")).to eq(result.fetch("intent"))
      expect(result.fetch("subclass_intent")).to eq(result.fetch("intent"))
      expect(result.fetch("default_after_intent")).to eq(result.fetch("ordinary"))
      expect(result.fetch("copies")).to eq(1)
      expect(result.fetch("protected")).to be(true)
    end
  end
end
