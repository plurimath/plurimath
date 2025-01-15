# frozen_string_literal: true

require_relative "../utility/shared"

module Plurimath
  class Mathml
    class TransformHelper
      extend Utility::Shared

      TABLE_SUPPORTED_ATTRS = %i[
        columnlines
        rowlines
        frame
      ].freeze
      MPADDED_ATTRS = %i[
        height
        depth
        width
      ].freeze
      MGLYPH_ATTRS = %i[
        height
        width
        index
        alt
        src
      ].freeze

      class << self
        def join_attr_value(attrs, value, unicode_only: false, lang: :mathml)
          if attrs&.is_a?(Hash) && attrs.key?(:intent)
            [
              Math::Function::Intent.new(
                Utility.filter_values(join_attr_value(nil, value, unicode_only: unicode_only, lang: lang)),
                Math::Function::Text.new(attrs[:intent]),
              )
            ]
          elsif value.any?(String)
            new_value = mathml_unary_classes(value, unicode_only: unicode_only, lang: lang)
            array_value = Array(new_value)
            attrs.nil? ? array_value : join_attr_value(attrs, array_value, unicode_only: unicode_only)
          elsif attrs.nil?
            value
          elsif attrs.is_a?(String) && ["solid", "none"].include?(attrs.split.first.downcase)
            table_separator(attrs.split, value)
          elsif attrs.is_a?(Hash)
            if (attrs.key?(:accent) || attrs.key?(:accentunder))
              attr_is_accent(attrs, value)
            elsif attrs.key?(:linebreak)
              Math::Function::Linebreak.new(value.first, attrs)
            elsif attrs.key?(:bevelled) || attrs.key?(:linethickness)
              Math::Function::Frac.new(value[0], value[1], attrs)
            elsif attrs.key?(:notation)
              value << attrs
            elsif attrs.key?(:separators)
              fenced = Math::Function::Fenced.new(
                symbol_object(attrs[:open] || "(", lang: lang),
                value,
                symbol_object(attrs[:close] || ")", lang: lang),
              )
              fenced.options = { separators: attrs[:separators] }
              fenced
            elsif TABLE_SUPPORTED_ATTRS.any? { |atr| attrs.key?(atr) }
              Math::Function::Table.new(value, nil, nil, attrs)
            elsif MPADDED_ATTRS.any? { |atr| attrs.key?(atr) }
              Math::Function::Mpadded.new(
                filter_values(value),
                attrs,
              )
            elsif MGLYPH_ATTRS.any? { |atr| attrs.key?(atr) }
              Math::Function::Mglyph.new(
                attrs,
              )
            end
          elsif attrs.is_a?(Math::Core)
            attr_is_function(attrs, value)
          end
        end

        def fenceable_classes(mrow = [])
          return false unless mrow.length > 1
          return unless paren_able?(Utility::PARENTHESIS, mrow) || (mrow.first.paren? && mrow.last.paren?)

          open_paren = mrow.shift
          close_paren = mrow.pop
          if mrow.length == 1 && mrow.first.is_a?(Math::Function::Table)
            table = mrow.first
            table.open_paren = open_paren
            table.close_paren = close_paren
          else
            mrow.replace(
              [
                Math::Function::Fenced.new(open_paren, mrow.dup, close_paren),
              ],
            )
          end
        end

        def paren_able?(arr = [], mrow = [])
          arr.any? do |opening, closing|
            Utility.symbol_value(mrow.first, opening.to_s) &&
              Utility.symbol_value(mrow.last, closing.to_s)
          end
        end

        def attr_is_accent(attrs, value)
          if value.last.is_a?(Math::Function::UnaryFunction)
            value.last.parameter_one = value.shift if value.length > 1
            value.last.attributes = attrs.transform_values { |v| YAML.safe_load(v) }
          end
          value
        end

        def attr_is_function(attrs, value)
          case attrs
          when Math::Function::Fenced
            attrs.parameter_two = value.compact
            attrs
          when Math::Function::FontStyle
            attrs.parameter_one = filter_values(value)
            attrs
          when Math::Function::Color
            color_value = filter_values(value)
            if attrs.parameter_two
              attrs.parameter_two.parameter_one = color_value
            else
              attrs.parameter_two = color_value
            end
            attrs
          end
        end

        def multiscript(values)
          values.slice_before("mprescripts").map do |value|
            base_value   = value.shift
            value        = Utility.nil_to_none_object(value)
            part_val     = value.partition.with_index { |_, i| i.even? }
            first_value  = part_val[0].empty? ? nil : part_val[0]
            second_value = part_val[1].empty? ? nil : part_val[1]
            if base_value.to_s.include?("mprescripts")
              [first_value, second_value]
            else
              Math::Function::PowerBase.new(
                filter_values(base_value),
                filter_values(first_value),
                filter_values(second_value),
              )
            end
          end
        end

        def mrow_left_right(mrow = [])
          object = mrow.first
          !(
            ((object.is_a?(Math::Function::TernaryFunction) && object.any_value_exist?) && (mrow.length <= 2)) ||
            (object.is_a?(Math::Function::UnaryFunction) && mrow.length == 1)
          )
        end
      end
    end
  end
end
