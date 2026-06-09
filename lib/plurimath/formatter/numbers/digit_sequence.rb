# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Shared base-digit helper for counting, rounding thresholds, next-digit
      # lookup, and carry propagation.
      class DigitSequence
        attr_reader :base

        ZERO = "0"

        def initialize(base:)
          @base = base
        end

        def digit?(char)
          Base::DIGIT_VALUE.key?(char)
        end

        def significant?(char)
          Base::DIGIT_VALUE[char]&.positive?
        end

        def digit_count(chars, stop_at: nil)
          count = 0
          each_countable_digit(chars, stop_at: stop_at) { count += 1 }
          count
        end

        def significant_digit_count(chars)
          start_counting = false
          count = 0

          each_countable_digit(chars) do |char|
            start_counting = true if significant?(char)
            count += 1 if start_counting
          end

          count
        end

        def max_digit?(char)
          Base::DIGIT_VALUE[char] == base.pred
        end

        def next_digit(char)
          current_index = Base::DIGIT_VALUE[char]
          return unless current_index

          Base::HEX_ALPHANUMERIC[current_index + 1]
        end

        def round_up?(char)
          value = Base::DIGIT_VALUE[char]
          !!(value && value >= threshold)
        end

        def threshold
          @threshold ||= base.div(2)
        end

        def increment_reversed(digits, carry: 1, skip: [], overflow: ZERO)
          digits = digits.dup
          return [digits, carry] unless carry.positive?

          digits.each_with_index do |digit, index|
            next if skip.include?(digit)
            next unless digit?(digit)

            if max_digit?(digit)
              digits[index] = overflow
            else
              digits[index] = next_digit(digit)
              carry = 0
              break
            end
          end

          [digits, carry]
        end

        private

        def each_countable_digit(chars, stop_at: nil)
          chars.each do |char|
            break if stop_at && char == stop_at
            next unless digit?(char)

            yield(char)
          end
        end
      end
    end
  end
end
