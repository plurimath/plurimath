# frozen_string_literal: true

require "bigdecimal"

module Plurimath
  module Math
    module Evaluation
      # JCGM101 7.9.4 adaptive batches with a finite, explicit resource cap.
      # Both interval kinds may be monitored simultaneously (a stronger stop).
      class MonteCarlo
        def initialize(formula, inputs:, independent:, seeds:, probability:,
                       interval:, significant_digits:, guard_digits:, max_samples:,
                       joint_covariance: nil, joint_distribution: nil)
          if independent == true
            unless joint_covariance.nil? && joint_distribution.nil?
              raise Gum::InvalidInput, "independent sampling cannot also declare a joint covariance or law"
            end
          elsif independent != false || joint_distribution != :multivariate_normal || joint_covariance.nil?
            raise Gum::UnsupportedModel, "joint sampling requires explicit multivariate_normal knowledge and covariance"
          end
          @joint_distribution = joint_distribution
          unless inputs.is_a?(Hash) && !inputs.empty? && inputs.keys.all? { |key| key.is_a?(String) || key.is_a?(::Symbol) }
            raise Gum::InvalidInput, "inputs must be a nonempty ordered PDF mapping"
          end
          @names = inputs.keys.map(&:to_s)
          raise Gum::InvalidInput, "duplicate variable names" unless @names.uniq.length == @names.length
          @probability = Gum.exact(probability)
          raise Gum::InvalidInput, "probability must lie strictly between zero and one" unless @probability.positive? && @probability < 1
          unless %i[symmetric shortest both].include?(interval)
            raise Gum::InvalidInput, "interval must be symmetric, shortest or both"
          end
          Gum.decimal_output(1, guard_digits)
          unless significant_digits.is_a?(Integer) && significant_digits.positive? && significant_digits <= guard_digits
            raise Gum::InvalidInput, "significant_digits must lie in 1..guard_digits"
          end
          @batch_size = [10_000, (100 / (1 - @probability)).ceil].max
          unless max_samples.is_a?(Integer) && max_samples >= 2 * @batch_size
            raise Gum::InvalidInput, "max_samples must admit at least two normative batches"
          end
          @max_samples = max_samples
          @max_batches = max_samples / @batch_size
          @significant_digits = significant_digits
          @guard_digits = guard_digits
          @interval = interval
          @generator = WichmannHill.new(seeds)
          centers = DistributionSampler.centers(inputs.values)
          @model = begin
            SamplingCompiler.new(formula, @names, centers).compile(formula)
          rescue SamplingPolynomial::NonConstant
            RationalSamplingCompiler.new(formula, @names, centers, inputs.values).compile(formula)
          end
          unless @model.is_a?(CompiledPolynomial) && @model.degrees.any?(&:positive?)
            raise Gum::UnsupportedModel, "constant models need exact analysis rather than adaptive uncertainty tolerance"
          end
          @sampler = if independent
                       DistributionSampler.new(inputs.values, @generator, degrees: @model.degrees, centered: true)
                     else
                       CorrelatedNormalSampler.new(inputs.values, joint_covariance, @generator)
                     end
        end

        def evaluate
          all = []
          batches = []
          @max_batches.times do
            values = Array.new(@batch_size) do
              value = @model.call(@sampler.draw)
              raise Gum::NumericalFailure, "non-finite sampled model value" unless value.real? && value.finite?
              value
            end
            all.concat(values)
            batches << summarize(values)
            next if batches.length < 2

            overall = moments(all)
            delta = self.class.numerical_tolerance(overall[:standard_uncertainty], @significant_digits)
            stability = batches.first.keys.to_h do |key|
              data = batches.map { |batch| batch.fetch(key) }
              mean = data.sum / data.length
              twice_se = 2 * ::Math.sqrt(data.sum { |value| (value - mean)**2 } / (data.length * (data.length - 1)))
              [key, twice_se]
            end
            next unless stability.values.all? { |twice_se| twice_se <= delta.to_f }

            return result(summarize(all), all.length, batches.length, delta, stability)
          end
          raise Gum::ConvergenceError, "adaptive MCM did not stabilize within #{@max_batches * @batch_size} samples"
        end

        # Equation18 after rounding the uncertainty to the requested number
        # of significant digits. Decimal exponent changes at carry boundaries.
        def self.numerical_tolerance(uncertainty, significant_digits)
          unless significant_digits.is_a?(Integer) && (1..12).cover?(significant_digits)
            raise Gum::InvalidInput, "tolerance significant_digits must lie in1..12"
          end
          if uncertainty.is_a?(Float)
            raise Gum::NumericalFailure, "non-finite uncertainty" unless uncertainty.finite?
            uncertainty = uncertainty.to_s
          end
          value = Gum.exact(uncertainty)
          raise Gum::NumericalFailure, "adaptive tolerance needs positive uncertainty" unless value.positive?
          n, d = value.numerator, value.denominator
          exponent = n.to_s.length - d.to_s.length
          too_large = exponent >= 0 ? n < d * 10**exponent : n * 10**(-exponent) < d
          exponent -= 1 if too_large
          ell = exponent - significant_digits + 1
          numerator, denominator = ell >= 0 ? [n, d * 10**ell] : [n * 10**(-ell), d]
          coefficient, remainder = numerator.divmod(denominator)
          coefficient += 1 if 2 * remainder >= denominator
          ell += 1 if coefficient >= 10**significant_digits
          BigDecimal("0.5") * BigDecimal("10")**ell
        end

        # 7.7.2 uses one-based r and r+q. Retain those endpoint conventions,
        # including deterministic first-window selection for shortest ties.
        def self.coverage(values, probability, kind)
          sorted = values.sort
          n = sorted.length
          q = (probability * n + 1r / 2).floor
          remaining = n - q
          raise Gum::InvalidInput, "too few samples for the requested coverage" unless q.positive? && remaining.positive?
          index = if kind == :symmetric
                    (remaining + 1) / 2 - 1
                  elsif kind == :shortest
                    (0...remaining).min_by { |i| sorted[i + q] - sorted[i] }
                  else
                    raise Gum::InvalidInput, "unknown coverage interval kind"
                  end
          [sorted[index], sorted[index + q]]
        end

        private

        def moments(values)
          mean = 0.0
          sum = 0.0
          values.each_with_index do |value, index|
            delta = value - mean
            mean += delta / (index + 1)
            sum += delta * (value - mean)
          end
          { estimate: mean, standard_uncertainty: ::Math.sqrt(sum / (values.length - 1)) }
        end

        def summarize(values)
          result = moments(values)
          kinds = @interval == :both ? %i[symmetric shortest] : [@interval]
          kinds.each do |kind|
            lower, upper = self.class.coverage(values, @probability, kind)
            result["#{kind}_lower".to_sym] = lower
            result["#{kind}_upper".to_sym] = upper
          end
          result
        end

        def result(statistics, samples, batches, delta, stability)
          intervals = {}
          %i[symmetric shortest].each do |kind|
            next unless statistics.key?("#{kind}_lower".to_sym)
            intervals[kind] = %w[lower upper].map { |bound| decimal(@model.offset + statistics.fetch("#{kind}_#{bound}".to_sym).to_r) }
          end
          certificate = @model.is_a?(CompiledRational) ? { denominator_interval: @model.denominator_interval.map(&:to_s), certificate: "exact-rectangular-support-interval-v1" } : {}
          { estimate: decimal(@model.offset + statistics.fetch(:estimate).to_r),
            standard_uncertainty: decimal(statistics.fetch(:standard_uncertainty)),
            intervals: intervals, probability: @probability.to_s,
            numerical_tolerance: delta.to_s("F"),
            twice_standard_errors: stability.transform_values { |value| decimal(value) },
            samples: samples, requested_max_samples: @max_samples, batches: batches, batch_size: @batch_size,
            significant_digits: @significant_digits, guard_digits: @guard_digits, precision_convention: :significant_digits,
            stabilized: true, method: :adaptive_mcm, variables: @names,
            engine: { name: "plurimath", version: Plurimath::VERSION,
                      method: "JCGM101-2008-7.9.4-v1", numeric_backend: @model.numeric_backend,
                      generator: "enhanced-Wichmann-Hill-C.3.3.3",
                      initial_seeds: @generator.initial_seeds,
                      final_state: @generator.state, uniform_draws: @generator.draws }.merge(certificate).merge(
                        @joint_distribution ? { joint_distribution: @joint_distribution,
                          covariance: @sampler.covariance.map { |row| row.map(&:to_s) },
                          joint_sampler: "exact-LDL-binary64-normal-v1" } : {}) }.freeze
        end

        def decimal(value) = Gum.decimal_output(value, @guard_digits)
      end
    end
  end
end
