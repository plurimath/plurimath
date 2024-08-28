# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Floor < UnaryFunction
        attr_accessor :open_paren, :close_paren

        def to_latex(options:)
          "{\\lfloor #{parameter_one.to_latex(options: options)} \\rfloor}"
        end

        def to_mathml_without_math_tag(intent, options:)
          first_value = parameter_one&.to_mathml_without_math_tag(intent, options: options)
          value_array = [first_value]
          value_array.insert(0, (ox_element("mo") << "&#x230a;")) unless open_paren
          value_array << (ox_element("mo") << "&#x230b;") unless close_paren
          Utility.update_nodes(ox_element("mrow"), value_array)
        end

        def to_omml_without_math_tag(display_style, options:)
          array = []
          array << r_element("⌊") unless open_paren
          array += Array(omml_value(display_style, options: options))
          array << r_element("⌋") unless close_paren
          array
        end

        def to_unicodemath(options:)
          first_value = "&#x230a;" unless open_paren
          second_value = "&#x230b;" unless close_paren
          "#{first_value}#{parameter_one&.to_unicodemath(options: options)}#{second_value}"
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
