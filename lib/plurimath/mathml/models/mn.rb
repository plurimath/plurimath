# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mn < Mml::V4::Mn
        include OrderedChildren

        def to_plurimath
          Math::Number.new(Array(value).join)
        end
      end
      Models.register_model(Mn, id: :mn)
    end
  end
end
