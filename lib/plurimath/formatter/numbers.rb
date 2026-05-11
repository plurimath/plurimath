# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      autoload :Base, "#{__dir__}/numbers/base"
      autoload :DigitSequence, "#{__dir__}/numbers/digit_sequence"
      autoload :Fraction, "#{__dir__}/numbers/fraction"
      autoload :Integer, "#{__dir__}/numbers/integer"
      autoload :Parts, "#{__dir__}/numbers/parts"
      autoload :RawIntegerFormatter, "#{__dir__}/numbers/raw_integer_formatter"
      autoload :Significant, "#{__dir__}/numbers/significant"
      autoload :Source, "#{__dir__}/numbers/source"
    end
  end
end
