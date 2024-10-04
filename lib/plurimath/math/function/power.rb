# frozen_string_literal: true

require_relative "binary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Power < BinaryFunction
        include Mathml::Utility

        FUNCTION = {
          name: "superscript",
          first_value: "base",
          second_value: "script",
        }.freeze

        def to_asciimath(options:)
          second_value = "^#{wrapped(parameter_two, options: options)}" if parameter_two
          "#{parameter_one.to_asciimath(options: options)}#{second_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          tag_name = ["ubrace", "obrace"].include?(parameter_one&.class_name) ? "over" : "sup"
          value_array = [
            validate_mathml_fields(parameter_one, intent, options: options),
            validate_mathml_fields(parameter_two, intent, options: options),
          ]
          Utility.update_nodes(ox_element("m#{tag_name}"), value_array)
        end

        def to_latex(options:)
          first_value  = parameter_one.to_latex(options: options)
          second_value = parameter_two.to_latex(options: options) if parameter_two
          "#{first_value}^{#{second_value}}"
        end

        def to_html(options:)
          first_value  = "<i>#{parameter_one.to_html(options: options)}</i>" if parameter_one
          second_value = "<sup>#{parameter_two.to_html(options: options)}</sup>" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag(display_style, options:)
          ssup_element  = Utility.ox_element("sSup", namespace: "m")
          suppr_element = Utility.ox_element("sSupPr", namespace: "m")
          suppr_element << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            ssup_element,
            [
              suppr_element,
              omml_parameter(parameter_one, display_style, tag_name: "e", options: options),
              omml_parameter(parameter_two, display_style, tag_name: "sup", options: options),
            ],
          )
          [ssup_element]
        end

        def to_unicodemath(options:)
          if accented?(parameter_two)
            "#{parameter_one.to_unicodemath(options: options)}#{parameter_two.to_unicodemath(options: options).gsub(/\s+/, "")}"
          elsif parameter_two.mini_sized?
            "#{parameter_one.to_unicodemath(options: options)}#{parameter_two.to_unicodemath(options: options)}"
          else
            first_value = parameter_one.to_unicodemath(options: options) if parameter_one
            second_value = if parameter_two.is_a?(self.class)
              "^#{parameter_two.to_unicodemath(options: options)}"
            else
              "^#{unicodemath_parens(parameter_two, options: options)}"
            end
            "#{first_value}#{second_value}"
          end
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(Utility.filter_values(obj.value), parameter_two))
            self.parameter_two = nil
          end
        end

        def new_nary_function(fourth_value)
          Nary.new(parameter_one, nil, parameter_two, fourth_value)
        end

        def is_nary_function?
          parameter_one.is_nary_function? || parameter_one.is_nary_symbol?
        end

        protected

        def accented?(field)
          (field.is_a?(Math::Symbols::Symbol) && prime_unicode?(field)) ||
            (field.is_a?(Math::Formula) && prime_unicode?(field.value.first)) ||
            (field.is_a?(Math::Function::Power) && prime_unicode?(field.parameter_one))
        end
      end
    end
  end
end
