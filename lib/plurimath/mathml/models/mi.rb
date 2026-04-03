# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mi < Mml::V4::Mi
        include OrderedChildren

        def to_plurimath
          resolve_symbol(Array(value).join, self)
        end
      end
      Models.register_model(Mi, id: :mi)
    end
  end
end
