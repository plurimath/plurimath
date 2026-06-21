# frozen_string_literal: true

module Plurimath
  class Html
    class Transform < Parslet::Transform
      rule(text: simple(:text))      { Math::Function::Text.new(text) }
      rule(unary: simple(:unary))    { Utility.get_class(unary).new }
      rule(symbol: simple(:symbol)) { TransformUtility.symbol(symbol) }
      rule(number: simple(:number)) { Math::Number.new(number) }
      rule(linebreak: simple(:_linebreak)) { Math::Function::Linebreak.new }
      rule(expression: simple(:exp)) { exp }

      rule(linebreak: simple(:_linebreak),
           expression: simple(:expr)) do
        [
          Math::Function::Linebreak.new,
          expr,
        ]
      end

      rule(linebreak: simple(:_linebreak),
           expression: sequence(:expr)) do
        [Math::Function::Linebreak.new] + expr
      end

      rule(expression: sequence(:exp))    { exp }
      rule(sequence: simple(:sequence))   { sequence }
      rule(tr_value: simple(:tr_value))   { Math::Function::Tr.new([tr_value]) }
      rule(tr_value: sequence(:tr_value)) { Math::Function::Tr.new(tr_value) }
      rule(td_value: simple(:td_value))   { Math::Function::Td.new([td_value]) }
      rule(sequence: sequence(:sequence)) { sequence }
      rule(td_value: sequence(:td_value)) { Math::Function::Td.new(td_value) }

      rule(parse_parenthesis: simple(:parse_paren)) { parse_paren }
      rule(unary_function: simple(:unary_function)) { unary_function }

      rule(table_value: simple(:table_value)) do
        Math::Function::Table.new([table_value])
      end

      rule(table_value: sequence(:table_value)) do
        Math::Function::Table.new(table_value)
      end

      rule(sum_prod: simple(:sum_prod)) do
        Utility.get_class(
          Constants::SUB_SUP_CLASSES[sum_prod.to_sym],
        ).new
      end

      rule(sequence: simple(:sequence),
           expression: simple(:expr)) do
        [sequence, expr]
      end

      rule(sequence: simple(:sequence),
           parse_parenthesis: simple(:parse_paren)) do
        [sequence, parse_paren]
      end

      rule(sequence: simple(:sequence),
           expression: sequence(:expr)) do
        expr.insert(0, sequence)
      end

      rule(sequence: sequence(:sequence),
           expression: simple(:expr)) do
        sequence << expr
      end

      rule(tr_value: simple(:tr_value),
           expression: simple(:expr)) do
        [
          Math::Function::Tr.new([tr_value]),
          expr,
        ]
      end

      rule(tr_value: simple(:tr_value),
           expression: sequence(:expr)) do
        expr.insert(
          0,
          Math::Function::Tr.new([tr_value]),
        )
      end

      rule(td_value: simple(:td_value),
           expression: simple(:expr)) do
        [
          Math::Function::Td.new([td_value]),
          expr,
        ]
      end

      rule(td_value: simple(:td_value),
           expression: sequence(:expr)) do
        expr.insert(
          0,
          Math::Function::Td.new([td_value]),
        )
      end

      rule(unary_function: simple(:unary_function),
           sequence: simple(:sequence)) do
        Math::Formula.new(
          [
            unary_function,
            sequence,
          ],
        )
      end

      rule(unary_function: simple(:unary_function),
           sequence: sequence(:sequence)) do
        Math::Formula.new(
          [unary_function] + sequence,
        )
      end

      rule(text: simple(:text),
           expression: simple(:expr)) do
        [
          Math::Function::Text.new(text),
          expr,
        ]
      end

      rule(text: simple(:text),
           expression: sequence(:expr)) do
        [Math::Function::Text.new(text)] + expr
      end

      rule(symbol: simple(:symbol),
           expression: simple(:expr)) do
        [
          TransformUtility.symbol(symbol),
          expr,
        ]
      end

      rule(symbol: simple(:symbol),
           expression: sequence(:expr)) do
        [TransformUtility.symbol(symbol)] + expr
      end

      rule(number: simple(:number),
           expression: sequence(:expr)) do
        [Math::Number.new(number)] + expr
      end

      rule(number: simple(:number),
           expression: simple(:expr)) do
        [
          Math::Number.new(number),
          expr,
        ]
      end

      rule(text: simple(:text),
           parse_parenthesis: simple(:parse_paren)) do
        Math::Formula.new(
          [
            Math::Function::Text.new(text),
            parse_paren,
          ],
        )
      end

      rule(unary: simple(:unary),
           first_value: simple(:first_value)) do
        Utility.get_class(unary).new(first_value)
      end

      rule(symbol: simple(:symbol),
           parse_parenthesis: simple(:parse_paren)) do
        [
          TransformUtility.symbol(symbol),
          parse_paren,
        ]
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: simple(:sub_value)) do
        TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value)
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: sequence(:sub_value)) do
        TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value)
      end

      rule(sub_sup: simple(:sub_sup),
           sup_value: simple(:sup_value)) do
        TransformUtility.sub_sup_value(sub_sup, sup_value: sup_value)
      end

      rule(sub_sup: simple(:sub_sup),
           sup_value: sequence(:sup_value)) do
        TransformUtility.sub_sup_value(sub_sup, sup_value: sup_value)
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: simple(:sub_value),
           sup_value: simple(:sup_value)) do
        TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value,
                                                sup_value: sup_value)
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: simple(:sub_value),
           sup_value: sequence(:sup_value)) do
        TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value,
                                                sup_value: sup_value)
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: sequence(:sub_value),
           sup_value: simple(:sup_value)) do
        TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value,
                                                sup_value: sup_value)
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: sequence(:sub_value),
           sup_value: sequence(:sup_value)) do
        TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value,
                                                sup_value: sup_value)
      end

      # Parslet emits separate shapes for each sub/sup value combination and
      # trailing expression form. Keep this cluster mechanical: build the
      # sub/sup node, then append the remaining expression in input order.
      rule(sub_sup: simple(:sub_sup),
           sup_value: sequence(:sup_value),
           expression: simple(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sup_value: sup_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: simple(:sub_value),
           expression: simple(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: simple(:sub_value),
           expression: sequence(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: sequence(:sub_value),
           expression: simple(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: sequence(:sub_value),
           expression: sequence(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sup_value: simple(:sup_value),
           expression: simple(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sup_value: sup_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sup_value: simple(:sup_value),
           expression: sequence(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sup_value: sup_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sup_value: sequence(:sup_value),
           expression: sequence(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sup_value: sup_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: simple(:sub_value),
           sup_value: simple(:sup_value),
           expression: simple(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value,
                                                  sup_value: sup_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: simple(:sub_value),
           sup_value: simple(:sup_value),
           expression: sequence(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value,
                                                  sup_value: sup_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: simple(:sub_value),
           sup_value: sequence(:sup_value),
           expression: simple(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value,
                                                  sup_value: sup_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: simple(:sub_value),
           sup_value: sequence(:sup_value),
           expression: sequence(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value,
                                                  sup_value: sup_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: sequence(:sub_value),
           sup_value: simple(:sup_value),
           expression: simple(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value,
                                                  sup_value: sup_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: sequence(:sub_value),
           sup_value: simple(:sup_value),
           expression: sequence(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value,
                                                  sup_value: sup_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: sequence(:sub_value),
           sup_value: sequence(:sup_value),
           expression: simple(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value,
                                                  sup_value: sup_value),
          expression,
        )
      end

      rule(sub_sup: simple(:sub_sup),
           sub_value: sequence(:sub_value),
           sup_value: sequence(:sup_value),
           expression: sequence(:expression)) do
        TransformUtility.append_expression(
          TransformUtility.sub_sup_value(sub_sup, sub_value: sub_value,
                                                  sup_value: sup_value),
          expression,
        )
      end

      rule(lparen: simple(:lparen),
           text: simple(:text),
           rparen: simple(:rparen)) do
        Math::Formula.new([
                            Utility.symbols_class(lparen, lang: :html),
                            Math::Function::Text.new(text),
                            Utility.symbols_class(rparen, lang: :html),
                          ])
      end

      rule(lparen: simple(:lparen),
           sequence: simple(:sequence),
           rparen: simple(:rparen)) do
        Math::Formula.new([
                            Utility.symbols_class(lparen, lang: :html),
                            sequence,
                            Utility.symbols_class(rparen, lang: :html),
                          ])
      end

      rule(lparen: simple(:lparen),
           sequence: simple(:sequence),
           parse_parenthesis: simple(:parse_paren),
           rparen: simple(:rparen)) do
        Math::Formula.new([
                            Utility.symbols_class(lparen, lang: :html),
                            sequence,
                            parse_paren,
                            Utility.symbols_class(rparen, lang: :html),
                          ])
      end

      rule(lparen: simple(:lparen),
           sequence: sequence(:sequence),
           rparen: simple(:rparen)) do
        Math::Formula.new([
                            Utility.symbols_class(lparen, lang: :html),
                            Utility.filter_values(sequence),
                            Utility.symbols_class(rparen, lang: :html),
                          ])
      end

      rule(lparen: simple(:lparen),
           number: simple(:number),
           rparen: simple(:rparen)) do
        Math::Formula.new([
                            Utility.symbols_class(lparen, lang: :html),
                            Math::Number.new(number),
                            Utility.symbols_class(rparen, lang: :html),
                          ])
      end

      rule(lparen: simple(:lparen),
           unary_function: simple(:unary_function),
           rparen: simple(:rparen)) do
        Math::Formula.new([
                            Utility.symbols_class(lparen, lang: :html),
                            unary_function,
                            Utility.symbols_class(rparen, lang: :html),
                          ])
      end

      rule(binary: simple(:binary),
           first_value: simple(:first_value),
           second_value: simple(:second_value)) do
        Utility.get_class(binary).new(first_value, second_value)
      end

      rule(first_value: sequence(:first_value),
           binary: simple(:binary),
           second_value: sequence(:second_value)) do
        Utility.get_class(binary).new(
          Utility.filter_values(first_value),
          Utility.filter_values(second_value),
        )
      end

      rule(lparen: simple(:lparen),
           text: simple(:text),
           expression: sequence(:expression),
           rparen: simple(:rparen)) do
        Math::Formula.new(
          (
            [
              Utility.symbols_class(lparen, lang: :html),
              Math::Function::Text.new(text),
            ] + expression
          ) << Utility.symbols_class(rparen, lang: :html),
        )
      end

      rule(lparen: simple(:lparen),
           text: simple(:text),
           expression: simple(:expression),
           rparen: simple(:rparen)) do
        Math::Formula.new([
                            Utility.symbols_class(lparen, lang: :html),
                            Math::Function::Text.new(text),
                            expression,
                            Utility.symbols_class(rparen, lang: :html),
                          ])
      end

      rule(lparen: simple(:lparen),
           number: simple(:number),
           expression: simple(:expression),
           rparen: simple(:rparen)) do
        Math::Formula.new([
                            Utility.symbols_class(lparen, lang: :html),
                            Math::Number.new(number),
                            expression,
                            Utility.symbols_class(rparen, lang: :html),
                          ])
      end

      rule(lparen: simple(:lparen),
           number: simple(:number),
           expression: sequence(:expression),
           rparen: simple(:rparen)) do
        Math::Formula.new(
          (
            [
              Utility.symbols_class(lparen, lang: :html),
              Math::Number.new(number),
            ] +
            expression
          ) << Utility.symbols_class(rparen, lang: :html),
        )
      end
    end
  end
end
