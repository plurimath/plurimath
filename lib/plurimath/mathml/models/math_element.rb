# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class MathElement < Mml::V4::Math
        include OrderedChildren

        def to_plurimath
          children = nary_check(children_to_plurimath)
          display_style = boolean_to_displaystyle(display)

          # Unwrap single Mstyle child
          if children.length == 1 && children.first.is_mstyle?
            mstyle = children.first
            children = Array(mstyle.value)
            display_style = mstyle.displaystyle
          end

          Math::Formula.new(
            children,
            display_style: display_style,
          )
        end
      end
      Models.register_model(MathElement, id: :math)
    end
  end
end
