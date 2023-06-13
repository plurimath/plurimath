# frozen_string_literal: true

module Plurimath
  class Html
    class Constants
      PARENTHESIS = {
        "(": :")",
        "{": :"}",
        "[": :"]",
      }.freeze
      UNARY_CLASSES = %w[
        arcsin
        arccos
        arctan
        coth
        tanh
        sech
        csch
        sqrt
        ceil
        sinh
        cosh
        sin
        cos
        gcd
        csc
        abs
        vec
        exp
        sec
        tan
        cot
        lcm
        det
        ln
        lg
      ].freeze
      SUB_SUP_CLASSES = {
        "&prod;": :prod,
        "&sum;": :sum,
        log: :log,
        lim: :lim,
        "∏": :prod,
        "∑": :sum,
      }.freeze
    end
  end
end
