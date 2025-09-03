# frozen_string_literal: true

module Plurimath
  class Latex
    class Transform < Parslet::Transform
      rule(base: simple(:base))       { base }
      rule(over: simple(:over))       { over }
      rule(number: simple(:num))      { Math::Number.new(num) }
      rule(power: simple(:power))     { power }
      rule(unary: simple(:unary))     { Utility.get_class(unary).new }
      rule(space: simple(:space))     { Math::Function::Text.new(" ") }
      rule(operant: simple(:oper))    { Utility.symbols_class(oper, lang: :latex) }
      rule(symbol: simple(:symbol))   { Utility.symbols_class(symbol, lang: :latex) }
      rule(lparen: simple(:lparen))   { Utility.symbols_class(lparen, lang: :latex) }
      rule(rparen: simple(:rparen))   { Utility.symbols_class(rparen, lang: :latex) }
      rule(limits: simple(:limits))   { limits }
      rule("\\\\" => simple(:slash))  { Math::Function::Linebreak.new }
      rule(expression: simple(:expr)) { expr }
      rule(environment: simple(:env)) { env }
      rule(ternary: simple(:ternary)) { Utility.get_class(ternary).new }

      rule(unary_functions: simple(:unary)) { unary }
      rule(ternary_class: simple(:ternary)) { ternary }
      rule(left_right: simple(:left_right)) { left_right }
      rule(under_over: simple(:under_over)) { under_over }
      rule(power_base: simple(:power_base)) { power_base }
      rule(table_data: simple(:table_data)) { table_data }
      rule(three_per_em_space: simple(:space)) { Math::Symbols::ThreePerEmSpace.new }

      rule(intermediate_exp: simple(:int_exp)) { int_exp }

      rule(numeric_values: simple(:value)) do
        Utility.symbols_class(value, lang: :latex)
      end

      rule(text: simple(:text)) do
        Math::Function::Text.new(text)
      end

      rule(unicode_symbols: simple(:unicode)) do
        Utility.symbols_class(unicode, lang: :latex)
      end

      rule(binary: simple(:binary)) do
        binary.is_a?(Parslet::Slice) ? Utility.get_class(binary).new : binary
      end

      rule(symbols: simple(:sym)) do
        Utility.symbols_class(sym, lang: :latex)
      end

      rule(lparen: simple(:lparen),
           rparen: simple(:rparen)) do
        []
      end

      rule(left_right: simple(:left_right),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          left_right,
          subscript,
        )
      end

      rule(left_right: simple(:left_right),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          left_right,
          supscript,
        )
      end

      rule(left: simple(:left),
           left_paren: simple(:lparen),
           expression: sequence(:expr),
           right: simple(:right),
           right_paren: simple(:rparen)) do
        Math::Formula.new(
          [
            Utility.left_right_objects(lparen, "left"),
            Math::Formula.new(expr),
            Utility.left_right_objects(rparen, "right"),
          ],
        )
      end

      rule(left: simple(:left),
           left_paren: simple(:lparen),
           expression: sequence(:expr),
           right: simple(:right)) do
        Math::Formula.new(
          [
            Utility.left_right_objects(lparen, "left"),
            Math::Formula.new(expr),
            Math::Function::Right.new,
          ],
        )
      end

      rule(left: simple(:left),
           left_paren: simple(:lparen),
           expression: simple(:expr),
           right: simple(:right)) do
        Math::Formula.new(
          [
            Utility.left_right_objects(lparen, "left"),
            expr,
            Math::Function::Right.new,
          ],
        )
      end

      rule(left: simple(:left),
           left_paren: simple(:lparen),
           right: simple(:right)) do
        Math::Formula.new(
          [
            Utility.left_right_objects(lparen, "left"),
            Math::Function::Right.new,
          ],
        )
      end

      rule(left: simple(:left),
           left_paren: simple(:lparen),
           right: simple(:right),
           right_paren: simple(:rparen)) do
        Math::Formula.new(
          [
            Utility.left_right_objects(lparen, "left"),
            Utility.left_right_objects(rparen, "right"),
          ],
        )
      end

      rule(left: simple(:left),
           left_paren: simple(:lparen)) do
        Utility.left_right_objects(lparen, "left")
      end

      rule(left: simple(:left),
           left_paren: simple(:lparen),
           expression: simple(:expr),
           right: simple(:right),
           right_paren: simple(:rparen)) do
        Math::Formula.new(
          [
            Utility.left_right_objects(lparen, "left"),
            expr,
            Utility.left_right_objects(rparen, "right"),
          ],
        )
      end

      rule(left: simple(:left),
           expression: simple(:expr),
           right: simple(:right)) do
        Math::Formula.new(
          [
            Math::Function::Left.new,
            expr,
            Math::Function::Right.new,
          ],
        )
      end

      rule(left: simple(:left),
           expression: sequence(:expr),
           right: simple(:right)) do
        Math::Formula.new(
          [
            Math::Function::Left.new,
            Math::Formula.new(expr),
            Math::Function::Right.new,
          ],
        )
      end

      rule(power: simple(:power),
           number: simple(:number)) do
        Math::Function::Power.new(
          power,
          Math::Number.new(number),
        )
      end

      rule(power: simple(:power),
           symbols: simple(:sym)) do
        Math::Function::Power.new(
          power,
          Utility.symbols_class(sym, lang: :latex),
        )
      end

      rule(power: simple(:power),
           expression: simple(:expr)) do
        Math::Function::Power.new(
          power,
          expr,
        )
      end

      rule(base: simple(:base),
           expression: simple(:expr)) do
        Math::Function::Base.new(
          base,
          expr,
        )
      end

      rule(base: simple(:base),
           expression: sequence(:expr)) do
        Math::Function::Base.new(
          base,
          Utility.filter_values(expr),
        )
      end

      rule(power: simple(:power),
           expression: sequence(:expr)) do
        Math::Function::Power.new(
          power,
          Utility.filter_values(expr),
        )
      end

      rule(left: simple(:left),
           left_paren: simple(:lparen),
           dividend: subtree(:dividend),
           divisor: subtree(:divisor),
           right: simple(:right),
           right_paren: simple(:rparen)) do
        Math::Formula.new(
          [
            Utility.left_right_objects(lparen, "left"),
            Math::Function::Over.new(
              Math::Formula.new(
                Array(dividend).flatten,
              ),
              Math::Formula.new(
                Array(divisor).flatten,
              ),
            ),
            Utility.left_right_objects(rparen, "right"),
          ],
        )
      end

      rule(dividend: subtree(:dividend),
           divisor: subtree(:divisor)) do
        Math::Function::Over.new(
          Math::Formula.new(
            Array(dividend).flatten,
          ),
          Math::Formula.new(
            Array(divisor).flatten,
          ),
        )
      end

      rule(over: simple(:over),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          over,
          subscript,
        )
      end

      rule(over: simple(:over),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          over,
          supscript,
        )
      end

      rule(operant: simple(:operant),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Utility.symbols_class(operant, lang: :latex),
          subscript,
        )
      end

      rule(operant: simple(:operant),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          Utility.symbols_class(operant, lang: :latex),
          supscript,
        )
      end

      rule(sequence: simple(:sequence),
           expression: simple(:expr)) do
        if sequence.is_a?(Math::Function::PowerBase) && sequence.parameter_one.is_nary_symbol?
          Math::Function::Nary.new(
            sequence.parameter_one,
            sequence.parameter_two,
            sequence.parameter_three,
            expr,
          )
        else
          [sequence, expr].compact
        end
      end

      rule(sequence: simple(:sequence),
           expression: sequence(:expr)) do
        if sequence.is_a?(Math::Function::PowerBase) && sequence.parameter_one.is_nary_symbol?
          Math::Function::Nary.new(
            sequence.parameter_one,
            sequence.parameter_two,
            sequence.parameter_three,
            Utility.filter_values(expr),
          )
        else
          [sequence] + expr
        end
      end

      rule(unary_functions: simple(:unary),
           subscript: simple(:subscript)) do
        unary_function = if unary.is_a?(Parslet::Slice)
                           Utility.get_class(unary).new
                         else
                           unary
                         end
        Math::Function::Base.new(
          unary_function,
          subscript,
        )
      end

      rule(binary_functions: simple(:binary),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          binary,
          supscript,
        )
      end

      rule(ternary_functions: simple(:ternary),
           subscript: simple(:subscript)) do
        Utility.get_class(ternary).new(subscript)
      end

      rule(unary_functions: simple(:unary),
           supscript: simple(:supscript)) do
        unary_function = if unary.is_a?(Parslet::Slice)
                           Utility.get_class(unary).new
                         else
                           unary
                         end
        Math::Function::Power.new(
          unary_function,
          supscript,
        )
      end

      rule(ternary_functions: simple(:ternary),
           subscript: simple(:subscript),
           third_value: simple(:third_value)) do
        Utility.get_class(ternary).new(
          subscript,
          nil,
          third_value,
        )
      end

      rule(ternary_functions: simple(:ternary),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        Utility.get_class(ternary).new(
          subscript,
          supscript,
        )
      end

      rule(unary_functions: simple(:unary),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        unary_function = if unary.is_a?(Parslet::Slice)
                           Utility.get_class(unary).new
                         else
                           unary
                         end
        Math::Function::PowerBase.new(
          unary_function,
          subscript,
          supscript,
        )
      end

      rule(ternary_functions: simple(:ternary),
           subscript: simple(:subscript),
           supscript: simple(:supscript),
           third_value: simple(:third_value)) do
        Utility.get_class(ternary).new(
          subscript,
          supscript,
          third_value,
        )
      end

      rule(fonts: simple(:fonts),
           intermediate_exp: simple(:int_exp)) do
        if Utility::FONT_STYLES[fonts.to_sym]
          Utility::FONT_STYLES[fonts.to_sym].new(
            int_exp,
            fonts.to_s,
          )
        else
          Math::Function::FontStyle.new(
            int_exp,
            fonts.to_s,
          )
        end
      end

      rule(number: simple(:number),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Math::Number.new(number),
          subscript,
        )
      end

      rule(number: simple(:number),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          Math::Number.new(number),
          supscript,
        )
      end

      rule(number: simple(:number),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        Math::Function::PowerBase.new(
          Math::Number.new(number),
          subscript,
          supscript,
        )
      end

      rule(symbols: simple(:sym),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Utility.symbols_class(sym, lang: :latex),
          subscript,
        )
      end

      rule(numeric_values: simple(:value),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Utility.symbols_class(value, lang: :latex),
          subscript,
        )
      end

      rule(symbols: simple(:sym),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          Utility.symbols_class(sym, lang: :latex),
          supscript,
        )
      end

      rule(intermediate_exp: simple(:int_exp),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          int_exp,
          supscript,
        )
      end

      rule(intermediate_exp: simple(:int_exp),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          int_exp,
          subscript,
        )
      end

      rule(unicode_symbols: simple(:sym),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Utility.symbols_class(sym, lang: :latex),
          subscript,
        )
      end

      rule(unicode_symbols: simple(:sym),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          Utility.symbols_class(sym, lang: :latex),
          supscript,
        )
      end

      rule(numeric_values: simple(:value),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          Utility.symbols_class(value, lang: :latex),
          supscript,
        )
      end

      rule(text: simple(:text),
           first_value: simple(:first_value)) do
        Utility.get_class(text).new(first_value)
      end

      rule(text: simple(:text),
           first_value: sequence(:first_value)) do
        Utility.get_class(text).new(first_value.join)
      end

      rule(text: simple(:text),
           first_value: simple(:first_value),
           supscript: simple(:supscript),) do
        Math::Function::Power.new(
          Utility.get_class(text).new(first_value),
          supscript,
        )
      end

      rule(text: simple(:text),
           first_value: sequence(:first_value),
           supscript: simple(:supscript),) do
        Math::Function::Power.new(
          Utility.get_class(text).new(first_value.join),
          supscript,
        )
      end

      rule(text: simple(:text),
           first_value: sequence(:first_value),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Utility.get_class(text).new(first_value.join),
          subscript,
        )
      end

      rule(text: simple(:text),
           first_value: simple(:first_value),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Utility.get_class(text).new(first_value),
          subscript,
        )
      end

      rule(text: simple(:text),
           first_value: simple(:first_value),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        Math::Function::PowerBase.new(
          Utility.get_class(text).new(first_value),
          subscript,
          supscript,
        )
      end

      rule(unary: simple(:unary),
           first_value: simple(:first_value)) do
        Utility.get_class(
          unary == "overline" ? "bar" : unary,
        ).new(first_value)
      end

      rule(sqrt: simple(:sqrt),
           intermediate_exp: simple(:int_exp)) do
        Math::Function::Sqrt.new(int_exp)
      end

      rule(fonts: simple(:fonts),
           intermediate_exp: simple(:int_exp),
           supscript: simple(:supscript)) do
        font_style = if Utility::FONT_STYLES[fonts.to_sym].nil?
                       Math::Function::FontStyle.new(
                         int_exp,
                         fonts.to_s,
                       )
                     else
                       Utility::FONT_STYLES[fonts.to_sym].new(
                         int_exp,
                         fonts.to_s,
                       )
                     end
        Math::Function::Power.new(
          font_style,
          supscript,
        )
      end

      rule(fonts: simple(:fonts),
           intermediate_exp: simple(:int_exp),
           subscript: simple(:subscript)) do
        font_style = if Utility::FONT_STYLES[fonts.to_sym].nil?
                       Math::Function::FontStyle.new(
                         int_exp,
                         fonts.to_s,
                       )
                     else
                       Utility::FONT_STYLES[fonts.to_sym].new(
                         int_exp,
                         fonts.to_s,
                       )
                     end
        Math::Function::Base.new(
          font_style,
          subscript,
        )
      end

      rule(fonts: simple(:fonts),
           intermediate_exp: simple(:int_exp),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        font_style = if Utility::FONT_STYLES[fonts.to_sym].nil?
                       Math::Function::FontStyle.new(
                         int_exp,
                         fonts.to_s,
                       )
                     else
                       Utility::FONT_STYLES[fonts.to_sym].new(
                         int_exp,
                         fonts.to_s,
                       )
                     end
        Math::Function::PowerBase.new(
          font_style,
          subscript,
          supscript,
        )
      end

      rule(root: simple(:root),
           first_value: simple(:first_value),
           second_value: simple(:second_value)) do
        second = second_value.nil? ? Math::Formula.new : second_value
        Math::Function::Root.new(
          first_value,
          second,
        )
      end

      rule(root: simple(:root),
           first_value: sequence(:first_value),
           second_value: simple(:second_value)) do
        first = Utility.filter_values(first_value)
        first = first.nil? ? Math::Formula.new : first
        Math::Function::Root.new(
          first,
          second_value,
        )
      end

      rule(first_value: simple(:first_value),
           base: simple(:base),
           power: simple(:power)) do
        Math::Function::Limits.new(
          first_value,
          base,
          power,
        )
      end

      rule(lparen: simple(:lparen),
           expression: sequence(:expr),
           rparen: simple(:rparen)) do
        Math::Formula.new(expr)
      end

      rule(left_paren: simple(:lparen),
           expression: simple(:expr),
           right_paren: simple(:rparen)) do
        Math::Function::Fenced.new(
          Utility.symbols_class(lparen, lang: :latex),
          [expr],
          Utility.symbols_class(rparen, lang: :latex),
        )
      end

      rule(left_paren: simple(:lparen),
           expression: sequence(:expr),
           right_paren: simple(:rparen)) do
        Math::Function::Fenced.new(
          Utility.symbols_class(lparen, lang: :latex),
          expr,
          Utility.symbols_class(rparen, lang: :latex),
        )
      end

      rule(expression: sequence(:expr)) do
        Math::Formula.new(expr)
      end

      rule(rule: simple(:rule),
           first_value: simple(:first_value),
           second_value: simple(:second_value),
           third_value: simple(:third_value)) do
        Math::Function::Rule.new(
          first_value,
          second_value,
          third_value,
        )
      end

      rule(expression: simple(:expression),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          expression,
          subscript,
        )
      end

      rule(expression: simple(:expr),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          expr,
          supscript,
        )
      end

      rule(expression: sequence(:expr),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          Utility.filter_values(expr),
          supscript,
        )
      end

      rule(binary: simple(:binary),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        Utility.get_class(binary).new(
          subscript,
          supscript,
        )
      end

      rule(binary: simple(:binary),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        if binary.is_a?(Parslet::Slice)
          Utility.get_class(binary).new(
            subscript,
            supscript,
          )
        else
          Math::Function::PowerBase.new(
            binary,
            subscript,
            subscript,
          )
        end
      end

      rule(binary: simple(:binary),
           subscript: simple(:subscript)) do
        if binary.is_a?(Parslet::Slice)
          Utility.get_class(binary).new(subscript)
        else
          Math::Function::Base.new(
            binary,
            subscript,
          )
        end
      end

      rule(symbols: simple(:sym),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        Math::Function::PowerBase.new(
          Utility.symbols_class(sym, lang: :latex),
          subscript,
          supscript,
        )
      end

      rule(unicode_symbols: simple(:sym),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        Math::Function::PowerBase.new(
          Utility.symbols_class(sym, lang: :latex),
          subscript,
          supscript,
        )
      end

      rule(binary: simple(:binary),
           first_value: simple(:first_value),
           second_value: simple(:second_value)) do
        if binary == "binom"
          Math::Function::Table.new(
            [
              Math::Function::Tr.new(
                Utility.table_td(first_value),
              ),
              Math::Function::Tr.new(
                Utility.table_td(second_value),
              ),
            ],
            Plurimath::Math::Symbols::Paren::Lcurly.new,
            Plurimath::Math::Symbols::Paren::Rcurly.new,
          )
        else
          Utility.get_class(
            binary.to_s.include?("mod") ? "mod" : binary,
          ).new(
            first_value,
            second_value,
          )
        end
      end

      rule(binary: simple(:binary),
           first_value: simple(:first_value),
           second_value: sequence(:second_value)) do
        Utility.get_class(
          binary.to_s.include?("mod") ? "mod" : binary,
        ).new(
          first_value,
          Utility.filter_values(second_value),
        )
      end

      rule(underover: simple(:function),
           first_value: simple(:first),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        Math::Function::PowerBase.new(
          Utility.get_class(function).new(first),
          subscript,
          supscript,
        )
      end

      rule(environment: simple(:environment),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        open_paren = Constants::MATRICES[environment.to_sym]
        Utility.get_table_class(environment).new(
          Utility.organize_table(table_data),
          Utility.symbols_class(open_paren, lang: :latex, table: true),
          Utility.symbols_class(Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s, lang: :latex, table: true),
          {},
        )
      end

      rule(environment: simple(:environment),
           args: simple(:args),
           table_data: simple(:table_data),
           ending: simple(:ending)) do
        third_value = args ? [args] : []
        open_paren = Constants::MATRICES[environment.to_sym]
        table = Utility.organize_table(
          [table_data],
          column_align: third_value,
        )
        Utility.get_table_class(environment).new(
          table,
          Utility.symbols_class(open_paren, lang: :latex, table: true),
          Utility.symbols_class(Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s, lang: :latex, table: true),
          Utility.table_options(table),
        )
      end

      rule(environment: simple(:environment),
           table_data: simple(:table_data),
           ending: simple(:ending)) do
        open_paren = Constants::MATRICES[environment.to_sym]
        Utility.get_table_class(environment).new(
          Utility.organize_table([table_data]),
          Utility.symbols_class(open_paren, lang: :latex, table: true),
          Utility.symbols_class(Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s, lang: :latex, table: true),
        )
      end

      rule(environment: simple(:environment),
           args: sequence(:args),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        open_paren = Constants::MATRICES[environment.to_sym]
        table = Utility.organize_table(table_data, column_align: args)
        Utility.get_table_class(environment).new(
          table,
          Utility.symbols_class(open_paren, lang: :latex, table: true),
          Utility.symbols_class(Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s, lang: :latex, table: true),
          Utility.table_options(table),
        )
      end

      rule(environment: simple(:environment),
           args: simple(:args),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        third_value = args ? [args] : []
        open_paren = Constants::MATRICES[environment.to_sym]
        table = Utility.organize_table(table_data, column_align: third_value)
        Utility.get_table_class(environment).new(
          table,
          Utility.symbols_class(open_paren, lang: :latex, table: true),
          Utility.symbols_class(Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s, lang: :latex, table: true),
          Utility.table_options(table),
        )
      end

      rule(environment: simple(:environment),
           asterisk: simple(:asterisk),
           options: simple(:options),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        third_value = options ? [options] : []
        open_paren = Constants::MATRICES[environment.to_sym]
        table = Utility.organize_table(
          table_data,
          column_align: third_value,
          options: true,
        )
        Utility.get_table_class(environment).new(
          table,
          Utility.symbols_class(open_paren, lang: :latex, table: true),
          Utility.symbols_class(Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s, lang: :latex, table: true),
          { asterisk: true },
        )
      end

      rule(environment: simple(:environment),
           asterisk: simple(:asterisk),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        open_paren = Constants::MATRICES[environment.to_sym]
        Utility.get_table_class(environment).new(
          Utility.organize_table(table_data),
          Utility.symbols_class(open_paren, lang: :latex, table: true),
          Utility.symbols_class(Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s, lang: :latex, table: true),
          { asterisk: true },
        )
      end

      rule(environment: simple(:env),
           expression: simple(:expr)) do
        open_paren = Constants::MATRICES[env.to_sym]
        Utility.get_table_class(env).new(
          Utility.organize_table(expr.nil? ? [] : [expr]),
          Utility.symbols_class(open_paren, lang: :latex, table: true),
          Utility.symbols_class(Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s, lang: :latex, table: true),
          {},
        )
      end

      rule(environment: simple(:env),
           expression: sequence(:expr)) do
        open_paren = Constants::MATRICES[env.to_sym]
        Utility.get_table_class(env).new(
          Utility.organize_table(expr.compact),
          Utility.symbols_class(open_paren, lang: :latex, table: true),
          Utility.symbols_class(Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s, lang: :latex, table: true),
          {},
        )
      end

      rule(substack: simple(:substack),
           expression: sequence(:value)) do
        Math::Function::Substack.new(
          Utility.organize_table(value),
        )
      end
    end
  end
end
