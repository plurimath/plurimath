# frozen_string_literal: true

module Plurimath
  class Latex
    # Maps the typed LaTeX model that the latexmath gem returns
    # (Latexmath::Model::Document) to a Plurimath::Math::Formula.
    #
    # latexmath owns the grammar and the model. Its model classes are the
    # grammar's captures, typed: each class has one attribute per capture key,
    # and the few captures its shape normalization adds (see latexmath's
    # docs/model-contract.adoc) are listed in WRAPPERS. The mapper builds
    # each node from its children's values, bottom up: a node of one set
    # attribute by its SINGLE builder, a node of several by its TYPED entry.
    #
    # A wrapper is always the only capture of its node: the grammar adds it
    # around a whole alternative (`((x) as literal) as c`, `(x / "" as
    # absent) as c`). So a node is either one wrapper, which stands for its
    # value, or ordinary captures; no node's parts need folding together.
    #
    # A node that no builder fits keeps its children's values in a Hash
    # keyed by capture name, which ends up in the Formula as it is.
    class Mapper
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

      # The matrix row break: latexmath names the capture +row_break+; a node
      # that no builder fits keys it as the String "\\\\", as the LaTeX
      # transform did.
      RENAMES = { row_break: "\\\\" }.freeze

      # A node whose only set attribute is one of these, holding one value
      # (SHAPES[:simple]: not a Hash or Array, nil included), is built from
      # that value. Text captures arrive as Parsanol::Slice text.
      symbol = ->(v) { Utility.symbols_class(v, lang: :latex) }
      same = ->(v) { v }
      SINGLE = {
        number: ->(v) { Math::Number.new(Utility.html_entity_to_unicode(v.to_s)) },
        unary: ->(v) { Utility.get_class(v).new },
        ternary: ->(v) { Utility.get_class(v).new },
        space: ->(_) { Math::Function::Text.new(" ") },
        three_per_em_space: ->(_) { Math::Symbols::ThreePerEmSpace.new },
        row_break: ->(_) { Math::Function::Linebreak.new },
        text: ->(v) { Math::Function::Text.new(v) },
        binary: ->(v) { v.is_a?(Parsanol::Slice) ? Utility.get_class(v).new : v },
        operant: symbol, symbol: symbol, symbols: symbol, unicode_symbols: symbol,
        numeric_values: symbol, lparen: symbol, rparen: symbol,
        # Base-prefix literals, built as Plurimath::BaseNumberPrefix::Transform
        # builds them for the other formats.
        hex_number: ->(v) { Math::Number.new(v.to_s, base: 16) },
        binary_number: ->(v) { Math::Number.new(v.to_s.to_i(2).to_s, base: 2) },
        octal_number: ->(v) { Math::Number.new(v.to_s.to_i(8).to_s, base: 8) },
        # Nodes that stand for their only value.
        base: same, over: same, power: same, limits: same, expression: same,
        environment: same, unary_functions: same, ternary_class: same,
        left_right: same, under_over: same, power_base: same,
        table_data: same, intermediate_exp: same
      }.freeze

      # A node whose only set attribute is one of these, holding a flat list
      # (SHAPES[:sequence]), stands for a Formula of the list.
      SEQUENCES = %i[expression].freeze

      # The value a builder needs from a child: :simple is one value (not a
      # Hash or Array), :sequence a list of such values, :subtree anything,
      # as Parsanol::Transform's simple, sequence and subtree match them.
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
          cases = env.to_s == "cases"
          open_paren = cases ? "{" : Constants::MATRICES[env.to_sym]
          table = Utility.organize_table(rows, **organize)
          close_paren = Constants::MATRICES_PARENTHESIS[open_paren&.to_sym]&.to_s
          close_paren = ":}" if cases # the open-ended brace of Table::Cases
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
        [{ underover: s, first_value: s, supscript: s },
         ->(f, v, p) { Math::Function::Power.new(Utility.get_class(f).new(v), p) }],
        [{ underover: s, first_value: s, subscript: s },
         ->(f, v, b) { Math::Function::Base.new(Utility.get_class(f).new(v), b) }],
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
        [{ lparen: s, rparen: s }, ->(_, _) { [] }],
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

        formula = value(expression)
        formula = [formula] unless formula.is_a?(Array)

        Math::Formula.new(formula)
      end

      # Raised for input that holds no formula (empty, or only spaces and
      # newlines), which the grammar refuses.
      class ParseError < StandardError; end

      private

      # A model value (node, repetition or captured text) as the Math object
      # it builds: a node's value, a list of values, or the text as a
      # Parsanol::Slice.
      def value(model)
        unwrap(captures(model))
      end

      # A model value as its capture tree: { built: value } for a node with
      # attributes set, a wrapper's value, Arrays for repetitions, and the
      # captured text.
      def captures(model)
        case model
        when Array then repetition(model.map { |v| captures(v) })
        when Lutaml::Model::Serializable then node_captures(model)
        else model
        end
      end

      # The only repetitions in the model are +items+ lists, whose elements
      # are hashes, or nil for an element with nothing set. A named
      # repetition keeps its hashes; one with none left is the empty list
      # when nothing repeated and empty text otherwise.
      def repetition(list)
        hashes = list.grep(Hash)
        return hashes unless hashes.empty?

        list.empty? ? [] : +""
      end

      # A capture tree as the value it stands for.
      def unwrap(tree)
        case tree
        when Hash then tree.fetch(:built)
        when Array then tree.map { |v| unwrap(v) }
        when String then slice(tree)
        else tree
        end
      end

      # A wrapper's value, nil for a node with nothing set, or the node's
      # built value.
      def node_captures(node)
        set = node.class.attributes.reject do |name, attribute|
          attribute.method_name ||
            (::Latexmath::Model.respond_to?(:catalog_field?) &&
             ::Latexmath::Model.catalog_field?(node.class, name)) ||
            node.public_send(name).nil?
        end.keys
        wrapper = set.find { |n| WRAPPERS.key?(n) }
        return wrapper_captures(node, set, wrapper) if wrapper
        return if set.empty?

        { built: build(node, set) }
      end

      def wrapper_captures(node, set, wrapper)
        unless set.size == 1
          raise ArgumentError, "#{node.class} sets the wrapper #{wrapper} with #{set - [wrapper]}"
        end

        wrapped(WRAPPERS[wrapper], captures(node.public_send(wrapper)))
      end

      # The node built from its children's values by its TYPED entry or its
      # SINGLE or SEQUENCES builder. A node that none fits keeps the values,
      # keyed by capture name.
      def build(node, set)
        values = set.to_h { |n| [n, value(node.public_send(n))] }
        entries = TYPED_BY_KEYS[set.sort]
        return typed(node, entries, values) if entries

        name = set.first
        if set.size == 1
          single = SINGLE[name]
          return single.call(values[name]) if single && SHAPES[:simple].call(values[name])
          return Math::Formula.new(values[name]) if SEQUENCES.include?(name) && SHAPES[:sequence].call(values[name])
        end
        unbuilt(values)
      end

      # The node built by the first TYPED entry its children fit. A flat list
      # (a non-nary sequence, see Build.nary) is returned as is, and the
      # parent reads it as a list.
      def typed(node, entries, values)
        entries.each do |shapes, build|
          next unless shapes.all? { |n, shape| SHAPES[shape].call(values[n]) }

          result = build.call(*shapes.keys.map { |n| values[n] })
          return result unless result.is_a?(Hash) || (result.is_a?(Array) && !SHAPES[:sequence].call(result))

          raise ArgumentError, "#{node.class} built #{result.class} that is neither a node nor a flat list"
        end
        unbuilt(values)
      end

      def unbuilt(values)
        values.transform_keys { |n| RENAMES.fetch(n, n) }
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
    end
  end
end
