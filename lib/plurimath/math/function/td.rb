# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Td < UnaryFunction
        def to_asciimath
          "[#{parameter_one.map(&:to_asciimath).join(',')}]"
        end

        def to_mathml_without_math_tag
          "<mtd>#{parameter_one.map(&:to_mathml_without_math_tag).join}</mtd>"
        end
      end
    end
  end
end
