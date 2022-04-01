# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Transform < Parslet::Transform
      rule(expr: simple(:expr))                       { expr }
      rule(base: simple(:base))                       { base }
      rule(base: sequence(:base))                     { base }
      rule(power: simple(:power))                     { power }
      rule(unary: simple(:unary))                     { unary }
      rule(power: sequence(:power))                   { power }
      rule(binary: simple(:binary))                   { binary }
      rule(sequance: simple(:sequance))               { sequance }
      rule(power_base: simple(:power_base))           { power_base }
      rule(intermediate_exp: simple(:int_exp))        { int_exp }
      rule(mod: simple(:mod), expr: simple(:expr))    { [mod, expr] }
      rule(base: sequence(:base), expr: simple(:exp)) { base + [exp] }

      rule(expr: sequence(:expr)) do
        Plurimath::Math::Formula.new(expr)
      end

      rule(power: sequence(:power), expr: simple(:expr)) do
        power + [expr]
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
        text.is_a?(Slice) ? Transform.get_class("text").new(text.to_s) : text
      end

      rule(base: simple(:base),
           expr: simple(:expr)) do
        [base, expr]
      end

      rule(power_base: simple(:power_base), expr: sequence(:expr)) do
        expr.insert(0, power_base)
      end

      rule(power_base: simple(:power_base), expr: simple(:expr)) do
        [power_base, expr]
      end

      rule(power_base: sequence(:power_base), expr: simple(:expr)) do
        power_base + [expr]
      end

      rule(power_base: sequence(:power_base), expr: sequence(:expr)) do
        power_base + expr
      end

      rule(sequance: simple(:sequance), expr: sequence(:expr)) do
        expr.insert(0, sequance)
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

      rule(unary: simple(:unary), "^": simple(:exponent),
           text: simple(:text)) do
        [
          unary,
          Plurimath::Math::Symbol.new(exponent.to_s),
          text.is_a?(Slice) ? Transform.get_class("text").new(text.to_s) : text,
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

      rule(binary: simple(:binary),
           "^": simple(:under_score),
           intermediate_exp: simple(:int_exp)) do
        [
          binary,
          Plurimath::Math::Symbol.new("^"),
          int_exp,
        ]
      end

      rule(binary: simple(:function), "^": simple(:exponent),
           number: simple(:number)) do
        [
          function,
          Plurimath::Math::Symbol.new("^"),
          Plurimath::Math::Number.new(number.to_s),
        ]
      end

      Constants::UNARY_CLASSES.each do |unary_class|
        rule(unary_class => simple(:function),
             intermediate_exp: simple(:int_exp)) do
          Transform.get_class(function).new(int_exp)
        end

        rule(unary_class => simple(:function),
             _: simple(:under_score),
             intermediate_exp: simple(:int_exp)) do
          [
            Transform.get_class(function).new,
            Plurimath::Math::Symbol.new("_"),
            int_exp,
          ]
        end

        rule(unary_class => simple(:function),
             symbol: simple(:new_symbol)) do
          symbol = Plurimath::Math::Symbol.new(new_symbol.to_s)
          Transform.get_class(function).new(symbol)
        end

        rule(unary_class => simple(:function),
             number: simple(:new_number)) do
          number = Plurimath::Math::Number.new(new_number.to_s)
          Transform.get_class(function).new(number)
        end

        rule(unary_class => simple(:function),
             "^": simple(:base),
             intermediate_exp: simple(:unary)) do
          [
            Transform.get_class(unary_class).new,
            Plurimath::Math::Symbol.new("^"),
            unary,
          ]
        end

        rule(unary_class => simple(:function),
             _: simple(:base),
             symbol: simple(:symbol)) do
          [
            Transform.get_class(unary_class).new,
            Plurimath::Math::Symbol.new("_"),
            Plurimath::Math::Symbol.new(symbol.to_s),
          ]
        end

        rule(unary_class => simple(:function),
             _: simple(:under_score),
             base: simple(:base),
             "^": simple(:power),
             exponent: simple(:exponent)) do
          [
            Transform.get_class(function).new,
            Plurimath::Math::Symbol.new("_"),
            base,
            Plurimath::Math::Symbol.new("^"),
            exponent,
          ]
        end
      end

      Constants::BINARY_CLASSES.each do |binary_class|
        rule(binary_class => simple(:function)) do
          Transform.get_class(function).new
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

        rule(binary_class => simple(:function), _: simple(:under_score),
             unary: simple(:unary)) do
          Transform.get_class(function).new(unary, nil)
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

        rule(binary: simple(:function), "^": simple(:exponent),
             text: simple(:text)) do
          [
            function,
            Plurimath::Math::Symbol.new("^"),
            text.is_a?(Slice) ? Transform.get_class("text").new(text.to_s) : text,
          ]
        end

        rule(binary: simple(:function), "^": simple(:exponent),
             unary: simple(:unary)) do
          [
            function,
            Plurimath::Math::Symbol.new("^"),
            unary,
          ]
        end

        Constants::UNARY_CLASSES.each do |unary_class|
          rule(binary_class => simple(:function),
               _: simple(:base),
               unary_class => simple(:unary)) do
            unary_class = Transform.get_class(unary).new
            Transform.get_class(binary_class).new(unary_class, nil)
          end

          rule(binary_class => simple(:function),
               "^": simple(:base),
               unary_class => simple(:unary)) do
            unary_class = Transform.get_class(unary).new
            Transform.get_class(binary_class).new(nil, unary_class)
          end
        end
      end

      rule(sequance: simple(:sequance), expr: simple(:exp)) { [sequance, exp] }

      def self.get_class(text)
        Object.const_get("Plurimath::Math::Function::#{text.to_s.capitalize}")
      end
    end
  end
end
