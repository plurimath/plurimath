# frozen_string_literal: true

module Plurimath
  class Asciimath
    # AsciiMath-specific helpers extracted from Plurimath::Utility (A1 code-quality
    # refactor). Subclasses Utility so bareword `Utility.<generic>` calls inside
    # AsciiMath files keep resolving here and inherit the generic helpers.
    class Utility < Plurimath::Utility
      class << self
        def td_values(objects, slicer)
          sliced = objects.slice_when { |object, _| symbol_value(object, slicer) }
          tds = sliced.map do |slice|
            Math::Function::Td.new(
              slice.delete_if { |d| symbol_value(d, slicer) }.compact,
            )
          end
          tds << Math::Function::Td.new([]) if symbol_value(objects.last, slicer)
          tds
        end

        def td_value(td_object)
          str_classes = [String, Parslet::Slice]
          if str_classes.include?(td_object.class) && td_object.to_s.empty?
            return Math::Function::Text.new(nil)
          end

          td_object
        end

        def frac_values(object)
          case object
          when Math::Formula
            object.value.any? { |d| symbol_value(d, ",") }
          when Array
            object.any? { |d| symbol_value(d, ",") }
          end
        end

        def asciimath_symbol_object(value, lang: :asciimath)
          return if value.nil?

          symbols = symbols_hash(lang)
          return symbols[value&.to_s].new if symbols.key?(value&.to_s)

          symbol_object(value&.to_s, lang: lang)
        end
      end
    end
  end
end
