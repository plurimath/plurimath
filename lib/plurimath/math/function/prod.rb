# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Prod < BinaryFunction
        attr_accessor :base, :exponent

        def initialize(base = nil, exponent = nil)
          @base = base
          @exponent = exponent
        end
      end
    end
  end
end
