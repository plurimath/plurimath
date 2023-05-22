# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Menclose < BinaryFunction
        FUNCTION = {
          name: "enclosure",
          first_value: "enclosure type",
          second_value: "expression",
        }.freeze

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

        def to_omml_without_math_tag(display_style)
          borderbox = Utility.ox_element("borderBox", namespace: "m")
          borderpr = Utility.ox_element("borderBoxPr", namespace: "m")
          borderpr << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            borderbox,
            [
              borderpr,
              omml_parameter(parameter_two, display_style, tag_name: "e"),
            ],
          )
          [borderbox]
        end
      end
    end
  end
end
