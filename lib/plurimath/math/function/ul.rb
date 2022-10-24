# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ul < UnaryFunction
        def to_omml_without_math_tag
          bar    = Utility.omml_element("bar", namespace: "m")
          barpr  = Utility.omml_element("barPr", namespace: "m")
          barpr << Utility.pr_element("ctrl", true, namespace: "m")
          me = Utility.omml_element("e", namespace: "m")
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
