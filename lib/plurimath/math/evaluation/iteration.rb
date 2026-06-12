# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Evaluates bounded Sum/Prod iterations: parses the `i=1` lower bound,
      # validates the integer bounds and step limit, then folds the body with
      # the index temporarily bound.
      class Iteration
        LIMIT = 1_000_000

        def initialize(evaluator, lower, upper, body)
          @evaluator = evaluator
          @lower = lower
          @upper = upper
          @body = body
        end

        def accumulate(initial, operation)
          name, from = index_definition
          to = evaluator.evaluate_node(upper)
          validate_bounds(from, to)

          (from..to).reduce(initial) do |accumulator, index|
            accumulator.public_send(operation, body_value(name, index))
          end
        end

        private

        attr_reader :evaluator, :lower, :upper, :body

        # Parses `i=1` style lower bounds into the index name and its start.
        def index_definition
          tokens = lower.is_a?(Formula) ? lower.value : Array(lower)
          index = tokens.first
          if index.is_a?(Core) && index.reserved_constant
            evaluator.unsupported("reserved constant as iteration index")
          end
          unless index.instance_of?(Symbols::Symbol) &&
              !index.value.to_s.empty? && tokens[1].is_a?(Symbols::Equal)
            evaluator.unsupported("malformed iteration bounds")
          end

          [index.value.to_s, evaluator.evaluate_nodes(tokens[2..])]
        end

        def validate_bounds(from, to)
          unless from.is_a?(Integer) && to.is_a?(Integer)
            raise MathDomainError, "iteration bounds must be integers"
          end

          return unless (to - from + 1) > LIMIT

          evaluator.unsupported("iteration range larger than #{LIMIT} steps")
        end

        def body_value(name, index)
          evaluator.with_binding(name, index) { evaluator.evaluate_node(body) }
        end
      end
    end
  end
end
