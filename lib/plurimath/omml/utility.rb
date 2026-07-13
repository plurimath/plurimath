# frozen_string_literal: true

require "plurimath/mathml/utility"

module Plurimath
  class Omml
    # Omml-specific helper extracted from Plurimath::Utility (code-quality
    # refactor). Subclasses Utility so bareword `Utility.<generic>` calls inside
    # Omml files keep resolving here and inherit the generic helpers.
    class Utility < Plurimath::Utility
      extend Plurimath::Mathml::FunctionTokenResolver

      class << self
        def valid_class(object)
          text = object.extract_class_name_from_text
          (object.extractable? && Asciimath::Constants::SUB_SUP_CLASSES.include?(text)) ||
            Latex::Constants::SYMBOLS[text&.to_sym] == :power_base
        end

        def resolve_text_token(value)
          return nil if value.nil?

          function_from_token(value) || text_token(value)
        end

        def resolve_symbol_token(value)
          return nil if value.nil?

          function_from_token(value) ||
            symbols_class(string_to_html_entity(value.to_s), lang: :omml)
        end

        def populate_function_classes(mrow = [])
          flatten_mrow = mrow.flatten.compact
          unary_function_classes(flatten_mrow)
          binary_function_classes(flatten_mrow)
          ternary_function_classes(flatten_mrow)
          flatten_mrow
        end

        private

        def binary_function_classes(mrow)
          mrow.each_with_index do |object, ind|
            mrow[ind] = resolve_symbol_token(object) if object.is_a?(String)
            object = mrow[ind]
            next unless object.is_a?(Math::Function::Mod)

            object.parameter_one = mrow.delete_at(ind - 1) unless ind.zero?
            object.parameter_two = mrow.delete_at(ind)
          end
        end

        def unary_function_classes(mrow)
          unary_class = Math::Function::UnaryFunction
          if mrow.any?(String) || mrow.any?(unary_class)
            mrow.each_with_index do |object, ind|
              if object.is_a?(String)
                mrow[ind] = resolve_symbol_token(object)
                object = mrow[ind]
              end
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

                object.parameter_three = filter_values(mrow.delete_at(ind + 1))
              end
            end
          end
        end

        def text_token(text)
          text = filter_values(text) unless text.is_a?(String)
          return text if text.is_a?(Math::Core)

          if text.scan(/[[:digit:]]/).length == text.length
            Math::Number.new(text)
          elsif text.match?(/[a-zA-Z]/)
            Math::Function::Text.new(text, lang: :omml)
          else
            text = string_to_html_entity(text)
              .gsub("&#x26;", "&")
              .gsub("&#x3c;", "<")
              .gsub("&#x27;", "'")
              .gsub("&#xa0;", "\u00A0")
              .gsub("&#x3e;", ">")
              .gsub("&#xa;", "\n")
            symbols_class(text, lang: :omml)
          end
        end
      end
    end
  end
end
