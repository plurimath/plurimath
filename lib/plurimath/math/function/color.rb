# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Color < BinaryFunction
        attr_accessor :options

        FUNCTION = {
          name: "color",
          first_value: "mathcolor",
          second_value: "text",
        }.freeze

        def initialize(parameter_one = nil,
                       parameter_two = nil,
                       options = {})
          super(parameter_one, parameter_two)
          @options = options unless options.empty?
        end

        def to_asciimath(options:)
          first_value = "(#{parameter_one&.to_asciimath(options: options)&.gsub(/\s/, '')})"
          second_value = "(#{parameter_two&.to_asciimath(options: options)})"
          "color#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          Utility.update_nodes(
            Utility.ox_element(
              "mstyle",
              attributes: mathml_options,
            ),
            [parameter_two&.to_mathml_without_math_tag(intent, options: options)],
          )
        end

        def to_latex(options:)
          first_value = parameter_one&.to_asciimath(options: options)&.gsub(/\s/, "")
          second_value = parameter_two&.to_latex(options: options)
          "{\\#{class_name}{#{first_value}} #{second_value}}"
        end

        def to_omml_without_math_tag(display_style, options:)
          Array(parameter_two.insert_t_tag(display_style, options: options))
        end

        def to_omml_math_zone(spacing, last = false, _, display_style:, options:)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{dump_omml(self, display_style, options: options)}\" #{parameters[:name]}\n"]
          omml_fields_to_print(parameter_two, { spacing: new_spacing, field_name: "text", additional_space: "|  |_ ", array: new_arr, display_style: display_style, options: options })
          new_arr
        end

        def to_unicodemath(options:)
          "#{color_symbol}(#{parameter_one.to_unicodemath(options: options)}&#{parameter_two.to_unicodemath(options: options)})"
        end

        protected

        def color_symbol
          options&.dig(:backgroundcolor) ? "☁" : "✎"
        end

        def attr_key
          options&.dig(:backgroundcolor) ? :mathbackground : :mathcolor
        end

        def mathml_options
          return unless parameter_one

          color_options = {}
          color_options[attr_key] =
            parameter_one.to_asciimath(options: options)&.gsub(/\s/, "")&.gsub(/"/, "")
          color_options
        end
      end
    end
  end
end
