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
        "&#x2206;": "increment",
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
        "&#x22c5;": "cdot",
        "&#x2219;": "*",
        "&#x2e;": ".",
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
        "&#x2329;": "<<",
        "&#x232a;": ">>",
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
        "&#x203e;": "overline",
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
        "&#x21a3;": ">->",
        "&#x21a0;": "->>",
        "&#x2916;": ">->>",
        "&#x21a6;": "|->",
        "&#x2026;": "...",
        "&#x2212;": "-",
        "&#x23de;": "obrace",
        "&#x23df;": "ubrace",
        "&#x2192;": "vec",
        "&#x302;": "hat",
        "&#x332;": "ul",
        "&#xaf;": "bar",
        "&#x26;": "&",
        "&#x3e;": ">",
        "&#x3c;": "<",
        "&amp;": "&",
        "~": "tilde",
        "..": "ddot",
        "^": "hat",
        "¯": "bar",
        "_": "ul",
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
        overline
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
      ].freeze
      OPERATORS = [
        "&#x00a0;&#x00a0;&#x00a0;&#x00a0;",
        "&#x00a0;&#x00a0;",
        "&#x002a;",
        "&#x003c;",
        "&#x003e;",
        "&#x00a0;",
        "&#x00ac;",
        "&#x00b1;",
        "&#x00d7;",
        "&#x00f7;",
        "&#x0393;",
        "&#x0394;",
        "&#x0398;",
        "&#x039b;",
        "&#x039e;",
        "&#x03a0;",
        "&#x03a3;",
        "&#x03a9;",
        "&#x2026;",
        "&#x2032;",
        "&#x2102;",
        "&#x2115;",
        "&#x211a;",
        "&#x211d;",
        "&#x2124;",
        "&#x2135;",
        "&#x2190;",
        "&#x2191;",
        "&#x2192;",
        "&#x2192;",
        "&#x2193;",
        "&#x2194;",
        "&#x21a0;",
        "&#x21a3;",
        "&#x21a6;",
        "&#x21d0;",
        "&#x21d2;",
        "&#x21d2;",
        "&#x21d4;",
        "&#x21d4;",
        "&#x2200;",
        "&#x2202;",
        "&#x2203;",
        "&#x2205;",
        "&#x2207;",
        "&#x2208;",
        "&#x2209;",
        "&#x220f;",
        "&#x2211;",
        "&#x2212;",
        "&#x2213;",
        "&#x221d;",
        "&#x221e;",
        "&#x2220;",
        "&#x2227;",
        "&#x2228;",
        "&#x2229;",
        "&#x222a;",
        "&#x222b;",
        "&#x222e;",
        "&#x2234;",
        "&#x2235;",
        "&#x223c;",
        "&#x2245;",
        "&#x2248;",
        "&#x2254;",
        "&#x2260;",
        "&#x2261;",
        "&#x2264;",
        "&#x2265;",
        "&#x226a;",
        "&#x226b;",
        "&#x227a;",
        "&#x227b;",
        "&#x2282;",
        "&#x2283;",
        "&#x2286;",
        "&#x2287;",
        "&#x2295;",
        "&#x2297;",
        "&#x2299;",
        "&#x22a2;",
        "&#x22a4;",
        "&#x22a5;",
        "&#x22a8;",
        "&#x22c0;",
        "&#x22c1;",
        "&#x22c2;",
        "&#x22c3;",
        "&#x22c4;",
        "&#x22c5;",
        "&#x22c6;",
        "&#x22c8;",
        "&#x22c9;",
        "&#x22ca;",
        "&#x22ee;",
        "&#x22ef;",
        "&#x22f1;",
        "&#x2308;",
        "&#x2309;",
        "&#x230a;",
        "&#x230b;",
        "&#x2322;",
        "&#x25a1;",
        "&#x25b3;",
        "&#x26ac;",
        "&#x2916;",
        "&#x2aaf;",
        "&#x2ab0;",
        "&#x2b;",
        "&#x3d;",
        "&#x3a;",
        "&#x3c;",
        "&#xd7;",
        "&#xb1;",
        "&#x26;",
        "&#x3b;",
        "&#x3e;",
        "&#x7c;",
        "lim",
        "max",
        "min",
        "\\",
        "//",
        "/",
        "if",
        "^",
        "_",
        "+",
        "/",
        "=",
        ":",
        ",",
        ")",
        "(",
        "[",
        "]",
      ].freeze
      SUPPORTED_FONT_STYLES = {
        "sans-serif-bold-italic": Math::Function::FontStyle::SansSerifBoldItalic,
        "sans-serif-italic": Math::Function::FontStyle::SansSerifItalic,
        "bold-sans-serif": Math::Function::FontStyle::BoldSansSerif,
        "double-struck": Math::Function::FontStyle::DoubleStruck,
        "bold-fraktur": Math::Function::FontStyle::BoldFraktur,
        "bold-italic": Math::Function::FontStyle::BoldItalic,
        "bold-script": Math::Function::FontStyle::BoldScript,
        "sans-serif": Math::Function::FontStyle::SansSerif,
        monospace: Math::Function::FontStyle::Monospace,
        fraktur: Math::Function::FontStyle::Fraktur,
        normal: Math::Function::FontStyle::Normal,
        script: Math::Function::FontStyle::Script,
        italic: Math::Function::FontStyle::Italic,
        bold: Math::Function::FontStyle::Bold,
      }.freeze
    end
  end
end
