# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      autoload :Evaluator, "#{__dir__}/evaluation/evaluator"

      class Error < StandardError; end

      class MissingVariableError < Error
        def initialize(name)
          super("Missing value for variable `#{name}`.")
        end
      end

      class UnsupportedExpressionError < Error
        def initialize(message)
          super("Unsupported expression: #{message}.")
        end
      end

      class DivisionByZeroError < Error
        def initialize
          super("Cannot divide by zero.")
        end
      end

      class InvalidBindingError < Error
        def initialize(name, value)
          super("Value for variable `#{name}` must be a real number, got #{value.class}.")
        end
      end

      class MathDomainError < Error
        def initialize(message)
          super("Math domain error: #{message}.")
        end
      end

      class NonFiniteResultError < Error
        def initialize
          super("Evaluation did not produce a finite number.")
        end
      end
    end
  end
end
