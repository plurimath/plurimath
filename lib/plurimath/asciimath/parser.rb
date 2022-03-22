# frozen_string_literal: true

require "parslet"
require "parslet/convenience"
require_relative "constants"
module Plurimath
  class Asciimath
    class MiniT < Parslet::Transform
      rule(number: simple(:number)) { Plurimath::Math::Number.new(number) }
      Constants::SYMBOLS.each do |sy_cl|
        rule("#{sy_cl[0]}": simple(:function)) { Plurimath::Math::Symbol.new(sy_cl[0].to_s) }
      end
      Constants::UNARY_CLASSES.each do |sy_cl|
        rule("#{sy_cl[0]}": simple(:function), intermediate_exp: simple(:int_exp)) {
          Object.const_get("Plurimath::Math::Function::#{function.to_s.capitalize}").new(int_exp)
        }
      end
      Constants::BINARY_CLASSES.each do |sy_cl|
        rule("#{sy_cl[0]}": simple(:function), intermediate_exp: simple(:int_exp)) {
          Object.const_get("Plurimath::Math::Function::#{function.to_s.capitalize}").new(int_exp)
        }
      end

      # rule(sin: simple(:sin), intermediate_exp: simple(:express)) { Plurimath::Math::Function::Sin.new(express) }
      # rule(cos: simple(:cos), intermediate_exp: simple(:express)) {
      #  Plurimath::Math::Function::Cos.new(express)
      # }
      rule(unary: simple(:unary)) { unary }
      rule("(": simple(:left_paren), expr: simple(:expr), ")": simple(:right_paren)) {
        lp = Plurimath::Math::Symbol.new(left_paren.to_s)
        exp = expr
        rp = Plurimath::Math::Symbol.new(right_paren.to_s)
        Plurimath::Math::Formula.new([lp, exp, rp])
      }
      rule("{": simple(:left_paren), expr: simple(:expr), "}": simple(:right_paren)) {
        lp = Plurimath::Math::Symbol.new(left_paren.to_s)
        exp = expr
        rp = Plurimath::Math::Symbol.new(right_paren.to_s)
        Plurimath::Math::Formula.new([lp, exp, rp])
      }
      rule(power_base: subtree(:power_base)) {
        new_klass = nil
        base = []
        exponent = []
        power_base.each do |key, value|
          if key == :"^"
            base = exponent
            exponent = []
            next
          end

          next if :_ == key

          if Constants::SYMBOLS_AND_CLASSES[key.to_sym] == :class
            new_klass = Object.const_get("Plurimath::Math::Function::#{key.to_s.capitalize}")
          elsif value.kind_of? Slice
            exponent << Plurimath::Math::Symbol.new(value.to_s)
          else
            exponent << value
          end
        end
        new_klass.new(base, exponent)
      }
      rule(power: subtree(:power)) {
        new_klass = nil
        exponent = []
        power.each do |key, value|
          next if key == :"^"

          if Constants::SYMBOLS_AND_CLASSES[key.to_sym] == :class
            new_klass = Object.const_get("Plurimath::Math::Function::#{key.to_s.capitalize}")
          elsif value.kind_of? Slice
            exponent << Plurimath::Math::Symbol.new(value.to_s)
          else
            exponent << value
          end
        end
        new_klass.new(exponent)
      }
      rule(base: subtree(:base)) {
        new_klass = nil
        new_symbols = []
        base.each do |key, value|
          next if key == :_

          if Constants::SYMBOLS_AND_CLASSES[key.to_sym] == :class
            new_klass = Object.const_get("Plurimath::Math::Function::#{key.to_s.capitalize}")
          elsif value.kind_of? Slice
            new_symbols << Plurimath::Math::Symbol.new(value.to_s)
          else
            new_symbols << value
          end
        end
        new_klass.new(new_symbols) unless new_klass.nil?
      }
      rule(symbol: subtree(:symbol)) { Plurimath::Math::Symbol.new(symbol.to_s) }
      rule(intermediate_exp: subtree(:intermediate_exp)) { intermediate_exp }
      rule(sequance: simple(:sequance), expr: simple(:expr)) {
        unless sequance.is_a?(Plurimath::Math::Symbol) || sequance.is_a?(Plurimath::Math::Number)
          sequance.new(expr)
        else
          [sequance, expr]
        end
      }
      rule(sequance: subtree(:sequance)) { sequance }
      rule(expr: subtree(:expr)) { expr }
    end

    class MiniP < Parslet::Parser
      rule(:symbols) {
        Constants::SYMBOLS.reduce do |expression, exp_string|
          expression = str(expression[0]).as(expression[0]) if expression.is_a?(Array)
          expression.send(:|, str(exp_string[0]).as(exp_string[0]))
        end
      }
      rule(:symbol_text_or_integer) { symbols | unary | binary | match['a-zA-Z'].as(:symbol) | match('[0-9]').repeat(1).as(:number) }
      rule(:unary) {
        Constants::UNARY_CLASSES.reduce do |expression, exp_string|
          expression = str(expression[0]).as(expression[0]) if expression.is_a?(Array)
          expression.send(:|, str(exp_string[0]).as(exp_string[0]))
        end
      }
      rule(:binary) {
        Constants::BINARY_CLASSES.reduce do |expression, exp_string|
          expression = str(expression[0]).as(expression[0]) if expression.is_a?(Array)
          expression.send(:|, str(exp_string[0]).as(exp_string[0]))
        end
      }
      rule(:lparen) {
        Constants::LPAREN.reduce do |expression, exp_string|
          expression = str(expression[0]).as(expression[0]) if expression.is_a?(Array)
          expression.send(:|, str(exp_string[0]).as(exp_string[0]))
        end
      }
      rule(:rparen) {
        Constants::RPAREN.reduce do |expression, exp_string|
          expression = str(expression[0]).as(expression[0]) if expression.is_a?(Array)
          expression.send(:|, str(exp_string[0]).as(exp_string[0]))
        end
      }
      rule(:sequance) { (lparen >> expression >> rparen).as(:intermediate_exp) | (unary >> sequance).as(:unary) | (binary >> sequance >> sequance).as(:binary) | symbol_text_or_integer }
      rule(:power) { str('^').as(:'^') }
      rule(:base) { str('_').as(:'_') }
      rule(:iteration) { (sequance >> base >> sequance >> power >> sequance).as(:power_base) | (sequance >> base >> sequance).as(:base) | (sequance >> power >> sequance).as(:power) | sequance.as(:sequance) }
      rule(:expression) { (iteration >> expression).as(:expr) | (iteration >> str('/').as(:'/') >> iteration).as(:expr) | iteration.as(:expr) }
      rule(:conclude) { expression }
      root :conclude
    end

    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text.string.gsub(' ', '')
      end

      def parse
        @new_nodes = MiniP.new.parse_with_debug(text)
        tree_t = Plurimath::Asciimath::MiniT.new.apply(@new_nodes)
        Plurimath::Math::Formula.new([tree_t])
      end
    end
  end
end
