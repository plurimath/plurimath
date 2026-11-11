# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # JCGM106 normal, measurement-only knowledge (7.6.1). This explicit
      # gate identifies posterior y,u with measured ym,um. Global risks need
      # a process/measurement joint PDF and are deliberately unavailable.
      class Conformity
        RULES = %i[simple guarded_acceptance guarded_rejection iso14253_style three_zone].freeze

        def initialize(estimate:, standard_uncertainty:, distribution:, knowledge:,
                       tolerance:, rule:, coverage_factor:, guard_ratio:,
                       guard_digits:, risk_scope: :specific, consumer_risk_ceiling: nil)
          unless distribution == :normal && knowledge == :measurement_only
            raise Gum::UnsupportedModel, "decision capability requires explicit measurement-only normal knowledge"
          end
          raise Gum::UnsupportedModel, "global risks require a process/measurement joint PDF" unless risk_scope == :specific
          unless guard_digits.is_a?(Integer) && (1..12).cover?(guard_digits)
            raise Gum::InvalidInput, "probabilities support 1..12 decimal places"
          end
          @digits = guard_digits
          @resolution = 1r / 10**guard_digits
          @y = Gum.exact(estimate)
          @u = Gum.exact(standard_uncertainty)
          raise Gum::InvalidInput, "normal uncertainty must be positive" unless @u.positive?
          unless tolerance.is_a?(Array) && tolerance.length == 2 && tolerance.any?
            raise Gum::InvalidInput, "provide lower/upper tolerance limits; nil denotes an open side"
          end
          @lower, @upper = tolerance.map { |value| value.nil? ? nil : Gum.exact(value) }
          raise Gum::InvalidInput, "tolerance limits must increase" if @lower && @upper && @lower >= @upper
          raise Gum::InvalidInput, "unknown decision rule" unless RULES.include?(rule)
          @rule = rule
          k = Gum.exact(coverage_factor)
          r = Gum.exact(guard_ratio)
          raise Gum::InvalidInput, "coverage factor must be positive and guard ratio nonnegative" unless k.positive? && !r.negative?
          raise Gum::InvalidInput, "simple acceptance requires zero guard ratio" if rule == :simple && !r.zero?
          if rule == :iso14253_style && (k != 2 || r != 1)
            raise Gum::InvalidInput, "JCGM106 ISO14253-style rule requires k=2 and r=1"
          end
          @k, @r = k, r
          @expanded = k * @u
          @w = r * @expanded
          @w = -@w if rule == :guarded_rejection
          @accept_lower = @lower && @lower + @w
          @accept_upper = @upper && @upper - @w
          @possible = !(@accept_lower && @accept_upper && @accept_lower > @accept_upper)
          @ceiling = consumer_risk_ceiling.nil? ? nil : Gum.exact(consumer_risk_ceiling)
          if @ceiling && (@ceiling <= @resolution || @ceiling >= 1)
            raise Gum::UnsupportedModel, "risk ceiling must exceed the declared probability resolution and be below one"
          end
        end

        def evaluate
          pc, nonconformance = probabilities(@y)
          accepted = @possible && inside?(@y, @accept_lower, @accept_upper)
          decision = if accepted
                       :accept
                     elsif @rule == :three_zone && !clearly_outside?
                       :conditional
                     else
                       :reject
                     end
          maximum_risk = maximum_accepted_risk
          if @ceiling && (maximum_risk.nil? || maximum_risk + @resolution.to_f > @ceiling.to_f)
            raise Gum::UnsupportedModel, "declared guard geometry does not establish the requested consumer risk ceiling"
          end
          boundaries = [@lower, @upper, @accept_lower, @accept_upper]
          boundaries.concat([@lower && @lower - @w, @upper && @upper + @w]) if @rule == :three_zone
          boundary = boundaries.compact.include?(@y)
          { decision: decision, boundary: boundary,
            estimate: @y.to_s, standard_uncertainty: @u.to_s,
            coverage_factor: @k.to_s, guard_ratio: @r.to_s,
            required_consumer_risk_ceiling: @ceiling&.to_s,
            conformance_probability: probability(pc), nonconformance_probability: probability(nonconformance),
            specific_consumer_risk: decision == :accept ? probability(nonconformance) : nil,
            specific_producer_risk: decision == :reject ? probability(pc) : nil,
            maximum_specific_consumer_risk_if_accepted: maximum_risk && probability(maximum_risk),
            iso_2p3_percent_ceiling_holds: @rule == :iso14253_style && maximum_risk ? maximum_risk <= 0.023 : nil,
            acceptance_possible: @possible, tolerance: [@lower&.to_s, @upper&.to_s],
            acceptance_interval: [@accept_lower&.to_s, @accept_upper&.to_s],
            signed_guard_band: @w.to_s, expanded_uncertainty: @expanded.to_s,
            lower_residual: @lower && (@y - @lower).to_s,
            upper_residual: @upper && (@upper - @y).to_s,
            measurement_capability_index: @lower && @upper ? ((@upper - @lower) / (4 * @u)).to_s : nil,
            rule: @rule, distribution: :normal, knowledge: :measurement_only, risk_scope: :specific,
            guard_digits: @digits, precision_convention: :decimal_places, probability_resolution: @resolution.to_s,
            engine: { name: "plurimath", version: Plurimath::VERSION,
                      method: "JCGM106-2012-normal-v1", numeric_backend: "binary64" } }.freeze
        end

        private

        def inside?(value, lower, upper)
          (lower.nil? || value >= lower) && (upper.nil? || value <= upper)
        end

        def clearly_outside?
          (@lower && @y + @w < @lower) || (@upper && @y - @w > @upper)
        end

        def probabilities(mean)
          z_lower = @lower ? ((@lower - mean) / @u).to_f : -Float::INFINITY
          z_upper = @upper ? ((@upper - mean) / @u).to_f : Float::INFINITY
          nonconformance = Statistics.normal_cdf(z_lower) + Statistics.normal_tail(z_upper)
          pc = if z_lower.positive?
                 Statistics.normal_tail(z_lower) - Statistics.normal_tail(z_upper)
               elsif z_upper.negative?
                 Statistics.normal_cdf(z_upper) - Statistics.normal_cdf(z_lower)
               else
                 1 - nonconformance
               end
          [clamp(pc), clamp(nonconformance)]
        end

        def maximum_accepted_risk
          return nil unless @possible
          mean = @accept_lower || @accept_upper
          probabilities(mean)[1]
        end

        def clamp(value)
          unless value.finite? && value >= -1e-12 && value <= 1 + 1e-12
            raise Gum::NumericalFailure, "normal probability outside numerical range"
          end
          [[value, 0.0].max, 1.0].min
        end

        def probability(value) = Gum.decimal_places_output(value, @digits)
      end
    end
  end
end
