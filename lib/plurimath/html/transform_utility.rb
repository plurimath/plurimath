# frozen_string_literal: true

module Plurimath
  class Html
    module TransformUtility
      module_function

      HTML_ENTITY = /\A&(?:#x[0-9a-f]+|#\d+|[a-z][a-z0-9]+);\z/i

      def symbol(symbol)
        Utility.symbols_class(normalize_symbol(symbol), lang: :html)
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

      def normalize_symbol(symbol)
        symbol = symbol.to_s
        return symbol if symbol.match?(HTML_ENTITY)

        Utility.string_to_html_entity(symbol)
      end
    end
  end
end
