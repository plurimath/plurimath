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
      rule(operant: simple(:oper))    { Math::Symbol.new(oper) }
      rule(symbol: simple(:symbol))   { Math::Symbol.new(symbol) }
      rule(lparen: simple(:lparen))   { Math::Symbol.new(lparen) }
      rule(rparen: simple(:rparen))   { Math::Symbol.new(rparen) }
      rule(limits: simple(:limits))   { limits }
      rule("\\\\" => simple(:slash))  { Math::Symbol.new(slash) }
      rule(expression: simple(:expr)) { expr }
      rule(environment: simple(:env)) { env }

      rule(unary_functions: simple(:unary)) { unary }
      rule(left_right: simple(:left_right)) { left_right }
      rule(under_over: simple(:under_over)) { under_over }
      rule(power_base: simple(:power_base)) { power_base }
      rule(table_data: simple(:table_data)) { table_data }

      rule(intermediate_exp: simple(:int_exp)) { int_exp }

      rule(numeric_values: simple(:value)) do
        Math::Symbol.new(value)
      end

      rule(text: simple(:text)) do
        Math::Function::Text.new(text)
      end

      rule(unicode_symbols: simple(:unicode)) do
        Math::Unicode.new(unicode)
      end

      rule(binary: simple(:binary)) do
        binary.is_a?(Parslet::Slice) ? Utility.get_class(binary).new : binary
      end

      rule(symbols: simple(:sym)) do
        if sym.is_a?(Parslet::Slice)
          Math::Symbol.new(
            Constants::UNICODE_SYMBOLS[sym.to_sym] || sym,
          )
        else
          sym
        end
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
          Math::Symbol.new(operant),
          subscript,
        )
      end

      rule(sequence: simple(:sequence),
           expression: simple(:expr)) do
        [sequence, expr].compact
      end

      rule(sequence: simple(:sequence),
           expression: sequence(:expr)) do
        [sequence] + expr
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

      rule(unary_functions: simple(:unary),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          unary,
          supscript,
        )
      end

      rule(unary_functions: simple(:unary),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        Math::Function::PowerBase.new(
          unary,
          subscript,
          supscript,
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

      rule(symbols: simple(:sym),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Math::Symbol.new(
            Constants::UNICODE_SYMBOLS[sym.to_sym] || sym,
          ),
          subscript,
        )
      end

      rule(numeric_values: simple(:value),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Math::Symbol.new(value),
          subscript,
        )
      end

      rule(symbols: simple(:sym),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          Math::Symbol.new(
            Constants::UNICODE_SYMBOLS[sym.to_sym] || sym,
          ),
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

      rule(unicode_symbols: simple(:sym),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Math::Unicode.new(sym),
          subscript,
        )
      end

      rule(unicode_symbols: simple(:sym),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          Math::Unicode.new(sym),
          supscript,
        )
      end

      rule(numeric_values: simple(:value),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          Math::Symbol.new(value),
          supscript,
        )
      end

      rule(text: simple(:text),
           first_value: simple(:first_value)) do
        Math::Function::Text.new(first_value)
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
          lparen,
          [expr],
          rparen,
        )
      end

      rule(left_paren: simple(:lparen),
           expression: sequence(:expr),
           right_paren: simple(:rparen)) do
        Math::Function::Fenced.new(
          lparen,
          expr,
          rparen,
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

      rule(rparen: simple(:rparen),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          Math::Symbol.new(rparen),
          supscript,
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
          Math::Symbol.new(
            Constants::UNICODE_SYMBOLS[sym.to_sym] || sym,
          ),
          subscript,
          supscript,
        )
      end

      rule(unicode_symbols: simple(:sym),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        Math::Function::PowerBase.new(
          Math::Unicode.new(sym),
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
            "(",
            ")",
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
          open_paren,
          Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s,
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
          open_paren,
          Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s,
          Utility.table_options(table),
        )
      end

      rule(environment: simple(:environment),
           table_data: simple(:table_data),
           ending: simple(:ending)) do
        open_paren = Constants::MATRICES[environment.to_sym]
        Utility.get_table_class(environment).new(
          Utility.organize_table([table_data]),
          open_paren,
          Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s,
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
          open_paren,
          Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s,
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
          open_paren,
          Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s,
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
          open_paren,
          Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s,
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
          open_paren,
          Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s,
          { asterisk: true },
        )
      end

      rule(environment: simple(:env),
           expression: simple(:expr)) do
        open_paren = Constants::MATRICES[env.to_sym]
        Utility.get_table_class(env).new(
          Utility.organize_table(expr.nil? ? [] : [expr]),
          open_paren,
          Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s,
          {},
        )
      end

      rule(environment: simple(:env),
           expression: sequence(:expr)) do
        open_paren = Constants::MATRICES[env.to_sym]
        Utility.get_table_class(env).new(
          Utility.organize_table(expr.compact),
          open_paren,
          Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s,
          {},
        )
      end

      rule(substack: simple(:substack),
           expression: sequence(:value)) do
        tds = Utility.td_values(value, "\\\\")

        substack_values = tds.map { |td| Math::Function::Tr.new([td]) }
        Math::Function::Substack.new(
          substack_values.shift,
          substack_values.shift,
        )
      end
    end
  end
end
