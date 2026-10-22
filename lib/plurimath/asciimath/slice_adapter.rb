# frozen_string_literal: true

module Plurimath
  class Asciimath
    # Turns a parse tree produced by amath (Parsanol) into the tree the
    # Parslet-based Asciimath::Parse produced, so Asciimath::Transform and the
    # other Parslet::Slice consumers keep working unchanged.
    #
    # - Every leaf becomes a real Parslet::Slice. Parsanol slices carry a byte
    #   offset into the parsed string; Parslet::Position also stores a byte
    #   offset and derives the character offset (Slice#offset) from it, so the
    #   byte offset is kept and #offset answers in characters, as Parslet does.
    # - Plain String leaves (Parsanol returns a bare "" for an empty match)
    #   become Parslet::Slice at the end of the last leaf seen so far, in tree
    #   order; for empty input that is ""@0, as Parslet gives.
    # - Hashes keep their key order (String keys become Symbols, as Parslet
    #   always uses Symbols), arrays keep their order, [] stays [], nil stays
    #   nil.
    module SliceAdapter
      class OffsetError < StandardError; end

      module_function

      def convert(tree, input)
        input = input.to_s
        line_cache = Parslet::Source::LineCache.new
        line_cache.scan_for_line_endings(0, input)
        Walker.new(input, line_cache).walk(tree)
      end

      class Walker
        def initialize(input, line_cache)
          @input = input
          @line_cache = line_cache
          @cursor = 0
        end

        def walk(node)
          case node
          when Hash then node.to_h { |key, value| [symbol_key(key), walk(value)] }
          when Array then node.map { |value| walk(value) }
          when ::Parslet::Slice then keep(node)
          when String then slice(@cursor, node)
          when nil then nil
          else
            return slice_from(node) if foreign_slice?(node)

            node
          end
        end

        private

        def keep(node)
          advance(node.position.bytepos, node.to_s)
          node
        end

        def symbol_key(key)
          key.is_a?(String) ? key.to_sym : key
        end

        def foreign_slice?(node)
          node.respond_to?(:offset) && node.respond_to?(:to_str)
        end

        def slice_from(node)
          content = node.to_str
          bytepos = node.offset
          unless @input.byteslice(bytepos, content.bytesize) == content
            raise OffsetError,
                  "slice #{content.inspect} does not match the input at " \
                  "byte #{bytepos}"
          end

          slice(bytepos, content)
        end

        def slice(bytepos, content)
          advance(bytepos, content)
          position = ::Parslet::Position.new(@input, bytepos)
          ::Parslet::Slice.new(position, content.to_s.dup, @line_cache)
        end

        def advance(bytepos, content)
          finish = bytepos + content.to_s.bytesize
          @cursor = finish if finish > @cursor
        end
      end
    end
  end
end
