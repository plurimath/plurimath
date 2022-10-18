# frozen_string_literal: true

require "parslet"
module Plurimath
  class Asciimath
    class Parse < Parslet::Parser
      rule(:base)   { str("_") }
      rule(:space)  { str(" ") }
      rule(:power)  { str("^") }
      rule(:comma)  { (str(",") >> space) | str(",") }
      rule(:number) { match("[0-9.]").repeat(1).as(:number) }

      rule(:left_right_open_paren)  { str("(") | str("[") }
      rule(:left_right_close_paren) { str(")") | str("]") }
      rule(:color_left_parenthesis) { str("(") | str("[") | str("{") }
      rule(:color_right_parenthesis) { str(")") | str("]") | str("}") }

      rule(:symbols) do
        arr_to_expression(Constants::SYMBOLS.keys, :symbol)
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
        (str("left") >> left_right_open_paren.as(:left) >> iteration.as(:left_right_value) >> str("right") >> left_right_close_paren.as(:right)) |
          (table.as(:table) >> expression.maybe)
      end

      rule(:quoted_text) do
        str('"') >> match("[^\"]").repeat.as(:text) >> str('"')
      end

      rule(:symbol_text_or_integer) do
        sub_sup_classes |
          binary_classes |
          unary_binary_or_symbols |
          quoted_text |
          match["a-zA-Z"].as(:symbol) |
          number
      end

      rule(:power_base) do
        (base >> space.maybe >> sequence.as(:base_value) >> power >> space.maybe >> sequence.as(:power_value)) |
          (base >> space.maybe >> sequence.as(:base_value)).as(:base) |
          (power >> space.maybe >> sequence.as(:power_value)).as(:power)
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

      rule(:td) do
        (expression.as(:td) >> comma >> td.as(:tds)) |
          expression.as(:td)
      end

      rule(:color_value) do
        (color_left_parenthesis.capture(:paren) >> read_text.as(:text) >> color_right_parenthesis.maybe) |
          iteration |
          read_text.as(:text)
      end

      rule(:sequence) do
        (lparen.as(:lparen) >> expression.maybe.as(:expr) >> rparen.maybe.as(:rparen)).as(:intermediate_exp) |
          (str("text") >> lparen.capture(:paren) >> read_text.as(:text) >> rparen.maybe) |
          symbol_text_or_integer
      end

      rule(:iteration) do
        table.as(:table) |
          (sequence.as(:dividend) >> str("mod").as(:mod) >> sequence.as(:divisor)).as(:mod) |
          (str("color").as(:binary_class) >> color_value.as(:base_value).maybe >> iteration.as(:power_value).maybe) |
          (power_base_rules >> power_base) |
          power_base_rules |
          sequence.as(:sequence) |
          space
      end

      rule(:expression) do
        left_right.as(:left_right) |
          (iteration >> expression).as(:expr) |
          (iteration >> str("/").as(:/) >> iteration).as(:expr) |
          str("_").as(:symbol) |
          str("")
      end

      root :expression

      def arr_to_expression(arr, name = nil)
        type = arr.first.class
        arr.reduce do |expression, expr_string|
          as_value = if name.nil?
                       expr_string.is_a?(type) ? expr_string : expression
                     else
                       name
                     end
          expression = str(expression).as(as_value) if expression.is_a?(type)
          expression | str(expr_string).as(as_value)
        end
      end

      def read_text
        dynamic do |_sour, context|
          rparen = Constants::PARENTHESIS[context.captures[:paren].to_sym]
          match("[^#{rparen}]").repeat
        end
      end

      def unary_binary_or_symbols
        unsorted_hash = Constants::UNARY_CLASSES.each_with_object({}) { |d, i| i[d] = :unary_class }
        unsorted_hash = Constants::SYMBOLS.each_with_object(unsorted_hash) { |d, i| i[d.first] = :symbol }
        unsorted_hash = Constants::FONT_STYLES.each_with_object(unsorted_hash) { |d, i| i[d] = :fonts }
        sorted_hash   = unsorted_hash.sort_by { |v, _| -v.length }.to_h
        hash_to_expression(sorted_hash)
      end

      def hash_to_expression(arr)
        type = arr.first.class
        arr.reduce do |expression, expr_string|
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
        else
          first_value
        end
      end
    end
  end
end
