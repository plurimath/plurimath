# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Explicit multivariate normal sampling. Exact LDL factors preserve
      # singular PSD covariance without jitter; only final roots/draws use
      # binary64. Scalar normal marginals alone never select this sampler.
      class CorrelatedNormalSampler
        attr_reader :covariance

        def initialize(definitions, covariance, generator)
          n = definitions.length
          unless covariance.is_a?(Array) && covariance.length == n &&
              covariance.all? { |row| row.is_a?(Array) && row.length == n }
            raise Gum::InvalidInput, "joint covariance shape mismatch"
          end
          @covariance = covariance.map { |row| row.map { |value| Gum.exact(value) } }
          unless n.times.all? { |i| n.times.all? { |j| @covariance[i][j] == @covariance[j][i] } }
            raise Gum::InvalidInput, "joint covariance must be symmetric"
          end
          definitions.each_with_index do |definition, i|
            unless definition[:distribution] == :normal
              raise Gum::UnsupportedModel, "joint normal sampling requires normal marginal declarations"
            end
            sd = Gum.exact(definition.fetch(:sd))
            unless sd.positive? && sd*sd == @covariance[i][i]
              raise Gum::InvalidInput, "normal marginal variance and joint covariance diagonal disagree"
            end
          end
          lower = Array.new(n) { Array.new(n, 0r) }
          diagonal = Array.new(n, 0r)
          n.times do |j|
            lower[j][j] = 1r
            diagonal[j] = @covariance[j][j] - j.times.sum { |k| lower[j][k]**2*diagonal[k] }
            raise Gum::InvalidInput, "joint covariance is not positive semidefinite" if diagonal[j].negative?
            (j+1...n).each do |i|
              numerator = @covariance[i][j] - j.times.sum { |k| lower[i][k]*lower[j][k]*diagonal[k] }
              if diagonal[j].zero?
                raise Gum::InvalidInput, "joint covariance is not positive semidefinite" unless numerator.zero?
              else
                lower[i][j] = numerator / diagonal[j]
              end
            end
          end
          @factor = lower.map do |row|
            row.each_with_index.map do |coefficient, j|
              if diagonal[j].zero? || coefficient.zero?
                0.0
              else
                variance = diagonal[j].to_f
                unless variance.positive? && variance.finite? && coefficient.to_f.finite?
                  raise Gum::InvalidInput, "joint factor exceeds binary64 range"
                end
                value = coefficient.to_f * ::Math.sqrt(variance)
                raise Gum::InvalidInput, "joint factor exceeds binary64 range" unless value.finite? && !value.zero?
                value
              end
            end
          end
          @base = DistributionSampler.new(Array.new(n) { {distribution: :normal, location: 0, sd: 1} },
                                          generator, degrees: Array.new(n, 1), centered: true)
        rescue KeyError => error
          raise Gum::InvalidInput, "missing normal PDF parameter: #{error.key}"
        end

        def draw
          independent = @base.draw
          @factor.map { |row| row.zip(independent).sum { |a, b| a*b } }
        end
      end
    end
  end
end
