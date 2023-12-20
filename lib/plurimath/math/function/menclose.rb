# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Menclose < BinaryFunction
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

        def to_asciimath
          parameter_two&.to_asciimath
        end

        def to_mathml_without_math_tag
          attributes = { notation: parameter_one }
          menclose = ox_element("menclose", attributes: attributes)
          menclose << parameter_two.to_mathml_without_math_tag if parameter_two
          menclose
        end

        def to_latex
          parameter_two&.to_latex
        end

        def to_html
          second_value = parameter_two&.to_html
          "<menclose notation=\"#{parameter_one}\">#{second_value}</menclose>"
        end

        def to_omml_without_math_tag(display_style)
          borderbox = ox_element("borderBox", namespace: "m")
          Utility.update_nodes(
            borderbox,
            [
              borderboxpr,
              omml_parameter(parameter_two, display_style, tag_name: "e"),
            ],
          )
          [borderbox]
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
      end
    end
  end
end
