# frozen_string_literal: true

module Plurimath
  class UnicodeMath
    class Transform < Parslet::Transform

      rule(td: simple(:td)) { Math::Function::Td.new([td]) }
      rule(tr: simple(:tr)) { Math::Function::Tr.new([tr]) }

      rule(sub: simple(:sub)) { sub }
      rule(trs: simple(:trs)) { trs }
      rule(exp: simple(:exp)) { exp }
      rule(tr: sequence(:tr)) { Math::Function::Tr.new(tr) }
      rule(td: sequence(:td)) { Math::Function::Td.new(td) }

      rule(exp: sequence(:exp)) { exp }
      rule(atom: simple(:atom)) { atom }
      rule(rect: simple(:rect)) { rect }
      rule(nary: simple(:nary)) { nary }
      rule(char: simple(:char)) { char }
      rule(expr: simple(:expr)) { expr }
      rule(frac: simple(:frac)) { frac }
      rule(root: simple(:root)) { root }
      rule(text: simple(:text)) { Math::Function::Text.new(text) }

      rule(sub_exp: simple(:exp)) { exp }
      rule(sup_exp: simple(:exp)) { exp }
      rule(int_exp: simple(:exp)) { exp }
      rule(atom: sequence(:atom)) { atom }
      rule(expr: sequence(:expr)) { expr }
      rule(table: simple(:table)) { table }
      rule(fonts: simple(:fonts)) { fonts }
      rule(digit: simple(:digit)) { digit }
      rule(color: simple(:color)) { color }
      rule(ldots: simple(:ldots)) { ldots }

      rule(sub_exp: sequence(:exp)) { exp }
      rule(factor: simple(:factor)) { factor }
      rule(hbrack: simple(:hbrack)) { hbrack }
      rule(symbol: simple(:symbol)) { Math::Symbol.new(symbol) }
      rule(number: simple(:number)) { Math::Number.new(number) }

      rule(backcolor: simple(:color)) { color }
      rule(sub_paren: simple(:paren)) { paren }
      rule(factor: sequence(:factor)) { factor }
      rule(operand: simple(:operand)) { operand }
      rule(accents: subtree(:accent)) { Utility.unicode_accents(accent) }
      rule(sup_alpha: simple(:alpha)) { Math::Symbol.new(Constants::SUP_ALPHABETS.key(alpha).to_s, mini_sup_sized: true) }

      rule(sub_script: simple(:script)) { script }
      rule(sup_script: simple(:script)) { script }
      rule(pre_script: simple(:script)) { script }
      rule(operand: sequence(:operand)) { operand }
      rule(mini_sup: simple(:mini_sup)) { mini_sup }
      rule(mini_sub: simple(:mini_sub)) { mini_sub }
      rule(close_paren: simple(:paren)) { Math::Symbol.new(paren) }
      rule(operator: simple(:operator)) { Math::Symbol.new(operator) }

      rule(unary_sub_sup: simple(:unary)) { unary }
      rule(sub_script: sequence(:script)) { script }
      rule(sup_script: sequence(:script)) { script }
      rule(mini_sub: sequence(:mini_sub)) { mini_sub }
      rule(monospace: simple(:monospace)) { monospace }

      rule(intermediate_exp: simple(:expr))  { expr }
      rule(decimal_number: simple(:number))  { number }
      rule(accents_subsup: simple(:subsup))  { subsup }
      rule(subsup_exp: simple(:subsup_exp))  { subsup_exp }
      rule(expression: simple(:expression))  { expression }
      rule(open_paren: simple(:open_paren))  { Math::Symbol.new(open_paren) }
      rule(override_subsup: simple(:subsup)) { subsup }

      rule(intermediate_exp: sequence(:expr)) { expr }
      rule(diacritic_belows: simple(:belows)) { belows }
      rule(unary_function: simple(:function)) { function }
      rule(sup_recursion: simple(:recursion)) { recursion }
      rule(nary_sub_sup: simple(:subsup_exp)) { subsup_exp }
      rule(open_paren: sequence(:open_paren)) { open_paren }

      rule(diacritics_accents: simple(:accent)) { accent }
      rule(mini_sub_sup: simple(:mini_sub_sup)) { mini_sub_sup }
      rule(unary_subsup: simple(:unary_subsup)) { unary_subsup }
      rule(exclamation_symbol: simple(:symbol)) { Math::Symbol.new(symbol) }
      rule(alphanumeric: simple(:alphanumeric)) { Math::Symbol.new(alphanumeric) }

      rule(diacritic_overlays: simple(:overlays)) { overlays }
      rule(mini_sub_sup: sequence(:mini_sub_sup)) { mini_sub_sup }
      rule(unicode_fractions: simple(:fractions)) { Utility.unicode_fractions(fractions) }
      rule(mini_intermediate_exp: simple(:mini_expr)) { mini_expr }

      rule(combined_symbols: simple(:combined_symbols)) do
        Math::Symbol.new(Constants::COMBINING_SYMBOLS[combined_symbols.to_sym] || combined_symbols)
      end

      rule(spaces: simple(:spaces)) do
        Math::Symbol.new(
          (Constants::SKIP_SYMBOLS[spaces.to_sym] || spaces),
          options: { space: true },
        )
      end

      rule(binary_symbols: simple(:symbols)) do
        symbol = (Constants::BINARY_SYMBOLS[symbols.to_sym] || symbols)
        Math::Symbol.new(symbol)
      end

      rule(sup_operators: simple(:operator)) do
        op = Constants::SUP_OPERATORS.key(operator).to_s
        Math::Symbol.new(op, mini_sup_sized: true)
      end

      rule(prefixed_prime: simple(:prime)) do
        Math::Symbol.new(Constants::PREFIXED_PRIMES[prime.to_sym])
      end

      rule(unary_functions: simple(:unary)) do
        if Constants::UNDEF_UNARY_FUNCTIONS.include?(unary.to_s)
          Math::Symbol.new(unary)
        else
          Utility.get_class(unary).new
        end
      end

      rule(negated_operator: simple(:operator)) do
        Math::Formula.new([
          Math::Symbol.new(operator),
          Math::Symbol.new("&#x338;"),
        ])
      end

      rule(slashed_value: simple(:value)) do
        decoded = HTMLEntities.new.decode(value)
        if decoded.to_s.match?(/^\w+/)
          Math::Function::Text.new("\\#{decoded}")
        else
          Math::Symbol.new(decoded, true)
        end
      end

      rule(slashed_value: sequence(:values)) do
        values.each.with_index do |value, index|
          decoded = HTMLEntities.new.decode(value.value)
          slashed = if decoded.to_s.match?(/^\w+/)
                      Math::Function::Text.new("\\#{decoded}")
                    else
                      Math::Symbol.new(decoded, true)
                    end
          values[index] = slashed
        end
        values
      end

      rule(ordinary_symbols: simple(:ordinary)) do
        Math::Symbol.new(
          (Constants::ORDINARY_SYMBOLS[ordinary.to_sym] || ordinary),
        )
      end

      rule(relational_symbols: simple(:symbol)) do
        Math::Symbol.new(
          (Constants::RELATIONAL_SYMBOLS[symbol.to_sym] || symbol),
        )
      end

      rule(unicode_symbols: simple(:unicode_symbols)) do
        Math::Symbol.new(unicode_symbols)
      end

      rule(monospace_value: simple(:monospace_value)) do
        Math::Function::FontStyle::Monospace.new(
          Math::Symbol.new(monospace_value),
        )
      end

      rule(sup_digits: simple(:digits)) do
        digit = Constants::SUP_DIGITS.key(digits).to_s
        Math::Number.new(digit, mini_sup_sized: true)
      end

      rule(sub_digits: simple(:digits)) do
        digit = Constants::SUB_DIGITS.key(digits).to_s
        Math::Number.new(digit, mini_sub_sized: true)
      end

      rule(nary_class: simple(:nary_class)) do
        nary = nary_class.to_s
        nary_function = if Constants::NARY_CLASSES.key?(nary.to_sym)
                          nary
                        else
                          Constants::NARY_CLASSES.invert[nary]
                        end
        Utility.get_class(nary_function).new 
      end

      rule(ordinary_negated_operator: simple(:operator)) do
        Math::Formula.new([
          Math::Symbol.new(operator),
          Math::Symbol.new("&#x338;"),
        ])
      end

      rule(decimal: simple(:decimal),
           whole: simple(:whole)) do
        Math::Number.new("#{decimal}#{whole.value}")
      end

      rule(unicode_fractions: simple(:fractions),
           expr: sequence(:expr)) do
        [Utility.unicode_fractions(fractions)] + expr
      end

      rule(unicode_fractions: simple(:fractions),
           expr: simple(:expr)) do
        [Utility.unicode_fractions(fractions), expr]
      end

      rule(diacritics_accents: simple(:accents),
           expr: sequence(:expr)) do
        [accents] + expr
      end

      rule(unicoded_font_class: simple(:unicoded),
           symbol: simple(:symbol)) do
        unicode = Constants::UNICODED_FONTS.dig(
          unicoded.to_sym,
          symbol.to_sym,
        )
        Math::Symbol.new(unicode)
      end

      rule(number: simple(:number),
           symbol: simple(:symbol)) do
        [
          Math::Number.new(number),
          Math::Symbol.new(symbol),
        ]
      end

      rule(symbol: simple(:symbol),
           naryand_recursion: sequence(:naryand_recursion)) do
        [
          Math::Symbol.new(symbol),
        ] + naryand_recursion
      end

      rule(symbol: simple(:symbol),
           naryand_recursion: simple(:naryand_recursion)) do
        [Math::Symbol.new(symbol), naryand_recursion]
      end

      rule(symbol: simple(:symbol),
           expr: simple(:expr)) do
        [Math::Symbol.new(symbol), expr]
      end

      rule(binary_symbols: simple(:symbols),
           expr: simple(:expr)) do
        symbol = (Constants::BINARY_SYMBOLS[symbols.to_sym] || symbols)
        [Math::Symbol.new(symbol), expr]
      end

      rule(binary_symbols: simple(:symbols),
           exp: sequence(:exp)) do
        symbol = (Constants::BINARY_SYMBOLS[symbols.to_sym] || symbols)
        [Math::Symbol.new(symbol)] + exp
      end

      rule(binary_symbols: simple(:symbols),
           expr: sequence(:expr)) do
        symbol = (Constants::BINARY_SYMBOLS[symbols.to_sym] || symbols)
        [Math::Symbol.new(symbol)] + expr
      end

      rule(binary_symbols: simple(:symbols),
           naryand_recursion: simple(:naryand_recursion)) do
        symbol = (Constants::BINARY_SYMBOLS[symbols.to_sym] || symbols)
        [Math::Symbol.new(symbol), naryand_recursion]
      end

      rule(binary_symbols: simple(:symbols),
           recursive_denominator: simple(:recursive_denominator)) do
        symbol = (Constants::BINARY_SYMBOLS[symbols.to_sym] || symbols)
        [Math::Symbol.new(symbol), recursive_denominator]
      end

      rule(binary_symbols: simple(:symbols),
           recursive_denominator: sequence(:recursive_denominator)) do
        symbol = (Constants::BINARY_SYMBOLS[symbols.to_sym] || symbols)
        [Math::Symbol.new(symbol)] + recursive_denominator
      end

      rule(binary_symbols: simple(:symbols),
           recursive_numerator: simple(:recursive_numerator)) do
        symbol = (Constants::BINARY_SYMBOLS[symbols.to_sym] || symbols)
        [Math::Symbol.new(symbol), recursive_numerator]
      end

      rule(number: simple(:number),
           expr: simple(:expr)) do
        [Math::Number.new(number), expr]
      end

      rule(symbol: simple(:symbol),
           expr: sequence(:expr)) do
        [
          Math::Symbol.new(symbol),
        ] + expr
      end

      rule(number: simple(:number),
           expr: sequence(:expr)) do
        [
          Math::Number.new(number),
        ] + expr
      end

      rule(negated_operator: simple(:operator),
           expr: simple(:expr)) do
        [
          Math::Formula.new([
            Math::Symbol.new(operator),
            Math::Symbol.new("&#x338;"),
          ]),
          expr,
        ]
      end

      rule(negated_operator: simple(:operator),
           expr: sequence(:expr)) do
        [
          Math::Formula.new([
            Math::Symbol.new(operator),
            Math::Symbol.new("&#x338;"),
          ]),
        ] + expr
      end

      rule(ordinary_negated_operator: simple(:operator),
           expr: simple(:expr)) do
        [
          Math::Formula.new([
            Math::Symbol.new(operator),
            Math::Symbol.new("&#x338;"),
          ]),
          expr,
        ]
      end

      rule(accents: subtree(:accent),
           expr: sequence(:expr)) do
        [Utility.unicode_accents(accent)] + expr
      end

      rule(accents: subtree(:accent),
           exp: sequence(:exp)) do
        [Utility.unicode_accents(accent)] + exp
      end

      rule(text: simple(:text),
           expr: sequence(:expr)) do
        [Math::Function::Text.new(text)] + expr
      end

      rule(text: simple(:text),
           operand: simple(:operand)) do
        [Math::Function::Text.new(text), operand]
      end

      rule(text: simple(:text),
           operand: sequence(:operand)) do
        [Math::Function::Text.new(text)] + operand
      end

      rule(text: simple(:text),
           expr: simple(:expr)) do
        [Math::Function::Text.new(text), expr]
      end

      rule(subsup_exp: simple(:subsup),
           expr: sequence(:expr)) do
        [subsup] + expr
      end

      rule(override_subsup: simple(:subsup),
           expr: sequence(:expr)) do
        [subsup] + expr
      end

      rule(unary_subsup: simple(:subsup),
           expr: sequence(:expr)) do
        [subsup] + expr
      end

      rule(unary_subsup: simple(:subsup),
           expr: simple(:expr)) do
        [subsup, expr]
      end

      rule(char: simple(:char),
           alphanumeric: simple(:alphanumeric)) do
        [char, Math::Symbol.new(alphanumeric)]
      end

      rule(char: simple(:char),
           number: simple(:num)) do
        [char, Math::Number.new(num)]
      end

      rule(char: simple(:char),
           diacritics: simple(:diacritics)) do
        [char, diacritics]
      end

      rule(char: simple(:char),
           diacritics: sequence(:diacritics)) do
        [char] + diacritics
      end

      rule(fonts: simple(:fonts),
           expr: sequence(:expr)) do
        [fonts] + expr
      end

      rule(phantom: simple(:phantom),
           expr: sequence(:expr)) do
        [phantom] + expr
      end

      rule(subsup_exp: simple(:subsup),
           expr: simple(:expr)) do
        [subsup, expr]
      end

      rule(int_exp: simple(:int),
           expr: simple(:expr)) do
        [int, expr]
      end

      rule(operator: simple(:operator),
           expr: simple(:expr)) do
        [Math::Symbol.new(operator), expr]
      end

      rule(mid_symbol: simple(:mid_symbol),
           expr: simple(:expr)) do
        [Math::Symbol.new(mid_symbol), expr]
      end

      rule(mid_symbol: simple(:mid_symbol),
           expr: sequence(:expr)) do
        [Math::Symbol.new(mid_symbol)] + expr
      end

      rule(operator: simple(:operator),
           exp: simple(:exp)) do
        [Math::Symbol.new(operator), exp]
      end

      rule(unicode_symbols: simple(:unicode_symbols),
           exp: simple(:exp)) do
        [Math::Symbol.new(unicode_symbols), exp]
      end

      rule(unicode_symbols: simple(:unicode_symbols),
           expr: simple(:expr)) do
        [Math::Symbol.new(unicode_symbols), expr]
      end

      rule(unicode_symbols: simple(:unicode_symbols),
           exp: sequence(:exp)) do
        [Math::Symbol.new(unicode_symbols)] + exp
      end

      rule(unicode_symbols: simple(:unicode_symbols),
           expr: sequence(:expr)) do
        [Math::Symbol.new(unicode_symbols)] + expr
      end

      rule(atom: simple(:atom),
           atoms: simple(:atoms)) do
        [atom, atoms]
      end

      rule(atom: sequence(:atom),
           atoms: simple(:atoms)) do
        atom + [atoms]
      end

      rule(atom: simple(:atom),
           atoms: sequence(:atoms)) do
        [atom] + atoms
      end

      rule(operator: simple(:operator),
           expr: sequence(:expr)) do
        [Math::Symbol.new(operator)] + expr
      end

      rule(operator: simple(:operator),
           exp: sequence(:exp)) do
        [Math::Symbol.new(operator)] + exp
      end

      rule(operator: simple(:operator),
           sup_script: simple(:sup_script)) do
        [Math::Symbol.new(operator), sup_script]
      end

      rule(operator: simple(:operator),
           sup_script: sequence(:sup_script)) do
        [Math::Symbol.new(operator)] + sup_script
      end

      rule(combined_symbols: simple(:combined_symbols),
           sup_script: simple(:sup_script)) do
        symbol = Constants::COMBINING_SYMBOLS[combined_symbols.to_sym]
        [Math::Symbol.new(symbol), sup_script]
      end

      rule(operator: simple(:operator),
           sub_script: simple(:sub_script)) do
        [Math::Symbol.new(operator), sub_script]
      end

      rule(size_overrides: simple(:size_overrides),
           sub_script: simple(:sub_script)) do
        [size_overrides, sub_script]
      end

      rule(pre_script: simple(:pre_script),
           expr: sequence(:expr)) do
        [pre_script] + expr
      end

      rule(sub_digits: simple(:sub_digits),
           sub_recursion_expr: sequence(:sub_recursion_expr)) do
        digit = Constants::SUB_DIGITS.key(sub_digits).to_s
        [
          Math::Number.new(digit, mini_sub_sized: true)
        ] + sub_recursion_expr
      end

      rule(sub_digits: simple(:sub_digits),
           sub_recursion_expr: simple(:sub_recursion_expr)) do
        digit = Constants::SUB_DIGITS.key(sub_digits).to_s
        [Math::Number.new(digit, mini_sub_sized: true), sub_recursion_expr]
      end

      rule(sup_alpha: simple(:sup_alpha),
           sup_recursion_expr: sequence(:sup_recursion_expr)) do
        alpha = Constants::SUP_ALPHABETS.key(sup_alpha)
        [
          Math::Symbol.new(alpha.to_s, mini_sup_sized: true)
        ] + sup_recursion_expr
      end

      rule(sup_alpha: simple(:sup_alpha),
           sup_recursion_expr: simple(:sup_recursion_expr)) do
        alpha = Constants::SUP_ALPHABETS.key(sup_alpha)
        [
          Math::Symbol.new(alpha.to_s, mini_sup_sized: true),
          sup_recursion_expr,
        ]
      end

      rule(sup_digits: simple(:digits),
           sup_recursion_expr: sequence(:sup_recursion_expr)) do
        digit = Constants::SUP_DIGITS.key(digits).to_s
        [
          Math::Number.new(digit, mini_sup_sized: true)
        ] + sup_recursion_expr
      end

      rule(sup_digits: simple(:digits),
           sup_recursion_expr: simple(:sup)) do
        digit = Constants::SUP_DIGITS.key(digits).to_s
        [Math::Number.new(digit, mini_sup_sized: true), sup]
      end

      rule(labeled_tr_value: sequence(:value),
           labeled_tr_id: simple(:id)) do
        Math::Function::Mlabeledtr.new(
          Utility.filter_values(value),
          Math::Function::Text.new(id),
        )
      end

      rule(labeled_tr_value: simple(:value),
           labeled_tr_id: simple(:id)) do
        Math::Function::Mlabeledtr.new(
          value,
          Math::Function::Text.new(id),
        )
      end

      rule(operator: simple(:operator),
           sup_recursion: simple(:sup_recursion)) do
        Utility.sort_sup(
          Math::Symbol.new(operator),
          Utility.unfenced_value(sup_recursion, paren_specific: true),
        )
      end

      rule(operator: simple(:operator),
           sub_recursion: simple(:sub_recursion)) do
        Utility.sort_sub(
          Math::Symbol.new(operator),
          sub_recursion,
        )
      end

      rule(operator: simple(:operator),
           sub_recursion: sequence(:sub_recursion)) do
        [Math::Symbol.new(operator)] + sub_recursion
      end

      rule(sub_script: simple(:sub_script),
           sub_recursion: simple(:sub_recursion)) do
        Utility.sort_sub(sub_script, sub_recursion)
      end

      rule(sub_operators: simple(:operator),
           sub_recursions: simple(:recursions)) do
        op = Constants::SUB_OPERATORS.key(operator).to_s
        [Math::Symbol.new(op, mini_sub_sized: true), recursions]
      end

      rule(sub_operators: simple(:operator),
           sub_recursions: sequence(:recursions)) do
        op = Constants::SUB_OPERATORS.key(operator).to_s
        [Math::Symbol.new(op, mini_sub_sized: true)] + recursions
      end

      rule(sup_operators: simple(:operator),
           sup_recursions: simple(:recursions)) do
        op = Constants::SUP_OPERATORS.key(operator).to_s
        [Math::Symbol.new(op, mini_sup_sized: true), recursions]
      end

      rule(digit: simple(:digit),
           recursive_denominator: simple(:recursive_denominator)) do
        [
          digit,
          recursive_denominator,
        ]
      end

      rule(relational_symbols: simple(:symbols),
           recursive_denominator: simple(:recursive_denominator)) do
        symbol = Constants::RELATIONAL_SYMBOLS[symbols.to_sym] || symbols
        [
          Math::Symbol.new(symbol.to_s),
          recursive_denominator,
        ]
      end

      rule(atom: simple(:atom),
           recursive_denominator: simple(:recursive_denominator)) do
        [atom, recursive_denominator]
      end

      rule(atom: simple(:atom),
           recursive_denominator: sequence(:recursive_denominator)) do
        [atom] + recursive_denominator
      end

      rule(atom: sequence(:atom),
           recursive_denominator: simple(:recursive_denominator)) do
        atom + [recursive_denominator]
      end

      rule(atom: sequence(:atom),
           recursive_numerator: simple(:recursive_numerator)) do
        atom + [recursive_numerator]
      end

      rule(atom: sequence(:atom),
           recursive_denominator: sequence(:recursive_denominator)) do
        atom + recursive_denominator
      end

      rule(accents_subsup: simple(:accents_subsup),
           expr: simple(:expr)) do
        [accents_subsup, expr]
      end

      rule(accents_subsup: simple(:accents_subsup),
           expr: sequence(:expr)) do
        [accents_subsup] + expr
      end

      rule(accents_subsup: simple(:accents_subsup),
           exp: simple(:exp)) do
        [accents_subsup, exp]
      end

      rule(accents_subsup: simple(:accents_subsup),
           naryand_recursion: simple(:naryand_recursion)) do
        [accents_subsup, naryand_recursion]
      end

      rule(sup_exp: simple(:sup_exp),
           naryand_recursion: sequence(:naryand_recursion)) do
        [sup_exp] + naryand_recursion
      end

      rule(nary: simple(:nary),
           naryand_recursion: simple(:naryand_recursion)) do
        [nary, naryand_recursion]
      end

      rule(factor: simple(:factor),
           operand: simple(:operand)) do
        [factor, operand]
      end

      rule(factor: simple(:factor),
           unary_subsup: simple(:subsup)) do
        [factor, subsup]
      end

      rule(factor: simple(:factor),
           operand: sequence(:operand)) do
        [factor] + operand
      end

      rule(factor: simple(:factor),
           unary_subsup: sequence(:subsup)) do
        [factor] + subsup
      end

      rule(sup_exp: simple(:sup_exp),
           expr: simple(:expr)) do
        [sup_exp, expr]
      end

      rule(sup_exp: simple(:sup_exp),
           exp: simple(:exp)) do
        [sup_exp, exp]
      end

      rule(sub_exp: simple(:sub_exp),
           expr: sequence(:expr)) do
        [sub_exp] + expr
      end

      rule(sub_exp: sequence(:sub_exp),
           expr: sequence(:expr)) do
        sub_exp + expr
      end

      rule(sub_exp: simple(:sub_exp),
           exp: sequence(:exp)) do
        [sub_exp] + exp
      end

      rule(sub_exp: simple(:sub_exp),
           expr: simple(:expr)) do
        [sub_exp, expr]
      end

      rule(sub_exp: simple(:sub_exp),
           exp: simple(:exp)) do
        [sub_exp, exp]
      end

      rule(sub_exp: simple(:sub_exp),
           naryand_recursion: sequence(:naryand)) do
        [sub_exp] + naryand
      end

      rule(exp: simple(:exp),
           expr: simple(:expr)) do
        [exp, expr]
      end

      rule(exp: simple(:exp),
           expr: sequence(:expr)) do
        [exp] + expr
      end

      rule(exp: sequence(:exp),
           expr: sequence(:expr)) do
        exp + expr
      end

      rule(sup_exp: simple(:sup_exp),
           expr: sequence(:expr)) do
        [sup_exp] + expr
      end

      rule(sup_exp: sequence(:sup_exp),
           expr: sequence(:expr)) do
        sup_exp + expr
      end

      rule(factor: simple(:factor),
           expr: simple(:expr)) do
        [factor, expr]
      end

      rule(operand: simple(:operand),
           expr: simple(:expr)) do
        [operand, expr]
      end

      rule(factor: simple(:factor),
           exp: sequence(:exp)) do
        [factor] + exp
      end

      rule(operand: simple(:operand),
           expr: sequence(:expr)) do
        [operand] + expr
      end

      rule(factor: sequence(:factor),
           expr: sequence(:expr)) do
        factor + expr
      end

      rule(factor: sequence(:factor),
           exp: sequence(:exp)) do
        factor + exp
      end

      rule(factor: simple(:factor),
           expr: sequence(:expr)) do
        [factor] + expr
      end

      rule(factor: simple(:factor),
           exp: sequence(:exp)) do
        [factor] + exp
      end

      rule(factor: simple(:factor),
           exp: simple(:exp)) do
        [factor, exp]
      end

      rule(monospace: simple(:monospace),
           exp: simple(:exp)) do
        [monospace, exp]
      end

      rule(monospace: simple(:monospace),
           expr: simple(:expr)) do
        [monospace, expr]
      end

      rule(monospace: simple(:monospace),
           exp: sequence(:exp)) do
        [monospace] + exp
      end

      rule(monospace: simple(:monospace),
           expr: sequence(:expr)) do
        [monospace] + expr
      end

      rule(factor: sequence(:factor),
           expr: simple(:expr)) do
        factor + [expr]
      end

      rule(factor: sequence(:factor),
           operand: simple(:operand)) do
        factor + [operand]
      end

      rule(mini_sub: simple(:mini_sub),
           expr: simple(:expr)) do
        [mini_sub, expr]
      end

      rule(mini_sub: simple(:mini_sub),
           expr: sequence(:expr)) do
        [mini_sub] + expr
      end

      rule(sub_script: simple(:sub_script),
           mini_sub: simple(:mini_sub)) do
        [sub_script, mini_sub]
      end

      rule(expression: simple(:expression),
           expr: sequence(:expr)) do
        [expression] + expr
      end

      rule(expression: simple(:expression),
           expr: simple(:expr)) do
        [expression, expr]
      end

      rule(unary_function: simple(:unary_function),
           expr: simple(:expr)) do
        [unary_function, expr]
      end

      rule(unary_function: simple(:unary_function),
           expr: sequence(:expr)) do
        [unary_function] + expr
      end

      rule(rect: simple(:rect),
           expr: sequence(:expr)) do
        [rect] + expr
      end

      rule(table: simple(:table),
           expr: sequence(:expr)) do
        [table] + expr
      end

      rule(intent: simple(:intent),
           intent_expr: simple(:expr)) do
        if expr.is_a?(Math::Function::Fenced) && expr.parameter_two.first.is_a?(Math::Function::Text)
          intent_string = expr.parameter_two.shift
          Math::Function::Intent.new(
            Utility.filter_values(expr.parameter_two),
            intent_string,
          )
        else
          binding.pry
        end
      end

      rule(over: simple(:over),
           sup_script: simple(:sup_script)) do
        Math::Function::Overset.new(
          Utility.unfenced_value(sup_script, paren_specific: true),
          nil,
        )
      end

      rule(under: simple(:under),
           sub_script: simple(:sub_script)) do
        Math::Function::Underset.new(
          Utility.unfenced_value(sub_script, paren_specific: true),
          nil,
        )
      end

      rule(sup_script: simple(:sup_script),
           sup_recursion: simple(:sup_recursion)) do
        Utility.sort_sup(
          sup_script,
          Utility.unfenced_value(sup_recursion, paren_specific: true),
        )
      end

      rule(sup_script: simple(:sup_script),
           mini_sup: simple(:mini_sup)) do
        [sup_script, mini_sup]
      end

      rule(sup_script: simple(:sup_script),
           mini_sub: simple(:mini_sub)) do
        [sup_script, mini_sub]
      end

      rule(sub_script: simple(:sub_script),
           recursion: simple(:recursion)) do
        Utility.sort_sub(
          sub_script,
          Utility.unfenced_value(recursion, paren_specific: true),
        )
      end

      rule(sup_script: sequence(:sup_script),
           sup_recursion: simple(:sup_recursion)) do
        Utility.sort_sup(
          Math::Formula.new(sup_script),
          Utility.unfenced_value(sup_recursion, paren_specific: true),
        )
      end

      rule(base: simple(:base),
           sub: simple(:sub)) do
        if (Constants::BINARY_FUNCTIONS.include?(base.class_name) && !base.parameter_one)
          if sub.class_name == "underset"
            base.parameter_one = sub.parameter_one
          else
            base.parameter_one = Utility.unfenced_value(sub, paren_specific: true)
          end
          base
        elsif sub.class_name == "underset"
          sub.parameter_two = base
          sub
        elsif base.is_a?(Math::Function::Power) && Utility.base_is_prime?(base)
          Math::Function::PowerBase.new(
            base.parameter_one,
            sub,
            base.parameter_two,
          )

        else
          if (base.is_a?(Math::Function::Underset) && Constants::HORIZONTAL_BRACKETS.key(base.parameter_one.value.to_s)) ||
              ("ubrace" == base.class_name && !base.parameter_one.is_a?(Math::Formula))
            Math::Function::Underset.new(
              Utility.unfenced_value(sub, paren_specific: true),
              base,
            )
          else
            Math::Function::Base.new(
              base,
              Utility.unfenced_value(sub, paren_specific: true),
            )
          end
        end
      end

      rule(base: sequence(:base),
           sub: simple(:sub)) do
        new_base = base.pop
        object = if sub.class_name == "underset"
                   sub.parameter_two = new_base
                   sub
                 else
                   Math::Function::Base.new(
                     new_base,
                     Utility.unfenced_value(sub, paren_specific: true),
                   )
                 end
        base << object
      end

      rule(base: sequence(:base),
           sub: sequence(:sub)) do
        object = Math::Function::Base.new(
          base.pop,
          Utility.unfenced_value(sub, paren_specific: true),
        )
        base << object
      end

      rule(base: simple(:base),
           sub: sequence(:sub)) do
        if (Constants::BINARY_FUNCTIONS.include?(base.class_name) && !base.parameter_one)
          base.parameter_one = sub_value
          base
        elsif base.is_a?(Math::Function::Power) && Utility.base_is_prime?(base)
          Math::Function::PowerBase.new(
            base.parameter_one,
            sub,
            base.parameter_two,
          )
        else
          Math::Function::Base.new(
            base,
            Utility.unfenced_value(sub, paren_specific: true),
          )
        end
      end

      rule(root_symbol: simple(:root_symbol),
           first_value: simple(:first_value)) do
        if ["&#x221b;", "\\cbrt"].include?(root_symbol)
          Math::Function::Root.new(
            Math::Number.new("3"),
            Utility.unfenced_value(first_value, paren_specific: true),
          )
        elsif ["&#x221c;", "\\qdrt"].include?(root_symbol)
          Math::Function::Root.new(
            Math::Number.new("4"),
            Utility.unfenced_value(first_value, paren_specific: true),
          )
        else
          Math::Function::Sqrt.new(
            Utility.unfenced_value(first_value, paren_specific: true),
          )
        end
      end

      rule(base: simple(:base),
           sup: simple(:sup)) do
        if "overset" == sup.class_name && !sup.parameter_two
          sup.parameter_two = Utility.unfenced_value(base, paren_specific: true)
          sup
        elsif (Constants::BINARY_FUNCTIONS.include?(base.class_name) && !base.parameter_one)
          base.parameter_two = Utility.unfenced_value(sup, paren_specific: true)
          base
        else
          if base.is_a?(Math::Function::Overset) && Constants::HORIZONTAL_BRACKETS.key(base.parameter_one.value.to_s) || "obrace" == base.class_name
            Math::Function::Overset.new(
              Utility.unfenced_value(sup, paren_specific: true),
              base,
            )
          else
            Math::Function::Power.new(
              base,
              Utility.unfenced_value(sup, paren_specific: true),
            )
          end
        end
      end

      rule(base: sequence(:base),
           sup: simple(:sup)) do
        power = Math::Function::Power.new(
          base.pop,
          Utility.unfenced_value(sup, paren_specific: true)
        )
        Math::Formula.new(base << power)
      end

      rule(base: simple(:base),
           sup: sequence(:sup)) do
        if (base.class_name == "base" && Utility.base_is_sub_or_sup?(base.parameter_two))
          Math::Function::PowerBase.new(
            base.parameter_one,
            base.parameter_two,
            Utility.unfenced_value(sup, paren_specific: true)
          )
        else
          Math::Function::Power.new(
            base,
            Utility.unfenced_value(sup, paren_specific: true),
          )
        end
      end

      rule(base: sequence(:base),
           sup: sequence(:sup)) do
        power = Math::Function::Power.new(
          base.pop,
          Utility.unfenced_value(sup, paren_specific: true),
        )
        base << power
      end

      rule(unary_sub_sup: simple(:sub_sup),
           first_value: simple(:first_value)) do
        if sub_sup.is_unary?
          sub_sup.parameter_one.parameter_one = first_value
          sub_sup
        else
          Math::Formula.new([sub_sup, first_value])
        end
      end

      rule(color_value: simple(:color),
           first_value: simple(:first_value)) do
        Math::Function::Color.new(
          Math::Symbol.new(color),
          first_value,
        )
      end

      rule(color_value: simple(:color),
           first_value: sequence(:first_value)) do
        Math::Function::Color.new(
          Math::Symbol.new(color),
          Utility.filter_values(first_value),
        )
      end

      rule(unary_arg_functions: simple(:function),
           first_value: simple(:first_value)) do
        if ["abs", "&#x249c;"].any?(function)
          Math::Function::Abs.new(
            Utility.unfenced_value(first_value, paren_specific: true)
          )
        else
          unary = Constants::UNARY_ARG_FUNCTIONS.key(function) || function.to_sym
          Math::Function::Menclose.new(
            Utility::UNICODEMATH_MENCLOSE_FUNCTIONS[unary],
            Utility.unfenced_value(first_value, paren_specific: true),
          )
        end
      end

      rule(unary_symbols: simple(:unary),
           first_value: simple(:first_value)) do
        unary_symbol = (Constants::UNARY_SYMBOLS.key(unary.to_s) || unary.to_sym)
        if Constants::PHANTOM_SYMBOLS.key?(unary_symbol)
          new_value = nil
          Constants::PHANTOM_SYMBOLS[unary_symbol].map do |function_name, attributes|
            if function_name == :phantom && attributes
              new_value = Math::Function::Phantom.new(
                Utility.unfenced_value((new_value.nil? ? first_value : new_value), paren_specific: true)
              )
            elsif function_name == :mpadded
              new_value = Math::Function::Mpadded.new(
                Utility.unfenced_value(first_value, paren_specific: true),
                attributes,
              )
            end
          end
          new_value
        else
          notation = Utility::UNICODEMATH_MENCLOSE_FUNCTIONS[unary.to_sym] ||
                      Utility::UNICODEMATH_MENCLOSE_FUNCTIONS[unary_symbol.to_sym]
          Math::Function::Menclose.new(
            notation,
            Utility.unfenced_value(first_value, paren_specific: true),
          )
        end
      end

      rule(backcolor_value: simple(:color),
           first_value: simple(:first_value)) do
        color_obj = Math::Function::Color.new(
          Math::Symbol.new(color),
          first_value,
        )
        color_obj.set_options({ backcolor: true })
      end

      rule(backcolor_value: simple(:color),
           first_value: sequence(:first_value)) do
        color_obj = Math::Function::Color.new(
          Math::Symbol.new(color),
          Utility.filter_values(first_value),
        )
        color_obj.set_options({ backcolor: true })
      end

      rule(rect_value: simple(:mask),
           first_value: sequence(:first_value)) do
        Math::Function::Menclose.new(
          Utility.enclosure_attrs(mask.to_i),
          Utility.unfenced_value(first_value, paren_specific: true),
        )
      end

      rule(rect_value: simple(:mask),
           first_value: simple(:first_value)) do
        Math::Function::Menclose.new(
          Utility.enclosure_attrs(mask.to_i),
          Utility.unfenced_value(first_value, paren_specific: true),
        )
      end

      rule(hbracket_class: simple(:hbrack),
           first_value: simple(:first_value)) do
        value = Utility.unfenced_value(first_value, paren_specific: true)
        if hbrack == "&#x23de;"
          Math::Function::Obrace.new(value)
        elsif hbrack == "&#x23df;"
          if value.is_a?(Math::Function::Base) && !value.parameter_one.is_a?(Math::Formula)
            Math::Function::Underset.new(
              value.parameter_two,
              Math::Function::Ubrace.new(value.parameter_one)
            )
          else
            Math::Function::Ubrace.new(value)
          end
        else
          if Constants::UNDER_HORIZONTAL_BRACKETS[hbrack.to_sym] || Constants::UNDER_HORIZONTAL_BRACKETS.key(hbrack)
            Math::Function::Underset.new(
              Math::Symbol.new(Constants::HORIZONTAL_BRACKETS[hbrack.to_sym] || hbrack),
              value,
            )
          else
            Math::Function::Overset.new(
              Math::Symbol.new(Constants::HORIZONTAL_BRACKETS[hbrack.to_sym] || hbrack),
              value,
            )
          end
        end
      end

      rule(hbracket_class: simple(:hbrack),
           first_value: sequence(:first_value)) do
        value = Utility.unfenced_value(first_value, paren_specific: true)
        if hbrack == "&#x23de;"
          Math::Function::Obrace.new(value)
        elsif hbrack == "&#x23df;"
          if value.is_a?(Math::Function::Base) && !value.parameter_one.is_a?(Math::Formula)
            Math::Function::Underset.new(
              value.parameter_two,
              Math::Function::Ubrace.new(value.parameter_one)
            )
          else
            Math::Function::Ubrace.new(value)
          end
        else
          if Constants::UNDER_HORIZONTAL_BRACKETS[hbrack.to_sym] || Constants::UNDER_HORIZONTAL_BRACKETS.key(hbrack)
            Math::Function::Underset.new(
              Math::Symbol.new(Constants::HORIZONTAL_BRACKETS[hbrack.to_sym] || hbrack),
              value,
            )
          else
            Math::Function::Overset.new(
              Math::Symbol.new(Constants::HORIZONTAL_BRACKETS[hbrack.to_sym] || hbrack),
              value,
            )
          end
        end
      end

      rule(hbracket_class: simple(:hbrack),
           scripted_first_value: simple(:scripted_first_value)) do
        value = Utility.unfenced_value(scripted_first_value, paren_specific: true)
        if hbrack == "&#x23de;"
          Math::Function::Obrace.new(value)
        elsif hbrack == "&#x23df;"
          if value.is_a?(Math::Function::Base) && !value.parameter_one.is_a?(Math::Formula)
            Math::Function::Underset.new(
              value.parameter_two,
              Math::Function::Ubrace.new(
                Utility.unfenced_value(value.parameter_one, paren_specific: true),
              )
            )
          else
            Math::Function::Ubrace.new(value)
          end
        else
          if Constants::UNDER_HORIZONTAL_BRACKETS[hbrack.to_sym] || Constants::UNDER_HORIZONTAL_BRACKETS.key(hbrack)
            Math::Function::Underset.new(
              Math::Symbol.new(Constants::HORIZONTAL_BRACKETS[hbrack.to_sym] || hbrack),
              value,
            )
          else
            Math::Function::Overset.new(
              Math::Symbol.new(Constants::HORIZONTAL_BRACKETS[hbrack.to_sym] || hbrack),
              value,
            )
          end
        end
      end

      rule(hbracket_class: simple(:hbrack),
           scripted_first_value: sequence(:scripted_first_value)) do
        value = Utility.unfenced_value(scripted_first_value, paren_specific: true)
        if hbrack == "&#x23de;"
          binding.pry
          Math::Function::Obrace.new(value)
        elsif hbrack == "&#x23df;"
          if value.is_a?(Math::Function::Base) && !value.parameter_one.is_a?(Math::Formula)
            Math::Function::Underset.new(
              value.parameter_two,
              Math::Function::Ubrace.new(value.parameter_one)
            )
          else
            Math::Function::Ubrace.new(value)
          end
        else
          binding.pry
          if Constants::UNDER_HORIZONTAL_BRACKETS[hbrack.to_sym] || Constants::UNDER_HORIZONTAL_BRACKETS.key(hbrack)
            Math::Function::Underset.new(
              Math::Symbol.new(Constants::HORIZONTAL_BRACKETS[hbrack.to_sym] || hbrack),
              value,
            )
          else
            Math::Function::Overset.new(
              Math::Symbol.new(Constants::HORIZONTAL_BRACKETS[hbrack.to_sym] || hbrack),
              value,
            )
          end
        end
      end

      rule(first_value: simple(:first_value),
           prime_accent_symbols: sequence(:prime)) do
        Math::Function::Power.new(
          Utility.unfenced_value(first_value, paren_specific: true),
          Utility.filter_values(prime),
        )
      end

      rule(first_value: simple(:first_value),
           prime_accent_symbols: simple(:prime)) do
        Math::Function::Power.new(
          Utility.unfenced_value(first_value, paren_specific: true),
          Math::Symbol.new(prime),
        )
      end

      rule(first_value: sequence(:first_value),
           overlay_after: simple(:overlay)) do
        notation = Constants::OVERLAYS_NOTATIONS[overlay.to_sym]
        overlay_value = Utility.unfenced_value(first_value.pop, paren_specific: true)
        overlay_object = if notation == "mover"
                           Math::Function::Overset.new(
                              Math::Symbol.new(overlay),
                              overlay_value,
                              { accent: true },
                            )
                         else
                           if notation.split(" ").length > 1
                             binding.pry
                           elsif overlay == "&#x304;"
                             Math::Function::Overset.new(
                               Math::Symbol.new(overlay),
                               overlay_value,
                               { accent: true },
                             )
                           else
                             Math::Function::Menclose.new(
                               notation,
                               overlay_value
                             )
                           end
                         end
        Math::Formula.new(first_value << overlay_object)
      end

      rule(first_value: simple(:first_value),
           overlay_after: simple(:overlay)) do
        notation = Constants::OVERLAYS_NOTATIONS[overlay.to_sym]
        overlay_value = Utility.unfenced_value(first_value, paren_specific: true)
        if notation == "mover"
          Math::Function::Overset.new(
            Math::Symbol.new(overlay),
            overlay_value,
            { accent: true },
          )
        else
          if notation.split(" ").length > 1
            binding.pry
          elsif overlay == "&#x304;"
            Math::Function::Overset.new(
              Math::Symbol.new(overlay),
              overlay_value,
              { accent: true },
            )
          else
            Math::Function::Menclose.new(
              notation,
              overlay_value
            )
          end
        end
      end

      rule(overlay_before: simple(:overlay),
           first_value: simple(:first_value)) do
        notation = Constants::OVERLAYS_NOTATIONS[overlay.to_sym]
        overlay_value = Utility.unfenced_value(first_value, paren_specific: true)
        if notation == "mover"
          Math::Function::Overset.new(
            Math::Symbol.new(overlay),
            overlay_value,
            { accent: true },
          )
        else
          if notation.split(" ").length > 1
            binding.pry
          else
            Math::Function::Menclose.new(
              notation,
              overlay_value
            )
          end
        end
      end

      rule(below_after: simple(:overlay),
           first_value: simple(:first_value)) do
        notation = Constants::BELOWS_NOTATIONS[overlay.to_sym]
        overlay_value = Utility.unfenced_value(first_value, paren_specific: true)
        if notation == "munder"
          Math::Function::Underset.new(
            Math::Symbol.new(overlay),
            overlay_value,
            { accent: true },
          )
        else
          if notation.split(" ").length > 1
            binding.pry
          else
            Math::Function::Menclose.new(notation, overlay_value)
          end
        end
      end

      rule(first_value: sequence(:first_value),
           prime_accent_symbols: simple(:prime)) do
        Math::Function::Power.new(
          Utility.unfenced_value(first_value, paren_specific: true),
          Math::Symbol.new(prime),
        )
      end

      rule(root_first_value: sequence(:first_value),
           root_second_value: simple(:second_value)) do
        Math::Function::Root.new(
          Utility.filter_values(first_value),
          Utility.unfenced_value(second_value, paren_specific: true),
        )
      end

      rule(first_value: simple(:first_value),
           second_value: sequence(:second_value)) do
        Math::Function::Root.new(
          first_value,
          Utility.unfenced_value(second_value, paren_specific: true),
        )
      end

      rule(first_value: simple(:first_value),
           second_value: simple(:second_value)) do
        Math::Function::Root.new(
          first_value,
          Utility.unfenced_value(second_value, paren_specific: true),
        )
      end

      rule(unary_functions: simple(:unary),
           first_value: simple(:first_value)) do
        if Constants::UNDEF_UNARY_FUNCTIONS.include?(unary.to_s)
          Math::Formula.new([
            Math::Symbol.new(unary),
            first_value,
          ])
        else
          Utility.get_class(unary).new(first_value)
        end
      end

      rule(unary_functions: simple(:unary),
           first_value: simple(:first_value)) do
        if Constants::UNDEF_UNARY_FUNCTIONS.include?(unary.to_s)
          Math::Formula.new([
            Math::Symbol.new(unary),
            first_value,
          ])
        else
          Utility.get_class(unary).new(first_value)
        end
      end

      rule(phantom_value: simple(:value),
           first_value: simple(:first_value)) do
        Math::Function::Mpadded.new(
          first_value,
          { mask: value.to_s },
        )
      end

      rule(tr: simple(:tr),
           trs: simple(:trs)) do
        [Math::Function::Tr.new([tr]), trs]
      end

      rule(td: simple(:td),
           tds: simple(:tds)) do
        [Math::Function::Td.new([td]), tds]
      end

      rule(tr: simple(:tr),
           trs: sequence(:trs)) do
        [Math::Function::Tr.new([tr])] + trs
      end

      rule(tr: sequence(:tr),
           trs: simple(:trs)) do
        [Math::Function::Tr.new(tr), trs]
      end

      rule(tr: sequence(:tr),
           trs: sequence(:trs)) do
        [Math::Function::Tr.new(tr)] + trs
      end

      rule(td: simple(:td),
           tds: sequence(:tds)) do
        [Math::Function::Td.new([td])] + tds
      end

      rule(td: sequence(:td),
           tds: sequence(:tds)) do
        [Math::Function::Td.new(td)] + tds
      end

      rule(td: sequence(:td),
           tds: simple(:tds)) do
        [Math::Function::Td.new(td), tds]
      end

      rule(numerator: simple(:numerator),
           denominator: simple(:denominator)) do
        Utility.fractions(numerator, denominator)
      end

      rule(mini_numerator: simple(:numerator),
           mini_denominator: simple(:denominator)) do
        Utility.fractions(numerator, denominator, { displaystyle: false })
      end

      rule(numerator: simple(:numerator),
           denominator: sequence(:denominator)) do
        Utility.fractions(numerator, denominator)
      end

      rule(mini_numerator: simple(:numerator),
           mini_denominator: sequence(:denominator)) do
        Utility.fractions(numerator, denominator, { displaystyle: false })
      end

      rule(numerator: sequence(:numerator),
           denominator: simple(:denominator)) do
        Utility.fractions(numerator, denominator)
      end

      rule(mini_numerator: sequence(:numerator),
           mini_denominator: simple(:denominator)) do
        Utility.fractions(numerator, denominator, { displaystyle: false })
      end

      rule(numerator: sequence(:numerator),
           denominator: sequence(:denominator)) do
        Utility.fractions(numerator, denominator)
      end

      rule(mini_numerator: sequence(:numerator),
           mini_denominator: sequence(:denominator)) do
        Utility.fractions(numerator, denominator, { displaystyle: false })
      end

      rule(matrixs: simple(:matrixs),
           array: sequence(:array)) do
        matrix = Constants::MATRIXS.key(matrixs)
        if :Vmatrix == matrix
          Utility.get_table_class(matrix).new(
            array,
            "norm[",
          )
        elsif :Bmatrix == matrix
          Utility.get_table_class(matrix).new(
            array,
            "{",
            "}",
          )
        else
          Utility.get_table_class(matrix).new(array)
        end
      end

      rule(matrixs: simple(:matrixs),
           identity_matrix_number: simple(:number)) do
        matrix = Constants::MATRIXS.key(matrixs)
        if :Vmatrix == matrix
          Utility.get_table_class(matrix).new(
            array,
            "norm[",
          )
        elsif :Bmatrix == matrix
          Utility.get_table_class(matrix).new(
            array,
            "{",
            "}",
          )
        else
          Utility.get_table_class(matrix).new(
            Utility.identity_matrix(number.to_i)
          )
        end
      end

      rule(factor: simple(:factor),
           sup_exp: simple(:sup_exp)) do
        [factor, sup_exp]
      end

      rule(factor: simple(:factor),
           sub_exp: simple(:sub_exp)) do
        [factor, sub_exp]
      end

      rule(factor: simple(:factor),
           pre_script: simple(:pre_script)) do
        [factor, pre_script]
      end

      rule(factor: simple(:factor),
           mini_sup: simple(:mini_sup)) do
        [factor, mini_sup]
      end

      rule(mini_sup: simple(:mini_sup),
           expr: simple(:expr)) do
        [mini_sup, expr]
      end

      rule(mini_sup: simple(:mini_sup),
           expr: sequence(:expr)) do
        [mini_sup] + expr
      end

      rule(mini_sup: simple(:mini_sup),
           recursive_numerator: sequence(:recursive_numerator)) do
        [mini_sup] + recursive_numerator
      end

      rule(mini_sup: simple(:mini_sup),
           recursive_numerator: simple(:recursive_numerator)) do
        [mini_sup, recursive_numerator]
      end

      rule(atom: simple(:atom),
           recursive_numerator: simple(:numerator)) do
        [atom, numerator]
      end

      rule(digit: simple(:digit),
           recursive_numerator: simple(:numerator)) do
        [digit, numerator]
      end

      rule(digit: simple(:digit),
           recursive_numerator: sequence(:numerator)) do
        [digit] + numerator
      end

      rule(digit: simple(:digit),
           expr: sequence(:expr)) do
        [digit] + expr
      end

      rule(digit: simple(:digit),
           expr: simple(:expr)) do
        [digit, expr]
      end

      rule(sup_exp: simple(:sup),
           recursive_numerator: simple(:recursive_numerator)) do
        [sup, recursive_numerator]
      end

      rule(sup_exp: simple(:sup),
           recursive_numerator: sequence(:recursive_numerator)) do
        [sup] + recursive_numerator
      end

      rule(frac: simple(:frac),
           expr: simple(:expr)) do
        [frac, expr]
      end

      rule(frac: simple(:frac),
           exp: simple(:exp)) do
        [frac, exp]
      end

      rule(expr: simple(:expr),
           func_expr: simple(:func_expr)) do
        [expr, func_expr]
      end

      rule(expr: simple(:expr),
           func_expr: sequence(:func_expr)) do
        [expr] + func_expr
      end

      rule(frac: simple(:frac),
           expr: sequence(:expr)) do
        [frac] + expr
      end

      rule(frac: simple(:frac),
           exp: sequence(:exp)) do
        [frac] + exp
      end

      rule(nary: simple(:nary),
           expr: sequence(:expr)) do
        [nary] + expr
      end

      rule(nary: simple(:nary),
           expr: simple(:expr)) do
        [nary, expr]
      end

      rule(intermediate_exp: simple(:exp),
           expr: simple(:expr)) do
        [exp, expr]
      end

      rule(intermediate_exp: simple(:exp),
           operator: simple(:operator)) do
        [exp, Math::Symbol.new(operator)]
      end

      rule(intermediate_exp: simple(:exp),
           exclamation_symbol: simple(:exclamation_symbol)) do
        [exp, Math::Symbol.new(exclamation_symbol)]
      end

      rule(atom: simple(:atom),
           exclamation_symbol: simple(:exclamation_symbol)) do
        [atom, Math::Symbol.new(exclamation_symbol)]
      end

      rule(intermediate_exp: simple(:exp),
           expr: sequence(:expr)) do
        [exp] + expr
      end

      rule(nary_sub_sup: simple(:subsup_exp),
           naryand: simple(:naryand)) do
        if subsup_exp.is_ternary_function?
          subsup_exp.parameter_three = naryand
          subsup_exp
        else
          Math::Formula.new([subsup_exp, naryand])
        end
      end

      rule(nary_sub_sup: simple(:subsup_exp),
           naryand: sequence(:naryand)) do
        if subsup_exp.is_ternary_function?
          subsup_exp.parameter_three = Utility.filter_values(naryand)
          subsup_exp
        else
          Math::Function::Nary.new(
            subsup_exp.parameter_one,
            subsup_exp.parameter_two,
            subsup_exp.parameter_three,
            Utility.filter_values(naryand)
          )
        end
      end

      rule(slashed_value: simple(:value),
           expr: simple(:expr)) do
        decoded = HTMLEntities.new.decode(value)
        slashed = if decoded.to_s.match?(/^\w+/)
                    Math::Function::Text.new("\\#{decoded}")
                  else
                    Math::Symbol.new(decoded, true)
                  end
        [slashed, expr]
      end

      rule(slashed_value: simple(:value),
           exp: simple(:expr)) do
        decoded = HTMLEntities.new.decode(value)
        slashed = if decoded.to_s.match?(/^\w+/)
                    Math::Function::Text.new("\\#{decoded}")
                  else
                    Math::Symbol.new(decoded, true)
                  end
        [slashed, expr]
      end

      rule(slashed_value: sequence(:values),
           expr: simple(:expr)) do
        values.each.with_index do |value, index|
          decoded = HTMLEntities.new.decode(value.value)
          slashed = if decoded.to_s.match?(/^\w+/)
                      Math::Function::Text.new("\\#{decoded}")
                    else
                      Math::Symbol.new(decoded, true)
                    end
          values[index] = slashed
        end
        values + [expr]
      end

      rule(slashed_value: sequence(:values),
           expr: sequence(:expr)) do
        values.each.with_index do |value, index|
          decoded = HTMLEntities.new.decode(value.value)
          slashed = if decoded.to_s.match?(/^\w+/)
                      Math::Function::Text.new("\\#{decoded}")
                    else
                      Math::Symbol.new(decoded, true)
                    end
          values[index] = slashed
        end
        values + expr
      end

      rule(slashed_value: simple(:value),
           expr: sequence(:expr)) do
        decoded = HTMLEntities.new.decode(value)
        slashed = if decoded.to_s.match?(/^\w+/)
                    Math::Function::Text.new("\\#{decoded}")
                  else
                    Math::Symbol.new(decoded, true)
                  end
        [slashed] + expr
      end

      rule(nary_class: simple(:nary_class),
           sub: sequence(:sub)) do
        nary = nary_class.to_s
        nary_function = if Constants::NARY_CLASSES.key?(nary.to_sym)
                          nary
                        else
                          Constants::NARY_CLASSES.invert[nary]
                        end
        if nary_function
          Utility.get_class(nary_function).new(
            Utility.filter_values(sub),
          )
        else
          binding.pry
        end
      end

      rule(nary_class: simple(:nary_class),
           sub: simple(:sub)) do
        nary = nary_class.to_s
        nary_function = if Constants::NARY_CLASSES.key?(nary.to_sym)
                          nary
                        else
                          Constants::NARY_CLASSES.invert[nary]
                        end
        if nary_function
          nary_value = if sub.class_name == "underset"
                         sub.parameter_one
                       else
                         Utility.unfenced_value(sub, paren_specific: true)
                       end
          Utility.get_class(nary_function).new(nary_value)
        else
          Math::Function::Nary.new(
            Math::Symbol.new(nary),
            Utility.unfenced_value(sub, paren_specific: true)
          )
        end
      end

      rule(nary_class: simple(:nary_class),
           sup: simple(:sup)) do
        nary = nary_class.to_s
        nary_function = if Constants::NARY_CLASSES.key?(nary.to_sym)
                          nary
                        else
                          Constants::NARY_CLASSES.invert[nary]
                        end
        if nary_function
          nary_value = if sup.class_name == "overset"
                         sup.parameter_one
                       else
                         Utility.unfenced_value(sup, paren_specific: true)
                       end
          Utility.get_class(nary_function).new(nil, nary_value)
        else
          binding.pry
        end
      end

      rule(nary_class: simple(:nary_class),
           naryand: simple(:naryand)) do
        nary = nary_class.to_s
        nary_function = if Constants::NARY_CLASSES.key?(nary.to_sym)
                          nary
                        else
                          Constants::NARY_CLASSES.invert[nary]
                        end
        if nary_function
          nary_value = if naryand.class_name == "underset"
                         naryand.parameter_two
                       else
                         Utility.unfenced_value(naryand, paren_specific: true)
                       end
          Utility.get_class(nary_function).new(nil, nil, nary_value)
        else
          Math::Function::Nary.new(
            Math::Symbol.new(nary),
            nil,
            nil,
            naryand,
          )
        end
      end

      rule(pre_supscript: simple(:pre_sup),
           base: simple(:base)) do
        Math::Function::Multiscript.new(
          Math::Function::PowerBase.new(base),
          [],
          [pre_sup],
        )
      end

      rule(pre_subscript: simple(:pre_sub),
           base: simple(:base)) do
        Math::Function::Multiscript.new(
          Math::Function::PowerBase.new(base),
          [pre_sub],
          [],
        )
      end

      rule(paren_close_prefix: simple(:prefix),
           open_paren: simple(:paren)) do
        paren
     end

      rule(paren_open_prefix: simple(:prefix),
           close_paren: simple(:paren)) do
        paren
     end

      rule(open_paren: simple(:open_paren),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren
        )
     end

      rule(factor: simple(:factor),
           mini_sup: simple(:mini_sup),
           expr: sequence(:expr)) do
        [factor, mini_sup] + expr
      end

      rule(atom: simple(:atom),
           atoms: sequence(:atoms),
           recursive_denominator: simple(:denominator)) do
        [atom] + atoms + [denominator]
      end

      rule(atom: simple(:atom),
           binary_symbols: simple(:symbols),
           factor: simple(:factor)) do
        symbol = (Constants::BINARY_SYMBOLS[symbols.to_sym] || symbols)
        [atom, Math::Symbol.new(symbol), factor]
      end

      rule(atom: simple(:atom),
           binary_symbols: simple(:symbols),
           recursive_numerator: simple(:numerator)) do
        symbol = (Constants::BINARY_SYMBOLS[symbols.to_sym] || symbols)
        [atom, Math::Symbol.new(symbol), numerator]
      end

      rule(paren_open_prefix: simple(:paren_open_prefix),
           open_paren_mask: simple(:open_paren_mask),
           open_paren: simple(:open_paren)) do
        [open_paren_mask, open_paren]
      end

      rule(paren_close_prefix: simple(:paren_close_prefix),
           close_paren_mask: simple(:close_paren_mask),
           open_paren: simple(:open_paren)) do
        [close_paren_mask, open_paren]
      end

      rule(paren_close_prefix: simple(:paren_close_prefix),
           close_paren_mask: simple(:close_paren_mask),
           close_paren: simple(:close_paren)) do
        [close_paren_mask, close_paren]
      end

      rule(paren_open_prefix: simple(:paren_open_prefix),
           open_paren_mask: simple(:open_paren_mask),
           close_paren: simple(:close_paren)) do
        [open_paren_mask, close_paren]
      end

      rule(char: simple(:char),
           diacritics: sequence(:diacritics),
           number: simple(:number)) do
        [char] + diacritics + [Math::Number.new(number)]
      end

      rule(char: simple(:char),
           diacritics: simple(:diacritics),
           number: simple(:number)) do
        [char, diacritics, Math::Number.new(number)]
      end

      rule(char: simple(:char),
           diacritics: simple(:diacritics),
           alphanumeric: simple(:alpha)) do
        [char, diacritics, Math::Symbol.new(alpha)]
      end

      rule(sub_script: simple(:sub_script),
           mini_sup: simple(:mini_sup),
           operand: simple(:operand)) do
        [sub_script, mini_sup, operand]
      end

      rule(base: simple(:base),
           sup: simple(:sup),
           sub: simple(:sub)) do
        underover_classes = ["underset", "overset"].freeze
        if underover_classes.include?(sub.class_name) && underover_classes.include?(sup.class_name)
          Math::Function::Underover.new(
            base,
            sub.parameter_one,
            sup.parameter_one,
          )
        else
          Math::Function::PowerBase.new(
            base,
            Utility.unfenced_value(sub, paren_specific: true),
            Utility.unfenced_value(sup, paren_specific: true),
          )
        end
      end

      rule(base: simple(:base),
           size_overrides: simple(:size_overrides),
           sub_script: sequence(:sub)) do
        Math::Function::Base.new(
          base,
          Utility.filter_values(sub),
          { size: Constants::SIZE_OVERRIDES_SYMBOLS[size_overrides.to_sym] }
        )
      end

      rule(base: simple(:base),
           size_overrides: simple(:size_overrides),
           sub_script: simple(:sub)) do
        Math::Function::Base.new(
          base,
          Utility.unfenced_value(sub, paren_specific: true),
          { size: Constants::SIZE_OVERRIDES_SYMBOLS[size_overrides.to_sym] }
        )
      end

      rule(base: sequence(:base),
           sup: simple(:sup),
           sub: simple(:sub)) do
        power_base = Math::Function::PowerBase.new(
          base.pop,
          Utility.unfenced_value(sub, paren_specific: true),
          Utility.unfenced_value(sup, paren_specific: true),
        )
        base + [power_base]
      end

      rule(base: simple(:base),
           sup: simple(:sup),
           sub: sequence(:sub)) do
        Math::Function::PowerBase.new(
          base,
          Utility.unfenced_value(sub, paren_specific: true),
          Utility.unfenced_value(sup, paren_specific: true),
        )
      end

      rule(base: simple(:base),
           sup: sequence(:sup),
           sub: sequence(:sub)) do
        Math::Function::PowerBase.new(
          base,
          Utility.filter_values(sub),
          Utility.filter_values(sup),
        )
      end

      rule(base: simple(:base),
           sup: sequence(:sup),
           sub: simple(:sub)) do
        Math::Function::PowerBase.new(
          base,
          Utility.filter_values(sub),
          Utility.filter_values(sup),
        )
      end

      rule(nary_class: simple(:nary_class),
           sub: sequence(:sub),
           sup: simple(:sup)) do
        nary = nary_class.to_s
        nary_function = if Constants::NARY_CLASSES.key?(nary.to_sym)
                          nary
                        else
                          Constants::NARY_CLASSES.invert[nary]
                        end
        if nary_function
          Utility.get_class(nary_function).new(
            Utility.filter_values(sub),
            Utility.filter_values(sup),
          )
        else
          binding.pry
        end
      end

      rule(numerator: simple(:numerator),
           atop: simple(:atop),
           denominator: simple(:denominator)) do
        Utility.fractions(numerator, denominator, { linethickness: "0" })
      end

      rule(numerator: sequence(:numerator),
           atop: simple(:atop),
           denominator: simple(:denominator)) do
        Utility.fractions(numerator, denominator, { linethickness: "0" })
      end

      rule(numerator: simple(:numerator),
           choose: simple(:choose),
           denominator: simple(:denominator)) do
        Math::Function::Fenced.new(
          Math::Symbol.new("("),
          [
            Utility.fractions(numerator, denominator, { linethickness: "0" }),
          ],
          Math::Symbol.new(")"),
        )
      end

      rule(arg: simple(:arg),
           arg_arguments: simple(:args),
           first_value: simple(:first_value)) do
        Math::Function::Arg.new(first_value, args)
      end

      rule(whole: simple(:whole),
           decimal: simple(:decimal),
           fractional: simple(:fractional)) do
        Math::Number.new("#{whole.value}#{decimal}#{fractional.value}")
      end

      rule(factor: simple(:factor),
           operand: sequence(:operand),
           expr: simple(:expr)) do
        [factor] + operand + [expr]
      end

      rule(factor: simple(:factor),
           operand: sequence(:operand),
           expr: sequence(:expr)) do
        [factor] + operand + expr
      end

      rule(factor: simple(:factor),
           operand: sequence(:operand),
           naryand_recursion: sequence(:naryand_recursion)) do
        [factor] + operand + naryand_recursion
      end

      rule(factor: sequence(:factor),
           operand: simple(:operand),
           expr: sequence(:expr)) do
        factor + [operand] + expr
      end

      rule(factor: sequence(:factor),
           operand: sequence(:operand),
           expr: simple(:expr)) do
        factor + operand + [expr]
      end

      rule(factor: simple(:factor),
           operand: simple(:operand),
           expr: sequence(:expr)) do
        [factor, operand] + expr
      end

      rule(factor: simple(:factor),
           operand: simple(:operand),
           exp: sequence(:exp)) do
        [factor, operand] + exp
      end

      rule(factor: simple(:factor),
           operand: simple(:operand),
           exp: simple(:exp)) do
        [factor, operand, exp]
      end

      rule(factor: simple(:factor),
           operand: sequence(:operand),
           exp: sequence(:exp)) do
        [factor] + operand + exp
      end

      rule(factor: simple(:factor),
           sup_exp: simple(:sup_exp),
           expr: simple(:expr)) do
        [factor, sup_exp, expr]
      end

      rule(factor: simple(:factor),
           sub_exp: simple(:sub_exp),
           expr: simple(:expr)) do
        [factor, sub_exp, expr]
      end

      rule(factor: simple(:factor),
           sup_exp: simple(:sup_exp),
           expr: sequence(:expr)) do
        [factor, sup_exp] + expr
      end

      rule(factor: simple(:factor),
           sub_exp: simple(:sub_exp),
           expr: sequence(:expr)) do
        [factor, sub_exp] + expr
      end

      rule(factor: simple(:factor),
           operand: simple(:operand),
           expr: simple(:expr)) do
        [factor, operand, expr]
      end

      rule(factor: simple(:factor),
           operand: simple(:operand),
           recursive_denominator: simple(:denominator)) do
        [factor, operand, denominator]
      end

      rule(factor: simple(:factor),
           expr: simple(:expr),
           expression: simple(:expression)) do
        [factor, expr, expression]
      end

      rule(sub_script: simple(:sub_script),
           mini_sub: simple(:mini_sub),
           exp_iteration: simple(:exp_iteration)) do
        [sub_script, mini_sub, exp_iteration]
      end

      rule(intermediate_exp: simple(:exp),
           expr: simple(:expr),
           expression: simple(:expression)) do
        [exp, expr, expression]
      end

      rule(numerator: simple(:numerator),
           bevelled: simple(:bevelled),
           denominator: simple(:denominator)) do
        Utility.fractions(numerator, denominator, { bevelled: true })
      end

      rule(numerator: simple(:numerator),
           bevelled: simple(:bevelled),
           denominator: sequence(:denominator)) do
        Utility.fractions(numerator, denominator, { bevelled: true })
      end

      rule(numerator: simple(:numerator),
           no_display_style: simple(:no_display_style),
           denominator: sequence(:denominator)) do
        Utility.fractions(numerator, denominator, { no_display_style: false })
      end

      rule(numerator: simple(:numerator),
           no_display_style: simple(:no_display_style),
           denominator: simple(:denominator)) do
        Utility.fractions(numerator, denominator, { displaystyle: false })
      end

      rule(fonts: simple(:fonts),
           relational_symbols: simple(:symbols),
           expr: simple(:expr)) do
        [
          fonts,
          Math::Symbol.new((Constants::RELATIONAL_SYMBOLS[symbols.to_sym] || symbols)),
          expr,
        ]
      end

      rule(frac: simple(:frac),
           relational_symbols: simple(:symbols),
           expr: simple(:expr)) do
        [
          frac,
          Math::Symbol.new((Constants::RELATIONAL_SYMBOLS[symbols.to_sym] || symbols)),
          expr,
        ]
      end

      rule(base: simple(:base),
           sub: sequence(:sub),
           sub_recursion: simple(:sub_recursion)) do
        if (Constants::BINARY_FUNCTIONS.include?(base.class_name) && !base.parameter_one)
          base.parameter_one = sub_value
          base
        elsif base.is_a?(Math::Function::Power) && Utility.base_is_prime?(base)
          Math::Function::PowerBase.new(
            base.parameter_one,
            sub,
            base.parameter_two,
          )
        else
          Math::Function::Base.new(
            base,
            Utility.sort_sub(
              Utility.filter_values(sub),
              sub_recursion,
            ),
          )
        end
      end

      rule(mini_intermediate_exp: simple(:mini_exp),
           sub_operators: simple(:sub_operators),
           sub_recursions: sequence(:sub_recursions)) do
        operators = Constants::SUB_OPERATORS.key(sub_operators).to_s
        [
          mini_exp,
          Math::Number.new(operators, mini_sub_sized: true),
        ] + sub_recursions
      end

      rule(opener: simple(:opener),
           operand: simple(:operand),
           closer: simple(:closer)) do
        Utility.unfenced_value(operand, paren_specific: true) if [opener, closer].include?("|")
        Math::Function::Fenced.new(
          opener.is_a?(Slice) ? Math::Symbol.new(opener) : opener,
          [operand],
          closer.is_a?(Slice) ? Math::Symbol.new(closer) : closer,
        )
      end

      rule(opener: simple(:opener),
           operand: sequence(:operand),
           closer: simple(:closer)) do
        Math::Function::Fenced.new(
          opener.is_a?(Slice) ? Math::Symbol.new(opener) : opener,
          operand,
          closer.is_a?(Slice) ? Math::Symbol.new(closer) : closer,
        )
      end

      rule(opener: sequence(:opener),
           operand: simple(:operand),
           closer: simple(:closer)) do
        options = { prefixed: true }
        if opener.first.is_a?(Math::Number)
          mask = "#{1.25**opener[0].value.to_i}em"
          options[:open_paren] = { minsize: mask, maxisize: mask }
        end
        Utility.unfenced_value(operand, paren_specific: true) if [opener, closer].include?("|")
        Math::Function::Fenced.new(
          Math::Symbol.new(opener.last),
          [operand],
          closer.is_a?(Slice) ? Math::Symbol.new(closer) : closer,
          options,
        )
      end

      rule(open_paren: simple(:open_paren),
           frac: simple(:frac),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [frac],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           phantom: simple(:phantom),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [phantom],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           unary_function: simple(:unary_function),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [unary_function],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           rect: simple(:rect),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [rect],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           paren_close_prefix: simple(:close_prefix)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [factor],
          Math::Symbol.new(close_prefix),
          { prefixed: true }
        )
      end

      rule(paren_open_prefix: simple(:open_paren),
           factor: simple(:factor),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          Math::Symbol.new(open_paren),
          [factor],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
          { prefixed: true }
        )
      end

      rule(open_paren: simple(:open_paren),
           nary: simple(:nary),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [nary],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           sub_exp: simple(:sub_exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [sub_exp],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           subsup_exp: simple(:subsup_exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [subsup_exp],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           unary_subsup: simple(:subsup),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [subsup],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           mini_sup: simple(:mini_sup),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [mini_sup],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(sub_open_paren: simple(:open_paren),
           mini_expr: sequence(:mini_expr),
           sub_close_paren: simple(:close_paren)) do
        sub_open = Constants::SUB_PARENTHESIS[:open].key(open_paren)
        sub_close = Constants::SUB_PARENTHESIS[:close].key(close_paren)
        Math::Function::Fenced.new(
          Math::Symbol.new(sub_open.to_s, mini_sub_sized: true),
          mini_expr,
          Math::Symbol.new(sub_close.to_s, mini_sub_sized: true),
        )
      end

      rule(open_paren: simple(:open_paren),
           text: simple(:text),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [Math::Function::Text.new(text)],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           close_paren: simple(:close_paren)) do
        new_factor = [open_paren, close_paren].include?("|") ? Utility.unfenced_value(factor, paren_specific: true) : factor
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [new_factor],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           sup_exp: simple(:sup_exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [sup_exp],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           accents: subtree(:accents),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [Utility.unicode_accents(accents)],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: sequence(:open_paren),
           factor: simple(:factor),
           close_paren: simple(:close_paren)) do
        options = { prefixed: true }
        if open_paren.first.is_a?(Math::Number)
          mask = "#{1.25**open_paren.first.value.to_i}em"
          options[:open_paren] = { minsize: mask, maxisize: mask }
        end
        new_factor = [open_paren, close_paren].include?("|") ? Utility.unfenced_value(factor, paren_specific: true) : factor
        Math::Function::Fenced.new(
          Math::Symbol.new(open_paren.last),
          [new_factor],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
          options
        )
      end

      rule(open_paren: sequence(:open_paren),
           frac: simple(:frac),
           close_paren: sequence(:close_paren)) do
        options = { prefixed: true }
        if open_paren.first.is_a?(Math::Number)
          mask = "#{1.25**open_paren.first.value.to_i}em"
          options[:open_paren] = { minsize: mask, maxisize: mask }
        end
        if close_paren.first.is_a?(Math::Number)
          mask = "#{1.25**close_paren.first.value.to_i}em"
          options[:close_paren] = { minsize: mask, maxisize: mask }
        end
        Math::Function::Fenced.new(
          Math::Symbol.new(open_paren.last),
          [frac],
          Math::Symbol.new(close_paren.last),
          options
        )
      end

      rule(open_paren: simple(:open_paren),
           frac: simple(:frac),
           close_paren: sequence(:close_paren)) do
        options = { prefixed: true }
        if close_paren.first.is_a?(Math::Number)
          mask = "#{1.25**close_paren.first.value.to_i}em"
          options[:close_paren] = { minsize: mask, maxisize: mask }
        end
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [frac],
          Math::Symbol.new(close_paren.last),
          options
        )
      end

      rule(open_paren: sequence(:open_paren),
           factor: simple(:factor),
           close_paren: sequence(:close_paren)) do
        options = { prefixed: true }
        if open_paren.first.is_a?(Math::Number)
          mask = "#{1.25**open_paren.first.value.to_i}em"
          options[:open_paren] = { minsize: mask, maxisize: mask }
        end
        if close_paren.first.is_a?(Math::Number)
          mask = "#{1.25**close_paren.first.value.to_i}em"
          options[:close_paren] = { minsize: mask, maxisize: mask }
        end
        Math::Function::Fenced.new(
          Math::Symbol.new(open_paren.last),
          [factor],
          Math::Symbol.new(close_paren.last),
          options
        )
      end

      rule(open_paren: simple(:open_paren),
           negated_operator: simple(:operator),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [
            Math::Formula.new([
              Math::Symbol.new(operator),
              Math::Symbol.new("&#x338;"),
            ])
          ],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           table: simple(:table),
           paren_close_prefix: simple(:close_paren)) do
          table.open_paren = open_paren.to_s
          table.close_paren = close_paren.to_s
          table
      end

      rule(open_paren: simple(:open_paren),
           table: simple(:table),
           close_paren: simple(:close_paren)) do
          table.open_paren = open_paren.to_s
          table.close_paren = close_paren.to_s
          table
      end

      rule(intermediate_exp: simple(:intermediate_exp),
           operator: simple(:operator),
           expr: simple(:expr)) do
        [
          intermediate_exp,
          Math::Symbol.new(operator),
          expr,
        ]
      end

      rule(atom: simple(:atom),
           operator: simple(:operator),
           frac: simple(:frac)) do
        [
          atom,
          Math::Symbol.new(operator),
          frac,
        ]
      end

      rule(operator: simple(:operator),
           frac: simple(:frac),
           expr: sequence(:expr)) do
        [
          Math::Symbol.new(operator),
          frac,
        ] + expr
      end

      rule(nary_class: simple(:nary_class),
           sub: simple(:sub),
           sup: simple(:sup)) do
        nary = nary_class.to_s
        nary_function = if Constants::NARY_CLASSES.key?(nary.to_sym)
                          nary
                        else
                          Constants::NARY_CLASSES.invert[nary]
                        end
        if nary_function
          new_sub = (sub.class_name == "underset" ? sub.parameter_one : Utility.unfenced_value(sub, paren_specific: true))
          new_sup = (sup.class_name == "overset" ? sup.parameter_one : Utility.unfenced_value(sup, paren_specific: true))
          Utility.get_class(nary_function).new(new_sub, new_sup)
        else
          Math::Function::Nary.new(
            Math::Symbol.new(Constants::NARY_SYMBOLS[nary_class.to_sym] || nary),
            Utility.unfenced_value(sub, paren_specific: true),
            Utility.unfenced_value(sup, paren_specific: true),
          )
        end
      end

      rule(nary_class: simple(:nary_class),
           sub: sequence(:sub),
           sup: sequence(:sup)) do
        nary = nary_class.to_s
        nary_function = if Constants::NARY_CLASSES.key?(nary.to_sym)
                          nary
                        else
                          Constants::NARY_CLASSES.invert[nary]
                        end
        if nary_function
          Utility.get_class(nary_function).new(
            Utility.unfenced_value(sub, paren_specific: true),
            Utility.unfenced_value(sup, paren_specific: true),
          )
        else
          binding.pry
        end
      end

      rule(nary_class: simple(:nary_class),
           sub: simple(:sub),
           sup: sequence(:sup)) do
        nary = nary_class.to_s
        nary_function = if Constants::NARY_CLASSES.key?(nary.to_sym)
                          nary
                        else
                          Constants::NARY_CLASSES.invert[nary]
                        end
        sub_value = sub.is_a?(Math::Function::Underset) ? sub.parameter_one : Utility.unfenced_value(sub, paren_specific: true)
        if nary_function
          Utility.get_class(nary_function).new(
            sub_value,
            Utility.unfenced_value(sup, paren_specific: true),
          )
        else
          binding.pry
        end
      end

      rule(nary_class: simple(:nary_class),
           mask: simple(:mask),
           sub: simple(:sub)) do
        nary_function = Constants::NARY_CLASSES.invert[nary_class.to_s]
        sub_value = sub.is_a?(Math::Function::Underset) ? sub.parameter_one : Utility.unfenced_value(sub, paren_specific: true)
        options = { mask: mask.value }
        if nary_function
          Utility.get_class(nary_function).new(
            sub_value,
            nil,
            nil,
            options
          )
        else
          Math::Function::Nary.new(
            Math::Symbol.new(nary_class),
            sub_value,
            nil,
            options
          )
        end
      end

      rule(nary_class: simple(:nary_class),
           mask: simple(:mask),
           sup: simple(:sup)) do
        nary_function = Constants::NARY_CLASSES.invert[nary_class.to_s]
        sup_value = sup.is_a?(Math::Function::Overset) ? sup.parameter_one : Utility.unfenced_value(sup, paren_specific: true)
        options = { mask: mask.value }
        if nary_function
          Utility.get_class(nary_function).new(
            nil,
            sup_value,
            nil,
            options
          )
        else
          Math::Function::Nary.new(
            Math::Symbol.new(nary_class),
            nil,
            sup_value,
            options
          )
        end
      end

      rule(pre_supscript: simple(:pre_sup),
           base: simple(:base),
           sub: simple(:sub)) do
        Math::Function::Multiscript.new(
          Math::Function::PowerBase.new(base, sub),
          [],
          [pre_sup],
        )
      end

      rule(pre_supscript: simple(:pre_sup),
           pre_subscript: simple(:pre_sub),
           base: simple(:base)) do
        Math::Function::Multiscript.new(
          Math::Function::PowerBase.new(base),
          [pre_sub],
          [pre_sup],
        )
      end

      rule(pre_subscript: simple(:pre_sub),
           base: simple(:base),
           sub: simple(:sub)) do
        Math::Function::Multiscript.new(
          Math::Function::PowerBase.new(
            base,
            Utility.unfenced_value(sub, paren_specific: true),
          ),
          [pre_sub],
          [],
        )
      end

      rule(pre_subscript: simple(:pre_sub),
           base: simple(:base),
           sub_digits: simple(:digits)) do
        digit = Constants::SUB_DIGITS.key(digits).to_s
        number = Math::Number.new(digit, mini_sub_sized: true)
        Math::Function::Multiscript.new(
          Math::Function::PowerBase.new(base, number),
          [pre_sub],
          [],
        )
      end

      rule(open_paren: simple(:open_paren),
           pre_script: simple(:pre_script),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [pre_script],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(atom: simple(:atom),
           operator: simple(:operator),
           frac: simple(:frac),
           expr: sequence(:expr)) do
        [
          atom,
          Math::Symbol.new(operator),
          frac,
        ] + expr
      end

      rule(open_paren: sequence(:open_paren),
           factor: simple(:factor),
           exp: sequence(:exp),
           close_paren: sequence(:close_paren)) do
        options = { prefixed: true }
        if open_paren.first.is_a?(Math::Number)
          mask = "#{1.25**open_paren.first.value.to_i}em"
          options[:open_paren] = { minsize: mask, maxisize: mask }
        end
        if close_paren.first.is_a?(Math::Number)
          mask = "#{1.25**close_paren.first.value.to_i}em"
          options[:close_paren] = { minsize: mask, maxisize: mask }
        end
        Math::Function::Fenced.new(
          Math::Symbol.new(open_paren.last),
          ([factor] + exp),
          Math::Symbol.new(close_paren.last),
          options
        )
      end

      rule(open_paren: simple(:open_paren),
           unary_function: simple(:unary),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([unary] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           close_paren: simple(:close_paren),
           naryand_recursion: sequence(:naryand_recursion)) do
        new_factor = [open_paren, close_paren].include?("|") ? Utility.unfenced_value(factor, paren_specific: true) : factor
        fenced = Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [new_factor],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
        [fenced] + naryand_recursion
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           close_paren: simple(:close_paren),
           naryand_recursion: simple(:naryand_recursion)) do
        new_factor = [open_paren, close_paren].include?("|") ? Utility.unfenced_value(factor, paren_specific: true) : factor
        fenced = Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [new_factor],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
        [fenced, naryand_recursion]
      end

      rule(open_paren: simple(:open_paren),
           mini_sub: simple(:mini_sub),
           expr: sequence(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([mini_sub] + expr),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           mini_sub: simple(:mini_sub),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([mini_sub] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           mini_sub_sup: simple(:mini_sub_sup),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([mini_sub_sup] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           mini_sup: simple(:mini_sup),
           expr: sequence(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([mini_sup] + expr),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           mini_sup: simple(:mini_sup),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([mini_sup] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           intermediate_exp: simple(:intermediate_exp),
           expr: sequence(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([intermediate_exp] + expr),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           expr: simple(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [factor, expr],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           exp: simple(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [factor, exp],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           accents: subtree(:accent),
           expr: sequence(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([Utility.unicode_accents(accent)] + expr),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           accents: subtree(:accent),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([Utility.unicode_accents(accent)] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           unicode_fractions: simple(:fraction),
           expr: sequence(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([Utility.unicode_fractions(fraction)] + expr),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           unicode_fractions: simple(:fraction),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([Utility.unicode_fractions(fraction)] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           unicode_symbols: simple(:symbol),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([Math::Symbol.new(symbol)] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           unicode_symbols: simple(:symbol),
           exp: simple(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [Math::Symbol.new(symbol), exp],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           operator: simple(:operator),
           expr: simple(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [Math::Symbol.new(operator), expr],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           sub_exp: simple(:sub_exp),
           expr: sequence(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([sub_exp] + expr),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           sub_exp: simple(:sub_exp),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([sub_exp] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           sub_exp: simple(:sub_exp),
           expr: simple(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([sub_exp, expr]),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           sub_exp: simple(:sub_exp),
           exp: simple(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([sub_exp, exp]),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           sup_exp: simple(:sup_exp),
           expr: simple(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([sup_exp, expr]),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           sup_exp: simple(:sup_exp),
           exp: simple(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([sup_exp, exp]),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           monospace: simple(:monospace),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([monospace] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           frac: simple(:frac),
           exp: simple(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([frac, exp]),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           frac: simple(:frac),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([frac] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           sup_exp: simple(:sup_exp),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([sup_exp] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           subsup_exp: simple(:subsup_exp),
           expr: sequence(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([subsup_exp] + expr),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           subsup_exp: simple(:subsup_exp),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([subsup_exp] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           expr: sequence(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([factor] + expr),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([factor] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: sequence(:factor),
           expr: sequence(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          (factor + expr),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           symbol: simple(:symbol),
           expr: sequence(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([Math::Symbol.new(symbol)] + expr),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: sequence(:factor),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          (factor + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: sequence(:factor),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          factor,
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           operand: simple(:operand),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([factor, operand]),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           operand: sequence(:operand),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([factor] + operand),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: sequence(:factor),
           operand: sequence(:operand),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          (factor + operand),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           text: simple(:text),
           operand: simple(:operand),
           exp: simple(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [Math::Function::Text.new(text), operand, exp],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           text: simple(:text),
           operand: simple(:operand),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [Math::Function::Text.new(text), operand] + exp,
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(nary_class: simple(:nary_class),
           mask: simple(:mask),
           sub: simple(:sub),
           sup: simple(:sup)) do
        nary_function = Constants::NARY_CLASSES.invert[nary_class.to_s]
        sub_value = sub.is_a?(Math::Function::Underset) ? sub.parameter_one : Utility.unfenced_value(sub, paren_specific: true)
        sup_value = sup.is_a?(Math::Function::Overset) ? sup.parameter_one : Utility.unfenced_value(sup, paren_specific: true)
        if nary_function
          Utility.get_class(nary_function).new(sub_value, sup_value, nil, { mask: mask.value })
        else
          binding.pry
        end
      end

      rule(open_paren: simple(:open_paren),
           operator: simple(:operator),
           expr: sequence(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([Math::Symbol.new(operator)] + expr),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           operator: simple(:operator),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([Math::Symbol.new(operator)] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(pre_subscript: simple(:pre_sub),
           pre_supscript: simple(:pre_sup),
           base: simple(:base),
           sub: simple(:sub)) do
        Math::Function::Multiscript.new(
          Math::Function::PowerBase.new(
            base,
            Utility.unfenced_value(sub, paren_specific: true),
          ),
          [Utility.unfenced_value(pre_sub, paren_specific: true)],
          [Utility.unfenced_value(pre_sup, paren_specific: true)],
        )
      end

      rule(open_paren: simple(:open_paren),
           operator: simple(:operator),
           exp: simple(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([Math::Symbol.new(operator), exp]),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           pre_subscript: simple(:pre_sub),
           close_paren: simple(:close_paren),
           base: simple(:base)) do
        Math::Function::Multiscript.new(
          Math::Function::PowerBase.new(base),
          [pre_sub],
          [],
        )
      end

      rule(open_paren: simple(:open_paren),
           operator: simple(:operator),
           expr: simple(:expr),
           close_paren: simple(:close_paren),
           sup: simple(:sup)) do
        fenced = Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [Math::Symbol.new(operator), expr],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
        Math::Function::Power.new(fenced, sup)
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           sup_exp: simple(:sup_exp),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([factor, sup_exp] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           sub_exp: simple(:sub_exp),
           exp: simple(:exp),
           close_paren: simple(:close_paren),
           sup: simple(:sup)) do
        fenced = Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([sub_exp, exp]),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
        Math::Function::Power.new(
          fenced,
          Utility.unfenced_value(sup, paren_specific: true)
        )
      end

      rule(open_paren: simple(:open_paren),
           sub_exp: simple(:sub_exp),
           exp: sequence(:exp),
           close_paren: simple(:close_paren),
           sup: simple(:sup)) do
        fenced = Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([sub_exp] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
        Math::Function::Power.new(
          fenced,
          Utility.unfenced_value(sup, paren_specific: true)
        )
      end

      rule(open_paren: simple(:open_paren),
           operator: simple(:operator),
           exp: simple(:exp),
           close_paren: simple(:close_paren),
           sup: simple(:sup)) do
        fenced = Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          [Math::Symbol.new(operator), exp],
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
        Math::Function::Power.new(fenced, sup)
      end

      rule(open_paren: simple(:open_paren),
           pre_subscript: simple(:pre_sub),
           close_paren: simple(:close_paren),
           base: simple(:base),
           sub: simple(:sub)) do
        Math::Function::Multiscript.new(
          Math::Function::PowerBase.new(base, sub),
          [pre_sub],
          [],
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           operand: simple(:operand),
           expr: sequence(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([factor, operand] + expr),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           operand: simple(:operand),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([factor, operand] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           operand: simple(:operand),
           expr: simple(:expr),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([factor, operand, expr]),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           factor: simple(:factor),
           sub_exp: sequence(:sub_exp),
           exp: simple(:exp),
           close_paren: simple(:close_paren)) do
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([factor] + sub_exp + [exp]),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(open_paren: simple(:open_paren),
           monospace: simple(:monospace),
           relational_symbols: simple(:symbol),
           expr: simple(:expr),
           exp: sequence(:exp),
           close_paren: simple(:close_paren)) do
        relational = Math::Symbol.new(
          (Constants::RELATIONAL_SYMBOLS[symbol.to_sym] || symbol),
        )
        Math::Function::Fenced.new(
          open_paren.is_a?(Slice) ? Math::Symbol.new(open_paren) : open_paren,
          ([monospace, relational, expr] + exp),
          close_paren.is_a?(Slice) ? Math::Symbol.new(close_paren) : close_paren,
        )
      end

      rule(pre_subscript: simple(:pre_sub),
           pre_supscript: simple(:pre_sup),
           base: simple(:base),
           sub: simple(:sub),
           sup: simple(:sup)) do
        Math::Function::Multiscript.new(
          Math::Function::PowerBase.new(
            base,
            Utility.unfenced_value(sub, paren_specific: true),
            Utility.unfenced_value(sup, paren_specific: true),
          ),
          [Utility.unfenced_value(pre_sub, paren_specific: true)],
          [Utility.unfenced_value(pre_sup, paren_specific: true)],
        )
      end

      rule(intent: simple(:intent),
           open_paren: simple(:open_paren),
           intent_arguments: simple(:args),
           first_value: simple(:value),
           close_paren: simple(:close_paren)) do
        Math::Function::Intent.new(value, args)
      end

      rule(intent: simple(:intent),
           open_paren: simple(:open_paren),
           intent_arguments: simple(:args),
           first_value: sequence(:value),
           close_paren: simple(:close_paren)) do
        Math::Function::Intent.new(Utility.filter_values(value), args)
      end

      rule(open_paren: simple(:open_paren),
           pre_subscript: simple(:pre_sub),
           pre_supscript: simple(:pre_sup),
           close_paren: simple(:close_paren),
           base: simple(:base),
           sub: simple(:sub),
           sup: simple(:sup)) do
        Math::Function::Multiscript.new(
          Math::Function::PowerBase.new(
            base,
            Utility.unfenced_value(sub, paren_specific: true),
            Utility.unfenced_value(sup, paren_specific: true),
          ),
          [pre_sub],
          [pre_sup],
        )
      end

      rule(open_paren: simple(:open_paren),
           pre_subscript: simple(:pre_sub),
           pre_supscript: simple(:pre_sup),
           close_paren: simple(:close_paren),
           base: simple(:base)) do
        Math::Function::Multiscript.new(
          Math::Function::PowerBase.new(
            base,
          ),
          [pre_sub],
          [pre_sup],
        )
      end
    end
  end
end