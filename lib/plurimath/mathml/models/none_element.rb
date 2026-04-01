# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class NoneElement < Mml::V4::None
        include OrderedChildren

        def to_plurimath
          Math::Function::None.new
        end
      end
      Models.register_model(NoneElement, id: :none)
    end
  end
end
