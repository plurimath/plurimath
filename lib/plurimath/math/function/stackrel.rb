# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Stackrel < BinaryFunction
        FUNCTION = {
          name: "stackrel",
          first_value: "above",
          second_value: "below",
        }.freeze

        def to_asciimath
          first_value  = wrapped(parameter_one)
          second_value = wrapped(parameter_two)
          "#{class_name}#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag(intent)
          Utility.update_nodes(
            ox_element("mover"),
            [
              mathml_values(parameter_two, intent),
              mathml_values(parameter_one, intent),
            ],
          )
        end

        def to_html
          first_value = parameter_one&.to_html
          second_value = parameter_two&.to_html
          "#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag(display_style)
          limupp   = Utility.ox_element("limUpp", namespace: "m")
          limupppr = Utility.ox_element("limUppPr", namespace: "m")
          limupppr << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            limupp,
            [
              limupppr,
              omml_parameter(parameter_two, display_style, tag_name: "e"),
              omml_parameter(parameter_one, display_style, tag_name: "lim"),
            ],
          )
          [limupp]
        end

        def to_unicodemath
          first_value = "(#{parameter_one&.to_unicodemath})"
          second_value = "(#{parameter_two&.to_unicodemath})"
          "#{second_value}┴#{first_value}"
        end

        def line_breaking(obj)
          parameter_one.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(Utility.filter_values(obj.value), parameter_two))
            self.parameter_two = nil
          end
        end

        protected

        def wrapped(field)
          string = field&.to_asciimath || ""
          string.start_with?("(") ? string : "(#{string})"
        end

        def mathml_values(field, intent)
          ox_element("mrow") << (field&.to_mathml_without_math_tag(intent) || "")
        end
      end
    end
  end
end
