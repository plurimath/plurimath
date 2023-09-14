# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Abs < UnaryFunction
        attr_accessor :open_paren, :close_paren

        def to_mathml_without_math_tag
          symbol = Utility.ox_element("mo") << "|"
          first_value = mathml_value&.insert(0, symbol)
          Utility.update_nodes(
            Utility.ox_element("mrow"),
            first_value << symbol,
          )
        end

        def to_omml_without_math_tag(display_style)
          Array(
            md_tag << omml_parameter(parameter_one, display_style, tag_name: "e"),
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
            self.open_paren = false
          end
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
