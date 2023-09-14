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

        def to_mathml_without_math_tag
          mover = Utility.ox_element("mover")
          first_value = Utility.ox_element("mrow")
          first_value << parameter_one.to_mathml_without_math_tag if parameter_one
          second_value = Utility.ox_element("mrow")
          second_value << parameter_two.to_mathml_without_math_tag if parameter_two
          Utility.update_nodes(mover, [second_value, first_value])
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
      end
    end
  end
end
