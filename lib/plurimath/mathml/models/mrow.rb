# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mrow < Mml::V4::Mrow
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          return nil if children.empty?

          children = nary_check(children)

          # Single child: unwrap the mrow
          return children.first if children.length == 1

          mrow = Math::Formula::Mrow.new(children)
          mrow.organize_value

          # Fill parameter_three for ternary functions (Sum, Int, etc.)
          fill_ternary_third_values(mrow.value)

          # Wrap with Intent if intent attribute is present
          if intent && !intent.empty?
            content = mrow.is_a?(Math::Formula) ? mrow : Math::Formula.new([mrow])
            return Math::Function::Intent.new(
              content,
              Math::Function::Text.new(intent),
            )
          end

          mrow
        end
      end
      Models.register_model(Mrow, id: :mrow)
    end
  end
end
