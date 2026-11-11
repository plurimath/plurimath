# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Full exact polynomial compilation reuses Taylor's rational algebra.
      # Unlike derivative jets it retains every term (within an explicit cap).
      class SamplingPolynomial < Taylor
        class NonConstant < Gum::UnsupportedModel; end

        DEGREE_LIMIT = nil
        MAX_TERMS = 128

        def constant_value
          unless terms.keys.all? { |powers| powers.sum.zero? }
            raise NonConstant, "finite output moments are not established for non-polynomial sampling models"
          end
          primal
        end
      end

      # Expand about exact PDF centers before any binary64 model arithmetic.
      # Thus (1e16+x-1e16), and equivalent polynomial cancellation, cannot
      # erase a small sampled signal. Accumulate centered terms in fixed order.
      class CompiledPolynomial
        attr_reader :degrees, :offset

        def initialize(polynomial)
          @offset = polynomial.primal
          @degrees = Array.new(polynomial.size) { |i| polynomial.terms.keys.map { |powers| powers[i] }.max || 0 }
          if polynomial.terms.keys.any? { |powers| powers.sum > 32 }
            raise Gum::UnsupportedModel, "sampling polynomial degree exceeds32"
          end
          @terms = polynomial.terms.sort_by(&:first).filter_map do |powers, coefficient|
            next if powers.sum.zero?
            number = coefficient.to_f
            unless number.finite? && !number.zero?
              raise Gum::UnsupportedModel, "centered model coefficient outside binary64 range"
            end
            factors = powers.each_with_index.filter_map { |power, index| [index, power] unless power.zero? }
            [number, factors]
          end
        end

        def numeric_backend = "binary64-centered-exact-polynomial"

        def call(deviations)
          sum = 0.0
          correction = 0.0
          @terms.each do |coefficient, factors|
            term = coefficient
            factors.each do |index, power|
              power.times { term *= deviations.fetch(index) }
            end
            adjusted = term - correction
            total = sum + adjusted
            correction = (total - sum) - adjusted
            sum = total
          end
          sum
        end
      end

      class SamplingCompiler < Differentiator
        def initialize(formula, names, centers)
          @size = names.length
          bindings = names.each_with_index.to_h do |name, i|
            [name, SamplingPolynomial.variable(centers.fetch(i), i, @size)]
          end
          super(formula, bindings, mode: :strict)
        end

        def compile(formula)
          polynomial = evaluate_formula(formula)
          polynomial = SamplingPolynomial.constant(polynomial, @size) unless polynomial.is_a?(SamplingPolynomial)
          CompiledPolynomial.new(polynomial)
        end

        def divide(left, right)
          right = right.constant_value if right.is_a?(SamplingPolynomial)
          raise Errors::Evaluation::DivisionByZeroError if right.zero?
          left / Gum.exact(right)
        end

        def power(base, exponent)
          exponent = exponent.constant_value if exponent.is_a?(SamplingPolynomial)
          exponent = Gum.exact(exponent)
          unless exponent.denominator == 1 && exponent.abs <= 32
            raise Gum::UnsupportedModel, "sampling requires integer powers within -32..32"
          end
          n = exponent.numerator
          base = base.constant_value if n.negative? && base.is_a?(SamplingPolynomial)
          raise Errors::Evaluation::DivisionByZeroError if n.negative? && base.zero?
          base**n
        end
      end
    end
  end
end
