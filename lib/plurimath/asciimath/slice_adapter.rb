# frozen_string_literal: true

module Plurimath
  class Asciimath
    # Turns a parse tree produced by amath (Parsanol) into a Parslet-shaped
    # tree (Symbol keys, Parslet::Slice leaves), so Asciimath::Transform and
    # the other Parslet::Slice consumers keep working unchanged.
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

        # Preserve depth-first leaf order without using the Ruby call stack.
        def walk(node)
          root = []
          pending = [[node, root, 0]]
          until pending.empty?
            value, parent, key = pending.pop
            parent[key] = convert_node(value, pending)
          end
          root.first
        end

        private

        def convert_node(node, pending)
          case node
          when Hash then convert_hash(node, pending)
          when Array then convert_array(node, pending)
          when ::Parslet::Slice then keep(node)
          when String then slice(@cursor, node)
          when nil then nil
          else
            return slice_from(node) if foreign_slice?(node)

            node
          end
        end

        def convert_hash(node, pending)
          converted = {}
          node.to_a.reverse_each do |key, value|
            pending << [value, converted, symbol_key(key)]
          end
          converted
        end

        def convert_array(node, pending)
          converted = []
          (node.length - 1).downto(0) do |index|
            pending << [node[index], converted, index]
          end
          converted
        end

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
