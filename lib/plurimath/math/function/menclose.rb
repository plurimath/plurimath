# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Menclose < BinaryFunction
        def to_asciimath
          parameter_two&.to_asciimath
        end

        def to_mathml_without_math_tag
          attributes = { notation: parameter_one }
          menclose = Utility.ox_element("menclose", attributes: attributes)
          menclose << parameter_two.to_mathml_without_math_tag if parameter_two
          menclose
        end

        def to_latex
          parameter_two&.to_latex
        end

        def to_html
          second_value = parameter_two&.to_html
          "<menclose notation=\"#{parameter_one}\">#{second_value}</menclose>"
        end

        def to_omml_without_math_tag
          borderbox = Utility.ox_element("borderBox", namespace: "m")
          borderpr = Utility.ox_element("borderBoxPr", namespace: "m")
          borderpr << Utility.pr_element("ctrl", true, namespace: "m")
          me = Utility.ox_element("e", namespace: "m")
          Utility.update_nodes(me, Array(parameter_two.to_omml_without_math_tag)) if parameter_two
          Utility.update_nodes(
            borderbox,
            [
              borderpr,
              me,
            ],
          )
          [borderbox]
        end
      end
    end
  end
end
