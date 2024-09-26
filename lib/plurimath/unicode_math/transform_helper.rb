# frozen_string_literal: true

require_relative '../utility/shared'

module Plurimath
  class UnicodeMath
    class TransformHelper
      UNICODE_REGEX = %r{&#x[a-zA-Z0-9]+;}
      MASK_CLASSES = {
        1 => 'top',
        2 => 'bottom',
        4 => 'left',
        8 => 'right',
        16 => 'horizontalstrike',
        32 => 'verticalstrike',
        64 => 'downdiagonalstrike',
        128 => 'updiagonalstrike'
      }.freeze
      extend Utility::Shared

      class << self
        def unicode_accents(accents, lang: :unicodemath)
          if accents.is_a?(Math::Function::BinaryFunction)
            accents
          else
            if accents.any? { |acc| acc&.dig(:first_value)&.is_a?(Array) }
              accent_value = accents.first[:first_value].pop
              first_value = accents.first[:first_value]
              accents.first[:first_value] = accent_value
              Math::Formula.new(
                first_value + [transform_accents(accents, lang: lang)]
              )
            else
              transform_accents(accents, lang: lang)
            end
          end
        end

        def transform_accents(accents, lang:)
          accents.reduce do |function, accent|
            if function.is_a?(Hash)
              if function[:prime_accent_symbols]
                Math::Function::Power.new(
                  unfenced_value(accent_value(function, function: true, lang: lang), paren_specific: true),
                  accent_value(accent, lang: lang),
                )
              else
                Math::Function::Overset.new(
                  accent_value(accent, lang: lang),
                  unfenced_value(accent_value(function, function: true, lang: lang), paren_specific: true),
                  { accent: true }
                )
              end
            else
              if accent[:prime_accent_symbols]
                Math::Function::Power.new(
                  unfenced_value(function, paren_specific: true),
                  accent_value(accent, lang: lang),
                )
              else
                Math::Function::Overset.new(
                  accent_value(accent, lang: lang),
                  unfenced_value(function, paren_specific: true),
                  { accent: true }
                )
              end
            end
          end
        end

        def accent_value(accent, function: false, lang:)
          if accent[:accent_symbols]
            Utility.symbols_class(
              Constants::ACCENT_SYMBOLS[accent[:accent_symbols].to_sym] ||
                accent[:accent_symbols],
              lang: lang,
            )
          else
            accent[:first_value] || Utility.filter_values(accent[:prime_accent_symbols])
          end
        end

        def unicode_fractions(fractions)
          frac_arr = UnicodeMath::Constants::UNICODE_FRACTIONS[fractions.to_sym]
          Math::Function::Frac.new(
            Math::Number.new(frac_arr.first.to_s),
            Math::Number.new(frac_arr.last.to_s),
            { displaystyle: false, unicodemath_fraction: true }
          )
        end

        def updated_primes(prime)
          Utility.filter_values(
            prime.to_s.scan(UNICODE_REGEX).map do |str|
              Utility.symbols_class(str, lang: :unicodemath)
            end
          )
        end

        def fractions(numerator, denominator, options = nil)
          frac_class = Math::Function::Frac
          if denominator.is_a?(frac_class)
            if denominator.parameter_one.is_a?(frac_class)
              recursion_fraction(denominator, numerator, options)
            else
              denominator.parameter_one = frac_class.new(
                unfenced_value(numerator, paren_specific: true),
                unfenced_value(denominator.parameter_one, paren_specific: true),
                options
              )
            end
            denominator
          else
            frac_class.new(
              unfenced_value(numerator, paren_specific: true),
              unfenced_value(denominator, paren_specific: true),
              options
            )
          end
        end

        def recursion_fraction(frac, numerator, options)
          frac_class = Math::Function::Frac
          new_numerator = frac.parameter_one
          if new_numerator.is_a?(frac_class)
            recursion_fraction(new_numerator, numerator, options)
          else
            frac.parameter_one = frac_class.new(
              unfenced_value(numerator, paren_specific: true),
              unfenced_value(frac.parameter_one, paren_specific: true),
              options
            )
            frac
          end
        end

        def recursive_sub(sub_script, sub_recursion)
          base_class = Math::Function::Base
          if sub_recursion.is_a?(base_class)
            if sub_recursion.parameter_one.is_a?(base_class)
              base_recursion(sub_script, sub_recursion)
            else
              sub_recursion.parameter_one = base_class.new(sub_script, sub_recursion.parameter_one)
            end
            sub_recursion
          else
            base_class.new(
              sub_script,
              sub_recursion,
            )
          end
        end

        def base_recursion(sub_script, sub_recursion)
          base_class = Math::Function::Base
          new_sub = sub_recursion.parameter_one
          if new_sub.is_a?(base_class)
            base_recursion(sub_script, new_sub)
            sub_recursion
          else
            sub_recursion.parameter_one = base_class.new(sub_script, new_sub)
            sub_recursion
          end
        end

        def recursive_sup(sup_script, sup_recursion)
          power_class = Math::Function::Power
          if sup_recursion.is_a?(power_class)
            if sup_recursion.parameter_one.is_a?(power_class)
              sup_recursion(sup_script, sup_recursion)
            else
              sup_recursion.parameter_one = power_class.new(sup_script, sup_recursion.parameter_one)
            end
            sup_recursion
          else
            power_class.new(
              sup_script,
              sup_recursion,
            )
          end
        end

        def sup_recursion(sup_script, sup_recursion)
          power_class = Math::Function::Power
          new_sup = sup_recursion.parameter_one
          if new_sup.is_a?(power_class)
            sup_recursion(sup_script, new_sup)
            sup_recursion
          else
            sup_recursion.parameter_one = power_class.new(sup_script, new_sup)
            sup_recursion
          end
        end

        def base_is_prime?(base)
          symbol_prime?(base.parameter_two) ||
            primes_constants.key(base.parameter_two.value)
        end

        def symbol_prime?(obj)
          obj&.class&.const_defined?(:INPUT) &&
            primes_constants&.key(Utility.hexcode_in_input(obj))
        end

        def primes_constants
          primes = {}
          primes
            .merge!(Constants::PREFIXED_PRIMES)
            .merge({ sprime: "&#x27;" })
        end

        def slashed_values(value)
          decoded = HTMLEntities.new.decode(value)
          if decoded.to_s.match?(/^\w+/)
            Math::Function::Text.new("\\#{decoded}")
          else
            Math::Symbols::Symbol.new(decoded, true)
          end
        end

        def sequence_slashed_values(values, lang:)
          values.each_with_index do |value, index|
            decoded = HTMLEntities.new.decode(value.value)
            slashed = if index == 0
                        slashed_values(value.value)
                      else
                        decoded.match?(/[0-9]/) ? Math::Number.new(decoded) : Utility.symbols_class(decoded, lang: lang)
                      end
            values[index] = slashed
          end
          values
        end

        def enclosure_attrs(mask)
          raise "enclosure mask is not between 0 and 255" if (mask.nil? || mask < 0 || mask > 255)

          ret = ""
          unless mask.nil?
            mask ^= 15
            bin_mask = mask.to_s(2).reverse
            classes = bin_mask.chars.each_with_index.map { |bit, i| MASK_CLASSES[2**i] if bit == '1' }.compact
            ret = classes.join(' ')
          end
          ret
        end

        def identity_matrix(size)
          matrix = Array.new(size) { Array.new(size, 0) }
          size.times { |i| matrix[i][i] = 1 }
          matrix.map do |tr|
            tr.each_with_index do |td, i|
              tr[i] = Math::Function::Td.new([Math::Number.new(td.to_s)])
            end
            Math::Function::Tr.new(tr)
          end
        end

        def base_is_sub_or_sup?(base)
          if base.is_a?(Math::Formula)
            base_is_sub_or_sup?(base.value.first)
          elsif base.is_a?(Math::Function::Fenced)
            base_is_sub_or_sup?(base.parameter_two.first)
          elsif base.is_a?(Math::Symbols::Symbol) || base.is_a?(Math::Number)
            base.mini_sub_sized || base_mini_sup_sized
          end
        end
      end
    end
  end
end
