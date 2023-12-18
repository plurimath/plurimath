# frozen_string_literal: true

module Plurimath
  module Math
    class Core
      REPLACABLES = {
        /&amp;/ => "&",
        /^\n/ => "",
      }

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
        r_tag = ox_element("r", namespace: "m")
        r_tag << (ox_element("t", namespace: "m") << "&#8203;")
        wrapper_tag << r_tag
      end

      def omml_parameter(field, display_style, tag_name:, namespace: "m")
        tag = ox_element(tag_name, namespace: namespace)
        return empty_tag(tag) unless field

        field_value = if field.is_a?(Array)
                        field.map { |object| object.insert_t_tag(display_style) }
                      else
                        field.insert_t_tag(display_style)
                      end
        Utility.update_nodes(tag, field_value)
      end

      def validate_function_formula
        true
      end

      def r_element(string, rpr_tag: true)
        r_tag = ox_element("r", namespace: "m")
        if rpr_tag
          attrs = { "m:val": "p" }
          sty_tag = ox_element("sty", namespace: "m", attributes: attrs)
          r_tag << (ox_element("rPr", namespace: "m") << sty_tag)
        end
        r_tag << (ox_element("t", namespace: "m") << string)
        Array(r_tag)
      end

      def extractable?
        false
      end

      def extract_class_name_from_text
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
        dump_ox_nodes(field.to_mathml_without_math_tag).gsub(/\n\s*/, "")
      end

      def dump_omml(field, display_style)
        return if field.nil?

        dump_ox_nodes(field.omml_nodes(display_style)).gsub(/\n\s*/, "")
      end

      def omml_nodes(display_style)
        to_omml_without_math_tag(display_style)
      end

      def validate_mathml_fields(field)
        field&.to_mathml_without_math_tag
      end

      def common_math_zone_conversion(field, options = {})
        {
          spacing: options[:spacing],
          last: options[:last] || true,
          indent: !field.is_a?(Formula),
          function_spacing: "#{options[:spacing]}#{options[:additional_space]}",
          field_name: (options[:field_name] ? " #{options[:field_name]}" : ""),
        }
      end

      def filtered_values(value)
        @values = Utility.filter_math_zone_values(value)
      end

      def dump_ox_nodes(nodes)
        return dump_nodes(nodes) unless nodes.is_a?(Array)

        nodes.flatten.map { |node| dump_nodes(node) }.join
      end

      def dump_nodes(nodes, indent: nil)
        replacable_values(
          Plurimath.xml_engine.dump(nodes, indent: indent),
        )
      end

      def replacable_values(string)
        REPLACABLES.each { |regex, str| string.gsub!(regex, str) }
        string
      end

      def gsub_spacing(spacing, last)
        spacing.gsub(/\|_/, last ? "  " : "| ")
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

      def cloned_objects
        object = self.class.new rescue self.class.new(nil)
        variables.each { |var| object.set(var, variable_value(get(var))) }
        object
      end

      def variable_value(value)
        case value
        when Core
          value.cloned_objects
        when Array
          value.map { |object| variable_value(object) }
        else
          value
        end
      end

      def line_breaking(obj)
        variables.each do |variable|
          field = get(variable)
          case field
          when Core
            field.line_breaking(obj)
            updated_object_values(variable, obj: obj, update_value: true) if obj.value_exist?
          when Array
            if result(field).length > 1
              updated_object_values(variable, obj: obj)
            else
              field.each { |object| object.line_breaking(obj) }
            end
          end
        end
      end

      def updated_object_values(param, obj:, update_value: false)
        object = self.class.new(nil)
        found = false
        variables.each do |variable|
          value = if param == variable
                    found = true
                    if update_value
                      return_value = obj.value
                      obj.value = []
                      return_value
                    else
                      formula = Formula.new(get(variable))
                      formula.line_breaking(obj)
                      set(variable, obj)
                      get(variable)
                    end
                  else
                    return_value = get(variable)
                    set(variable, nil) if found
                    return_value
                  end
          object.set(variable, Utility.filter_values(value))
        end
        object.hide_function_name = true if object.methods.include?(:hide_function_name)
        obj.update(object)
      end

      def get(variable)
        instance_variable_get(variable)
      end

      def set(variable, value)
        instance_variable_set(variable, value)
      end

      def variables
        instance_variables
      end

      def ox_element(node, attributes: [], namespace: "")
        Utility.ox_element(
          node,
          attributes: attributes,
          namespace: namespace,
        )
      end

      def result(value = [])
        value = get("@value") || value
        value.slice_after { |d| d.is_a?(Math::Function::Linebreak) }.to_a
      end

      def is_unary?
        is_a?(Math::Function::UnaryFunction)
      end

      def is_nary_function?;end

      def is_nary_symbol?;end

      def is_binary_function?
        is_a?(Function::BinaryFunction)
      end

      def is_ternary_function?
        is_a?(Function::TernaryFunction)
      end
    end
  end
end
