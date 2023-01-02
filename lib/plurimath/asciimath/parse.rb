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
      rule(:number) { match("[0-9.]").repeat(1).as(:number) }

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
          (table.as(:table) >> expression.maybe)
      end

      rule(:quoted_text) do
        str('"') >> match("[^\"]").repeat.as(:text) >> str('"')
      end

      rule(:symbol_text_or_integer) do
        sub_sup_classes |
          binary_classes |
          hash_to_expression(Constants.precompile_constants) |
          (match(/[0-9]/).as(:number) >> comma.as(:comma)).repeat(1).as(:comma_separated) |
          quoted_text |
          match["a-zA-Z"].as(:symbol) |
          match(/[^\[{(\\\/@;:.,'"|\]})0-9a-zA-Z\-><$%^&*_=+!`~\s?]/).as(:symbol) |
          number
      end

      rule(:power_base) do
        (base >> space.maybe >> sequence.as(:base_value) >> power >> space.maybe >> sequence.as(:power_value)) |
          (space.maybe >> base >> space.maybe >> sequence.as(:base_value)).as(:base) |
          (space.maybe >> power >> space.maybe >> sequence.as(:power_value)).as(:power) |
          (space.maybe >> base >> space.maybe >> (power.as(:symbol)).as(:base_value)).as(:base) |
          (space.maybe >> power >> space.maybe >> (base.as(:symbol)).as(:power_value)).as(:power)
      end

      rule(:power_base_rules) do
        (sub_sup_classes >> power_base).as(:power_base) |
          (binary_classes >> space.maybe >> sequence.as(:base_value).maybe >> space.maybe >> sequence.as(:power_value).maybe).as(:power_base) |
          (sequence >> power_base).as(:power_base)
      end

      rule(:table) do
        (open_table.as(:table_left) >> tr >> close_table.as(:table_right)) |
          (str("left") >> left_right_open_paren.as(:left) >> tr >> str("right") >> left_right_close_paren.as(:right))
      end

      rule(:tr) do
        ((left_right_open_paren.as(:open_tr) >> td.as(:tds_list) >> left_right_close_paren).as(:table_row) >> comma >> tr.as(:expr)) |
          (left_right_open_paren.as(:open_tr) >> td.as(:tds_list) >> left_right_close_paren).as(:table_row)
      end

      rule(:color_value) do
        (color_left_parenthesis.capture(:paren).as(:lparen) >> read_text.as(:text).as(:color) >> color_right_parenthesis.maybe.as(:rparen)).as(:intermediate_exp) |
          expression |
          read_text.as(:text)
      end

      rule(:sequence) do
        (lparen.as(:lparen) >> expression.maybe.as(:expr) >> rparen.maybe.as(:rparen)).as(:intermediate_exp) |
          (str("text") >> lparen.capture(:paren).as(:lparen) >> read_text.as(:text) >> rparen.maybe.as(:rparen)).as(:intermediate_exp) |
          symbol_text_or_integer
      end

      rule(:iteration) do
        table.as(:table) |
          comma.as(:comma) |
          (sequence.as(:dividend) >> space.maybe >> str("mod").as(:mod) >> space.maybe >> iteration.as(:divisor)).as(:mod) |
          (sequence.as(:sequence) >> space.maybe >> str("//").as(:symbol)) |
          (sequence.as(:numerator) >> space.maybe >> str("/") >> space.maybe >> sequence.as(:denominator)).as(:frac) |
          (str("color").as(:binary_class) >> color_value.as(:base_value).maybe >> iteration.as(:power_value).maybe) |
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
        when :symbol
          first_value.as(:symbol)
        when :unary_class
          (first_value.as(:unary_class) >> space.maybe >> sequence.maybe).as(:unary)
        when :fonts
          first_value.as(:fonts_class) >> space.maybe >> sequence.as(:fonts_value)
        end
      end
    end
  end
end
