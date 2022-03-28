# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Transform < Parslet::Transform
      rule(mod: simple(:mod))                 { mod }
      rule(expr: simple(:expr))               { expr }
      rule(base: simple(:base))               { base }
      rule(expr: sequence(:expr))             { expr }
      rule(power: simple(:power))             { power }
      rule(unary: simple(:unary))             { unary }
      rule(power: sequence(:power))           { power }
      rule(binary: simple(:binary))           { binary }
      rule(sequance: simple(:sequance))       { sequance }
      rule(power_base: simple(:power_base))   { power_base }
      rule(power_base: sequence(:power_base)) { power_base }

      rule(intermediate_exp: simple(:intermediate_exp)) do
        intermediate_exp
      end

      rule(power: sequence(:power), expr: sequence(:expr)) do
        power + expr
      end

      rule(number: simple(:number)) do
        Plurimath::Math::Number.new(number.to_s)
      end

      rule(symbol: simple(:symbol)) do
        Plurimath::Math::Symbol.new(symbol.to_s)
      end

      rule(text: simple(:text)) do
        Plurimath::Math::Function::Text.new(text.to_s)
      end

      rule(power_base: simple(:power_base), expr: simple(:expr)) do
        [power_base, expr]
      end

      rule(power_base: simple(:power_base), expr: sequence(:expr)) do
        expr.insert(0, power_base)
      end

      rule(power_base: sequence(:power_base), expr: sequence(:expr)) do
        power_base + expr
      end

      rule(sequance: simple(:sequance), expr: sequence(:expr)) do
        expr.insert(0, sequance)
      end

      rule(mod: simple(:mod), expr: simple(:expr)) do
        [mod, expr]
      end

      rule(dividend: simple(:dividend), mod: simple(:mod),
           divisor: simple(:divisor)) do
        Plurimath::Math::Function::Mod.new(dividend, divisor)
      end

      rule(unary: simple(:unary), "^": simple(:exponent),
           number: simple(:number)) do
        [
          unary,
          Plurimath::Math::Symbol.new(exponent.to_s),
          Plurimath::Math::Number.new(number.to_s),
        ]
      end

      rule(unary: simple(:unary), "^": simple(:exponent),
           intermediate_exp: simple(:intermediate_exp)) do
        [
          unary,
          Plurimath::Math::Symbol.new(exponent.to_s),
          intermediate_exp,
        ]
      end

      rule(symbol: simple(:symbol), "^": simple(:exponent),
           number: simple(:number)) do
        [
          Plurimath::Math::Symbol.new(symbol.to_s),
          Plurimath::Math::Symbol.new(exponent.to_s),
          Plurimath::Math::Number.new(number.to_s),
        ]
      end

      rule(binary: simple(:function), "^": simple(:exponent),
           number: simple(:number)) do
        Transform.get_class(function.class).new(nil, int_exp)
      end

      Constants::SYMBOLS.each do |symbol|
        rule(symbol => simple(:symbol)) do
          Plurimath::Math::Symbol.new(symbol.to_s)
        end

        rule(symbol => simple(:main_symbol), _: simple(:under_score),
             intermediate_exp: simple(:int_exp),
             "^": simple(:power), symbol: simple(:symbol)) do
          [
            Plurimath::Math::Symbol.new(main_symbol.to_s),
            Plurimath::Math::Symbol.new(under_score.to_s),
            int_exp,
            Plurimath::Math::Symbol.new("^".to_s),
            Plurimath::Math::Symbol.new(symbol.to_s),
          ]
        end

        rule(symbol => simple(:symbol), _: simple(:under_score),
             base: simple(:int_exp), "^": simple(:power),
             exponent: simple(:exponent)) do
          [
            Plurimath::Math::Symbol.new(symbol.to_s),
            Plurimath::Math::Symbol.new(under_score.to_s),
            int_exp,
            Plurimath::Math::Symbol.new(power.to_s),
            exponent,
          ]
        end
      end
      Constants::UNARY_CLASSES.each do |unary_class|
        rule(unary_class => simple(:function),
             intermediate_exp: simple(:int_exp)) do
          Transform.get_class(function).new(int_exp)
        end
      end

      Constants::BINARY_CLASSES.each do |binary_class|
        rule(binary_class => simple(:function)) do
          Transform.get_class(function)
        end

        rule(
          binary_class => simple(:function),
          _: simple(:under_score),
          intermediate_exp: simple(:int_exp),
          "^": simple(:power),
          number: simple(:number),
        ) do
          Transform.get_class(function).new(
            int_exp,
            Plurimath::Math::Number.new(number.to_s),
          )
        end

        rule(binary_class => simple(:function), _: simple(:under_score),
             intermediate_exp: simple(:int_exp),
             "^": simple(:power), symbol: simple(:symbol)) do
          Transform.get_class(function).new(
            int_exp,
            Plurimath::Math::Symbol.new(symbol.to_s),
          )
        end

        rule(binary_class => simple(:function), _: simple(:under_score),
             intermediate_exp: simple(:int_exp),
             "^": simple(:power), unary: simple(:unary)) do
          Transform.get_class(function).new(int_exp, unary)
        end

        rule(binary_class => simple(:function), _: simple(:under_score),
             base: simple(:int_exp), "^": simple(:power),
             exponent: simple(:exponent)) do
          Transform.get_class(function).new(int_exp, exponent)
        end

        rule(binary_class => simple(:function), _: simple(:under_score),
             intermediate_exp: simple(:int_exp)) do
          Transform.get_class(function).new(int_exp, nil)
        end

        rule(binary_class => simple(:function), "^": simple(:exponent),
             intermediate_exp: simple(:int_exp)) do
          Transform.get_class(function).new(nil, int_exp)
        end

        rule(binary_class => simple(:function), _: simple(:under_score),
             number: simple(:number)) do
          Transform.get_class(function).new(
            Plurimath::Math::Number.new(number.to_s), nil
          )
        end

        rule(binary_class => simple(:function), _: simple(:under_score),
             symbol: simple(:symbol)) do
          Transform.get_class(function).new(
            Plurimath::Math::Symbol.new(symbol.to_s), nil
          )
        end

        rule(binary_class => simple(:function), "^": simple(:power),
             number: simple(:number)) do
          Transform.get_class(function).new(
            nil,
            Plurimath::Math::Number.new(number.to_s),
          )
        end

        rule(binary_class => simple(:function), "^": simple(:power),
             symbol: simple(:symbol)) do
          Transform.get_class(function).new(
            nil,
            Plurimath::Math::Symbol.new(symbol.to_s),
          )
        end

        rule(binary_class => simple(:function), base: simple(:base),
             exponent: simple(:exponent)) do
          Transform.get_class(function).new(base, exponent)
        end
      end
      Constants::LPAREN.each do |lparen|
        Constants::RPAREN.each do |rparen|
          rule(lparen => simple(:left_paren), expr: simple(:expr),
               rparen => simple(:right_paren)) do
            exp = [expr]
            exp.flatten!
            Plurimath::Math::Formula.new(exp)
          end

          rule(lparen => simple(:left_paren), expr: subtree(:expr),
               rparen => simple(:right_paren)) do
            exp = [expr]
            exp.flatten!
            Plurimath::Math::Formula.new(exp)
          end
        end
      end
      rule(sequance: simple(:sequance), expr: simple(:expr)) do
        if sequance.is_a?(Math::Symbol) || sequance.is_a?(Math::Number)
          [sequance, expr]
        else
          sequance.new(expr)
        end
      end

      def self.get_class(text)
        Object.const_get("Plurimath::Math::Function::#{text.to_s.capitalize}")
      end
    end
  end
end
