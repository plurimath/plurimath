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
        "&#x305;": "bar",
        "&#x20e1;": "overleftrightarrow",
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
        _: "ul",
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
      # Named operators that have no dedicated MathML/OMML representation — no
      # unicode character and no structural element — so a bare <mi>/<mo>/<m:t>
      # word (e.g. <mi>sin</mi>, <m:t>min</m:t>) is their only written form and
      # resolves to the function class. Every other CLASSES entry has a proper
      # form — a diacritic character (bar/hat/vec via <mover>), a unicode symbol
      # (sum/prod/int via &#x2211; etc.), or a structural element (frac via
      # <mfrac>/<m:f>, sqrt via <msqrt>) — so its bare word is a literal
      # identifier, not the function. See PR #450 (which introduced this for accents).
      NAMED_FUNCTION_WORDS = %w[
        arccos arcsin arctan sin cos tan sec csc cot sinh cosh tanh coth sech
        csch log ln exp det dim gcd lcm glb lub max min mod
      ].freeze

      # True when +string+ is a bare word naming an operator that has no other
      # MathML/OMML representation, so it legitimately resolves to its function
      # class. Words for constructs that DO have a character/structural form
      # (accents, sum/prod/int, frac/sqrt/...) return false and stay literal.
      def self.named_function_word?(string)
        NAMED_FUNCTION_WORDS.include?(string&.strip)
      end

      CLASSES = %w[
        mathfrak
        underset
        stackrel
        overline
        overset
        overleftrightarrow
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
