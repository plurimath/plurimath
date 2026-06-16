# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Resolves operator precedence over the flat token sequences stored in
      # Formula#value, delegating node evaluation back to the evaluator.
      #
      # Standard recursive-descent precedence ladder — each level parses its
      # operands at the next-tighter level, so the operands of `+`/`-` are
      # whole multiplicative expressions, and so on down to single operands:
      #   parse_additive -> parse_multiplicative -> parse_unary
      #     -> parse_power -> parse_operand
      class ExpressionParser
        def initialize(evaluator, tokens)
          @evaluator = evaluator
          @tokens = tokens
          @index = 0
        end

        def parse
          result = parse_additive
          evaluator.unsupported(current) unless eof?

          result
        end

        private

        attr_reader :evaluator, :tokens

        def parse_additive
          result = parse_multiplicative
          loop do
            if take?(:plus_operator?)
              result += parse_multiplicative
            elsif take?(:minus_operator?)
              result -= parse_multiplicative
            else
              break result
            end
          end
        end

        def parse_multiplicative
          result = parse_unary
          loop do
            if take?(:multiply_operator?)
              result *= parse_unary
            elsif take?(:divide_operator?)
              result = evaluator.divide(result, parse_unary)
            elsif implicit_multiplication?
              result *= parse_power
            else
              break result
            end
          end
        end

        def parse_unary
          if take?(:plus_operator?)
            parse_unary
          elsif take?(:minus_operator?)
            negated_unary
          else
            parse_power
          end
        end

        # Unary minus binds tighter than `mod`, so `-7 mod 3` negates the
        # dividend, not the result: `(-7) mod 3 == 2`, not `-(7 mod 3)`.
        def negated_unary
          return next_token.evaluate_negated(evaluator) if current.is_a?(Function::Mod)

          -parse_unary
        end

        # Chained powers evaluate left-to-right, matching the left-nested
        # trees parsers build for chains like `2^3^2`.
        def parse_power
          result = parse_operand
          result = evaluator.power(result, parse_exponent) while take?(:power_operator?)
          result
        end

        def parse_exponent
          if take?(:plus_operator?)
            parse_exponent
          elsif take?(:minus_operator?)
            negated_exponent
          else
            parse_operand
          end
        end

        def negated_exponent
          return next_token.evaluate_negated(evaluator) if current.is_a?(Function::Mod)

          -parse_exponent
        end

        def parse_operand
          evaluator.unsupported("empty expression") if eof?
          return parse_group if open_paren?(current)

          node = next_token
          return bind_argument(node) if next_argument?(node)
          return bind_log_argument(node) if log_argument?(node)

          node = bind_nary_body(node) if nary_body?(node)
          evaluator.evaluate_node(node)
        end

        # A non-close token before the close paren is reported as itself;
        # "unmatched parenthesis" is reserved for true end-of-input.
        def parse_group
          advance
          result = parse_additive
          evaluator.unsupported(current || "unmatched parenthesis") unless close_paren?(current)

          advance
          result
        end

        # Unary functions and `log` parse separately from their argument in
        # some syntaxes; both bind the following fenced group.
        def next_argument?(node)
          node.is_a?(Function::UnaryFunction) && node.parameter_one.nil? &&
            current.is_a?(Function::Fenced)
        end

        def bind_argument(node)
          evaluator.evaluate_node(node.class.new(next_token))
        end

        # MathML/OMML n-ary Sum/Prod carry their bounds but leave the body as
        # the following sibling token; AsciiMath binds a single operand as the
        # body, so we match by adopting the next operand as parameter_three.
        def nary_body?(node)
          (node.is_a?(Function::Sum) || node.is_a?(Function::Prod)) &&
            node.parameter_three.nil? &&
            node.parameter_one && node.parameter_two &&
            !eof? && operand_start?(current)
        end

        # The body is a single following operand; if that operand is itself a
        # sibling-body Sum/Prod (e.g. nested MathML `sum sum …`), complete it
        # recursively so the inner body binds too.
        def bind_nary_body(node)
          body = next_token
          body = bind_nary_body(body) if nary_body?(body)
          node.class.new(node.parameter_one, node.parameter_two, body)
        end

        def log_argument?(node)
          node.is_a?(Function::Log) && current.is_a?(Function::Fenced)
        end

        def bind_log_argument(node)
          evaluator.real_result(node.evaluate_with_argument(evaluator, next_token))
        end

        # Adjacent operands multiply by juxtaposition (`2a`, `2(a+b)`), except
        # two adjacent numeric literals, which usually indicate a split number
        # literal. Signs are never consumed implicitly.
        def implicit_multiplication?
          operand_start?(current) &&
            !(current.is_a?(Number) && tokens[@index - 1].is_a?(Number))
        end

        def operand_start?(node)
          return false if node.nil? || operator?(node)

          !close_paren?(node)
        end

        def operator?(node)
          node.plus_operator? || node.minus_operator? ||
            node.multiply_operator? || node.divide_operator? ||
            node.power_operator?
        end

        def take?(operator)
          return false if eof? || !current.public_send(operator)

          advance
          true
        end

        def next_token
          token = current
          advance
          token
        end

        def open_paren?(node)
          node.respond_to?(:open?) && node.open?
        end

        def close_paren?(node)
          node.respond_to?(:close?) && node.close?
        end

        def current
          token = tokens[@index]
          evaluator.unsupported("malformed token") unless token.nil? || token.is_a?(Core)

          token
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
