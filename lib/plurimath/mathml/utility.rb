# frozen_string_literal: true

module Plurimath
  class Mathml
    module FunctionTokenResolver
      # Promotes an accent character to its function class. Callers must only
      # use this from an accent position; elsewhere the character has to stay a
      # plain symbol/text. Decode-then-encode normalizes both call sites: MathML
      # passes an already-encoded "&#x303;", OMML passes the raw U+0303.
      def contextual_accent_from_token(value)
        return nil if value.nil?

        entity = string_to_html_entity(html_entity_to_unicode(value.to_s))
        function_name =
          Mathml::Constants::CONTEXTUAL_ACCENT_FUNCTIONS[entity.strip.to_sym]
        get_class(function_name).new if function_name
      end

      private

      def function_from_token(value)
        return nil if value.nil?

        string = value.to_s
        word = string.strip
        unicode = string_to_html_entity(string)
        symbol = Mathml::Constants::UNICODE_SYMBOLS[unicode.strip.to_sym]&.strip
        function_name =
          if Mathml::Constants::CLASSES.include?(symbol)
            symbol
          elsif Mathml::Constants::CLASSES.include?(word) &&
              Mathml::Constants.named_function_word?(word)
            word
          end

        get_class(function_name).new if function_name
      end
    end

    class Utility < Plurimath::Utility
      extend FunctionTokenResolver

      class << self
        def resolve_token(value)
          return nil if value.nil?

          function_from_token(value) ||
            symbols_class(string_to_html_entity(value.to_s), lang: :mathml)
        end
      end
    end
  end
end
