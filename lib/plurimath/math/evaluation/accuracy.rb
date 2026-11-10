# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Accuracy class of an evaluated value. Integer and Rational values
      # are exact; Float values are limited with undeclared accuracy
      # (platform bits); BigDecimal values are limited to their declared
      # precision (guard digits). Limited operands contaminate exact ones:
      # the combined accuracy of an operation is its least precise operand.
      module Accuracy
        EXACT = :exact
        FLOAT = :limited_float

        module_function

        def of(value)
          case value
          when Integer, Rational then EXACT
          when Float then FLOAT
          when BigDecimal then :"limited_#{value.precision}"
          end
        end

        def exact?(value)
          of(value) == EXACT
        end

        def limited?(value)
          !exact?(value)
        end

        # The least precise operand wins: a limited operand makes the
        # result limited to that accuracy, so exactness is never claimed
        # past a contamination point.
        def combine(*values)
          values.map { |value| of(value) }.min_by do |label|
            case label
            when EXACT then Float::INFINITY
            when FLOAT then -Float::INFINITY
            else label.to_s.split("_").last.to_i
            end
          end
        end
      end
    end
  end
end
