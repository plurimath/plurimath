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
        rule(:op_unary) { op_prefixed_unary_arg_functions | op_unary_arg_functions | op_prefixed_unary_symbols | op_unary_symbols }



        rule(:unary_spaces) { space | invisible_unicode }
        rule(:custom_fonts) { str("double") | str("fraktur") | str("script") }
        rule(:parsing_text) { str("\"") >> match("[^\"]").repeat(1).as(:text) >> str("\"") }
        rule(:alphanumeric) { match("[\u{0041}-\u{005A}\u{0061}-\u{007A}\u{0391}-\u{2207}\u{3B1}-\u{3DD}\u{30}-\u{39}]") }

        rule(:op_h_brackets)  { op_h_bracket | op_h_bracket_prefixed }
        rule(:nary_functions) { (op_unary >> unary_spaces.maybe) | (op_unary_functions >> unary_spaces) }

        rule(:fonts) do
          str("\\") >> custom_fonts.as(:unicoded_font_class) >> str("H").as(:symbol) |
            str("\\") >> str("mitBbb").as(:unicoded_font_class) >> match(/D|d|e|i|j/).as(:symbol)|
            op_fonts >> match["A-Za-z"].as(:symbol) |
            op_alphanumeric_fonts >> (match["A-Za-z"].as(:symbol) | match("[0-9]").as(:number))
        end

        rule(:unary_arg_functions) do
          op_unary_functions >> (soperand | exp_bracket).as(:first_value).maybe |
            (nary_functions >> (exp_bracket | soperand).as(:first_value)).as(:unary_function)
        end

        rule(:accents)  do
          (exp_bracket.as(:intermediate_exp).as(:first_value) >> str("&#xa0;").maybe >> repeated_accent_symbols).as(:accents) |
            (str("&#xa0;").absent? >> factor.as(:first_value) >> str("&#xa0;").maybe >> repeated_accent_symbols).as(:accents)
        end

        rule(:diacritics_accents) do
          (operand.as(:first_value) >> op_diacritic_overlays).as(:diacritics_accents) |
            (operand.as(:first_value) >> op_diacritic_belows).as(:diacritics_accents) |
            (op_diacritic_belows >> operand.as(:first_value)).as(:diacritics_accents) |
            (op_diacritic_overlays >> operand.as(:first_value)).as(:diacritics_accents)
        end

        rule(:repeated_accent_symbols) do
          (
            op_accent |
            op_accent_prefixed |
            ((str("&#x27;") | str("'")).repeat(1) >> space?).as(:accent_symbols)
          ).repeat(1)
        end

        rule(:accent_symbols) do
          op_accent |
            op_accent_prefixed |
            ((str("&#x27;") | str("'"))).as(:accent_symbols)
        end

        rule(:operand) do
          rect |
            phant |
            accents |
            monospace_fonts |
            combined_symbols |
            negatable_symbols |
            ((parsing_text | factor.as(:factor)) >> operand.as(:operand).maybe) |
            fonts.as(:fonts)
        end

        rule(:factor) do
          combined_symbols |
            ((str("&#x2212;").absent? >> op_unary_functions.absent?) >> entity >> (str("!") | str("!!")).as(:exclamation_symbol).maybe) |
            color |
            (exp_bracket.as(:intermediate_exp) >> (str("!") | str("!!")).as(:exclamation_symbol).maybe) |
            function |
            backcolor |
            monospace_fonts |
            relational_symbols |
            unary_arg_functions |
            op_unary_functions >> unary_spaces >> (operand | exp_bracket).absent? |
            ordinary_symbols |
            negatable_symbols |
            str("...").as(:ldots).as(:symbol)
        end

        rule(:soperand) do
          operand |
            str("&#x221e;").as(:infty) |
            str("-&#x221e;").as(:symbol) |
            str("-").as(:symbol) |
            operator
        end

        rule(:bracketed_soperand) do
          (op_opener.as(:opener) >> space? >> soperand.as(:operand) >> space? >> op_closer.as(:closer)).as(:int_exp) |
            soperand.as(:operand)
        end
      end
    end
  end
end
