# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mglyph < Mml::V4::Mglyph
        include OrderedChildren

        def to_plurimath
          Math::Function::Mglyph.new
        end
      end
      Models.register_model(Mglyph, id: :mglyph)
    end
  end
end
