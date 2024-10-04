# frozen_string_literal: true

require "lutaml/model"

module Plurimath
  class Mathml
    module Parse
      class Mo < Lutaml::Model::Serializable
        model Plurimath::Math::Symbols::Symbol

        attribute :value, :string

        xml do
          root "mo"

          map_content to: :value
      end
    end
  end
end
