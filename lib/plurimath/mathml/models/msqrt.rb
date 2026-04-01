# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Msqrt < Mml::V4::Msqrt
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          Math::Function::Sqrt.new(wrap_children(children))
        end
      end
      Models.register_model(Msqrt, id: :msqrt)
    end
  end
end
