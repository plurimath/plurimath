# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Parser
      attr_accessor :text

      WHITESPACE = /\s+/.freeze
      NUMBER = /[0-9]+(?:\.[0-9]+)?/.freeze
      QUOTED_TEXT = /"[^"]*"/.freeze
      TEX_TEXT = /text\([^)]*\)/.freeze
      PARENTHESES = { "(" => ")", "{" => "}", "[" => "]" }.freeze

      def initialize(text)
        @text = text
        @symbols = symbols_and_classes.keys
        lookahead = @symbols.map(&:length).max
        @symbol_regexp = /((?:\\[\s0-9]|[^\s0-9]){1,#{lookahead}})/
      end

      def parse
        @nodes = []
        klass = Plurimath::Math::Formula.new
        until @text.eos?
          @text.scan(WHITESPACE)
          @nodes << token
        end
        while node = new_node
          klass.value << intermediate_parse(node, @nodes.index(node))
        end
        klass
      end

      def intermediate_parse(node, ind)
        return if node.nil?

        @nodes.delete_at(ind)
        formula_klass = Plurimath::Math::Formula.new
        if function?(node)
          function_parse(node, formula_klass)
        else
          node.values.last.new(node.first.first)
        end
      end

      def function_parse(node, formula_klass)
        underscore_parse(formula_klass)
        parenthesis_parse(formula_klass)
        if ["sum", "prod"].include?(node.first.first)
          exponent = sum_prod_exponent
          node.values.last.new(formula_klass, exponent)
        else
          node.values.last.new(formula_klass)
        end
      end

      def sum_prod_exponent
        if new_node.key?("^")
          @nodes.delete_at(0)
          return if closing_paren?(node_keys(new_node), PARENTHESES.values)

          intermediate_parse(new_node, 0)
        end
      end

      def underscore_parse(formula_klass)
        if new_node.key?("_")
          @nodes.delete_at(0)
          if opening_paren?(node_keys(new_node), PARENTHESES.keys)
            parenthesis_parse(formula_klass)
          else
            child_node = intermediate_parse(new_node, 0)
            formula_klass.value << child_node
          end
        end
      end

      def parenthesis_parse(formula_klass)
        if opening_paren?(node_keys(new_node), PARENTHESES.keys)
          until_closing_paren(formula_klass)
        end
      end

      def new_node
        @nodes.first
      end

      def node_keys(node)
        node.first.first
      end

      def until_closing_paren(klass, next_node = new_node)
        until new_node.nil?
          klass.value << intermediate_parse(next_node, 0)
          break if closing_paren?(node_keys(next_node), PARENTHESES.values)

          if opening_paren?(node_keys(new_node), PARENTHESES.keys)
            until_closing_paren(klass)
          end
          next_node = new_node
        end
      end

      def closing_paren?(node, parens)
        parens.include? node
      end

      def opening_paren?(node, parens)
        parens.include?(node)
      end

      def function?(node)
        node.first.last.to_s.include?("Function") unless node.nil?
      end

      def symbol?(node)
        node.first.last.to_s.include?("Symbol") unless node.nil?
      end

      def token
        case @text.peek(1)
        when '"'
          read_quoted_text
        when "t"
          read_text
        when "-", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
          read_number || read_symbols
        else
          read_symbols
        end
      end

      def read_text
        case @text.peek(5)
        when "text("
          read_tex_text
        else
          read_symbols
        end
      end

      def class_or_symbol
        symbols_and_classes[symbol_or_string(@text.rest.delete("(")).to_sym]
      end

      def read_tex_text
        read_value(TEX_TEXT) do |text|
          { text[5..-2] => Plurimath::Math::Symbol }
        end
      end

      def read_quoted_text
        read_value(QUOTED_TEXT) do |text|
          { text[1..-2] => Plurimath::Math::Symbol }
        end
      end

      def read_symbols
        position = @text.pos
        read_value(@symbol_regexp) do |str|
          symbol_or_string(str)
          @text.pos = position + str.length
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
        read_value(NUMBER) do |number|
          { number => Plurimath::Math::Number }
        end
      end

      def read_value(regex)
        str = @text.scan(regex)
        if str && block_given?
          yield str
        else
          str
        end
      end

      def initial_object(klass)
        Object.const_get("Plurimath::Math::Function::#{klass.capitalize}")
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
          sin: :class,
          tan: :class,
          cos: :class,
          arccos: :class,
          arcsin: :class,
          arctan: :class,
          cosh: :class,
          cot: :class,
          coth: :class,
          csc: :class,
          csch: :class,
          det: :class,
          dim: :class,
          exp: :class,
          f: :class,
          g: :class,
          gcd: :class,
          glb: :class,
          lcm: :class,
          ln: :class,
          log: :class,
          lub: :class,
          max: :class,
          min: :class,
          mod: :class,
          sec: :class,
          sech: :class,
          sinh: :class,
          tanh: :class,
          frac: :class,
          root: :class,
          sqrt: :class,
          text: :class,
          abs: :class,
          bar: :class,
          cancel: :class,
          ceil: :class,
          color: :class,
          ddot: :class,
          dot: :class,
          floor: :class,
          hat: :class,
          norm: :class,
          obrace: :class,
          overset: :class,
          tilde: :class,
          ubrace: :class,
          ul: :class,
          underset: :class,
          vec: :class,
          mathbb: :class,
          mathbf: :class,
          mathcal: :class,
          mathfrak: :class,
          mathsf: :class,
          mathtt: :class,
          sum: :class,
          prod: :class,
        }
      end
    end
  end
end
