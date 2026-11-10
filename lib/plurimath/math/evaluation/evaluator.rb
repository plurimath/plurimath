# frozen_string_literal: true

require "bigdecimal"
require "bigdecimal/math"

module Plurimath
  module Math
    module Evaluation
      # Computes the numeric value of a Formula tree against variable
      # bindings. Values carry an accuracy class (exact integers and
      # rationals, limited floats and guard-digit decimals); the evaluator
      # processes until an accuracy boundary and never violates one.
      #
      # mode: :approximate (default) crosses every boundary, computing
      # limited results and reporting each crossing. :strict never crosses
      # an exactness boundary: the first one defers the evaluation, and the
      # result reports the boundary and the unevaluated expression.
      # guard_digits: with :strict, crosses a transcendental boundary by
      # computing a BigDecimal result to the declared number of digits.
      #
      # evaluate returns an Evaluation::Result. The strict error contract
      # stands in both modes: results are always real, finite numbers (or
      # nil when deferred) or one of the Errors::Evaluation classes.
      class Evaluator
        # Internal control flow: strict mode stopping at a boundary. Never
        # escapes evaluate.
        class BoundaryReached < StandardError
        end

        MODES = %i[approximate strict].freeze

        # BigMath-backed transcendentals eligible for guard-digit
        # computation, plus the composites built from them; everything
        # else is approximate-only.
        GUARD_DIGIT_FUNCTIONS = %w[sin cos exp log log_base log10 sqrt atan].freeze

        def initialize(formula, bindings = {}, mode: :approximate,
                       guard_digits: nil)
          unless MODES.include?(mode)
            raise ArgumentError, "mode must be one of #{MODES.inspect}"
          end
          unless guard_digits.nil? || (guard_digits.is_a?(Integer) && guard_digits.positive?)
            raise ArgumentError, "guard_digits must be a positive Integer"
          end

          @formula = formula
          @mode = mode
          @guard_digits = guard_digits
          @bindings = normalize_bindings(bindings)
          @boundaries = []
          @unevaluated = []
        end

        def evaluate
          value = evaluate_formula(@formula)
          raise Errors::Evaluation::MathDomainError, "result is not a real number" unless value.real?
          raise Errors::Evaluation::NonFiniteResultError unless value.finite?

          Result.new(value: value, boundaries: @boundaries,
                     unevaluated: @unevaluated)
        rescue BoundaryReached
          Result.new(value: nil, boundaries: @boundaries,
                     unevaluated: [@formula.to_asciimath])
        rescue ::Math::DomainError => e
          raise Errors::Evaluation::MathDomainError, e.message
        rescue ::FloatDomainError
          raise Errors::Evaluation::NonFiniteResultError
        rescue ::ZeroDivisionError
          raise Errors::Evaluation::DivisionByZeroError
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
            real_result(node.evaluate(self))
          end
        end

        def value_for(name)
          raise Errors::Evaluation::MissingVariableError, name unless bindings.key?(name)

          bindings[name]
        end

        # ExpressionParser delegates its folds to a backend. These operations
        # retain the numeric contract; the semantic display uses the same
        # precedence ladder with a backend that only builds a render view.
        def normalize_tokens(tokens)
          tokens
        end

        def relation_operator?(_node)
          false
        end

        def add(left, right)
          left + right
        end

        def subtract(left, right)
          left - right
        end

        def multiply(left, right, implicit:)
          left * right
        end

        def positive(value)
          value
        end

        def negate(value)
          -value
        end

        def negated_mod(node)
          node.evaluate_negated(self)
        end

        def group(value)
          value
        end

        def nary_function?(node)
          (node.is_a?(Function::Sum) || node.is_a?(Function::Prod)) &&
            node.parameter_one && node.parameter_two
        end

        def log_argument(node, argument)
          real_result(node.evaluate_with_argument(self, argument))
        end

        def divide(dividend, divisor)
          raise Errors::Evaluation::DivisionByZeroError if divisor.zero?

          if mode == :strict
            if Accuracy.exact?(dividend) && Accuracy.exact?(divisor)
              exact_division(dividend, divisor)
            else
              dividend / divisor
            end
          else
            record_crossing("divide", [dividend, divisor], dividend / divisor.to_f)
          end
        end

        def modulo(dividend, divisor)
          raise Errors::Evaluation::DivisionByZeroError if divisor.zero?

          dividend % divisor
        end

        def power(base, exponent)
          value = base**exponent
          return value if Accuracy.exact?(value)

          # Non-real results (a complex root) are rejected at the
          # operation, never carried into further arithmetic.
          real_result(value)

          if mode == :strict && Accuracy.exact?(base) && Accuracy.exact?(exponent)
            return strict_exact_boundary("power", [base, exponent])
          end

          record_crossing("power", [base, exponent], value)
        end

        # The choke point every limited-accuracy operation goes through:
        # approximate mode computes and records the crossing; strict mode
        # defers exact-valued operands (or computes guard digits when
        # declared) and lets limited operands degrade as defined.
        def limited_operation(label, values, &block)
          if mode == :strict && values.all? { |value| Accuracy.exact?(value) }
            return strict_approximation(label, values, &block)
          end

          record_crossing(label, values, yield)
        end

        # Square roots of exact values stay exact when the root is
        # rational (sqrt(4) = 2 in both modes, no boundary crossed); an
        # irrational root is a limited-accuracy operation like any other.
        def square_root(node)
          value = evaluate_node(node)
          if Accuracy.exact?(value)
            exact = exact_square_root(value)
            return exact if exact
          end

          limited_operation("sqrt", [value]) { ::Math.sqrt(value) }
        end

        # Number literals route through here: integers stay exact in both
        # modes; strict decimals become exact rationals, approximate ones
        # become floats with a recorded crossing.
        def number_value(raw)
          return raw.to_i if raw.match?(/\A[+-]?\d+\z/)

          if mode == :strict
            Rational(raw)
          else
            float = Float(raw)
            record_boundary(operation: "number literal", operands: [raw],
                            operand_accuracy: Accuracy::EXACT,
                            action: :approximated, result: float)
            float
          end
        rescue ArgumentError
          raise Errors::Evaluation::UnsupportedExpressionError, "number `#{raw}`"
        end

        def strict?
          mode == :strict
        end

        # Non-real values are rejected per subexpression so they cannot reach
        # other numeric operations. Non-finite values are only rejected on the
        # final result, so correct asymptotic values like `1/exp(1000)` still
        # evaluate.
        def real_result(value)
          raise Errors::Evaluation::MathDomainError, "result is not a real number" unless value.real?

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
          raise Errors::Evaluation::UnsupportedExpressionError, unsupported_message(node_or_message)
        end

        private

        attr_reader :bindings, :mode, :guard_digits

        # Strict mode at an exact-valued limited-accuracy operation: with
        # declared guard digits and a BigMath-backed function, compute a
        # BigDecimal result to the declared precision (action :guarded);
        # otherwise defer — the boundary is recorded, evaluation stops.
        def strict_approximation(label, operands)
          strict_exact_boundary(label, operands)
        end

        def guard_digit_value(label, operands)
          Accuracy.with_decimal_context do
            x, y = operands.map do |value|
              if value.is_a?(Rational)
                BigDecimal(value.numerator, guard_digits).div(value.denominator, guard_digits)
              else
                BigDecimal(value.to_s)
              end
            end
            case label
            when "sqrt" then x.sqrt(guard_digits)
            when "log" then BigMath.log(x, guard_digits)
            when "log_base" then BigMath.log(x, guard_digits) / BigMath.log(y, guard_digits)
            when "log10" then BigMath.log(x, guard_digits) / BigMath.log(BigDecimal("10"), guard_digits)
            when "atan" then BigMath.atan(x, guard_digits)
            else BigMath.public_send(label, x, guard_digits)
            end
          end
        end

        # Square root of an exact value: exact when the root is rational,
        # nil otherwise (including negative operands, which the limited
        # path then reports through Math::DomainError).
        def exact_square_root(value)
          rational = Rational(value)
          return nil if rational.negative?

          root_numerator = Integer.sqrt(rational.numerator)
          root_denominator = Integer.sqrt(rational.denominator)
          if root_numerator * root_numerator == rational.numerator &&
              root_denominator * root_denominator == rational.denominator
            return Rational(root_numerator, root_denominator)
          end

          nil
        end

        def record_crossing(label, operands, value)
          record_boundary(operation: label, operands: operands,
                          operand_accuracy: Accuracy.combine(*operands),
                          action: :approximated, result: value)
          value
        end

        def record_boundary(record)
          @boundaries << record
        end

        # Rational division is exact; an exact quotient keeps strict mode
        # clean, a non-rational one (never occurs for Rational operands) is
        # treated as a crossing.
        def exact_division(dividend, divisor)
          Rational(dividend) / divisor
        end

        # Rational exponentiation is exact for integer exponents; a
        # non-representable root (2**0.5) is a boundary: strict mode
        # defers (or guards), approximate mode records the float.
        def strict_exact_boundary(label, operands)
          if guard_digits
            unless GUARD_DIGIT_FUNCTIONS.include?(label)
              raise Errors::Evaluation::UnsupportedExpressionError,
                    "no guard-digit implementation for `#{label}`; " \
                    "use approximate mode or an exact reformulation"
            end

            guarded = guard_digit_value(label, operands)
            record_boundary(operation: label, operands: operands,
                            operand_accuracy: Accuracy.combine(*operands),
                            action: :guarded, result: guarded)
            return guarded
          end

          @boundaries << { operation: label, operands: operands,
                           operand_accuracy: Accuracy.combine(*operands),
                           action: :deferred, result: nil }
          raise BoundaryReached
        end

        def normalize_bindings(bindings)
          bindings.to_hash.each_with_object({}) do |(key, value), normalized|
            unless key.is_a?(String) || key.is_a?(Symbol)
              raise Errors::Evaluation::InvalidBindingKeyError, key
            end
            unless numeric_binding?(value)
              raise Errors::Evaluation::InvalidBindingError.new(key, value)
            end

            normalized[key.to_s] = binding_value(value)
          end
        end

        def numeric_binding?(value)
          (value.is_a?(Numeric) && value.real?) ||
            (value.is_a?(String) && exact_decimal_string?(value))
        end

        def exact_decimal_string?(value)
          value.match?(/\A-?[0-9]+(\.[0-9]+)?\z/)
        end

        def binding_value(value)
          return value unless value.is_a?(String)

          mode == :strict ? Rational(value) : Float(value)
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
