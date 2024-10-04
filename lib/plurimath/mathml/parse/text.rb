# frozen_string_literal: true

module Plurimath
  class Mathml
    module Parse
      class Text < Lutaml::Model::Serializable
        model Plurimath::Math::Function::Text

        attribute :parameter_one, :string

        xml do
          root "mi"

          map_content to: :parameter_one
        end
      end
    end
  end
end
