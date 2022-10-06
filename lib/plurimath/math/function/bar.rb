# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Bar < UnaryFunction
        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          "\\bar#{first_value}"
        end

        def to_omml_without_math_tag
          attrs  = { "m:val": "top" }
          bar    = Utility.omml_element("m:bar")
          barpr  = Utility.omml_element("m:barPr")
          pos    = Utility.omml_element("m:pos", attrs)
          ctrlpr = Utility.pr_element("m:ctrl", true)
          Utility.update_nodes(barpr, [pos, ctrlpr])
          me = Utility.omml_element("m:e")
          me << parameter_one.to_omml_without_math_tag
          Utility.update_nodes(
            bar,
            [
              barpr,
              me,
            ],
          )
        end
      end
    end
  end
end
