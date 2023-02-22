# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Constants
      TABLE_PARENTHESIS = {
        "(:": ":)",
        "ℒ": "ℛ",
        "[": "]",
        "(": ")",
      }.freeze
      PARENTHESIS = {
        "(:": ":)",
        "ℒ": "ℛ",
        "(": ")",
        "{": "}",
        "[": "]",
      }.freeze
      SYMBOLS = {
        twoheadrightarrowtail: :"&#x2916;",
        twoheadrightarrow: :"&#x21a0;",
        rightarrowtail: :"&#x21a3;",
        Leftrightarrow: :"&#x21d4;",
        leftrightarrow: :"&#x2194;",
        Rightarrow: :"&#x21d2;",
        rightarrow: :"&#x2192;",
        varepsilon: :"&#x25b;",
        Leftarrow: :"&#x21d0;",
        leftarrow: :"&#x2190;",
        downarrow: :"&#x2193;",
        therefore: :"&#x2234;",
        backslash: :"&#x5c;",
        setminus: :"&#x29f5;",
        triangle: :"&#x25b3;",
        bigwedge: :"&#x22c0;",
        rceiling: :"&#x2309;",
        lceiling: :"&#x2308;",
        supseteq: :"&#x2287;",
        subseteq: :"&#x2286;",
        vartheta: :"&#x3d1;",
        emptyset: :"&#x2205;",
        diamond: :"&#x22c4;",
        uparrow: :"&#x2191;",
        implies: :"&#x21d2;",
        partial: :"&#x2202;",
        because: :"&#x2235;",
        upsilon: :"&#x3c5;",
        epsilon: :"&#x3b5;",
        bigcap: :"&#x22c2;",
        bigvee: :"&#x22c1;",
        propto: :"&#x221d;",
        approx: :"&#x2248;",
        exists: :"&#x2203;",
        forall: :"&#x2200;",
        otimes: :"&#x2297;",
        ltimes: :"&#x22c9;",
        bowtie: :"&#x22c8;",
        rtimes: :"&#x22ca;",
        models: :"&#x22a8;",
        mapsto: :"&#x21a6;",
        bigcup: :"&#x22c3;",
        succeq: :"&#x2ab0;",
        preceq: :"&#x2aaf;",
        rfloor: :"&#x230b;",
        lfloor: :"&#x230a;",
        square: :"&#x25a1;",
        supset: :"&#x2283;",
        subset: :"&#x2282;",
        lambda: :"&#x3bb;",
        Lambda: :"&#x39b;",
        varphi: :"&#x3c6;",
        rangle: :"&#x232a;",
        langle: :"&#x2329;",
        ">->>": :"&#x2916;",
        "/_\\": :"&#x25b3;",
        "|><|": :"&#x22c8;",
        kappa: :"&#x3ba;",
        Delta: :"&#x394;",
        delta: :"&#x3b4;",
        gamma: :"&#x3b3;",
        Gamma: :"&#x393;",
        Theta: :"&#x398;",
        theta: :"&#x3b8;",
        alpha: :"&#x3b1;",
        aleph: :"&#x2135;",
        infty: :"&#x221e;",
        equiv: :"&#x2261;",
        frown: :"&#x2322;",
        notin: :"&#x2209;",
        angle: :"&#x2220;",
        prime: :"&#x2032;",
        "!in": :"&#x2209;",
        cdots: :"&#x22ef;",
        vdash: :"&#x22a2;",
        wedge: :"&#x2227;",
        oplus: :"&#x2295;",
        nabla: :"&#x2207;",
        ddots: :"&#x22f1;",
        vdots: :"&#x22ee;",
        Sigma: :"&#x3a3;",
        Omega: :"&#x3a9;",
        omega: :"&#x3c9;",
        sigma: :"&#x3c3;",
        times: :"&#xd7;",
        ldots: :"&#x2026;",
        ">-=": :"&#x2ab0;",
        "-<=": :"&#x2aaf;",
        "><|": :"&#x22ca;",
        "|==": :"&#x22a8;",
        "|--": :"&#x22a2;",
        "^^^": :"&#x22c0;",
        "|->": :"&#x21a6;",
        ">->": :"&#x21a3;",
        "->>": :"&#x21a0;",
        "__|": :"&#x230b;",
        "|__": :"&#x230a;",
        "|><": :"&#x22c9;",
        "_|_": :"&#x22a5;",
        "***": :"&#x22c6;",
        "<=>": :"&#x21d4;",
        "...": :"&#x2026;",
        "(:": :"&#x2329;",
        ":)": :"&#x232a;",
        quad: :"&#x2001;",
        star: :"&#x22c6;",
        odot: :"&#x2299;",
        cdot: :"&#x22c5;",
        rarr: :"&#x2192;",
        darr: :"&#x2193;",
        prop: :"&#x221d;",
        lArr: :"&#x21d0;",
        rArr: :"&#x21d2;",
        uarr: :"&#x2191;",
        hArr: :"&#x21d4;",
        harr: :"&#x2194;",
        larr: :"&#x2190;",
        grad: :"&#x2207;",
        circ: :"&#x2218;",
        sube: :"&#x2286;",
        supe: :"&#x2287;",
        succ: :"&#x227b;",
        prec: :"&#x227a;",
        cong: :"&#x2245;",
        beta: :"&#x3b2;",
        zeta: :"&#x3b6;",
        iota: :"&#x3b9;",
        ":'": :"&#x2235;",
        "^^": :"&#x2227;",
        "o+": :"&#x2295;",
        "o.": :"&#x2299;",
        "**": :"&#x2217;",
        "~~": :"&#x2248;",
        "O/": :"&#x2205;",
        "->": :"&#x2192;",
        "=>": :"&#x21d2;",
        ">>": :"&#x232a;",
        "<<": :"&#x2329;",
        "~|": :"&#x2309;",
        "!=": :"&#x2260;",
        ">-": :"&#x227b;",
        "-<": :"&#x227a;",
        "~=": :"&#x2245;",
        "-=": :"&#x2261;",
        ":.": :"&#x2234;",
        ">=": :"&#x2265;",
        "<=": :"&#x2264;",
        "|~": :"&#x2308;",
        "/_": :"&#x2220;",
        "+-": :"&#xb1;",
        "-:": :"&#xf7;",
        "\\ ": :"&#xa0;",
        "\\": :"\\",
        "//": :/,
        sup: :"&#x2283;",
        sub: :"&#x2282;",
        top: :"&#x22a4;",
        vvv: :"&#x22c1;",
        vee: :"&#x2228;",
        nnn: :"&#x22c2;",
        cap: :"&#x2229;",
        ast: :"&#x2217;",
        bot: :"&#x22a5;",
        del: :"&#x2202;",
        uuu: :"&#x22c3;",
        cup: :"&#x222a;",
        iff: :"&#x21d4;",
        eta: :"&#x3b7;",
        Phi: :"&#x3a6;",
        Psi: :"&#x3a8;",
        psi: :"&#x3c8;",
        chi: :"&#x3c7;",
        phi: :"&#x3d5;",
        rho: :"&#x3c1;",
        tau: :"&#x3c4;",
        div: :"&#xf7;",
        neg: :"&#xac;",
        not: :"&#xac;",
        "*": :"&#x22c5;",
        "@": :"&#x40;",
        "<": :"&#x3c;",
        ">": :"&#x3e;",
        "/": :"&#x2f;",
        ":": :"&#x3a;",
        "!": :"&#x21;",
        ",": :"&#x2c;",
        ";": :"&#x3b;",
        "?": :"&#x3f;",
        "$": :"&#x24;",
        "~": :"&#x7e;",
        "|": :"&#x7c;",
        "%": :"&#x25;",
        "'": :"&#x27;",
        "&": :"&#x26;",
        "#": :"&#x23;",
        "=": :"=",
        "-": :"-",
        "+": :"+",
        nn: :"&#x2229;",
        vv: :"&#x2228;",
        TT: :"&#x22a4;",
        EE: :"&#x2203;",
        ox: :"&#x2297;",
        to: :"&#x2192;",
        AA: :"&#x2200;",
        uu: :"&#x222a;",
        ne: :"&#x2260;",
        oo: :"&#x221e;",
        ge: :"&#x2265;",
        le: :"&#x2264;",
        in: :"&#x2208;",
        nu: :"&#x3bd;",
        mu: :"&#x3bc;",
        pi: :"&#x3c0;",
        Pi: :"&#x3a0;",
        xi: :"&#x3be;",
        Xi: :"&#x39e;",
        xx: :"&#xd7;",
        pm: :"&#xb1;",
        gt: :"&#x3e;",
        lt: :"&#x3c;",
        if: :if,
      }.freeze
      UNARY_CLASSES = %i[
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
        f
        g
      ].freeze
      BINARY_CLASSES = %i[
        underset
        stackrel
        overset
        frac
        root
      ].freeze
      FONT_STYLES = %i[
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
      SUB_SUP_CLASSES = %w[
        prod
        oint
        lim
        sum
        log
        int
      ].freeze
      SPECIAL_BOLD_ALPHABETS = %w[
        ZZ
        RR
        QQ
        NN
        CC
      ].freeze

      class << self
        def precompile_constants
          @values ||=
            named_hash(UNARY_CLASSES, :unary_class)
              .merge(named_hash(SYMBOLS.keys, :symbol))
              .merge(named_hash(FONT_STYLES, :fonts))
              .merge(named_hash(SPECIAL_BOLD_ALPHABETS, :special_fonts))
          @values.sort_by { |v, _| -v.length }.to_h
        end

        def named_hash(hash_or_array, name_key)
          hash_or_array.each_with_object({}) { |d, i| i[d] = name_key }
        end
      end
    end
  end
end
