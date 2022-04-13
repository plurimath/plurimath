# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Underover
        attr_accessor :parameter_one, :parameter_two, :parameter_three

        def initialize(parameter_one = nil, parameter_two = nil, parameter_three = nil)
          @parameter_one = parameter_one
          @parameter_two = parameter_two
          @parameter_three = parameter_three
        end

        def to_asciimath
          first_value = parameter_one.to_asciimath if parameter_one
          second_value = "_(#{parameter_two.to_asciimath})" if parameter_two
          third_value = "^(#{parameter_three.to_asciimath})" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def ==(object)
          object.parameter_one == parameter_one &&
            object.parameter_two == parameter_two &&
            object.parameter_three == parameter_three
        end
      end
    end
  end
end
