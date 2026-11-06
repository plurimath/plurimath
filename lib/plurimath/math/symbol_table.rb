# frozen_string_literal: true

module Plurimath
  module Math
    # A Hash from input strings to symbol classes that loads a class only when
    # its entry is read. Entries are stored as constant paths relative to
    # Math::Symbols (or as classes) and swapped for the class on first read.
    #
    # Lookups by key (#[], #fetch, #dig, #values_at, #fetch_values) and the
    # key-only methods load nothing beyond the entries they return. Any other
    # Hash or Enumerable method resolves every entry first, so the table then
    # behaves exactly like the eager Hash it replaces.
    class SymbolTable < ::Hash
      HASH_STORE = ::Hash.instance_method(:store)
      HASH_FETCH = ::Hash.instance_method(:fetch)
      HASH_EACH_PAIR = ::Hash.instance_method(:each_pair)

      KEY_ONLY_METHODS = %i[
        keys key? has_key? include? member? each_key size length empty?
        compare_by_identity? default default_proc
      ].freeze
      LOOKUP_METHODS = %i[[] fetch dig values_at fetch_values].freeze

      # +pairs+ is an ordered list of [input, constant path or class].
      def initialize(pairs = nil)
        super()
        pairs&.each { |key, value| HASH_STORE.bind_call(self, key, value) }
      end

      def [](key)
        resolve(key, super)
      end

      def fetch(key, *args, &block)
        return super unless key?(key)

        resolve(key, super)
      end

      def dig(key, *rest)
        return self[key] if rest.empty?

        resolve_all!
        super
      end

      def values_at(*keys)
        keys.map { |key| self[key] }
      end

      def fetch_values(*keys, &block)
        keys.map { |key| fetch(key, &block) }
      end

      # The stored [key, value] pairs, without resolving anything.
      def raw_pairs
        pairs = []
        HASH_EACH_PAIR.bind_call(self) { |key, value| pairs << [key, value] }
        pairs
      end

      # Resolves every entry. Idempotent.
      def resolve_all!
        raw_pairs.each { |key, value| resolve(key, value) }
        self
      end

      wrapped = ::Hash.public_instance_methods(true) - ::Object.public_instance_methods +
        %i[== eql? hash inspect to_s]
      (wrapped - KEY_ONLY_METHODS - LOOKUP_METHODS - %i[raw_pairs resolve_all!])
        .uniq.each do |name|
          define_method(name) do |*args, **kwargs, &block|
            resolve_all!
            super(*args, **kwargs, &block)
          end
        end

      private

      def resolve(key, value)
        return value unless value.is_a?(::String)

        klass = Symbols.const_get(value)
        HASH_STORE.bind_call(self, key, klass)
        klass
      end
    end
  end
end
