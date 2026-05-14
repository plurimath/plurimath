# frozen_string_literal: true

module Plurimath
  class Html
    module TransformUtility
      CANONICAL_HTML_SYMBOLS = {
        "!" => "&#x21;",
        "%" => "&#x25;",
        "-" => "&#x2212;",
        "/" => "&#x2215;",
      }.freeze

      def symbol(symbol)
        decoded_symbol = Utility.html_entity_to_unicode(symbol.to_s)
        mapped_symbol = Utility.symbols_class(canonical_symbol(decoded_symbol), lang: :html)
        return mapped_symbol unless mapped_symbol.instance_of?(Math::Symbols::Symbol)

        Utility.symbols_class(decoded_symbol, lang: :html)
      end

      def append_expression(value, expression)
        return [value] + expression if expression.is_a?(Array)

        [value, expression]
      end

      def sub_sup_value(sub_sup, sub_value: nil, sup_value: nil)
        normalized_sub_value = normalize_sub_sup_value(sub_value)
        normalized_sup_value = normalize_sub_sup_value(sup_value)

        if Utility.sub_sup_method?(sub_sup)
          sub_sup.parameter_one = normalized_sub_value if normalized_sub_value
          sub_sup.parameter_two = normalized_sup_value if normalized_sup_value
          sub_sup
        elsif normalized_sub_value && normalized_sup_value
          Math::Function::PowerBase.new(
            sub_sup,
            normalized_sub_value,
            normalized_sup_value,
          )
        elsif normalized_sup_value
          Math::Function::Power.new(
            sub_sup,
            normalized_sup_value,
          )
        else
          Math::Function::Base.new(
            sub_sup,
            normalized_sub_value,
          )
        end
      end

      def canonical_symbol(symbol)
        CANONICAL_HTML_SYMBOLS.fetch(symbol) do
          Utility.string_to_html_entity(symbol)
        end
      end

      def normalize_sub_sup_value(value)
        return Utility.filter_values(value) if value.is_a?(Array)

        value
      end

      module_function :symbol, :append_expression, :sub_sup_value,
                      :canonical_symbol, :normalize_sub_sup_value
      private_class_method :canonical_symbol, :normalize_sub_sup_value
    end
  end
end
