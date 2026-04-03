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

          if has_color
            content = Math::Function::Color.new(
              Math::Function::Text.new(mathcolor),
              content,
            )
          end

          if has_variant
            font_class = Plurimath::Utility::FONT_STYLES[mathvariant.to_sym]
            return font_class.new(content, mathvariant) if font_class
          end

          return content if has_color

          fill_ternary_third_values(children)
          Math::Formula::Mstyle.new(children, display_style: boolean_to_displaystyle(displaystyle))
        end
      end
      Models.register_model(Mstyle, id: :mstyle)
    end
  end
end
