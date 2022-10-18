# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Transform < Parslet::Transform
      rule(expr: simple(:expr))   { expr }
      rule(unary: simple(:unary)) { unary }
      rule(table: simple(:table)) { table }

      rule(sequence: simple(:sequence))     { sequence }
      rule(table_row: simple(:table_row))   { table_row }
      rule(power_base: simple(:power_base)) { power_base }
      rule(left_right: simple(:left_right)) { left_right }
      rule(table_left: simple(:table_left)) { table_left }

      rule(table_right: simple(:table_right))      { table_right }
      rule(intermediate_exp: simple(:int_exp))     { int_exp }
      rule(mod: simple(:mod), expr: simple(:expr)) { [mod, expr] }

      rule(unary_class: simple(:unary)) do
        Utility.get_class(unary).new
      end

      rule(binary_class: simple(:binary)) do
        Utility.get_class(binary).new
      end

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

      rule(power_value: simple(:power_value)) do
        power_value
      end

      rule(base_value: simple(:base_value)) do
        base_value
      end

      rule(sequence: simple(:sequence),
           expr: simple(:exp)) do
        new_arr = []
        new_arr << sequence unless sequence.to_s.strip.empty?
        new_arr << exp unless exp.to_s.strip.empty?
        new_arr
      end

      rule(table_row: simple(:table_row),
           expr: simple(:expr)) do
        [table_row, expr]
      end

      rule(td: simple(:td),
           tds: simple(:tds)) do
        [
          Math::Function::Td.new([Utility.td_value(td)]),
          tds,
        ]
      end

      rule(td: simple(:td),
           tds: sequence(:tds)) do
        [
          Math::Function::Td.new([Utility.td_value(td)]),
        ] + tds
      end

      rule(td: simple(:td)) do
        Math::Function::Td.new([Utility.td_value(td)])
      end

      rule(open_tr: simple(:tr),
           tds_list: sequence(:tds_list)) do
        Math::Function::Tr.new(tds_list)
      end

      rule(open_tr: simple(:tr),
           tds_list: simple(:tds_list)) do
        Math::Function::Tr.new([tds_list])
      end

      rule(fonts_class: simple(:font_style),
           fonts_value: simple(:fonts_value)) do
        Utility::FONT_STYLES[font_style.to_sym].new(
          fonts_value,
          font_style,
        )
      end

      rule(power_base: simple(:power_base),
           expr: sequence(:expr)) do
        expr.insert(0, power_base)
      end

      rule(power_base: simple(:power_base),
           power: simple(:power)) do
        Math::Function::Power.new(
          power_base,
          power,
        )
      end

      rule(intermediate_exp: simple(:int_exp),
           power: simple(:power)) do
        Math::Function::Power.new(
          int_exp,
          power,
        )
      end

      rule(power_base: simple(:power_base),
           expr: simple(:expr)) do
        [power_base, expr]
      end

      rule(sequence: simple(:sequence),
           expr: sequence(:expr)) do
        expr.insert(0, sequence)
      end

      rule(unary: simple(:unary),
           power: simple(:power)) do
        Math::Function::Power.new(
          unary,
          power,
        )
      end

      rule(unary: simple(:unary),
           base: simple(:base)) do
        Math::Function::Base.new(
          unary,
          base,
        )
      end

      rule(binary_class: simple(:function),
           base_value: simple(:base)) do
        Utility.get_class(function).new(
          base,
        )
      end

      rule(symbol: simple(:symbol),
           power: simple(:power)) do
        Math::Function::Power.new(
          Math::Symbol.new(symbol),
          power,
        )
      end

      rule(symbol: simple(:symbol),
           base: simple(:base)) do
        Math::Function::Base.new(
          Math::Symbol.new(symbol),
          base,
        )
      end

      rule(binary_class: simple(:function),
           base: simple(:base)) do
        Utility.get_class(function).new(
          base,
        )
      end

      rule(binary_class: simple(:function),
           power: simple(:power)) do
        Utility.get_class(function).new(
          nil,
          power,
        )
      end

      rule(binary_class: simple(:function),
           base_value: simple(:base),
           power_value: simple(:power)) do
        Utility.get_class(function).new(
          base,
          power,
        )
      end

      rule(binary_class: simple(:function),
           base_value: simple(:base),
           power_value: simple(:power),
           expr: simple(:expr)) do
        [
          Utility.get_class(function).new(
            base,
            power,
          ),
          expr,
        ]
      end

      rule(unary_class: simple(:function),
           intermediate_exp: simple(:int_exp)) do
        Utility.get_class(function).new(int_exp)
      end

      rule(unary_class: simple(:function),
           symbol: simple(:new_symbol)) do
        symbol = Math::Symbol.new(new_symbol)
        Utility.get_class(function).new(symbol)
      end

      rule(unary_class: simple(:function),
           number: simple(:new_number)) do
        number = Math::Number.new(new_number)
        Utility.get_class(function).new(number)
      end

      rule(table: simple(:table),
           expr: sequence(:expr)) do
        Math::Formula.new([table] + expr)
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

      rule(dividend: simple(:dividend),
           mod: simple(:mod),
           divisor: simple(:divisor)) do
        Math::Function::Mod.new(
          dividend,
          divisor,
        )
      end

      rule(unary: simple(:unary),
           base_value: simple(:base),
           power_value: simple(:power)) do
        Math::Function::PowerBase.new(
          unary,
          base,
          power,
        )
      end

      rule(intermediate_exp: simple(:int_exp),
           base_value: simple(:base),
           power_value: simple(:power)) do
        Math::Function::PowerBase.new(
          int_exp,
          base,
          power,
        )
      end

      rule(symbol: simple(:symbol),
           base_value: simple(:base),
           power_value: simple(:power)) do
        Math::Function::PowerBase.new(
          Math::Symbol.new(symbol),
          base,
          power,
        )
      end

      rule(lparen: simple(:lparen),
           expr: simple(:expr),
           rparen: simple(:rparen)) do
        if expr.is_a?(Math::Formula)
          expr.wrapped = true
          expr
        else
          Math::Formula.new([expr], true)
        end
      end

      rule(table_left: simple(:table_left),
           table_row: simple(:table_row),
           table_right: simple(:table_right)) do
        Math::Function::Table.new(
          [
            table_row,
          ],
          table_left,
          table_right,
        )
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
