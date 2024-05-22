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

        def to_mathml_without_math_tag(intent)
          first_value = Array(parameter_one&.to_mathml_without_math_tag(intent))
          norm = ox_element("mo") << "&#x2225;"
          first_value = first_value.insert(0, norm) unless open_paren
          first_value = first_value << norm unless close_paren
          Utility.update_nodes(ox_element("mrow"), first_value)
        end

        def to_unicodemath
          first_value = "&#x2016;" unless open_paren
          second_value = "&#x2016;" unless close_paren
          "#{first_value}#{parameter_one&.to_unicodemath}#{second_value}"
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
            norm_object = self.class.new(Utility.filter_values(obj.value))
            norm_object.open_paren = true
            norm_object.close_paren = false
            obj.update(norm_object)
            self.close_paren = true
            self.open_paren = false unless open_paren
          end
        end
      end
    end
  end
end
