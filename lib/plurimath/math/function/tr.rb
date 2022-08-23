# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Tr < UnaryFunction
        def to_asciimath
          "[#{parameter_one.map(&:to_asciimath).join(',')}]"
        end

        def to_mathml_without_math_tag
          "<mtr>#{parameter_one.map(&:to_mathml_without_math_tag).join}</mtr>"
        end

        def to_latex
          parameter_one.reject do |td|
            td if td.is_a?(Symbol) && td.value == "|"
          end.map(&:to_latex).join("&")
        end

        def to_html
          first_value = parameter_one.map(&:to_html).join
          "<tr>#{first_value}</tr>"
        end
      end
    end
  end
end
