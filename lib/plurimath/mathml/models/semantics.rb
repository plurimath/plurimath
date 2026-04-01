# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Semantics < Mml::V4::Semantics
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          Math::Function::Semantics.new(wrap_children(children))
        end
      end
      Models.register_model(Semantics, id: :semantics)
    end
  end
end
