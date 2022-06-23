# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Log < BinaryFunction
        def to_asciimath
          first_value = "_(#{parameter_one.to_asciimath})" if parameter_one
          second_value = "^(#{parameter_two.to_asciimath})" if parameter_two
          "log#{first_value}#{second_value}"
        end

        def to_latex
          first_value = "_{#{parameter_one.to_latex}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex}}" if parameter_two
          "\\log#{first_value}#{second_value}"
        end
      end
    end
  end
end
