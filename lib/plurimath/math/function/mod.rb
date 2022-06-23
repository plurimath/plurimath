# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Mod < BinaryFunction
        def to_asciimath
          first_value = "(#{parameter_one.to_asciimath})" if parameter_one
          second_value = "(#{parameter_two.to_asciimath})" if parameter_two
          "#{first_value}mod#{second_value}"
        end

        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          second_value = "{#{parameter_two.to_latex}}" if parameter_two
          "#{first_value}\\pmod#{second_value}"
        end
      end
    end
  end
end
