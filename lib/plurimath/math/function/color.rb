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

        def to_asciimath
          first_value = "(#{parameter_one&.to_asciimath&.gsub(/\s/, '')})"
          second_value = "(#{parameter_two&.to_asciimath})"
          "color#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          color_value = parameter_one&.to_asciimath&.gsub(/\s/, "")&.gsub(/"/, "")
          Utility.update_nodes(
            Utility.ox_element(
              "mstyle",
              attributes: { attr_key => color_value },
            ),
            [parameter_two&.to_mathml_without_math_tag],
          )
        end

        def to_latex
          first_value = parameter_one&.to_asciimath&.gsub(/\s/, "")
          second_value = parameter_two&.to_latex
          "{\\#{class_name}{#{first_value}} #{second_value}}"
        end

        def to_omml_without_math_tag(display_style)
          Array(parameter_two.insert_t_tag(display_style))
        end

        def to_omml_math_zone(spacing, last = false, _, display_style:)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{dump_omml(self, display_style)}\" #{parameters[:name]}\n"]
          omml_fields_to_print(parameter_two, { spacing: new_spacing, field_name: "text", additional_space: "|  |_ ", array: new_arr, display_style: display_style })
          new_arr
        end

        def set_options(value)
          self.options = value
          self
        end

        protected

        def attr_key
          (options && options[:backcolor]) ? :mathbackground : :mathcolor
        end
      end
    end
  end
end
