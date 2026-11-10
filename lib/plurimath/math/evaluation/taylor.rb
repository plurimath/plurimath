# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Exact truncated Taylor algebra. Coefficients include the factorial
      # divisor; derivative() restores it. No finite differences or floats.
      class Taylor < Numeric
        DEGREE_LIMIT = 3
        MAX_TERMS = nil
        attr_reader :terms, :size

        def initialize(terms, size)
          @size = size
          limit = self.class::DEGREE_LIMIT
          @terms = terms.reject { |powers, value| (limit && powers.sum > limit) || value.zero? }.freeze
          if self.class::MAX_TERMS && @terms.length > self.class::MAX_TERMS
            raise Gum::UnsupportedModel, "polynomial exceeds the bounded term domain"
          end
        end

        def self.constant(value, size)
          new({ Array.new(size, 0).freeze => Gum.exact(value) }, size)
        end

        def self.variable(value, index, size)
          powers = Array.new(size, 0)
          powers[index] = 1
          constant(value, size) + new({ powers.freeze => 1r }, size)
        end

        def +(other)
          other = convert(other)
          self.class.new(terms.merge(other.terms) { |_key, a, b| a + b }, size)
        end

        def -@ = self.class.new(terms.transform_values(&:-@), size)
        def -(other) = self + -convert(other)

        def *(other)
          other = convert(other)
          product = Hash.new(0r)
          terms.each do |a, x|
            other.terms.each do |b, y|
              powers = a.zip(b).map { |i, j| i + j }.freeze
              limit = self.class::DEGREE_LIMIT
              product[powers] += x * y if limit.nil? || powers.sum <= limit
              if self.class::MAX_TERMS && product.length > self.class::MAX_TERMS
                raise Gum::UnsupportedModel, "polynomial exceeds the bounded term domain"
              end
            end
          end
          self.class.new(product, size)
        end

        def /(other)
          other = convert(other)
          constant = other.primal
          raise Errors::Evaluation::DivisionByZeroError if constant.zero?

          delta = (other - constant) * (-1r / constant)
          sum = self.class.constant(1, size)
          power = sum
          3.times do
            power *= delta
            sum += power
          end
          self * sum * (1r / constant)
        end

        def **(exponent)
          exponent = exponent.constant_value if exponent.is_a?(Taylor)
          exponent = Gum.exact(exponent)
          unless exponent.denominator == 1
            raise Gum::UnsupportedModel, "analytic differentiation requires an integer exponent"
          end
          n = exponent.numerator
          return self.class.constant(1, size) / (self**-n) if n.negative?

          result = self.class.constant(1, size)
          base = self
          until n.zero?
            result *= base if n.odd?
            n /= 2
            base *= base unless n.zero?
          end
          result
        end

        def primal = terms.fetch(Array.new(size, 0), 0r)
        def real? = true
        def finite? = true
        def zero? = terms.empty?
        def coerce(other) = [convert(other), self]

        def constant_value
          unless terms.keys.all? { |powers| powers.sum.zero? }
            raise Gum::UnsupportedModel, "variable exponents are unsupported"
          end
          primal
        end

        def derivative(indices)
          powers = Array.new(size, 0)
          indices.each { |i| powers[i] += 1 }
          factorial = powers.reduce(1) { |acc, n| acc * (1..n).reduce(1, :*) }
          terms.fetch(powers, 0r) * factorial
        end

        private

        def convert(other)
          return self.class.constant(other, size) unless other.is_a?(Taylor)
          raise Gum::InvalidInput, "Taylor dimension mismatch" unless size == other.size

          other
        end
      end

      # Reuses the existing Formula expression parser and node dispatch.
      # Operations outside exact rational arithmetic are explicitly refused.
      class Differentiator < Evaluator
        def normalize_bindings(bindings) = bindings

        def evaluate_node(node)
          case node
          when Formula, Number, Symbols::Symbol, Function::Frac, Function::Power, Function::Fenced
            super
          else
            raise Gum::UnsupportedModel, "analytic derivatives unavailable for #{node.class}"
          end
        end
        def divide(left, right)
          return left / right if left.is_a?(Taylor) || right.is_a?(Taylor)

          Gum.exact(left) / Gum.exact(right)
        end

        def power(base, exponent)
          exponent = exponent.constant_value if exponent.is_a?(Taylor)
          exponent = Gum.exact(exponent)
          unless exponent.denominator == 1
            raise Gum::UnsupportedModel, "analytic differentiation requires an integer exponent"
          end
          base**exponent.numerator
        end

        def modulo(_left, _right)
          raise Gum::UnsupportedModel, "modulo is not differentiable by this backend"
        end

        def limited_operation(label, _values)
          raise Gum::UnsupportedModel, "analytic derivatives unavailable for #{label}"
        end

        def square_root(_node)
          raise Gum::UnsupportedModel, "analytic derivatives unavailable for sqrt"
        end
      end
    end
  end
end
