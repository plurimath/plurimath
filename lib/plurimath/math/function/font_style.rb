# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class FontStyle < BinaryFunction
        autoload :Bold, "#{__dir__}/font_style/bold"
        autoload :BoldFraktur, "#{__dir__}/font_style/bold-fraktur"
        autoload :BoldItalic, "#{__dir__}/font_style/bold-italic"
        autoload :BoldSansSerif, "#{__dir__}/font_style/bold-sans-serif"
        autoload :BoldScript, "#{__dir__}/font_style/bold-script"
        autoload :DoubleStruck, "#{__dir__}/font_style/double_struck"
        autoload :Fraktur, "#{__dir__}/font_style/fraktur"
        autoload :Italic, "#{__dir__}/font_style/italic"
        autoload :Monospace, "#{__dir__}/font_style/monospace"
        autoload :Normal, "#{__dir__}/font_style/normal"
        autoload :SansSerif, "#{__dir__}/font_style/sans-serif"
        autoload :SansSerifBoldItalic,
                 "#{__dir__}/font_style/sans-serif-bold-italic"
        autoload :SansSerifItalic, "#{__dir__}/font_style/sans-serif-italic"
        autoload :Script, "#{__dir__}/font_style/script"

        def to_asciimath(options:)
          parameter_one&.to_asciimath(options: options)
        end

        def ==(object)
          object.class == self.class &&
            object.parameter_one == parameter_one &&
            comparable_font_family(object.parameter_two) == comparable_font_family(parameter_two)
        end

        def to_mathml_without_math_tag(intent, options:)
          first_value = parameter_one&.to_mathml_without_math_tag(intent,
                                                                  options: options)
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

        def font_styles(display_style, options:, sty: "p", scr: nil)
          children = flatten_omml_nodes(
            Array(parameter_one&.font_style_t_tag(display_style,
                                                  options: options)),
          )
          return [empty_font_style_r_tag(sty, scr)] if children.empty?

          if children.all? { |node| node.is_a?(String) || t_tag_node?(node) }
            r_tag = empty_font_style_r_tag(sty, scr)
            Utility.update_nodes(r_tag, children)
            return [r_tag]
          end

          children.flat_map do |node|
            if r_tag_node?(node)
              inject_font_style_rpr(node, sty, scr)
              [node]
            elsif t_tag_node?(node)
              r_tag = empty_font_style_r_tag(sty, scr)
              r_tag << node
              [r_tag]
            else
              inject_font_style_recursive(node, sty, scr)
              [node]
            end
          end
        end

        def flatten_omml_nodes(nodes)
          nodes.each_with_object([]) do |node, result|
            if node.is_a?(Array)
              result.concat(flatten_omml_nodes(node))
            elsif !node.nil?
              result << node
            end
          end
        end

        def t_tag_node?(node)
          node.respond_to?(:name) && node.name == "m:t"
        end

        def r_tag_node?(node)
          node.respond_to?(:name) && node.name == "m:r"
        end

        def empty_font_style_r_tag(sty, scr)
          r_tag = Utility.ox_element("r", namespace: "m")
          rpr_tag = Utility.ox_element("rPr", namespace: "m")
          if scr
            rpr_tag << Utility.ox_element("scr", namespace: "m",
                                                 attributes: { "m:val": scr })
          end
          if sty
            rpr_tag << Utility.ox_element("sty", namespace: "m",
                                                 attributes: { "m:val": sty })
          end
          r_tag << rpr_tag
          r_tag
        end

        def inject_font_style_rpr(r_node, sty, scr)
          return if r_node.nodes.any? do |n|
            n.respond_to?(:name) && n.name == "m:rPr"
          end

          rpr_tag = Utility.ox_element("rPr", namespace: "m")
          if scr
            rpr_tag << Utility.ox_element("scr", namespace: "m",
                                                 attributes: { "m:val": scr })
          end
          if sty
            rpr_tag << Utility.ox_element("sty", namespace: "m",
                                                 attributes: { "m:val": sty })
          end
          r_node.insert_in_nodes(0, rpr_tag)
        end

        def inject_font_style_recursive(node, sty, scr)
          return unless node.respond_to?(:nodes)

          node.nodes.each do |child|
            if r_tag_node?(child)
              inject_font_style_rpr(child, sty, scr)
            elsif child.respond_to?(:nodes)
              inject_font_style_recursive(child, sty, scr)
            end
          end
        end

        def to_asciimath_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{to_asciimath(options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{parameter_two}\" font family\n",
          ]
          ascii_fields_to_print(parameter_one,
                                { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ ",
                                  array: new_arr, options: options })
          new_arr
        end

        def to_latex_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{to_latex(options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{parameter_two}\" font family\n",
          ]
          latex_fields_to_print(parameter_one,
                                { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ ",
                                  array: new_arr, options: options })
          new_arr
        end

        def to_mathml_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{dump_mathml(self,
                                       options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{font_family(mathml: true)}\" font family\n",
          ]
          mathml_fields_to_print(parameter_one,
                                 { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ ",
                                   array: new_arr, options: options })
          new_arr
        end

        def to_omml_math_zone(spacing, last = false, _, display_style:,
options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{dump_omml(self, display_style,
                                     options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{font_family(omml: true)}\" font family\n",
          ]
          omml_fields_to_print(parameter_one,
                               { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ ",
                                 array: new_arr, display_style: display_style, options: options })
          new_arr
        end

        def font_family(unicode: false, omml: false, mathml: false)
          fonts = font_classes
          fonts = font_classes(parameter_to_class) if fonts.empty?
          supported_fonts(fonts, unicode: unicode, omml: omml, mathml: mathml)
        end

        def supported_fonts(fonts_array = [], unicode: false, omml: false,
mathml: false)
          if unicode
            font = UnicodeMath::Constants::FONTS_CLASSES.find { |value| fonts_array.include?(value) }
            return "\\#{font}" if font
          end
          if omml
            return Omml::Parser::SUPPORTED_FONTS.values.find do |value|
              fonts_array.include?(value)
            end
          end

          if mathml
            Mathml::Constants::SUPPORTED_FONT_STYLES.find do |string, _object|
              fonts_array.include?(string.to_s)
            end&.first ||
              parameter_two
          end
        end

        def to_unicodemath_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{dump_unicodemath(self,
                                            options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{font_family(unicode: true,
                                              options: options)}\" font family\n",
          ]
          unicodemath_fields_to_print(parameter_one,
                                      { spacing: new_spacing, field_name: "argument", additional_space: "|  |_ ",
                                        array: new_arr, options: options })
          new_arr
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          return unless obj.value_exist?

          obj.update(
            self.class.new(
              Utility.filter_values(obj.value),
              parameter_two,
            ),
          )
        end

        private

        def comparable_font_family(value)
          return if value.nil?

          Utility::FONT_STYLES[value.to_sym] || value
        end

        def font_classes(object = self)
          Utility::FONT_STYLES.select do |_font, font_class|
            font_class == object.class
          end.keys.map(&:to_s)
        end

        def parameter_to_class
          Utility::FONT_STYLES.select do |font, _font_class|
            font == parameter_two.to_sym
          end&.values&.first&.new("")
        end
      end
    end
  end
end
