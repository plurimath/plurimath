# frozen_string_literal: true

require "parslet"
module Plurimath
  class Asciimath
    class Parse < Parslet::Parser
      rule(:td)     { expression.as(:td) }
      rule(:base)   { str("__|").absent? >> str("_") }
      rule(:power)  { str("^") }
      rule(:space)  { match(/\s+/) }
      rule(:comma)  { (str(",") >> space?) }
      rule(:space?) { space.maybe }
      rule(:number) do
        (match("[0-9]").repeat(1) >> str(".") >> match("[0-9]").repeat(1)).as(:number) |
          match("[0-9]").repeat(1).as(:number) |
          str(".").as(:symbol)
      end

      rule(:controversial_symbols)   { power_base | expression }
      rule(:left_right_open_paren)   { str("(") | str("[") }
      rule(:left_right_close_paren)  { str(")") | str("]") }
      rule(:color_left_parenthesis)  { str("(") | str("[") | str("{") }
      rule(:color_right_parenthesis) { str(")") | str("]") | str("}") }

      rule(:ternary_classes_rules) do
        (str("left") >> space? >> left_right_open_paren.as(:left) >> space? >> (ternary_classes >> power_base >> space? >> iteration.as(:third_value).maybe).as(:ternary) >> space? >> str("right") >> space? >> left_right_close_paren.as(:right)) |
          (ternary_classes >> power_base >> space? >> iteration.as(:third_value).maybe).as(:ternary) |
          ternary_classes
      end

      rule(:ternary_classes) do
        arr_to_expression(Constants::TERNARY_CLASSES, :ternary_class)
      end

      rule(:binary_classes) do
        arr_to_expression(Constants::BINARY_CLASSES, :binary_class)
      end

      rule(:sub_sup_classes) do
        arr_to_expression(Constants::SUB_SUP_CLASSES, :binary_class)
      end

      rule(:open_table) do
        arr_to_expression(Constants::TABLE_PARENTHESIS.keys, :table_left)
      end

      rule(:close_table) do
        arr_to_expression(Constants::TABLE_PARENTHESIS.values, :table_right)
      end

      rule(:lparen) do
        Constants::PARENTHESIS.keys.reduce do |expression, parenthesis|
          expression = str(expression) if expression.is_a?(Symbol)
          expression | str(parenthesis)
        end
      end

      rule(:rparen) do
        Constants::PARENTHESIS.values.reduce do |expression, parenthesis|
          expression = str(expression) if expression.is_a?(String)
          expression | str(parenthesis)
        end
      end

      rule(:left_right) do
        (str("left") >> space? >> left_right_open_paren.as(:left) >> space? >> (iteration.maybe >> sequence.maybe).as(:left_right_value) >> space? >> str("right") >> space? >> left_right_close_paren.as(:right)) |
          ((table.as(:numerator) >> space? >> match(/(?<!\/)\/(?!\/)/) >> space? >> iteration.as(:denominator)).as(:frac) >> expression) |
          (table.as(:table) >> power_base.maybe >> expression.maybe)
      end

      rule(:quoted_text) do
        (str('"') >> str("unitsml(") >> (str(')"').absent? >> any).repeat.as(:unitsml) >> str(')"')) |
          (str('"') >> match("[^\"]").repeat.as(:text) >> str('"')) |
          (str('"') >> str("").as(:text))
      end

      rule(:symbol_text_or_integer) do
        sub_sup_classes |
          binary_classes |
          ternary_classes |
          hash_to_expression(Constants.precompile_constants) |
          (match(/[0-9]/).as(:number) >> str(",").as(:comma)).repeat(1).as(:comma_separated) |
          quoted_text |
          (str("d").as(:d) >> str("x").as(:x)).as(:intermediate_exp) |
          ((str("left").absent? >> str("right").absent?) >> match["a-zA-Z"].as(:symbol)) |
          match(/[^\[{(\\\/@;:.,'"|\]})0-9a-zA-Z\-><$%^&*_=+!`~\s?ℒℛᑕᑐ]/).as(:symbol) |
          number
      end

      rule(:power_base) do
        (base >> space? >> sequence.as(:base_value) >> power >> (power >> power.maybe).absent? >> space? >> sequence.as(:power_value)) |
          (space? >> base >> space? >> sequence.as(:base_value)).as(:base) |
          (space? >> power >> (power >> power.maybe).absent? >> space? >> sequence.as(:power_value)).as(:power) |
          (space? >> base >> space? >> power.as(:symbol).as(:base_value)).as(:base) |
          (space? >> power >> (power >> power.maybe).absent? >> space? >> base.as(:symbol).as(:power_value)).as(:power)
      end

      rule(:power_base_rules) do
        (sub_sup_classes >> power_base).as(:power_base) |
          (binary_classes >> space? >> sequence.as(:base_value).maybe >> space? >> sequence.as(:power_value).maybe).as(:power_base) |
          (sequence.as(:power_base) >> power_base).as(:power_base)
      end

      rule(:table) do
        (str("{").as(:table_left) >> space? >> tr >> space? >> close_table.as(:table_right)) |
          (open_table.as(:table_left) >> space? >> tr >> space? >> close_table.as(:table_right)) |
          (str("norm").as(:norm) >> open_table.as(:table_left) >> space? >> tr >> space? >> close_table.as(:table_right)) |
          (str("|").as(:table_left) >> space? >> tr >> space? >> str("|").as(:table_right)) |
          (str("left") >> space? >> left_right_open_paren.as(:left) >> space? >> tr >> space? >> str("right") >> space? >> left_right_close_paren.as(:right))
      end

      rule(:tr) do
        ((left_right_open_paren.as(:open_tr) >> td.as(:tds_list) >> left_right_close_paren).as(:table_row) >> space? >> comma >> space? >> tr.as(:expr)) |
          (left_right_open_paren.as(:open_tr) >> td.as(:tds_list) >> left_right_close_paren).as(:table_row)
      end

      rule(:color_value) do
        (color_left_parenthesis.capture(:paren).as(:lparen) >> expression.as(:rgb_color) >> color_right_parenthesis.maybe.as(:rparen)).as(:intermediate_exp) |
          iteration
      end

      rule(:sequence) do
        (lparen.as(:lparen) >> space? >> expression.maybe.as(:expr) >> space? >> rparen.maybe.as(:rparen)).as(:intermediate_exp) |
          (str("text") >> lparen.capture(:paren) >> read_text.as(:text) >> rparen.maybe).as(:intermediate_exp) |
          symbol_text_or_integer
      end

      rule(:frac) do
        (sequence.as(:numerator) >> space? >> match(/(?<!\/)\/(?!\/)/) >> space? >> iteration.as(:denominator)).as(:frac) |
          ((power_base_rules | power_base).as(:numerator) >> space? >> match(/(?<!\/)\/(?!\/)/) >> space? >> iteration.as(:denominator)).as(:frac)
      end

      rule(:mod) do
        (sequence.as(:dividend) >> space? >> str("mod").as(:mod) >> space? >> iteration.as(:divisor)).as(:mod) |
          ((power_base_rules >> power_base).as(:dividend) >> space? >> str("mod").as(:mod) >> space? >> iteration.as(:divisor)).as(:mod) |
          (power_base_rules.as(:dividend) >> space? >> str("mod").as(:mod) >> space? >> iteration.as(:divisor)).as(:mod)
      end

      rule(:iteration) do
        ternary_classes_rules |
          table.as(:table) >> power_base.maybe |
          comma.as(:comma) |
          mod |
          (sequence.as(:sequence) >> space? >> str("//").as(:symbol)) |
          (str("color") >> color_value.as(:color) >> sequence.as(:color_value)) |
          frac |
          (power_base_rules >> power_base) |
          power_base_rules |
          sequence.as(:sequence) |
          space
      end

      rule(:expression) do
        left_right.as(:left_right) |
          (iteration >> space? >> expression).as(:expr) |
          (base.as(:symbol) >> expression.maybe).as(:expr) |
          (power.as(:symbol) >> expression.maybe).as(:expr) |
          str("") |
          (rparen.as(:rparen) >> space? >> controversial_symbols >> comma.as(:comma).maybe >> expression).repeat(1).as(:expr) |
          (power.as(:symbol) >> space? >> expression).as(:expr) |
          table.as(:table) >> space? >> rparen.as(:rparen) >> space? >> expression.as(:expr).maybe |
          comma.as(:comma).maybe
      end

      root :expression

      def arr_to_expression(arr, name = nil)
        type = arr.first.class
        arr.reduce do |expression, expr_string|
          expression = str(expression).as(name) if expression.is_a?(type)
          expression | str(expr_string).as(name)
        end
      end

      def read_text
        dynamic do |_sour, context|
          rparen = Constants::PARENTHESIS[context.captures[:paren].to_sym]
          match("[^#{rparen}]").repeat
        end
      end

      def hash_to_expression(arr)
        type = arr.first.class
        @@expression ||= arr.reduce do |expression, expr_string|
          expression = dynamic_parser_rules(expression) if expression.is_a?(type)
          expression | dynamic_parser_rules(expr_string)
        end
      end

      def dynamic_parser_rules(expr)
        first_value = str(expr.first.to_s)
        case expr.last
        when :symbol then (str("\\").as(:slash) >> match("\s").repeat >> str("\n")) | first_value.as(:symbol)
        when :unary_class then unary_functions(first_value)
        when :fonts then first_value.as(:fonts_class) >> space? >> sequence.as(:fonts_value)
        when :special_fonts then first_value.as(:bold_fonts)
        end
      end

      def unary_functions(first_value)
        if ["'underbrace'", "'ubrace'"].include?(first_value.to_s)
          (first_value.as(:unary_class) >> space? >> str("_").as(:symbol)).as(:unary) |
            (first_value.as(:unary_class) >> space? >> sequence.maybe).as(:unary)
        else
          (first_value.as(:unary_class).as(:power_base) >> space? >> power_base).as(:unary) |
            (first_value.as(:unary_class) >> space? >> sequence.maybe).as(:unary)
        end
      end
    end
  end
end
