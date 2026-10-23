# frozen_string_literal: true

module Plurimath
  class Asciimath
    # The AsciiMath grammar lives in the amath gem. This class keeps the
    # tree-level entry point for callers that parse without transforming
    # (plurimath-testsuite's corpus generator calls Parse.new.parse): it
    # returns the Parslet-shaped tree Asciimath::Transform expects, and
    # raises Parslet::ParseFailed with a cause at amath's rejection position.
    class Parse
      def parse(text)
        require "amath"

        tree = ::Amath.parse(text, decimal: Plurimath.configuration.decimal)
        SliceAdapter.convert(tree, text)
      rescue ::Amath::ParseError => e
        raise parse_failed(e, text)
      end

      private

      def parse_failed(error, text)
        position = Parslet::Position.new(text, error.byte_offset)
        cause = Parslet::Cause.new(error.message, Parslet::Source.new(text),
                                   position, [])
        Parslet::ParseFailed.new(error.message, cause)
      end
    end
  end
end
