# frozen_string_literal: true

require "parslet"
module Plurimath
  class Latex
    class Parse < Parslet::Parser
      rule(:base)           { str("_") }
      rule(:power)          { str("^") }
      rule(:slash)          { str("\\") }
      rule(:array_args)     { str("{") >> expression >> str("}") }
      rule(:ending)         { slash >> str("end") >> intermediate_exp }
      rule(:begining)       { slash >> str("begin") >> intermediate_exp }
      rule(:lparen)         { arr_to_expression(Constants::PARENTHESIS.keys, :lparen) }
      rule(:rparen)         { arr_to_expression(Constants::PARENTHESIS.values, :rparen) }
      rule(:subscript)      { intermediate_exp >> base >> intermediate_exp.as(:subscript) }
      rule(:supscript)      { intermediate_exp >> power >> intermediate_exp.as(:supscript) }
      rule(:unary)          { slash >> arr_to_expression(Constants::UNARY_CLASSES, :unary) }
      rule(:environment)    { arr_to_expression(Constants::MATRICES.keys, :environment) }
      rule(:binary)         { slash >> arr_to_expression(Constants::BINARY_CLASSES, :binary) }
      rule(:under_over)     { slash >> arr_to_expression(Constants::UNDEROVER_CLASSES, :binary) }
      rule(:math_operators) { slash >> arr_to_expression(Constants::MATH_OPERATORS, :unary_functions) >> str("\\limits") }
      rule(:left_right)     { str("\\left").as(:left) >> lparen >> expression.as(:expression) >> str("\\right").as(:right) >> rparen }

      rule(:limits) do
        math_operators >> base >> intermediate_exp.as(:base) >> power >> intermediate_exp.as(:power) |
          math_operators >> power >> intermediate_exp.as(:power) >> base >> intermediate_exp.as(:base)
      end

      rule(:symbol_class_commands) do
        (slash >> arr_to_expression(Constants::SYMBOLS.keys, :symbols)) |
          (unary >> intermediate_exp.as(:first_value)).as(:unary_functions) |
          unary.as(:unary_functions) |
          binary |
          under_over |
          environment |
          arr_to_expression(Constants::OPERATORS, :operant) |
          arr_to_expression(Constants::NUMERIC_VALUES, :numeric_values) |
          (slash >> arr_to_expression(Constants::POWER_BASE_CLASSES, :binary)) |
          (slash >> arr_to_expression(Constants::FONT_STYLES, :fonts) >> (binary_functions | intermediate_exp).as(:intermediate_exp))
      end

      rule(:symbol_text_or_integer) do
        symbol_class_commands |
          match["a-zA-Z"].repeat(1).as(:text) |
          (str('"') >> match("[^\"]").repeat >> str('"')).as(:text) |
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
        limits.as(:limits) |
          left_right.as(:left_right) >> power >> intermediate_exp.as(:supscript) |
          left_right.as(:left_right) >> base >> intermediate_exp.as(:subscript) |
          left_right.as(:left_right) |
          over_class.as(:over) >> power >> intermediate_exp.as(:supscript) |
          over_class.as(:over) >> base >> intermediate_exp.as(:subscript) |
          over_class.as(:over) |
          (slash >> str("mbox") >> lparen.capture(:paren) >> read_text >> rparen).as(:unary_functions) |
          (slash >> str("substack").as(:substack) >> lparen >> expression.as(:substack_value) >> rparen) |
          (begining.as(:begining) >> array_args.as(:args) >> expression.as(:table_data) >> ending.as(:ending)).as(:environment) |
          (begining.as(:begining) >> expression.as(:table_data) >> ending.as(:ending)).as(:environment) |
          (slash >> environment >> intermediate_exp).as(:table_data) |
          power_base |
          binary_functions |
          intermediate_exp
      end

      rule(:left_right_over) do
        str("\\left").as(:left) >> lparen >> expression.repeat.as(:dividend) >> str("\\over") >> expression.repeat.as(:divisor) >> str("\\right").as(:right) >> rparen
      end

      rule(:over_class) do
        str("{") >> expression.repeat.as(:dividend) >> str("\\over") >> expression.repeat.as(:divisor) >> str("}") |
          (left_right_over.as(:left_right).as(:power) >> power >> intermediate_exp) |
          (left_right_over.as(:left_right).as(:base) >> base >> intermediate_exp) |
          left_right_over.as(:left_right)
      end

      rule(:iteration) { (sequence.as(:sequence) >> expression.as(:expression)) | sequence }

      rule(:expression) { (iteration >> expression) | iteration }

      root :expression

      def arr_to_expression(array, name = nil)
        type = array.first.class
        array.reduce do |expression, expr_string|
          expression = str(expression).as(name || expression.to_sym) if expression.is_a?(type)
          expression | str(expr_string).as(name || expr_string.to_sym)
        end
      end

      def read_text
        dynamic do |_sour, context|
          rparen = Constants::PARENTHESIS[context.captures[:paren][:lparen].to_s]
          match("[^#{rparen}]").repeat.as(:mbox)
        end
      end
    end
  end
end
