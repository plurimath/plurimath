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
          Utility.update_nodes(
            Utility.ox_element("mrow"),
            [
              Utility.ox_element("mo") << "&#x230a;",
              first_value,
              Utility.ox_element("mo") << "&#x230b;",
            ],
          )
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
            self.open_paren = false
          end
        end
      end
    end
  end
end
