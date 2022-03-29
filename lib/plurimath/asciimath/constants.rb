# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Constants
      SYMBOLS = %i[
        ~~ approx prop propto /
        uparrow darr downarrow rarr
        + - * cdot ** ast ***
        xx times -: div |>< ltimes
        o+ oplus ox otimes o. odot
        forall EE exists _|_ bot TT
        star // \\\\ backslash setminus
        ^^ wedge ^^^ bigwedge vv vee
        vvv bigvee nn cap nnn bigcap
        leftrightarrow rArr Rightarrow lArr
        top |-- vdash |== models uarr
        ><| rtimes |><| bowtie @ circ
        uu cup uuu bigcup and or not
        neg => implies if <=> iff AA
        rightarrow -> to >-> rightarrowtail
        del partial grad nabla +- pm O/
        ->> twoheadrightarrow twoheadrightarrowtail
        |-> >->> mapsto larr leftarrow harr
        Leftarrow hArr Leftrightarrow alpha beta
        Xi Lambda Theta Delta Gamma int oint
        gamma delta epsilon varepsilon zeta eta
        theta vartheta iota kappa lambda mu nu
        because |...| |ldots| |cdots| vdots ddots
        lceiling ~| rceiling CC NN QQ RR ZZ
        << >> "{:x)" "(x:}" = != ne < lt
        chi psi omega Omega Psi Phi Sigma Pi
        emptyset oo infty aleph :. therefore ":'"
        diamond square |__ lfloor __| rfloor |~
        > gt <= le >= ge mlt ll mgt gg
        subseteq supe supseteq -= equiv ~= cong
        -< prec -<= preceq >- succ >-= succeq
        xi pi rho sigma tau upsilon phi varphi
        "|\\ |" |quad| /_ angle frown /_\\ triangle
        in !in notin sub subset sup supset sube
      ].freeze
      UNARY_CLASSES = %i[
        sin tan cos arccos arcsin arctan
        exp f g gcd glb lcm ln lub
        cosh cot coth csc csch det dim
        max min sec sech sinh tanh sqrt
        text abs bar cancel ceil ddot dot
        floor hat norm obrace tilde ubrace mathsf
        ul vec mathbb mathbf mathcal mathfrak mathtt
      ].freeze
      BINARY_CLASSES = %i[
        overset mod root underset color
        frac stackrel sum prod log
      ].freeze
      RPAREN = %i[) } ) \] :}].freeze
      LPAREN = %i[( { (: \[ {:].freeze
      CLASSES = UNARY_CLASSES + BINARY_CLASSES
    end
  end
end
