# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      autoload :Base, "#{__dir__}/numbers/base"
      autoload :BaseNotation, "#{__dir__}/numbers/base_notation"
      autoload :DigitSequence, "#{__dir__}/numbers/digit_sequence"
      autoload :Fraction, "#{__dir__}/numbers/fraction"
      autoload :FormatOptions, "#{__dir__}/numbers/format_options"
      autoload :FormattedNumber, "#{__dir__}/numbers/formatted_number"
      autoload :FormattedNotation, "#{__dir__}/numbers/formatted_notation"
      autoload :Integer, "#{__dir__}/numbers/integer"
      autoload :MathmlRenderer, "#{__dir__}/numbers/mathml_renderer"
      autoload :NumberRenderer, "#{__dir__}/numbers/number_renderer"
      autoload :NotationRenderer, "#{__dir__}/numbers/notation_renderer"
      autoload :OmmlRenderer, "#{__dir__}/numbers/omml_renderer"
      autoload :Parts, "#{__dir__}/numbers/parts"
      autoload :PrecisionResolver, "#{__dir__}/numbers/precision_resolver"
      autoload :SignRenderer, "#{__dir__}/numbers/sign_renderer"
      autoload :Significant, "#{__dir__}/numbers/significant"
      autoload :Source, "#{__dir__}/numbers/source"
      autoload :SymbolResolver, "#{__dir__}/numbers/symbol_resolver"
      autoload :TextRenderer, "#{__dir__}/numbers/text_renderer"
    end
  end
end
