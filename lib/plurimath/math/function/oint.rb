# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Oint < BinaryFunction
        def to_asciimath
          first_value = "_#{wrapped(parameter_one)}" if parameter_one
          second_value = "^#{wrapped(parameter_two)}" if parameter_two
          "oint#{first_value}#{second_value}"
        end
      end
    end
  end
end
