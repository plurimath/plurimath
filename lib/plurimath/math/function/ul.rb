# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ul < UnaryFunction
        def to_omml_without_math_tag
          bar    = Utility.ox_element("bar", namespace: "m")
          barpr  = Utility.ox_element("barPr", namespace: "m")
          barpr << Utility.pr_element("ctrl", true, namespace: "m")
          me = Utility.ox_element("e", namespace: "m")
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
