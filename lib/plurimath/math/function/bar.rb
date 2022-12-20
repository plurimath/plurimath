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
          bar = Utility.ox_element("bar", namespace: "m")
          me  = Utility.ox_element("e", namespace: "m")
          me << parameter_one.to_omml_without_math_tag if parameter_one
          Utility.update_nodes(
            bar,
            [
              bar_pr,
              me,
            ],
          )
        end

        def bar_pr
          attrs = { "m:val": "top" }
          barpr = Utility.ox_element("barPr", namespace: "m")
          pos   = Utility.ox_element("pos", namespace: "m", attributes: attrs)
          ctrlp = Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(barpr, [pos, ctrlp])
        end
      end
    end
  end
end
