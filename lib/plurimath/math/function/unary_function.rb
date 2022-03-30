# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class UnaryFunction
        def ==(object)
          object.parameter_value == parameter_value
        end

        def parameter_value
          instance_variable_get(instance_variables[0])
        end
      end
    end
  end
end
