# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Base < BinaryFunction
        FUNCTION = {
          name: "subscript",
          first_value: "base",
          second_value: "script",
        }.freeze

        def to_asciimath
          first_value = parameter_one.to_asciimath if parameter_one
          second_value = "_#{wrapped(parameter_two)}" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          tag_name = (Utility::MUNDER_CLASSES.include?(parameter_one&.class_name) ? "under" : "sub")
          sub_tag = Utility.ox_element("m#{tag_name}")
          mathml_value = []
          mathml_value << validate_mathml_fields(parameter_one)
          mathml_value << validate_mathml_fields(parameter_two)
          Utility.update_nodes(sub_tag, mathml_value)
        end

        def to_latex
          first_value  = parameter_one.to_latex if parameter_one
          first_value  = "{#{first_value}}" if parameter_one.is_a?(Formula)
          second_value = parameter_two.to_latex if parameter_two
          "#{first_value}_{#{second_value}}"
        end

        def to_html
          first_value  = "<i>#{parameter_one.to_html}</i>" if parameter_one
          second_value = "<sub>#{parameter_two.to_html}</sub>" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag(display_style)
          ssub_element  = Utility.ox_element("sSub", namespace: "m")
          subpr_element = Utility.ox_element("sSubPr", namespace: "m")
          subpr_element << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            ssub_element,
            [
              subpr_element,
              omml_parameter(parameter_one, display_style, tag_name: "e"),
              omml_parameter(parameter_two, display_style, tag_name: "sub"),
            ],
          )
          [ssub_element]
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(Utility.filter_values(obj.value), parameter_two))
            self.parameter_two = nil
            return
          end

          parameter_two&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(nil, Utility.filter_values(obj.value)))
          end
        end

        def new_nary_function(fourth_value)
          Nary.new(parameter_one, parameter_two, nil, fourth_value)
        end

        def is_nary_function?
          parameter_one.is_nary_function? || parameter_one.is_nary_symbol?
        end
      end
    end
  end
end
