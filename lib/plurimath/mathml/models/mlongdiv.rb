# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mlongdiv < Mml::V4::Mlongdiv
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          Math::Function::Longdiv.new(wrap_children(children))
        end
      end
      Models.register_model(Mlongdiv, id: :mlongdiv)
    end
  end
end
