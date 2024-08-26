# frozen_string_literal: true

require_relative "parsing_rules/masked"
require_relative "parsing_rules/sub_sup"
require_relative "parsing_rules/common_rules"
require_relative "parsing_rules/absence_rules"
require_relative "parsing_rules/constants_rules"
module Plurimath
  class UnicodeMath
    class Parse < Parslet::Parser
      include ParsingRules::Masked
      include ParsingRules::SubSup
      include ParsingRules::CommonRules
      include ParsingRules::ConstantsRules
      include ParsingRules::AbsenceRules

      rule(:an)  { an_math | an_other }
      rule(:box) { str("□") >> operand }

      rule(:char) { (absent_chars >> unicode.as(:unicode_symbols)) }
      rule(:rows) { (str("@").as(:tr) >> space? >> rows.as(:trs).maybe) | (row.as(:tr) >> space? >> str("@") >> space? >> rows.as(:trs).maybe) | row.as(:tr) }

      rule(:space) { match(/\s/).repeat(1) | invisible_times }
      rule(:other) { other_absent >> alphanumeric.as(:symbol) }

      rule(:space?) { space.maybe }
      rule(:digits) { (n_ascii >> digits) | n_ascii }

      rule(:op_nary) { op_nary_symbols | op_nary_text }
      rule(:n_ascii) { match["0-9"].repeat(1).as(:number) }
      rule(:a_ascii) { match["A-Za-z"].repeat(1).as(:symbol) }
      rule(:unicode) { str("&#x") >> match["0-9a-fA-F"].repeat >> str(";") }
      rule(:an_math) { space.absent? >> match("[\u{1D400}-\u{1D7FF}\u{2102}-\u{2134}]") }

      rule(:td_value) { expression.as(:exp) >> space? >> td_value.as(:expr).maybe }
      rule(:an_other) { (an_math | n_ascii).absent? >> alphanumeric.as(:alphanumeric) }
      rule(:function) { root_functions | box | hbrack | arg_function | intent_function }
      rule(:op_array) { op_matrixs | op_prefixed_matrixs | str("&") | str("&#xb;") | str("\\array") }

      rule(:op_opener) { open_paren | op_open_unicode | op_open_paren | op_open }
      rule(:op_closer) { op_close_unicode | close_paren | op_close_paren | op_close }

      rule(:op_decimal) { str(",") | str(".") }
      rule(:diacritics) { (char.as(:char) >> diacritics.as(:diacritics)) | char.as(:char) }
      rule(:open_paren) { (op_masked_open >> (op_closer | op_opener)).as(:open_paren) | op_masked_open }

      rule(:matrix_only) { non_matrixs_absence? >> (op_matrixs | op_prefixed_matrixs) }
      rule(:close_paren) { (op_masked_close >> (op_opener | op_closer)).as(:close_paren) | op_masked_close }

      rule(:diacriticbase) { an | n_ascii }
      rule(:forward_slash) { str("/") | str("&#x2f;") | str("&#x2044;") }

      rule(:root_functions) { qdrt | cbrt | sqrt | binary_root | nthrt }
      rule(:op_over_choose) { (str("\\choose") | str("&#x249e;")).as(:choose) }
      rule(:op_masked_open) { (str("\\left") | str("\\open") | str("&#x251c;")).as(:paren_open_prefix) >> digits.as(:open_paren_mask).maybe }

      rule(:invisible_times) { (str("&#x2062;") | str("&#x2061;") | str("&#x20;") | str("\\itimes") >> space?) }

      rule(:ordinary_symbols) { op_ordinary_symbols | op_prefixed_ordinary_symbols }
      rule(:interval_a_ascii) { match["A-Za-z"].as(:symbol).repeat(1) }

      rule(:negatable_symbols) { forward_slash >> negated | negated >> str("&#x338;") }
      rule(:invisible_unicode) { str("&#x2592;") | (str("\\naryand") | str("\\of") >> space?) }

      rule(:invisible_unicode?) { invisible_unicode.maybe }
      rule(:relational_symbols) { op_relational_unicode | op_relational_symbols }

      rule(:hbrack_power_base_check)  { (sub_sup_operand >> (power_symbol | base_symbol)).present? }
      rule(:spaced_bracketed_operand) { operand >> space? >> spaced_bracketed_operand.as(:expr).maybe }

      rule(:hbrack) do
        (op_h_brackets >> str("(").present? >> exp_bracket.as(:first_value)) |
          (op_h_brackets >> (sub_sup_operand >> (power_symbol | base_symbol)).present? >> exp_script.as(:scripted_first_value)).as(:hbrack) |
          (op_h_brackets >> operand.as(:first_value)).as(:hbrack)
      end

      rule(:negated) do
        root_functions.absent? >> (
          op_negated |
          op_prefixed_negated |
          op_prefixed_ordinary_negated |
          op_ordinary_negated |
          binary_negated |
          absent_negated_unicodes >> unicode.as(:negated_operator)
        )
      end

      rule(:op_over) do
        str("&#x2044;").as(:bevelled) |
          slash >> (str("sdiv") | str("sdivide") | str("sfrac")).as(:bevelled) |
          str("&#x2298;").as(:no_display_style) |
          slash >> (str("ndiv") | str("oslash")).as(:no_display_style) |
          (str("&#x2215;") | str("\\ldiv")).as(:ldiv) |
          forward_slash |
          str("\\over") |
          str("&#x2f;") |
          str("\\not") |
          (str("&#xa6;") | str("\\atop")).as(:atop) |
          op_over_choose
      end

      rule(:element_exp_script_validation?) do
        (((op_unary_functions | unary_arg_functions).absent? >> atom.as(:factor).maybe) >> (mini_sub_sup_present? >> operator >> mini_fraction.present?).absent?)
      end

      rule(:spaced_exp_bracket) do
        expression >> space? >> spaced_exp_bracket.as(:exp) |
          mid_symbols >> space? >> spaced_exp_bracket.as(:expr) |
          str("&#x2212;").as(:symbol) >> space? >> spaced_exp_bracket.as(:expr) |
          expression >> space?
      end

      rule(:row) do
        (td_value.as(:td) >> space? >> str("&") >> space? >> row.as(:tds).maybe) |
          td_value.as(:td) |
          (char.absent? >> space? >> str("&").as(:td) >> space? >> row.as(:tds).maybe)
      end

      rule(:array) do
        (op_array >> str("(") >> rows.as(:array) >> str(")")).as(:table) |
          (matrix_only >> match["0-9"].as(:identity_matrix_number)).as(:table)
      end

      rule(:slashed_operator) do
        absent_slashed_values >> str("\\") >> (str("\\") | unicode | (n_ascii | a_ascii).repeat(1) | any).as(:slashed_value) |
          absent_slashed_values >> str("\\").as(:slashed_value)
      end

      rule(:number) do
        (digits.as(:whole) >> op_decimal.as(:decimal) >> digits.as(:fractional)).as(:decimal_number) |
          (op_decimal.as(:decimal) >> digits.as(:whole) >> space?).as(:decimal_number) |
          digits.as(:digit)
      end

      rule(:numerator) do
        (relational_symbols.absent? | exp_script.present?) >>  (
          (unary_arg_functions >> numerator.as(:recursive_numerator).maybe) |
          ((absent_numerator_exp_script? >> op_nary.absent?) >> mini_fraction_exp_script_absent? >> exp_script >> space) >> numerator.as(:recursive_numerator).maybe |
          (absent_numerator_exp_script? >> mini_fraction_exp_script_absent? >> exp_script) >> numerator.as(:recursive_numerator).maybe |
          (accents.as(:base) >> accents_subsup).as(:accents_subsup) |
          sub_paren |
          sup_paren |
          accents |
          unary_arg_functions |
          (frac_binary_absent >> numerator.as(:recursive_numerator)) |
          (factor >> frac_binary_absent.maybe >> numerator.as(:recursive_numerator).maybe) |
          operator.absent? >> operand >> frac_binary_absent.maybe |
          frac_binary_absent
        )
      end

      rule(:op_build_up) do
        str("_") |
          str("^") |
          str("∛") |
          str("∜") |
          str("□") |
          str("|") |
          op_array |
          op_open |
          op_close |
          op_nary |
          op_over |
          forward_slash |
          op_h_brackets |
          root_symbols |
          op_decimal
      end

      rule(:exp_bracket) do
        (str("||").as(:open_paren) >> space? >> spaced_exp_bracket >> space? >> str("||").as(:close_paren)) |
          (str("|").as(:open_paren) >> space? >> spaced_exp_bracket >> space? >> str("|").as(:close_paren)) |
          interval_exp_bracket |
          (op_opener >> space? >> spaced_exp_bracket.maybe >> space? >> op_closer) |
          (mix_bracketed.as(:intermediate_exp) >> space? >> expression.as(:expr)) |
          (mix_bracketed.as(:intermediate_exp) >> space)
      end

      rule(:interval_exp_bracket) do
        str("(").as(:open_paren) >> interval_value.as(:left_value) >> str(",").as(:comma) >> interval_value.as(:right_value) >> str("]").as(:close_paren) |
        str("[").as(:open_paren) >> interval_value.as(:left_value) >> str(",").as(:comma) >> interval_value.as(:right_value) >> str(")").as(:close_paren) |
        (str("[") | str("]")).as(:open_paren) >> interval_value.as(:left_value) >> str(",").as(:comma) >> interval_value.as(:right_value) >> (str("[") | str("]")).as(:close_paren)
      end

      rule(:interval_value) do
        infty.as(:infty) |
          (str("+").as(:positive) >> (infty.as(:infty) | digits | interval_a_ascii)) |
          ((str("-") | str("&#x2212;")).as(:negative) >> (infty.as(:infty) | digits | interval_a_ascii)) |
          digits |
          interval_a_ascii
      end

      rule(:mix_bracketed) do
        (op_opener >> space? >> spaced_exp_bracket >> space? >> str("|").as(:close_paren)) |
          (str("|").as(:open_paren) >> space? >> spaced_exp_bracket >> space? >> op_closer)
      end

      rule(:denominator) do
        operator.absent? >> fraction.as(:frac) |
          exp_script |
          sub_paren |
          sup_paren |
          frac_binary_absent >> invisible_times.maybe >> relational_symbols.absent? >> denominator.as(:recursive_denominator) |
          operator.absent? >> factor >> invisible_times.maybe >> relational_symbols.absent? >> denominator.as(:recursive_denominator) |
          operator.absent? >> operand >> invisible_times.maybe >> relational_symbols.absent? >> denominator.as(:recursive_denominator) |
          frac_binary_absent |
          operator.absent? >> operand
      end

      rule(:op_masked_close) do
        (str("\\right") | str("\\close") | str("&#x2524;")).as(:paren_close_prefix) >> digits.as(:close_paren_mask).maybe
      end

      rule(:element) do
        accents.present? >> (accents.as(:base) >> accents_subsup).as(:accents_subsup) |
          accents.present? >> fraction.as(:frac) |
          ((op_unary_functions | unary_arg_functions).present? >> fraction.as(:frac)) |
          mini_sub_sup_present? >> operator >> mini_fraction.as(:frac) |
          accents |
          diacritics_accents |
          op_unicode_fractions |
          fraction.as(:frac) |
          monospace_fonts |
          array |
          exp_script |
          element_exp_script_validation? >> space? >> exp_script |
          unary_arg_functions |
          combined_symbols |
          wrapper_symbols |
          operand |
          char |
          alphanumeric |
          negatable_symbols |
          operator |
          binary_symbols |
          slashed_operator
      end

      rule(:expression) do
        element >> other.as(:other) >> expression.as(:expr) |
          element >> relational_symbols >> expression.as(:expr).maybe |
          element |
          element >> space? >> expression.as(:expr) |
          slashed_operator >> space? >> expression.as(:expr).maybe |
          element >> space? >> expression.as(:expr) >> space? >> expression.as(:expression).maybe |
          mini_values >> space? >> expression.as(:expr).maybe
      end

      root :expression
    end
  end
end
