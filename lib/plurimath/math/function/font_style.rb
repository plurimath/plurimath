# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class FontStyle < BinaryFunction
        FONT_TYPES = {
          bb: "bold",
          fr: "fraktur",
          cc: "script",
          sf: "sans-serif",
          tt: "monospace",
          mbf: "bold",
          mit: "italic",
          mtt: "monospace",
          Bbb: "double-struck",
          bbb: "double-struck",
          mscr: "mathbb",
          mfrak: "fraktur",
          msans: "sans-serif",
          mbfit: "bold italic",
          mathbf: "bold",
          mathit: "italic",
          mathds: "mathbb",
          mathrm: "mathrm",
          mathtt: "monospace",
          mathsf: "sans-serif",
          mathbb: "double-struck",
          mbfsans: "bold sans-serif",
          mathcal: "script",
          mathbold: "bold",
          mathfrak: "fraktur",
          mathbfit: "bold italic",
          mathsfbf: "sans-serif bold",
          mathsfit: "sans-serif italic",
          mbfitsans: "bold italic sans-serif",
          mathsfbfit: "sans-serif bold italic",
        }.freeze

        def to_asciimath
          if Asciimath::Constants::FONT_STYLES.include?(parameter_two.to_sym)
            "#{parameter_two}(#{parameter_one.to_asciimath})"
          else
            parameter_one.to_asciimath
          end
        end

        def to_mathml_without_math_tag
          type = FONT_TYPES[parameter_two.to_sym]
          first_value = parameter_one.to_mathml_without_math_tag
          "<mstyle mathvariant='#{type}'>#{first_value}</mstyle>"
        end

        def to_latex
          first_value = parameter_one.to_latex if parameter_one
          "\\#{parameter_two}{#{first_value}}"
        end
      end
    end
  end
end
