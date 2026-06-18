# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Computes the numeric value of a Formula tree against variable
      # bindings, enforcing the strict error contract: results are always
      # real, finite numbers or one of the Evaluation errors is raised.
      class Evaluator
        def initialize(formula, bindings = {})
          @formula = formula
          @bindings = normalize_bindings(bindings)
        end

        def evaluate
          result = begin
            evaluate_formula(@formula)
          rescue ::Math::DomainError => e
            raise MathDomainError, e.message
          rescue ::FloatDomainError
            raise NonFiniteResultError
          rescue ::ZeroDivisionError
            raise DivisionByZeroError
          end

          raise NonFiniteResultError unless result.finite?

          result
        end

        def evaluate_formula(formula)
          real_result(ExpressionParser.new(self, formula.value).parse)
        end

        def evaluate_nodes(nodes)
          evaluate_formula(Formula.new(Array(nodes)))
        end

        def evaluate_node(node)
          case node
          when nil
            unsupported("missing operand")
          when Formula
            evaluate_formula(node)
          else
            return real_result(node.evaluate(self)) if node.respond_to?(:evaluate)

            unsupported(node)
          end
        end

        def value_for(name)
          raise MissingVariableError, name unless bindings.key?(name)

          bindings[name]
        end

        def divide(dividend, divisor)
          raise DivisionByZeroError if divisor.zero?

          dividend / divisor.to_f
        end

        def modulo(dividend, divisor)
          raise DivisionByZeroError if divisor.zero?

          dividend % divisor
        end

        def power(base, exponent)
          real_result(base**exponent)
        end

        # Non-real values are rejected per subexpression so they cannot reach
        # other numeric operations. Non-finite values are only rejected on the
        # final result, so correct asymptotic values like `1/exp(1000)` still
        # evaluate.
        def real_result(value)
          raise MathDomainError, "result is not a real number" unless value.real?

          value
        end

        # Comma-separated argument lists for functions like `max(2,3)`.
        def evaluate_arguments(nodes)
          split_on_commas(Array(nodes)).map { |segment| evaluate_nodes(segment) }
        end

        def function_arguments(node)
          return evaluate_arguments(node.parameter_two) if node.is_a?(Function::Fenced)

          evaluate_arguments(Array(node))
        end

        # Temporarily binds an iteration index, shadowing any outer binding
        # of the same name and restoring it afterwards.
        def with_binding(name, value)
          had_key = bindings.key?(name)
          previous = bindings[name]
          bindings[name] = value
          yield
        ensure
          had_key ? bindings[name] = previous : bindings.delete(name)
        end

        def unsupported(node_or_message)
          raise UnsupportedExpressionError, unsupported_message(node_or_message)
        end

        private

        attr_reader :bindings

        def normalize_bindings(bindings)
          bindings.to_hash.each_with_object({}) do |(key, value), normalized|
            unless key.is_a?(String) || key.is_a?(Symbol)
              raise InvalidBindingKeyError, key
            end
            unless value.is_a?(Numeric) && value.real?
              raise InvalidBindingError.new(key, value)
            end

            normalized[key.to_s] = value
          end
        end

        def split_on_commas(nodes)
          nodes.each_with_object([[]]) do |node, segments|
            node.is_a?(Symbols::Comma) ? segments << [] : segments.last << node
          end
        end

        def unsupported_message(node_or_message)
          return node_or_message if node_or_message.is_a?(String)
          return "equation" if node_or_message.is_a?(Symbols::Equal)
          return "number `#{node_or_message.value}`" if node_or_message.is_a?(Number)

          if node_or_message.instance_of?(Symbols::Symbol) &&
              node_or_message.value.to_s != ""
            return "symbol `#{node_or_message.value}`"
          end

          node_or_message.class.name.sub(/^Plurimath::Math::/, "")
        end
      end
    end
  end
end
