# frozen_string_literal: true

module Plurimath
  class Asciimath
    # The AsciiMath grammar lives in the amath gem. This class keeps the
    # tree-level entry point for callers that parse without transforming
    # (plurimath-testsuite's corpus generator calls Parse.new.parse): it
    # returns the Parslet-shaped tree Asciimath::Transform expects, and
    # raises Parslet::ParseFailed with a cause at amath's rejection position.
    class Parse
      # amath is not released yet, so the Gemfile line points at GitHub.
      AMATH_GEMFILE_LINE = 'gem "amath", github: "plurimath/amath"'

      def parse(text)
        load_amath
        parse_with_amath(text)
      end

      private

      # Loaded here, outside parse_with_amath, so its `rescue ::Amath::...`
      # clause is never evaluated while Amath is undefined.
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

      def parse_with_amath(text)
        tree = ::Amath.parse(text, decimal: Plurimath.configuration.decimal)
        SliceAdapter.convert(tree, text)
      rescue ::Amath::ParseError => e
        raise parse_failed(e, text)
      end

      def parse_failed(error, text)
        position = Parslet::Position.new(text, error.byte_offset)
        cause = Parslet::Cause.new(error.message, Parslet::Source.new(text),
                                   position, [])
        Parslet::ParseFailed.new(error.message, cause)
      end
    end
  end
end
