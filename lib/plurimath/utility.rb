# frozen_string_literal: true

module Plurimath
  class Utility
    FONT_STYLES = {
      "double-struck": Math::Function::FontStyle::DoubleStruck,
      "sans-serif": Math::Function::FontStyle::SansSerif,
      monospace: Math::Function::FontStyle::Monospace,
      mathfrak: Math::Function::FontStyle::Fraktur,
      mathcal: Math::Function::FontStyle::Script,
      fraktur: Math::Function::FontStyle::Fraktur,
      mathtt: Math::Function::FontStyle::Monospace,
      mathbb: Math::Function::FontStyle::DoubleStruck,
      script: Math::Function::FontStyle::Script,
      mathsf: Math::Function::FontStyle::SansSerif,
      mathbf: Math::Function::FontStyle::Bold,
      bold: Math::Function::FontStyle::Bold,
      bbb: Math::Function::FontStyle::DoubleStruck,
      bf: Math::Function::FontStyle::Bold,
      sf: Math::Function::FontStyle::SansSerif,
      tt: Math::Function::FontStyle::Monospace,
      fr: Math::Function::FontStyle::Fraktur,
      cc: Math::Function::FontStyle::Script,
      bb: Math::Function::FontStyle::Bold,
    }.freeze

    class << self
      def organize_table(array, table = [], table_data = [], table_row = [])
        table_separator = ["&", "\\\\"].freeze
        array.each do |data|
          if data.is_a?(Math::Symbol) && table_separator.include?(data.value)
            table_row << Math::Function::Td.new(filter_table_data(table_data))
            table_data = []
            if data.value == "\\\\"
              table << Math::Function::Tr.new(table_row.flatten)
              table_row = []
            end
          else
            table_data << data
          end
        end
        table_row << Math::Function::Td.new(table_data) if table_data
        table << Math::Function::Tr.new(table_row) unless table_row.empty?
        table
      end

      def filter_table_data(table_data)
        table_data.each_with_index do |object, ind|
          if object.is_a?(Math::Symbol) && object.value == "-"
            table_data[ind] = Math::Formula.new(
              [
                object,
                table_data.delete_at(ind.next),
              ],
            )
          end
        end
        table_data
      end

      def get_table_class(text)
        Object.const_get(
          "Plurimath::Math::Function::Table::#{text.capitalize}",
        )
      end

      def sub_sup_method?(sub_sup)
        if sub_sup.methods.include?(:class_name)
          Html::Constants::SUB_SUP_CLASSES.value?(sub_sup.class_name.to_sym)
        end
      end

      def get_class(text)
        Object.const_get(
          "Plurimath::Math::Function::#{text.capitalize}",
        )
      end

      def raise_error!(open_tag, close_tag)
        message = "Please check your input."\
                  " Opening tag is \"#{open_tag}\""\
                  " and closing tag is \"#{close_tag}\""
        raise Math::Error.new(message)
      end

      def ox_element(node, attributes: [], namespace: "")
        namespace = "#{namespace}:" unless namespace.empty?

        element = Ox::Element.new("#{namespace}#{node}")
        attributes.each do |attr_key, attr_value|
          element[attr_key] = attr_value
        end
        element
      end

      def rpr_element(wi_tag: false)
        rpr_element = ox_element("rPr", namespace: "w")
        attributes = {
          "w:ascii": "Cambria Math",
          "w:hAnsi": "Cambria Math",
        }
        rpr_element << ox_element(
          "rFonts",
          namespace: "w",
          attributes: attributes,
        )
        rpr_element << ox_element("i", namespace: "w") if wi_tag
        rpr_element
      end

      def update_nodes(element, nodes)
        nodes.each { |node| element << node unless node.nil? }
        element
      end

      def pr_element(main_tag, wi_tag, namespace: "")
        tag_name = "#{main_tag}Pr"
        ox_element(
          tag_name,
          namespace: namespace,
        ) << rpr_element(wi_tag: wi_tag)
      end

      def filter_values(value, wrapped: false)
        return value unless value.is_a?(Array)

        compact_value = value.flatten.compact
        if compact_value.length > 1
          Math::Formula.new(compact_value, wrapped)
        else
          compact_value.first
        end
      end

      def text_classes(text)
        return nil if text.empty?

        text = filter_values(text) unless text.is_a?(String)
        if text.scan(/[[:digit:]]/).length == text.length
          Math::Number.new(text)
        elsif text.match?(/[a-zA-Z]/)
          Math::Function::Text.new(text)
        else
          Math::Symbol.new(text)
        end
      end

      def nary_fonts(nary)
        narypr = nary.first.flatten.compact
        fonts  = narypr.any?(Hash) ? narypr.first[:chr] : "∫"
        subsup = if narypr.any?("undOvr")
                   Math::Function::Underover
                 else
                   Math::Function::PowerBase
                 end
        subsup.new(
          Math::Symbol.new(fonts),
          nary[1],
          nary[2],
        )
      end

      def find_class_name(object)
        new_object = case object
                     when Math::Function::Text
                       object.parameter_one
                     when Math::Formula
                       object.value.first.parameter_one
                     end
        get_class(new_object) unless new_object.nil?
      end

      def find_pos_chr(fonts_array, key)
        fonts_array.find { |d| d.is_a?(Hash) && d[key] }
      end

      def nested_formula_object(array)
        if array.length > 1
          Math::Formula.new(array)
        else
          array.first
        end
      end

      def td_values(objects)
        sliced = objects.slice_when { |object, _| comma(object) }
        tds = sliced.map do |slice|
          Math::Function::Td.new(
            slice.delete_if { |d| comma(d) },
          )
        end
        tds << Math::Function::Td.new([]) if comma(objects.last)
        tds
      end

      def comma(object)
        object.is_a?(Math::Symbol) && object.value.include?(",")
      end

      def td_value(td_object)
        if td_object.is_a?(String) && td_object.empty?
          Math::Function::Text.new(nil)
        else
          td_object
        end
      end

      def mathml_unary_classes(text_array)
        return [] if text_array.empty?

        compacted = text_array.compact
        string = if compacted.count == 1
                   compacted.first
                 else
                   compacted.join
                 end
        return string unless string.is_a?(String)

        unicode = string_to_html_entity(string)
        symbol  = Mathml::Constants::UNICODE_SYMBOLS[unicode.strip.to_sym]
        if Mathml::Constants::CLASSES.include?(symbol&.strip)
          get_class(symbol.strip).new
        elsif Mathml::Constants::CLASSES.any?(string&.strip)
          get_class(string.strip).new
        else
          Math::Symbol.new(unicode)
        end
      end

      def string_to_html_entity(string)
        entities = HTMLEntities.new
        entities.encode(string, :hexadecimal)
      end

      def table_separator(separator, value)
        solid_none = separator.split
        sep_symbol = Math::Function::Td.new([Math::Symbol.new("|")])
        solid_none.each_with_index do |sep, ind|
          next unless sep == "solid"

          value.map { |val| val.parameter_one.insert((ind + 1), sep_symbol) }
        end
        value
      end

      def join_attr_value(attrs, value)
        if value.any?(String)
          new_value = mathml_unary_classes(value)
          array_value = new_value.is_a?(Array) ? new_value : [new_value]
          attrs.nil? ? array_value : join_attr_value(attrs, array_value)
        elsif attrs.nil?
          value
        elsif attrs.is_a?(Math::Function::Menclose)
          attrs.parameter_two = filter_values(value)
          attrs
        elsif attrs.is_a?(Math::Function::Fenced)
          attrs.parameter_two = value
          attrs
        elsif attrs.is_a?(Math::Function::FontStyle)
          attrs.parameter_one = nested_formula_object(value)
          attrs
        elsif attrs.is_a?(Math::Function::Color)
          color_value = nested_formula_object(value)
          if attrs.parameter_two
            attrs.parameter_two.parameter_one = color_value
          else
            attrs.parameter_two = color_value
          end
          attrs
        elsif ["solid", "none"].include?(attrs.downcase)
          table_separator(attrs, value)
        end
      end

      def multiscript(values)
        values.slice_before("mprescripts").map do |value|
          base_value   = value.shift
          part_val     = value.partition.with_index { |_, i| i.even? }
          first_value  = part_val[0].empty? ? nil : filter_values(part_val[0])
          second_value = part_val[1].empty? ? nil : filter_values(part_val[1])
          if base_value.is_a?(String) && base_value.include?("mprescripts")
            [first_value, second_value]
          else
            Math::Function::PowerBase.new(
              base_value,
              first_value,
              second_value,
            )
          end
        end
      end
    end
  end
end
