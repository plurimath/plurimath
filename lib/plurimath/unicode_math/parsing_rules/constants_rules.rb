# frozen_string_literal: true

require_relative "helper"
module Plurimath
  class UnicodeMath
    module ParsingRules
      module ConstantsRules
        include Helper

        rule(:slash) { str("\\") }

        rule(:op_open) { slash >> arr_to_expression(Constants::OPEN_SYMBOLS.keys, :open_paren) }

        rule(:op_fonts) { slash >> arr_to_expression(Constants::FONTS_CLASSES, :font_class) }
        rule(:op_close) { slash >> arr_to_expression(Constants::CLOSE_SYMBOLS.keys, :close_paren) }

        rule(:op_accent) { arr_to_expression(Constants::ACCENT_SYMBOLS.values, :accent_symbols) }

        rule(:op_matrixs) { arr_to_expression(Constants::MATRIXS.values, :matrixs) }
        rule(:op_negated) { arr_to_expression(Constants::NEGATABLE_SYMBOLS, :negated_operator) }

        rule(:op_nary_text) { slash >> arr_to_expression(Constants::NARY_SYMBOLS.keys, :nary_class) }
        rule(:op_sub_alpha) { arr_to_expression(Constants::SUB_ALPHABETS.values, :sub_alpha) }
        rule(:op_sup_alpha) { arr_to_expression(Constants::SUP_ALPHABETS.values, :sup_alpha) }
        rule(:op_h_bracket) { arr_to_expression(Constants::HORIZONTAL_BRACKETS.values, :hbracket_class) }

        rule(:op_open_paren) { arr_to_expression(Constants::OPEN_PARENTHESIS, :open_paren) }
        rule(:op_sup_digits) { arr_to_expression(Constants::SUP_DIGITS.values, :sup_digits) }
        rule(:op_sub_digits) { arr_to_expression(Constants::SUB_DIGITS.values, :sub_digits) }

        rule(:binary_symbols) { op_binary_symbols | op_binary_symbols_prefixed }
        rule(:op_close_paren) { arr_to_expression(Constants::CLOSE_PARENTHESIS, :close_paren) }

        rule(:op_nary_symbols) { arr_to_expression(Constants::NARY_SYMBOLS.values, :nary_class) }
        rule(:op_open_unicode) { arr_to_expression(Constants::OPEN_SYMBOLS.values, :open_paren) }

        rule(:combined_symbols) { op_combined_symbols | op_combined_unicode }
        rule(:op_close_unicode) { arr_to_expression(Constants::CLOSE_SYMBOLS.values, :close_paren) }
        rule(:op_unary_symbols) { arr_to_expression(Constants::UNARY_SYMBOLS.values, :unary_symbols) }
        rule(:op_sub_operators) { arr_to_expression(Constants::SUB_OPERATORS.values, :sub_operators) }
        rule(:op_sup_operators) { arr_to_expression(Constants::SUP_OPERATORS.values, :sup_operators) }

        rule(:op_binary_symbols) { arr_to_expression(Constants::BINARY_SYMBOLS.values, :binary_symbols) }
        rule(:op_sub_open_paren) { arr_to_expression(Constants::SUB_PARENTHESIS[:open].values, :sub_open_paren) }
        rule(:op_sup_open_paren) { arr_to_expression(Constants::SUP_PARENTHESIS[:open].values, :sup_open_paren) }

        rule(:op_accent_prefixed) { slash >> arr_to_expression(Constants::ACCENT_SYMBOLS.keys, :accent_symbols) }
        rule(:op_unary_functions) { arr_to_expression(Constants::UNARY_FUNCTIONS, :unary_functions) }
        rule(:op_sub_close_paren) { arr_to_expression(Constants::SUB_PARENTHESIS[:close].values, :sub_close_paren) }
        rule(:op_sup_close_paren) { arr_to_expression(Constants::SUP_PARENTHESIS[:close].values, :sup_close_paren) }

        rule(:op_prefixed_matrixs) { slash >> arr_to_expression(Constants::MATRIXS.keys, :matrixs) }
        rule(:op_prefixed_negated) { slash >> arr_to_expression(Constants::PREFIXED_NEGATABLE_SYMBOLS, :negated_operator) }
        rule(:op_diacritic_belows) { arr_to_expression(Constants::DIACRITIC_BELOWS, :diacritic_belows) }
        rule(:op_combined_symbols) { arr_to_expression(Constants::COMBINING_SYMBOLS.keys, :combined_symbols) }
        rule(:op_ordinary_symbols) { arr_to_expression(Constants::ORDINARY_SYMBOLS.values, :ordinary_symbols) }
        rule(:op_combined_unicode) { arr_to_expression(Constants::COMBINING_SYMBOLS.values, :combined_symbols) }

        rule(:op_unicode_fractions)  { arr_to_expression(Constants::UNICODE_FRACTIONS.keys, :unicode_fractions) }
        rule(:op_alphanumeric_fonts) { slash >> arr_to_expression(Constants::ALPHANUMERIC_FONTS_CLASSES, :font_class) }
        rule(:op_h_bracket_prefixed) { slash >> arr_to_expression(Constants::HORIZONTAL_BRACKETS.keys, :hbracket_class) }
        rule(:op_relational_symbols) { slash >> arr_to_expression(Constants::RELATIONAL_SYMBOLS.keys, :relational_symbols) }
        rule(:op_diacritic_overlays) { arr_to_expression(Constants::DIACRITIC_OVERLAYS, :diacritic_overlays) }
        rule(:op_relational_unicode) { arr_to_expression(Constants::RELATIONAL_SYMBOLS.values, :relational_symbols) }

        rule(:op_unary_arg_functions) { arr_to_expression(Constants::UNARY_ARG_FUNCTIONS.values, :unary_arg_functions) }

        rule(:op_prefixed_unary_symbols) { slash >> arr_to_expression(Constants::UNARY_SYMBOLS.keys, :unary_symbols) }
        rule(:op_size_overrides_symbols) { str("&#x2132;") >> arr_to_expression(Constants::SIZE_OVERRIDES_SYMBOLS.keys, :size_overrides) }

        rule(:op_binary_symbols_prefixed) { slash >> arr_to_expression(Constants::BINARY_SYMBOLS.keys, :binary_symbols) }

        rule(:op_prefixed_ordinary_symbols) { slash >> arr_to_expression(Constants::ORDINARY_SYMBOLS.keys, :ordinary_symbols) }

        rule(:op_prefixed_unary_arg_functions) { slash >> arr_to_expression(Constants::UNARY_ARG_FUNCTIONS.keys, :unary_arg_functions) }

        def arr_to_expression(arr, name = nil)
          type = arr.first.class
          if arr.length > 1
            arr.reduce do |expression, expr_string|
              expression = str(expression).as(name) if expression.is_a?(type)
              expression | str(expr_string).as(name)
            end
          else
            str(arr.first).as(name)
          end
        end
      end
    end
  end
end
