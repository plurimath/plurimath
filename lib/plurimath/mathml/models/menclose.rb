# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Menclose < Mml::V4::Menclose
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          Math::Function::Menclose.new(
            notation,
            wrap_children(children),
          )
        end
      end
      Models.register_model(Menclose, id: :menclose)
    end
  end
end
