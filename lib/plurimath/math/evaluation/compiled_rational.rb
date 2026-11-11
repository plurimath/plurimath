# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Exact rational expression algebra. Sampling never substitutes a
      # finite Taylor series for a reciprocal.
      class SamplingFraction < Numeric
        attr_reader :numerator, :denominator, :size

        def initialize(numerator, denominator = nil)
          @size = numerator.size
          @numerator = numerator
          @denominator = denominator || SamplingPolynomial.constant(1, size)
          raise Errors::Evaluation::DivisionByZeroError if @denominator.zero?
        end

        def convert(other)
          other.is_a?(SamplingFraction) ? other : self.class.new(SamplingPolynomial.constant(other, size))
        end

        def +(other)
          other = convert(other)
          self.class.new(numerator*other.denominator + other.numerator*denominator, denominator*other.denominator)
        end
        def -@ = self.class.new(-numerator, denominator)
        def -(other) = self + -convert(other)
        def *(other)
          other = convert(other)
          self.class.new(numerator*other.numerator, denominator*other.denominator)
        end
        def /(other)
          other = convert(other)
          self.class.new(numerator*other.denominator, denominator*other.numerator)
        end
        def **(power)
          power.negative? ? self.class.new(denominator**-power, numerator**-power) : self.class.new(numerator**power, denominator**power)
        end
        def constant_value = numerator.constant_value / denominator.constant_value
        def primal = numerator.primal / denominator.primal
        def real? = true
        def finite? = true
        def zero? = numerator.zero?
        def coerce(other) = [convert(other), self]
      end

      class CompiledRational < CompiledPolynomial
        attr_reader :denominator_interval

        def initialize(fraction, supports)
          @denominator_interval = interval(fraction.denominator, supports)
          unless @denominator_interval[0].positive? || @denominator_interval[1].negative?
            raise Gum::UnsupportedModel, "denominator support certificate includes zero"
          end
          @offset = fraction.primal
          residual = fraction.numerator - fraction.denominator*@offset
          @numerator = CompiledPolynomial.new(residual)
          @denominator = CompiledPolynomial.new(fraction.denominator)
          @degrees = @numerator.degrees
          @denominator_center = @denominator.offset.to_f
          unless @denominator_center.finite? && !@denominator_center.zero?
            raise Gum::UnsupportedModel, "denominator center outside binary64 range"
          end
        end

        def call(deviations)
          divisor = @denominator_center + @denominator.call(deviations)
          raise Gum::NumericalFailure, "sampled denominator lost its nonzero certificate in binary64" unless divisor.finite? && !divisor.zero?
          @numerator.call(deviations) / divisor
        end

        def numeric_backend = "binary64-centered-certified-rational"

        private

        def interval(polynomial, supports)
          total = [0r,0r]
          polynomial.terms.each do |powers, coefficient|
            term = [coefficient,coefficient]
            powers.each_with_index do |power, index|
              next if power.zero?
              support = supports.fetch(index)
              raise Gum::UnsupportedModel, "finite output moments require finite certified rectangular denominator support" unless support
              lo,hi = support
              ends = [lo**power,hi**power]
              bound = [power.even? && lo <= 0 && hi >= 0 ? 0r : ends.min, ends.max]
              products = term.product(bound).map { |a,b| a*b }
              term = [products.min,products.max]
            end
            total = total.zip(term).map { |a,b| a+b }
          end
          total
        end
      end

      class RationalSamplingCompiler < Differentiator
        def initialize(formula, names, centers, definitions)
          @size = names.length
          @supports = definitions.each_with_index.map do |definition, i|
            next unless definition[:distribution] == :rectangular
            [Gum.exact(definition.fetch(:lower))-centers[i],Gum.exact(definition.fetch(:upper))-centers[i]]
          end
          bindings = names.each_with_index.to_h do |name,i|
            [name,SamplingFraction.new(SamplingPolynomial.variable(centers.fetch(i),i,@size))]
          end
          super(formula,bindings,mode: :strict)
        end

        def compile(formula)
          fraction = evaluate_formula(formula)
          fraction = SamplingFraction.new(SamplingPolynomial.constant(fraction,@size)) unless fraction.is_a?(SamplingFraction)
          CompiledRational.new(fraction,@supports)
        end

        def divide(left,right)
          left = SamplingFraction.new(SamplingPolynomial.constant(left,@size)) unless left.is_a?(SamplingFraction)
          left / right
        end

        def power(base,exponent)
          exponent = exponent.constant_value if exponent.is_a?(SamplingFraction)
          exponent = Gum.exact(exponent)
          unless exponent.denominator == 1 && exponent.abs <= 32
            raise Gum::UnsupportedModel, "sampling requires integer powers within -32..32"
          end
          base**exponent.numerator
        end
      end
    end
  end
end
