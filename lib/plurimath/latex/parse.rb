# frozen_string_literal: true

module Plurimath
  class Latex
    # The LaTeX grammar lives in the latexmath gem. This class keeps the
    # tree-level entry point for callers that parse without building a
    # Formula (plurimath-testsuite's corpus generator calls
    # Parse.new.parse on Parser#text): it returns latexmath's legacy-shaped
    # raw tree and raises Parsanol::ParseFailed with a cause at the
    # grammar's rejection position.
    #
    # The raw tree and the grammar step are latexmath internals, not its public API
    # (Latexmath.parse and the typed model are its API); nothing in plurimath's own
    # parsing uses this class.
    class Parse
      ENGINES = { nil => :auto, ruby: :ruby, native: :native }.freeze

      def parse(text, mode: nil, **_options)
        Parser.load_latexmath
        parse_tree(text, ENGINES.fetch(mode))
      end

      private

      # +text+ is grammar input (Parser#text), so latexmath's preprocessing
      # is not run again: only its grammar, bindings and tree unwrap.
      def parse_tree(text, engine)
        entry = ::Latexmath::RawParser.entry_for(Plurimath.configuration.decimal)
        input = ::Latexmath::RawParser.grammar_input(text)
        loaded = ::Latexmath.artifacts
        shape = ::Latexmath::Engine.run(loaded.parse, entry, input, ::Latexmath::Engine.resolve(engine),
                                        fallback: engine == :auto, source: input)
        raw = loaded.bindings.apply(entry, shape).fetch(:latex_tree)
        ::Latexmath::RawParser.restore_capture_names(::Latexmath::Unwrap.call(raw))
      rescue ::Latexmath::ParseError => e
        raise Parser.parse_failed(e, text)
      end
    end
  end
end
