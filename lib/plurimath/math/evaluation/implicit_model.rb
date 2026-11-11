# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Linearization of h(y,x)=0 at caller-supplied roots. This operation
      # does not find roots or infer the adequacy of a local linear model.
      module ImplicitModel
        module_function

        def propagate(estimates:, output_jacobian:, input_jacobian:, covariance:,
                      residuals:, residual_tolerance:, guard_digits:)
          unless estimates.is_a?(Array) && !estimates.empty?
            raise Gum::InvalidInput, "implicit model needs output estimates"
          end
          n = estimates.length
          cy = matrix(output_jacobian, n, n)
          unless covariance.is_a?(Array) && !covariance.empty?
            raise Gum::InvalidInput, "implicit model needs input covariance"
          end
          cx = matrix(input_jacobian, n, covariance.length)
          tolerance = Gum.exact(residual_tolerance)
          unless tolerance >= 0 && residuals.is_a?(Array) && residuals.length == n
            raise Gum::InvalidInput, "provide residuals and a nonnegative residual tolerance"
          end
          errors = residuals.map { |value| Gum.exact(value) }
          if errors.any? { |value| value.abs > tolerance }
            raise Gum::UnsupportedModel, "supplied root residual exceeds declared tolerance"
          end
          # Solve Cy*J=-Cx with exact Gauss-Jordan elimination. Pivoting
          # avoids rejecting nonsingular matrices with a zero leading entry.
          augmented = cy.each_index.map { |i| cy[i] + cx[i].map { |value| -value } }
          n.times do |column|
            pivot = (column...n).find { |row| !augmented[row][column].zero? }
            raise Gum::UnsupportedModel, "implicit output Jacobian is singular" unless pivot
            augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
            divisor = augmented[column][column]
            augmented[column] = augmented[column].map { |value| value / divisor }
            n.times do |row|
              next if row == column
              factor = augmented[row][column]
              augmented[row] = augmented[row].zip(augmented[column]).map { |a, b| a - factor*b }
            end
          end
          jacobian = augmented.map { |row| row.drop(n) }
          result = Covariance.transform(estimates: estimates, jacobian: jacobian,
                                        covariance: covariance, guard_digits: guard_digits)
          result.merge(input_sensitivities: jacobian, root_residuals: errors,
                       residual_tolerance: tolerance, root_solver: :caller_supplied,
                       adequacy: :not_assessed,
                       engine: { name: "plurimath", version: Plurimath::VERSION,
                                 method: "implicit-Jacobian-LPU-v1" }).freeze
        end

        def matrix(value, rows, columns)
          unless value.is_a?(Array) && value.length == rows &&
              value.all? { |row| row.is_a?(Array) && row.length == columns }
            raise Gum::InvalidInput, "implicit Jacobian shape mismatch"
          end
          value.map { |row| row.map { |entry| Gum.exact(entry) } }
        end
        private_class_method :matrix
      end
    end
  end
end
