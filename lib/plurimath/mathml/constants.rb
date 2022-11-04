# frozen_string_literal: true

module Plurimath
  class Mathml
    class Constants
      UNICODE_SYMBOLS = {
        "&#x3b1;": "alpha",
        "&#x3b2;": "beta",
        "&#x3b3;": "gamma",
        "&#x393;": "Gamma",
        "&#x3b4;": "delta",
        "&#x394;": "Delta",
        "&#x2206;": "Delta",
        "&#x3b5;": "epsilon",
        "&#x25b;": "varepsilon",
        "&#x3b6;": "zeta",
        "&#x3b7;": "eta",
        "&#x3b8;": "theta",
        "&#x398;": "Theta",
        "&#x3d1;": "vartheta",
        "&#x3b9;": "iota",
        "&#x3ba;": "kappa",
        "&#x3bb;": "lambda",
        "&#x39b;": "Lambda",
        "&#x3bc;": "mu",
        "&#x3bd;": "nu",
        "&#x3be;": "xi",
        "&#x39e;": "Xi",
        "&#x3C0;": "pi",
        "&#x3a0;": "Pi",
        "&#x3c1;": "rho",
        "&#x3c2;": "beta",
        "&#x3c3;": "sigma",
        "&#x3a3;": "Sigma",
        "&#x3c4;": "tau",
        "&#x3c5;": "upsilon",
        "&#x3c6;": "phi",
        "&#x3a6;": "Phi",
        "&#x3d5;": "varphi",
        "&#x3c7;": "chi",
        "&#x3c8;": "psi",
        "&#x3a8;": "Psi",
        "&#x3c9;": "omega",
        "&#x3a9;": "omega",
        "&#x22c5;": "dot",
        "&#x2219;": "*",
        "&#xb7;": ".",
        "&#x2217;": "**",
        "&#x22c6;": "***",
        "&#xd7;": "xx",
        "&#x22c9;": "|><",
        "&#x22ca;": "><|",
        "&#x22c8;": "|><|",
        "&#xf7;": "-:",
        "&#x2218;": "@",
        "&#x2295;": "o+",
        "&#x2a01;": "o+",
        "&#x2297;": "ox",
        "&#x2299;": " ",
        "&#x2211;": "sum",
        "&#x220f;": "prod",
        "&#x2227;": "^^",
        "&#x22c0;": "^^^",
        "&#x2228;": "vv",
        "&#x22c1;": "vvv",
        "&#x2229;": "nn",
        "&#x22c2;": "nnn",
        "&#x222a;": "cup",
        "&#x22c3;": "uuu",
        "&#x2260;": "!=",
        "&#x2264;": "<=",
        "&#x2265;": ">=",
        "&#x227a;": "-<",
        "&#x227b;": ">-",
        "&#x2aaf;": "-<=",
        "&#x2ab0;": " >-=",
        "&#x2208;": "in",
        "&#x2209;": "!in",
        "&#x2282;": "sub",
        "&#x2283;": "sup",
        "&#x2286;": "sube",
        "&#x2287;": "supe",
        "&#x2261;": "-=",
        "&#x2245;": "~=",
        "&#x2248;": "~~",
        "&#x221d;": "prop",
        "&#xac;": "not",
        "&#x2200;": "AA",
        "&#x2203;": "EE",
        "&#x22a5;": "_|_",
        "&#x22a4;": "TT",
        "&#x22a2;": "|--",
        "&#x22a8;": "|==",
        "&#x2329;": "(:",
        "&#x232a;": ":)",
        "&#x27e8;": "<<",
        "&#x27e9;": ">>",
        "&#x222b;": "int",
        "&#x222e;": "oint",
        "&#x2202;": "del",
        "&#x2207;": "grad",
        "&#xb1;": "+-",
        "&#x2205;": "O/",
        "&#x221e;": "oo",
        "&#x2135;": "aleph",
        "&#x2234;": ":.",
        "&#x2235;": ":'",
        "&#x2220;": "/_",
        "&#x25b3;": "/_\\",
        "&#x2032;": "'",
        "&#xa0;&#xa0;": "quad",
        "&#xa0;&#xa0;&#xa0;&#xa0;": "qquad",
        "&#x2322;": "frown",
        "&#x22ef;": "cdots",
        "&#x22ee;": "vdots",
        "&#x22f1;": "ddots",
        "&#x22c4;": "diamond",
        "&#x25a1;": "square",
        "&#x230a;": "|__",
        "&#x230b;": "__|",
        "&#x2308;": "|~",
        "&#x2309;": "~|",
        "&#x2102;": "CC",
        "&#x2115;": "NN",
        "&#x211a;": "QQ",
        "&#x211d;": "RR",
        "&#x2124;": "ZZ",
        "&#x2191;": "uarr",
        "&#x2193;": "darr",
        "&#x2190;": "larr",
        "&#x2194;": "harr",
        "&#x21d2;": "rArr",
        "&#x21d0;": "lArr",
        "&#x21d4;": "hArr",
        "&#x2192;": "->",
        "&#x21a3;": ">->",
        "&#x21a0;": "->>",
        "&#x2916;": ">->>",
        "&#x21a6;": "|->",
        "&#x2026;": "...",
        "&#x2212;": "-",
        "&#x23de;": "obrace",
        "&#x23df;": "ubrace",
        "&#x26;": "&",
        "&#x3e;": ">",
        "&#x3c;": "<",
      }.freeze
      SYMBOLS = {
        "|": "|",
        "/": "//",
        "\\": "\\\\",
        "~": "tilde",
        "(": "(",
        ")": ")",
        "(:": "(:",
        ":)": ":)",
        "{": "{",
        "}": "}",
        "{:": "{:",
        ":}": ":}",
        "]": "]",
        "[": "[",
        "=": "=",
        "+": "+",
        "-": "-",
      }.freeze
      CLASSES = %w[
        mathfrak
        underset
        stackrel
        overset
        mathcal
        arccos
        arcsin
        arctan
        mathsf
        mathbb
        mathbf
        mathtt
        ubrace
        obrace
        cancel
        tilde
        floor
        color
        frac
        root
        oint
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
        prod
        sec
        int
        sin
        tan
        cos
        sum
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
        mod
        log
        ul
        ln
        f
        g
      ].freeze
      TAGS = %i[
        annotation-xml
        annotation_xml
        mmultiscripts
        maligngroup
        malignmark
        annotation
        munderover
        mscarries
        semantics
        mphantom
        mlongdiv
        menclose
        mscarry
        msubsup
        mpadded
        maction
        msgroup
        mfenced
        merror
        munder
        mtable
        mstyle
        mstack
        mspace
        msline
        mfrac
        mover
        msrow
        mroot
        msqrt
        msup
        msub
        mrow
        math
        mtr
        mtd
        ms
        mi
        mo
        mn
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
      FONT_CLASSES = %i[
        double-struck
        sans-serif
        monospace
        fraktur
        script
        bold
      ].freeze
    end
  end
end
