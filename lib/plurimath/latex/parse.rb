# frozen_string_literal: true

require "parslet"
module Plurimath
  class Latex
    class Parse < Parslet::Parser
      rule(:base)        { str("_") }
      rule(:power)       { str("^") }
      rule(:slash)       { str("\\") }
      rule(:array_args)  { str("{") >> expression >> str("}") }
      rule(:ending)      { slash >> str("end") >> intermediate_exp }
      rule(:begining)    { slash >> str("begin") >> intermediate_exp }
      rule(:lparen)      { arr_to_expression(Constants::PARENTHESIS.keys, :lparen) }
      rule(:environment) { arr_to_expression(Constants::ENVIRONMENTS.keys, :environment) }
      rule(:rparen)      { arr_to_expression(Constants::PARENTHESIS.values, :rparen) }
      rule(:subscript)   { intermediate_exp >> base >> intermediate_exp.as(:subscript) }
      rule(:supscript)   { intermediate_exp >> power >> intermediate_exp.as(:supscript) }
      rule(:binary)      { slash >> arr_to_expression(Constants::BINARY_CLASSES, :binary) }
      rule(:under_over)  { slash >> arr_to_expression(Constants::UNDEROVER_CLASSES, :binary) }
      rule(:left_right)  { str("\\left") >> lparen >> expression >> str("\\right") >> rparen }
      rule(:unary)       { slash >> arr_to_expression(Constants::UNARY_CLASSES, :unary) >> intermediate_exp.as(:first_value) }

      rule(:symbol_class_commands) do
        (slash >> arr_to_expression(Constants::SYMBOLS, :symbols)) |
          unary.as(:unary_functions) |
          binary |
          under_over |
          environment |
          (slash >> arr_to_expression(Constants::FONT_STYLES, :fonts) >> expression.as(:intermediate_exp)) |
          arr_to_expression(Constants::OPERATORS, :operant) |
          (slash >> arr_to_expression(Constants::POWER_BASE_CLASSES, :binary)) |
          arr_to_expression(Constants::NUMERIC_VALUES, :numeric_values)
      end

      rule(:symbol_text_or_integer) do
        symbol_class_commands |
          match["a-zA-Z"].repeat(1).as(:text) |
          match(/\d+(\.[0-9]+)|\d/).repeat(1).as(:number) |
          str("\\\\").as("\\\\")
      end

      rule(:intermediate_exp) do
        (lparen >> expression.as(:expression) >> rparen) |
          (lparen >> str("") >> rparen) |
          symbol_text_or_integer
      end

      rule(:power_base) do
        (subscript >> power >> intermediate_exp.as(:supscript)).as(:power_base) |
          (supscript >> base >> intermediate_exp.as(:subscript)).as(:power_base) |
          supscript.as(:power) |
          subscript.as(:base)
      end

      rule(:sqrt_arg) { str("[").as(:lparen) >> (expression | str("")) >> str("]").as(:rparen) }

      rule(:binary_functions) do
        (slash >> str("sqrt").as(:root) >> sqrt_arg.as(:first_value) >> intermediate_exp.as(:second_value)).as(:binary) |
          (slash >> str("sqrt").as(:sqrt) >> intermediate_exp.as(:intermediate_exp)).as(:binary) |
          (intermediate_exp.as(:first_value) >> under_over >> intermediate_exp.as(:second_value)).as(:under_over) |
          (binary >> intermediate_exp.as(:first_value) >> intermediate_exp.as(:second_value)).as(:binary)
      end

      rule(:sequence) do
        left_right.as(:left_right) |
          (slash >> str("mbox") >> lparen.capture(:paren) >> read_text >> rparen).as(:unary_functions) |
          (begining.as(:begining) >> array_args.as(:args) >> expression.as(:table_data) >> ending.as(:ending)).as(:environment) |
          (begining.as(:begining) >> expression.as(:table_data) >> ending.as(:ending)).as(:environment) |
          (slash >> environment >> intermediate_exp).as(:table_data) |
          power_base |
          binary_functions |
          intermediate_exp
      end

      rule(:iteration) { (sequence.as(:sequence) >> expression.as(:expression)) | sequence }

      rule(:expression) { (iteration >> expression) | iteration }

      root :expression

      def arr_to_expression(array, name = nil)
        array.reduce do |expression, expr_string|
          expression = str(expression).as(name || expression.to_sym) if expression.is_a?(String)
          expression | str(expr_string).as(name || expr_string.to_sym)
        end
      end

      def read_text
        dynamic do |_sour, context|
          rparen = Constants::PARENTHESIS[context.captures[:paren][:lparen].to_s]
          match("[^#{rparen}]").repeat.as(:text)
        end
      end
    end
  end
end
