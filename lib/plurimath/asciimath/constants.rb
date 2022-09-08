# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Constants
      TABLE_PARENTHESIS = {
        "[": "]",
        "{": "}",
        "(": ")",
        "|": "|",
      }.freeze
      PARENTHESIS = {
        "(:": ":)",
        "{:": ":}",
        "(": ")",
        "{": "}",
        "[": "]",
      }.freeze
      SYMBOLS = {
        twoheadrightarrowtail: :"&#x2916;",
        twoheadrightarrow: :"&#x21A0;",
        rightarrowtail: :"&#x21A3;",
        Leftrightarrow: :"&#x21D4;",
        leftrightarrow: :"&#x2194;",
        Rightarrow: :"&#x21D2;",
        rightarrow: :"&#x2192;",
        varepsilon: :"&#x25B;",
        Leftarrow: :"&#x21D0;",
        leftarrow: :"&#x2190;",
        downarrow: :"&#x2193;",
        therefore: :"&#x2234;",
        backslash: :"\\",
        setminus: :"\\",
        triangle: :"&#x25B3;",
        bigwedge: :"&#x22C0;",
        rceiling: :"&#x2309;",
        lceiling: :"&#x2308;",
        supseteq: :"&#x2287;",
        subseteq: :"&#x2286;",
        vartheta: :"&#x3D1;",
        emptyset: :"&#x2205;",
        diamond: :"&#x22C4;",
        uparrow: :"&#x2191;",
        implies: :"&#x21D2;",
        partial: :"&#x2202;",
        because: :"&#x2235;",
        upsilon: :"&#x3C5;",
        epsilon: :"&#x3B5;",
        bigcap: :"&#x22C2;",
        bigvee: :"&#x22C1;",
        propto: :"&#x221D;",
        approx: :"&#x2248;",
        exists: :"&#x2203;",
        forall: :"&#x2200;",
        otimes: :"&#x2297;",
        ltimes: :"&#x22C9;",
        bowtie: :"&#x22C8;",
        rtimes: :"&#x22CA;",
        models: :"&#x22A8;",
        mapsto: :"&#x21A6;",
        bigcup: :"&#x22C3;",
        succeq: :"&#x2AB0;",
        preceq: :"&#x2AAF;",
        rfloor: :"&#x230B;",
        lfloor: :"&#x230A;",
        square: :"&#x25A1;",
        supset: :"&#x2283;",
        subset: :"&#x2282;",
        lambda: :"&#x3BB;",
        Lambda: :"&#x39B;",
        varphi: :"&#x3C6;",
        ">->>": :"&#x2916;",
        "/_\\": :"&#x25B3;",
        "|><|": :"&#x22C8;",
        kappa: :"&#x3BA;",
        Delta: :"&#x394;",
        delta: :"&#x3B4;",
        gamma: :"&#x3B3;",
        Gamma: :"&#x393;",
        Theta: :"&#x398;",
        theta: :"&#x3B8;",
        alpha: :"&#x3B1;",
        aleph: :"&#2135;",
        infty: :"&#221E;",
        equiv: :"&#2261;",
        frown: :"&#2322;",
        notin: :"&#2209;",
        angle: :"&#2220;",
        "!in": :"&#x2209;",
        cdots: :"&#x22EF;",
        vdash: :"&#x22A2;",
        wedge: :"&#x2227;",
        oplus: :"&#x2295;",
        nabla: :"&#x2207;",
        ddots: :"&#x22F1;",
        vdots: :"&#x22EE;",
        Sigma: :"&#3A3;",
        Omega: :"&#3A9;",
        omega: :"&#3C9;",
        sigma: :"&#3C3;",
        times: :"&#xD7;",
        ldots: :"...",
        ">-=": :"&#x2AB0;",
        "-<=": :"&#x2AAF;",
        "><|": :"&#x22CA;",
        "|==": :"&#x22A8;",
        "|--": :"&#x22A2;",
        "^^^": :"&#x22C0;",
        "|->": :"&#x21A6;",
        ">->": :"&#x21A3;",
        "->>": :"&#x21A0;",
        "__|": :"&#x230B;",
        "|__": :"&#x230A;",
        "|><": :"&#x22C9;",
        "_|_": :"&#x22A5;",
        "***": :"&#x22C6;",
        "<=>": :"&#x21D4;",
        quad: :"&#xA0;&#xA0;",
        star: :"&#x22C6;",
        odot: :"&#x2299;",
        cdot: :"&#x22C5;",
        rarr: :"&#x2192;",
        darr: :"&#x2193;",
        prop: :"&#x221D;",
        lArr: :"&#x21D0;",
        rArr: :"&#x21D2;",
        uarr: :"&#x2191;",
        hArr: :"&#x21D4;",
        harr: :"&#x2194;",
        larr: :"&#x2190;",
        grad: :"&#x2207;",
        circ: :"&#x2218;",
        sube: :"&#x2286;",
        supe: :"&#x2287;",
        succ: :"&#227B;",
        prec: :"&#227A;",
        cong: :"&#2245;",
        beta: :"&#x3B2;",
        zeta: :"&#x3B6;",
        iota: :"&#x3B9;",
        ":'": :"&#x2235;",
        "^^": :"&#x2227;",
        "o+": :"&#x2295;",
        "o.": :"&#x2299;",
        "**": :"&#x2217;",
        "~~": :"&#x2248;",
        "O/": :"&#x2205;",
        "->": :"&#x2192;",
        "=>": :"&#x21D2;",
        ">>": :"&#x232A;",
        "<<": :"&#x2329;",
        "~|": :"&#x2309;",
        "!=": :"&#x2260;",
        ">-": :"&#x227B;",
        "-<": :"&#x227A;",
        "~=": :"&#x2245;",
        "-=": :"&#x2261;",
        ":.": :"&#x2234;",
        ">=": :"&#x2265;",
        "<=": :"&#x2264;",
        "|~": :"&#x2308;",
        "/_": :"&#x2220;",
        "+-": :"&#xB1;",
        "-:": :"&#xF7;",
        sup: :"&#x2283;",
        sub: :"&#x2282;",
        top: :"&#x22A4;",
        vvv: :"&#x22C1;",
        vee: :"&#x2228;",
        nnn: :"&#x22C2;",
        cap: :"&#x2229;",
        ast: :"&#x2217;",
        bot: :"&#x22A5;",
        del: :"&#x2202;",
        uuu: :"&#x22C3;",
        cup: :"&#x222A;",
        iff: :"&#x21D4;",
        eta: :"&#x3B7;",
        Phi: :"&#x3A6;",
        Psi: :"&#x3A8;",
        psi: :"&#x3C8;",
        chi: :"&#x3C7;",
        phi: :"&#x3D5;",
        rho: :"&#x3C1;",
        tau: :"&#x3C4;",
        div: :"&#xF7;",
        neg: :"&#xAC;",
        not: :"&#xAC;",
        "@": :"&#x2218;",
        "*": :"&#x22C5;",
        "<": :"&lt;",
        ">": :"&gt;",
        "-": :"-",
        "=": :"=",
        "+": :"+",
        "/": :"/",
        nn: :"&#x2229;",
        vv: :"&#x2228;",
        TT: :"&#x22A4;",
        EE: :"&#x2203;",
        ox: :"&#x2297;",
        to: :"&#x2192;",
        AA: :"&#x2200;",
        uu: :"&#x222A;",
        ne: :"&#x2260;",
        ZZ: :"&#x2124;",
        RR: :"&#x211D;",
        QQ: :"&#x211A;",
        NN: :"&#x2115;",
        CC: :"&#x2102;",
        oo: :"&#x221E;",
        ge: :"&#x2265;",
        le: :"&#x2264;",
        in: :"&#x2208;",
        nu: :"&#x3BD;",
        mu: :"&#x3BC;",
        pi: :"&#x3C0;",
        Pi: :"&#x3A0;",
        xi: :"&#x3BE;",
        Xi: :"&#x39E;",
        xx: :"&#xD7;",
        pm: :"&#xB1;",
        gt: :"&gt;",
        lt: :"&lt;",
      }.freeze
      UNARY_CLASSES = %i[
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
        color
        prod
        frac
        root
        oint
        int
        sum
        mod
        log
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
        fr
        cc
        sf
        tt
      ].freeze
    end
  end
end
