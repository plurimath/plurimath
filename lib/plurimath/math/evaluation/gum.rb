# frozen_string_literal: true

require "bigdecimal"
require "plurimath/version"

module Plurimath
  module Math
    module Evaluation
      # Independent-input propagation with explicit analytic derivatives.
      # Derivatives and components must use one caller-declared coherent unit
      # system. This API does not infer units, independence or derivatives.
      module Gum
        class InvalidInput < ArgumentError; end
        class UnsupportedModel < InvalidInput; end

        module_function

        def exact(value)
          case value
          when Integer, Rational then value.to_r
          when BigDecimal
            raise InvalidInput, "non-finite decimal" unless value.finite?
            value.to_r
          when String
            Rational(value)
          else
            raise InvalidInput, "use exact integers, rationals or decimal strings"
          end
        rescue ArgumentError, ZeroDivisionError
          raise InvalidInput, "invalid exact numeric input"
        end

        # Differentiate an existing Formula using its canonical parser. The
        # supplied estimate/component hash order defines the derivative axes.
        def analyze(formula, estimates:, components:, independent:, order: 1,
                    guard_digits:)
          unless estimates.is_a?(Hash) && components.is_a?(Hash) &&
              estimates.keys == components.keys && !estimates.empty?
            raise InvalidInput, "estimates and components need identical ordered keys"
          end
          names = estimates.keys.map(&:to_s)
          unless names.uniq.length == names.length && estimates.keys.all? { |key| key.is_a?(String) || key.is_a?(Symbol) }
            raise InvalidInput, "variable names must be distinct strings or symbols"
          end
          n = names.length
          bindings = estimates.values.each_with_index.to_h do |value, i|
            [names[i], Taylor.variable(value, i, n)]
          end
          jet = Differentiator.new(formula, bindings, mode: :strict).evaluate_formula(formula)
          jet = Taylor.constant(jet, n) unless jet.is_a?(Taylor)
          gradient = Array.new(n) { |i| jet.derivative([i]) }
          hessian = Array.new(n) { |i| Array.new(n) { |j| jet.derivative([i, j]) } }
          third = Array.new(n) { |i| Array.new(n) { |j| Array.new(n) { |k| jet.derivative([i, j, k]) } } }
          propagate(estimate: jet.primal, components: components.values,
                    gradient: gradient, independent: independent, order: order,
                    hessian: hessian, third: third, derivatives_complete: true,
                    guard_digits: guard_digits).merge(
                      variables: names.freeze, gradient: gradient.freeze,
                      hessian: hessian, third: third).freeze
        end

        # JCGM 100 4.2.3: uncertainty of the mean, not sample dispersion.
        def type_a(observations)
          raise InvalidInput, "observations must be an Array" unless observations.is_a?(Array)

          values = observations.map { |value| exact(value) }
          n = values.length
          raise InvalidInput, "Type A needs at least two observations" if n < 2

          mean = values.sum.quo(n)
          variance = values.sum { |value| (value - mean)**2 }.quo(n - 1)
          { count: n, mean: mean, minimum: values.min, maximum: values.max,
            sample_variance: variance, variance: variance.quo(n),
            degrees_of_freedom: n - 1, distribution: :unspecified }.freeze
        end

        # Half-width a about the estimate. Normal uses standard uncertainty,
        # not half-width; Student-t uses scale, not standard deviation.
        def component(distribution:, half_width: nil, standard_uncertainty: nil,
                      scale: nil, degrees_of_freedom: nil, boundary_half_width: nil)
          variance = case distribution
                     when :rectangular, :triangular, :arcsine
                       a = exact(half_width)
                       raise InvalidInput, "half-width must be nonnegative" if a.negative?
                       a**2 / { rectangular: 3r, triangular: 6r, arcsine: 2r }.fetch(distribution)
                     when :curvilinear_trapezoid
                       a = exact(half_width)
                       d = exact(boundary_half_width)
                       unless d.positive? && a > d
                         raise InvalidInput, "curvilinear trapezoid needs 0 < boundary half-width < nominal half-width"
                       end
                       a**2 / 3r + d**2 / 9r
                     when :normal
                       u = exact(standard_uncertainty)
                       raise InvalidInput, "uncertainty must be nonnegative" if u.negative?
                       u**2
                     when :student_t
                       sigma = exact(scale)
                       nu = exact(degrees_of_freedom)
                       raise InvalidInput, "Student-t needs nonnegative scale and nu > 2" if sigma.negative? || nu <= 2
                       sigma**2 * nu / (nu - 2)
                     else
                       raise UnsupportedModel, "unsupported component distribution"
                     end
          { variance: variance, distribution: distribution,
            degrees_of_freedom: degrees_of_freedom }.freeze
        end

        # JCGM 100 5.1.2 / note and JCGM 101 5.6: GUF2 is restricted
        # to independent normal inputs. Third derivatives are required even
        # when all Hessian terms vanish. Omitted entries are explicit zeros
        # only when the caller declares complete derivative tensors.
        def propagate(estimate:, components:, gradient:, independent:,
                      order: 1, hessian: nil, third: nil,
                      derivatives_complete: false, guard_digits:)
          raise UnsupportedModel, "joint dependence is unsupported" unless independent == true
          raise InvalidInput, "order must be 1 or 2" unless [1, 2].include?(order)
          unless guard_digits.is_a?(Integer) && guard_digits.positive?
            raise InvalidInput, "guard_digits must be positive"
          end
          unless components.is_a?(Array) && gradient.is_a?(Array) &&
              components.all? { |component| component.is_a?(Hash) && component.key?(:variance) }
            raise InvalidInput, "components need explicit variances and gradient must be an Array"
          end
          n = components.length
          raise InvalidInput, "gradient shape mismatch" unless gradient.length == n
          variances = components.map do |component|
            v = exact(component.fetch(:variance))
            raise InvalidInput, "negative variance" if v.negative?
            v
          end
          g = gradient.map { |value| exact(value) }
          contributions = g.zip(variances).map { |c, v| c**2 * v }
          variance = contributions.sum
          mean = exact(estimate)
          if order == 2
            unless components.all? { |component| component[:distribution] == :normal }
              raise UnsupportedModel, "GUF2 requires normal inputs; use distribution propagation"
            end
            unless derivatives_complete && hessian && third
              raise UnsupportedModel, "GUF2 requires complete analytic Hessian and third derivatives"
            end
            h = tensor(hessian, n, 2)
            t = tensor(third, n, 3)
            n.times do |i|
              n.times do |j|
                raise InvalidInput, "Hessian must be symmetric" unless h[i][j] == h[j][i]
                n.times do |k|
                  unless t[i][j][k] == t[j][i][k] && t[i][j][k] == t[i][k][j]
                    raise InvalidInput, "third derivative tensor must be symmetric"
                  end
                end
              end
            end
            n.times do |i|
              mean += h[i][i] * variances[i] / 2r
              n.times do |j|
                variance += (h[i][j]**2 / 2r + g[i] * t[i][j][j]) * variances[i] * variances[j]
              end
            end
          end
          raise UnsupportedModel, "Taylor approximation gives negative variance" if variance.negative?

          result = { estimate: mean, variance: variance,
                     standard_uncertainty: decimal_sqrt(variance, guard_digits),
                     guard_digits: guard_digits, method: order == 1 ? :lpu : :guf2,
                     adequacy: :not_assessed,
                     engine: { name: "plurimath", version: Plurimath::VERSION,
                               method: "independent-gum-v1" }.freeze }
          result[:effective_degrees_of_freedom] = effective_dof(components, contributions, variance) if order == 1
          result.freeze
        end

        def effective_dof(components, contributions, variance)
          denominator = components.zip(contributions).sum do |component, contribution|
            nu = component[:degrees_of_freedom]
            next 0 if nu.nil? || contribution.zero?

            nu = exact(nu)
            raise InvalidInput, "degrees of freedom must be positive" unless nu.positive?
            contribution**2 / nu
          end
          return nil if denominator.zero? # infinite degrees of freedom

          variance**2 / denominator
        end

        def decimal_sqrt(value, digits)
          BigDecimal(value.numerator, digits).div(value.denominator, digits).sqrt(digits)
        end

        def tensor(values, n, rank)
          unless values.is_a?(Array) && values.length == n
            raise InvalidInput, "derivative tensor shape mismatch"
          end
          return values.map { |value| exact(value) } if rank == 1

          values.map { |value| tensor(value, n, rank - 1) }
        end
        private_class_method :tensor, :decimal_sqrt, :effective_dof
      end
    end
  end
end
