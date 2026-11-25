# frozen_string_literal: true

module Plurimath
  module Math
    # Display/serialization support helpers for the Math node classes,
    # extracted from Plurimath::Utility (macro refactor). Deliberately a
    # standalone class — NOT a Utility subclass — so it does not shadow
    # bareword `Utility` references inside math files.
    class ModelHelper
      autoload :TreeHelpers, "plurimath/math/model_helper/tree_helpers"

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
          singleton_class.include(TreeHelpers) unless singleton_class < TreeHelpers
          super
        end

        def filter_math_zone_values(value, lang:, intent: false, options: nil)
          singleton_class.include(TreeHelpers) unless singleton_class < TreeHelpers
          super
        end

        def notations_to_mask(notations)
          mask = notations.split.map do |notation|
            Utility::MASK_CLASSES.key(notation)
          end
          mask.compact.sum ^ 15
        end

        private

        def symbol_to_text(symbol, lang:, options:, intent: false)
          singleton_class.include(TreeHelpers) unless singleton_class < TreeHelpers
          super
        end

        def math_display_text_objects(object)
          singleton_class.include(TreeHelpers) unless singleton_class < TreeHelpers
          super
        end
      end
    end
  end
end
