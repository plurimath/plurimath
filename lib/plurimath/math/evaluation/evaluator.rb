# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      class Evaluator
        MULTIPLY_OPERATORS = [
          Symbols::Cdot,
          Symbols::Times,
        ].freeze

        MULTIPLY_SYMBOL_VALUES = ["*", "⋅", "×"].freeze
        PLUS_SYMBOL_VALUES = ["+"].freeze
        MINUS_SYMBOL_VALUES = ["-", "−"].freeze
        DIVIDE_SYMBOL_VALUES = ["/", "∕", "÷"].freeze
        POWER_SYMBOL_VALUES = ["^"].freeze

        DIVIDE_OPERATORS = [
          Symbols::Div,
        ].freeze

        RESERVED_BINDINGS = { "pi" => ::Math::PI }.freeze

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
          when Formula
            evaluate_formula(node)
          else
            return real_result(node.evaluate(self)) if node.respond_to?(:evaluate)

            unsupported(node)
          end
        end

        def value_for(name)
          return RESERVED_BINDINGS[name] if RESERVED_BINDINGS.key?(name)
          raise MissingVariableError, name unless bindings.key?(name)

          bindings[name]
        end

        def divide(dividend, divisor)
          raise DivisionByZeroError if divisor.zero?

          dividend / divisor.to_f
        end

        # Non-real values are rejected per subexpression so they cannot reach
        # other numeric operations. Non-finite values are only rejected on the
        # final result, so correct asymptotic values like `1/exp(1000)` still
        # evaluate.
        def real_result(value)
          raise MathDomainError, "result is not a real number" unless value.real?

          value
        end

        def unsupported(node_or_message)
          raise UnsupportedExpressionError, unsupported_message(node_or_message)
        end

        private

        attr_reader :bindings

        def normalize_bindings(bindings)
          bindings.to_hash.each_with_object({}) do |(key, value), normalized|
            unless value.is_a?(Numeric) && value.real?
              raise InvalidBindingError.new(key, value)
            end

            normalized[key.to_s] = value
          end
        end

        def unsupported_message(node_or_message)
          return node_or_message if node_or_message.is_a?(String)
          return "equation" if node_or_message.is_a?(Symbols::Equal)

          if node_or_message.instance_of?(Symbols::Symbol) &&
              node_or_message.value.to_s != ""
            return "symbol `#{node_or_message.value}`"
          end

          node_or_message.class.name.sub(/^Plurimath::Math::/, "")
        end

        # Formula#value stores basic infix operators as a flat sequence, so
        # precedence is resolved here before semantic nodes evaluate themselves.
        class ExpressionParser
          def initialize(evaluator, tokens)
            @evaluator = evaluator
            @tokens = tokens
            @index = 0
          end

          def parse
            value = parse_additive
            return value if eof?

            evaluator.unsupported(current)
          end

          private

          attr_reader :evaluator, :tokens

          def parse_additive
            result = parse_multiplicative
            until eof?
              if plus_operator?(current)
                advance
                result += parse_multiplicative
              elsif minus_operator?(current)
                advance
                result -= parse_multiplicative
              else
                return result
              end
            end
            result
          end

          def parse_multiplicative
            result = parse_unary
            until eof?
              if multiply_operator?(current)
                advance
                result *= parse_unary
              elsif divide_operator?(current)
                advance
                result = evaluator.divide(result, parse_unary)
              else
                return result
              end
            end
            result
          end

          def parse_unary
            if plus_operator?(current)
              advance
              parse_unary
            elsif minus_operator?(current)
              advance
              -parse_unary
            else
              parse_power
            end
          end

          # Chained powers evaluate left-to-right, matching the left-nested
          # trees parsers build for source chains like `2^3^2`.
          def parse_power
            result = parse_operand
            while power_operator?(current)
              advance
              result **= parse_exponent
            end
            result
          end

          def parse_exponent
            if plus_operator?(current)
              advance
              parse_exponent
            elsif minus_operator?(current)
              advance
              -parse_exponent
            else
              parse_operand
            end
          end

          def parse_operand
            evaluator.unsupported("empty expression") if eof?

            return parse_group if current.respond_to?(:open?) && current.open?

            node = current
            advance
            node = apply_following_argument(node) if next_argument?(node)
            evaluator.evaluate_node(node)
          end

          def parse_group
            advance
            value = parse_additive
            evaluator.unsupported("unmatched parenthesis") unless current.respond_to?(:close?) && current.close?

            advance
            value
          end

          def apply_following_argument(node)
            argument = current
            advance
            node.class.new(argument)
          end

          def next_argument?(node)
            node.is_a?(Function::UnaryFunction) &&
              node.parameter_one.nil? &&
              current.is_a?(Function::Fenced)
          end

          def plus_operator?(node)
            node.is_a?(Symbols::Plus) ||
              symbol_value?(node, PLUS_SYMBOL_VALUES)
          end

          def minus_operator?(node)
            node.is_a?(Symbols::Minus) ||
              symbol_value?(node, MINUS_SYMBOL_VALUES)
          end

          def multiply_operator?(node)
            MULTIPLY_OPERATORS.any? { |operator| node.is_a?(operator) } ||
              symbol_value?(node, MULTIPLY_SYMBOL_VALUES)
          end

          def divide_operator?(node)
            DIVIDE_OPERATORS.any? { |operator| node.is_a?(operator) } ||
              symbol_value?(node, DIVIDE_SYMBOL_VALUES)
          end

          def power_operator?(node)
            node.is_a?(Symbols::Hat) ||
              symbol_value?(node, POWER_SYMBOL_VALUES)
          end

          def symbol_value?(node, values)
            node.instance_of?(Symbols::Symbol) && values.include?(node.value)
          end

          def current
            tokens[@index]
          end

          def advance
            @index += 1
          end

          def eof?
            @index >= tokens.length
          end
        end
      end
    end
  end
end
