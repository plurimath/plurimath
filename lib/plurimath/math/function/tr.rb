# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Tr < UnaryFunction
        def to_asciimath
          "[#{parameter_one.map(&:to_asciimath).join(', ')}]"
        end

        def to_mathml_without_math_tag
          first_value = parameter_one.dup
          row_lines = first_value.first.parameter_one
          row_lines.shift if Utility.symbol_value(row_lines.first, "&#x23af;")
          Utility.update_nodes(
            Utility.ox_element("mtr"),
            first_value.map(&:to_mathml_without_math_tag).compact,
          )
        end

        def to_latex
          parameter_one.reject do |td|
            td if Utility.symbol_value(td, "|") || Utility.symbol_value(td.parameter_one.first, "|")
          end.map(&:to_latex).join(" & ")
        end

        def to_html
          first_value = parameter_one.map(&:to_html).join
          "<tr>#{first_value}</tr>"
        end

        def to_omml_without_math_tag
          omml_content = parameter_one&.map(&:to_omml_without_math_tag)
          if parameter_one.count.eql?(1)
            omml_content
          else
            mr = Utility.ox_element("mr", namespace: "m")
            Utility.update_nodes(
              mr,
              omml_content,
            )
          end
        end
      end
    end
  end
end
