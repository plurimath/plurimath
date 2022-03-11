# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Constants
      WHITESPACES = /\s+/.freeze
      NUMBER = /[0-9]+(?:\.[0-9]+)?/.freeze
      QUOTED_TEXT = /"[^"]*"/.freeze
      TEX_TEXT = /text\([^)]*\)/.freeze
      PARENTHESES = { "(" => ")", "{" => "}", "[" => "]" }.freeze
      SYMBOLS_AND_CLASSES = {
        "+": :symbol,
        "-": :symbol,
        "*": :symbol,
        cdot: :symbol,
        "**": :symbol,
        ast: :symbol,
        "***": :symbol,
        star: :symbol,
        "//": :symbol,
        "\\\\": :symbol,
        backslash: :symbol,
        setminus: :symbol,
        xx: :symbol,
        times: :symbol,
        "-:": :symbol,
        div: :symbol,
        "|><": :symbol,
        ltimes: :symbol,
        "><|": :symbol,
        rtimes: :symbol,
        "|><|": :symbol,
        bowtie: :symbol,
        "@": :symbol,
        circ: :symbol,
        "o+": :symbol,
        oplus: :symbol,
        ox: :symbol,
        otimes: :symbol,
        "o.": :symbol,
        odot: :symbol,
        "^^": :symbol,
        wedge: :symbol,
        "^^^": :symbol,
        bigwedge: :symbol,
        vv: :symbol,
        vee: :symbol,
        vvv: :symbol,
        bigvee: :symbol,
        nn: :symbol,
        cap: :symbol,
        nnn: :symbol,
        bigcap: :symbol,
        uu: :symbol,
        cup: :symbol,
        uuu: :symbol,
        bigcup: :symbol,
        and: :symbol,
        or: :symbol,
        not: :symbol,
        neg: :symbol,
        "=>": :symbol,
        implies: :symbol,
        if: :symbol,
        "<=>": :symbol,
        iff: :symbol,
        AA: :symbol,
        forall: :symbol,
        EE: :symbol,
        exists: :symbol,
        "_|_": :symbol,
        bot: :symbol,
        TT: :symbol,
        top: :symbol,
        "|--": :symbol,
        vdash: :symbol,
        "|==": :symbol,
        models: :symbol,
        uarr: :symbol,
        uparrow: :symbol,
        darr: :symbol,
        downarrow: :symbol,
        rarr: :symbol,
        rightarrow: :symbol,
        "->": :symbol,
        to: :symbol,
        ">->": :symbol,
        rightarrowtail: :symbol,
        "->>": :symbol,
        twoheadrightarrow: :symbol,
        ">->>": :symbol,
        twoheadrightarrowtail: :symbol,
        "|->": :symbol,
        mapsto: :symbol,
        larr: :symbol,
        leftarrow: :symbol,
        harr: :symbol,
        leftrightarrow: :symbol,
        rArr: :symbol,
        Rightarrow: :symbol,
        lArr: :symbol,
        Leftarrow: :symbol,
        hArr: :symbol,
        Leftrightarrow: :symbol,
        alpha: :symbol,
        beta: :symbol,
        gamma: :symbol,
        delta: :symbol,
        epsilon: :symbol,
        varepsilon: :symbol,
        zeta: :symbol,
        eta: :symbol,
        theta: :symbol,
        vartheta: :symbol,
        iota: :symbol,
        kappa: :symbol,
        lambda: :symbol,
        mu: :symbol,
        nu: :symbol,
        xi: :symbol,
        pi: :symbol,
        rho: :symbol,
        sigma: :symbol,
        tau: :symbol,
        upsilon: :symbol,
        phi: :symbol,
        varphi: :symbol,
        chi: :symbol,
        psi: :symbol,
        omega: :symbol,
        Omega: :symbol,
        Psi: :symbol,
        Phi: :symbol,
        Sigma: :symbol,
        Pi: :symbol,
        Xi: :symbol,
        Lambda: :symbol,
        Theta: :symbol,
        Delta: :symbol,
        Gamma: :symbol,
        int: :symbol,
        oint: :symbol,
        del: :symbol,
        partial: :symbol,
        grad: :symbol,
        nabla: :symbol,
        "+-": :symbol,
        pm: :symbol,
        "O/": :symbol,
        emptyset: :symbol,
        oo: :symbol,
        infty: :symbol,
        aleph: :symbol,
        ":.": :symbol,
        therefore: :symbol,
        ":'": :symbol,
        because: :symbol,
        "|...|": :symbol,
        "|ldots|": :symbol,
        "|cdots|": :symbol,
        vdots: :symbol,
        ddots: :symbol,
        "|\\ |": :symbol,
        "|quad|": :symbol,
        "/_": :symbol,
        angle: :symbol,
        frown: :symbol,
        "/_\\": :symbol,
        triangle: :symbol,
        diamond: :symbol,
        square: :symbol,
        "|__": :symbol,
        lfloor: :symbol,
        "__|": :symbol,
        rfloor: :symbol,
        "|~": :symbol,
        lceiling: :symbol,
        "~|": :symbol,
        rceiling: :symbol,
        CC: :symbol,
        NN: :symbol,
        QQ: :symbol,
        RR: :symbol,
        ZZ: :symbol,
        "(": :symbol,
        ")": :symbol,
        "[": :symbol,
        "]": :symbol,
        "{": :symbol,
        "}": :symbol,
        "(:": :symbol,
        ":)": :symbol,
        "<<": :symbol,
        ">>": :symbol,
        "{: x )": :symbol,
        "( x :}": :symbol,
        "=": :symbol,
        "!=": :symbol,
        ne: :symbol,
        "<": :symbol,
        lt: :symbol,
        ">": :symbol,
        gt: :symbol,
        "<=": :symbol,
        le: :symbol,
        ">=": :symbol,
        ge: :symbol,
        mlt: :symbol,
        ll: :symbol,
        mgt: :symbol,
        gg: :symbol,
        "-<": :symbol,
        prec: :symbol,
        "-<=": :symbol,
        preceq: :symbol,
        ">-": :symbol,
        succ: :symbol,
        ">-=": :symbol,
        succeq: :symbol,
        in: :symbol,
        "!in": :symbol,
        notin: :symbol,
        sub: :symbol,
        subset: :symbol,
        sup: :symbol,
        supset: :symbol,
        sube: :symbol,
        subseteq: :symbol,
        supe: :symbol,
        supseteq: :symbol,
        "-=": :symbol,
        equiv: :symbol,
        "~=": :symbol,
        cong: :symbol,
        "~~": :symbol,
        approx: :symbol,
        prop: :symbol,
        propto: :symbol,
        "^": :symbol,
        "/": :symbol,
        _: :symbol,
        sin: :class,
        tan: :class,
        cos: :class,
        arccos: :class,
        arcsin: :class,
        arctan: :class,
        cosh: :class,
        cot: :class,
        coth: :class,
        csc: :class,
        csch: :class,
        det: :class,
        dim: :class,
        exp: :class,
        f: :class,
        g: :class,
        gcd: :class,
        glb: :class,
        lcm: :class,
        ln: :class,
        log: :class,
        lub: :class,
        max: :class,
        min: :class,
        mod: :class,
        sec: :class,
        sech: :class,
        sinh: :class,
        tanh: :class,
        frac: :class,
        root: :class,
        sqrt: :class,
        text: :class,
        abs: :class,
        bar: :class,
        cancel: :class,
        ceil: :class,
        color: :class,
        ddot: :class,
        dot: :class,
        floor: :class,
        hat: :class,
        norm: :class,
        obrace: :class,
        overset: :class,
        tilde: :class,
        ubrace: :class,
        ul: :class,
        underset: :class,
        vec: :class,
        mathbb: :class,
        mathbf: :class,
        mathcal: :class,
        mathfrak: :class,
        mathsf: :class,
        mathtt: :class,
        sum: :class,
        prod: :class,
      }

      end
    end
  end
