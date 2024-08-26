# frozen_string_literal: true

require_relative "helper"
module Plurimath
  class UnicodeMath
    module ParsingRules
      module CommonRules
        include Helper

        rule(:atom)   { (diacritics >> diacriticbase.maybe) | an }
        rule(:atoms)  { (atom.as(:atom) >> atoms.as(:atoms).maybe) }
        rule(:entity) { atoms | number }

        rule(:operator) { match["-+*=.?:,`"].as(:operator) }
        rule(:op_unary) { op_prefixed_unary_arg_functions | op_unary_arg_functions | op_prefixed_unary_symbols | op_unary_symbols }

        rule(:mid_symbols) { (slash >> str("mid").as(:mid_symbol)) | str("&#x2223;").as(:mid_symbol) }

        rule(:unary_spaces) { space | invisible_unicode }
        rule(:custom_fonts) { str("double") | str("fraktur") | str("script") }
        rule(:parsing_text) { str("\"") >> match("[^\"]").repeat(1).as(:text) >> str("\"") }
        rule(:alphanumeric) { match("[\u{0041}-\u{005A}\u{0061}-\u{007A}\u{0391}-\u{2207}\u{3B1}-\u{3DD}\u{30}-\u{39}]") }

        rule(:op_h_brackets)  { op_h_bracket | op_h_bracket_prefixed }
        rule(:nary_functions) { (op_unary >> unary_spaces.maybe) | (op_unary_functions >> unary_spaces) }
        rule(:exclamation_symbols) { (str("!") | str("!!")).as(:exclamation_symbol) }
        rule(:exclamation_symbols?) { exclamation_symbols.maybe }

        rule(:mini_fraction) do
          sup_paren.as(:mini_numerator) >> (negatable_symbols.absent? >> op_over) >> sub_paren.as(:mini_denominator)
        end

        rule(:binomial_fraction) do
          numerator.as(:numerator) >> op_over_choose >> denominator.as(:denominator)
        end

        rule(:fraction) do
          mini_fraction |
            binomial_fraction |
            numerator.as(:numerator) >> space? >> (negatable_symbols.absent? >> op_over) >> space? >> denominator.as(:denominator)
        end

        rule(:fonts) do
          unicoded_fonts |
            str("\\") >> custom_fonts.as(:unicoded_font_class) >> str("H").as(:symbol) |
            str("\\") >> str("mitBbb").as(:unicoded_font_class) >> match(/D|d|e|i|j/).as(:symbol)|
            op_fonts >> match["A-Za-z"].as(:symbol) |
            op_alphanumeric_fonts >> (match["A-Za-z"].as(:symbol) | match("[0-9]").as(:number))
        end

        rule(:unary_arg_functions) do
          (op_unary_functions >> space? >> (soperand | exp_bracket).as(:first_value).maybe) |
            (nary_functions >> space? >> (exp_bracket | soperand).as(:first_value)).as(:unary_function)
        end

        rule(:accents)  do
          (exp_bracket.as(:intermediate_exp).as(:first_value) >> str("&#xa0;").maybe >> repeated_accent_symbols).as(:accents) |
            (str("&#xa0;").absent? >> factor.as(:first_value) >> str("&#xa0;").maybe >> repeated_accent_symbols).as(:accents)
        end

        rule(:diacritics_accents) do
          (operand.as(:first_value) >> op_diacritic_overlays.as(:overlay_after)).as(:diacritics_accents) |
            (operand.as(:first_value) >> op_diacritic_belows.as(:below_after)).as(:diacritics_accents) |
            (op_diacritic_belows.as(:below_before) >> operand.as(:first_value)).as(:diacritics_accents) |
            (op_diacritic_overlays.as(:overlay_before) >> operand.as(:first_value)).as(:diacritics_accents)
        end

        rule(:repeated_accent_symbols) do
          (op_accent | op_accent_prefixed).repeat(1) >> prime_symbols.maybe |
            prime_symbols
        end

        rule(:prime_symbols) do
          ((slash >> prefixed_primes.as(:prefixed_prime) | primes).repeat(1).as(:prime_accent_symbols))
        end

        rule(:operand) do
          rect |
            phant |
            accents |
            negatable_symbols |
            fonts.as(:fonts) |
            wrapper_symbols |
            ((parsing_text | factor.as(:factor)) >> operand.as(:operand).maybe)
        end

        rule(:factor) do
          combined_symbols |
            ((str("&#x2212;").absent? >> op_unary_functions.absent?) >> entity >> exclamation_symbols?) |
            color |
            (exp_bracket.as(:intermediate_exp) >> exclamation_symbols?) |
            function |
            backcolor |
            op_spaces |
            monospace_fonts |
            relational_symbols |
            unary_arg_functions |
            op_unary_functions >> unary_spaces >> (operand | exp_bracket).absent? |
            wrapper_symbols |
            ordinary_symbols |
            negatable_symbols |
            str("...").as(:ldots).as(:symbol) |
            exclamation_symbols
        end

        rule(:soperand) do
          operand |
            infty.as(:infty) |
            (str("-") >> infty).as(:symbol) |
            str("&#x2212;").as(:symbol) |
            str("-").as(:symbol) |
            operator
        end

        rule(:bracketed_soperand) do
          (op_opener.as(:opener) >> space? >> soperand.as(:operand) >> space? >> op_closer.as(:closer)).as(:int_exp) |
            soperand.as(:operand)
        end

        rule(:infty) { str("&#x221e;") }
      end
    end
  end
end
