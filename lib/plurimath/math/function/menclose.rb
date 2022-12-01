# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Menclose < BinaryFunction
        def to_asciimath
          parameter_two&.to_asciimath
        end

        def to_latex
          parameter_two&.to_latex
        end

        def to_omml_without_math_tag
          borderbox = Utility.ox_element("borderBox", namespace: "m")
          borderpr = Utility.ox_element("borderBoxPr", namespace: "m")
          borderpr << Utility.pr_element("ctrl", true, namespace: "m")
          me = Utility.ox_element("e", namespace: "m")
          me << parameter_two.to_omml_without_math_tag
          Utility.update_nodes(
            borderbox,
            [
              borderpr,
              me,
            ],
          )
        end
      end
    end
  end
end
