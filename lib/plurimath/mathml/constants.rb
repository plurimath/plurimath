# frozen_string_literal: true

module Plurimath
  class Mathml
    class Constants
      UNICODE_SYMBOLS = {
        "&#x3B1;": "alpha",
        "&#x3B2;": "beta",
        "&#x3B3;": "gamma",
        "&#x393;": "Gamma",
        "&#x3B4;": "delta",
        "&#x394;": "Delta",
        "&#x2206;": "Delta",
        "&#x3B5;": "epsilon",
        "&#x25b;": "varepsilon",
        "&#x3B6;": "zeta",
        "&#x3B7;": "eta",
        "&#x3B8;": "theta",
        "&#x398;": "Theta",
        "&#x3D1;": "vartheta",
        "&#x3B9;": "iota",
        "&#x3BA;": "kappa",
        "&#x3BB;": "lambda",
        "&#x39B;": "Lambda",
        "&#x3BC;": "mu",
        "&#x3BD;": "nu",
        "&#x3BE;": "xi",
        "&#x39E;": "Xi",
        "&#x3C0;": "pi",
        "&#x3A0;": "Pi",
        "&#x3C1;": "rho",
        "&#x3C2;": "beta",
        "&#x3C3;": "sigma",
        "&#x3A3;": "Sigma",
        "&#x3C4;": "tau",
        "&#x3C5;": "upsilon",
        "&#x3C6;": "phi",
        "&#x3A6;": "Phi",
        "&#x3D5;": "varphi",
        "&#x3C7;": "chi",
        "&#x3C8;": "psi",
        "&#x3A8;": "Psi",
        "&#x3C9;": "omega",
        "&#x3A9;": "omega",
        "&#x22C5;": "dot",
        "&#x2219;": "*",
        "&#xB7;": ".",
        "&#x2217;": "**",
        "&#x22C6;": "***",
        "&#xD7;": "xx",
        "&#x22C9;": "|><",
        "&#x22CA;": "><|",
        "&#x22C8;": "|><|",
        "&#xF7;": "-:",
        "&#x2218;": "@",
        "&#x2295;": "o+",
        "&#x2A01;": "o+",
        "&#x2297;": "ox",
        "&#x2299;": " ",
        "&#x2211;": "sum",
        "&#x220f;": "prod",
        "&#x220F;": "prod",
        "&#x2227;": "^^",
        "&#x22C0;": "^^^",
        "&#x2228;": "vv",
        "&#x22c1;": "vvv",
        "&#x2229;": "nn",
        "&#x22C2;": "nnn",
        "&#x222A;": "cup",
        "&#x22C3;": "uuu",
        "&#x2260;": "!=",
        "&#x2264;": "<=",
        "&#x2265;": ">=",
        "&#x227A;": "-<",
        "&#x227B;": ">-",
        "&#x2AAF;": "-<=",
        "&#x2AB0;": " >-=",
        "&#x2208;": "in",
        "&#x2209;": "!in",
        "&#x2282;": "sub",
        "&#x2283;": "sup",
        "&#x2286;": "sube",
        "&#x2287;": "supe",
        "&#x2261;": "-=",
        "&#x2245;": "~=",
        "&#x2248;": "~~",
        "&#x221D;": "prop",
        "&#xAC;": "not",
        "&#x2200;": "AA",
        "&#x2203;": "EE",
        "&#x22A5;": "_|_",
        "&#x22A4;": "TT",
        "&#x22A2;": "|--",
        "&#x22A8;": "|==",
        "&#x2329;": "(:",
        "&#x232A;": ":)",
        "&#x27E8;": "<<",
        "&#x27E9;": ">>",
        "&#x222B;": "int",
        "&#x222E;": "oint",
        "&#x2202;": "del",
        "&#x2207;": "grad",
        "&#xB1;": "+-",
        "&#x2205;": "O/",
        "&#x221E;": "oo",
        "&#x2135;": "aleph",
        "&#x2234;": ":.",
        "&#x2235;": ":'",
        "&#x2220;": "/_",
        "&#x25B3;": "/_\\",
        "&#x2032;": "'",
        "&#xA0;&#xA0;": "quad",
        "&#xA0;&#xA0;&#xA0;&#xA0;": "qquad",
        "&#x2322;": "frown",
        "&#x22EF;": "cdots",
        "&#x22EE;": "vdots",
        "&#x22F1;": "ddots",
        "&#x22C4;": "diamond",
        "&#x25A1;": "square",
        "&#x230A;": "|__",
        "&#x230B;": "__|",
        "&#x2308;": "|~",
        "&#x2309;": "~|",
        "&#x2102;": "CC",
        "&#x2115;": "NN",
        "&#x211A;": "QQ",
        "&#x211D;": "RR",
        "&#x2124;": "ZZ",
        "&#x2191;": "uarr",
        "&#x2193;": "darr",
        "&#x2190;": "larr",
        "&#x2194;": "harr",
        "&#x21D2;": "rArr",
        "&#x21D0;": "lArr",
        "&#x21D4;": "hArr",
        "&#x2192;": "->",
        "&#x21A3;": ">->",
        "&#x21A0;": "->>",
        "&#x2916;": ">->>",
        "&#x21A6;": "|->",
        "&#x2026;": "...",
        "&#x2212;": "-",
        "&#x2061;": "",
        "&#x2751;": "square",
        "&#x23DE;": "obrace",
        "&#x23DF;": "ubrace",
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
      FONT_CLASSES = {
        "fraktur": Plurimath::Math::Function::Mathfrak,
        "sans-serif": Plurimath::Math::Function::Mathsf,
        "monospace": Plurimath::Math::Function::Mathtt,
        "script": Plurimath::Math::Function::Mathcal,
        "double-struck": Plurimath::Math::Function::Mathbb,
        "bold": Plurimath::Math::Function::Mathbf,
      }.freeze
    end
  end
end
