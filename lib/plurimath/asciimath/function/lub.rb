# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      class Lub
        attr_accessor :values

        def initialize(values = [])
          @values = values
        end
      end
    end
  end
end
