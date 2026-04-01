# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mscarries < Mml::V4::Mscarries
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          Math::Function::Scarries.new(wrap_children(children))
        end
      end
      Models.register_model(Mscarries, id: :mscarries)
    end
  end
end
