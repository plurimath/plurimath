# frozen_string_literal: true

require "parslet"
module Plurimath
  class Asciimath
    class Parse < Parslet::Parser
      rule(:base) { str("_").as(:_) }
      rule(:power) { str("^").as(:^) }
      rule(:lparen) { arr_to_expression(Constants::LPAREN) }
      rule(:rparen) { arr_to_expression(Constants::RPAREN) }
      rule(:symbols) { arr_to_expression(Constants::SYMBOLS) }
      rule(:unary_functions) { arr_to_expression(Constants::UNARY_CLASSES) }
      rule(:binary_functions) { arr_to_expression(Constants::BINARY_CLASSES) }
      rule(:quoted_text) do
        str('"') >> match("[a-zA-Z0-9 ]").repeat.as(:text) >> str('"')
      end
      rule(:expression) do
        (iteration >> expression).as(:expr) |
          (iteration >> str("/").as(:/) >> iteration).as(:expr) |
          str("")
      end
      rule(:symbol_text_or_integer) do
        symbols | binary_functions | unary_functions |
          match["a-zA-Z"].as(:symbol) |
          match("[0-9]").repeat(1).as(:number) |
          quoted_text
      end
      rule(:sequance) do
        (lparen >> expression >> rparen).as(:intermediate_exp) |
          (binary_functions >> sequance.as(:base) >>
            sequance.maybe.as(:exponent)).as(:binary) |
          (unary_functions >> sequance).as(:unary) |
          symbol_text_or_integer
      end
      rule(:iteration) do
        (sequance.as(:dividend) >> str("mod").as(:mod) >>
          sequance.as(:divisor)).as(:mod) |
          (sequance >> base >> sequance.as(:base) >>
            power >> sequance.as(:exponent)).as(:power_base) |
          (sequance >> base >> sequance).as(:base) |
          (sequance >> power >> sequance).as(:power) |
          sequance.as(:sequance) |
          str(" ")
      end
      rule(:conclude) { expression }
      root :conclude

      def arr_to_expression(arr)
        arr.reduce do |expr, exp_string|
          expr = str(expr).as(expr) if expr.is_a?(Symbol)
          expr.send(:|, str(exp_string).as(exp_string))
        end
      end
    end
  end
end
