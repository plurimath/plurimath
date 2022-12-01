# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Stackrel < BinaryFunction
        def to_asciimath
          first_value  = wrapped(parameter_one)
          second_value = wrapped(parameter_two)
          "#{class_name}#{first_value}#{second_value}"
        end

        def wrapped(field)
          string = field&.to_asciimath || ""
          string.start_with?("(") ? string : "(#{string})"
        end
      end
    end
  end
end
