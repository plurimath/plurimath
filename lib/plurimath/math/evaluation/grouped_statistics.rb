# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Balanced repeated-observation summaries, GUM100 H.5. The caller
      # chooses the variance model; an F statistic never silently changes it.
      module GroupedStatistics
        module_function

        def evaluate(group_means:, group_sample_variances:, observations_per_group:,
                     variance_model:, guard_digits:)
          unless group_means.is_a?(Array) && group_sample_variances.is_a?(Array) &&
              group_means.length >= 2 && group_means.length == group_sample_variances.length &&
              observations_per_group.is_a?(Integer) && observations_per_group >= 2
            raise Gum::InvalidInput, "balanced groups need paired summaries, J>=2 and K>=2"
          end
          unless %i[random_group_effect no_group_effect].include?(variance_model)
            raise Gum::UnsupportedModel, "declare random_group_effect or no_group_effect"
          end
          unless guard_digits.is_a?(Integer) && guard_digits.positive?
            raise Gum::InvalidInput, "guard_digits must be positive"
          end
          means = group_means.map { |value| Gum.exact(value) }
          within = group_sample_variances.map { |value| Gum.exact(value) }
          raise Gum::InvalidInput, "negative within-group variance" if within.any?(&:negative?)
          j, k = means.length, observations_per_group
          grand = means.sum / j
          variance_of_means = means.sum { |value| (value - grand)**2 } / (j - 1)
          ms_between = k * variance_of_means
          ms_within = within.sum / j
          between_component = (ms_between - ms_within) / k
          if variance_model == :random_group_effect && between_component.negative?
            raise Gum::UnsupportedModel, "negative estimated group component requires an explicit constrained model; no clipping is inferred"
          end
          all_variance = ((j - 1)*ms_between + j*(k - 1)*ms_within) / (j*k - 1)
          variance = variance_model == :random_group_effect ? variance_of_means / j : all_variance / (j*k)
          uncertainty = Accuracy.with_decimal_context do
            BigDecimal(variance.numerator, guard_digits).div(variance.denominator, guard_digits).sqrt(guard_digits)
          end
          { mean: grand, groups: j, observations_per_group: k, count: j*k,
            within_group_variance: ms_within, group_mean_variance: variance_of_means,
            between_group_component: between_component, between_mean_square: ms_between,
            within_mean_square: ms_within, all_observations_sample_variance: all_variance,
            f_statistic: ms_within.zero? ? nil : ms_between / ms_within,
            f_degrees_of_freedom: [j - 1, j*(k - 1)],
            variance: variance, standard_uncertainty: uncertainty,
            degrees_of_freedom: variance_model == :random_group_effect ? j - 1 : j*k - 1,
            variance_model: variance_model, adequacy: :not_assessed, guard_digits: guard_digits,
            engine: { name: "plurimath", version: Plurimath::VERSION,
                      method: "GUM100-H5-balanced-groups-v1" } }.freeze
        end
      end
    end
  end
end
