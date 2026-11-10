# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # JCGM 101:2008 C.3.3.3, enhanced Wichmann-Hill, 64-bit recurrence.
      # State and draw order are request-local; there is no global RNG.
      class WichmannHill
        MULTIPLIERS = [11_600, 47_003, 23_000, 33_000].freeze
        MODULI = [2_147_483_579, 2_147_483_543, 2_147_483_423, 2_147_483_123].freeze
        attr_reader :initial_seeds, :draws

        def initialize(seeds)
          unless seeds.is_a?(Array) && seeds.length == 4 && seeds.zip(MODULI).all? { |seed, modulus| seed.is_a?(Integer) && seed.positive? && seed < modulus }
            raise Gum::InvalidInput, "four nonzero WH seeds below their respective moduli are required"
          end
          @initial_seeds = seeds.dup.freeze
          @state = seeds.dup
          @draws = 0
        end

        def state = @state.dup.freeze

        def uniform
          w = 0.0
          4.times do |j|
            @state[j] = (MULTIPLIERS[j] * @state[j]) % MODULI[j]
            w += @state[j].fdiv(MODULI[j])
          end
          @draws += 1
          value = w - w.floor
          unless value.positive? && value < 1
            raise Gum::NumericalFailure, "WH uniform draw rounded to an endpoint"
          end
          value
        end
      end
    end
  end
end
