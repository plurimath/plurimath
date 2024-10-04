# frozen_string_literal: true

require "lutaml/model"

module Plurimath
  class Mathml
    module Parse
      class Mn < Lutaml::Model::Serializable
        model Plurimath::Math::Symbols::Symbol

        attribute :value, :integer

        xml do
          root "mn"

          map_content to: :value
        end
      end
    end
  end
end
