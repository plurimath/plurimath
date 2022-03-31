# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class BinaryFunction
        attr_accessor :parameter_one, :parameter_two

        def initialize(parameter_one = nil, parameter_two = nil)
          @parameter_one = parameter_one
          @parameter_two = parameter_two
        end

        def ==(object)
          object.parameter_one == parameter_one &&
            object.parameter_two == parameter_two
        end
      end
    end
  end
end
