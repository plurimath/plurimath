# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class MathElement < Mml::V4::Math
        include OrderedChildren

        def to_plurimath
          children = nary_check(children_to_plurimath)

          # Unwrap single Mstyle child — propagate displaystyle to formula
          if children.length == 1 && children.first.is_mstyle?
            mstyle = children.first
            children = Array(mstyle.value)
            display = mstyle.displaystyle
          end

          Math::Formula.new(
            children,
            display_style: boolean_to_displaystyle(display),
          )
        end

        private

        def boolean_to_displaystyle(value)
          case value
          when "true", true then true
          when "false", false then false
          else true
          end
        end
      end
      Models.register_model(MathElement, id: :math)
    end
  end
end
