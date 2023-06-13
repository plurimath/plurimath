# frozen_string_literal: true

require "parslet"
module Plurimath
  class Asciimath
    class Parse < Parslet::Parser
      rule(:td)     { expression.as(:td) }
      rule(:base)   { str("_") }
      rule(:power)  { str("^") }
      rule(:space)  { match(/\s+/) }
      rule(:comma)  { (str(",") >> space.maybe) }
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
        (str("left") >> left_right_open_paren.as(:left) >> iteration.as(:left_right_value) >> str("right") >> left_right_close_paren.as(:right)) |
          ((table.as(:numerator) >> space.maybe >> match(/(?<!\/)\/(?!\/)/) >> space.maybe >> iteration.as(:denominator)).as(:frac) >> expression) |
          (table.as(:table) >> expression.maybe)
      end

      rule(:quoted_text) do
        (str('"') >> match("[^\"]").repeat.as(:text) >> str('"')) |
          (str('"') >> str("").as(:text))
      end

      rule(:symbol_text_or_integer) do
        sub_sup_classes |
          binary_classes |
          hash_to_expression(Constants.precompile_constants) |
          (match(/[0-9]/).as(:number) >> comma.as(:comma)).repeat(1).as(:comma_separated) |
          quoted_text |
          (str("d").as(:d) >> str("x").as(:x)).as(:intermediate_exp) |
          match["a-zA-Z"].as(:symbol) |
          match(/[^\[{(\\\/@;:.,'"|\]})0-9a-zA-Z\-><$%^&*_=+!`~\s?ℒℛᑕᑐ]/).as(:symbol) |
          number
      end

      rule(:power_base) do
        (base >> space.maybe >> sequence.as(:base_value) >> power >> space.maybe >> sequence.as(:power_value)) |
          (space.maybe >> base >> space.maybe >> sequence.as(:base_value)).as(:base) |
          (space.maybe >> power >> space.maybe >> sequence.as(:power_value)).as(:power) |
          (space.maybe >> base >> space.maybe >> power.as(:symbol).as(:base_value)).as(:base) |
          (space.maybe >> power >> space.maybe >> base.as(:symbol).as(:power_value)).as(:power)
      end

      rule(:power_base_rules) do
        (sub_sup_classes >> power_base).as(:power_base) |
          (binary_classes >> space.maybe >> sequence.as(:base_value).maybe >> space.maybe >> sequence.as(:power_value).maybe).as(:power_base) |
          (sequence.as(:power_base) >> power_base).as(:power_base)
      end

      rule(:table) do
        (str("{").as(:table_left) >> space.maybe >> tr >> space.maybe >> close_table.as(:table_right)) |
          (open_table.as(:table_left) >> space.maybe >> tr >> space.maybe >> close_table.as(:table_right)) |
          (str("norm").as(:norm) >> open_table.as(:table_left) >> space.maybe >> tr >> space.maybe >> close_table.as(:table_right)) |
          (str("|").as(:table_left) >> space.maybe >> tr >> space.maybe >> str("|").as(:table_right)) |
          (str("left") >> left_right_open_paren.as(:left) >> space.maybe >> tr >> space.maybe >> str("right") >> left_right_close_paren.as(:right))
      end

      rule(:tr) do
        ((left_right_open_paren.as(:open_tr) >> td.as(:tds_list) >> left_right_close_paren).as(:table_row) >> comma >> space.maybe >> tr.as(:expr)) |
          (left_right_open_paren.as(:open_tr) >> td.as(:tds_list) >> left_right_close_paren).as(:table_row)
      end

      rule(:color_value) do
        (color_left_parenthesis.capture(:paren).as(:lparen) >> expression.as(:rgb_color) >> color_right_parenthesis.maybe.as(:rparen)).as(:intermediate_exp) |
          iteration
      end

      rule(:sequence) do
        (lparen.as(:lparen) >> space.maybe >> expression.maybe.as(:expr) >> space.maybe >> rparen.maybe.as(:rparen)).as(:intermediate_exp) |
          (str("text") >> lparen.capture(:paren) >> read_text.as(:text) >> rparen.maybe).as(:intermediate_exp) |
          symbol_text_or_integer
      end

      rule(:frac) do
        (sequence.as(:numerator) >> space.maybe >> match(/(?<!\/)\/(?!\/)/) >> space.maybe >> iteration.as(:denominator)).as(:frac) |
          ((power_base_rules | power_base).as(:numerator) >> match(/(?<!\/)\/(?!\/)/) >> iteration.as(:denominator)).as(:frac)
      end

      rule(:mod) do
        (sequence.as(:dividend) >> space.maybe >> str("mod").as(:mod) >> space.maybe >> iteration.as(:divisor)).as(:mod) |
          ((power_base_rules >> power_base).as(:dividend) >> space.maybe >> str("mod").as(:mod) >> space.maybe >> iteration.as(:divisor)).as(:mod) |
          (power_base_rules.as(:dividend) >> space.maybe >> str("mod").as(:mod) >> space.maybe >> iteration.as(:divisor)).as(:mod)
      end

      rule(:iteration) do
        table.as(:table) |
          comma.as(:comma) |
          mod |
          (sequence.as(:sequence) >> space.maybe >> str("//").as(:symbol)) |
          (str("color") >> color_value.as(:color) >> sequence.as(:color_value)) |
          frac |
          (power_base_rules >> power_base) |
          power_base_rules |
          sequence.as(:sequence) |
          space
      end

      rule(:expression) do
        left_right.as(:left_right) |
          (iteration >> space.maybe >> expression).as(:expr) |
          (base.as(:symbol) >> expression.maybe).as(:expr) |
          (power.as(:symbol) >> expression.maybe).as(:expr) |
          str("") |
          (rparen.as(:rparen) >> space.maybe >> controversial_symbols >> comma.as(:comma).maybe >> expression).repeat(1).as(:expr) |
          (power.as(:symbol) >> space.maybe >> expression).as(:expr) |
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
        when :symbol then first_value.as(:symbol)
        when :unary_class then (first_value.as(:unary_class) >> space.maybe >> sequence.maybe).as(:unary)
        when :fonts then first_value.as(:fonts_class) >> space.maybe >> sequence.as(:fonts_value)
        when :special_fonts then first_value.as(:bold_fonts)
        end
      end
    end
  end
end
