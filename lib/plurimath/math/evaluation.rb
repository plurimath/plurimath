# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      errors_dir = File.expand_path("../errors/evaluation", __dir__)

      autoload :Evaluator, "#{__dir__}/evaluation/evaluator"
      autoload :Error, "#{errors_dir}/error"
      autoload :MissingVariableError, "#{errors_dir}/missing_variable_error"
      autoload :UnsupportedExpressionError,
               "#{errors_dir}/unsupported_expression_error"
      autoload :DivisionByZeroError, "#{errors_dir}/division_by_zero_error"
      autoload :InvalidBindingError, "#{errors_dir}/invalid_binding_error"
      autoload :MathDomainError, "#{errors_dir}/math_domain_error"
      autoload :NonFiniteResultError, "#{errors_dir}/non_finite_result_error"
    end
  end
end
