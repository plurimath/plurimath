# frozen_string_literal: true

module Plurimath
  class Latex
    class Transform < Parslet::Transform
      rule(base: simple(:base))      { base }
      rule(text: simple(:text))      { Math::Function::Text.new(text.to_s) }
      rule(number: simple(:num))     { Math::Number.new(num.to_s) }
      rule(power: simple(:power))    { power }
      rule(symbols: simple(:sym))    { Math::Symbol.new(sym.to_s) }
      rule(operant: simple(:oper))   { Math::Symbol.new(oper.to_s) }
      rule(ending: simple(:ending))  { nil }
      rule(binary: simple(:binary))  { binary }
      rule("\\\\" => simple(:slash)) { Math::Symbol.new(slash.to_s) }

      rule(unary_functions: simple(:unary))    { unary }
      rule(under_over: simple(:under_over))    { under_over }
      rule(power_base: simple(:power_base))    { power_base }
      rule(table_data: simple(:table_data))    { table_data }
      rule(environment: simple(:environment))  { environment }
      rule(intermediate_exp: simple(:int_exp)) { int_exp }
      rule(lparen: simple(:lparen), rparen: simple(:rparen)) { nil }

      rule(left_right: simple(:left_right)) do
        Math::Function::Left.new(left_right)
      end

      rule(fonts: simple(:fonts), intermediate_exp: simple(:int_exp)) do
        Math::Function::FontStyle.new(int_exp, fonts.to_s)
      end

      rule(number: simple(:number), subscript: simple(:subscript)) do
        number_object = Math::Number.new(number.to_s)
        Math::Function::Base.new(number_object, subscript)
      end

      rule(symbols: simple(:symbol), subscript: simple(:subscript)) do
        symbol_object = Math::Symbol.new(symbol.to_s)
        Math::Function::Base.new(symbol_object, subscript)
      end

      rule(text: simple(:text), subscript: simple(:subscript)) do
        text_object = Math::Function::Text.new(text.to_s)
        Math::Function::Base.new(text_object, subscript)
      end

      rule(text: simple(:text), supscript: simple(:supscript)) do
        text_object = Math::Function::Text.new(text.to_s)
        Math::Function::Power.new(text_object, supscript)
      end

      rule(unary: simple(:unary), first_value: simple(:first_value)) do
        class_name = unary == "overline" ? "bar" : unary
        Transform.get_class(class_name).new(first_value)
      end

      rule(sqrt: simple(:sqrt), intermediate_exp: simple(:int_exp)) do
        Math::Function::Sqrt.new(int_exp)
      end

      rule(root: simple(:root),
           first_value: simple(:first_value),
           second_value: simple(:second_value)) do
        Math::Function::Root.new(first_value, second_value)
      end

      rule(sequence: simple(:sequence), expression: simple(:expr)) do
        [sequence, expr]
      end

      rule(sequence: simple(:sequence), expression: sequence(:expr)) do
        [sequence] + expr
      end

      rule(lparen: simple(:lparen),
           text: simple(:text),
           rparen: simple(:rparen)) do
        Math::Function::Text.new(text.to_s)
      end

      rule(lparen: simple(:lparen),
           symbols: simple(:symbol),
           rparen: simple(:rparen)) do
        Math::Symbol.new(symbol.to_s)
      end

      rule(lparen: simple(:lparen),
           sequence: simple(:sequence),
           expression: sequence(:expr),
           rparen: simple(:rparen)) do
        Math::Formula.new([sequence] + expr)
      end

      rule(lparen: simple(:lparen),
           sequence: simple(:sequence),
           expression: simple(:expr),
           rparen: simple(:rparen)) do
        Math::Formula.new([sequence, expr])
      end

      rule(lparen: simple(:lparen),
           expression: simple(:expr),
           rparen: simple(:rparen)) do
        if expr.is_a?(Slice) && Constants::ENVIRONMENTS.key?(expr.to_s)
          open_paren = Constants::ENVIRONMENTS[expr.to_s]
          close_paren = if Constants::PARENTHESIS[open_paren]
                          Constants::PARENTHESIS[open_paren]
                        elsif open_paren == "|"
                          "|"
                        end
          Math::Function::Table.new(
            nil,
            open_paren,
            close_paren,
          )
        else
          expr
        end
      end

      rule(lparen: simple(:lparen),
           expression: sequence(:expr),
           rparen: simple(:rparen)) do
        Math::Formula.new(expr)
      end

      rule(binary: simple(:binary),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        Transform.get_class(binary).new(subscript, supscript)
      end

      rule(binary: simple(:binary),
           subscript: simple(:subscript)) do
        Transform.get_class(binary).new(subscript)
      end

      rule(text: simple(:text),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        text_object = Math::Function::Text.new(text.to_s)
        Math::Function::PowerBase.new(text_object, subscript, supscript)
      end

      rule(binary: simple(:binary),
           first_value: simple(:first_value),
           second_value: simple(:second_value)) do
        if binary == "binom"
          Math::Function::Table.new(
            [Math::Function::Tr.new([first_value]),
             Math::Function::Tr.new([second_value])],
            "(",
            ")",
          )
        else
          binary_class = if ["pmod", "bmod"].include?(binary)
                           "mod"
                         elsif binary == "over"
                           "frac"
                         else
                           binary
                         end
          Transform.get_class(binary_class).new(first_value, second_value)
        end
      end

      rule(begining: simple(:begining),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        begining.parameter_one = Transform.organize_table(table_data)
        begining
      end

      rule(lparen: simple(:lparen),
           environment: simple(:env),
           rparen: simple(:rparen)) do
        env
      end

      rule(begining: simple(:begining),
           args: simple(:args),
           table_data: simple(:table_data),
           ending: simple(:ending)) do
        separator = Transform.separator(args)
        table_value = Transform.organize_table([table_data])
        begining.parameter_one = if separator
                                   Transform.inserting_at(table_value, args, 1)
                                 else
                                   table_value
                                 end
        begining
      end

      rule(begining: simple(:begining),
           args: sequence(:args),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        separator = args.find { |arg| Transform.separator(arg) }
        insert_at = args.index(separator)
        table_value = Transform.organize_table(table_data)
        begining.parameter_one = if separator
                                   Transform.inserting_at(table_value, separator, insert_at)
                                 else
                                   table_value
                                 end
        begining
      end

      rule(begining: simple(:begining),
           args: simple(:args),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        separator = Transform.separator(args)
        table_value = Transform.organize_table(table_data)
        begining.parameter_one = if separator
                                   Transform.inserting_at(table_value, args, 1)
                                 else
                                   table_value
                                 end
        begining
      end

      rule(environment: simple(:env),
           lparen: simple(:lparen),
           expression: sequence(:expr),
           rparen: simple(:rparen)) do
        table_value = Transform.organize_table(expr)
        left_paren = Constants::ENVIRONMENTS[env.to_s]
        Math::Function::Table.new(
          table_value,
          left_paren,
          Constants::PARENTHESIS[left_paren],
        )
      end

      rule(lparen: simple(:lparen),
           expression: sequence(:expr),
           rparen: simple(:rparen),
           supscript: simple(:supscript)) do
        formula = Math::Formula.new(expr)
        Math::Function::Power.new(formula, supscript)
      end

      class << self
        def organize_table(array, table = [], table_data = [], table_row = [])
          array.each do |data|
            if data.is_a?(Math::Symbol) && data.value == "&"
              table_row << Math::Function::Td.new(table_data)
              table_data = []
            elsif data.is_a?(Math::Symbol) && data.value == "\\\\"
              table_row << Math::Function::Td.new(table_data)
              table << Math::Function::Tr.new(table_row.flatten)
              table_row  = []
              table_data = []
            else
              table_data << data
            end
          end
          table_row << Math::Function::Td.new(table_data) if table_data
          table << Math::Function::Tr.new(table_row) unless table_row.empty?
          table
        end

        def inserting_at(table_array, separator, index)
          table_array.each do |tr|
            tr.parameter_one.insert(index, separator)
          end
        end

        def separator(arg)
          arg.is_a?(Math::Symbol) && arg.value == "|"
        end

        def get_class(text)
          Object.const_get("Plurimath::Math::Function::#{text.to_s.capitalize}")
        end
      end
    end
  end
end
