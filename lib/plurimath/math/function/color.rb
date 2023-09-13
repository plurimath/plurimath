# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Color < BinaryFunction
        FUNCTION = {
          name: "color",
          first_value: "mathcolor",
          second_value: "text",
        }.freeze

        def to_asciimath
          first_value = "(#{parameter_one&.to_asciimath&.gsub(/\s/, '')})"
          second_value = "(#{parameter_two&.to_asciimath})"
          "color#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element(
              "mstyle",
              attributes: { mathcolor: parameter_one&.to_asciimath&.gsub(/\s/, "")&.gsub(/"/, "") },
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
      end
    end
  end
end
