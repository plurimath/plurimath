# frozen_string_literal: true

module Plurimath
  module Math
    class Core
      REPLACABLES = {
        /&amp;/ => "&",
        /^\n/ => "",
      }.freeze

      ALL_PARAMETERS = %i[
        parameter_one
        parameter_two
        parameter_three
        parameter_four
      ].freeze

      def self.inherited(subclass)
        @descendants ||= []
        @descendants << subclass
        super
      end

      def self.descendants
        @descendants
      end

      def class_name
        self.class.name.split("::").last.downcase
      end

      def insert_t_tag(display_style, options:)
        Array(omml_nodes(display_style, options: options))
      end

      def tag_name
        "subsup"
      end

      def omml_tag_name
        "subSup"
      end

      def nary_attr_value(**)
        ""
      end

      def empty_tag(wrapper_tag = nil)
        r_tag = ox_element("r", namespace: "m")
        r_tag << (ox_element("t", namespace: "m") << "&#8203;")
        return r_tag unless wrapper_tag

        wrapper_tag << r_tag
      end

      def omml_parameter(field, display_style, tag_name:, namespace: "m", options:)
        tag = ox_element(tag_name, namespace: namespace)
        return empty_tag(tag) unless field

        field_value = if field.is_a?(Array)
                        field.map { |object| object.insert_t_tag(display_style, options: options) }
                      else
                        field.insert_t_tag(display_style, options: options)
                      end
        Utility.update_nodes(tag, field_value)
      end

      def validate_function_formula
        true
      end

      def r_element(string, rpr_tag: true)
        r_tag = ox_element("r", namespace: "m")
        if rpr_tag
          r_tag << (ox_element("rPr", namespace: "m") << msty_tag_with_attrs)
        end
        r_tag << (ox_element("t", namespace: "m") << string)
        Array(r_tag)
      end

      def msty_tag_with_attrs
        attrs = { "m:val": "p" }
        ox_element("sty", namespace: "m", attributes: attrs)
      end

      def extractable?
        false
      end

      def extract_class_name_from_text
        ""
      end

      def font_style_t_tag(display_style, options:)
        omml_nodes(display_style, options: options)
      end

      def ascii_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        options[:array] << "#{hashed[:spacing]}|_ \"#{field&.to_asciimath(options: options[:options])}\"#{hashed[:field_name]}\n"
        return unless Utility.validate_math_zone(field, lang: :asciimath)

        options[:array] << field&.to_asciimath_math_zone(hashed[:function_spacing], hashed[:last], hashed[:indent], options: options[:options])
      end

      def latex_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        options[:array] << "#{hashed[:spacing]}|_ \"#{field&.to_latex(options: options[:options])}\"#{hashed[:field_name]}\n"
        return unless Utility.validate_math_zone(field, lang: :latex)

        options[:array] << field&.to_latex_math_zone(hashed[:function_spacing], hashed[:last], hashed[:indent], options: options[:options])
      end

      def mathml_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        options[:array] << "#{hashed[:spacing]}|_ \"#{dump_mathml(field, options: options[:options])}\"#{hashed[:field_name]}\n"
        return unless Utility.validate_math_zone(field, lang: :mathml, intent: options[:intent], options: options[:options])

        options[:array] << field&.to_mathml_math_zone(hashed[:function_spacing], hashed[:last], hashed[:indent], options: options[:options])
      end

      def omml_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        display_style = options[:display_style]
        options[:array] << "#{hashed[:spacing]}|_ \"#{dump_omml(field, display_style, options: options[:options])}\"#{hashed[:field_name]}\n"
        return unless Utility.validate_math_zone(field, lang: :omml)

        options[:array] << field&.to_omml_math_zone(hashed[:function_spacing], hashed[:last], hashed[:indent], display_style: display_style, options: options[:options])
      end

      def unicodemath_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        options[:array] << "#{hashed[:spacing]}|_ \"#{field&.to_unicodemath(options: options[:options])}\"#{hashed[:field_name]}\n"
        return unless Utility.validate_math_zone(field, lang: :unicodemath)

        options[:array] << field&.to_unicodemath_math_zone(hashed[:function_spacing], hashed[:last], hashed[:indent], options: options[:options])
      end

      def dump_mathml(field, intent = false, options:)
        dump_ox_nodes(field.mathml_nodes(intent, options: options)).gsub(/\n\s*/, "")
      end

      def dump_omml(field, display_style, options:)
        return if field.nil?

        dump_ox_nodes(field.omml_nodes(display_style, options: options)).gsub(/\n\s*/, "")
      end

      def mathml_nodes(intent, options:)
        to_mathml_without_math_tag(intent, options: options)
      end

      def omml_nodes(display_style, options:)
        to_omml_without_math_tag(display_style, options: options)
      end

      def validate_mathml_fields(field, intent, options:)
        if field.is_a?(Array)
          field&.map { |object| object.mathml_nodes(intent, options: options) }
        else
          field&.mathml_nodes(intent, options: options)
        end
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

      def filtered_values(value, lang:, options: {})
        @values = Utility.filter_math_zone_values(value, lang: lang, options: options)
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
        REPLACABLES.each { |regex, str| string = string.gsub(regex, str) }
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

      def linebreak?
        false
      end

      def cloned_objects
        object = self.class.new(nil)
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
            array_line_break_field(field, variable, obj)
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

      def is_nary_function?; end

      def is_nary_symbol?; end

      def nary_intent_name; end

      def symbol?
        is_a?(Math::Symbols::Symbol)
      end

      def is_binary_function?
        is_a?(Function::BinaryFunction)
      end

      def is_ternary_function?
        is_a?(Function::TernaryFunction)
      end

      def mini_sized?
        false
      end

      def unicodemath_parens(field, options:)
        paren = field.to_unicodemath(options: options)
        return paren if field.is_a?(Math::Function::Fenced)

        "(#{paren})" if field
      end

      def prime_unicode?(field)
        return unless field.is_a?(Math::Symbols::Symbol)
        return true if field&.value&.include?("&#x27;")

        Utility.primes_constants.any? { |prefix, prime| unicodemath_field_value(field).include?(prime) }
      end

      def paren?
        false
      end

      def pretty_print_instance_variables
        excluded_vars = [
          :@left_right_wrapper,
          :@temp_mathml_order,
          :@using_default,
          :@displaystyle,
          :@__encoding,
          :@__ordered,
          :@unitsml,
          :@__mixed,
          :@is_mrow,
          :@values,
        ]
        instance_variables.sort - excluded_vars
      end

      def to_ms_value
        new_arr = []
        case self
        when Math::Symbols::Symbol
          new_arr << (value ? value.to_s : to_unicodemath(options: {}))
        when Math::Number, Math::Function::Text
          new_arr << value
        else
          parameters_to_ms_value(new_arr)
          if respond_to?(:value) && value.is_a?(Array)
            new_arr << value&.map { |element| element.to_ms_value }.join(" ")
          end
        end
        new_arr
      end

      def is_mstyle?
        false
      end

      def is_mrow?
        false
      end

      private

      def parameters_to_ms_value(array)
        ALL_PARAMETERS.each do |field|
          array << get("@#{field}")&.to_ms_value if respond_to?(field)
        end
      end

      def array_line_break_field(field, variable, obj)
        if result(field).length > 1
          updated_object_values(variable, obj: obj)
        else
          field.each { |object| object.line_breaking(obj) }
        end
      end

      def unicodemath_field_value(field)
        field.class_name == "symbol" ? field.value : Utility.hexcode_in_input(field)
      end

      def wrap_mrow(xml_engine_node, intent)
        return xml_engine_node if xml_engine_node.name == "mrow"
        return xml_engine_node unless intent

        ox_element("mrow") << xml_engine_node
      end

      def intentify(tag, intent, func_name:, intent_name: nil, options: {})
        return tag unless intent

        Utility::IntentEncoding.send("#{func_name}_intent", tag, intent_name, options)
      end

      def masked_tag(tag)
        options_array = get_mask_options
        if options_array.include?("show_up_limit_place_holder") && parameter_three.nil?
          set_place_holder(tag, type: :above)
        end
        if options_array.include?("show_low_limit_place_holder") && parameter_two.nil?
          set_place_holder(tag, type: :below)
        end
        if options_array.include?("limits_opposite")
          change_power_base_values(tag)
        end
        if options_array.include?("limits_under_over")
          case tag.name
          when "msubsup" then tag.name = "munderover"
          when "msub" then tag.name = "munder"
          when "msup" then tag.name = "mover"
          end
        elsif options_array.include?("limits_sub_sup")
          case tag.name
          when "munderover" then tag.name = "msubsup"
          when "munder" then tag.name = "msub"
          when "mover" then tag.name = "msup"
          end
        elsif options_array.include?("upper_limit_as_super_script") && tag.nodes[1].name == "mrow"
          tag = Utility.update_nodes(
            ox_element("munder"),
            [
              Utility.update_nodes(
                ox_element("msup"),
                [
                  tag.nodes[0],
                  tag.nodes[2],
                ],
              ),
              tag.nodes[1],
            ],
          )
        end
        tag
      end

      def get_mask_options(mask_options = [])
        mask = options&.dig(:mask).to_i

        case mask % 4
        when 0 then mask_options << "limits_default"
        when 1 then mask_options << "limits_under_over"
        when 2 then mask_options << "limits_sub_sup"
        when 3 then mask_options << "upper_limit_as_super_script"
        end

        mask -= mask % 4

        case mask % 32
        when 4 then mask_options << "limits_opposite"
        when 8 then mask_options << "show_low_limit_place_holder"
        when 12 then mask_options += ["limits_opposite", "show_low_limit_place_holder"]
        when 16 then mask_options << "show_up_limit_place_holder"
        when 20 then mask_options += ["limits_opposite", "show_up_limit_place_holder"]
        when 24 then mask_options += ["show_low_limit_place_holder", "show_up_limit_place_holder"]
        when 28 then mask_options += ["limits_opposite", "show_low_limit_place_holder", "show_up_limit_place_holder"]
        end

        mask_options
      end

      def change_power_base_values(tag)
        return unless ["munderover", "msubsup"].include?(tag.name)

        Plurimath.xml_engine.replace_nodes(
          tag,
          [tag.nodes[0], tag.nodes[2], tag.nodes[1]],
        )
      end

      def set_place_holder(node, type:)
        nodes = if type == :below
                  node.name = node.name == "msup" ? "msubsup" : "munderover"
                  node.nodes.insert(1, mo_tag("&#x2b1a;"))
                else
                  node.name = node.name == "msub" ? "msubsup" : "munderover"
                  node.nodes.insert(2, mo_tag("&#x2b1a;"))
                end
        Plurimath.xml_engine.replace_nodes(node, nodes)
      end

      def mo_tag(str)
        ox_element("mo") << str
      end
    end
  end
end
