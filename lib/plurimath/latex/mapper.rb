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
        when String then Parsanol::Slice.new(0, tree.dup.force_encoding(Encoding::UTF_8))
        else tree
        end
      end
    end
  end
end
