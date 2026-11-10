# frozen_string_literal: true

require "unitsml"

module Plurimath
  module Math
    module Evaluation
      # An explicit arithmetic entrypoint. UnitsML owns unit construction,
      # dimension checks, conversion, composition and scale legality.
      class QuantityEvaluator < Evaluator
        class QuantityResult < Result
          def exact?
            Accuracy.exact?(value.value)
          end
        end

        def initialize(formula, bindings)
          super(formula, bindings, mode: :strict)
        end

        def evaluate
          QuantityResult.new(value: evaluate_formula(@formula))
        rescue ::ZeroDivisionError
          raise Errors::Evaluation::DivisionByZeroError
        end

        def evaluate_node(node)
          case node
          when Formula, Number, Symbols::Symbol, Function::Frac, Function::Power, Function::Fenced
            super
          else
            unsupported("quantity arithmetic unavailable for #{node.class}")
          end
        end

        def normalize_bindings(bindings)
          quantities, scalars = bindings.partition { |_key, value| value.is_a?(::Unitsml::Quantity) }.map(&:to_h)
          result = super(scalars).transform_values { |value| quantity(value) }
          quantities.each do |key, value|
            unless key.is_a?(String) || key.is_a?(::Symbol)
              raise Errors::Evaluation::InvalidBindingKeyError, key
            end
            result[key.to_s] = quantity(value)
          end
          result
        end

        def number_value(raw) = quantity(super)
        def real_result(value) = quantity(value)

        def add(left, right)
          left + addition_operand(left, right)
        end

        def subtract(left, right)
          left - addition_operand(left, right)
        end

        def divide(left, right) = left / right
        def negate(value) = value * -1r

        def power(base, exponent)
          unless exponent.dimension_vector == {} && exponent.value.to_r.denominator == 1
            unsupported("quantity powers need a dimensionless integer exponent")
          end
          n = exponent.value.to_i
          return quantity(1) / power(base, quantity(-n)) if n.negative?

          result = quantity(1)
          until n.zero?
            result *= base if n.odd?
            n /= 2
            base *= base unless n.zero?
          end
          result
        end

        def modulo(_left, _right)
          unsupported("quantity modulo")
        end

        private

        def quantity(value)
          original = value if value.is_a?(::Unitsml::Quantity)
          magnitude = original ? original.value : value
          unless magnitude.is_a?(Numeric) && magnitude.real? && magnitude.finite?
            raise Errors::Evaluation::InvalidBindingError.new("quantity magnitude", magnitude)
          end
          magnitude = magnitude.to_r if magnitude.is_a?(Integer)
          result = ::Unitsml::Quantity.new(value: magnitude,
                                          unit: original&.formula,
                                          scale: original&.scale)
          unsupported("unknown unit dimension") if result.dimension_vector.nil?
          result
        end

        def addition_operand(left, right)
          return right unless left.formula && right.formula

          # UnitsML addition checks dimensions but does not convert unlike
          # scales. Normalize the right operand into the left unit first.
          right.convert_to(left.formula)
        end
      end
    end
  end
end
