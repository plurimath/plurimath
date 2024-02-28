# frozen_string_literal: true

require_relative "helper"
module Plurimath
  class UnicodeMath
    module ParsingRules
      module AbsenceRules
        include Helper

        rule(:absent_negated_unicodes) { sqrt_symbols | root_symbols }

        rule(:absent_chars) do
          (
            op_unary_arg_functions |
            op_diacritic_overlays |
            op_unicode_fractions |
            op_diacritic_belows |
            op_ordinary_symbols |
            relational_symbols |
            op_sub_close_paren |
            op_sup_close_paren |
            op_sub_open_paren |
            op_sup_open_paren |
            invisible_unicode |
            op_unary_symbols |
            op_sub_operators |
            op_sup_operators |
            op_close_unicode |
            str("&#x2534;") |
            str("&#x252c;") |
            str("&#x2524;") |
            str("&#x251c;") |
            str("&#x270e;") |
            str("&#x2062;") |
            str("&#x2044;") |
            str("&#x2061;") |
            str("&#x2601;") |
            str("&#x2592;") |
            str("&#x249e;") |
            str("&#x2298;") |
            op_open_unicode |
            op_nary_symbols |
            str("&#x221a;") |
            str("&#x221b;") |
            str("&#x221c;") |
            str("&#x24ad;") |
            str("&#x25ad;") |
            str("&#xffd7;") |
            str("&#x24d0;") |
            str("&#x24d8;") |
            str("&#x20;") |
            str("&#x27;") |
            str("&#x2f;") |
            str("&#xac;") |
            str("&#xa6;") |
            op_sup_digits |
            op_sub_digits |
            op_sup_alpha |
            op_sub_alpha |
            op_h_bracket |
            op_matrixs |
            op_accent
          ).absent?
        end

        rule(:absent_slashed_values) do
          (
            op_prefixed_unary_arg_functions |
            op_prefixed_ordinary_symbols |
            op_prefixed_unary_symbols |
            op_relational_symbols |
            op_h_bracket_prefixed |
            op_alphanumeric_fonts |
            op_prefixed_matrixs |
            op_binary_symbols_prefixed |
            op_prefixed_negated |
            op_accent_prefixed |
            str("\\backcolor") |
            str("\\naryand") |
            str("\\color") |
            str("\\rect") |
            str("\\sqrt") |
            str("\\qdrt") |
            str("\\cbrt") |
            str("\\root") |
            str("\\of") |
            op_nary_text |
            op_close |
            op_fonts |
            op_open
          ).absent?
        end

        rule(:other_absent) do
          (
            an.as(:other_exp) |
            op_build_up |
            match('\r') |
            n_ascii |
            char
          ).absent?
        end

        rule(:non_matrixs_absence?) do
          (
            str("eqarray") |
            str("&#x2588;") |
            str("cases") |
            str("&#x24b8;")
          ).absent?
        end

        rule(:absent_numerator_exp_script?) do
          (power_base_script.as(:nary_sub_sup) >> invisible_space? >> naryand_recursion.as(:naryand)).absent? |
            (op_nary >> invisible_space? >> naryand_recursion.as(:naryand).maybe).absent?
        end
      end
    end
  end
end
