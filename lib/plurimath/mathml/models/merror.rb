# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Merror < Mml::V4::Merror
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          Math::Function::Merror.new(wrap_children(children))
        end
      end
      Models.register_model(Merror, id: :merror)
    end
  end
end
