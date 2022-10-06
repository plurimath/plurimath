# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ul < UnaryFunction
        def to_omml_without_math_tag
          bar    = Utility.omml_element("m:bar")
          barpr  = Utility.omml_element("m:barPr")
          barpr << Utility.pr_element("m:ctrl", true)
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
