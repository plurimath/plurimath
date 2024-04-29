# frozen_string_literal: true

require_relative "helper"
module Plurimath
  class UnicodeMath
    module ParsingRules
      module Masked
        include Helper

        rule(:rect) { rect_symbols >> space? >> bracketed_masked_value(:rect) }
        rule(:sqrt) { (sqrt_symbols.as(:root_symbol) >> (exp_script | operand).as(:first_value)).as(:root) }
        rule(:qdrt) { (qdrt_symbols.as(:root_symbol) >> (exp_script | operand).as(:first_value)).as(:root) }
        rule(:cbrt) { (cbrt_symbols.as(:root_symbol) >> (exp_script | operand).as(:first_value)).as(:root) }

        rule(:color) { color_symbols >> space? >>  bracketed_masked_value(:color) }
        rule(:phant) { phantom_symbols >> space? >> bracketed_masked_value(:phantom) }

        rule(:backcolor)   { backcolor_symbols >> space? >> bracketed_masked_value(:backcolor) }

        rule(:cbrt_symbols) { str("&#x221b;") | str("\\cbrt") }
        rule(:qdrt_symbols) { str("&#x221c;") | str("\\cbrt") }
        rule(:rect_symbols) { str("&#x25ad;") | str("\\rect") }
        rule(:sqrt_symbols) { str("&#x221a;") | str("\\sqrt") | str("\\surd") }
        rule(:root_symbols) { str("&#x24ad;") | str("&#x221a;") | str("\\root") | str("\\surd") }
        rule(:arg_function) do
          str("&#x24d0;").as(:arg) >> str("(") >> a_ascii.as(:arg_arguments).maybe >> space? >> expression.as(:first_value).maybe >> str(")") |
            str("&#x24d0;").as(:arg) >> a_ascii.as(:arg_arguments).maybe >> space? >> expression.as(:first_value).maybe
        end

        rule(:color_symbols)   { str("&#x270e;") | str("\\color") }
        rule(:phantom_symbols) { str("&#x27e1;") | str("\\phantom") }
        rule(:monospace_fonts) { (str("&#xffd7;") >> str("(") >> space? >> expression.as(:monospace_value) >> space? >> str(")")).as(:monospace) }

        rule(:backcolor_symbols) { str("&#x2601;") | str("\\backcolor") }
        rule(:masked_recursive_value) { (space? >> expression | exp_bracket | exp_script).as(:expr) >> masked_recursive_value.as(:func_expr).maybe }

        rule(:root_invisible_character?) { (str("\\naryand").absent? >> invisible_unicode).maybe }

        rule(:nthrt) do
          (sqrt_symbols >> str("(") >> masked_recursive_value.as(:first_value) >> str("&") >> masked_recursive_value.as(:second_value) >> str(")")).as(:root)
        end

        rule(:binary_root) do
          root_symbols >> space? >> masked_recursive_value.as(:root_first_value) >> space? >> root_invisible_character? >> space? >> masked_recursive_value.as(:root_second_value)
        end

        rule(:intent_function) do
          str("&#x24d8;").as(:intent) >> str("(").as(:open_paren) >> parsing_text.as(:intent_arguments).maybe >> space? >> expression.as(:first_value).maybe >> str(")").as(:close_paren) |
            str("&#x24d8;").as(:intent) >> expression.as(:intent_expr)
        end

        def masked_value(func_name)
          match["^&"].repeat(1).as(:"#{func_name}_value") >> str("&") >> masked_recursive_value.as(:first_value)
        end

        def bracketed_masked_value(func_name)
          str("(") >> (masked_value(func_name).as(func_name)) >> str(")")
        end
      end
    end
  end
end
