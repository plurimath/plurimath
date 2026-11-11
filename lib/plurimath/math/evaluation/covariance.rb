# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Exact covariance algebra in the caller's coherent unit system.
      # Zero covariance is not used as evidence of a joint normal law.
      module Covariance
        module_function

        def type_a(observations)
          unless observations.is_a?(Array) && observations.length >= 2 && observations.first.is_a?(Array) &&
              !observations.first.empty? && observations.all? { |row| row.is_a?(Array) && row.length == observations.first.length }
            raise Gum::InvalidInput, "paired Type-A observations need a rectangular matrix with at least two rows"
          end
          values = observations.map { |row| row.map { |value| Gum.exact(value) } }
          n, width = values.length, values.first.length
          means = values.transpose.map { |column| column.sum / n }
          sample = Array.new(width) do |i|
            Array.new(width) do |j|
              values.sum { |row| (row[i] - means[i]) * (row[j] - means[j]) } / (n - 1)
            end
          end
          { count: n, means: means, sample_covariance: sample,
            covariance_of_mean: sample.map { |row| row.map { |value| value / n } },
            degrees_of_freedom: n - 1, distribution: :unspecified,
            engine: { name: "plurimath", version: Plurimath::VERSION,
                      method: "paired-TypeA-covariance-v1" } }.freeze
        end

        # JCGM1005.2.2, equation13. A vector result retains output covariance.
        def transform(estimates:, jacobian:, covariance:, guard_digits:)
          matrix = checked(covariance)
          n = matrix.length
          unless estimates.is_a?(Array) && jacobian.is_a?(Array) && estimates.length == jacobian.length &&
              !estimates.empty? && jacobian.all? { |row| row.is_a?(Array) && row.length == n }
            raise Gum::InvalidInput, "estimate/Jacobian shape mismatch"
          end
          rows = jacobian.map { |row| row.map { |value| Gum.exact(value) } }
          output = rows.map { |a| rows.map { |b| bilinear(a, matrix, b) } }
          { estimates: estimates.map { |value| Gum.exact(value) }, covariance: output,
            standard_uncertainties: output.each_index.map { |i| root(output[i][i], guard_digits) },
            method: :lpu_covariance, adequacy: :not_assessed, guard_digits: guard_digits,
            effective_degrees_of_freedom: nil, degrees_of_freedom_status: :not_evaluated_for_correlated_inputs,
            engine: { name: "plurimath", version: Plurimath::VERSION,
                      method: "JCGM100-2008-equation13-v1" } }.freeze
        end

        # Gaussian moment contraction through covariance order2. For g,H,T,
        # Var=f'g Σ g +tr(HΣHΣ)/2 +(Σg)'(T:Σ); bias=tr(HΣ)/2.
        def propagate(estimate:, components:, gradient:, covariance:, joint_distribution:,
                      order: 1, hessian: nil, third: nil, derivatives_complete: false,
                      guard_digits:)
          matrix = checked(covariance)
          n = matrix.length
          unless components.is_a?(Array) && components.length == n &&
              gradient.is_a?(Array) && gradient.length == n &&
              components.each_with_index.all? { |component, i| component.is_a?(Hash) && component.key?(:variance) && Gum.exact(component[:variance]) == matrix[i][i] }
            raise Gum::InvalidInput, "components/gradient/covariance diagonal mismatch"
          end
          raise Gum::InvalidInput, "order must be1 or2" unless [1, 2].include?(order)
          g = gradient.map { |value| Gum.exact(value) }
          mean = Gum.exact(estimate)
          variance = bilinear(g, matrix, g)
          if order == 2
            unless joint_distribution == :multivariate_normal && components.all? { |component| component[:distribution] == :normal }
              raise Gum::UnsupportedModel, "GUF2 covariance requires an explicitly joint multivariate normal law"
            end
            unless derivatives_complete && hessian && third
              raise Gum::UnsupportedModel, "complete analytic Hessian and third derivatives are required"
            end
            h = tensor(hessian, n, 2)
            t = tensor(third, n, 3)
            n.times do |i|
              n.times do |j|
                raise Gum::InvalidInput, "Hessian must be symmetric" unless h[i][j] == h[j][i]
                n.times do |k|
                  unless t[i][j][k] == t[j][i][k] && t[i][j][k] == t[i][k][j]
                    raise Gum::InvalidInput, "third derivative tensor must be symmetric"
                  end
                end
              end
            end
            product = h.map { |row| matrix.transpose.map { |column| row.zip(column).sum { |a, b| a*b } } }
            n.times do |i|
              n.times do |j|
                mean += h[i][j] * matrix[i][j] / 2r
                variance += product[i][j] * product[j][i] / 2r
              end
              contracted_third = n.times.sum { |j| n.times.sum { |k| t[i][j][k] * matrix[j][k] } }
              variance += g.zip(matrix[i]).sum { |a, b| a*b } * contracted_third
            end
          end
          raise Gum::UnsupportedModel, "Taylor covariance approximation gives negative variance" if variance.negative?
          { estimate: mean, variance: variance, standard_uncertainty: root(variance, guard_digits),
            guard_digits: guard_digits, method: order == 1 ? :lpu_covariance : :guf2_covariance,
            joint_distribution: joint_distribution, adequacy: :not_assessed,
            effective_degrees_of_freedom: nil, degrees_of_freedom_status: :not_evaluated_for_correlated_inputs,
            engine: { name: "plurimath", version: Plurimath::VERSION,
                      method: "Gaussian-covariance-contraction-v1" } }.freeze
        end

        def correlations(covariance, guard_digits:)
          matrix = checked(covariance)
          unless guard_digits.is_a?(Integer) && guard_digits.positive?
            raise Gum::InvalidInput, "guard_digits must be positive"
          end
          Accuracy.with_decimal_context do
            matrix.each_index.map do |i|
              matrix.each_index.map do |j|
                product = matrix[i][i]*matrix[j][j]
                next nil if product.zero?
                numerator = matrix[i][j]
                next BigDecimal(numerator.negative? ? "-1" : "1") if numerator**2 == product
                divisor = root(product, guard_digits + 8)
                BigDecimal(numerator.numerator, guard_digits + 8).div(numerator.denominator, guard_digits + 8).div(divisor, guard_digits)
              end
            end
          end
        end

        # Exact Schur complements accept singular PSD matrices; no diagonal
        # jitter, rounding tolerance or invented correlation is introduced.
        def checked(covariance)
          unless covariance.is_a?(Array) && !covariance.empty? &&
              covariance.all? { |row| row.is_a?(Array) && row.length == covariance.length }
            raise Gum::InvalidInput, "covariance must be a nonempty square matrix"
          end
          matrix = covariance.map { |row| row.map { |value| Gum.exact(value) } }
          n = matrix.length
          unless n.times.all? { |i| n.times.all? { |j| matrix[i][j] == matrix[j][i] } }
            raise Gum::InvalidInput, "covariance must be symmetric"
          end
          remainder = matrix.map(&:dup)
          n.times do |k|
            pivot = remainder[k][k]
            raise Gum::InvalidInput, "covariance is not positive semidefinite" if pivot.negative?
            if pivot.zero?
              unless (k+1...n).all? { |i| remainder[i][k].zero? }
                raise Gum::InvalidInput, "covariance is not positive semidefinite"
              end
              next
            end
            (k+1...n).each do |i|
              (i...n).each do |j|
                remainder[i][j] -= remainder[i][k] * remainder[j][k] / pivot
                remainder[j][i] = remainder[i][j]
              end
            end
          end
          matrix
        end

        def bilinear(a, covariance, b)
          a.each_index.sum { |i| b.each_index.sum { |j| a[i] * covariance[i][j] * b[j] } }
        end

        def tensor(values, n, rank)
          raise Gum::InvalidInput, "derivative tensor shape mismatch" unless values.is_a?(Array) && values.length == n
          rank == 1 ? values.map { |value| Gum.exact(value) } : values.map { |value| tensor(value, n, rank - 1) }
        end

        def root(variance, digits)
          unless digits.is_a?(Integer) && digits.positive?
            raise Gum::InvalidInput, "guard_digits must be positive"
          end
          Accuracy.with_decimal_context { BigDecimal(variance.numerator, digits).div(variance.denominator, digits).sqrt(digits) }
        end
        private_class_method :checked, :bilinear, :tensor, :root
      end
    end
  end
end
