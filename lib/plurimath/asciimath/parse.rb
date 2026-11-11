# frozen_string_literal: true

module Plurimath
  class Asciimath
    # The AsciiMath grammar lives in the amath gem. This class keeps the
    # tree-level entry point for callers that parse without building a
    # Formula (plurimath-testsuite's corpus generator calls
    # Parse.new.parse): it returns amath's legacy-shaped raw tree as the
    # Parslet-shaped tree Mapper::Rules reads, and raises
    # Parslet::ParseFailed with a cause at amath's rejection position.
    #
    # The raw tree is what Amath.parse and Amath::Parser.raw return (amath
    # 0.1's contract); plurimath's own parsing uses the typed model from
    # Amath.parse_model instead.
    class Parse
      # amath is a runtime dependency (published on RubyGems); this line is
      # only guidance for installs where the gem is unexpectedly missing.
      AMATH_GEMFILE_LINE = 'gem "amath"'

      def parse(text)
        load_amath
        parse_with_amath(text)
      end

      # Loaded here, outside the methods that rescue ::Amath::... errors, so
      # those clauses are never evaluated while Amath is undefined.
      def load_amath
        require "amath"
      rescue LoadError => e
        raise unless e.path == "amath" || e.message.end_with?("-- amath")

        raise Math::MissingDependencyError.new(
          :asciimath,
          format_name: "AsciiMath",
          gem_name: "amath",
          gemfile_line: AMATH_GEMFILE_LINE,
        ), cause: nil
      end

      # The Parslet::ParseFailed for an amath refusal of +text+, with its
      # cause at amath's position.
      def self.parse_failed(error, text)
        position = Parslet::Position.new(text, error.byte_offset)
        cause = Parslet::Cause.new(error.message, Parslet::Source.new(text),
                                   position, [])
        Parslet::ParseFailed.new(error.message, cause)
      end

      private

      def parse_with_amath(text)
        tree = ::Amath::Parser.raw(text, decimal: Plurimath.configuration.decimal)
        SliceAdapter.convert(tree, text)
      rescue ::Amath::ParseError => e
        raise self.class.parse_failed(e, text)
      end
    end
  end
end
