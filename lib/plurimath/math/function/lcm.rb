# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Lcm
        attr_accessor :values

        def initialize(values = [])
          @values = values
        end
      end
    end
  end
end