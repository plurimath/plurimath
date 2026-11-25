# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Color
        # Specialized tree writers load on first display use.
        module DisplayTreeMethods
          def to_omml_math_zone(spacing, last = false, _, display_style:,
  options:)
            parameters = self.class::FUNCTION
            new_spacing = gsub_spacing(spacing, last)
            new_arr = ["#{spacing}\"#{dump_omml(self, display_style,
                                                options: options)}\" #{parameters[:name]}\n"]
            omml_fields_to_print(parameter_two,
                                 { spacing: new_spacing, field_name: "text", additional_space: "|  |_ ",
                                   array: new_arr, display_style: display_style, options: options })
            new_arr
          end
        end
      end
    end
  end
end
