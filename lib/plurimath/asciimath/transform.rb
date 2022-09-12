# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Transform < Parslet::Transform
      rule(expr: simple(:expr))     { expr }
      rule(base: simple(:base))     { base }
      rule(base: sequence(:base))   { base }
      rule(fonts: simple(:fonts))   { fonts }
      rule(power: simple(:power))   { power }
      rule(unary: simple(:unary))   { unary }
      rule(table: simple(:table))   { table }
      rule(power: sequence(:power)) { power }
      rule(binary: simple(:binary)) { binary }

      rule(sequence: simple(:sequence))   { sequence }
      rule(table_row: simple(:table_row)) { table_row }

      rule(power_base: simple(:power_base)) { power_base }
      rule(left_right: simple(:left_right)) { left_right }
      rule(table_left: simple(:table_left)) { table_left }

      rule(table_right: simple(:table_right))  { table_right }
      rule(intermediate_exp: simple(:int_exp)) { int_exp }

      rule(mod: simple(:mod), expr: simple(:expr))    { [mod, expr] }
      rule(base: sequence(:base), expr: simple(:exp)) { base + [exp] }

      rule(number: simple(:number)) do
        Math::Number.new(number)
      end

      rule(symbol: simple(:symbol)) do
        Math::Symbol.new(symbol)
      end

      rule(text: simple(:text)) do
        text.is_a?(String) ? Utility.get_class("text").new(text) : text
      end

      rule(expr: sequence(:expr)) do
        Math::Formula.new(expr)
      end

      rule(sequence: simple(:sequence),
           expr: simple(:exp)) do
        [sequence, exp]
      end

      rule(power: simple(:power),
           expr: simple(:expr)) do
        [power, expr]
      end

      rule(power: simple(:power),
           expr: sequence(:expr)) do
        expr.insert(0, power)
      end

      rule(table_row: simple(:table_row),
           expr: simple(:expr)) do
        [table_row, expr]
      end

      rule(td: simple(:td),
           tds: simple(:tds)) do
        [
          Math::Function::Td.new([td]),
          Math::Function::Td.new([tds]),
        ]
      end

      rule(open_tr: simple(:tr),
           tds_list: sequence(:tds_list)) do
        Math::Function::Tr.new(tds_list)
      end

      rule(base: simple(:base),
           expr: simple(:expr)) do
        [base, expr]
      end

      rule(fonts: simple(:font_style),
           intermediate_exp: simple(:int_exp)) do
        Utility::FONT_STYLES[font_style.to_sym].new(
          int_exp,
          font_style,
        )
      end

      rule(fonts: simple(:font_style),
           text: simple(:text)) do
        Utility::FONT_STYLES[font_style.to_sym].new(
          Math::Function::Text.new(text),
          font_style,
        )
      end

      rule(power_base: simple(:power_base),
           expr: sequence(:expr)) do
        expr.insert(0, power_base)
      end

      rule(power_base: simple(:power_base),
           expr: simple(:expr)) do
        [power_base, expr]
      end

      rule(sequence: simple(:sequence),
           expr: sequence(:expr)) do
        expr.insert(0, sequence)
      end

      rule(dividend: simple(:dividend),
           mod: simple(:mod),
           divisor: simple(:divisor)) do
        Math::Function::Mod.new(
          dividend,
          divisor,
        )
      end

      rule(unary: simple(:unary),
           "^": simple(:exponent),
           number: simple(:number)) do
        Math::Function::Power.new(
          unary,
          Math::Number.new(number),
        )
      end

      rule(unary: simple(:unary),
           "^": simple(:exponent),
           intermediate_exp: simple(:intermediate_exp)) do
        Math::Function::Power.new(
          unary,
          intermediate_exp,
        )
      end

      rule(unary: simple(:unary),
           "^": simple(:exponent),
           text: simple(:text)) do
        Math::Function::Power.new(
          unary,
          text.is_a?(String) ? Utility.get_class("text").new(text) : text,
        )
      end

      rule(symbol: simple(:symbol),
           "^": simple(:exponent),
           number: simple(:number)) do
        Math::Function::Power.new(
          Math::Symbol.new(symbol),
          Math::Number.new(number),
        )
      end

      rule(binary: simple(:binary),
           "^": simple(:under_score),
           intermediate_exp: simple(:int_exp)) do
        Math::Function::Power.new(
          binary,
          int_exp,
        )
      end

      rule(binary: simple(:function),
           "^": simple(:exponent),
           number: simple(:number)) do
        Math::Function::Power.new(
          function,
          Math::Number.new(number),
        )
      end

      rule(left: simple(:left),
           left_right_value: simple(:left_right),
           right: simple(:right)) do
        Math::Formula.new(
          [
            Math::Function::Left.new(left),
            left_right,
            Math::Function::Right.new(right),
          ],
        )
      end

      Constants::UNARY_CLASSES.each do |unary_class|
        rule(unary_class => simple(:function),
             intermediate_exp: simple(:int_exp)) do
          Utility.get_class(function).new(int_exp)
        end

        rule(unary_class => simple(:function),
             _: simple(:under_score),
             intermediate_exp: simple(:int_exp)) do
          Math::Function::Base.new(
            Utility.get_class(function).new,
            int_exp,
          )
        end

        rule(unary_class => simple(:function),
             symbol: simple(:new_symbol)) do
          symbol = Math::Symbol.new(new_symbol)
          Utility.get_class(function).new(symbol)
        end

        rule(unary_class => simple(:function),
             number: simple(:new_number)) do
          number = Math::Number.new(new_number)
          Utility.get_class(function).new(number)
        end

        rule(unary_class => simple(:function),
             "^": simple(:base),
             intermediate_exp: simple(:unary)) do
          Math::Function::Power.new(
            Utility.get_class(unary_class).new,
            unary,
          )
        end

        rule(unary_class => simple(:function),
             _: simple(:base),
             symbol: simple(:symbol)) do
          Math::Function::Base.new(
            Utility.get_class(unary_class).new,
            Math::Symbol.new(symbol),
          )
        end

        rule(unary_class => simple(:function),
             _: simple(:under_score),
             base: simple(:base),
             "^": simple(:power),
             exponent: simple(:exponent)) do
          Math::Function::PowerBase.new(
            Utility.get_class(function).new,
            base,
            exponent,
          )
        end
      end

      Constants::BINARY_CLASSES.each do |binary_class|
        rule(binary_class => simple(:function)) do
          Utility.get_class(function).new
        end

        rule(binary_class => simple(:function),
             _: simple(:under_score),
             base: simple(:int_exp),
             "^": simple(:power),
             exponent: simple(:exponent)) do
          Utility.get_class(function).new(
            int_exp,
            exponent,
          )
        end

        rule(binary_class => simple(:function),
             _: simple(:under_score),
             intermediate_exp: simple(:int_exp)) do
          Utility.get_class(function).new(int_exp, nil)
        end

        rule(binary_class => simple(:function),
             "^": simple(:exponent),
             intermediate_exp: simple(:int_exp)) do
          Utility.get_class(function).new(nil, int_exp)
        end

        rule(binary_class => simple(:function),
             _: simple(:under_score),
             number: simple(:number)) do
          Utility.get_class(function).new(
            Math::Number.new(number), nil
          )
        end

        rule(binary_class => simple(:function),
             _: simple(:under_score),
             symbol: simple(:symbol)) do
          Utility.get_class(function).new(
            Math::Symbol.new(symbol), nil
          )
        end

        rule(binary_class => simple(:function),
             _: simple(:under_score),
             unary: simple(:unary)) do
          Utility.get_class(function).new(unary, nil)
        end

        rule(binary_class => simple(:function),
             "^": simple(:power),
             number: simple(:number)) do
          Utility.get_class(function).new(
            nil,
            Math::Number.new(number),
          )
        end

        rule(binary_class => simple(:function),
             "^": simple(:power),
             symbol: simple(:symbol)) do
          Utility.get_class(function).new(
            nil,
            Math::Symbol.new(symbol),
          )
        end

        rule(binary_class => simple(:function),
             base: simple(:base),
             exponent: simple(:exponent)) do
          Utility.get_class(function).new(
            base,
            exponent,
          )
        end

        rule(binary: simple(:function),
             "^": simple(:exponent),
             text: simple(:text)) do
          Math::Function::Power.new(
            function,
            text.is_a?(String) ? Utility.get_class("text").new(text) : text,
          )
        end

        rule(binary: simple(:function),
             "^": simple(:exponent),
             unary: simple(:unary)) do
          Math::Function::Power.new(
            function,
            unary,
          )
        end

        Constants::UNARY_CLASSES.each do |unary_class|
          rule(binary_class => simple(:function),
               _: simple(:base),
               unary_class => simple(:unary)) do
            unary_class = Utility.get_class(unary).new
            Utility.get_class(binary_class).new(unary_class, nil)
          end

          rule(binary_class => simple(:function),
               "^": simple(:base),
               unary_class => simple(:unary)) do
            unary_class = Utility.get_class(unary).new
            Utility.get_class(binary_class).new(nil, unary_class)
          end
        end
      end

      rule(table_left: simple(:table_left),
           table_row: simple(:table_row),
           expr: simple(:expr),
           table_right: simple(:table_right)) do
        Math::Function::Table.new(
          [table_row, expr],
          table_left,
          table_right,
        )
      end

      rule(table_left: simple(:table_left),
           table_row: simple(:table_row),
           expr: sequence(:expr),
           table_right: simple(:table_right)) do
        Math::Function::Table.new(
          expr.insert(0, table_row),
          table_left,
          table_right,
        )
      end

      rule(left: simple(:left),
           table_row: simple(:table_row),
           expr: sequence(:expr),
           right: simple(:right)) do
        Math::Formula.new(
          [
            Math::Function::Left.new(left),
            Math::Function::Table.new(expr.insert(0, table_row), "", ""),
            Math::Function::Right.new(right),
          ],
        )
      end
    end
  end
end
