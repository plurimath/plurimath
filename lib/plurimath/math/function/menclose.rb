# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Menclose < BinaryFunction
        def to_omml_without_math_tag
          borderbox = Utility.omml_element("borderBox", namespace: "m")
          borderpr = Utility.omml_element("borderBoxPr", namespace: "m")
          borderpr << Utility.pr_element("ctrl", true, namespace: "m")
          me = Utility.omml_element("e", namespace: "m")
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
