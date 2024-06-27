# frozen_string_literal: true

require_relative "helper"
module Plurimath
  class UnicodeMath
    module ParsingRules
      module AbsenceRules
        include Helper

        rule(:frac_binary_absent) { frac_binary_absent_symbols? >> binary_symbols }

        rule(:non_matrixs_absence?) { (str("eqarray") | str("&#x2588;") | str("cases") | str("&#x24b8;")).absent? }

        rule(:sub_sup_binary_absent) { ((slash >> str("times")) | str("&#xd7;")).absent? >> binary_symbols }

        rule(:absent_negated_unicodes) { sqrt_symbols | root_symbols }

        rule(:frac_binary_absent_symbols?) { ((slash >> (str("times") | str("neq") | str("ne"))) | (str("&#xd7;") | str("&#x2260"))).absent? }

        rule(:binary_negated_absent_symbols?) { ((slash >> str("dd")) | str("&#x2146;")).absent? }

        rule(:mini_fraction_exp_script_absent?) { (operator >> mini_fraction).absent? }

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
            op_binary_symbols |
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
            str("&#x2223;") |
            str("&#x2215;") |
            unicoded_fonts |
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
            skip_symbols |
            op_matrixs |
            op_accent |
            primes
          ).absent?
        end

        rule(:absent_slashed_values) do
          (
            op_prefixed_unary_arg_functions |
            op_prefixed_ordinary_symbols |
            op_binary_symbols_prefixed |
            op_prefixed_unary_symbols |
            slash >> str("backcolor") |
            slash >> str("naryand") |
            slash >> str("sdivide") |
            slash >> str("oslash") |
            slash >> str("color") |
            op_relational_symbols |
            op_h_bracket_prefixed |
            op_alphanumeric_fonts |
            skip_symbols_prefixed |
            slash >> str("sfrac") |
            slash >> str("rect") |
            slash >> str("sqrt") |
            slash >> str("qdrt") |
            slash >> str("cbrt") |
            slash >> str("root") |
            slash >> str("sdiv") |
            slash >> str("ndiv") |
            slash >> str("ldiv") |
            op_prefixed_matrixs |
            op_binary_symbols_prefixed |
            op_prefixed_negated |
            slash >> str("mid") |
            op_accent_prefixed |
            prefixed_primes |
            op_nary_text |
            str("\\of") |
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

        rule(:absent_numerator_exp_script?) do
          (power_base_script.as(:nary_sub_sup) >> invisible_space? >> naryand_recursion.as(:naryand)).absent? |
            (op_nary >> invisible_space? >> naryand_recursion.as(:naryand).maybe).absent?
        end
      end
    end
  end
end
