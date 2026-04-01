# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Msline < Mml::V4::Msline
        include OrderedChildren

        def to_plurimath
          Math::Function::Msline.new
        end
      end
      Models.register_model(Msline, id: :msline)
    end
  end
end
