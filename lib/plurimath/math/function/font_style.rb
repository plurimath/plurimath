# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class FontStyle < BinaryFunction
        def to_asciimath(options:)
          parameter_one&.to_asciimath(options: options)
        end

        def to_mathml_without_math_tag(intent, options:)
          first_value = parameter_one&.to_mathml_without_math_tag(intent, options: options)
          Utility.update_nodes(
            Utility.ox_element(
              "mstyle",
              attributes: { mathvariant: font_family(mathml: true) },
            ),
            [first_value],
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          font_styles(display_style, options: options)
        end

        def to_html(options:)
          parameter_one&.to_html(options: options)
        end

        def to_latex(options:)
          parameter_one&.to_latex(options: options)
        end

        def to_unicodemath(options:)
          "#{font_family(unicode: true)}#{parameter_one&.to_unicodemath(options: options)}"
        end

        def validate_function_formula
          true
        end

        def extract_class_name_from_text
          parameter_one.parameter_one if parameter_one.is_a?(Text)
          parameter_one.class_name
        end

        def extractable?
          parameter_one.is_a?(Text)
        end

        def font_styles(display_style, sty: "p", scr: nil, options:)
          r_tag = Utility.ox_element("r", namespace: "m")
          rpr_tag = Utility.ox_element("rPr", namespace: "m")
          rpr_tag << Utility.ox_element("scr", namespace: "m", attributes: { "m:val": scr }) if scr
          rpr_tag << Utility.ox_element("sty", namespace: "m", attributes: { "m:val": sty }) if sty
          Utility.update_nodes(
            (r_tag << rpr_tag),
            Array(parameter_one&.font_style_t_tag(display_style, options: options)),
          )
          [r_tag]
        end

        def to_asciimath_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{to_asciimath(options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{parameter_two}\" font family\n",
          ]
          ascii_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ " , array: new_arr, options: options })
          new_arr
        end

        def to_latex_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{to_latex(options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{parameter_two}\" font family\n",
          ]
          latex_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ " , array: new_arr, options: options })
          new_arr
        end

        def to_mathml_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{dump_mathml(self, options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{font_family(mathml: true)}\" font family\n",
          ]
          mathml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ ", array: new_arr, options: options })
          new_arr
        end

        def to_omml_math_zone(spacing, last = false, _, display_style:, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{dump_omml(self, display_style, options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{font_family(omml: true)}\" font family\n",
          ]
          omml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ ", array: new_arr, display_style: display_style, options: options })
          new_arr
        end

        def font_family(unicode: false, omml: false, mathml: false)
          fonts = font_classes
          fonts = font_classes(parameter_to_class) if fonts.empty?
          supported_fonts(fonts, unicode: unicode, omml: omml, mathml: mathml)
        end

        def supported_fonts(fonts_array = [], unicode: false, omml: false, mathml: false)
          if unicode
            font = UnicodeMath::Constants::FONTS_CLASSES.find { |value| fonts_array.include?(value) }
            return "\\#{font}" if font
          end
          return Omml::Parser::SUPPORTED_FONTS.values.find { |value| fonts_array.include?(value) } if omml
          if mathml
            Mathml::Constants::SUPPORTED_FONT_STYLES.find { |string, object| fonts_array.include?(string.to_s) }&.first ||
              parameter_two
          end
        end

        def to_unicodemath_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{dump_unicodemath(self, options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{font_family(unicode: true, options: options)}\" font family\n",
          ]
          unicodemath_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ ", array: new_arr, options: options })
          new_arr
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          return unless obj.value_exist?

          obj.update(
            self.class.new(
              Utility.filter_values(obj.value),
              self.parameter_two,
            )
          )
        end

        def font_classes(object = self)
          Utility::FONT_STYLES.select { |_font, font_class| font_class == object.class }.keys.map(&:to_s)
        end

        def parameter_to_class
          Utility::FONT_STYLES.select { |font, _font_class| font == parameter_two.to_sym }&.values&.first&.new('')
        end
      end
    end
  end
end
