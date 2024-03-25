# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ceil < UnaryFunction
        attr_accessor :open_paren, :close_paren

        def to_latex
          "{\\lceil #{latex_value} \\rceil}"
        end

        def to_mathml_without_math_tag
          first_value = mathml_value
          first_value = first_value&.insert(0, paren_node("&#x2308;")) unless open_paren
          first_value = first_value << paren_node("&#x2309;") unless close_paren
          Utility.update_nodes(ox_element("mrow"), first_value)
        end

        def to_omml_without_math_tag(display_style)
          lceil = Symbol.new("⌈") unless open_paren
          rceil = Symbol.new("⌉") unless close_paren
          fenced = Fenced.new(lceil, Array(parameter_one), rceil)
          Array(fenced.to_omml_without_math_tag(display_style))
        end

        def to_html
          first_value = "<i>#{parameter_one.to_html}</i>" if parameter_one
          "<i>&#x2308;</i>#{first_value}<i>&#x2309;</i>"
        end

        def to_unicodemath
          first_value = "&#x2308;" unless open_paren
          second_value = "&#x2309;" unless close_paren
          "#{first_value}#{parameter_one&.to_unicodemath}#{second_value}"
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

        def paren_node(value)
          ox_element("mo") << value
        end
      end
    end
  end
end
