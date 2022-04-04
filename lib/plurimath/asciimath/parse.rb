# frozen_string_literal: true

require "parslet"
module Plurimath
  class Asciimath
    class Parse < Parslet::Parser
      rule(:base)    { str("_").as(:_) }

      rule(:power)   { str("^").as(:^) }

      rule(:symbols) { arr_to_expression(Constants::SYMBOLS, :symbol) }

      rule(:unary_functions) { arr_to_expression(Constants::UNARY_CLASSES) }

      rule(:binary_functions) { arr_to_expression(Constants::BINARY_CLASSES) }

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

      rule(:sequence) do
        (lparen >> expression >> rparen).as(:intermediate_exp) |
        (binary_functions >> sequence.as(:base) >> sequence.maybe.as(:exponent)).as(:binary) |
        (str("text") >> lparen.capture(:paren) >> read_text >> rparen) |
        (unary_functions >> sequence).as(:unary) |
        symbol_text_or_integer
      end

      rule(:iteration) do
        (sequence.as(:dividend) >> str("mod").as(:mod) >> sequence.as(:divisor)).as(:mod) |
        (sequence >> base >> sequence.as(:base) >> power >> sequence.as(:exponent)).as(:power_base) |
        (sequence >> base >> sequence).as(:base) |
        (sequence >> power >> sequence).as(:power) |
        sequence.as(:sequence) |
        str(" ")
      end

      rule(:expression) do
        (iteration >> expression).as(:expr) |
        (iteration >> str("/").as(:/) >> iteration).as(:expr) |
        str("")
      end

      root :expression

      def arr_to_expression(arr, name = nil)
        arr.reduce do |expression, expr_string|
          expression = str(expression).as(expression) if expression.is_a?(Symbol)
          expression | str(expr_string).as(name || expr_string)
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
