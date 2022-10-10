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

      def filter_values(value)
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

      def parse_nary_tag(first_value, second_value)
        Math::Formula.new(
          [first_value, Math::Formula.new(second_value)],
        )
      end
    end
  end
end
