# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Base < BinaryFunction
        def to_asciimath
          first_value = parameter_one.to_asciimath if parameter_one
          second_value = "_#{wrapped(parameter_two)}" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          sub_tag = Utility.ox_element("msub")
          new_arr = []
          new_arr << parameter_one.to_mathml_without_math_tag if parameter_one
          new_arr << parameter_two.to_mathml_without_math_tag if parameter_two
          Utility.update_nodes(sub_tag, new_arr)
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

        def to_omml_without_math_tag
          ssub_element  = Utility.ox_element("sSub", namespace: "m")
          subpr_element = Utility.ox_element("sSubPr", namespace: "m")
          e_element     = Utility.ox_element("e", namespace: "m")
          sub_element   = Utility.ox_element("sub", namespace: "m")
          Utility.update_nodes(
            ssub_element,
            [
              subpr_element << Utility.pr_element("ctrl", true, namespace: "m"),
              e_element << parameter_one.to_omml_without_math_tag,
              sub_element << parameter_two.to_omml_without_math_tag,
            ],
          )
          ssub_element
        end
      end
    end
  end
end
