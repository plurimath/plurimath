# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Norm < UnaryFunction
        attr_accessor :open_paren, :close_paren

        def to_asciimath
          parameter_one.is_a?(Table) ? "norm#{parameter_one.to_asciimath}" : super
        end

        def to_latex
          "{\\lVert #{parameter_one&.to_latex} \\lVert}"
        end

        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          norm = Utility.ox_element("mo") << "&#x2225;"
          Utility.update_nodes(
            Utility.ox_element("mrow"),
            [
              norm,
              first_value,
              norm,
            ],
          )
        end

        def to_omml_without_math_tag(display_style)
          array = []
          array << r_element("∥") unless open_paren
          array += Array(omml_value(display_style))
          array << r_element("∥") unless close_paren
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
