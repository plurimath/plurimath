require_relative "common_mapping"

module Plurimath
  class Mathml
    module Parse
      class Mtd < CommonMapping
        model Plurimath::Math::Function::Td


        xml do
          root "mtd", mixed: true
        end
      end
    end
  end
end
