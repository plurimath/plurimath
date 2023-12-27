# frozen_string_literal: true

require_relative "helper"
module Plurimath
  class UnicodeMath
    module ParsingRules
      module SubSup
        include Helper

        rule(:subscript) { base_value >> subscript_value }
        rule(:supscript) { base_value >> supscript_value }

        rule(:sub_or_sup)  { subscript | supscript }
        rule(:base_symbol) { str("_") }
        rule(:script_base) { mini_sub_sup_present? >> mini_sub_sup | sub_sup_operand }
        rule(:base_syntax) { base_symbol | (str("&#x252c;") | str("\\below")).as(:under) }

        rule(:power_symbol) { str("^") }
        rule(:power_syntax) { power_symbol | (str("&#x2534;") | str("\\above")).as(:over) }

        rule(:sub_sup_paren) { sub_paren.as(:sub_paren) | sup_paren.as(:sup_paren) }
        rule(:pre_subscript) { base_syntax >> size_overrides? >> (operand | mini_sub_sup | operator_symbols).as(:pre_subscript) | sub_paren.as(:pre_subscript) }
        rule(:pre_supscript) { power_syntax >> size_overrides? >> (operand | mini_sub_sup | operator_symbols).as(:pre_supscript) | sup_paren.as(:pre_supscript) }

        rule(:mini_sub_value) { (sub_sup_operand.as(:base) >> sub_paren.as(:sub)).as(:mini_sub) }
        rule(:mini_sup_value) { (sub_sup_operand.as(:base) >> sup_paren.as(:sup)).as(:mini_sup) }

        rule(:size_overrides?)  { op_size_overrides_symbols.maybe }
        rule(:invisible_space?) { (invisible_unicode? >> invisible_times.maybe).maybe }
        rule(:operator_symbols) { combined_symbols | negatable_symbols | operator }

        rule(:power_base_script) { (base_value >> subsup).as(:subsup_exp) | subscript.as(:sub_exp) | supscript.as(:sup_exp) }

        rule(:mini_sub_sup_present?) { mini_sub_value.present? | mini_sup_value.present? | mini_subsup.present? }

        rule(:sup_script) do
          (script_base.as(:base) >> sup_paren.as(:sup_script)).as(:sup) >> sup_script.as(:recursion).maybe
        end

        rule(:sub_script) do
          (script_base.as(:base) >> sub_paren.as(:sub_script)).as(:sub) >> sub_script.as(:recursion).maybe
        end

        rule(:subscript_value) do
          (sub_paren | baseless_sub.as(:sub)) >> recursive_baseless_sub_exp.as(:recursion).maybe
        end

        rule(:supscript_value) do
          (sup_paren | baseless_sup.as(:sup)) >> recursive_baseless_sup_exp.as(:recursion).maybe
        end

        rule(:naryand_recursion) do
          (operator.absent? >> naryand_values >> naryand_recursion.as(:naryand_recursion).maybe)
        end
        
        rule(:baseless_sub) do
          (invisible_space? >> base_syntax >> size_overrides? >> (operator_symbols.maybe >> baseless_sub_values(:sub_script))) |
            (invisible_space? >> base_syntax >> size_overrides? >> (operator_symbols >> recursive_baseless_sub_exp.maybe)) |
              (invisible_space? >> base_syntax >> size_overrides? >> (operator_symbols >> baseless_sub_values(:sub_script).maybe)) |
            sub_sup_paren.as(:sub_script)
        end

        rule(:baseless_sup) do
          (invisible_space? >> power_syntax >> size_overrides? >> (operator_symbols.maybe >> baseless_sup_values(:sup_script))) |
            (invisible_space? >> power_syntax >> size_overrides? >> (operator_symbols >> recursive_baseless_sup_exp.maybe)) |
              (invisible_space? >> power_syntax >> size_overrides? >> (operator_symbols >> baseless_sup_values(:sup_script).maybe)) |
            sub_sup_paren.as(:sup_script)
        end

        rule(:recursive_baseless_sup_exp) do
          (mini_sub_sup >> recursive_baseless_sup_exp.as(:exp_iteration).maybe) |
            (baseless_sup.as(:sup_script) >> recursive_baseless_sup_exp.as(:exp_iteration).maybe) 
        end

        rule(:recursive_baseless_sub_exp) do
          (mini_sub_sup >> recursive_baseless_sub_exp.as(:exp_iteration).maybe) |
            (baseless_sub.as(:sub_script) >> recursive_baseless_sub_exp.as(:exp_iteration).maybe)
        end

        rule(:naryand_values) do
          (exp_bracket >> (subsup | subscript_value | supscript_value).maybe) |
            (exp_script >> space?) |
            expression
        end

        rule(:mini_sub_sup) do
          mini_sub_sup_present? >> (
            (sub_sup_operand.as(:base) >> mini_subsup).as(:mini_sub_sup) |
            mini_sub_value |
            mini_sup_value
          )
        end

        rule(:nary_sub_sup) do
          (power_base_script.as(:nary_sub_sup) >> invisible_space? >> naryand_recursion.as(:naryand).maybe) |
            (op_nary >> invisible_space? >> naryand_recursion.as(:naryand).maybe)
        end

        rule(:unary_sub_sup) do
          ((power_base_script | mini_sub_sup).as(:unary_sub_sup) >> (invisible_space? >> space?) >> expression.as(:first_value).maybe) |
            (op_unary_functions >> (invisible_space? >> space?) >> expression.as(:first_value).maybe)
        end

        rule(:base_value) do
          op_nary.present? >> op_nary >> invisible_space? >> number.as(:mask).maybe |
            script_base.as(:base) >> invisible_space?
        end

        rule(:subsup) do
          baseless_sub.as(:sub) >> baseless_sup.as(:sup) |
            baseless_sup.as(:sup) >> baseless_sub.as(:sub)
        end

        rule(:mini_subsup) do
          sub_paren.as(:sub) >> sup_paren.as(:sup) |
            sup_paren.as(:sup) >> sub_paren.as(:sub)
        end

        rule(:accents_subsup) do
          baseless_sub.as(:sub) >> baseless_sup.as(:sup) |
            baseless_sup.as(:sup) >> baseless_sub.as(:sub) |
            sub_paren.as(:sub) >> sup_paren.as(:sup) |
            sup_paren.as(:sup) >> sub_paren.as(:sub) |
            baseless_sub.as(:sub) |
            baseless_sup.as(:sup) |
            sub_paren.as(:sub) |
            sup_paren.as(:sup)
        end

        rule(:exp_script) do
          op_nary.present? >> nary_sub_sup.as(:nary) |
            op_unary_functions.present? >> unary_sub_sup.as(:unary_subsup) |
            accents.present? >> (accents.as(:base) >> accents_subsup).as(:accents_subsup) |
            power_base_script |
            (paren_wrap_rule(pre_subsup) >> space? >> (operand.as(:base) >> (subsup | mini_subsup | subscript_value | supscript_value).maybe)).as(:pre_script) |
            mini_sub_sup
        end

        rule(:pre_subsup) do
          pre_subscript >> pre_supscript |
            pre_supscript >> pre_subscript |
            pre_subscript |
            pre_supscript
        end

        rule(:sub_sup_operand) do
          accents |
            op_unary_functions >> invisible_unicode? |
            a_ascii |
            (a_ascii >> n_ascii) |
            (n_ascii >> a_ascii) |
            an_math |
            number |
            other |
            exp_bracket |
            parsing_text |
            negatable_symbols |
            soperand |
            (str("|") | str("&#x2032;")).as(:symbol)
        end

        rule(:sub_alpha_digits) do
          (op_sub_digits >> op_sub_alpha).as(:expr) >> sub_paren.as(:sub_recursion).maybe |
            (op_sub_alpha >> op_sub_digits).as(:expr) >> sub_paren.as(:sub_recursion).maybe |
            op_sub_alpha >> sub_paren.as(:sub_recursion_expr).maybe |
            op_sub_digits >> sub_paren.as(:sub_recursion_expr).maybe |
            op_sub_operators >> sub_paren.as(:sub_recursions).maybe
        end

        rule(:sup_alpha_digits) do
          (op_sup_digits >> op_sup_alpha).as(:expr) >> sup_paren.as(:sup_recursion).maybe |
            (op_sup_alpha >> op_sup_digits).as(:expr) >> sup_paren.as(:sup_recursion).maybe |
            op_sup_alpha >> sup_paren.as(:sup_recursion_expr).maybe |
            op_sup_digits >> sup_paren.as(:sup_recursion_expr).maybe |
            op_sup_operators >> sup_paren.as(:sup_recursions).maybe
        end

        rule(:sub_paren) do
          op_sub_open_paren >> sub_alpha_digits >> op_sub_close_paren >> sub_paren.maybe |
            sub_alpha_digits >> sub_paren.maybe
        end

        rule(:sup_paren) do
          op_sup_open_paren >> sup_alpha_digits >> op_sup_close_paren >> sup_paren.maybe |
            sup_alpha_digits >> sup_paren.maybe
        end

        rule(:sub_sup_values) do
          (operator_symbols.as(:expr) >> (((mini_sub_sup | sub_or_sup) >> space?) >> bracketed_soperand.maybe)) |
            (operator_symbols.as(:expr) >> bracketed_soperand) |
            ((accent_symbols.as(:first_value) >> repeated_accent_symbols).as(:accents) >> (sub_or_sup.maybe >> space? >> bracketed_soperand).maybe) |
            bracketed_soperand >> operator_symbols.absent? >> sub_sup_values.as(:expr).maybe |
            bracketed_soperand
        end

        def paren_wrap_rule(passed_rule)
          (op_opener >> space? >> passed_rule >> space? >> op_closer) |
            passed_rule
        end

        def baseless_sub_values(soperand_name)
          (mini_sub_sup | sub_sup_paren).as(soperand_name) >> recursive_baseless_sub_exp.as(:recursion).maybe >> sub_sup_values.maybe |
            sub_sup_values.as(soperand_name) >> recursive_baseless_sub_exp.as(:recursion).maybe
        end

        def baseless_sup_values(soperand_name)
          (mini_sub_sup | sub_sup_paren).as(soperand_name) >> recursive_baseless_sup_exp.as(:recursion).maybe >> sub_sup_values.maybe |
            sub_sup_values.as(soperand_name) >> recursive_baseless_sup_exp.as(:recursion).maybe
        end
      end
    end
  end
end
