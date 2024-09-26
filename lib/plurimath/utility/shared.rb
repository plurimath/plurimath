# frozen_string_literal: true

module Plurimath
  class Utility
    module Shared
      ALIGNMENT_LETTERS = {
        c: "center",
        r: "right",
        l: "left",
      }.freeze

      def table_separator(separator, value, symbol: "solid")
        sep_symbol = Math::Function::Td.new([Math::Symbols::Paren::Vert.new])
        separator&.each_with_index do |sep, ind|
          next unless sep == symbol

          value.each do |val|
            if ["solid", "|"].include?(symbol)
              index = symbol == "solid" ? (ind + 1) : ind
              val.parameter_one.insert(index, sep_symbol)
            end
            val.parameter_one.map! { |v| v.nil? ? Math::Function::Td.new([]) : v }
          end
        end
        value
      end

      def mathml_unary_classes(text_array, omml: false, unicode_only: false, lang: nil)
        return [] if text_array.empty?

        compacted = text_array.compact
        return Utility.filter_values(compacted) unless compacted.any?(String)

        string  = compacted.join
        classes = Mathml::Constants::CLASSES
        unicode = string_to_html_entity(string)
        return Utility.symbols_class(unicode, lang: lang) if unicode_only && unicode

        symbol = Mathml::Constants::UNICODE_SYMBOLS[unicode.strip.to_sym]
        if classes.include?(symbol&.strip)
          Utility.get_class(symbol.strip).new
        elsif classes.any?(string&.strip)
          Utility.get_class(string.strip).new
        else
          omml ? text_classes(string, lang: lang) : Utility.symbols_class(unicode, lang: lang)
        end
      end

      def populate_function_classes(mrow = [], lang:)
        flatten_mrow = mrow.flatten.compact
        unary_function_classes(flatten_mrow, lang: lang)
        binary_function_classes(flatten_mrow, lang: lang)
        ternary_function_classes(flatten_mrow)
        flatten_mrow
      end

      def binary_function_classes(mrow, under: false, lang:)
        binary_class = Math::Function::BinaryFunction
        mrow.each_with_index do |object, ind|
          mrow[ind] = mathml_unary_classes([object], lang: lang) if object.is_a?(String)
          object = mrow[ind]
          next unless object.is_a?(binary_class)

          if object.is_a?(Math::Function::Mod)
            next unless mrow.length >= 1

            object.parameter_one = mrow.delete_at(ind - 1) unless ind.zero?
            object.parameter_two = mrow.delete_at(ind)
          elsif Mathml::Constants::UNICODE_SYMBOLS.invert[object.class_name] && mrow.length > 1
            next if object.parameter_one || mrow.length > 2
            next object.parameter_one = mrow.delete_at(ind - 1) if under && ind <= 1

            object.parameter_one = mrow.delete_at(ind + 1)
          end
        end
      end

      def unary_function_classes(mrow, lang:)
        unary_class = Math::Function::UnaryFunction
        if mrow.any?(String) || mrow.any?(unary_class)
          mrow.each_with_index do |object, ind|
            mrow[ind] = mathml_unary_classes([object], lang: lang) if object.is_a?(String)
            object = mrow[ind] if object.is_a?(String)
            next unless object.is_a?(unary_class)
            next if object.is_a?(Math::Function::Text)
            next if object.parameter_one || mrow[ind + 1].nil?
            next unless ind.zero?

            object.parameter_one = mrow.delete_at(ind + 1)
          end
        end
      end

      def ternary_function_classes(mrow)
        ternary_class = Math::Function::TernaryFunction
        if mrow.any?(ternary_class) && mrow.length > 1
          mrow.each_with_index do |object, ind|
            if object.is_a?(ternary_class)
              next if [Math::Function::Fenced, Math::Function::Multiscript].include?(object.class)
              next unless object.parameter_one || object.parameter_two
              next if object.parameter_three

              object.parameter_three = Utility.filter_values(mrow.delete_at(ind + 1))
            end
          end
        end
      end

      def string_to_html_entity(string)
        entities = HTMLEntities.new
        entities.encode(
          string.frozen? ? string : string.force_encoding('UTF-8'),
          :hexadecimal,
        )
      end

      def unfenced_value(object, paren_specific: false)
        case object
        when Math::Function::Fenced
          if !paren_specific || (paren_specific && valid_paren?(object))
            Utility.filter_values(object.parameter_two)
          else
            object
          end
        when Array
          Utility.filter_values(object)
        else
          object
        end
      end

      def valid_paren?(object)
        object.parameter_one.is_a?(Math::Symbols::Paren::Lround) &&
          object.parameter_three.is_a?(Math::Symbols::Paren::Rround) &&
          !object.options.keys.any? { |k| [:open_paren, :close_paren].any?(k.to_sym) } &&
          !object.parameter_one.mini_sup_sized &&
          !object.parameter_three.mini_sub_sized &&
          object.options.empty?
      end

      def text_classes(text, lang:)
        return nil unless text

        text = Utility.filter_values(text) unless text.is_a?(String)
        return text if text.is_a?(Math::Core)

        if text&.scan(/[[:digit:]]/)&.length == text&.length
          Math::Number.new(text)
        elsif text&.match?(/[a-zA-Z]/)
          Math::Function::Text.new(text)
        else
          text = string_to_html_entity(text)
                  .gsub("&#x26;", "&")
                  .gsub("&#x3c;", "<")
                  .gsub("&#x27;", "'")
                  .gsub("&#xa0;", " ")
                  .gsub("&#x3e;", ">")
                  .gsub("&#xa;", "\n")
          Utility.symbols_class(text, lang: lang)
        end
      end
    end
  end
end