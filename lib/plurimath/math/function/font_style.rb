# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class FontStyle < BinaryFunction
        FONT_TYPES = {
          mathfrak: "fraktur",
          mathcal: "script",
          mathbb: "double-struck",
          mathsf: "sans-serif",
          mathtt: "monospace",
          mathbf: "bold",
          bbb: "double-struck",
          bb: "bold",
          fr: "fraktur",
          cc: "script",
          sf: "sans-serif",
          tt: "monospace",
        }.freeze

        def to_asciimath
          if Asciimath::Constants::FONT_STYLES.include?(parameter_two.to_sym)
            "#{parameter_two}(#{parameter_one.to_asciimath})"
          else
            parameter_two.to_asciimath
          end
        end

        def to_mathml_without_math_tag
          type = FONT_TYPES[parameter_two.to_sym]
          first_value = parameter_one.to_mathml_without_math_tag
          "<mstyle mathvariant='#{type}'>#{first_value}</mstyle>"
        end
      end
    end
  end
end
