# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Binary64 statistical functions with a declared, verified output domain.
      # Student-t CDF uses adaptive integration of its normalized density;
      # quantiles bracket that monotone CDF, never a table interpolation.
      module Statistics
        module_function

        def normal_cdf(value) = 0.5 * ::Math.erfc(-value / ::Math.sqrt(2))
        def normal_tail(value) = 0.5 * ::Math.erfc(value / ::Math.sqrt(2))

        def coverage(standard_uncertainty:, probability:, degrees_of_freedom:,
                     guard_digits:)
          unless guard_digits.is_a?(Integer) && (1..8).cover?(guard_digits)
            raise Gum::InvalidInput, "coverage factors support 1..8 declared digits"
          end
          p = Gum.exact(probability)
          unless p >= 1r / 2 && p <= 999r / 1000
            raise Gum::UnsupportedModel, "verified coverage probability domain is 0.5..0.999"
          end
          uncertainty = Gum.exact(standard_uncertainty)
          raise Gum::InvalidInput, "negative standard uncertainty" if uncertainty.negative?
          unless uncertainty.to_f.finite? && (uncertainty.zero? || !uncertainty.to_f.zero?)
            raise Gum::UnsupportedModel, "standard uncertainty outside binary64 range"
          end
          nu = degrees_of_freedom.nil? ? nil : Gum.exact(degrees_of_freedom)
          unless nu.nil? || (nu >= 1 && nu <= 10_000)
            raise Gum::UnsupportedModel, "verified Student-t degrees of freedom domain is 1..10000"
          end
          factor = quantile(((1 + p) / 2).to_f, nu&.to_f)
          expanded = uncertainty.to_f * factor
          { coverage_factor: Gum.decimal_output(factor, guard_digits),
            expanded_uncertainty: Gum.decimal_output(expanded, guard_digits),
            probability: p.to_s, degrees_of_freedom: nu&.to_s,
            guard_digits: guard_digits, precision_convention: :significant_digits, distribution: nu.nil? ? :normal : :student_t,
            engine: { name: "plurimath", version: Plurimath::VERSION,
                      method: "normalized-density-coverage-v1", numeric_backend: "binary64" } }.freeze
        end

        def quantile(probability, nu)
          cdf = nu.nil? ? ->(x) { normal_cdf(x) } : ->(x) { student_cdf(x, nu) }
          lower = 0.0
          upper = 1.0
          upper *= 2 while cdf.call(upper) < probability && upper < 1_000_000
          raise Gum::NumericalFailure, "quantile could not be bracketed" if cdf.call(upper) < probability
          64.times do
            midpoint = (lower + upper) / 2
            if cdf.call(midpoint) < probability
              lower = midpoint
            else
              upper = midpoint
            end
          end
          (lower + upper) / 2
        end

        def student_cdf(value, nu)
          return 0.5 if value.zero?
          return 1 - student_cdf(-value, nu) if value.negative?
          log_constant = ::Math.lgamma((nu + 1) / 2).first - ::Math.lgamma(nu / 2).first - 0.5 * ::Math.log(nu * ::Math::PI)
          density = ->(x) { ::Math.exp(log_constant - (nu + 1) / 2 * ::Math.log1p(x*x / nu)) }
          a = density.call(0.0)
          b = density.call(value / 2)
          c = density.call(value)
          whole = value * (a + 4*b + c) / 6
          integral = integrate(density, 0.0, value, a, b, c, whole, 1e-13, 24)
          result = 0.5 + integral
          unless result >= 0 && result <= 1 + 1e-11
            raise Gum::NumericalFailure, "Student-t CDF outside numerical range"
          end
          [result, 1.0].min
        end

        def integrate(function, left, right, a, b, c, whole, tolerance, depth)
          midpoint = (left + right) / 2
          d = function.call((left + midpoint) / 2)
          e = function.call((midpoint + right) / 2)
          l = (midpoint - left) * (a + 4*d + b) / 6
          r = (right - midpoint) * (b + 4*e + c) / 6
          error = l + r - whole
          return l + r + error / 15 if error.abs <= 15 * tolerance
          raise Gum::NumericalFailure, "Student-t CDF quadrature did not converge" if depth.zero?
          integrate(function, left, midpoint, a, d, b, l, tolerance / 2, depth - 1) +
            integrate(function, midpoint, right, b, e, c, r, tolerance / 2, depth - 1)
        end
        private_class_method :quantile, :student_cdf, :integrate
      end
    end
  end
end
