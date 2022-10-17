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

      def omml_element(node, attributes = [])
        element = Ox::Element.new(node)
        attributes.each do |attr_key, attr_value|
          element[attr_key] = attr_value
        end
        element
      end

      def rpr_element(wi_tag: false)
        rpr_element = omml_element("w:rPr")
        attributes = {
          "w:ascii": "Cambria Math",
          "w:hAnsi": "Cambria Math",
        }
        rpr_element << omml_element("w:rFonts", attributes)
        rpr_element << omml_element("w:i") if wi_tag
        rpr_element
      end

      def update_nodes(element, nodes)
        nodes.each { |node| element << node }
        element
      end

      def pr_element(main_tag, wi_tag)
        omml_element("#{main_tag}Pr") << rpr_element(wi_tag: wi_tag)
      end

      def filter_values(value)
        return value unless value.is_a?(Array)

        compact_value = value.flatten.compact
        if compact_value.length > 1
          Math::Formula.new(compact_value)
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
    end
  end
end
