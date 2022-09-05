# frozen_string_literal: true

require "parslet"
module Plurimath
  class Asciimath
    class Parse < Parslet::Parser
      rule(:space) { str(" ") }
      rule(:base)  { str("_").as(:_) }
      rule(:power) { str("^").as(:^) }
      rule(:comma) { (str(",") >> space) | str(",") }
      rule(:symbols) { arr_to_expression(Constants::SYMBOLS.values, :symbol) }
      rule(:font_style) { arr_to_expression(Constants::FONT_STYLES, :fonts) }
      rule(:unary_functions) { arr_to_expression(Constants::UNARY_CLASSES) }
      rule(:binary_functions) { arr_to_expression(Constants::BINARY_CLASSES) }

      rule(:left_right_open_paren) { str("(") | str("[") }

      rule(:left_right_close_paren) { str(")") | str("]") }

      rule(:left_right) do
        (str("left") >> left_right_open_paren.as(:left) >> iteration.as(:left_right_value) >> str("right") >> left_right_close_paren.as(:right)) |
          table
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

      rule(:quoted_text) do
        str('"') >> match("[^\"]").repeat.as(:text) >> str('"')
      end

      rule(:symbol_text_or_integer) do
        binary_functions |
          unary_functions |
          symbols |
          quoted_text |
          match["a-zA-Z"].as(:symbol) |
          match("[0-9]").repeat(1).as(:number)
      end

      rule(:table) do
        (open_table.as(:table_left) >> tr >> close_table.as(:table_right)) |
          (str("left") >> left_right_open_paren.as(:left) >> tr >> str("right") >> left_right_close_paren.as(:right))
      end

      rule(:tr) do
        ((str("[").as(:open_tr) >> td.as(:tds_list) >> str("]")).as(:table_row) >> comma >> tr.as(:expr)) |
          (str("[").as(:open_tr) >> td.as(:tds_list) >> str("]")).as(:table_row)
      end

      rule(:td) do
        (sequence.as(:td) >> str(",") >> sequence.as(:tds)) |
          sequence.as(:td)
      end

      rule(:sequence) do
        (lparen >> expression >> rparen).as(:intermediate_exp) |
          (binary_functions >> sequence.as(:base) >> sequence.maybe.as(:exponent)).as(:binary) |
          (str("text") >> lparen.capture(:paren) >> read_text >> rparen) |
          (unary_functions >> sequence).as(:unary) |
          (font_style >> sequence).as(:fonts) |
          symbol_text_or_integer
      end

      rule(:iteration) do
        table.as(:table) |
          (sequence.as(:dividend) >> str("mod").as(:mod) >> sequence.as(:divisor)).as(:mod) |
          (sequence >> base >> sequence.as(:base) >> power >> sequence.as(:exponent)).as(:power_base) |
          (sequence >> base >> sequence).as(:base) |
          (sequence >> power >> sequence).as(:power) |
          sequence.as(:sequence) |
          space
      end

      rule(:expression) do
        left_right.as(:left_right) |
          (iteration >> expression).as(:expr) |
          (iteration >> str("/").as(:/) >> iteration).as(:expr) |
          str("")
      end

      root :expression

      def arr_to_expression(arr, name = nil)
        type = arr.first.class
        arr.reduce do |expression, expr_string|
          as_value = name.nil? ? expr_string || expression : name
          expression = str(expression).as(as_value) if expression.is_a?(type)
          expression | str(expr_string).as(as_value)
        end
      end

      def read_text
        dynamic do |_sour, context|
          rparen = Constants::PARENTHESIS[context.captures[:paren].to_sym]
          match("[^#{rparen}]").repeat.as(:text)
        end
      end
    end
  end
end
