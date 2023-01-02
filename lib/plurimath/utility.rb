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
      textbf: Math::Function::FontStyle::Bold,
      bold: Math::Function::FontStyle::Bold,
      bbb: Math::Function::FontStyle::DoubleStruck,
      cal: Math::Function::FontStyle::Script,
      bf: Math::Function::FontStyle::Bold,
      sf: Math::Function::FontStyle::SansSerif,
      tt: Math::Function::FontStyle::Monospace,
      fr: Math::Function::FontStyle::Fraktur,
      cc: Math::Function::FontStyle::Script,
      bb: Math::Function::FontStyle::Bold,
    }.freeze
    ALIGNMENT_LETTERS = {
      r: "right",
      l: "left",
      c: "center",
    }.freeze

    class << self
      def organize_table(array, table = [], table_data = [], table_row = [], column_align: nil)
        td_value = organize_td(array, column_align) if column_align
        table_separators = ["&", "\\\\"].freeze
        array.each do |data|
          if data.is_a?(Math::Symbol) && table_separators.include?(data.value)
            table_row << Math::Function::Td.new(
              filter_table_data(table_data).compact,
              ALIGNMENT_LETTERS[td_value&.to_sym],
            )
            table_data = []
            if data.value == "\\\\"
              table << Math::Function::Tr.new(table_row.flatten)
              table_row = []
            end
          else
            table_data << data
          end
        end
        if table_data
          table_row << Math::Function::Td.new(
            table_data.compact,
            ALIGNMENT_LETTERS[td_value&.to_sym],
          )
        end
        table << Math::Function::Tr.new(table_row) unless table_row.empty?
        [table, td_value]
      end

      def organize_td(table_data, column_align)
        if ALIGNMENT_LETTERS.include?(column_align.first.value.to_sym)
          align = column_align.shift.value
        end
        table_data.insert(0, *column_align)
        align
      end

      def filter_table_data(table_data)
        table_data.each_with_index do |object, ind|
          if symbol_value(object, "-")
            table_data[ind] = Math::Formula.new(
              [object, table_data.delete_at(ind.next)],
            )
          end
        end
        table_data
      end

      def get_table_class(text)
        Object.const_get(
          "Plurimath::Math::Function::Table::#{text.to_s.capitalize}",
        )
      end

      def sub_sup_method?(sub_sup)
        if sub_sup.methods.include?(:class_name)
          Html::Constants::SUB_SUP_CLASSES.value?(sub_sup.class_name.to_sym)
        end
      end

      def get_class(text)
        text = text.to_s.split("_").map(&:capitalize).join
        Object.const_get(
          "Plurimath::Math::Function::#{text}",
        )
      end

      def ox_element(node, attributes: [], namespace: "")
        namespace = "#{namespace}:" unless namespace.empty?

        element = Ox::Element.new("#{namespace}#{node}")
        attributes&.each do |attr_key, attr_value|
          element[attr_key] = attr_value
        end
        element
      end

      def rpr_element(wi_tag: false)
        rpr_element = ox_element("rPr", namespace: "w")
        attributes = { "w:ascii": "Cambria Math", "w:hAnsi": "Cambria Math" }
        rpr_element << ox_element(
          "rFonts",
          namespace: "w",
          attributes: attributes,
        )
        rpr_element << ox_element("i", namespace: "w") if wi_tag
        rpr_element
      end

      def update_nodes(element, nodes)
        nodes&.each { |node| element << node unless node.nil? }
        element
      end

      def pr_element(main_tag, wi_tag, namespace: "")
        tag_name = "#{main_tag}Pr"
        ox_element(
          tag_name,
          namespace: namespace,
        ) << rpr_element(wi_tag: wi_tag)
      end

      def filter_values(array)
        return array unless array.is_a?(Array)

        array = array.flatten.compact
        if array.length > 1
          Math::Formula.new(array)
        else
          array.first
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
        subsup = narypr.any?("undOvr") ? "underover" : "power_base"
        get_class(subsup).new(
          Math::Symbol.new(narypr.any?(Hash) ? narypr.first[:chr] : "∫"),
          nary[1],
          nary[2],
        )
      end

      def find_class_name(object)
        new_object = object.value.first.parameter_one if Math::Formula
        get_class(new_object) unless new_object.nil?
      end

      def find_pos_chr(fonts_array, key)
        fonts_array.find { |d| d.is_a?(Hash) && d[key] }
      end

      def td_values(objects, slicer)
        sliced = objects.slice_when { |object, _| symbol_value(object, slicer) }
        tds = sliced.map do |slice|
          Math::Function::Td.new(
            slice.delete_if { |d| symbol_value(d, slicer) }.compact,
          )
        end
        tds << Math::Function::Td.new([]) if symbol_value(objects.last, slicer)
        tds
      end

      def symbol_value(object, value)
        object.is_a?(Math::Symbol) && object.value.include?(value)
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

        classes = Mathml::Constants::CLASSES
        unicode = string_to_html_entity(string)
        symbol  = Mathml::Constants::UNICODE_SYMBOLS[unicode.strip.to_sym]
        if classes.include?(symbol&.strip)
          get_class(symbol.strip).new
        elsif classes.any?(string&.strip)
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
        sep_symbol = Math::Function::Td.new([Math::Symbol.new("|")])
        separator&.split&.each_with_index do |sep, ind|
          next unless sep == "solid"

          value.map { |val| val.parameter_one.insert((ind + 1), sep_symbol) }
        end
        value
      end

      def join_attr_value(attrs, value)
        if value.any?(String)
          new_value = mathml_unary_classes(value)
          array_value = Array(new_value)
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
          attrs.parameter_one = filter_values(value)
          attrs
        elsif attrs.is_a?(Math::Function::Color)
          color_value = filter_values(value)
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
          if base_value.to_s.include?("mprescripts")
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

      def unfenced_value(object)
        case object
        when Math::Function::Fenced
          value = filter_values(object.parameter_two)
          unfenced_value(value)
        when Array
          filter_values(object)
        else
          object
        end
      end

      def table_td(object)
        new_object = case object
                     when Math::Function::Td
                       object
                     else
                       Math::Function::Td.new([object])
                     end
        Array(new_object)
      end
    end
  end
end
