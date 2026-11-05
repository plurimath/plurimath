# frozen_string_literal: true

module Plurimath
  class UnicodeMath
    # The UnicodeMath grammar lives in the unicodemath gem. This class keeps
    # the tree-level entry point for callers that parse without building a
    # Formula (plurimath-testsuite's corpus generator calls Parse.new.parse
    # on Parser#text): it returns the legacy-shaped raw tree and raises
    # Parsanol::ParseFailed for a refusal.
    #
    # The raw tree and the grammar step are unicodemath internals, not its
    # public API (Unicodemath.parse and the typed model are its API); nothing
    # in plurimath's own parsing uses this class.
    class Parse
      ENGINES = { nil => :ruby, ruby: :ruby, native: :native, auto: :auto }.freeze

      def parse(text, mode: nil, **_options)
        Parser.load_unicodemath
        parse_tree(text, ENGINES.fetch(mode))
      end

      # The grammar's number rule: a formula that is one number, as the
      # number capture (the factor around it removed). unicodemath has no
      # entry for the rule itself, so anything else is refused.
      def number
        NumberRule.new(self)
      end

      class NumberRule
        NUMBER_KEYS = %i[number decimal_number].freeze

        def initialize(parse)
          @parse = parse
        end

        def parse(text, **options)
          tree = @parse.parse(text, **options)
          factor = tree.is_a?(Hash) && tree.keys == [:factor] ? tree[:factor] : nil
          return factor if factor.is_a?(Hash) && factor.size == 1 && NUMBER_KEYS.include?(factor.keys.first)

          error = Struct.new(:message, :input, :byte_offset).new("Expected a number", text, 0)
          raise Parser.parse_failed(error, text)
        end
      end

      private

      # +text+ is grammar input (Parser#text), so unicodemath's
      # preprocessing is not run again: only its grammar and bindings.
      def parse_tree(text, engine)
        entry = ::Unicodemath::RawParser.entry_for(Plurimath.configuration.decimal)
        loaded = ::Unicodemath.artifacts
        shape = ::Unicodemath::Engine.run(loaded.parse, entry, text, ::Unicodemath::Engine.resolve(engine),
                                          fallback: engine == :auto)
        raw = loaded.bindings.apply(entry, shape).fetch(::Unicodemath::Configuration::TREE_CAPTURE)
        Mapper.new.unwrap(raw)
      rescue ::Unicodemath::ParseError => e
        raise Parser.parse_failed(e, text)
      end
    end
  end
end
