# frozen_string_literal: true

require "lutaml/model"

module Plurimath
  class Mathml
    module Parse
      class Mi < Lutaml::Model::Serializable
        model Plurimath::Math::Symbols::Symbol

        attribute :value, :string

        xml do
          root "mi"

          map_content to: :value
        end
      end
    end
  end
end
