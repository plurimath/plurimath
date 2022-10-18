# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Td < UnaryFunction
        def to_asciimath
          if parameter_one.length > 1
            "[#{parameter_one.map(&:to_asciimath).join(',')}]"
          else
            parameter_one.map(&:to_asciimath).join(",")
          end
        end

        def to_mathml_without_math_tag
          return "" if parameter_one.first.is_a?(Math::Symbol) && parameter_one.first.value == "|"

          "<mtd>#{parameter_one.map(&:to_mathml_without_math_tag).join}</mtd>"
        end

        def to_latex
          parameter_one.map(&:to_latex).join
        end

        def to_html
          first_value = parameter_one.map(&:to_html).join
          "<td>#{first_value}</td>"
        end

        def to_omml_without_math_tag
          me = Utility.omml_element("e", namespace: "m")
          Utility.update_nodes(
            me,
            parameter_one.map(&:to_omml_without_math_tag),
          )
        end
      end
    end
  end
end
