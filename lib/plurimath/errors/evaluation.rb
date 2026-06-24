# frozen_string_literal: true

module Plurimath
  module Errors
    module Evaluation
      autoload :Error, "#{__dir__}/evaluation/error"
      autoload :DivisionByZeroError, "#{__dir__}/evaluation/division_by_zero_error"
      autoload :InvalidBindingError, "#{__dir__}/evaluation/invalid_binding_error"
      autoload :InvalidBindingKeyError,
               "#{__dir__}/evaluation/invalid_binding_key_error"
      autoload :MathDomainError, "#{__dir__}/evaluation/math_domain_error"
      autoload :MissingVariableError, "#{__dir__}/evaluation/missing_variable_error"
      autoload :NonFiniteResultError, "#{__dir__}/evaluation/non_finite_result_error"
      autoload :UnsupportedExpressionError,
               "#{__dir__}/evaluation/unsupported_expression_error"
    end
  end
end
