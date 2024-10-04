# frozen_string_literal: true

require_relative "binary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Stackrel < BinaryFunction
        include Mathml::Utility

        FUNCTION = {
          name: "stackrel",
          first_value: "above",
          second_value: "below",
        }.freeze

        def to_asciimath(options:)
          first_value  = wrapped(parameter_one, options: options)
          second_value = wrapped(parameter_two, options: options)
          "#{class_name}#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          Utility.update_nodes(
            ox_element("mover"),
            [
              mathml_values(parameter_two, intent, options: options),
              mathml_values(parameter_one, intent, options: options),
            ],
          )
        end

        def to_html(options:)
          first_value = parameter_one&.to_html(options: options)
          second_value = parameter_two&.to_html(options: options)
          "#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag(display_style, options:)
          limupp   = Utility.ox_element("limUpp", namespace: "m")
          limupppr = Utility.ox_element("limUppPr", namespace: "m")
          limupppr << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            limupp,
            [
              limupppr,
              omml_parameter(parameter_two, display_style, tag_name: "e", options: options),
              omml_parameter(parameter_one, display_style, tag_name: "lim", options: options),
            ],
          )
          [limupp]
        end

        def to_unicodemath(options:)
          first_value = "(#{parameter_one&.to_unicodemath(options: options)})"
          second_value = "(#{parameter_two&.to_unicodemath(options: options)})"
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

        def wrapped(field, options:)
          string = field&.to_asciimath(options: options) || ""
          string.start_with?("(") ? string : "(#{string})"
        end

        def mathml_values(field, intent, options:)
          ox_element("mrow") << (field&.to_mathml_without_math_tag(intent, options: options) || "")
        end
      end
    end
  end
end
