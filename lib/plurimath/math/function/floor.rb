# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Floor < UnaryFunction
        attr_accessor :open_paren, :close_paren

        def to_latex
          "{\\lfloor #{parameter_one.to_latex} \\rfloor}"
        end

        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          value_array = [first_value]
          value_array.insert(0, (ox_element("mo") << "&#x230a;")) unless open_paren
          value_array << (ox_element("mo") << "&#x230b;") unless close_paren
          Utility.update_nodes(ox_element("mrow"), value_array)
        end

        def to_omml_without_math_tag(display_style)
          array = []
          array << r_element("⌊") unless open_paren
          array += Array(omml_value(display_style))
          array << r_element("⌋") unless close_paren
          array
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
      end
    end
  end
end
