# frozen_string_literal: true

require "plurimath/errors/evaluation"

module Plurimath
  module Math
    module Evaluation
      autoload :Evaluator, "#{__dir__}/evaluation/evaluator"
      autoload :ExpressionParser, "#{__dir__}/evaluation/expression_parser"
      autoload :Iteration, "#{__dir__}/evaluation/iteration"
    end
  end
end
