# frozen_string_literal: true

require "plurimath/errors/evaluation"

module Plurimath
  module Math
    module Evaluation
      autoload :Accuracy, "#{__dir__}/evaluation/accuracy"
      autoload :Evaluator, "#{__dir__}/evaluation/evaluator"
      autoload :ExpressionParser, "#{__dir__}/evaluation/expression_parser"
      autoload :Gum, "#{__dir__}/evaluation/gum"
      autoload :Iteration, "#{__dir__}/evaluation/iteration"
      autoload :Taylor, "#{__dir__}/evaluation/taylor"
      autoload :Differentiator, "#{__dir__}/evaluation/taylor"
      autoload :QuantityEvaluator, "#{__dir__}/evaluation/quantity_evaluator"
      autoload :Result, "#{__dir__}/evaluation/result"
    end
  end
end
