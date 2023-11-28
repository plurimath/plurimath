# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Phantom < UnaryFunction
        def to_asciimath
          "#{Array.new(asciimath_value&.length, '\ ').join}"
        end

        def to_html
          "<i style='visibility: hidden;'>#{parameter_one&.to_html}</i>"
        end

        def to_latex
          "\\#{class_name}{#{latex_value}}"
        end

        def to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element("mphantom"),
            Array(parameter_one&.to_mathml_without_math_tag),
          )
        end

        def to_omml_without_math_tag(display_style)
          phant = Utility.ox_element("phant", namespace: "m")
          e_tag = Utility.ox_element("e", namespace: "m")
          Utility.update_nodes(e_tag, Array(omml_value(display_style)))
          Utility.update_nodes(phant, [phant_pr, e_tag])
        end

        protected

        def phant_pr
          attributes = { val: "m:off" }
          phant = Utility.ox_element("phant", namespace: "m")
          phant << Utility.ox_element("show", namespace: "m", attributes: attributes)
        end
      end
    end
  end
end
