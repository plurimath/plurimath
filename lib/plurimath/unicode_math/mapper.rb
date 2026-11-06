# frozen_string_literal: true

module Plurimath
  class UnicodeMath
    # Maps the typed UnicodeMath model that the umath gem returns
    # (Umath::Model::Document) to a Plurimath::Math::Formula.
    #
    # umath owns the grammar and the model. Its model classes are the
    # grammar's captures, typed: each class has one attribute per capture key,
    # and the few captures its shape normalization adds (see umath's
    # docs/model-contract.adoc) are listed in WRAPPERS. The mapper first reads
    # a model node as the capture tree it stands for (#captures), then builds
    # the Formula with the UnicodeMath rule table (Mapper::Rules). The model
    # declares fields alphabetically; each Hash of the capture tree lists
    # them in the grammar's capture order instead (Mapper::CaptureOrder).
    class Mapper
      extend Parsanol::Atoms::CanFlatten

      autoload :CaptureOrder, "#{__dir__}/mapper/capture_order"
      autoload :Rules, "#{__dir__}/mapper/rules"

      # The captures umath's shape normalization adds, and the value
      # each one stands for (umath 0.1, grammars/umath.wrappers.json):
      #   :text   the wrapped text ("" when empty);
      #   :empty  an absent optional part ("");
      #   :list   the list ("" when it is empty);
      #   :absent nothing (nil).
      WRAPPERS = {
        empty: :empty,
        list: :list,
        literal: :text,
        literal_2: :text,
        present: :absent,
        spelling: :text,
      }.freeze

      # Filled from the symbol catalog by umath, not by the grammar.
      SYMBOL_FIELDS = %i[value kind].freeze

      def call(document)
        expression = document.expression
        raise ParseError.new("UnicodeMath input has no formula") if expression.nil?

        tree(expression)
      end

      # The capture tree of the model node +expression+ (the formula, captured
      # as the grammar's root), with the grammar's text as Parsanol::Slice
      # values: the input of the rule table.
      def tree(expression)
        slices(captures(expression, capture_order.root_capture))
      end

      # The capture tree of a umath raw tree (Hashes keyed by capture
      # name, Arrays and Parsanol::Slice leaves): its wrappers folded away.
      def unwrap(value)
        case value
        when Hash then fold(value.map { |k, v| [k.to_sym, unwrap(v)] })
        when Array then self.class.send(:flatten_repetition, value.map { |v| unwrap(v) }, true)
        else value
        end
      end

      # Raised for input that holds no formula.
      class ParseError < StandardError; end

      private

      # A model node, captured as +capture+, as its capture tree: Hashes
      # keyed by capture name, Arrays for repetitions, and the captured text.
      def captures(node, capture)
        case node
        when Array then self.class.send(:flatten_repetition, node.map { |v| captures(v, capture) }, true)
        when Lutaml::Model::Serializable then fold(node_fields(node, capture))
        else node
        end
      end

      # The node's set attributes as [name, captures], in the order the
      # grammar captures them.
      def node_fields(node, capture)
        names = node.class.attributes.keys
        names -= SYMBOL_FIELDS if names.include?(:spelling)
        names = names.reject { |name| node.public_send(name).nil? }
        capture_order.order(capture, names).map do |name|
          [name, captures(node.public_send(name), name)]
        end
      end

      # The grammar the model was parsed with: umath's compiled
      # artifact, entry for the configured decimal marker.
      def capture_order
        @capture_order ||= begin
          entry = ::Umath::RawParser.entry_for(Plurimath.configuration.decimal)
          CaptureOrder.for(::Umath.artifacts.parse.entry(entry).fetch("grammar"))
        end
      end

      # Ordinary captures form hash parts; each wrapper is the value it
      # stands for. The parts fold as the grammar's sequence folded them.
      def fold(fields)
        return fields.to_h if fields.none? { |name, _| WRAPPERS.key?(name) }

        parts = []
        run = nil
        only_absent = true
        fields.each do |name, value|
          kind = WRAPPERS[name]
          if kind
            parts << run if run
            run = nil
            only_absent &&= kind == :absent
            parts << wrapped(kind, value)
          else
            only_absent = false
            (run ||= {})[name] = value
          end
        end
        parts << run if run
        return nil if only_absent

        self.class.send(:foldl, parts) { |l, r| self.class.send(:merge_fold, l, r) }
      end

      def wrapped(kind, value)
        case kind
        when :text then value.nil? || value == [] ? +"" : value
        when :empty then +""
        when :list then value == [] ? +"" : value
        when :absent then nil
        end
      end

      # The grammar's captured text is Parsanol::Slice text, which the rule
      # table tells apart from values it has already built.
      def slices(tree)
        case tree
        when Hash then tree.transform_values { |v| slices(v) }
        when Array then tree.map { |v| slices(v) }
        when String then Parsanol::Slice.new(0, tree.dup.force_encoding(Encoding::UTF_8))
        else tree
        end
      end
    end
  end
end
