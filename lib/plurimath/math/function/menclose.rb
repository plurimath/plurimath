# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Menclose < BinaryFunction
        def to_omml_without_math_tag
          borderbox = Utility.omml_element("m:borderBox")
          borderpr = Utility.omml_element("m:borderBoxPr")
          borderpr << Utility.pr_element("m:ctrl", true)
          me = Utility.omml_element("m:e")
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
