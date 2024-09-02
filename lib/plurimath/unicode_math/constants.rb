# frozen_string_literal: true

module Plurimath
  class UnicodeMath
    class Constants
      UNARY_FUNCTIONS = %w[
        arccos
        arcsin
        arctan
        csch
        sech
        sinh
        tanh
        cosh
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

      UNDEF_UNARY_FUNCTIONS = %w[
        arg
        def
        erf
        Im
        Pr
        Re
        tg
      ].freeze

      BINARY_FUNCTIONS = %w[
        obrace
        oint
        prod
        sum
        int
        lim
        inf
        log
      ].freeze

      UNARY_SYMBOLS = {
        underline: "&#x2581;",
        hphantom: "&#x2b04;",
        vphantom: "&#x21f3;",
        underbar: "&#x2581;",
        overline: "&#xaf;",
        phantom: "&#x27e1;",
        longdiv: "&#x27cc;",
        circle: "&#x25cb;",
        asmash: "&#x2b06;",
        dsmash: "&#x2b07;",
        hsmash: "&#x2b0c;",
        smash: "&#x2b0d;",
        overbar: "&#xaf;",
      }.freeze

      PHANTOM_SYMBOLS = {
        hphantom: { mpadded: { depth: "0", height: "0" }, phantom: true },
        vphantom: { mpadded: { width: "0" }, phantom: true },
        phantom: { phantom: true },
        hsmash: { mpadded: { width: "0" }, phantom: false },
        asmash: { mpadded: { height: "0" }, phantom: false },
        dsmash: { mpadded: { depth: "0" }, phantom: false },
        smash: { mpadded: { height: "0", depth: "0" }, phantom: false }
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
        intercal: "&#x22ba;",
        leftthreetimes: "&#x22cb;",
        lor: "&#x2228;",
        ltimes: "&#x22c9;",
        oast: "&#x229b;",
        ocirc: "&#x229a;",
        odash: "&#x229d;",
        odot: "&#x2299;",
        oeq: "&#x229c;",
        ominus: "&#x2296;",
        oplus: "&#x2295;",
        otimes: "&#x2297;",
        pitchfork: "&#x22d4;",
        rightthreetimes: "&#x22cc;",
        rtimes: "&#x22ca;",
        setminus: "&#x2216;",
        sqcap: "&#x2293;",
        sqcup: "&#x2294;",
        star: "&#x22c6;",
        times: "&#xd7;",
        triangle: "&#x25b3;",
        uplus: "&#x228e;",
        wedge: "&#x2227;",
        neq: "&#x2260;",
        wr: "&#x2240;",
        ne: "&#x2260;",
        dd: "&#x2146;",
        Dd: "&#x2145;",
      }.freeze

      NARY_CLASSES = {
        prod: "&#x220f;",
        oint: "&#x222e;",
        int: "&#x222b;",
        sum: "&#x2211;",
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
        delta: "&#x3b4;",
        Delta: "&#x394;",
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
        models: "&#x22a8;",
        multimap: "&#x22b8;",
        napprox: "&#x2249;",
        nasymp: "&#x226d;",
        ncong: "&#x2247;",
        nearrow: "&#x2197;",
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

      UNDER_HORIZONTAL_BRACKETS = {
        underbracket: "&#x23b5;",
        undershell: "&#x23e1;",
        underparen: "&#x23dd;",
        underbrace: "&#x23df;",
      }.freeze

      ORDINARY_SYMBOLS = {
        backepsilon: "&#x3f6;",
        diamondsuit: "&#x2664;",
        varepsilon: "&#x3b5;",
        rightangle: "&#x2220;",
        complement: "&#x2201;",
        spadesuit: "&#x2660;",
        emptyset: "&#x2205;",
        vartheta: "&#x3d1;",
        varsigma: "&#x3c2;",
        varkappa: "&#x3f0;",
        hearsuit: "&#x2661;",
        clubsuit: "&#x2663;",
        partial: "&#x2202;",
        nexists: "&#x2204;",
        upsilon: "&#x3c5;",
        Upsilon: "&#x3a5;",
        epsilon: "&#x3f5;",
        Deltaeq: "&#x225c;",
        varrho: "&#x3f1;",
        forall: "&#x2200;",
        exists: "&#x2203;",
        varphi: "&#x3c6;",
        lambda: "&#x3bb;",
        Lambda: "&#x39b;",
        frown: "&#x2322;",
        nabla: "&#x2207;",
        angle: "&#x2220;",
        daleth: "&#x2138;",
        varpi: "&#x3d6;",
        theta: "&#x3b8;",
        Theta: "&#x398;",
        sigma: "&#x3c3;",
        Sigma: "&#x3a3;",
        omega: "&#x3c9;",
        Omega: "&#x3A9;",
        medsp: "&#x205f;",
        ldots: "&#x2026;",
        kappa: "&#x3ba;",
        jmath: "&#x237;",
        infty: "&#x221e;",
        imath: "&#x131;",
        gimel: "&#x2137;",
        gamma: "&#x3b3;",
        Gamma: "&#x393;",
        cdots: "&#x23ef;",
        alpha: "&#x3b1;",
        aleph: "&#x2135;",
        "...": "&#x2026;",
        Vert: "&#x2016;",
        norm: "&#x2016;",
        zwsp: "&#x200b;",
        zwnj: "&#x200c;",
        zeta: "&#x3b6;",
        vbar: "&#x2502;",
        ldsh: "&#x21b2;",
        iota: "&#x3b9;",
        hbar: "&#x210f;",
        gets: "&#x2190;",
        degree: "&#xb0;",
        epar: "&#x22e5;",
        dots: "&#x2026;",
        degf: "&#x2109;",
        degc: "&#x2103;",
        ddag: "&#x2021;",
        beth: "&#x2136;",
        beta: "&#x2b2;",
        inc: "&#x2206;",
        tau: "&#x3c4;",
        rho: "&#x3c1;",
        qed: "&#x220e;",
        psi: "&#x3c8;",
        Psi: "&#x3a8;",
        phi: "&#x3d5;",
        Phi: "&#x3a6;",
        eta: "&#x3b7;",
        ell: "&#x2113;",
        dag: "&#x2020;",
        chi: "&#x3c7;",
        box: "&#x25a1;",
        vert: "&#x7c;",
        eqno: "&#x23;",
        mp: "&#x2213;",
        xi: "&#x3be;",
        wp: "&#x2118;",
        Re: "&#x211c;",
        pi: "&#x3c0;",
        Pi: "&#x3a0;",
        oo: "&#x3c9;",
        nu: "&#x3bd;",
        mu: "&#x3bc;",
        jj: "&#x2149;",
        Im: "&#x2111;",
        ii: "&#x2148;",
        ee: "&#x2147;",
        neg: "&#xac;",
        pm: "&#xb1;",
      }.freeze

      SKIP_SYMBOLS = {
        vthicksp: "&#x2004;",
        thicksp: "&#x2005;",
        thinsp: "&#x2006;",
        hairsp: "&#x200a;",
        numsp: "&#x2007;",
        quad: "&#x2003;",
        ensp: "&#x2002;",
        emsp: "&#x2003;",
        nbsp: "&#xa0;",
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

      NEGATABLE_SYMBOLS = %w[
        "&#x2292;"
        "&#x2291;"
        "&#x2287;"
        "&#x2286;"
        "&#x2283;"
        "&#x2282;"
        "&#x227c;"
        "&#x227b;"
        "&#x227a;"
        "&#x227d;"
        "&#x2277;"
        "&#x2276;"
        "&#x2265;"
        "&#x2264;"
        "&#x2261;"
        "&#x224d;"
        "&#x2248;"
        "&#x2245;"
        "&#x2243;"
        "&#x223c;"
        "&#x220b;"
        "&#x2208;"
        "&#x2203;"
        "&#x3e;"
        "&#x3c;"
        "&#xac;"
        ~
        =
        +
        -
      ].freeze

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
        widehat: "&#x302;",
        ddddot: "&#x20dc;",
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
        rrect: "&#x25a2;",
        rect: "&#x25ad;",
        abs: "&#x249c;",
      }.freeze

      FONTS_CLASSES = %w[
        mbfitsans
        mbffrak
        mitsans
        mbfsans
        mbfscr
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
        '&#x309;',
        '&#x304;',
        '&#x338;',
        '&#x337;',
        '&#x336;',
        '&#x335;',
        '&#x334;',
      ].freeze

      OVERLAYS_NOTATIONS = {
        '&#x20eb;': "mover",
        '&#x20ea;': "mover",
        '&#x20e6;': "mover",
        '&#x20e5;': "mover",
        '&#x20e4;': "mover",
        '&#x20e3;': "mover",
        '&#x20e2;': "mover",
        '&#x20e0;': "circle downdiagonalstrike",
        '&#x20df;': "mover",
        '&#x20de;': "box",
        '&#x20dd;': "circle",
        '&#x20da;': "mover",
        '&#x20d9;': "mover",
        '&#x20d4;': "mover",
        '&#x20d6;': "mover",
        '&#x20d5;': "mover",
        '&#x20d8;': "mover",
        '&#x20d3;': "mover",
        '&#x20d2;': "mover",
        '&#x304;': "top",
        '&#x338;': "mover",
        '&#x337;': "mover",
        '&#x336;': "mover",
        '&#x335;': "mover",
        '&#x334;': "mover",
        '&#x309;': "mover",
      }.freeze

      DIACRITIC_BELOWS = [
        '&#x316;',
        '&#x317;',
        '&#x318;',
        '&#x319;',
        '&#x31c;',
        '&#x31d;',
        '&#x31e;',
        '&#x31f;',
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
        '&#x32a;',
        '&#x32b;',
        '&#x32c;',
        '&#x32d;',
        '&#x32e;',
        '&#x32f;',
        '&#x330;',
        '&#x331;',
        '&#x332;',
        '&#x333;',
        '&#x339;',
        '&#x33a;',
        '&#x33b;',
        '&#x33c;',
        '&#x345;',
        '&#x347;',
        '&#x348;',
        '&#x349;',
        '&#x34d;',
        '&#x34e;',
        '&#x353;',
        '&#x354;',
        '&#x355;',
        '&#x356;',
        '&#x359;',
        '&#x35a;',
        '&#x35c;',
        '&#x35f;',
        '&#x362;',
        '&#x20e8;',
        '&#x20ec;',
        '&#x20ed;',
        '&#x20ee;',
        '&#x20ef;',
      ].freeze

      BELOWS_NOTATIONS = {
        '&#x316;': "munder",
        '&#x317;': "munder",
        '&#x318;': "munder",
        '&#x319;': "munder",
        '&#x31c;': "munder",
        '&#x31d;': "munder",
        '&#x31e;': "munder",
        '&#x31f;': "munder",
        '&#x320;': "munder",
        '&#x321;': "munder",
        '&#x322;': "munder",
        '&#x323;': "munder",
        '&#x324;': "munder",
        '&#x325;': "munder",
        '&#x326;': "munder",
        '&#x327;': "munder",
        '&#x328;': "munder",
        '&#x329;': "munder",
        '&#x32a;': "munder",
        '&#x32b;': "munder",
        '&#x32c;': "munder",
        '&#x32d;': "munder",
        '&#x32e;': "munder",
        '&#x32f;': "munder",
        '&#x330;': "munder",
        '&#x331;': "munder",
        '&#x332;': "bottom",
        '&#x333;': "munder",
        '&#x339;': "munder",
        '&#x33a;': "munder",
        '&#x33b;': "munder",
        '&#x33c;': "munder",
        '&#x345;': "munder",
        '&#x347;': "munder",
        '&#x348;': "munder",
        '&#x349;': "munder",
        '&#x34d;': "munder",
        '&#x34e;': "munder",
        '&#x353;': "munder",
        '&#x354;': "munder",
        '&#x355;': "munder",
        '&#x356;': "munder",
        '&#x359;': "munder",
        '&#x35a;': "munder",
        '&#x35c;': "munder",
        '&#x35f;': "munder",
        '&#x362;': "munder",
        '&#x20e8;': "munder",
        '&#x20ec;': "munder",
        '&#x20ed;': "munder",
        '&#x20ee;': "munder",
        '&#x20ef;': "munder",
      }.freeze

      SUP_DIGITS = {
        "0": "&#x2070;",
        "1": "&#xb9;",
        "2": "&#xb2;",
        "3": "&#xb3;",
        "4": "&#x2074;",
        "5": "&#x2075;",
        "6": "&#x2076;",
        "7": "&#x2077;",
        "8": "&#x2078;",
        "9": "&#x2079;"
      }.freeze

      SUB_DIGITS = {
        "0": "&#x2080;",
        "1": "&#x2081;",
        "2": "&#x2082;",
        "3": "&#x2083;",
        "4": "&#x2084;",
        "5": "&#x2085;",
        "6": "&#x2086;",
        "7": "&#x2087;",
        "8": "&#x2088;",
        "9": "&#x2089;",
      }.freeze

      SUB_ALPHABETS = {
        "a": "&#x2090;",
        "e": "&#x2091;",
        "h": "&#x2095;",
        "i": "&#x1d62;",
        "j": "&#x2c7c;",
        "k": "&#x2096;",
        "l": "&#x2097;",
        "m": "&#x2098;",
        "n": "&#x2099;",
        "o": "&#x2092;",
        "p": "&#x209a;",
        "r": "&#x1d63;",
        "s": "&#x209b;",
        "t": "&#x209c;",
        "u": "&#x1d64;",
        "v": "&#x1d65;",
        "x": "&#x2093;"
      }.freeze

      SUP_ALPHABETS = {
        "a": "&#x1d43;",
        "b": "&#x1d47;",
        "c": "&#x1d9c;",
        "d": "&#x1d48;",
        "e": "&#x1d49;",
        "f": "&#x1da0;",
        "g": "&#x1d4d;",
        "h": "&#x2b0;",
        "i": "&#x2071;",
        "j": "&#x2b2;",
        "k": "&#x1d4f;",
        "l": "&#x2e1;",
        "m": "&#x1d50;",
        "n": "&#x207f;",
        "o": "&#x1d52;",
        "p": "&#x1d56;",
        "r": "&#x2b3;",
        "s": "&#x2e2;",
        "t": "&#x1d57;",
        "u": "&#x1d58;",
        "v": "&#x1d5b;",
        "w": "&#x2b7;",
        "x": "&#x2e3;",
        "y": "&#x2b8;",
        "z": "&#x1dbb;"
      }.freeze

      SUB_OPERATORS = {
        "+": "&#x208a;",
        "-": "&#x208b;",
        "=": "&#x208c;",
        "ₔ": "&#x2094;",
      }.freeze

      SUP_OPERATORS = {
        "+": "&#x207a;",
        "-": "&#x207b;",
        "=": "&#x207c;",
      }.freeze

      SUB_PARENTHESIS = {
        open: {
          "(": "&#x208d;",
        },
        close: {
          ")": "&#x208e;",
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

      UNICODED_FONTS = {
        script: {
          "H": "&#x210b;"
        },
        fraktur: {
          "H": "&#x210c;",
        },
        double: {
          "H": "&#x210d;"
        },
        mitBbb: {
          D: "&#x2145;",
          d: "&#x2146;",
          e: "&#x2147;",
          i: "&#x2148;",
          j: "&#x2149;",
        },
      }.freeze

      PREFIXED_PRIMES = {
        pppprime: "&#x2057;",
        ppprime: "&#x2034;",
        pprime: "&#x2033;",
        prime: "&#x2032;",
      }.freeze

      PARENTHESIS_MATRICES = {
        pmatrix: "(",
        vmatrix: "|",
        Vmatrix: "\\Vert",
        bmatrix: "[",
        Bmatrix: "{",
        eqarray: nil,
        matrix: nil,
        cases: nil,
      }.freeze

      class << self
        def wrapper_symbols
          @@wrapper_symbols ||= Utility.symbols_hash(:unicodemath).keys.grep(/"P\{[^\}]+\}/)
        end
      end
    end
  end
end
