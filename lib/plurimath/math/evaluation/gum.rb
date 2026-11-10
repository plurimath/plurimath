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
        class NumericalFailure < StandardError; end
        class ConvergenceError < StandardError; end

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

        # JCGM101 8.1/8.2: validation is specific to this interval and p.
        # The MC tolerance must be at least five times tighter than the
        # target tolerance; coarse/still-running calculations cannot validate.
        def validate_coverage(guf_interval:, guf_standard_uncertainty:,
                              significant_digits:, probability:, interval:,
                              monte_carlo:)
          unless guf_interval.is_a?(Array) && guf_interval.length == 2 &&
              significant_digits.is_a?(Integer) && significant_digits.positive?
            raise InvalidInput, "validation needs two endpoints and positive significant_digits"
          end
          unless %i[symmetric shortest].include?(interval) && monte_carlo.is_a?(Hash) &&
              monte_carlo[:stabilized] == true && monte_carlo[:method] == :adaptive_mcm
            raise UnsupportedModel, "validation requires stabilized adaptive MCM of the requested interval kind"
          end
          p = exact(probability)
          raise InvalidInput, "coverage probability mismatch" unless p == exact(monte_carlo.fetch(:probability))
          target = MonteCarlo.numerical_tolerance(exact(guf_standard_uncertainty), significant_digits).to_r
          mc_tolerance = exact(monte_carlo.fetch(:numerical_tolerance))
          if mc_tolerance > target / 5
            raise UnsupportedModel, "MCM tolerance must be at least five times tighter for validation"
          end
          bounds = monte_carlo.fetch(:intervals).fetch(interval)
          left, right = guf_interval.map { |value| exact(value) }
          raise InvalidInput, "GUF interval endpoints must increase" unless left < right
          differences = [left, right].zip(bounds).map { |a, b| (a - exact(b)).abs }
          { adequacy: differences.all? { |difference| difference <= target } ? :validated : :not_validated,
            probability: p.to_s, interval: interval, tolerance: target.to_s,
            monte_carlo_tolerance: mc_tolerance.to_s,
            endpoint_differences: differences.map(&:to_s),
            engine: { name: "plurimath", version: Plurimath::VERSION,
                      method: "JCGM101-2008-8.1-8.2-v1" } }.freeze
        rescue KeyError => error
          raise InvalidInput, "missing validation result field: #{error.key}"
        end

        def grouped_type_a(**options)
          GroupedStatistics.evaluate(**options)
        end

        def linear_calibration(**options)
          Calibration.fit(**options)
        end

        def predict_calibration(calibration, **options)
          Calibration.predict(calibration, **options)
        end

        def type_a_covariance(observations)
          Covariance.type_a(observations)
        end

        def propagate_covariance(**options)
          Covariance.propagate(**options)
        end

        def correlation_matrix(covariance, **options)
          Covariance.correlations(covariance, **options)
        end

        def propagate_vector(**options)
          Covariance.transform(**options)
        end

        def coverage(**options)
          Statistics.coverage(**options)
        end

        def conformity(**options)
          Conformity.new(**options).evaluate
        end

        def monte_carlo(formula, **options)
          MonteCarlo.new(formula, **options).evaluate
        end

        # Explicit half-up decimal wire rounding, independent of BigDecimal
        # global limits/modes and printf's platform rounding conventions.
        def decimal_output(value, guard_digits)
          unless guard_digits.is_a?(Integer) && (1..12).cover?(guard_digits)
            raise InvalidInput, "binary64 statistical outputs support 1..12 declared digits"
          end
          number = output_rational(value)
          return "0" if number.zero?
          n, d = number.numerator.abs, number.denominator
          exponent = n.to_s.length - d.to_s.length
          too_large = exponent >= 0 ? n < d * 10**exponent : n * 10**(-exponent) < d
          exponent -= 1 if too_large
          places = guard_digits - 1 - exponent
          numerator, denominator = places >= 0 ? [n * 10**places, d] : [n, d * 10**(-places)]
          q, remainder = numerator.divmod(denominator)
          q += 1 if 2 * remainder >= denominator
          text = if places.positive?
                   digits = q.to_s.rjust(places + 1, "0")
                   (digits[0...-places] + "." + digits[-places..]).sub(/0+\z/, "").delete_suffix(".")
                 else
                   (q * 10**(-places)).to_s
                 end
          number.negative? ? "-#{text}" : text
        end

        def decimal_places_output(value, places)
          number = output_rational(value)
          q, remainder = (number.numerator.abs * 10**places).divmod(number.denominator)
          q += 1 if 2 * remainder >= number.denominator
          digits = q.to_s.rjust(places + 1, "0")
          text = digits[0...-places] + "." + digits[-places..]
          number.negative? ? "-#{text}" : text
        end

        def output_rational(value)
          if value.is_a?(Float)
            raise NumericalFailure, "non-finite statistical result" unless value.finite?
            value.to_r
          else
            exact(value)
          end
        end
        private_class_method :output_rational

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

        # Axis0 treats matrix rows as observations; axis1 treats columns as
        # observations. Windows are zero-based [start,length] on that axis.
        def series(observations, axis:, window:, guard_digits:)
          decimal_output(1, guard_digits)
          unless observations.is_a?(Array) && [0, 1].include?(axis)
            raise InvalidInput, "series needs an Array and an explicit axis0 or1"
          end
          matrix = observations.first.is_a?(Array)
          if matrix
            width = observations.first.length
            unless width.positive? && observations.all? { |row| row.is_a?(Array) && row.length == width }
              raise InvalidInput, "matrix series must be nonempty and rectangular"
            end
            samples = axis.zero? ? observations : observations.transpose
          else
            raise InvalidInput, "a vector has only axis0" unless axis.zero?
            samples = observations
          end
          unless window.nil?
            unless window.is_a?(Array) && window.length == 2 && window.all? { |v| v.is_a?(Integer) } &&
                window[0] >= 0 && window[1] >= 2 && window.sum <= samples.length
              raise InvalidInput, "window must select at least two existing observations"
            end
            samples = samples.slice(*window)
          end
          vectors = matrix ? samples.transpose : [samples]
          results = vectors.map do |vector|
            statistics = type_a(vector)
            statistics.merge(
              sample_standard_deviation: decimal_output(decimal_sqrt(statistics[:sample_variance], guard_digits + 4), guard_digits),
              standard_uncertainty_of_mean: decimal_output(decimal_sqrt(statistics[:variance], guard_digits + 4), guard_digits),
              axis: axis, window: window, guard_digits: guard_digits,
              engine: { name: "plurimath", version: Plurimath::VERSION, method: "sample-series-v1" })
          end
          matrix ? results : results.first
        end

        # Half-width a about the estimate. Normal uses standard uncertainty,
        # not half-width; Student-t uses scale, not standard deviation.
        def component(distribution:, half_width: nil, standard_uncertainty: nil,
                      scale: nil, degrees_of_freedom: nil, boundary_half_width: nil,
                      pdf_degrees_of_freedom: nil, variance_degrees_of_freedom: :not_provided)
          if distribution != :student_t && !pdf_degrees_of_freedom.nil?
            raise InvalidInput, "PDF degrees of freedom apply only to Student-t"
          end
          if distribution != :student_t && !degrees_of_freedom.nil? && variance_degrees_of_freedom != :not_provided
            raise InvalidInput, "provide only one variance degrees-of-freedom argument"
          end
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
                       if pdf_degrees_of_freedom && degrees_of_freedom
                         raise InvalidInput, "use variance_degrees_of_freedom separately from Student-t PDF degrees"
                       end
                       nu = exact(pdf_degrees_of_freedom || degrees_of_freedom)
                       raise InvalidInput, "Student-t needs nonnegative scale and nu > 2" if sigma.negative? || nu <= 2
                       sigma**2 * nu / (nu - 2)
                     else
                       raise UnsupportedModel, "unsupported component distribution"
                     end
          variance_dof = if variance_degrees_of_freedom != :not_provided
                           variance_degrees_of_freedom
                         elsif distribution == :student_t
                           :unknown
                         else
                           degrees_of_freedom
                         end
          unless variance_dof.nil? || variance_dof == :unknown || exact(variance_dof).positive?
            raise InvalidInput, "variance degrees of freedom must be positive, nil or unknown"
          end
          result = { variance: variance, distribution: distribution,
                     degrees_of_freedom: variance_dof }
          result[:pdf_degrees_of_freedom] = nu if distribution == :student_t
          result.freeze
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
          if order == 1
            unknown_dof = components.zip(contributions).any? { |component, contribution| component[:degrees_of_freedom] == :unknown && !contribution.zero? }
            nu = effective_dof(components, contributions, variance)
            result[:effective_degrees_of_freedom] = nu
            result[:degrees_of_freedom_status] = if variance.zero?
                                                   :not_applicable
                                                 elsif unknown_dof
                                                   :unknown
                                                 else
                                                   nu.nil? ? :infinite : :finite
                                                 end
          end
          result.freeze
        end

        def effective_dof(components, contributions, variance)
          return nil if components.zip(contributions).any? { |component, contribution| component[:degrees_of_freedom] == :unknown && !contribution.zero? }

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
          Accuracy.with_decimal_context do
            BigDecimal(value.numerator, digits).div(value.denominator, digits).sqrt(digits)
          end
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
