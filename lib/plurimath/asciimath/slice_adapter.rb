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

        # Depth-first with an explicit stack instead of recursion: a long
        # AsciiMath sum is a tree about two levels deep per term, which would
        # overflow a small (1 MiB, as on Windows) stack. Children are visited
        # in the same order as a recursive walk, so the cursor that places
        # empty-string leaves sees the leaves in the same order.
        def walk(root)
          return leaf(root) unless container?(root)

          result = empty_copy(root)
          stack = [[entries(root), result, 0]]
          until stack.empty?
            frame = stack.last
            items, out, index = frame
            next stack.pop if index == items.size

            frame[2] = index + 1
            key, value = items[index]
            if container?(value)
              child = empty_copy(value)
              store(out, key, child)
              stack.push([entries(value), child, 0])
            else
              store(out, key, leaf(value))
            end
          end
          result
        end

        private

        def container?(node)
          node.is_a?(Hash) || node.is_a?(Array)
        end

        def empty_copy(node)
          node.is_a?(Hash) ? {} : []
        end

        def entries(node)
          node.is_a?(Hash) ? node.to_a : node.each_with_index.map { |v, i| [i, v] }
        end

        def store(out, key, value)
          if out.is_a?(Hash)
            out[symbol_key(key)] = value
          else
            out << value
          end
        end

        def leaf(node)
          case node
          when ::Parslet::Slice then keep(node)
          when String then slice(@cursor, node)
          when nil then nil
          else
            return slice_from(node) if foreign_slice?(node)

            node
          end
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
