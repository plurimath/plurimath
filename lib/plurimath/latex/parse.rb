# frozen_string_literal: true

require "parslet"
module Plurimath
  class Latex
    class Parse < Parslet::Parser
      rule(:base)       { str("_") }
      rule(:power)      { str("^") }
      rule(:slash)      { str("\\") }
      rule(:under_over) { slash >> underover_classes }
      rule(:array_args) { (str("{") >> expression.as(:args) >> str("}")) }

      rule(:optional_args) do
        (str("[") >> intermediate_exp.maybe.as(:options) >> str("]")).maybe
      end

      rule(:begining) do
        (slash >> str("begin") >> (str("{") >> symbol_text_or_integer >> str("*").as(:asterisk).maybe >> str("}")) >> optional_args)
      end

      rule(:ending) do
        (slash >> str("end") >> (str("{") >> symbol_text_or_integer >> str("*").maybe >> str("}"))).as(:ending)
      end

      rule(:numeric_values) do
        arr_to_expression(Constants::NUMERIC_VALUES, :numeric_values)
      end

      rule(:underover_classes) do
        arr_to_expression(Constants::UNDEROVER_CLASSES, :binary)
      end

      rule(:math_operators_classes) do
        arr_to_expression(Constants::MATH_OPERATORS, :unary_functions)
      end

      rule(:lparen) do
        arr_to_expression(Constants::PARENTHESIS.keys, :lparen)
      end

      rule(:rparen) do
        arr_to_expression(Constants::PARENTHESIS.values, :rparen)
      end

      rule(:environment) do
        arr_to_expression(Constants::MATRICES.keys, :environment)
      end

      rule(:subscript) do
        intermediate_exp >> base >> intermediate_exp.as(:subscript)
      end

      rule(:supscript) do
        intermediate_exp >> power >> intermediate_exp.as(:supscript)
      end

      rule(:math_operators) do
        slash >> math_operators_classes >> str("\\limits")
      end

      rule(:sqrt_arg) do
        (str("[").as(:lparen) >> intermediate_exp.repeat(1).as(:expression) >> str("]").as(:rparen)) |
          (str("[").as(:lparen) >> str("]").as(:rparen))
      end

      rule(:limits) do
        (math_operators >> base >> intermediate_exp.as(:base) >> power >> intermediate_exp.as(:power)) |
          (math_operators >> power >> intermediate_exp.as(:power) >> base >> intermediate_exp.as(:base))
      end

      rule(:symbol_class_commands) do
        (str("&#x") >> match["0-9a-fA-F"].repeat >> str(";")).as(:unicode_symbols) |
          hash_to_expression(Constants::SYMBOLS) |
          under_over |
          environment |
          numeric_values
      end

      rule(:symbol_text_or_integer) do
        symbol_class_commands |
          match["a-zA-Z"].as(:symbols) |
          (str('"') >> match("[^\"]").repeat >> str('"')).as(:text) |
          match(/\d+(\.[0-9]+)|\d/).repeat(1).as(:number) |
          str("\\\\").as("\\\\") |
          (slash >> (lparen | rparen).as(:symbols)) |
          lparen |
          str("\\ ").as(:space)
      end

      rule(:intermediate_exp) do
        (str("{") >> expression.maybe.as(:expression) >> str("}")) |
          symbol_text_or_integer
      end

      rule(:power_base) do
        (subscript >> power >> intermediate_exp.as(:supscript)).as(:power_base) |
          (supscript >> base >> intermediate_exp.as(:subscript)).as(:power_base) |
          supscript.as(:power) |
          subscript.as(:base)
      end

      rule(:binary_functions) do
        (intermediate_exp.as(:first_value) >> under_over >> intermediate_exp.as(:second_value)).as(:under_over) |
          (slash >> str("sqrt").as(:root) >> sqrt_arg.as(:first_value) >> intermediate_exp.as(:second_value)).as(:binary) |
          (slash >> str("sqrt").as(:sqrt) >> intermediate_exp.as(:intermediate_exp)).as(:binary)
      end

      rule(:sequence) do
        limits.as(:limits) |
          (binary_functions.as(:binary_functions) >> power >> sequence.as(:supscript)).as(:power) |
          (binary_functions.as(:binary_functions) >> base >> sequence.as(:subscript)).as(:base) |
          binary_functions |
          (slash >> str("rule").as(:rule) >> sqrt_arg.maybe.as(:first_value) >> intermediate_exp.maybe.as(:second_value) >> intermediate_exp.maybe.as(:third_value)).as(:binary) |
          (over_class >> power >> intermediate_exp.as(:supscript)) |
          (over_class >> base >> intermediate_exp.as(:subscript)) |
          over_class |
          (left_right.as(:left_right) >> power >> intermediate_exp.as(:supscript)) |
          (left_right.as(:left_right) >> base >> intermediate_exp.as(:subscript)) |
          left_right.as(:left_right) |
          (slash >> str("substack").as(:substack) >> intermediate_exp) |
          (begining >> array_args >> expression.as(:table_data) >> ending).as(:environment) |
          (begining >> expression.as(:table_data) >> ending).as(:environment) |
          (slash >> environment >> intermediate_exp).as(:table_data) |
          power_base |
          (rparen >> (base >> sequence.as(:subscript)).maybe >> power >> sequence.as(:supscript)).as(:power_base) |
          (rparen >> (power >> sequence.as(:supscript)) >> base >> sequence.as(:subscript)).as(:power_base) |
          rparen |
          intermediate_exp
      end

      rule(:left_right) do
        (
         str("\\left").as(:left) >>
         lparen.maybe >>
         (
           (expression.repeat.as(:dividend) >> str("\\over") >> expression.repeat.as(:divisor)) |
           expression.as(:expression).maybe
         ) >>
         str("\\right").as(:right).maybe >>
         rparen.maybe
       )
      end

      rule(:over_class) do
        (
          (str("{") >> expression.repeat.as(:dividend) >> str("\\over") >> expression.repeat.as(:divisor) >> str("}")) |
          (left_right.as(:left_right).as(:power) >> power >> intermediate_exp) |
          (left_right.as(:left_right).as(:base) >> base >> intermediate_exp)
        ).as(:over)
      end

      rule(:overset) do
        (iteration.as(:dividend) >> str("\\over") >> iteration.as(:divisor))
      end

      rule(:iteration) do
        (sequence.as(:sequence) >> expression.as(:expression)) |
          sequence
      end

      rule(:expression) do
        (iteration >> expression) |
          iteration |
          (overset >> expression.repeat)
      end

      root :expression

      def arr_to_expression(array, name)
        @@new_hash ||= {}
        type = array.first.class
        @@new_hash[name] ||= array.reduce do |expression, expr_string|
          expression = str(expression).as(name) if expression.is_a?(type)
          expression | str(expr_string).as(name)
        end
      end

      def hash_to_expression(arr)
        type = arr.first.class
        @@expression ||= arr.reduce do |expression, expr_string|
          expression = dynamic_rules(expression) if expression.is_a?(type)
          expression | dynamic_rules(expr_string)
        end
      end

      def dynamic_rules(expr)
        first_value = str(expr.first.to_s)
        case expr.last
        when :operant
          (first_value.as(:operant) | (slashed_value(first_value, :symbols)))
        when :symbols
          slashed_value(first_value, :symbols)
        when :unary
          unary_rules(first_value)
        when :fonts
          ((slashed_value(first_value, :fonts)) >> (binary_functions | intermediate_exp).as(:intermediate_exp))
        when :power_base
          (slashed_value(first_value, :binary) >> base >> intermediate_exp.as(:subscript).maybe >> power >> intermediate_exp.as(:supscript).maybe).as(:power_base) |
            (slashed_value(first_value, :binary) >> power >> intermediate_exp.as(:supscript).maybe >> base >> intermediate_exp.as(:subscript).maybe).as(:power_base) |
            (slashed_value(first_value, :binary))
        when :binary
          (slashed_value(first_value, :binary) >> intermediate_exp.as(:first_value) >> intermediate_exp.as(:second_value)).as(:binary)
        end
      end

      def slashed_value(first_value, name = nil)
        (slash >> first_value.as(name))
      end

      def unary_rules(first_value)
        (slashed_value(first_value, :unary_functions) >> unary_power_base) |
          (slashed_value(first_value, :unary) >> intermediate_exp.as(:first_value)).as(:unary_functions) |
          (slashed_value(first_value, :unary))
      end

      def unary_power_base
        (base >> intermediate_exp.as(:subscript) >> power >> intermediate_exp.as(:supscript)) |
          (power >> intermediate_exp.as(:supscript) >> base >> intermediate_exp.as(:subscript)) |
          (power >> intermediate_exp.as(:supscript)) |
          (base >> intermediate_exp.as(:subscript))
      end
    end
  end
end
