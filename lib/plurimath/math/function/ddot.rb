# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ddot < UnaryFunction
        def to_mathml_without_math_tag
          second_value = Utility.ox_element("mo") << ".."
          Utility.update_nodes(
            Utility.ox_element("mover", attributes: { accent: "true" }),
            mathml_value << second_value,
          )
        end

        def to_omml_without_math_tag(display_style)
          return r_element("..", rpr_tag: false) unless parameter_one

          symbol = Symbol.new("..")
          Overset.new(parameter_one, symbol).to_omml_without_math_tag(true)
        end

        def to_html
          first_value = "<i>#{parameter_one.to_html}</i>" if parameter_one
          "#{first_value}<i>..</i>"
        end
      end
    end
  end
end
