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

      # Nodes whose set attributes are exactly these keys are built from
      # their children's Math objects.
      COMPOSITES = {
        %i[dividend divisor] => lambda do |dividend, divisor|
          Math::Function::Over.new(
            Math::Formula.new(Array(dividend).flatten),
            Math::Formula.new(Array(divisor).flatten),
          )
        end,
      }.freeze

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

        composite = COMPOSITES[set]
        return composite.call(*set.map { |n| built(node.public_send(n)) }) if composite
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
