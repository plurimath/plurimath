# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class BinaryFunction
        def ==(object)
          object.first_parameter_value == first_parameter_value &&
            object.second_parameter_value == second_parameter_value
        end

        def first_parameter_value
          instance_variable_get(instance_variables[0])
        end

        def second_parameter_value
          instance_variable_get(instance_variables[1])
        end
      end
    end
  end
end
