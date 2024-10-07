require_relative "common_mapping"

module Plurimath
  class Mathml
    module Parse
      class Math < CommonMapping
        model Plurimath::Math::Formula

        xml do
          root "math", mixed: true
        end
      end
    end
  end
end
