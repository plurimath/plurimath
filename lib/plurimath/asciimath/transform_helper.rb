# frozen_string_literal: true

module Plurimath
  class Asciimath
    class TransformHelper
      class << self
        STR_CLASSES = [String, Parslet::Slice].freeze

        def asciimath_symbol_object(value, lang: :asciimath)
          return if value.nil?

          symbols = Utility.symbols_hash(lang)
          return symbols[value&.to_s].new if symbols.key?(value&.to_s)

          Utility.symbol_object(value&.to_s, lang: lang)
        end

        def td_values(objects, slicer)
          sliced = objects.slice_when { |object, _| Utility.symbol_value(object, slicer) }
          tds = sliced.map do |slice|
            Math::Function::Td.new(
              slice.delete_if { |d| Utility.symbol_value(d, slicer) }.compact,
            )
          end
          tds << Math::Function::Td.new([]) if Utility.symbol_value(objects.last, slicer)
          tds
        end

        def frac_values(object)
          case object
          when Math::Formula
            object.value.any? { |d| Utility.symbol_value(d, ",") }
          when Array
            object.any? { |d| Utility.symbol_value(d, ",") }
          end
        end

        def td_value(td_object)
          if STR_CLASSES.include?(td_object.class) && td_object.to_s.empty?
            return Math::Function::Text.new(nil)
          end

          td_object
        end
      end
    end
  end
end
