# frozen_string_literal: true

module Plurimath
  class UnicodeMath
    class Constants
      UNARY_FUNCTIONS = %w[
        cos
        cot
        csc
        sec
        sin
        tan
        arg
        def
        deg
        det
        dim
        erf
        exp
        gcd
        hom
        inf
        ker
        lim
        log
        max
        min
        mod
        sup
        Im
        Pr
        Re
        ln
        tg
      ].freeze

      UNARY_SYMBOLS = {
        underline: "&#x2581;",
        hphantom: "&#x2b04;",
        vphantom: "&#x21f3;",
        underbar: "&#x2581;",
        phantom: "&#x27e1;",
        longdiv: "&#x27cc;",
        overline: "&#xaf;",
        circle: "&#x25cb;",
        hsmash: "&#x2b0c;",
        overbar: "&#xaf;",
      }.freeze

      BINARY_SYMBOLS = {
        ast: "&#x2217;",
        boxdot: "&#x22a1;",
        boxminus: "&#x229f;",
        boxplus: "&#x229e;",
        boxtimes: "&#x22a0;",
        bullet: "&#x2219;",
        Cap: "&#x22d2;",
        cap: "&#x2229;",
        cdot: "&#x22c5;",
        circ: "&#x2218;",
        Cup: "&#x22d3;",
        cup: "&#x222a;",
        curlyvee: "&#x22ce;",
        curlywedge: "&#x22cf;",
        diamond: "&#x22c4;",
        div: "&#xf7;",
        divideontimes: "&#xc7;",
        dotminus: "&#x2238;",
        dotplus: "&#x2214;",
        funcapply: "&#x2061;",
        intercal: "&#x22ba;",
        ldiv: "&#x2215;",
        leftthreetimes: "&#x22cb;",
        lor: "&#x2228;",
        ltimes: "&#x22c9;",
        ndiv: "&#x2298;",
        not: "&#x0338;",
        oast: "&#x229b;",
        ocirc: "&#x229a;",
        odash: "&#x229d;",
        odot: "&#x2299;",
        oeq: "&#x229c;",
        ominus: "&#x2296;",
        oplus: "&#x2295;",
        oslash: "&#x2298;",
        otimes: "&#x2297;",
        pitchfork: "&#x22d4;",
        rightthreetimes: "&#x22cc;",
        rtimes: "&#x22ca;",
        sdiv: "&#x2044;",
        sdivide: "&#x2044;",
        setminus: "&#x2216;",
        sfrac: "&#x2044;",
        sqcap: "&#x2293;",
        sqcup: "&#x2294;",
        star: "&#x22c6;",
        times: "&#xd7;",
        triangle: "&#x25b3;",
        uplus: "&#x228e;",
        wedge: "&#x2227;",
        wr: "&#x2240;",
      }.freeze

      NARY_SYMBOLS = {
        amalg: "&#x2210;",
        aoint: "&#x2233;",
        bigcap: "&#x22c2;",
        bigcup: "&#x22c3;",
        bigodot: "&#x2a00;",
        bigoplus: "&#x2a01;",
        bigotimes: "&#x2a02;",
        bigsqcap: "&#x2a05;",
        bigsqcup: "&#x2a06;",
        bigudot: "&#x2a00;",
        biguplus: "&#x2a04;",
        bigvee: "&#x22c1;",
        bigwedge: "&#x22c0;",
        coint: "&#x2232;",
        coprod: "&#x2210;",
        cwint: "&#x2231;",
        iiiint: "&#x2a0c;",
        iiint: "&#x222d;",
        iint: "&#x222c;",
        int: "&#x222b;",
        oiiint: "&#x2230;",
        oiint: "&#x222f;",
        oint: "&#x222e;",
        prod: "&#x220f;",
        sum: "&#x2211;",
      }.freeze

      OPEN_SYMBOLS = {
        begin: "&#x3016;",
        bra: "&#x27e8;",
        Langle: "&#x27ea;",
        langle: "&#x27e8;",
        lbbrack: "&#x27e6;",
        lbrace: "&#x7b;",
        Lbrack: "&#x27e6;",
        lbrack: "&#x5b;",
        lceil: "&#x2308;",
        lfloor: "&#x230a;",
      }.freeze

      CLOSE_SYMBOLS = {
        end: "&#x3017;",
        ket: "&#x27e9;",
        Rangle: "&#x27eb;",
        rangle: "&#x27e9;",
        rbbrack: "&#x27e7;",
        rbace: "&#x7d;",
        Rbrack: "&#x27e7;",
        rbrack: "&#x5d;",
        rceil: "&#x2309;",
        rfloor: "&#x230b;",
      }.freeze

      RELATIONAL_SYMBOLS = {
        angmsd: "&#x2221;",
        angrtvb: "&#x22be;",
        angsph: "&#x2222;",
        approx: "&#x2248;",
        approxeq: "&#x224a;",
        asymp: "&#x224d;",
        backsim: "&#x223d;",
        backsimeq: "&#x22cd;",
        because: "&#x2235;",
        between: "&#x226c;",
        bot: "&#x22a5;",
        bowtie: "&#x22c8;",
        bumpeq: "&#x224f;",
        circeq: "&#x2257;",
        circlearrowleft: "&#x21ba;",
        circlearrowright: "&#x21bb;",
        Colon: "&#x2237;",
        colon: "&#x2236;",
        cong: "&#x2245;",
        curlyeqprec: "&#x22de;",
        curlyeqsucc: "&#x22df;",
        curvearrowleft: "&#x21e0;",
        dasharrowright: "&#x21eb;",
        dashv: "&#x22a3;",
        ddots: "&#x22f1;",
        Doteq: "&#x2251;",
        doteq: "&#x2250;",
        Downarrow: "&#x21d3;",
        downarrow: "&#x2193;",
        downarrows: "&#x21ca;",
        downharpoonleft: "&#x21c3;",
        downharpoonright: "&#x21c2;",
        eqcirc: "&#x2256;",
        eqgtr: "&#x22dd;",
        equiv: "&#x2261;",
        fallingdotseq: "&#x2252;",
        ge: "&#x2265;",
        geq: "&#x2265;",
        geqq: "&#x2267;",
        gg: "&#x226b;",
        ggg: "&#x22d9;",
        gneqq: "&#x2269;",
        gtrdot: "&#x22d7;",
        gtreqless: "&#x22db;",
        gtrless: "&#x2277;",
        gtrsim: "&#x2273;",
        hookleftarrow: "&#x21a9;",
        hookrightarrow: "&#x21aa;",
        iff: "&#x27ff;",
        in: "&#x2208;",
        le: "&#x2264;",
        Leftarrow: "&#x21d0;",
        leftarrow: "&#x2190;",
        leftarrowtail: "&#x21a2;",
        leftharpoondown: "&#x21bd;",
        leftharpoonup: "&#x21bc;",
        leftleftarrows: "&#x21c7;",
        Leftrightarrow: "&#x21d4;",
        leftrightarrow: "&#x2194;",
        leftrightarrows: "&#x21c6;",
        leftrightharpoons: "&#x21cb;",
        leftrightwavearrow: "&#x21ad;",
        leftsquigarrow: "&#x21dc;",
        leftwavearrow: "&#x219c;",
        leq: "&#x2264;",
        leqq: "&#x2266;",
        lessdot: "&#x22d6;",
        lesseqgtr: "&#x22da;",
        lessgtr: "&#x2276;",
        lesssim: "&#x2272;",
        ll: "&#x226a;",
        lmoust: "&#x22b0;",
        lneq: "&#x2268;",
        # lnot: "&#xac;",
        lnsim: "&#x22e6;",
        Longleftarrow: "&#x27f8;",
        longleftarrow: "&#x27f5;",
        Longleftrightarrow: "&#x27fa;",
        Longrightarrow: "&#x27f9;",
        longrightarrow: "&#x27f6;",
        looparrowleft: "&#x21ac;",
        lrhar: "&#x21cb;",
        mapsto: "&#x21a6;",
        mapstoleft: "&#x21a4;",
        mid: "&#x2223;",
        models: "&#x22a8;",
        multimap: "&#x22b8;",
        napprox: "&#x2249;",
        nasymp: "&#x226d;",
        ncong: "&#x2247;",
        ne: "&#x2260;",
        nearrow: "&#x2197;",
        neq: "&#x2260;",
        nequiv: "&#x2262;",
        ngeq: "&#x2271;",
        ngt: "&#x226f;",
        ni: "&#x220b;",
        nLeftarrow: "&#x21cd;",
        nleftarrow: "&#x219a;",
        nLeftrightarrow: "&#x21ce;",
        nleftrightarrow: "&#x21ae;",
        nleq: "&#x2270;",
        nless: "&#x226e;",
        nmid: "&#x2224;",
        notin: "&#x2209;",
        notni: "&#x220c;",
        nparallel: "&#x2226;",
        nprec: "&#x2280;",
        npreccurlyeq: "&#x22e0;",
        nRightarrow: "&#x21cf;",
        nrightarrow: "&#x219b;",
        nsim: "&#x2241;",
        nsimeq: "&#x2244;",
        nsqsubseteq: "&#x22e2;",
        nsqsuperseteq: "&#x22e3;",
        nsub: "&#x2284;",
        subseteq: "&#x2288;",
        nsucc: "&#x2281;",
        nsucccurlyeq: "&#x22e1;",
        nsup: "&#x2285;",
        nsupseteq: "&#x2288;",
        ntriangleleft: "&#x22ea;",
        ntriangleright: "&#x22eb;",
        ntrianglerighteq: "&#x22ed;",
        nVdash: "&#x22ad;",
        nvdash: "&#x22ac;",
        nwarrow: "&#x2196;",
        parallel: "&#x2196;",
        perp: "&#x22a5;",
        prcue: "&#x227c;",
        prec: "&#x227a;",
        preccurlyeq: "&#x227c;",
        preceq: "&#x2aaf;",
        precnsim: "&#x22e8;",
        precsim: "&#x227e;",
        propto: "&#x221d;",
        ratio: "&#x221d;",
        rddots: "&#x22f0;",
        rdsh: "&#x21b3;",
        Rightarrow: "&#x21d2;",
        rightarrow: "&#x2192;",
        rightarrowtail: "&#x21a3;",
        rightharpoondown: "&#x21c1;",
        rightharpoonup: "&#x21c0;",
        rightleftarrows: "&#x21c4;",
        rightleftharpoons: "&#x21cc;",
        rightrightarrows: "&#x21c9;",
        rightsquigarrow: "&#x21dd;",
        rightwavearrow: "&#x219d;",
        risingdotseq: "&#x2253;",
        rlhar: "&#x21cc;",
        rmoust: "&#x23b1;",
        searrow: "&#x2198;",
        sim: "&#x223c;",
        simeq: "&#x2243;",
        sqsubset: "&#x228f;",
        sqsubseteq: "&#x2291;",
        sqsupset: "&#x2290;",
        sqsupseteq: "&#x2292;",
        Subset: "&#x22d0;",
        subset: "&#x2282;",
        subsetneq: "&#x228a;",
        subsub: "&#x2ad3;",
        succ: "&#x227b;",
        succcurlyeq: "&#x227d;",
        succeq: "&#x2ab0;",
        succnsim: "&#x22e9;",
        succsim: "&#x227f;",
        Supset: "&#x22d1;",
        supset: "&#x2283;",
        supseteq: "&#x2287;",
        supsetneq: "&#x228b;",
        supsub: "&#x2ad4;",
        supsup: "&#x2ad6;",
        swarrow: "&#x2199;",
        therefore: "&#x2234;",
        to: "&#x2192;",
        top: "&#x22a4;",
        trianglelefteq: "&#x22b4;",
        trianglerighteq: "&#x22b5;",
        twoheadleftarrow: "&#x219e;",
        twoheadrightarrow: "&#x21a0;",
        Uparrow: "&#x21d1;",
        uparrow: "&#x2191;",
        Updownarrow: "&#x21d5;",
        updownarrow: "&#x2195;",
        updownarrows: "&#x21c5;",
        upharpoonleft: "&#x21bf;",
        upharpoonright: "&#x21be;",
        upuparrows: "&#x21c8;",
        vartriangleleft: "&#x22b2;",
        vartriangleright: "&#x22b3;",
        VDash: "&#x22ab;",
        Vdash: "&#x22a9;",
        vdash: "&#x22a2;",
        vdots: "&#x22ee;",
        Vvdash: "&#x22aa;",
      }.freeze

      HORIZONTAL_BRACKETS = {
        underbracket: "&#x23b5;",
        overbracket: "&#x23b4;",
        undershell: "&#x23e1;",
        underparen: "&#x23dd;",
        underbrace: "&#x23df;",
        overshell: "&#x23e0;",
        overparen: "&#x23dc;",
        overbrace: "&#x23de;",
      }.freeze

      ORDINARY_SYMBOLS = {
        diamondsuit: "&#x2664;",
        varepsilon: "&#x03b5;",
        rightangle: "&#x2220;",
        complement: "&#x2201;",
        spadesuit: "&#x2660;",
        emptyset: "&#x2205;",
        vartheta: "&#x03d1;",
        varsigma: "&#x03c2;",
        varkappa: "&#x03f0;",
        hearsuit: "&#x2661;",
        clubsuit: "&#x2663;",
        partial: "&#x2202;",
        nexists: "&#x2204;",
        upsilon: "&#x03c5;",
        Upsilon: "&#x03a5;",
        epsilon: "&#x03f5;",
        Deltaeq: "&#x225c;",
        varrho: "&#x03f1;",
        forall: "&#x2200;",
        exists: "&#x2203;",
        varphi: "&#x03c6;",
        lambda: "&#x03bb;",
        Lambda: "&#x039b;",
        frown: "&#x2322;",
        nabla: "&#x2207;",
        angle: "&#x2220;",
        daleth: "&#x2138;",
        varpi: "&#x03d6;",
        theta: "&#x03b8;",
        Theta: "&#x0398;",
        sigma: "&#x03c3;",
        Sigma: "&#x03a3;",
        omega: "&#x03c9;",
        Omega: "&#x03A9;",
        medsp: "&#x205f;",
        ldots: "&#x2026;",
        kappa: "&#x03ba;",
        jmath: "&#x0237;",
        infty: "&#x221e;",
        imath: "&#x0131;",
        gimel: "&#x2137;",
        gamma: "&#x03b3;",
        Gamma: "&#x0393;",
        delta: "&#x03b4;",
        Delta: "&#x0394;",
        coint: "&#x2232;",
        cdots: "&#x23ef;",
        amalg: "&#x2210;",
        alpha: "&#x03b1;",
        aleph: "&#x2135;",
        "...": "&#x2026;",
        Vert: "&#x2016;",
        norm: "&#x2016;",
        zwsp: "&#x200b;",
        zwnj: "&#x200c;",
        zeta: "&#x03b6;",
        vbar: "&#x2502;",
        ldsh: "&#x21b2;",
        iota: "&#x03b9;",
        hbar: "&#x210f;",
        gets: "&#x2190;",
        degree: "&#xb0;",
        epar: "&#x22e5;",
        dots: "&#x2026;",
        degf: "&#x2109;",
        degc: "&#x2103;",
        ddag: "&#x2021;",
        beth: "&#x2136;",
        beta: "&#x02b2;",
        inc: "&#x2206;",
        tau: "&#x03c4;",
        rho: "&#x03c1;",
        qed: "&#x220e;",
        psi: "&#x03c8;",
        Psi: "&#x03a8;",
        phi: "&#x03d5;",
        Phi: "&#x03a6;",
        eta: "&#x03b7;",
        ell: "&#x2113;",
        dag: "&#x2020;",
        chi: "&#x03c7;",
        box: "&#x25a1;",
        vert: "&#x7c;",
        eqno: "&#x23;",
        mp: "&#x2213;",
        xi: "&#x03be;",
        wp: "&#x2118;",
        Re: "&#x211c;",
        pi: "&#x03c0;",
        Pi: "&#x03a0;",
        oo: "&#x03c9;",
        nu: "&#x03bd;",
        mu: "&#x03bc;",
        jj: "&#x2149;",
        Im: "&#x2111;",
        ii: "&#x2148;",
        dd: "&#x2146;",
        ee: "&#x2147;",
        neg: "&#xac;",
        pm: "&#xb1;",
      }.freeze

      SKIP_SYMBOLS = {
        emsp: "&#x2003;",
        ensp: "&#x2002;",
        hairsp: "&#x200a;",
        nbsp: "&#xa0;",
        numsp: "&#x2007;",
        quad: "&#x2003;",
        thicksp: "&#x2005;",
        thinsp: "&#x2006;",
        vthicksp: "&#x2004;",
      }.freeze

      OPEN_PARENTHESIS = [
        "[",
        "(",
        "{",
      ].freeze

      CLOSE_PARENTHESIS = [
        "]",
        ")",
        "}",
      ].freeze

      NEGATABLE_SYMBOLS = {
        "&#x2292;": "&#x22e3;",
        "&#x2291;": "&#x22e2;",
        "&#x2287;": "&#x2289;",
        "&#x2286;": "&#x2288;",
        "&#x2283;": "&#x2285;",
        "&#x2282;": "&#x2284;",
        "&#x227c;": "&#x22e0;",
        "&#x227b;": "&#x2281;",
        "&#x227a;": "&#x2280;",
        "&#x227d;": "&#x22e1;",
        "&#x2277;": "&#x2279;",
        "&#x2276;": "&#x2278;",
        "&#x2265;": "&#x2271;",
        "&#x2264;": "&#x2270;",
        "&#x2261;": "&#x2262;",
        "&#x224d;": "&#x226d;",
        "&#x2248;": "&#x2249;",
        "&#x2245;": "&#x2247;",
        "&#x2243;": "&#x2244;",
        "&#x223c;": "&#x2241;",
        "&#x220b;": "&#x220c;",
        "&#x2208;": "&#x2209;",
        "&#x2203;": "&#x2204;",
        "&#x3e;": "&#x226f;",
        "&#x3c;": "&#x226e;",
        "~": "&#x2241;",
        "=": "&#x2260;",
        # TODO: Following unicodes are incorrect yet.
        "&#xac;": "&#ac;",
        "+": "&#x220;",
        "-": "&#x220;",
      }.freeze

      PREFIXED_NEGATABLE_SYMBOLS = %w[
        sqsupseteq
        sqsubseteq
        supseteq
        subseteq
        emptyset
        gtrless
        lessgtr
        nexists
        approx
        exists
        supset
        subset
        forall
        preceq
        succeq
        simeq
        equiv
        frown
        nabla
        angle
        asymp
        succ
        prec
        cong
        neg
        inc
        sim
        ge
        le
        ni
        in
      ].freeze

      ACCENT_SYMBOLS = {
        widetilde: "&#x303;",
        pppprime: "&#x2057;",
        widehat: "&#x302;",
        ppprime: "&#x2034;",
        pprime: "&#x2033;",
        ddddot: "&#x20dc;",
        prime: "&#x2032;",
        breve: "&#x306;",
        check: "&#x30c;",
        tilde: "&#x303;",
        lhvec: "&#x20d0;",
        rhvec: "&#x20d1;",
        grave: "&#x300;",
        dddot: "&#x20db;",
        acute: "&#x301;",
        ddot: "&#x308;",
        lvec: "&#x20d6;",
        hvec: "&#x20d1;",
        ubar: "&#x332;",
        tvec: "&#x20e1;",
        dot: "&#x307;",
        Bar: "&#x33f;",
        bar: "&#x305;",
        hat: "&#x302;",
        vec: "&#x20d7;",
      }.freeze

      UNARY_ARG_FUNCTIONS = {
        bcancel: "&#x2572;",
        xcancel: "&#x2573;",
        ellipse: "&#x2b2d;",
        cancel: "&#x2571;",
        asmash: "&#x2b06;",
        dsmash: "&#x2b07;",
        smash: "&#x2b0d;",
        rrect: "&#x25a2;",
        rect: "&#x25ad;",
        abs: "&#x249c;",
      }.freeze

      FONTS_CLASSES = %w[
        mbfitsans
        mbffrak
        mitsans
        mbfsans
        fraktur
        mbfscr
        mitBbb
        double
        script
        mfrak
        msans
        mbfit
        mscr
        Bbb
        mup
        mbf
        mit
        mtt
      ].freeze

      ALPHANUMERIC_FONTS_CLASSES = %w[
        mbfsans
        msans
        Bbb
        mtt
        mbf
        mup
      ].freeze

      SIZE_OVERRIDES_SYMBOLS = {
        A: "1.25em",
        B: "1.5625em",
        C: "0.8em",
        D: "0.64em",
      }.freeze

      DIACRITIC_OVERLAYS = [
        '&#x20eb;',
        '&#x20ea;',
        '&#x20e6;',
        '&#x20e5;',
        '&#x20e4;',
        '&#x20e3;',
        '&#x20e2;',
        '&#x20e0;',
        '&#x20df;',
        '&#x20de;',
        '&#x20dd;',
        '&#x20da;',
        '&#x20d9;',
        '&#x20d8;',
        '&#x20d3;',
        '&#x20d2;',
        '&#x338;',
        '&#x337;',
        '&#x336;',
        '&#x335;',
        '&#x334;',
      ].freeze

      DIACRITIC_BELOWS = [
        '&#x304;',
        '&#x309;',
        '&#x316;',
        '&#x317;',
        '&#x318;',
        '&#x319;',
        '&#x31C;',
        '&#x31D;',
        '&#x31E;',
        '&#x31F;',
        '&#x320;',
        '&#x321;',
        '&#x322;',
        '&#x323;',
        '&#x324;',
        '&#x325;',
        '&#x326;',
        '&#x327;',
        '&#x328;',
        '&#x329;',
        '&#x32A;',
        '&#x32B;',
        '&#x32C;',
        '&#x32D;',
        '&#x32E;',
        '&#x32F;',
        '&#x330;',
        '&#x331;',
        '&#x332;',
        '&#x333;',
        '&#x339;',
        '&#x33A;',
        '&#x33B;',
        '&#x33C;',
        '&#x345;',
        '&#x347;',
        '&#x348;',
        '&#x349;',
        '&#x34D;',
        '&#x34E;',
        '&#x353;',
        '&#x354;',
        '&#x355;',
        '&#x356;',
        '&#x359;',
        '&#x35A;',
        '&#x35C;',
        '&#x35F;',
        '&#x362;',
        '&#x20E8;',
        '&#x20EC;',
        '&#x20ED;',
        '&#x20EE;',
        '&#x20EF;',
      ].freeze

      SUP_DIGITS = {
        "⁰": "&#x2070;",
        "¹": "&#xb9;",
        "²": "&#xb2;",
        "³": "&#xb3;",
        "⁴": "&#x2074;",
        "⁵": "&#x2075;",
        "⁶": "&#x2076;",
        "⁷": "&#x2077;",
        "⁸": "&#x2078;",
        "⁹": "&#x2079;"
      }.freeze

      SUB_DIGITS = {
        "₀": "&#x2080;",
        "₁": "&#x2081;",
        "₂": "&#x2082;",
        "₃": "&#x2083;",
        "₄": "&#x2084;",
        "₅": "&#x2085;",
        "₆": "&#x2086;",
        "₇": "&#x2087;",
        "₈": "&#x2088;",
        "₉": "&#x2089;",
      }.freeze

      SUB_ALPHABETS = {
        "ₐ": "&#x2090;",
        "ₑ": "&#x2091;",
        "ₕ": "&#x2095;",
        "ᵢ": "&#x1d62;",
        "ⱼ": "&#x2c7c;",
        "ₖ": "&#x2096;",
        "ₗ": "&#x2097;",
        "ₘ": "&#x2098;",
        "ₙ": "&#x2099;",
        "ₒ": "&#x2092;",
        "ₚ": "&#x209a;",
        "ᵣ": "&#x1d63;",
        "ₛ": "&#x209b;",
        "ₜ": "&#x209c;",
        "ᵤ": "&#x1d64;",
        "ᵥ": "&#x1d65;",
        "ₓ": "&#x2093;"
      }.freeze

      SUP_ALPHABETS = {
        "ᵃ": "&#x1d43;",
        "ᵇ": "&#x1d47;",
        "ᶜ": "&#x1d9c;",
        "ᵈ": "&#x1d48;",
        "ᵉ": "&#x1d49;",
        "ᶠ": "&#x1da0;",
        "ᵍ": "&#x1d4d;",
        "ʰ": "&#x2b0;",
        "ⁱ": "&#x2071;",
        "ʲ": "&#x2b2;",
        "ᵏ": "&#x1d4f;",
        "ˡ": "&#x2e1;",
        "ᵐ": "&#x1d50;",
        "ⁿ": "&#x207f;",
        "ᵒ": "&#x1d52;",
        "ᵖ": "&#x1d56;",
        "ʳ": "&#x2b3;",
        "ˢ": "&#x2e2;",
        "ᵗ": "&#x1d57;",
        "ᵘ": "&#x1d58;",
        "ᵛ": "&#x1d5b;",
        "ʷ": "&#x2b7;",
        "ˣ": "&#x2e3;",
        "ʸ": "&#x2b8;",
        "ᶻ": "&#x1dbb;"
      }.freeze

      SUB_OPERATORS = {
        "₊": "&#x208a;",
        "₋": "&#x208b;",
        "₌": "&#x208c;",
        "ₔ": "&#x2094;",
      }.freeze

      SUP_OPERATORS = {
        "⁺": "&#x207a;",
        "₋": "&#x207b;",
        "⁼": "&#x207c;",
      }.freeze

      SUB_PARENTHESIS = {
        open: {
          "₍": "&#x208d;",
        },
        close: {
          "₎": "&#x208e;",
        },
      }.freeze

      SUP_PARENTHESIS = {
        open: {
          "⁽": "&#x207d;",
        },
        close: {
          "⁾": "&#x207e;",
        },
      }.freeze

      MATRIXS = {
        pmatrix: "&#x24a8;",
        vmatrix: "&#x24b1;",
        Vmatrix: "&#x24a9;",
        bmatrix: "&#x24e2;",
        Bmatrix: "&#x24c8;",
        eqarray: "&#x2588;",
        matrix: "&#x25a0;",
        cases: "&#x24b8;",
      }.freeze

      COMBINING_SYMBOLS = {
        "!!": "&#x203c;",
        "-+": "&#x2213;",
        "+-": "&#xb1;",
      }.freeze

      UNICODE_FRACTIONS = {
        "&#x2153;": [1, 3],
        "&#x2154;": [2, 3],
        "&#x2155;": [1, 5],
        "&#x2156;": [2, 5],
        "&#x2157;": [3, 5],
        "&#x2158;": [4, 5],
        "&#x2159;": [1, 6],
        "&#x215a;": [5, 6],
        "&#x2150;": [1, 7],
        "&#x215b;": [1, 8],
        "&#x215c;": [3, 8],
        "&#x215d;": [5, 8],
        "&#x215e;": [7, 8],
        "&#x2151;": [1, 9],
        "&#x2189;": [0, 3],
        "&#xbd;": [1, 2],
        "&#xbc;": [1, 4],
        "&#xbe;": [3, 4],
      }.freeze
    end
  end
end
