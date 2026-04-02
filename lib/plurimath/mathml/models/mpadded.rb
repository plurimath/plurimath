# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mpadded < Mml::V4::Mpadded
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          opts = extract_options(%i[height depth width])
          Math::Function::Mpadded.new(
            wrap_children(children),
            opts || {},
          )
        end
      end
      Models.register_model(Mpadded, id: :mpadded)
    end
  end
end
