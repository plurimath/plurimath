# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Substack < UnaryFunction
        FUNCTION = {
          name: "substack",
          first_value: "above",
          second_value: "below",
        }.freeze

        def to_asciimath
          "{:#{parameter_one.compact.map(&:to_asciimath).join(",")}:}"
        end

        def to_latex
          "\\#{class_name}{#{parameter_one&.compact&.map(&:to_latex)&.join(" \\\\ ")}}"
        end

        def to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element("mtable"),
            mathml_value,
          )
        end

        def to_omml_without_math_tag(display_style)
          Table.new(parameter_one).to_omml_without_math_tag(display_style)
        end

        def to_unicodemath
          "■(#{parameter_one.compact.map(&:to_unicodemath).join("@")})"
        end
      end
    end
  end
end
