# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mstyle < Mml::V4::Mstyle
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          content = wrap_children(children)

          has_color = mathcolor && !mathcolor.empty?
          has_variant = mathvariant && !mathvariant.empty?

          # Apply mathcolor as Color wrapper
          if has_color
            content = Math::Function::Color.new(
              Math::Function::Text.new(mathcolor),
              content,
            )
          end

          # Apply mathvariant as FontStyle wrapper
          if has_variant
            font_class = Plurimath::Utility::FONT_STYLES[mathvariant.to_sym]
            if font_class
              styled = font_class.new(content, mathvariant)
              # Simple token (Symbol, Number): FontStyle directly
              # Complex content (Formula, functions): wrap in Mstyle
              return styled if simple_token?(content)

              mstyle = Math::Formula::Mstyle.new([styled])
              mstyle.displaystyle = displaystyle if displaystyle
              return mstyle
            end
          end

          # If only mathcolor was applied, return the Color wrapper directly
          return content if has_color

          mstyle = Math::Formula::Mstyle.new(children)
          mstyle.displaystyle = displaystyle if displaystyle
          mstyle
        end

        private

        def simple_token?(content)
          content.is_a?(Math::Symbols::Symbol) ||
            content.is_a?(Math::Number)
        end
      end
      Models.register_model(Mstyle, id: :mstyle)
    end
  end
end
