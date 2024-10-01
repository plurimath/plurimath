# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Abs < UnaryFunction
        attr_accessor :open_paren, :close_paren

        def to_mathml_without_math_tag(intent, options:)
          symbol = Utility.ox_element("mo") << "|"
          first_value = mathml_value(intent, options: options)
          first_value = first_value&.insert(0, symbol) unless open_paren
          first_value << symbol unless close_paren
          mrow = Utility.update_nodes(ox_element("mrow"), first_value)
          intentify(mrow, intent, func_name: :abs, intent_name: intent_names[:name])
        end

        def to_omml_without_math_tag(display_style, options:)
          Array(
            md_tag << omml_parameter(parameter_one, display_style, tag_name: "e", options: options),
          )
        end

        def line_breaking(obj)
          parameter_one.line_breaking(obj)
          if obj.value_exist?
            ceil_object = self.class.new(Utility.filter_values(obj.value))
            ceil_object.open_paren = true
            ceil_object.close_paren = false
            obj.update(ceil_object)
            self.close_paren = true
            self.open_paren = false unless open_paren
          end
        end

        def to_unicodemath(options:)
          "⒜#{unicodemath_parens(parameter_one, options: options)}"
        end

        def intent_names
          { name: "absolute-value" }
        end

        protected

        def md_tag
          attribute = { "m:val": "|" }
          sepchr_attr = { "m:val": "" }
          mdpr = Utility.pr_element("d", namespace: "m")
          mdpr << ox_element("begChr", namespace: "m", attributes: attribute) unless open_paren
          mdpr << ox_element("endChr", namespace: "m", attributes: attribute) unless close_paren
          mdpr << ox_element("sepChr", namespace: "m", attributes: sepchr_attr)
          mdpr << ox_element("grow", namespace: "m")
          ox_element("d", namespace: "m") << mdpr
        end
      end
    end
  end
end
