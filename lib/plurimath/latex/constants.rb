# frozen_string_literal: true

module Plurimath
  class Latex
    class Constants
      SYMBOLS = {
        displaystyle: :fonts,
        underbrace: :unary,
        mathsfbfit: :fonts,
        overbrace: :underover,
        mbfitsans: :fonts,
        stackrel: :binary,
        mathbold: :fonts,
        mathsfit: :fonts,
        mathsfbf: :fonts,
        mathbfit: :fonts,
        mathfrak: :fonts,
        overline: :unary,
        underset: :binary,
        overset: :binary,
        phantom: :unary,
        mathcal: :fonts,
        mbfsans: :fonts,
        mathds: :fonts,
        mathbf: :fonts,
        mathbb: :fonts,
        mathtt: :fonts,
        mathrm: :fonts,
        mathsf: :fonts,
        mathit: :fonts,
        textrm: :fonts,
        textbf: :fonts,
        textit: :fonts,
        arccos: :unary,
        cancel: :unary,
        arcsin: :unary,
        arctan: :unary,
        limsup: :unary,
        liminf: :unary,
        binom: :binary,
        color: :binary,
        mfrak: :fonts,
        mbfit: :fonts,
        msans: :fonts,
        tilde: :unary,
        prod: :ternary,
        oint: :ternary,
        frac: :binary,
        mscr: :fonts,
        sinh: :unary,
        coth: :unary,
        tanh: :unary,
        cosh: :unary,
        ddot: :unary,
        mbox: :text,
        text: :text,
        sum: :ternary,
        inf: :power_base,
        lim: :power_base,
        log: :power_base,
        int: :ternary,
        cal: :fonts,
        mit: :fonts,
        mbf: :fonts,
        mtt: :fonts,
        Bbb: :fonts,
        hat: :unary,
        vec: :unary,
        dot: :unary,
        tan: :unary,
        cos: :unary,
        cot: :unary,
        csc: :unary,
        deg: :unary,
        det: :unary,
        dim: :unary,
        exp: :unary,
        gcd: :unary,
        max: :unary,
        min: :unary,
        sec: :unary,
        sin: :unary,
        hom: :unary,
        sup: :unary,
        ker: :unary,
        bar: :unary,
        rm: :fonts,
        bf: :fonts,
        lg: :unary,
        ln: :unary,
        "#": :operant,
        "'": :operant,
        "$": :operant,
        ",": :operant,
        ".": :operant,
        ":": :operant,
        ";": :operant,
        "=": :operant,
        "?": :operant,
        "@": :operant,
        "%": :operant,
        "&": :operant,
        "!": :operant,
        "*": :operant,
        "+": :operant,
        "-": :operant,
        "/": :operant,
        "<": :operant,
        ">": :operant,
        "^": :operant,
        "|": :operant,
        _: :operant,
      }.freeze
      MATRICES_PARENTHESIS = {
        "\\Vert": :"]",
        "|": :"|",
        "(": :")",
        "{": :"}",
        "[": :"]",
      }.freeze
      MATRICES = {
        multline: nil,
        Vmatrix: "\\Vert",
        vmatrix: "|",
        pmatrix: "(",
        Bmatrix: "{",
        bmatrix: "[",
        matrix: nil,
        split: nil,
        align: nil,
        array: nil,
      }.freeze
      NUMERIC_VALUES = %w[
        zero
        one
        two
        three
        four
        five
        six
        seven
        eight
        nine
      ].freeze
      MATH_OPERATORS = %w[
        liminf
        arctan
        arcsin
        limsup
        tanh
        coth
        cosh
        sinh
        int
        sin
        max
        dim
        arg
        tan
        sec
        log
        hom
        det
        cot
        gcd
        deg
        min
        ker
        exp
        csc
        cos
        Pr
        ln
        lg
      ].freeze
      UNDEROVER_CLASSES = %w[
        bmod
        pmod
        mod
      ].freeze
      LEFT_RIGHT_PARENTHESIS = {
        "\\backslash": "&#x5c;",
        "\\langle": "&#x2329;",
        "\\rangle": "&#x232a;",
        "\\lfloor": "&#x230a;",
        "\\rfloor": "&#x230b;",
        "\\lceil": "&#x2308;",
        "\\rceil": "&#x2309;",
        "\\lbrace": "&#x7b;",
        "\\rbrace": "&#x7d;",
        "\\lbrack": "&#x5b;",
        "\\rbrack": "&#x5d;",
        "\\Vert": "&#x2016;",
        "\\vert": "&#x7c;",
        "\\|": "&#x2016;",
        "\\}": "}",
        "\\{": "{",
        "(": "(",
        ")": ")",
        "<": "<",
        ">": ">",
        "/": "/",
        "|": "|",
        "[": "[",
        "]": "]",
      }.freeze

      class << self
        def symbols_constants
          @@symbols ||= reverse_sort_hash(SYMBOLS.merge(symbols_hash))
        end

        def parenthesis
          @@parens ||= {"\\(" => "\\)", "\\[" => "\\]", "\\{" => "\\}"}
          rejected_paren(:close?).each do |paren, klass|
            @@parens[paren] = klass.new.closing::INPUT[:latex].flatten
          end
          reverse_sort_hash(@@parens)
        end

        private

        def symbols_hash
          latex_symbols.map { |sym, klass| [sym, :symbols] }.compact.to_h
        end

        def latex_symbols
          @@latex_symbols ||= Utility.symbols_hash(:latex)
        end

        def latex_parens
          @@latex_parens ||= Utility.parens_hash(:latex, skipables: ["lcurly"])
        end

        def rejected_paren(type)
          latex_parens.reject { |_, klass| klass.new.send(type) }
        end

        def reverse_sort_hash(hash)
          hash.sort_by { |str, _| -str.length }.to_h
        end
      end
    end
  end
end
