# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Msrow < Mml::V4::Msrow
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          Math::Formula.new(children)
        end
      end
      Models.register_model(Msrow, id: :msrow)
    end
  end
end
