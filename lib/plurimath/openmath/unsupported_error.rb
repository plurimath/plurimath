# frozen_string_literal: true

module Plurimath
  class Openmath
    # Refusal to discard semantics the Formula model cannot express.
    #
    # Autoloaded rather than defined in openmath.rb: its superclass lives in
    # Math, and resolving that at Openmath load time would load Math (which
    # builds VALID_TYPES, referencing ContentMathml) while ContentMathml is
    # still being defined.
    class UnsupportedError < Math::ParseError; end
  end
end
