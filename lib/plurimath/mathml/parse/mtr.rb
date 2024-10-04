require_relative "mtd"

module Plurimath
  class Mathml
    module Parse
      class Mtr < Lutaml::Model::Serializable
        model Plurimath::Math::Function::Tr

        attribute :parameter_one, Mtd, collection: true, default: -> { [] }

        xml do
          root "mtr"

          map_element :mtd, to: :parameter_one
        end
      end
    end
  end
end