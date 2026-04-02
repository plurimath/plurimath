# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mstack < Mml::V4::Mstack
        include OrderedChildren

        def to_plurimath
          Math::Function::Stackrel.new(
            wrap_children(children_to_plurimath),
          )
        end
      end
      Models.register_model(Mstack, id: :mstack)
    end
  end
end
