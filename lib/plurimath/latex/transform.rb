# frozen_string_literal: true

module Plurimath
  class Latex
    class Transform < Parslet::Transform
      rule(base: simple(:base))      { base }
      rule(over: simple(:over))      { over }
      rule(text: simple(:text))      { Math::Function::Text.new(text.to_s) }
      rule(number: simple(:num))     { Math::Number.new(num.to_s) }
      rule(power: simple(:power))    { power }
      rule(unary: simple(:unary))    { Transform.get_class(unary).new }
      rule(operant: simple(:oper))   { Math::Symbol.new(oper.to_s) }
      rule(limits: simple(:limits))  { limits }
      rule("\\\\" => simple(:slash)) {
        Math::Symbol.new(slash.to_s) }

      rule(unary_functions: simple(:unary))    { unary }
      rule(left_right: simple(:left_right))    { left_right }
      rule(under_over: simple(:under_over))    { under_over }
      rule(power_base: simple(:power_base))    { power_base }
      rule(table_data: simple(:table_data))    { table_data }
      rule(environment: simple(:environment))  { environment }

      rule(binary: simple(:binary)) do
        binary.is_a?(Slice) ? Math::Function::Text.new(binary.to_s) : binary
      end

      rule(symbols: simple(:sym)) do
        symbol = Constants::SYMBOLS[sym.to_sym] || sym
        Math::Symbol.new(symbol)
      end

      rule(lparen: simple(:lparen), rparen: simple(:rparen)) { Math::Formula.new }

      rule(left_right: simple(:left_right),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(left_right, subscript)
      end

      rule(left_right: simple(:left_right),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(left_right, supscript)
      end

      rule(left: simple(:left),
           lparen: simple(:lparen),
           expression: sequence(:expr),
           right: simple(:right),
           rparen: simple(:rparen)) do
        Math::Formula.new([
                            Plurimath::Math::Function::Left.new(lparen.to_s),
                            Math::Formula.new(expr),
                            Plurimath::Math::Function::Right.new(rparen.to_s),
                          ])
      end

      rule(left: simple(:left),
           lparen: simple(:lparen),
           expression: simple(:expr),
           right: simple(:right),
           rparen: simple(:rparen)) do
        Math::Formula.new([
                            Plurimath::Math::Function::Left.new(lparen.to_s),
                            expr,
                            Plurimath::Math::Function::Right.new(rparen.to_s),
                          ])
      end

      rule(power: simple(:power), number: simple(:number)) do
        Math::Function::Power.new(
          power,
          Math::Number.new(number.to_s),
        )
      end

      rule(left: simple(:left),
           lparen: simple(:lparen),
           dividend: subtree(:dividend),
           divisor: sequence(:divisor),
           right: simple(:right),
           rparen: simple(:rparen)) do
        Math::Formula.new([
                            Plurimath::Math::Function::Left.new(lparen.to_s),
                            Math::Function::Over.new(
                              Math::Formula.new(dividend.flatten),
                              Math::Formula.new(divisor.flatten),
                            ),
                            Plurimath::Math::Function::Right.new(rparen.to_s),
                          ])
      end

      rule(dividend: subtree(:dividend), divisor: subtree(:divisor)) do
        Math::Function::Over.new(
          Math::Formula.new(dividend.flatten),
          Math::Formula.new(divisor.flatten),
        )
      end

      rule(over: simple(:over), subscript: simple(:subscript)) do
        Math::Function::Base.new(over, subscript)
      end

      rule(over: simple(:over), supscript: simple(:supscript)) do
        Math::Function::Power.new(over, supscript)
      end

      rule(operant: simple(:operant), subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Math::Symbol.new(operant.to_s),
          subscript,
        )
      end

      rule(sequence: simple(:sequence), expression: simple(:expr)) do
        [sequence, expr]
      end

      rule(sequence: simple(:sequence), expression: sequence(:expr)) do
        [sequence] + expr
      end

      rule(unary_functions: simple(:unary), subscript: simple(:subscript)) do
        Math::Function::Base.new(unary, subscript)
      end

      rule(fonts: simple(:fonts), intermediate_exp: simple(:int_exp)) do
        Math::Function::FontStyle.new(int_exp, fonts.to_s)
      end

      rule(number: simple(:number), subscript: simple(:subscript)) do
        number_object = Math::Number.new(number.to_s)
        Math::Function::Base.new(number_object, subscript)
      end

      rule(symbols: simple(:sym), subscript: simple(:subscript)) do
        symbol = Constants::SYMBOLS[sym.to_sym] || sym
        symbol_object = Math::Symbol.new(symbol)
        Math::Function::Base.new(symbol_object, subscript)
      end

      rule(symbols: simple(:sym), supscript: simple(:supscript)) do
        symbol = Constants::SYMBOLS[sym.to_sym] || sym
        symbol_object = Math::Symbol.new(symbol)
        Math::Function::Power.new(symbol_object, supscript)
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

      rule(fonts: simple(:fonts),
           intermediate_exp: simple(:int_exp),
           supscript: simple(:supscript)) do
        font_style = Math::Function::FontStyle.new(int_exp, fonts.to_s)
        Math::Function::Power.new(font_style, supscript)
      end

      rule(root: simple(:root),
           first_value: simple(:first_value),
           second_value: simple(:second_value)) do
        Math::Function::Root.new(first_value, second_value)
      end

      rule(unary_functions: simple(:unary),
           base: simple(:base),
           power: simple(:power)) do
        Plurimath::Math::Function::Limits.new(
          Transform.get_class(unary).new,
          base,
          power,
        )
      end

      rule(lparen: simple(:lparen),
           mbox: simple(:mbox),
           rparen: simple(:rparen)) do
        Math::Function::Text.new("\\mbox{#{mbox}}")
      end

      rule(lparen: simple(:lparen),
           symbols: simple(:sym),
           rparen: simple(:rparen)) do
        symbol = Constants::SYMBOLS[sym.to_sym] || sym
        Math::Symbol.new(symbol)
      end

      rule(lparen: simple(:lparen),
           expression: simple(:expr),
           rparen: simple(:rparen)) do
        matrices = Constants::MATRICES
        if expr.is_a?(Slice) && matrices.key?(expr.to_sym)
          table = Transform.get_table_class(expr.to_s).new(nil)
          table.parameter_two = matrices[expr.to_sym]
          if %w[Bmatrix Vmatrix].include?(expr)
            table.parameter_three = Constants::PARENTHESIS[table.parameter_two]
          end
          table
        else
          expr
        end
      end

      rule(lparen: simple(:lparen),
           expression: sequence(:expr),
           rparen: simple(:rparen)) do
        Math::Formula.new(expr)
      end

      rule(lparen: simple(:lparen),
           expression: simple(:expr),
           rparen: simple(:rparen),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(Math::Formula.new(expr), supscript)
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

      rule(symbols: simple(:sym),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        symbol = Constants::SYMBOLS[sym.to_sym] || sym
        symbols_object = Math::Symbol.new(symbol.to_s)
        Math::Function::PowerBase.new(
                                       symbols_object,
                                       subscript,
                                       supscript
                                     )
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
          binary_class = %w[pmod bmod].include?(binary) ? "mod" : binary
          Transform.get_class(binary_class).new(first_value, second_value)
        end
      end

      rule(begining: simple(:begining),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        begining.parameter_one = Transform.organize_table(table_data)
        begining
      end

      rule(begining: simple(:begining),
           args: simple(:args),
           table_data: simple(:table_data),
           ending: simple(:ending)) do
        table_value = Transform.organize_table([table_data])
        begining.parameter_one = table_value
        begining.parameter_three = [args]
        begining
      end

      rule(begining: simple(:begining),
           args: sequence(:args),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        table_value = Transform.organize_table(table_data)
        begining.parameter_one = table_value
        begining.parameter_three = args
        begining
      end

      rule(begining: simple(:begining),
           args: simple(:args),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        table_value = Transform.organize_table(table_data)
        begining.parameter_one = table_value
        begining.parameter_three = [args]
        begining
      end

      rule(environment: simple(:env),
           lparen: simple(:lparen),
           expression: sequence(:expr),
           rparen: simple(:rparen)) do
        table_value = Transform.organize_table(expr)
        left_paren = Constants::MATRICES[env.to_sym]
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
          table_separator = ["&", "\\\\"].freeze
          array.each do |data|
            if data.is_a?(Math::Symbol) && table_separator.include?(data.value)
              table_row << Math::Function::Td.new(table_data)
              table_data = []
              if data.value == "\\\\"
                table << Math::Function::Tr.new(table_row.flatten)
                table_row = []
              end
            else
              table_data << data
            end
          end
          table_row << Math::Function::Td.new(table_data) if table_data
          table << Math::Function::Tr.new(table_row) unless table_row.empty?
          table
        end

        def get_table_class(text)
          text = text.to_s.capitalize
          Object.const_get("Plurimath::Math::Function::Table::#{text}")
        end

        def get_class(text)
          text = text.to_s.capitalize
          Object.const_get("Plurimath::Math::Function::#{text}")
        end
      end
    end
  end
end
