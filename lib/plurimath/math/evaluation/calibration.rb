# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Unweighted ordinary least squares, GUM100 H.3. Temperatures are exact
      # abscissae; residuals have independent common variance. No linearity
      # test, normality inference or errors-in-variables fit is hidden here.
      module Calibration
        module_function

        def fit(temperatures:, corrections:, reference_temperature:,
                abscissa_uncertainty:, residual_model:, guard_digits:)
          unless abscissa_uncertainty == :negligible && residual_model == :independent_common_variance
            raise Gum::UnsupportedModel, "calibration requires negligible abscissa uncertainty and independent common-variance residuals"
          end
          unless temperatures.is_a?(Array) && corrections.is_a?(Array) && temperatures.length == corrections.length && temperatures.length >= 3
            raise Gum::InvalidInput, "linear calibration needs at least three paired observations"
          end
          validate_digits(guard_digits)
          x = temperatures.map { |value| Gum.exact(value) }
          y = corrections.map { |value| Gum.exact(value) }
          t0 = Gum.exact(reference_temperature)
          theta = x.map { |value| value - t0 }
          n = x.length
          sum = theta.sum
          squares = theta.sum { |value| value**2 }
          cross = theta.zip(y).sum { |a, b| a*b }
          determinant = n*squares - sum**2
          raise Gum::InvalidInput, "calibration design is singular" unless determinant.positive?
          intercept = (y.sum*squares - cross*sum) / determinant
          slope = (n*cross - y.sum*sum) / determinant
          residuals = theta.zip(y).map { |value, response| response - intercept - slope*value }
          variance = residuals.sum { |value| value**2 } / (n - 2)
          covariance = [[variance*squares/determinant, -variance*sum/determinant],
                        [-variance*sum/determinant, variance*n/determinant]]
          { intercept: intercept, slope: slope, covariance: covariance,
            reference_temperature: t0, temperature_range: [x.min, x.max],
            count: n, degrees_of_freedom: n - 2, residuals: residuals,
            residual_variance: variance,
            residual_standard_deviation: decimal_root(variance, guard_digits),
            abscissa_uncertainty: abscissa_uncertainty, residual_model: residual_model,
            residual_distribution: :unspecified, adequacy: :not_assessed,
            guard_digits: guard_digits,
            engine: { name: "plurimath", version: Plurimath::VERSION,
                      method: "GUM100-H3-unweighted-OLS-v1" } }.freeze
        end

        def predict(calibration, temperature:, target:, temperature_uncertainty:,
                    guard_digits:)
          unless calibration.is_a?(Hash) && calibration.dig(:engine, :method) == "GUM100-H3-unweighted-OLS-v1"
            raise Gum::InvalidInput, "provide a linear calibration result"
          end
          unless %i[mean_correction new_observation].include?(target) && temperature_uncertainty == :negligible
            raise Gum::UnsupportedModel, "prediction requires an explicit target and negligible temperature uncertainty"
          end
          validate_digits(guard_digits)
          t = Gum.exact(temperature)
          delta = t - calibration.fetch(:reference_temperature)
          estimate = calibration.fetch(:intercept) + calibration.fetch(:slope)*delta
          cov = calibration.fetch(:covariance)
          variance = cov[0][0] + 2*delta*cov[0][1] + delta**2*cov[1][1]
          variance += calibration.fetch(:residual_variance) if target == :new_observation
          range = calibration.fetch(:temperature_range)
          { estimate: estimate, variance: variance,
            standard_uncertainty: decimal_root(variance, guard_digits),
            target: target, outside_calibration_range: t < range[0] || t > range[1],
            degrees_of_freedom: calibration.fetch(:degrees_of_freedom),
            adequacy: :not_assessed, guard_digits: guard_digits,
            engine: { name: "plurimath", version: Plurimath::VERSION,
                      method: "GUM100-H3-calibration-prediction-v1" } }.freeze
        end

        def decimal_root(value, digits)
          Accuracy.with_decimal_context { BigDecimal(value.numerator, digits).div(value.denominator, digits).sqrt(digits) }
        end

        def validate_digits(digits)
          raise Gum::InvalidInput, "guard_digits must be positive" unless digits.is_a?(Integer) && digits.positive?
        end
        private_class_method :decimal_root, :validate_digits
      end
    end
  end
end
