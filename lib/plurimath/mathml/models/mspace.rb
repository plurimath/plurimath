# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mspace < Mml::V4::Mspace
        include OrderedChildren

        def to_plurimath
          if linebreak && !linebreak.empty?
            Math::Function::Linebreak.new(
              nil,
              { linebreak: linebreak },
            )
          end
        end
      end
      Models.register_model(Mspace, id: :mspace)
    end
  end
end
