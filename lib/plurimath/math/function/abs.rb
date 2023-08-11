# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Abs < UnaryFunction
        def to_mathml_without_math_tag
          symbol = Utility.ox_element("mo") << "|"
          first_value = mathml_value&.insert(0, symbol)
          Utility.update_nodes(
            Utility.ox_element("mrow"),
            first_value << symbol,
          )
        end

        def to_omml_without_math_tag(display_style)
          md = (Utility.ox_element("d", namespace: "m") << mdpr_tag)
          me = Utility.ox_element("e", namespace: "m")
          Utility.update_nodes(me, omml_value(display_style))
          Utility.update_nodes(md, Array(me))
          [md]
        end

        protected

        def mdpr_tag
          attribute = { "m:val": "|" }
          mdpr = Utility.pr_element("d", namespace: "m")
          mdpr << Utility.ox_element("begChr", namespace: "m", attributes: attribute)
          mdpr << Utility.ox_element("endChr", namespace: "m", attributes: attribute)
          mdpr << Utility.ox_element("sepChr", namespace: "m", attributes: { "m:val": "" })
          mdpr << Utility.ox_element("grow", namespace: "m")
        end
      end
    end
  end
end
