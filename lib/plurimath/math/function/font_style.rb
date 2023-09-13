# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class FontStyle < BinaryFunction
        def to_asciimath
          parameter_one&.to_asciimath
        end

        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element(
              "mstyle",
              attributes: { mathvariant: parameter_two },
            ),
            [first_value],
          )
        end

        def to_omml_without_math_tag(display_style)
          font_styles(display_style)
        end

        def to_html
          parameter_one&.to_html
        end

        def to_latex
          parameter_one&.to_latex
        end

        def validate_function_formula
          true
        end

        def extract_class_from_text
          parameter_one.parameter_one if parameter_one.is_a?(Text)
          parameter_one.class_name
        end

        def extractable?
          parameter_one.is_a?(Text)
        end

        def font_styles(display_style, sty: "p", scr: nil)
          r_tag   = Utility.ox_element("r", namespace: "m")
          rpr_tag = Utility.ox_element("rPr", namespace: "m")
          fonts   = []
          fonts << Utility.ox_element("scr", namespace: "m", attributes: { "m:val": scr }) if scr
          fonts << Utility.ox_element("sty", namespace: "m", attributes: { "m:val": sty }) if sty
          r_tag << Utility.update_nodes(rpr_tag, fonts)
          Utility.update_nodes(
            r_tag,
            Array(parameter_one.font_style_t_tag(display_style)),
          )
          [r_tag]
        end

        def to_asciimath_math_zone(spacing, last = false, _)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{to_asciimath}\" function apply\n",
            "#{new_spacing}|_ \"#{parameter_two}\" font family\n",
          ]
          ascii_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ " , array: new_arr })
          new_arr
        end

        def to_latex_math_zone(spacing, last = false, _)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{to_latex}\" function apply\n",
            "#{new_spacing}|_ \"#{parameter_two}\" font family\n",
          ]
          latex_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ " , array: new_arr })
          new_arr
        end

        def to_mathml_math_zone(spacing, last = false, _)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{dump_mathml(self)}\" function apply\n",
            "#{new_spacing}|_ \"#{omml_and_mathml_font_family}\" font family\n",
          ]
          mathml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ ", array: new_arr })
          new_arr
        end

        def to_omml_math_zone(spacing, last = false, _, display_style:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{dump_omml(self, display_style)}\" function apply\n",
            "#{new_spacing}|_ \"#{omml_and_mathml_font_family}\" font family\n",
          ]
          omml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ ", array: new_arr, display_style: display_style })
          new_arr
        end

        def omml_and_mathml_font_family
          fonts = Utility::FONT_STYLES.select { |_font, font_class| font_class == self.class }.keys.map(&:to_s)
          Omml::Parser::SUPPORTED_FONTS.values.find { |value| fonts.include?(value) }
        end
      end
    end
  end
end
