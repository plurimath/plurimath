# frozen_string_literal: true

module Plurimath
  class Latex
    # Maps the typed LaTeX model that the latexmath gem returns
    # (Latexmath::Model::Document) to a Plurimath::Math::Formula.
    #
    # latexmath owns the grammar and the model. Its model classes are the
    # grammar's captures, typed: each class has one attribute per capture key,
    # and the few captures its shape normalization adds (see latexmath's
    # docs/model-contract.adoc) are listed in WRAPPERS. The mapper first reads
    # a model node as the capture tree it stands for (#captures), then builds
    # the Formula with the LaTeX rule table (Mapper::Rules).
    #
    # Leaf nodes (see LEAVES) are built from the model directly: their Math
    # object takes the place of their capture hash, and the rule table only
    # unwraps it.
    class Mapper
      extend Parsanol::Atoms::CanFlatten

      autoload :Rules, "#{__dir__}/mapper/rules"

      # The captures latexmath's shape normalization adds, and the value each
      # one stands for (latexmath 1.0, grammars/latex.wrappers.json):
      #   :text      the wrapped text ("" when empty);
      #   :text_list the text, or [] when it is empty;
      #   :items     the list;
      #   :absent    nothing (nil).
      WRAPPERS = {
        literal: :text,
        spelling: :text_list,
        text_list: :text_list,
        items: :items,
        absent: :absent,
      }.freeze

      # The matrix row break: latexmath names the capture +row_break+, the
      # rule table keys it as the String "\\\\".
      RENAMES = { row_break: "\\\\" }.freeze

      # A node whose only set attribute is one of these text captures is a
      # leaf: it maps straight to the Math object built from that text.
      LEAVES = {
        number: ->(t) { Math::Number.new(Utility.html_entity_to_unicode(t.to_s)) },
        unary: ->(t) { Utility.get_class(t).new },
        ternary: ->(t) { Utility.get_class(t).new },
        space: ->(_) { Math::Function::Text.new(" ") },
        operant: ->(t) { Utility.symbols_class(t, lang: :latex) },
        numeric_values: ->(t) { Utility.symbols_class(t, lang: :latex) },
        lparen: ->(t) { Utility.symbols_class(t, lang: :latex) },
        rparen: ->(t) { Utility.symbols_class(t, lang: :latex) },
        text: ->(t) { Math::Function::Text.new(t) },
        three_per_em_space: ->(_) { Math::Symbols::ThreePerEmSpace.new },
        row_break: ->(_) { Math::Function::Linebreak.new },
        symbols: ->(t) { Utility.symbols_class(t, lang: :latex) },
        unicode_symbols: ->(t) { Utility.symbols_class(t, lang: :latex) },
        symbol: ->(t) { Utility.symbols_class(t, lang: :latex) },
        binary: ->(t) { Utility.get_class(t).new },
      }.freeze

      # A node whose only set attribute is one of these, holding a node the
      # mapper built, stands for that built node.
      PASS_THROUGH = %i[
        binary unary_functions ternary_class power_base under_over limits
        left_right expression environment table_data intermediate_exp
      ].freeze

      # A node whose only set attribute is one of these, holding a sequence
      # of nodes the mapper built, stands for a Formula of them.
      SEQUENCES = %i[expression].freeze

      # The capture a typed rule needs from a child: :simple is one value
      # (not a Hash or Array), :sequence a list of such values, :subtree
      # anything. These are the rule table's simple, sequence and subtree.
      SHAPES = {
        simple: ->(v) { !v.is_a?(Hash) && !v.is_a?(Array) },
        sequence: ->(v) { v.is_a?(Array) && v.none? { |e| e.is_a?(Hash) || e.is_a?(Array) } },
        subtree: ->(_) { true },
      }.freeze

      # Builders shared by the typed rules below.
      module Build
        module_function

        def number(text)
          Math::Number.new(Utility.html_entity_to_unicode(text.to_s))
        end

        def symbol(text)
          Utility.symbols_class(text, lang: :latex)
        end

        def unary(value)
          value.is_a?(Parsanol::Slice) ? Utility.get_class(value).new : value
        end

        def font(fonts, value)
          (Utility::FONT_STYLES[fonts.to_sym] || Math::Function::FontStyle).new(value, fonts.to_s)
        end

        def fenced(left, body, right)
          Math::Formula.new([Utility.left_right_objects(left, "left"), body, right])
        end

        def right(paren)
          Utility.left_right_objects(paren, "right")
        end

        def nary(sequence, expr, rest)
          if sequence.is_a?(Math::Function::PowerBase) && sequence.parameter_one.is_nary_symbol?
            Math::Function::Nary.new(sequence.parameter_one, sequence.parameter_two,
                                     sequence.parameter_three, expr)
          else
            rest
          end
        end

        def table(env, rows, options = nil, **organize)
          open_paren = Constants::MATRICES[env.to_sym]
          table = Utility.organize_table(rows, **organize)
          close_paren = Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s
          args = [
            table,
            Utility.symbols_class(open_paren, lang: :latex, table: true),
            Utility.symbols_class(close_paren, lang: :latex, table: true),
          ]
          args << (options == :table ? Utility.table_options(table) : options) unless options.nil?
          Utility.get_table_class(env).new(*args)
        end
      end

      # Nodes built from their children's Math objects, keyed by the node's
      # set attributes. Each entry gives the shape each child must have and
      # the builder; the first entry whose shapes match is used. The order
      # is the precedence the LaTeX rule table had.
      s = :simple
      q = :sequence
      t = :subtree
      TYPED = [
        [{ substack: s, expression: q }, ->(_, v) { Math::Function::Substack.new(Utility.organize_table(v)) }],
        [{ environment: s, expression: q }, ->(e, x) { Build.table(e, x.compact, {}) }],
        [{ environment: s, expression: s }, ->(e, x) { Build.table(e, x.nil? ? [] : [x], {}) }],
        [{ environment: s, asterisk: s, table_data: q, ending: s }, ->(e, _, d, _) { Build.table(e, d, { asterisk: true }) }],
        [{ environment: s, asterisk: s, options: s, table_data: q, ending: s },
         lambda do |e, _, o, d, _|
           Build.table(e, d, { asterisk: true }, column_align: o ? [o] : [], options: true)
         end],
        [{ environment: s, args: s, table_data: q, ending: s },
         ->(e, a, d, _) { Build.table(e, d, :table, column_align: a ? [a] : []) }],
        [{ environment: s, args: q, table_data: q, ending: s },
         ->(e, a, d, _) { Build.table(e, d, :table, column_align: a) }],
        [{ environment: s, table_data: s, ending: s }, ->(e, d, _) { Build.table(e, [d]) }],
        [{ environment: s, args: s, table_data: s, ending: s },
         ->(e, a, d, _) { Build.table(e, [d], :table, column_align: a ? [a] : []) }],
        [{ environment: s, table_data: q, ending: s }, ->(e, d, _) { Build.table(e, d, {}) }],
        [{ underover: s, first_value: s, subscript: s, supscript: s },
         ->(f, v, b, p) { Math::Function::PowerBase.new(Utility.get_class(f).new(v), b, p) }],
        [{ binary: s, first_value: s, second_value: q },
         lambda do |b, f, v|
           Utility.get_class(b.to_s.include?("mod") ? "mod" : b).new(f, Utility.filter_values(v))
         end],
        [{ binary: s, first_value: s, second_value: s },
         lambda do |b, f, v|
           if b == "binom"
             Math::Function::Table.new(
               [Math::Function::Tr.new(Utility.table_td(f)), Math::Function::Tr.new(Utility.table_td(v))],
               Math::Symbols::Paren::Lcurly.new, Math::Symbols::Paren::Rcurly.new
             )
           else
             Utility.get_class(b.to_s.include?("mod") ? "mod" : b).new(f, v)
           end
         end],
        [{ unicode_symbols: s, subscript: s, supscript: s }, ->(v, b, p) { Math::Function::PowerBase.new(Build.symbol(v), b, p) }],
        [{ symbols: s, subscript: s, supscript: s }, ->(v, b, p) { Math::Function::PowerBase.new(Build.symbol(v), b, p) }],
        [{ binary: s, subscript: s },
         ->(v, b) { v.is_a?(Parsanol::Slice) ? Utility.get_class(v).new(b) : Math::Function::Base.new(v, b) }],
        # The later of the two binary/subscript/supscript rules took precedence.
        [{ binary: s, subscript: s, supscript: s },
         lambda do |v, b, p|
           v.is_a?(Parsanol::Slice) ? Utility.get_class(v).new(b, p) : Math::Function::PowerBase.new(v, b, b)
         end],
        [{ expression: q, supscript: s }, ->(x, p) { Math::Function::Power.new(Utility.filter_values(x), p) }],
        [{ expression: s, supscript: s }, ->(x, p) { Math::Function::Power.new(x, p) }],
        [{ expression: s, subscript: s }, ->(x, b) { Math::Function::Base.new(x, b) }],
        [{ rule: s, first_value: s, second_value: s, third_value: s }, ->(_, a, b, c) { Math::Function::Rule.new(a, b, c) }],
        [{ left_paren: s, expression: q, right_paren: s },
         ->(l, x, r) { Math::Function::Fenced.new(Build.symbol(l), x, Build.symbol(r)) }],
        [{ left_paren: s, expression: s, right_paren: s },
         ->(l, x, r) { Math::Function::Fenced.new(Build.symbol(l), [x], Build.symbol(r)) }],
        [{ lparen: s, expression: q, rparen: s }, ->(_, x, _) { Math::Formula.new(x) }],
        [{ first_value: s, base: s, power: s }, ->(f, b, p) { Math::Function::Limits.new(f, b, p) }],
        [{ root: s, first_value: q, second_value: s },
         ->(_, f, v) { Math::Function::Root.new(Utility.filter_values(f) || Math::Formula.new, v) }],
        [{ root: s, first_value: s, second_value: s },
         ->(_, f, v) { Math::Function::Root.new(f, v.nil? ? Math::Formula.new : v) }],
        [{ fonts: s, intermediate_exp: s, subscript: s, supscript: s },
         ->(f, x, b, p) { Math::Function::PowerBase.new(Build.font(f, x), b, p) }],
        [{ fonts: s, intermediate_exp: s, subscript: s }, ->(f, x, b) { Math::Function::Base.new(Build.font(f, x), b) }],
        [{ fonts: s, intermediate_exp: s, supscript: s }, ->(f, x, p) { Math::Function::Power.new(Build.font(f, x), p) }],
        [{ sqrt: s, intermediate_exp: s }, ->(_, x) { Math::Function::Sqrt.new(x) }],
        [{ unary: s, first_value: s }, ->(u, f) { Utility.get_class(u == "overline" ? "bar" : u).new(f) }],
        [{ text: s, first_value: s, subscript: s, supscript: s },
         ->(x, f, b, p) { Math::Function::PowerBase.new(Utility.get_class(x).new(f), b, p) }],
        [{ text: s, first_value: s, subscript: s }, ->(x, f, b) { Math::Function::Base.new(Utility.get_class(x).new(f), b) }],
        [{ text: s, first_value: q, subscript: s }, ->(x, f, b) { Math::Function::Base.new(Utility.get_class(x).new(f.join), b) }],
        [{ text: s, first_value: q, supscript: s }, ->(x, f, p) { Math::Function::Power.new(Utility.get_class(x).new(f.join), p) }],
        [{ text: s, first_value: s, supscript: s }, ->(x, f, p) { Math::Function::Power.new(Utility.get_class(x).new(f), p) }],
        [{ text: s, first_value: q }, ->(x, f) { Utility.get_class(x).new(f.join) }],
        [{ text: s, first_value: s }, ->(x, f) { Utility.get_class(x).new(f) }],
        [{ numeric_values: s, supscript: s }, ->(v, p) { Math::Function::Power.new(Build.symbol(v), p) }],
        [{ unicode_symbols: s, supscript: s }, ->(v, p) { Math::Function::Power.new(Build.symbol(v), p) }],
        [{ unicode_symbols: s, subscript: s }, ->(v, b) { Math::Function::Base.new(Build.symbol(v), b) }],
        [{ intermediate_exp: s, subscript: s }, ->(x, b) { Math::Function::Base.new(x, b) }],
        [{ intermediate_exp: s, supscript: s }, ->(x, p) { Math::Function::Power.new(x, p) }],
        [{ symbols: s, supscript: s }, ->(v, p) { Math::Function::Power.new(Build.symbol(v), p) }],
        [{ numeric_values: s, subscript: s }, ->(v, b) { Math::Function::Base.new(Build.symbol(v), b) }],
        [{ symbols: s, subscript: s }, ->(v, b) { Math::Function::Base.new(Build.symbol(v), b) }],
        [{ number: s, subscript: s, supscript: s }, ->(n, b, p) { Math::Function::PowerBase.new(Build.number(n), b, p) }],
        [{ number: s, supscript: s }, ->(n, p) { Math::Function::Power.new(Build.number(n), p) }],
        [{ number: s, subscript: s }, ->(n, b) { Math::Function::Base.new(Build.number(n), b) }],
        [{ fonts: s, intermediate_exp: s }, ->(f, x) { Build.font(f, x) }],
        [{ ternary_functions: s, subscript: s, supscript: s, third_value: s },
         ->(x, b, p, v) { Utility.get_class(x).new(b, p, v) }],
        [{ unary_functions: s, subscript: s, supscript: s },
         ->(u, b, p) { Math::Function::PowerBase.new(Build.unary(u), b, p) }],
        [{ ternary_functions: s, subscript: s, supscript: s }, ->(x, b, p) { Utility.get_class(x).new(b, p) }],
        [{ ternary_functions: s, subscript: s, third_value: s }, ->(x, b, v) { Utility.get_class(x).new(b, nil, v) }],
        [{ unary_functions: s, supscript: s }, ->(u, p) { Math::Function::Power.new(Build.unary(u), p) }],
        [{ ternary_functions: s, subscript: s }, ->(x, b) { Utility.get_class(x).new(b) }],
        [{ binary_functions: s, supscript: s }, ->(x, p) { Math::Function::Power.new(x, p) }],
        [{ unary_functions: s, subscript: s }, ->(u, b) { Math::Function::Base.new(Build.unary(u), b) }],
        [{ sequence: s, expression: q }, ->(z, x) { Build.nary(z, Utility.filter_values(x), [z] + x) }],
        [{ sequence: s, expression: s }, ->(z, x) { Build.nary(z, x, [z, x].compact) }],
        [{ operant: s, supscript: s }, ->(o, p) { Math::Function::Power.new(Build.symbol(o), p) }],
        [{ operant: s, subscript: s }, ->(o, b) { Math::Function::Base.new(Build.symbol(o), b) }],
        [{ over: s, supscript: s }, ->(o, p) { Math::Function::Power.new(o, p) }],
        [{ over: s, subscript: s }, ->(o, b) { Math::Function::Base.new(o, b) }],
        [{ dividend: t, divisor: t },
         ->(a, b) { Math::Function::Over.new(Math::Formula.new(Array(a).flatten), Math::Formula.new(Array(b).flatten)) }],
        [{ left: s, left_paren: s, dividend: t, divisor: t, right: s, right_paren: s },
         lambda do |_, l, a, b, _, r|
           over = Math::Function::Over.new(Math::Formula.new(Array(a).flatten), Math::Formula.new(Array(b).flatten))
           Build.fenced(l, over, Build.right(r))
         end],
        [{ power: s, expression: q }, ->(w, x) { Math::Function::Power.new(w, Utility.filter_values(x)) }],
        [{ base: s, expression: q }, ->(w, x) { Math::Function::Base.new(w, Utility.filter_values(x)) }],
        [{ base: s, expression: s }, ->(w, x) { Math::Function::Base.new(w, x) }],
        [{ power: s, expression: s }, ->(w, x) { Math::Function::Power.new(w, x) }],
        [{ power: s, symbols: s }, ->(w, v) { Math::Function::Power.new(w, Build.symbol(v)) }],
        [{ power: s, number: s }, ->(w, n) { Math::Function::Power.new(w, Build.number(n)) }],
        [{ left: s, expression: q, right: s },
         ->(_, x, _) { Math::Formula.new([Math::Function::Left.new, Math::Formula.new(x), Math::Function::Right.new]) }],
        [{ left: s, expression: s, right: s },
         ->(_, x, _) { Math::Formula.new([Math::Function::Left.new, x, Math::Function::Right.new]) }],
        [{ left: s, left_paren: s, expression: s, right: s, right_paren: s },
         ->(_, l, x, _, r) { Build.fenced(l, x, Build.right(r)) }],
        [{ left: s, left_paren: s }, ->(_, l) { Utility.left_right_objects(l, "left") }],
        [{ left: s, left_paren: s, right: s, right_paren: s },
         ->(_, l, _, r) { Math::Formula.new([Utility.left_right_objects(l, "left"), Build.right(r)]) }],
        [{ left: s, left_paren: s, right: s },
         ->(_, l, _) { Math::Formula.new([Utility.left_right_objects(l, "left"), Math::Function::Right.new]) }],
        [{ left: s, left_paren: s, expression: s, right: s },
         ->(_, l, x, _) { Build.fenced(l, x, Math::Function::Right.new) }],
        [{ left: s, left_paren: s, expression: q, right: s },
         ->(_, l, x, _) { Build.fenced(l, Math::Formula.new(x), Math::Function::Right.new) }],
        [{ left: s, left_paren: s, expression: q, right: s, right_paren: s },
         ->(_, l, x, _, r) { Build.fenced(l, Math::Formula.new(x), Build.right(r)) }],
        [{ left_right: s, supscript: s }, ->(x, p) { Math::Function::Power.new(x, p) }],
        [{ left_right: s, subscript: s }, ->(x, b) { Math::Function::Base.new(x, b) }],
      ].freeze
      TYPED_BY_KEYS = TYPED.group_by { |shapes, _| shapes.keys.sort }.freeze

      # Utility caches each language's paren table on first use. LaTeX
      # parsing has always built it first, without Lcurly, so "\\{" stays a
      # plain symbol rather than an Lcurly paren.
      PAREN_SKIPABLES = ["lcurly"].freeze

      def call(document)
        expression = document.expression
        raise ParseError.new("LaTeX input has no formula") if expression.nil?

        Utility.parens_hash(:latex, skipables: PAREN_SKIPABLES)

        tree = slices(captures(expression))
        formula = Rules.new.apply(tree)
        formula = [formula] unless formula.is_a?(Array)

        Math::Formula.new(formula)
      end

      # Raised for input that holds no formula (empty, or only spaces and
      # newlines), which the grammar refuses.
      class ParseError < StandardError; end

      private

      # A model node as its capture tree: Hashes keyed by capture name,
      # Arrays for repetitions, and the captured text.
      def captures(node)
        case node
        when Array then self.class.send(:flatten_repetition, node.map { |v| captures(v) }, true)
        when Lutaml::Model::Serializable then node_captures(node)
        else node
        end
      end

      # The node's set attributes, in declared order. Ordinary captures form
      # hash parts; each wrapper is the value it stands for. The parts fold
      # as the grammar's sequence folded them.
      def node_captures(node)
        leaf = leaf(node)
        return leaf.captures if leaf.is_a?(Untyped)
        return { built: leaf } if leaf

        parts = []
        run = nil
        only_absent = true
        node.class.attributes.each_key do |name|
          value = node.public_send(name)
          next if value.nil?

          kind = WRAPPERS[name]
          if kind
            parts << run if run
            run = nil
            only_absent &&= kind == :absent
            parts << wrapped(kind, captures(value))
          else
            only_absent = false
            (run ||= {})[RENAMES.fetch(name, name)] = captures(value)
          end
        end
        parts << run if run
        return nil if only_absent

        self.class.send(:foldl, parts) { |l, r| self.class.send(:merge_fold, l, r) }
      end

      # The Math object for a leaf, pass-through or composite node, or nil
      # when the node is none of these.
      def leaf(node)
        set = node.class.attributes.each_key.reject { |n| node.public_send(n).nil? }
        return if set.any? { |n| WRAPPERS.key?(n) }

        typed = typed(node, set)
        return typed if typed
        return unless set.size == 1

        name = set.first
        value = node.public_send(name)
        value = captures(value) if value.is_a?(Lutaml::Model::Serializable)
        if value.is_a?(String)
          build = LEAVES[name]
          build&.call(slice(value))
        elsif PASS_THROUGH.include?(name) && value.is_a?(Hash) && value.keys == [:built]
          value[:built]
        elsif SEQUENCES.include?(name) && sequence?(value)
          Math::Formula.new(value.map { |v| v[:built] })
        end
      end

      # A node with TYPED keys whose children fit no entry, or whose entry
      # gives a list. Its captures are its children as already built, which
      # the rule table reads as it read their capture trees, so no child is
      # built twice.
      Untyped = Struct.new(:captures)

      # The node built by the first TYPED entry its children fit, or Untyped.
      # A result that is a list stays with the rule table, which splices it
      # into the parent.
      def typed(node, set)
        entries = TYPED_BY_KEYS[set.sort] or return
        values = set.to_h { |n| [n, built(node.public_send(n))] }
        entries.each do |shapes, build|
          next unless shapes.all? { |n, shape| SHAPES[shape].call(values[n]) }

          result = build.call(*shapes.keys.map { |n| values[n] })
          return result unless result.is_a?(Array) || result.is_a?(Hash)

          break
        end
        Untyped.new(values.transform_keys { |n| RENAMES.fetch(n, n) })
      end

      def sequence?(value)
        value.is_a?(Array) && !value.empty? &&
          value.all? { |v| v.is_a?(Hash) && v.keys == [:built] }
      end

      # A child node as the rule table would build it.
      def built(node)
        Rules.new.apply(slices(captures(node)))
      end

      def slice(text)
        Parsanol::Slice.new(0, text.dup.force_encoding(Encoding::UTF_8))
      end

      def wrapped(kind, value)
        case kind
        when :text then value.nil? || value == [] ? +"" : value
        when :text_list then [[], ""].include?(value) ? [] : value
        when :items then value
        when :absent then nil
        end
      end

      # The grammar's captured text is Parsanol::Slice text, which the rule
      # table tells apart from values it has already built. Its encoding is
      # UTF-8, as the native engine gives it.
      def slices(tree)
        case tree
        when Hash then tree.transform_values { |v| slices(v) }
        when Array then tree.map { |v| slices(v) }
        when String then slice(tree)
        else tree
        end
      end
    end
  end
end
