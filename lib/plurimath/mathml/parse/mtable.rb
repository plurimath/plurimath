require_relative "mtr"
require_relative "mtd"

module Plurimath
  class Mathml
    module Parse
      class Mtable < Lutaml::Model::Serializable
        model Plurimath::Math::Function::Table

        attribute :value, Mtr, collection: true, default: -> { [] }

        xml do
          root "mtable"

          map_element :mtr, to: :value
        end
      end
    end
  end
end
