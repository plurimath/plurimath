# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Mod < BinaryFunction
        FUNCTION = {
          name: "mod",
          first_value: "base",
          second_value: "argument",
        }

        def to_asciimath(options:)
          first_value = parameter_one&.to_asciimath(options: options)
          second_value = parameter_two&.to_asciimath(options: options)
          "#{first_value} mod #{second_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          mi_tag = ox_element("mi")
          mi_tag << "mod" unless hide_function_name
          value_array = [mi_tag]
          value_array.insert(0, parameter_one&.to_mathml_without_math_tag(intent, options: options)) if parameter_one
          value_array << parameter_two&.to_mathml_without_math_tag(intent, options: options) if parameter_two
          Utility.update_nodes(ox_element("mrow"), value_array)
        end

        def to_latex(options:)
          first_value = "{#{parameter_one.to_latex(options: options)}}" if parameter_one
          second_value = "{#{parameter_two.to_latex(options: options)}}" if parameter_two
          "#{first_value} \\mod #{second_value}"
        end

        def to_html(options:)
          first_value = "<i>#{parameter_one.to_html(options: options)}</i>" if parameter_one
          second_value = "<i>#{parameter_two.to_html(options: options)}</i>" if parameter_two
          "#{first_value}<i>mod</i>#{second_value}"
        end

        def to_omml_without_math_tag(display_style, options:)
          values = []
          first_value(display_style, values, options: options)
          values << r_element("mod") unless hide_function_name
          second_value(display_style, values, options: options)
          values
        end

        def to_unicodemath(options:)
          "#{parameter_one&.to_unicodemath(options: options)}mod#{parameter_two&.to_unicodemath(options: options)}"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            mod = self.class.new(Utility.filter_values(obj.value), parameter_two)
            mod.hide_function_name = false
            self.hide_function_name = true
            obj.update(mod)
            self.parameter_two = nil
            return
          end

          parameter_two&.line_breaking(obj)
          if obj.value_exist?
            mod = self.class.new(nil, Utility.filter_values(obj.value))
            mod.hide_function_name = true
            obj.update(mod)
          end
        end

        protected

        def first_value(display_style, values, options:)
          return unless parameter_one

          values << parameter_one.insert_t_tag(display_style, options: options)
        end

        def second_value(display_style, values, options:)
          return unless parameter_two

          values << parameter_two.insert_t_tag(display_style, options: options)
        end
      end
    end
  end
end
