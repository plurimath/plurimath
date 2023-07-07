# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Transform < Parslet::Transform
      rule(mod: simple(:mod))       { mod }
      rule(frac: simple(:frac))     { frac }
      rule(unary: simple(:unary))   { unary }
      rule(table: simple(:table))   { table }
      rule(comma: simple(:comma))   { Utility.symbol_object(comma) }
      rule(unary: sequence(:unary)) { Utility.filter_values(unary) }
      rule(rparen: simple(:rparen)) { Utility.symbol_object(rparen) }
      rule(number: simple(:number)) { Math::Number.new(number) }

      rule(ternary: simple(:ternary))       { ternary }
      rule(sequence: simple(:sequence))     { sequence }
      rule(table_row: simple(:table_row))   { table_row }
      rule(sequence: sequence(:sequence))   { sequence }
      rule(power_base: simple(:power_base)) { power_base }
      rule(left_right: simple(:left_right)) { left_right }
      rule(table_left: simple(:table_left)) { table_left }

      rule(left_right: sequence(:left_right))      { left_right }
      rule(power_base: sequence(:power_base))      { power_base }
      rule(table_right: simple(:table_right))      { table_right }
      rule(intermediate_exp: simple(:int_exp))     { int_exp }
      rule(power_value: sequence(:power_value))    { power_value }
      rule(mod: simple(:mod), expr: simple(:expr)) { [mod, expr] }

      rule(bold_fonts: simple(:font)) do
        Math::Function::FontStyle::DoubleStruck.new(
          Utility.symbol_object(font.to_s[0]),
          "mathbf",
        )
      end

      rule(unary_class: simple(:unary)) do
        Utility.get_class(unary).new
      end

      rule(binary_class: simple(:binary)) do
        Utility.get_class(binary).new
      end

      rule(ternary_class: simple(:ternary)) do
        Utility.get_class(ternary).new
      end

      rule(comma_separated: subtree(:comma_separated)) do
        comma_separated.flatten
      end

      rule(symbol: simple(:symbol)) do
        Utility.symbol_object(
          (Constants::SYMBOLS[symbol.to_sym] || symbol).to_s,
        )
      end

      rule(expr: subtree(:expr)) do
        case expr
        when Array
          expr.flatten.compact
        else
          expr
        end
      end

      rule(text: simple(:text)) do
        text.is_a?(Slice) ? Utility.get_class("text").new(text) : text
      end

      rule(text: sequence(:text)) do
        Utility.get_class("text").new(text.join)
      end

      rule(power_value: simple(:power_value)) do
        power_value
      end

      rule(base_value: simple(:base_value)) do
        base_value
      end

      rule(base_value: sequence(:base_value)) do
        Utility.filter_values(base_value)
      end

      rule(numerator: simple(:numerator),
           denominator: simple(:denominator)) do
        new_arr = []
        first_value = numerator.value.shift if Utility.frac_values(numerator)
        new_arr << first_value
        first_value = Utility.unfenced_value(numerator)
        second_value = denominator.value.pop if Utility.frac_values(denominator)
        new_arr << second_value
        second_value = Utility.unfenced_value(denominator)
        frac = Math::Function::Frac.new(
          first_value,
          second_value,
        )
        if new_arr.compact.empty?
          frac
        else
          Math::Formula.new(new_arr.insert(1, frac).compact)
        end
      end

      rule(numerator: simple(:numerator),
           denominator: sequence(:denominator)) do
        new_arr = []
        first_value = numerator.value.shift if Utility.frac_values(numerator)
        new_arr << first_value
        first_value = Utility.unfenced_value(numerator)
        second_value = denominator.pop if Utility.frac_values(denominator)
        new_arr << second_value
        second_value = Utility.unfenced_value(denominator)
        frac = Math::Function::Frac.new(
          first_value,
          second_value,
        )
        if new_arr.compact.empty?
          frac
        else
          Math::Formula.new(new_arr.insert(1, frac).compact)
        end
      end

      rule(sequence: simple(:sequence),
           left_right: simple(:left_right)) do
        new_arr = [sequence]
        new_arr << left_right unless left_right.to_s.strip.empty?
        new_arr
      end

      rule(sequence: simple(:sequence),
           number: simple(:number)) do
        [sequence, Math::Number.new(number.to_s)]
      end

      rule(table_row: simple(:table_row),
           expr: simple(:expr)) do
        new_arr = [table_row]
        new_arr << expr unless expr.to_s.strip.empty?
        new_arr
      end

      rule(table_row: simple(:table_row),
           expr: sequence(:expr)) do
        expr.flatten.compact.insert(0, table_row)
      end

      rule(comma: simple(:comma),
           expr: simple(:expr)) do
        new_arr = [Utility.symbol_object(comma)]
        new_arr << expr unless expr.to_s.strip.empty?
        new_arr
      end

      rule(comma: simple(:comma),
           expr: sequence(:expr)) do
        expr.flatten.compact.insert(0, Utility.symbol_object(comma))
      end

      rule(symbol: simple(:symbol),
           expr: sequence(:expr)) do
        expr.flatten.compact.insert(0, Utility.symbol_object(symbol))
      end

      rule(rparen: simple(:rparen),
           expr: simple(:expr)) do
        [
          Utility.symbol_object(rparen),
          expr,
        ]
      end

      rule(rparen: simple(:rparen),
           expr: sequence(:expr)) do
        expr.flatten.compact.insert(0, Utility.symbol_object(rparen))
      end

      rule(rparen: simple(:rparen),
           power: simple(:power)) do
        Math::Function::Power.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(power),
        )
      end

      rule(rparen: simple(:rparen),
           power: simple(:power),
           expr: simple(:expr)) do
        power_object = Math::Function::Power.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(power),
        )
        new_arr = [power_object]
        new_arr << expr unless expr.to_s.strip.empty?
        new_arr
      end

      rule(rparen: simple(:rparen),
           power: simple(:power),
           expr: sequence(:expr)) do
        power_object = Math::Function::Power.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(power),
        )
        new_arr = [power_object]
        new_arr += expr
        new_arr
      end

      rule(rparen: simple(:rparen),
           base: simple(:base)) do
        Math::Function::Base.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(base),
        )
      end

      rule(rparen: simple(:rparen),
           base: simple(:base),
           expr: simple(:expr)) do
        base_object = Math::Function::Base.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(base),
        )
        new_arr = [base_object]
        new_arr << expr unless expr.to_s.strip.empty?
        new_arr
      end

      rule(rparen: simple(:rparen),
           power: simple(:power),
           comma: simple(:comma)) do
        [
          Math::Function::Power.new(
            Utility.symbol_object(rparen),
            Utility.unfenced_value(power),
          ),
          Utility.symbol_object(comma),
        ]
      end

      rule(rparen: simple(:rparen),
           power: simple(:power),
           comma: simple(:comma),
           expr: simple(:expr)) do
        exponent = Math::Function::Power.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(power),
        )
        new_arr = [
          exponent,
          Utility.symbol_object(comma),
        ]
        new_arr << expr unless expr.to_s.strip.empty?
        new_arr
      end

      rule(rparen: simple(:rparen),
           power: simple(:power),
           comma: simple(:comma),
           expr: sequence(:expr)) do
        exponent = Math::Function::Power.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(power),
        )
        new_arr = [
          exponent,
          Utility.symbol_object(comma),
        ]
        new_arr += expr
        new_arr
      end

      rule(rparen: simple(:rparen),
           base: simple(:base),
           comma: simple(:comma)) do
        [
          Math::Function::Base.new(
            Utility.symbol_object(rparen),
            Utility.unfenced_value(base),
          ),
          Utility.symbol_object(comma),
        ]
      end

      rule(comma: simple(:comma),
           left_right: simple(:left_right)) do
        [
          Utility.symbol_object(comma),
          left_right,
        ]
      end

      rule(td: simple(:td)) do
        Math::Function::Td.new(
          [
            Utility.td_value(td),
          ],
        )
      end

      rule(td: sequence(:td)) do
        Utility.td_values(td, ",")
      end

      rule(open_tr: simple(:tr),
           tds_list: simple(:tds_list)) do
        Math::Function::Tr.new([tds_list])
      end

      rule(open_tr: simple(:tr),
           tds_list: sequence(:tds_list)) do
        Math::Function::Tr.new(tds_list)
      end

      rule(fonts_class: simple(:font_style),
           fonts_value: simple(:fonts_value)) do
        Utility::FONT_STYLES[font_style.to_sym].new(
          Utility.unfenced_value(fonts_value),
          font_style.to_s,
        )
      end

      rule(unary_class: simple(:function),
           fonts_class: simple(:font_style),
           fonts_value: simple(:fonts_value)) do
        font_object = Utility::FONT_STYLES[font_style.to_sym].new(
          Utility.unfenced_value(fonts_value),
          font_style.to_s,
        )
        first_value = if Utility::UNARY_CLASSES.include?(function)
                        font_object
                      else
                        Utility.unfenced_value(font_object)
                      end
        Utility.get_class(function).new(first_value)
      end

      rule(power_base: simple(:power_base),
           expr: subtree(:expr)) do
        expr.flatten.compact.insert(0, power_base)
      end

      rule(power_base: simple(:power_base),
           expr: simple(:expr)) do
        new_arr = [power_base]
        new_arr << expr unless expr.to_s.strip.empty?
        new_arr
      end

      rule(frac: simple(:frac),
           expr: subtree(:expr)) do
        case expr
        when Array
          expr.flatten.compact.insert(0, frac)
        else
          new_arr = [frac]
          new_arr << expr unless expr.to_s.strip.empty?
          new_arr
        end
      end

      rule(mod: simple(:mod),
           expr: sequence(:expr)) do
        expr.flatten.compact.insert(0, mod)
      end

      rule(frac: simple(:frac),
           left_right: simple(:left_right)) do
        new_arr = [frac]
        new_arr << left_right unless left_right.to_s.strip.empty?
        new_arr
      end

      rule(power_base: simple(:power_base),
           power: sequence(:power)) do
        first_value = power.shift if Utility.frac_values(power)
        power_object = Math::Function::Power.new(power_base, first_value)
        if power.empty?
          power_object
        else
          [power_object] + power
        end
      end

      rule(power_base: simple(:power_base),
           left_right: simple(:left_right)) do
        new_arr = [power_base]
        new_arr << left_right unless left_right.to_s.strip.empty?
        new_arr
      end

      rule(power_base: simple(:power_base),
           power: simple(:power)) do
        Math::Function::Power.new(
          power_base,
          Utility.unfenced_value(power),
        )
      end

      rule(power_base: simple(:power_base),
           power: simple(:power),
           expr: sequence(:expr)) do
        power_object = Math::Function::Power.new(
          power_base,
          Utility.unfenced_value(power),
        )
        Math::Formula.new(
          expr.flatten.compact.insert(0, power_object),
        )
      end

      rule(power_base: simple(:power_base),
           base: simple(:base)) do
        if base.is_a?(Math::Formula) && base.value.any? { |value| Utility.symbol_value(value, ",") }
          sliced = base.value.slice_before { |object| Utility.symbol_value(object, ",") }.to_a
          base_object = Math::Function::Base.new(
            power_base,
            Utility.filter_values(
              Utility.unfenced_value(sliced.shift),
            ),
          )
          [
            base_object,
            sliced.shift.first,
            Utility.filter_values(sliced),
          ].compact
        else
          Math::Function::Base.new(
            power_base,
            Utility.unfenced_value(base),
          )
        end
      end

      rule(power_base: simple(:power_base),
           base: simple(:base),
           expr: sequence(:expr)) do
        base_object = Math::Function::Base.new(
          power_base,
          Utility.unfenced_value(base),
        )
        Math::Formula.new(
          expr.flatten.compact.insert(0, base_object),
        )
      end

      rule(power_base: simple(:power_base),
           base: simple(:base),
           expr: simple(:expr)) do
        base_object = Math::Function::Base.new(
          power_base,
          Utility.unfenced_value(base),
        )
        formula_array = [base_object]
        formula_array << expr unless expr.to_s.strip.empty?

        Math::Formula.new(formula_array)
      end

      rule(power_base: simple(:power_base),
           base_value: simple(:base_value),
           power_value: simple(:power_value)) do
        Math::Function::PowerBase.new(
          power_base,
          Utility.unfenced_value(base_value),
          Utility.unfenced_value(power_value),
        )
      end

      rule(power_base: simple(:power_base),
           base_value: simple(:base_value),
           power_value: sequence(:power_value)) do
        first_value = power_value
        first_value = power_value.shift if Utility.frac_values(power_value)
        power_base_object = Math::Function::PowerBase.new(
          power_base,
          Utility.unfenced_value(base_value),
          Utility.filter_values(first_value),
        )
        power_value.insert(0, power_base_object)
      end

      rule(power_base: simple(:power_base),
           base_value: simple(:base_value),
           power_value: simple(:power_value),
           expr: sequence(:expr)) do
        power_base_object = Math::Function::PowerBase.new(
          power_base,
          Utility.unfenced_value(base_value),
          Utility.unfenced_value(power_value),
        )
        Math::Formula.new(
          expr.flatten.compact.insert(0, power_base_object),
        )
      end

      rule(rparen: simple(:rparen),
           base_value: simple(:base_value),
           power_value: simple(:power_value)) do
        Math::Function::PowerBase.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(base_value),
          Utility.unfenced_value(power_value),
        )
      end

      rule(rparen: simple(:rparen),
           base_value: simple(:base_value),
           power_value: simple(:power_value),
           expr: simple(:expr)) do
        power_base = Math::Function::PowerBase.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(base_value),
          Utility.unfenced_value(power_value),
        )
        new_arr = [power_base]
        new_arr << expr unless expr.to_s.strip.empty?
        new_arr
      end

      rule(rparen: simple(:rparen),
           base_value: sequence(:base_value),
           power_value: simple(:power_value),
           expr: simple(:expr)) do
        power_base = Math::Function::PowerBase.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(base_value),
          Utility.unfenced_value(power_value),
        )
        new_arr = [power_base]
        new_arr << expr unless expr.to_s.strip.empty?
        new_arr
      end

      rule(rparen: simple(:rparen),
           base_value: simple(:base_value),
           power_value: simple(:power_value),
           expr: sequence(:expr)) do
        power_base = Math::Function::PowerBase.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(base_value),
          Utility.unfenced_value(power_value),
        )
        expr.flatten.compact.insert(0, power_base)
      end

      rule(rparen: simple(:rparen),
           base_value: sequence(:base_value),
           power_value: simple(:power_value),
           expr: sequence(:expr)) do
        power_base = Math::Function::PowerBase.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(base_value),
          Utility.unfenced_value(power_value),
        )
        expr.flatten.compact.insert(0, power_base)
      end

      rule(rparen: simple(:rparen),
           base_value: sequence(:base_value),
           power_value: simple(:power_value),
           comma: simple(:comma),
           expr: sequence(:expr)) do
        coma = Utility.symbol_object(comma)
        power_base = Math::Function::PowerBase.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(base_value),
          Utility.unfenced_value(power_value),
        )
        new_arr = [power_base, coma]
        new_arr += expr.flatten.compact unless expr.to_s.strip.empty?
        new_arr
      end

      rule(rparen: simple(:rparen),
           base_value: simple(:base_value),
           power_value: simple(:power_value),
           comma: simple(:comma),
           expr: sequence(:expr)) do
        coma = Utility.symbol_object(comma)
        power_base = Math::Function::PowerBase.new(
          Utility.symbol_object(rparen),
          Utility.unfenced_value(base_value),
          Utility.unfenced_value(power_value),
        )
        new_arr = [power_base, coma]
        new_arr += expr.flatten.compact unless expr.to_s.strip.empty?
        new_arr
      end

      rule(power_base: sequence(:power_base),
           expr: simple(:expr)) do
        new_arr = power_base
        new_arr << expr unless expr.to_s.strip.empty?
        new_arr
      end

      rule(power_base: sequence(:power_base),
           expr: sequence(:expr)) do
        power_base + expr
      end

      rule(sequence: simple(:sequence),
           expr: subtree(:expr)) do
        case expr
        when Array
          expr.flatten.compact.insert(0, sequence)
        else
          new_array = [sequence]
          new_array << expr unless expr.to_s.strip.empty?
          new_array
        end
      end

      rule(sequence: sequence(:sequence),
           expr: simple(:expr)) do
        new_arr = sequence.flatten.compact
        new_arr << expr unless expr.to_s.strip.empty?
        new_arr
      end

      rule(sequence: sequence(:sequence),
           expr: sequence(:expr)) do
        sequence.flatten.compact + expr.flatten.compact
      end

      rule(binary_class: simple(:function),
           base_value: simple(:base)) do
        Utility.get_class(function).new(
          Utility.unfenced_value(base),
        )
      end

      rule(d: simple(:d),
           x: simple(:x)) do
        Math::Formula.new(
          [
            Utility.symbol_object(d),
            Utility.symbol_object(x),
          ],
        )
      end

      rule(binary_class: simple(:function),
           base: simple(:base)) do
        Utility.get_class(function).new(
          Utility.unfenced_value(base),
        )
      end

      rule(binary_class: simple(:function),
           power: simple(:power)) do
        Utility.get_class(function).new(
          nil,
          Utility.unfenced_value(power),
        )
      end

      rule(sequence: simple(:sequence),
           symbol: simple(:sym),
           expr: simple(:expr)) do
        symbol = Utility.symbol_object(
          (Constants::SYMBOLS[sym.to_sym] || sym).to_s,
        )
        [sequence, symbol, expr]
      end

      rule(sequence: simple(:sequence),
           symbol: simple(:sym),
           expr: sequence(:expr)) do
        symbol = Utility.symbol_object(
          (Constants::SYMBOLS[sym.to_sym] || sym).to_s,
        )
        new_arr = [sequence, symbol]
        new_arr += expr.flatten.compact unless expr.to_s.strip.empty?
        new_arr
      end

      rule(binary_class: simple(:function),
           base_value: simple(:base),
           power_value: simple(:power)) do
        Utility.get_class(function).new(
          Utility.unfenced_value(base),
          Utility.unfenced_value(power),
        )
      end

      rule(ternary_class: simple(:function),
           base_value: simple(:base),
           power_value: simple(:power)) do
        Utility.get_class(function).new(
          Utility.unfenced_value(base),
          Utility.unfenced_value(power),
        )
      end

      rule(ternary_class: simple(:function),
           base: simple(:base)) do
        Utility.get_class(function).new(
          Utility.unfenced_value(base),
        )
      end

      rule(ternary_class: simple(:function),
           base: simple(:base),
           third_value: simple(:third)) do
        third_value = third.is_a?(Slice) ? nil : third
        Utility.get_class(function).new(
          Utility.unfenced_value(base),
          nil,
          third_value,
        )
      end

      rule(ternary_class: simple(:function),
           power: simple(:power)) do
        Utility.get_class(function).new(
          nil,
          Utility.unfenced_value(power),
        )
      end

      rule(ternary_class: simple(:function),
           expr: simple(:expr)) do
        [
          Utility.get_class(function).new,
          expr,
        ]
      end

      rule(ternary_class: simple(:function),
           expr: sequence(:expr)) do
        expr.insert(0, Utility.get_class(function).new)
      end

      rule(ternary: simple(:ternary),
           expr: simple(:expr)) do
        [ternary, expr]
      end

      rule(ternary_class: simple(:function),
           power: simple(:power),
           third_value: simple(:third)) do
        third_value = third.is_a?(Slice) ? nil : third
        Utility.get_class(function).new(
          nil,
          Utility.unfenced_value(power),
          third_value,
        )
      end

      rule(ternary_class: simple(:function),
           base_value: simple(:base),
           power_value: simple(:power),
           third_value: simple(:third)) do
        third_value = third.is_a?(Slice) ? nil : third
        Utility.get_class(function).new(
          Utility.unfenced_value(base),
          Utility.unfenced_value(power),
          third_value,
        )
      end

      rule(unary_class: simple(:function),
           intermediate_exp: simple(:int_exp)) do
        first_value = if Utility::UNARY_CLASSES.include?(function)
                        int_exp
                      else
                        Utility.unfenced_value(int_exp)
                      end
        Utility.get_class(function).new(first_value)
      end

      rule(unary_class: simple(:function),
           symbol: simple(:symbol)) do
        symbol_object = Utility.symbol_object(
          (Constants::SYMBOLS[symbol.to_sym] || symbol).to_s,
        )
        Utility.get_class(function).new(symbol_object)
      end

      rule(unary_class: simple(:function),
           number: simple(:new_number)) do
        number = Math::Number.new(new_number)
        Utility.get_class(function).new(number)
      end

      rule(unary_class: simple(:function),
           unary: simple(:unary)) do
        first_value = if Utility::UNARY_CLASSES.include?(function)
                        unary
                      else
                        Utility.unfenced_value(unary)
                      end
        Utility.get_class(function).new(first_value)
      end

      rule(unary_class: simple(:function),
           binary_class: simple(:binary_class)) do
        [
          Utility.get_class(function).new,
          Utility.get_class(binary_class).new,
        ]
      end

      rule(unary_class: simple(:function),
           ternary_class: simple(:ternary_class)) do
        [
          Utility.get_class(function).new,
          Utility.get_class(ternary_class).new,
        ]
      end

      rule(ternary: simple(:ternary),
           expr: sequence(:expr)) do
        expr.insert(0, ternary)
      end

      rule(unary_class: simple(:function),
           text: simple(:text)) do
        Utility.get_class(function).new(
          Math::Function::Text.new(text),
        )
      end

      rule(number: simple(:number),
           comma: simple(:comma)) do
        [
          Math::Number.new(number),
          Utility.symbol_object(comma),
        ]
      end

      rule(table: simple(:table),
           expr: sequence(:expr)) do
        Math::Formula.new([table] + expr.flatten.compact)
      end

      rule(table: simple(:table),
           expr: simple(:expr)) do
        formula_array = [table]
        formula_array << expr unless expr.to_s.strip.empty?
        Math::Formula.new(formula_array)
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

      rule(left: simple(:left),
           left_right_value: sequence(:left_right),
           right: simple(:right)) do
        Math::Formula.new(
          [
            Math::Function::Left.new(left),
            Math::Formula.new(left_right),
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

      rule(lparen: simple(:lparen),
           expr: simple(:expr),
           rparen: simple(:rparen)) do
        form_value  = if expr.is_a?(Slice)
                        expr.to_s.empty? ? nil : [expr]
                      else
                        [expr]
                      end
        right_paren = rparen.to_s.empty? ? "" : rparen
        Math::Function::Fenced.new(
          Utility.symbol_object(lparen),
          form_value&.flatten&.compact,
          Utility.symbol_object(right_paren),
        )
      end

      rule(lparen: simple(:lparen),
           expr: sequence(:expr),
           rparen: simple(:rparen)) do
        right_paren = rparen.to_s.empty? ? "" : rparen
        Math::Function::Fenced.new(
          Utility.symbol_object(lparen),
          expr.flatten.compact,
          Utility.symbol_object(right_paren),
        )
      end

      rule(lparen: simple(:lparen),
           rgb_color: sequence(:color),
           rparen: simple(:rparen)) do
        Math::Formula.new(color)
      end

      rule(lparen: simple(:lparen),
           rgb_color: simple(:color),
           rparen: simple(:rparen)) do
        Math::Formula.new(color)
      end

      rule(color: sequence(:color),
           color_value: sequence(:color_value)) do
        Utility.symbol_object(color)
      end

      rule(color: simple(:color),
           color_value: simple(:value),
           expr: simple(:expr)) do
        color_object = Math::Function::Color.new(
          color,
          Utility.unfenced_value(value),
        )
        [color_object, expr]
      end

      rule(color: simple(:color),
           color_value: simple(:value),
           expr: sequence(:expr)) do
        color_object = Math::Function::Color.new(
          color,
          Utility.unfenced_value(value),
        )
        expr.insert(0, color_object)
      end

      rule(color: simple(:color),
           color_value: simple(:color_value)) do
        first_value = if color.is_a?(Math::Function::Text)
                        Utility.symbol_object(color.parameter_one)
                      else
                        color
                      end
        Math::Function::Color.new(
          first_value,
          Utility.unfenced_value(color_value),
        )
      end

      rule(table_left: simple(:table_left),
           table_row: simple(:table_row),
           table_right: simple(:table_right)) do
        Math::Function::Table.new(
          [
            table_row,
          ],
          Utility.symbol_object(table_left).value,
          Utility.symbol_object(table_right).value,
        )
      end

      rule(table_left: simple(:table_left),
           table_row: simple(:table_row),
           expr: simple(:expr),
           table_right: simple(:table_right)) do
        new_arr = [table_row]
        new_arr << expr unless expr.to_s.strip.empty?
        Math::Function::Table.new(
          new_arr,
          Utility.symbol_object(table_left).value,
          Utility.symbol_object(table_right).value,
        )
      end

      rule(norm: simple(:function),
           table_left: simple(:table_left),
           table_row: simple(:table_row),
           expr: simple(:expr),
           table_right: simple(:table_right)) do
        table = Math::Function::Table.new(
          [table_row, expr],
          Utility.symbol_object(table_left).value,
          Utility.symbol_object(table_right).value,
        )
        Math::Function::Norm.new(table)
      end

      rule(table_left: simple(:table_left),
           table_row: simple(:table_row),
           expr: sequence(:expr),
           table_right: simple(:table_right)) do
        Math::Function::Table.new(
          expr.flatten.compact.insert(0, table_row),
          Utility.symbol_object(table_left).value,
          Utility.symbol_object(table_right).value,
        )
      end

      rule(left: simple(:left),
           table_row: simple(:table_row),
           expr: sequence(:expr),
           right: simple(:right)) do
        Math::Function::Table.new(
          expr.flatten.compact.insert(0, table_row),
          Utility.symbol_object(left).value,
          Utility.symbol_object(right).value,
        )
      end
    end
  end
end
