# frozen_string_literal: true

module Plurimath
  class Html
    module TransformUtility
      module_function

      # Raw Unicode symbols can reach this transform from literal HTML text.
      # Keep Utility.symbols_class as the lookup path, trying the direct value
      # first and then the HTML entity form used by the symbol tables.
      def symbol(symbol)
        known_html_symbol(symbol) ||
          known_html_symbol(Utility.string_to_html_entity(symbol.to_s)) ||
          Math::Symbols::Symbol.new(symbol)
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

      def normalize_sub_sup_value(value)
        return Utility.filter_values(value) if value.is_a?(Array)

        value
      end

      def known_html_symbol(symbol)
        parsed_symbol = Utility.symbols_class(symbol, lang: :html)
        return if generic_symbol?(parsed_symbol)

        parsed_symbol
      end

      def generic_symbol?(symbol)
        symbol.instance_of?(Math::Symbols::Symbol)
      end
    end
  end
end
