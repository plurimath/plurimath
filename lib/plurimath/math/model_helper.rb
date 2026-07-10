# frozen_string_literal: true

module Plurimath
  module Math
    # Display/serialization support helpers for the Math node classes,
    # extracted from Plurimath::Utility (macro refactor). Deliberately a
    # standalone class — NOT a Utility subclass — so it does not shadow
    # bareword `Utility` references inside math files.
    class ModelHelper
      TEXT_CLASSES = %w[
        symbol
        number
        text
      ].freeze

      class << self
        def validate_left_right(fields = [])
          fields.each do |field|
            if field.is_a?(Math::Formula) && field.value.first.is_a?(Math::Function::Left)
              field.left_right_wrapper = true
            end
          end
        end

        def validate_math_zone(object, lang:, intent: false, options: nil)
          return false unless object

          if object.is_a?(Math::Formula)
            filter_math_zone_values(object.value, lang: lang, intent: intent,
                                                  options: options).find do |value|
              !(value.is_a?(Math::Function::Text) || value.is_a?(Math::Symbols::Symbol))
            end
          else
            !(TEXT_CLASSES.include?(object.class_name) || object.is_a?(Math::Symbols::Symbol))
          end
        end

        def filter_math_zone_values(value, lang:, intent: false, options: nil)
          return [] if value && value.empty?

          new_arr = []
          temp_array = []
          skip_index = nil
          value.each_with_index do |obj, index|
            object = obj.dup
            next if index == skip_index
            if TEXT_CLASSES.include?(object.class_name) || math_display_text_objects(object)
              next temp_array << (if object.is_a?(Math::Symbols::Symbol)
                                    symbol_to_text(
                                      object, lang: lang, intent: intent, options: options
                                    )
                                  else
                                    object.value
                                  end)
            end

            if temp_array.any?
              new_arr << Math::Function::Text.new(temp_array.join(" "),
                                                  lang: lang)
            end
            temp_array = []
            new_arr << object
          end
          if temp_array.any?
            new_arr << Math::Function::Text.new(temp_array.join(" "),
                                                lang: lang)
          end
          new_arr
        end

        def notations_to_mask(notations)
          mask = notations.split.map do |notation|
            Utility::MASK_CLASSES.key(notation)
          end
          mask.inject(*:+) ^ 15
        end

        private

        def symbol_to_text(symbol, lang:, options:, intent: false)
          case lang
          when :asciimath
            symbol.to_asciimath(options: options)
          when :latex
            symbol.to_latex(options: options)
          when :mathml
            symbol.to_mathml_without_math_tag(intent,
                                              options: options).nodes.first
          when :omml
            symbol.to_omml_without_math_tag(true, options: options)
          when :unicodemath
            symbol.to_unicodemath(options: options)
          end
        end

        def math_display_text_objects(object)
          class_names = ["plus", "minus", "circ", "equal", "symbol"].freeze
          class_names.include?(object.class_name)
        end
      end
    end
  end
end
