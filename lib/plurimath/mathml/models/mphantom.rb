# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mphantom < Mml::V4::Mphantom
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          Math::Function::Phantom.new(wrap_children(children))
        end
      end
      Models.register_model(Mphantom, id: :mphantom)
    end
  end
end
