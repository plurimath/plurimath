# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Substack < BinaryFunction
        def to_latex
          first_value  = parameter_one.to_latex if parameter_one
          second_value = "\\\\#{parameter_two.to_latex}" if parameter_two
          "\\#{class_name}{#{first_value}#{second_value}}"
        end

        def to_mathml_without_math_tag
          value_array = []
          value_array << parameter_one.to_mathml_without_math_tag if parameter_one
          value_array << parameter_two.to_mathml_without_math_tag if parameter_two
          Utility.update_nodes(Utility.ox_element("mtable"), value_array)
        end

        def to_omml_without_math_tag
          Array(
            Utility.update_nodes(
              mm_element,
              [
                omml_parameter(parameter_one, tag_name: "mr"),
                omml_parameter(parameter_two, tag_name: "mr"),
              ],
            ),
          )
        end

        protected

        def mm_element
          mcjc = Utility.ox_element(
            "mcJc",
            namespace: "m",
            attributes: { "m:val": "center" },
          )
          mcount = Utility.ox_element(
            "count",
            namespace: "m",
            attributes: { "m:val": "1" },
          )
          mbasejc = Utility.ox_element(
            "baseJc",
            namespace: "m",
            attributes: { "m:val": "center", },
          )
          mplchide = Utility.ox_element(
            "plcHide",
            namespace: "m",
            attributes: { "m:val": "1" },
          )
          mm   = Utility.ox_element("m", namespace: "m")
          mc   = Utility.ox_element("mc", namespace: "m")
          mpr  = Utility.ox_element("mpr", namespace: "m")
          mcs  = Utility.ox_element("mcs", namespace: "m")
          mcpr = Utility.ox_element("mcPr", namespace: "m")
          mc << Utility.update_nodes(mcpr, [mcjc, mcount])
          mcs << mc
          Utility.update_nodes(mm, [mpr])
        end
      end
    end
  end
end
