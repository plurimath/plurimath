# frozen_string_literal: true

module Plurimath
  class Latex
    class Transform < Parslet::Transform
      rule(base: simple(:base))     { base }
      rule(over: simple(:over))     { over }
      rule(number: simple(:num))    { Math::Number.new(num) }
      rule(power: simple(:power))   { power }
      rule(unary: simple(:unary))   { Utility.get_class(unary).new }
      rule(operant: simple(:oper))  { Math::Symbol.new(oper) }
      rule("\\\\": simple(:slash))  { Math::Symbol.new(slash) }
      rule(symbol: simple(:symbol)) { Math::Symbol.new(symbol) }
      rule(limits: simple(:limits)) { limits }

      rule(unary_functions: simple(:unary)) { unary }
      rule(left_right: simple(:left_right)) { left_right }
      rule(under_over: simple(:under_over)) { under_over }
      rule(power_base: simple(:power_base)) { power_base }
      rule(table_data: simple(:table_data)) { table_data }

      rule(environment: simple(:environment)) { environment }

      rule(text: simple(:text)) do
        Math::Function::Text.new(text)
      end

      rule(binary: simple(:binary)) do
        binary.is_a?(String) ? Math::Function::Text.new(binary) : binary
      end

      rule(symbols: simple(:sym)) do
        Math::Symbol.new(
          Constants::SYMBOLS[sym.to_sym] || sym,
        )
      end

      rule(lparen: simple(:lparen),
           rparen: simple(:rparen)) do
        Math::Formula.new
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
           lparen: simple(:lparen),
           expression: sequence(:expr),
           right: simple(:right),
           rparen: simple(:rparen)) do
        Math::Formula.new(
          [
            Math::Function::Left.new(lparen),
            Math::Formula.new(expr),
            Math::Function::Right.new(rparen),
          ],
        )
      end

      rule(left: simple(:left),
           lparen: simple(:lparen),
           expression: simple(:expr),
           right: simple(:right),
           rparen: simple(:rparen)) do
        Math::Formula.new(
          [
            Math::Function::Left.new(lparen),
            expr,
            Math::Function::Right.new(rparen),
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

      rule(left: simple(:left),
           lparen: simple(:lparen),
           dividend: subtree(:dividend),
           divisor: sequence(:divisor),
           right: simple(:right),
           rparen: simple(:rparen)) do
        Math::Formula.new(
          [
            Math::Function::Left.new(lparen),
            Math::Function::Over.new(
              Math::Formula.new(dividend.flatten),
              Math::Formula.new(divisor),
            ),
            Math::Function::Right.new(rparen),
          ],
        )
      end

      rule(dividend: subtree(:dividend),
           divisor: subtree(:divisor)) do
        Math::Function::Over.new(
          Math::Formula.new(dividend.flatten),
          Math::Formula.new(divisor.flatten),
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
        [sequence, expr]
      end

      rule(sequence: simple(:sequence),
           expression: sequence(:expr)) do
        [sequence] + expr
      end

      rule(unary_functions: simple(:unary),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          unary,
          subscript,
        )
      end

      rule(fonts: simple(:fonts),
           intermediate_exp: simple(:int_exp)) do
        if Utility::FONT_STYLES[fonts.to_sym]
          Utility::FONT_STYLES[fonts.to_sym].new(
            int_exp,
            fonts,
          )
        else
          Math::Function::FontStyle.new(
            int_exp,
            fonts,
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

      rule(symbols: simple(:sym),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Math::Symbol.new(
            Constants::SYMBOLS[sym.to_sym] || sym,
          ),
          subscript,
        )
      end

      rule(symbols: simple(:sym),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          Math::Symbol.new(
            Constants::SYMBOLS[sym.to_sym] || sym,
          ),
          supscript,
        )
      end

      rule(text: simple(:text),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Math::Function::Text.new(text),
          subscript,
        )
      end

      rule(text: simple(:text),
           supscript: simple(:supscript)) do
        Math::Function::Power.new(
          Math::Function::Text.new(text),
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
                         fonts,
                       )
                     else
                       Utility::FONT_STYLES[fonts.to_sym].new(
                         int_exp,
                         fonts,
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
                         fonts,
                       )
                     else
                       Utility::FONT_STYLES[fonts.to_sym].new(
                         int_exp,
                         fonts,
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
        Math::Function::Root.new(
          first_value,
          second_value,
        )
      end

      rule(unary_functions: simple(:unary),
           base: simple(:base),
           power: simple(:power)) do
        Math::Function::Limits.new(
          Utility.get_class(unary).new,
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
        Math::Symbol.new(
          Constants::SYMBOLS[sym.to_sym] || sym,
        )
      end

      rule(lparen: simple(:lparen),
           expression: simple(:expr),
           rparen: simple(:rparen)) do
        expr
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
        Math::Function::Power.new(
          Math::Formula.new(expr),
          supscript,
        )
      end

      rule(lparen: simple(:lparen),
           expression: simple(:expr),
           rparen: simple(:rparen),
           subscript: simple(:subscript)) do
        Math::Function::Base.new(
          Math::Formula.new(expr),
          subscript,
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
        Utility.get_class(binary).new(subscript)
      end

      rule(text: simple(:text),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        Math::Function::PowerBase.new(
          Math::Function::Text.new(text),
          subscript,
          supscript,
        )
      end

      rule(symbols: simple(:sym),
           subscript: simple(:subscript),
           supscript: simple(:supscript)) do
        Math::Function::PowerBase.new(
          Math::Symbol.new(
            Constants::SYMBOLS[sym.to_sym] || sym,
          ),
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
              Math::Function::Tr.new([first_value]),
              Math::Function::Tr.new([second_value]),
            ],
            "(",
            ")",
          )
        else
          Utility.get_class(
            binary.include?("mod") ? "mod" : binary,
          ).new(
            first_value,
            second_value,
          )
        end
      end

      rule(begining: simple(:begining),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        Utility.get_table_class(begining).new(
          Utility.organize_table(table_data),
        )
      end

      rule(begining: simple(:begining),
           args: simple(:args),
           table_data: simple(:table_data),
           ending: simple(:ending)) do
        Utility.get_table_class(begining).new(
          Utility.organize_table([table_data]),
          nil,
          [args],
        )
      end

      rule(begining: simple(:begining),
           args: sequence(:args),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        Utility.get_table_class(begining).new(
          Utility.organize_table(table_data),
          nil,
          args,
        )
      end

      rule(begining: simple(:begining),
           args: simple(:args),
           table_data: sequence(:table_data),
           ending: simple(:ending)) do
        Utility.get_table_class(begining).new(
          Utility.organize_table(table_data),
          nil,
          [args],
        )
      end

      rule(environment: simple(:env),
           lparen: simple(:lparen),
           expression: sequence(:expr),
           rparen: simple(:rparen)) do
        left_paren = Constants::MATRICES[env.to_sym]
        Math::Function::Table.new(
          Utility.organize_table(expr),
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
    end
  end
end
