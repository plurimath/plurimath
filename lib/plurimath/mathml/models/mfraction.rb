# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mfraction < Mml::V4::Mfraction
        include OrderedChildren

        def to_plurimath
          fraction_to_plurimath(children_to_plurimath)
        end
      end
      Models.register_model(Mfraction, id: :mfraction)
    end
  end
end
