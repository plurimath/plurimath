# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mglyph < Mml::V4::Mglyph
        include OrderedChildren

        def to_plurimath
          opts = extract_options(%i[alt src index width height valign])
          Math::Function::Mglyph.new(opts || {})
        end
      end
      Models.register_model(Mglyph, id: :mglyph)
    end
  end
end
