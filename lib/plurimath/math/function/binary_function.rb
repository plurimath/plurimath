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

        def to_asciimath
          "#{self.class.name.split('::').last.downcase}#{value_to_asciimath}"
        end

        def value_to_asciimath
          first_value = "(#{parameter_one.to_asciimath})" if parameter_one
          second_value = "(#{parameter_two.to_asciimath})" if parameter_two
          "#{first_value}#{second_value}"
        end

        def ==(object)
          object.parameter_one == parameter_one &&
            object.parameter_two == parameter_two
        end
      end
    end
  end
end
