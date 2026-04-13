# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mfrac < Mml::V4::Mfrac
        include OrderedChildren

        def to_plurimath
          fraction_to_plurimath(children_to_plurimath)
        end
      end
      Models.register_model(Mfrac, id: :mfrac)
    end
  end
end
