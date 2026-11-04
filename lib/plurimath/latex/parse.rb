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
    # The raw tree is latexmath's internal test boundary, not its public API
    # (Latexmath.parse and the typed model are); nothing in plurimath's own
    # parsing uses this class.
    class Parse
      ENGINES = { nil => :auto, ruby: :ruby, native: :native }.freeze

      def parse(text, mode: nil, **_options)
        Parser.load_latexmath
        parse_tree(text, ENGINES.fetch(mode))
      end

      private

      def parse_tree(text, engine)
        ::Latexmath::RawParser.parse(text, decimal: Plurimath.configuration.decimal, engine: engine).tree
      rescue ::Latexmath::ParseError => e
        raise Parser.parse_failed(e, text)
      end
    end
  end
end
