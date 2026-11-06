# frozen_string_literal: true

module Plurimath
  class Latex
    class Mapper
      # The rule table that reads the capture tree of a latexmath model node
      # (see Mapper#captures). It unwraps the values the mapper built and
      # builds the single-capture nodes the mapper left as captures; nodes
      # with several captures are built by Mapper::TYPED.
      class Rules < Parsanol::Transform
        include Plurimath::BaseNumberPrefix::Transform

        # A leaf the mapper built from the model (Mapper::LEAVES).
        rule(built: simple(:built))     { built }
        # A list the mapper built (Mapper#typed), read as the list itself.
        rule(spliced: sequence(:list))  { list }
        rule(base: simple(:base))       { base }
        rule(over: simple(:over))       { over }
        rule(number: simple(:num))      { Math::Number.new(Utility.html_entity_to_unicode(num.to_s)) }
        rule(power: simple(:power))     { power }
        rule(unary: simple(:unary))     { Utility.get_class(unary).new }
        rule(space: simple(:space))     { Math::Function::Text.new(" ") }
        rule(operant: simple(:oper))    do
          Utility.symbols_class(oper, lang: :latex)
        end
        rule(symbol: simple(:symbol))   do
          Utility.symbols_class(symbol, lang: :latex)
        end
        rule(lparen: simple(:lparen))   do
          Utility.symbols_class(lparen, lang: :latex)
        end
        rule(rparen: simple(:rparen))   do
          Utility.symbols_class(rparen, lang: :latex)
        end
        rule(limits: simple(:limits))   { limits }
        rule("\\\\" => simple(:slash))  { Math::Function::Linebreak.new }
        # Native named captures use symbol keys; Ruby retains the declared string.
        rule("\\\\": simple(:slash)) { Math::Function::Linebreak.new }
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
          binary.is_a?(Parsanol::Slice) ? Utility.get_class(binary).new : binary
        end

        rule(symbols: simple(:sym)) do
          Utility.symbols_class(sym, lang: :latex)
        end

        rule(expression: sequence(:expr)) do
          Math::Formula.new(expr)
        end
      end
    end
  end
end
