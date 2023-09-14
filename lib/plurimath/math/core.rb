# frozen_string_literal: true

module Plurimath
  module Math
    class Core
      def class_name
        self.class.name.split("::").last.downcase
      end

      def insert_t_tag(display_style)
        Array(to_omml_without_math_tag(display_style))
      end

      def tag_name
        "subsup"
      end

      def omml_tag_name
        "subSup"
      end

      def nary_attr_value
        ""
      end

      def empty_tag(wrapper_tag)
        r_tag = Utility.ox_element("r", namespace: "m")
        r_tag << (Utility.ox_element("t", namespace: "m") << "&#8203;")
        wrapper_tag << r_tag
      end

      def omml_parameter(field, display_style, tag_name: , namespace: "m")
        tag = Utility.ox_element(tag_name, namespace: namespace)
        return empty_tag(tag) unless field

        Utility.update_nodes(
          tag,
          field&.insert_t_tag(display_style),
        )
      end

      def validate_function_formula
        true
      end

      def r_element(string, rpr_tag: true)
        r_tag = Utility.ox_element("r", namespace: "m")
        if rpr_tag
          sty_tag = Utility.ox_element("sty", namespace: "m", attributes: { "m:val": "p" })
          r_tag << (Utility.ox_element("rPr", namespace: "m") << sty_tag)
        end
        r_tag << (Utility.ox_element("t", namespace: "m") << string)
        Array(r_tag)
      end

      def extractable?
        false
      end

      def extract_class_from_text
        ""
      end

      def font_style_t_tag(display_style)
        to_omml_without_math_tag(display_style)
      end

      def ascii_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        options[:array] << "#{hashed[:spacing]}|_ \"#{field&.to_asciimath}\"#{hashed[:field_name]}\n"
        return unless Utility.validate_math_zone(field)

        options[:array] << field&.to_asciimath_math_zone(hashed[:function_spacing], hashed[:last], hashed[:indent])
      end

      def latex_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        options[:array] << "#{hashed[:spacing]}|_ \"#{field&.to_latex}\"#{hashed[:field_name]}\n"
        return unless Utility.validate_math_zone(field)

        options[:array] << field&.to_latex_math_zone(hashed[:function_spacing], hashed[:last], hashed[:indent])
      end

      def mathml_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        options[:array] << "#{hashed[:spacing]}|_ \"#{dump_mathml(field)}\"#{hashed[:field_name]}\n"
        return unless Utility.validate_math_zone(field)

        options[:array] << field&.to_mathml_math_zone(hashed[:function_spacing], hashed[:last], hashed[:indent])
      end

      def omml_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        display_style = options[:display_style]
        options[:array] << "#{hashed[:spacing]}|_ \"#{dump_omml(field, display_style)}\"#{hashed[:field_name]}\n"
        return unless Utility.validate_math_zone(field)

        options[:array] << field&.to_omml_math_zone(hashed[:function_spacing], hashed[:last], hashed[:indent], display_style: display_style)
      end

      def dump_mathml(field)
        mathml = dump_ox_nodes(field.to_mathml_without_math_tag)
        mathml.gsub(/\n\s*/, "").gsub("&amp;", "&")
      end

      def dump_omml(field, display_style)
        return if field.nil?

        omml = field.omml_nodes(display_style)
        omml_string = omml.is_a?(Array) ? omml.flatten.map { |obj| dump_ox_nodes(obj) }.join : dump_ox_nodes(omml)
        omml_string.gsub(/\n\s*/, "").gsub("&amp;", "&")
      end

      def omml_nodes(display_style)
        to_omml_without_math_tag(display_style)
      end

      def validate_mathml_fields(field)
        field.nil? ? Utility.ox_element("mi") : field.to_mathml_without_math_tag
      end

      def common_math_zone_conversion(field, options = {})
        {
          spacing: options[:spacing],
          last: options[:last] || true,
          indent: !field&.is_a?(Formula),
          function_spacing: "#{options[:spacing]}#{options[:additional_space]}",
          field_name: options[:field_name] ?  " #{options[:field_name]}" : "",
        }
      end

      def filtered_values(value)
        @values = Utility.filter_math_zone_values(value)
      end

      def dump_ox_nodes(nodes)
        Ox.dump(nodes)
      end

      def gsub_spacing(spacing, last)
        spacing.gsub(/\|\_/, last ? "  " : "| ")
      end

      def invert_unicode_symbols
        Mathml::Constants::UNICODE_SYMBOLS.invert[class_name] || class_name
      end

      def separate_table
        false
      end

      def linebreak
        false
      end
    end
  end
end
