# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Mglyph < UnaryFunction
        def initialize(parameter_one = {})
          super(parameter_one)
        end

        def to_asciimath(**)
          parameter_one[:alt]
        end

        def to_latex(**)
          parameter_one[:alt]
        end

        def to_mathml_without_math_tag(intent, **)
          ox_element(class_name, attributes: parameter_one)
        end

        def to_omml_without_math_tag(_, **)
          index = parameter_one[:index].to_i
          r_element(
            (ignoring_index(index) ? parameter_one[:alt].to_s : "&#x#{glyph_user_index(index)};"),
            rpr_tag: false,
          )
        end

        def to_unicodemath(**)
          parameter_one[:alt] if parameter_one
        end

        protected

        def glyph_user_index(index)
          return "" unless index > 0

          remaining = index.modulo(16)
          hex_bits = glyph_user_index(index / 16)
          hex_digit = case remaining
          when 0..9 then remaining.to_s
          when 10 then "A"
          when 11 then "B"
          when 12 then "C"
          when 13 then "D"
          when 14 then "E"
          when 15 then "F"
          end
          "#{hex_bits}#{hex_digit}"
        end

        def ignoring_index(index)
          index.zero? ||
            (index < 32 && !([9, 10, 13].include?(index))) ||
            [65534, 65535].include?(index)
        end
      end
    end
  end
end
