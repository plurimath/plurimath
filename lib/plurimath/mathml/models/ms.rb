# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Ms < Mml::V4::Ms
        include OrderedChildren

        def to_plurimath
          Math::Function::Ms.new(value)
        end
      end
      Models.register_model(Ms, id: :ms)
    end
  end
end
