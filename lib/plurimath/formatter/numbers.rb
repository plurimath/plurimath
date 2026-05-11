# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      autoload :Base, "#{__dir__}/numbers/base"
      autoload :DigitSequence, "#{__dir__}/numbers/digit_sequence"
      autoload :BaseNotation, "#{__dir__}/numbers/base_notation"
      autoload :Fraction, "#{__dir__}/numbers/fraction"
      autoload :Integer, "#{__dir__}/numbers/integer"
      autoload :NotationRenderer, "#{__dir__}/numbers/notation_renderer"
      autoload :Parts, "#{__dir__}/numbers/parts"
      autoload :PrecisionResolver, "#{__dir__}/numbers/precision_resolver"
      autoload :RawIntegerFormatter, "#{__dir__}/numbers/raw_integer_formatter"
      autoload :SignRenderer, "#{__dir__}/numbers/sign_renderer"
      autoload :Significant, "#{__dir__}/numbers/significant"
      autoload :Source, "#{__dir__}/numbers/source"
      autoload :SymbolResolver, "#{__dir__}/numbers/symbol_resolver"
    end
  end
end
