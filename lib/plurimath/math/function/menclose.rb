# frozen_string_literal: true

require_relative "binary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Menclose < BinaryFunction
        include Mathml::Utility

        FUNCTION = {
          name: "enclosure",
          first_value: "enclosure type",
          second_value: "expression",
        }.freeze
        FOUR_SIDED_NOTATIONS = {
          top: "hideTop",
          bottom: "hideBot",
          left: "hideLeft",
          right: "hideRight",
        }
        STRIKES_NOTATIONS = {
          horizontalstrike: "strikeH",
          verticalstrike: "strikeV",
          updiagonalstrike: "strikeBLTR",
          downdiagonalstrike: "strikeTLBR",
        }

        def to_asciimath(options:)
          parameter_two&.to_asciimath(options: options)
        end

        def to_mathml_without_math_tag(intent, options:)
          attributes = { notation: parameter_one }
          menclose = ox_element("menclose", attributes: attributes)
          menclose << parameter_two.to_mathml_without_math_tag(intent, options: options) if parameter_two
          menclose
        end

        def to_latex(options:)
          parameter_two&.to_latex(options: options)
        end

        def to_html(options:)
          second_value = parameter_two&.to_html(options: options)
          "<menclose notation=\"#{parameter_one}\">#{second_value}</menclose>"
        end

        def to_omml_without_math_tag(display_style, options:)
          borderbox = ox_element("borderBox", namespace: "m")
          Utility.update_nodes(
            borderbox,
            [
              borderboxpr,
              omml_parameter(parameter_two, display_style, tag_name: "e", options: options),
            ],
          )
          [borderbox]
        end

        def to_unicodemath(options:)
          if unicode_symbol?
            "#{unicode_symbol}#{unicodemath_parens(parameter_two, options: options)}"
          elsif masked_class?
            first_value = Utility.notations_to_mask(parameter_one) if parameter_one
            second_value = parameter_two&.to_unicodemath(options: options) if parameter_two
            "▭(#{first_value}&#{second_value})"
          end
        end

        protected

        def borderboxpr
          return if %w[box circle roundedbox].include?(parameter_one)

          borderpr = ox_element("borderBoxPr", namespace: "m")
          four_sided_notations(borderpr)
          strikes_notations(borderpr)
          borderpr
        end

        def four_sided_notations(borderpr)
          return if %w[box circle roundedbox].any? { |value| parameter_one.include?(value) }

          FOUR_SIDED_NOTATIONS.each do |side, rep|
            border_ox_element(rep, !parameter_one.include?(side.to_s), borderpr)
          end
        end

        def strikes_notations(borderpr)
          STRIKES_NOTATIONS.each do |strike, rep|
            border_ox_element(rep, parameter_one.include?(strike.to_s), borderpr)
          end
        end

        def border_ox_element(tag_name, condition, borderpr)
          return unless condition

          borderpr << ox_element(
            tag_name,
            namespace: "m",
            attributes: { "m:val": "on" },
          )
        end

        def masked_class?
          Utility::MASK_CLASSES.values.any? { |mask| parameter_one.include?(mask) }
        end

        def unicode_symbol
          class_name = Utility::UNICODEMATH_MENCLOSE_FUNCTIONS.key(parameter_one)
          UnicodeMath::Constants::UNARY_ARG_FUNCTIONS[class_name] ||
            UnicodeMath::Constants::UNARY_SYMBOLS[class_name]
        end

        def unicode_symbol?
          Utility::UNICODEMATH_MENCLOSE_FUNCTIONS.value?(parameter_one)
        end
      end
    end
  end
end
