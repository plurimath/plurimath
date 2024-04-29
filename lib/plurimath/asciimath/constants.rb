# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Constants
      TABLE_PARENTHESIS = {
        "ᑕ": "ᑐ",
        "ℒ": "ℛ",
        "[": "]",
        "(": ")",
      }.freeze
      PARENTHESIS = {
        "ᑕ": "ᑐ",
        "ℒ": "ℛ",
        "(": ")",
        "{": "}",
        "[": "]",
      }.freeze
      UNARY_CLASSES = %w[
        underbrace
        overbrace
        underline
        arccos
        arcsin
        arctan
        ubrace
        obrace
        cancel
        tilde
        floor
        ceil
        ddot
        coth
        csch
        sech
        sinh
        tanh
        cosh
        sqrt
        norm
        text
        sec
        sin
        tan
        cos
        exp
        gcd
        glb
        lcm
        lub
        cot
        csc
        det
        dim
        max
        min
        abs
        bar
        dot
        hat
        vec
        ul
        ln
      ].freeze
      FONT_STYLES = %w[
        mathfrak
        mathcal
        mathbb
        mathsf
        mathtt
        mathbf
        bbb
        bb
        rm
        fr
        cc
        sf
        tt
        ii
      ].freeze
      SUB_SUP_CLASSES = %w[lim log].freeze
      TERNARY_CLASSES = %w[prod oint sum int].freeze
      SPECIAL_BOLD_ALPHABETS = %w[ZZ RR QQ NN CC].freeze
      BINARY_CLASSES = %w[underset stackrel overset frac root].freeze
      SKIP_INPUT_PARENS = ["[", "]", "{", "}", "(", ")", "(:", ":)"].freeze

      class << self
        def precompile_constants
          @values ||=
            named_hash(UNARY_CLASSES, :unary_class)
              .merge(named_hash(symbols_array, :symbol))
              .merge(named_hash(FONT_STYLES, :fonts))
              .merge(named_hash(SPECIAL_BOLD_ALPHABETS, :special_fonts))
          @values.sort_by { |v, _| -v.length }.to_h
        end

        def named_hash(hash_or_array, name_key)
          hash_or_array.each_with_object({}) { |d, i| i[d] = name_key }
        end

        def symbols_array
          @@symbols ||= Utility.symbols_hash(:asciimath).keys.concat(parens_symbols)
        end

        def parens_symbols
          Utility.parens_hash(:asciimath).keys.delete_if { |sym| SKIP_INPUT_PARENS.include?(sym) }
        end
      end
    end
  end
end
