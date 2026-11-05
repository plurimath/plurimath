# frozen_string_literal: true

require "bigdecimal"

module Plurimath
  class Asciimath
    # Maps the typed AsciiMath model that the amath gem returns
    # (Amath::Model::Document) to a Plurimath::Math::Formula.
    #
    # amath owns the grammar and the model. Its model classes are the
    # grammar's captures, typed: each class has one attribute per capture
    # key, and the captures its shape normalization adds (see amath's
    # docs/parser-contract.adoc) are listed in WRAPPERS. The mapper reads a
    # model node as the capture tree it stands for (#captures), rebuilds the
    # nesting of the flat expression chains (Amath::Renester), and builds the
    # Formula with the AsciiMath rule table (Mapper::Rules).
    class Mapper
      extend Parsanol::Atoms::CanFlatten

      autoload :Rules, "#{__dir__}/mapper/rules"

      # The captures amath's shape normalization adds, and the value each
      # one stands for (grammars/asciimath.wrappers.json):
      #   :text       the wrapped text ("" when empty);
      #   :empty      "";
      #   :empty_list [];
      #   :list       the list ("" when empty).
      WRAPPERS = {
        literal: :text,
        literal_2: :text, # rubocop:disable Naming/VariableNumber -- amath's capture name
        spelling: :text,
        empty: :empty,
        empty_list: :empty_list,
        list: :list,
      }.freeze

      def call(document, text)
        return pma_formula(document.term) if document.is_a?(::Amath::Model::PmaDocument)

        expression = document.expression
        tree = expression.nil? ? +"" : ::Amath::Renester.call(captures(expression))
        formula = Rules.new.apply(SliceAdapter.convert(tree, text))
        return formula if formula.is_a?(Math::Formula)

        Math::Formula.new(formula)
      end

      private

      # A pma document holds one term: a measured value (with its unit), a
      # unit, or diff(q). The measured value takes the same path as the
      # dialect L uncertainty calls (Rules::UncertaintyTree).
      def pma_formula(term)
        node = if term.uncertainty
                 Rules::UncertaintyTree.node(pma_uncertainty(term.uncertainty))
               elsif term.unit
                 Math::Function::Unitsml.new(term.unit.literal.to_s)
               else
                 raise ArgumentError,
                       "diff(q) has no Plurimath node yet (docs/pma.adoc, open decision 9)"
               end
        Math::Formula.new([node])
      end

      # The uncertainty fields as dialect L names them. A measured literal
      # (v +/- u) is a standard uncertainty; a relative one (v +/- p%) stores
      # the absolute magnitude v * p / 100, exact on the decimal text.
      def pma_uncertainty(model)
        fields = {}
        model.class.attributes.each_key do |name|
          value = model.public_send(name)
          fields[name] = value unless value.nil?
        end
        fields[:uncertainty_class] = "ustd" if fields.delete(:plus_minus)
        fields[:unit] = fields[:unit].literal.to_s if fields.key?(:unit)
        relative = fields.delete(:relative_magnitude)
        fields[:magnitude] = relative_magnitude(fields[:value], relative) if relative
        fields.transform_values(&:to_s)
      end

      def relative_magnitude(value, percent)
        product = BigDecimal(value.to_s).abs * BigDecimal(percent.to_s) / 100
        product.to_s("F").sub(/\.0\z/, "")
      end

      # A model node as its capture tree: Hashes keyed by capture name,
      # Arrays for repetitions, and the captured text.
      def captures(node)
        case node
        when Array then self.class.send(:flatten_repetition, node.map { |v| captures(v) }, true)
        when Lutaml::Model::Serializable then node_captures(node)
        else node
        end
      end

      # The node's set capture attributes, in declared order. Ordinary
      # captures form hash parts; each wrapper is the value it stands for.
      # The parts fold as the grammar's sequence folded them. Derived
      # attributes (MathSymbol#value and #kind) are not captures.
      def node_captures(node)
        parts = []
        run = nil
        node.class.attributes.each do |name, attribute|
          next if attribute.method_name

          value = node.public_send(name)
          next if value.nil?

          kind = WRAPPERS[name]
          if kind
            parts << run if run
            run = nil
            parts << wrapped(kind, captures(value))
          else
            (run ||= {})[name] = captures(value)
          end
        end
        run = unclosed(node, run)
        parts << run if run
        return nil if parts.empty?

        self.class.send(:foldl, parts) { |l, r| self.class.send(:merge_fold, l, r) }
      end

      # The grammar captures a missing closing paren as rparen: nil, which a
      # model node holds as an unset attribute: an opened paren without a
      # closing one gets the nil capture back.
      def unclosed(node, run)
        return run unless run&.key?(:lparen) && !run.key?(:rparen) &&
          node.class.attributes.key?(:rparen)

        run.merge(rparen: nil)
      end

      def wrapped(kind, value)
        case kind
        when :text then value.nil? || value == [] ? +"" : value
        when :empty then +""
        when :empty_list then []
        when :list then value == [] ? +"" : value
        end
      end
    end
  end
end
