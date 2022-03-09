# frozen_string_literal: true

Dir[File.join("#{Dir.pwd}/lib/plurimath/mathml/function/*.rb")].each do |file|
  require_relative file.gsub(".rb", "")
end
require "byebug"
module Plurimath
  class Mathml
    class Parser
      attr_accessor :text

      WHITESPACE = /\s+/.freeze
      NUMBER = /[0-9]+(?:\.[0-9]+)?/.freeze
      QUOTED_TEXT = /"[^"]*"/.freeze
      TEX_TEXT = /text\([^)]*\)/.freeze
      PARENTHESES = { "(" => ")", "{" => "}", "[" => "]" }.freeze
      COMPLETE_TAG = /<[^>]*>/.freeze

      def initialize(text)
        @text = text
        @symbols = symbols_and_classes.keys
        lookahead = @symbols.map(&:length).max
        @symbol_regexp = /((?:\\[\s0-9]|[^\s0-9]){1,#{lookahead}})/
      end

      def parse
        create_nodes
        klass = formula_class
        while node = new_node
          klass.value << intermediate_parse(node)
        end
        klass
      end

      def intermediate_parse(node)
        delete_node_at
        if function? node
          p node
        else
          p node
        end
      end

      def node_value(node = new_node)
        node&.first&.last
      end

      def function?(node)
        node_value(node).to_s.include?("Function") unless node.nil?
      end

      def node_key(node = new_node)
        node&.first&.first
      end

      def new_node(nodes = @nodes)
        nodes.first
      end

      def delete_node_at(ind = 0)
        @nodes.delete_at(ind)
      end

      def create_nodes
        @nodes = []
        until text.eos?
          text.scan(WHITESPACE)
          @nodes << token
        end
      end

      def token
        case text.peek(1)
        when "<"
          read_tag
        when "-", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
          read_number
        else
          read_symbol
        end
      end

      def read_symbol
        position = text.pos
        read_value(@symbol_regexp) do |str|
          symbol_or_string(str)
          text.pos = position + str.length
          type = symbols_and_classes[str.to_sym]
          value = type == :class ? initial_object(str) : Plurimath::Math::Symbol
          { str => value }
        end
      end

      def symbol_or_string(str)
        until str.length == 1 || @symbols.include?(str.to_sym)
          str.chop!
        end
        str
      end

      def read_number
        read_value(NUMBER) do |str|
          { str => Plurimath::Math::Number }
        end
      end

      def read_tag
        read_value(COMPLETE_TAG) do |str|
          str.gsub!("<", "")
          until symbols_and_classes[str.to_sym]
            str.chop!
            break unless str
          end
          { str => initial_object(str) } unless str.nil?
        end
      end

      def read_value(regex)
        str = text.scan(regex)
        if str && block_given?
          yield str
        else
          str
        end
      end

      def initial_object(klass)
        if klass.include? "-"
          klass = klass.split('-').map(&:capitalize).join
          Object.const_get("Plurimath::Mathml::Function::#{klass}")
        elsif klass.include? "/"
          "/"
        else
          Object.const_get("Plurimath::Mathml::Function::#{klass.capitalize}")
        end
      end

      def formula_class
        Plurimath::Math::Formula.new
      end

      def symbols_and_classes
        {
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
          math: :class,
          maction: :class,
          maligngroup: :class,
          malignmark: :class,
          menclose: :class,
          merror: :class,
          mfenced: :class,
          mfrac: :class,
          mi: :class,
          mlongdiv: :class,
          mmultiscripts: :class,
          mn: :class,
          mo: :class,
          mover: :class,
          mpadded: :class,
          mphantom: :class,
          mroot: :class,
          mrow: :class,
          ms: :class,
          mscarries: :class,
          mscarry: :class,
          msgroup: :class,
          msline: :class,
          mspace: :class,
          msqrt: :class,
          msrow: :class,
          mstack: :class,
          mstyle: :class,
          msub: :class,
          msup: :class,
          msubsup: :class,
          mtable: :class,
          mtd: :class,
          mtext: :class,
          mtr: :class,
          munder: :class,
          munderover: :class,
          semantices: :class,
          annotation: :class,
          "annotation-xml": :class,
        }
      end
    end
  end
end
