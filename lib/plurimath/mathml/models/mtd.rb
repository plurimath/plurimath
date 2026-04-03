# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mtd < Mml::V4::Mtd
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          Math::Function::Td.new(children)
        end
      end
      Models.register_model(Mtd, id: :mtd)
    end
  end
end
