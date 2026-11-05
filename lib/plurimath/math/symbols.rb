# frozen_string_literal: true

require "plurimath/math/symbols/symbol"
require "plurimath/math/symbol_index"
require "plurimath/math/symbol_table"

module Plurimath
  module Math
    # Symbol classes load on first reference. Each constant is registered for
    # autoload from the generated SymbolIndex, which also records the order
    # the classes used to be defined in, so lookups built from it match the
    # tables the eager loader produced.
    module Symbols
      if RUBY_ENGINE != "opal"
        SymbolIndex::FILES.each do |name, file|
          autoload name.to_sym, File.join(__dir__, "symbols", "#{file}.rb")
        end
      end

      module_function

      # The indexed classes of +list+ (:symbols or :parens) in definition
      # order, followed by any loaded subclass the index does not know (e.g.
      # one defined at runtime). Loads every class in the list.
      def indexed_classes(list)
        names, base = list_and_base(list)
        names.map { |name| const_get(name) } + unindexed_descendants(base)
      end

      # [constant path or class, INPUT[lang] flattened] for +list+, in
      # definition order, without loading any indexed class.
      def indexed_inputs(list, lang)
        names, base = list_and_base(list)
        inputs = SymbolIndex::INPUTS[lang] || {}
        pairs = names.filter_map { |name| [name, inputs[name]] if inputs.key?(name) }
        return pairs unless base_loaded?(base)

        pairs + unindexed_descendants(base).filter_map do |klass|
          input = klass::INPUT[lang]
          [klass, input.flatten] if input
        end
      end

      # The indexed n-ary symbol classes, then unindexed Symbol subclasses
      # (their is_nary_symbol? is checked by the caller).
      def nary_classes
        SymbolIndex::NARY.map { |name| const_get(name) } +
          unindexed_descendants(:Symbol)
      end

      # Loads every symbol class, in definition order.
      def eager_load!
        SymbolIndex::SYMBOLS.each { |name| const_get(name) }
        SymbolIndex::PARENS.each { |name| const_get(name) }
        nil
      end

      def list_and_base(list)
        case list
        when :symbols then [SymbolIndex::SYMBOLS, :Symbol]
        when :parens then [SymbolIndex::PARENS, :Paren]
        else raise ArgumentError, "unknown symbol list #{list.inspect}"
        end
      end

      def base_loaded?(base)
        RUBY_ENGINE == "opal" || autoload?(base).nil?
      end

      def unindexed_descendants(base)
        return [] unless base_loaded?(base)

        prefix = "Plurimath::Math::Symbols::"
        Array(const_get(base).descendants).reject do |klass|
          name = klass.name
          name&.start_with?(prefix) && indexed_name?(name.delete_prefix(prefix))
        end
      end

      def indexed_name?(name)
        @indexed_names ||= (SymbolIndex::SYMBOLS + SymbolIndex::PARENS)
          .to_h { |indexed| [indexed, true] }.freeze
        @indexed_names.key?(name)
      end

      private_class_method :list_and_base, :base_loaded?, :unindexed_descendants,
                           :indexed_name?
    end
  end
end
