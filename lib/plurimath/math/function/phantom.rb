# frozen_string_literal: true

require_relative "unary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Phantom < UnaryFunction
        include Mathml::Utility

        def to_asciimath(options:)
          "#{Array.new(asciimath_value(options: options)&.length, '\ ').join}"
        end

        def to_html
          "<i style='visibility: hidden;'>#{parameter_one&.to_html}</i>"
        end

        def to_latex(options:)
          "\\#{class_name}{#{latex_value(options: options)}}"
        end

        def to_mathml_without_math_tag(intent, options:)
          Utility.update_nodes(
            Utility.ox_element("mphantom"),
            Array(mathml_value(intent, options: options)),
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          phant = Utility.ox_element("phant", namespace: "m")
          e_tag = Utility.ox_element("e", namespace: "m")
          Utility.update_nodes(e_tag, Array(omml_value(display_style, options: options)))
          Utility.update_nodes(phant, [phant_pr, e_tag])
        end

        def to_unicodemath(options:)
          if parameter_one.is_a?(Math::Function::Mpadded) && parameter_one&.options&.dig(:phantom)
            "#{phantom_unicode}#{unicodemath_parens(parameter_one.parameter_one, options: options)}"
          else
            "⟡#{unicodemath_parens(parameter_one, options: options)}"
          end
        end

        def line_breaking(obj)
          custom_array_line_breaking(obj)
        end

        protected

        def phant_pr
          attributes = { "m:val": "off" }
          phant = Utility.ox_element("phantPr", namespace: "m")
          phant << Utility.ox_element("show", namespace: "m", attributes: attributes)
        end

        def phantom_symbol
          UnicodeMath::Constants::PHANTOM_SYMBOLS.key(parameter_one.options)
        end

        def phantom_unicode
          UnicodeMath::Constants::UNARY_SYMBOLS[phantom_symbol]
        end
      end
    end
  end
end
