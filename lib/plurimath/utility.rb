# frozen_string_literal: true

module Plurimath
  class Utility
    FONT_STYLES = {
      "double-struck": Math::Function::FontStyle::DoubleStruck,
      "sans-serif": Math::Function::FontStyle::SansSerif,
      monospace: Math::Function::FontStyle::Monospace,
      fraktur: Math::Function::FontStyle::Fraktur,
      script: Math::Function::FontStyle::Script,
      normal: Math::Function::FontStyle::Normal,
      bold: Math::Function::FontStyle::Bold,
      mathfrak: Math::Function::FontStyle::Fraktur,
      mathcal: Math::Function::FontStyle::Script,
      mathbb: Math::Function::FontStyle::DoubleStruck,
      mathtt: Math::Function::FontStyle::Monospace,
      mathsf: Math::Function::FontStyle::SansSerif,
      mathrm: Math::Function::FontStyle::Normal,
      textrm: Math::Function::FontStyle::Normal,
      mathbf: Math::Function::FontStyle::Bold,
      textbf: Math::Function::FontStyle::Bold,
      bbb: Math::Function::FontStyle::DoubleStruck,
      cal: Math::Function::FontStyle::Script,
      bf: Math::Function::FontStyle::Bold,
      sf: Math::Function::FontStyle::SansSerif,
      tt: Math::Function::FontStyle::Monospace,
      fr: Math::Function::FontStyle::Fraktur,
      rm: Math::Function::FontStyle::Normal,
      cc: Math::Function::FontStyle::Script,
      ii: Math::Function::FontStyle::Italic,
      bb: Math::Function::FontStyle::Bold,
    }.freeze
    ALIGNMENT_LETTERS = {
      c: "center",
      r: "right",
      l: "left",
    }.freeze
    UNARY_CLASSES = %w[
      arccos
      arcsin
      arctan
      right
      sech
      sinh
      tanh
      cosh
      coth
      csch
      left
      max
      min
      sec
      sin
      deg
      det
      dim
      exp
      gcd
      glb
      lub
      tan
      cos
      cot
      csc
      ln
      lg
      f
      g
    ].freeze
    MUNDER_CLASSES = %w[
      ubrace
      obrace
      right
      max
      min
    ].freeze

    class << self
      def organize_table(array, column_align: nil, options: nil)
        table = []
        table_data = []
        table_row = []
        table_separators = ["&", "\\\\"].freeze
        organize_options(array, column_align) if options
        string_columns = column_align&.map(&:value)
        array.each do |data|
          if data.is_a?(Math::Symbol) && table_separators.include?(data.value)
            table_row << Math::Function::Td.new(filter_table_data(table_data).compact)
            table_data = []
            if data.value == "\\\\"
              organize_tds(table_row.flatten, string_columns.dup, options)
              table << Math::Function::Tr.new(table_row)
              table_row = []
            end
            next
          end
          table_data << data
        end
        table_row << Math::Function::Td.new(table_data.compact) if table_data
        unless table_row.nil? || table_row.empty?
          organize_tds(table_row.flatten, string_columns.dup, options)
          table << Math::Function::Tr.new(table_row)
        end
        table_separator(string_columns, table, symbol: "|") unless column_align.nil? || column_align.empty?
        table
      end

      def organize_options(table_data, column_align)
        return column_align if column_align.length <= 1

        align = [column_align&.shift]
        table_data.insert(0, *column_align)
        align
      end

      def table_options(table_data)
        rowline = ""
        table_data.map do |tr|
          if symbol_value(tr&.parameter_one&.first&.parameter_one&.first, "&#x23af;")
            rowline += "solid "
          else
            rowline += "none "
          end
        end
        options = { rowline: rowline.strip } if rowline.include?("solid")
        options || {}
      end

      def organize_tds(tr_array, column_align, options)
        return tr_array if column_align.nil? || column_align.empty?

        column_align.reject! { |string| string == "|" }
        column_align = column_align * tr_array.length if options
        tr_array.map.with_index do |td, ind|
          columnalign = ALIGNMENT_LETTERS[column_align[ind]&.to_sym]
          td.parameter_two = { columnalign: columnalign } if columnalign
        end
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
        nodes&.each do |node|
          next update_nodes(element, node) if node.is_a?(Array)
          element << node unless node.nil?
        end
        element
      end

      def pr_element(main_tag, wi_tag = false, namespace: "")
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
          return Math::Formula.new(array)
        end

        array.first
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
        new_object = object.value.first.parameter_one if object.is_a?(Math::Formula)
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
          return Math::Function::Text.new(nil)
        end

        td_object
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

      def table_separator(separator, value, symbol: "solid")
        sep_symbol = Math::Function::Td.new([Math::Symbol.new("|")])
        separator&.each_with_index do |sep, ind|
          next unless sep == symbol

          value.map do |val|
            val.parameter_one.insert((ind + 1), sep_symbol) if symbol == "solid"
            val.parameter_one.insert(ind, sep_symbol) if symbol == "|"
            (val.parameter_one[val.parameter_one.index(nil)] = Math::Function::Td.new([])) rescue nil
            val
          end
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
          attrs.parameter_two = value.compact
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
        elsif ["solid", "none"].include?(attrs.split.first.downcase)
          table_separator(attrs.split, value)
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

      def frac_values(object)
        case object
        when Math::Formula
          object.value.any? { |d| symbol_value(d, ",") }
        when Array
          object.any? { |d| symbol_value(d, ",") }
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

      def symbol_object(value)
        value = case value
                when "ℒ" then "{:"
                when "ℛ" then ":}"
                else value
                end
        Math::Symbol.new(value)
      end

      def validate_left_right(fields = [])
        fields.each do |field|
          if field.is_a?(Math::Formula)
            wrapper = field.value.first.is_a?(Math::Function::Left) ? "wrap" : nil
            field.left_right_wrapper = wrapper
          end
        end
      end
    end
  end
end
