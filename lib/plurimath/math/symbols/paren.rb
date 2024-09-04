module Plurimath
  module Math
    module Symbols
      class Paren < Symbol
        INPUT = {}.freeze

        def ==(object)
          object.class == object.class
        end

        def paren?
          true
        end
      end
    end
  end
end
