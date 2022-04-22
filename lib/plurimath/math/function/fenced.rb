# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Fenced
        attr_accessor :parameter_one, :parameter_two, :parameter_three

        def initialize(parameter_one = nil, parameter_two = nil, parameter_three = nil)
          @parameter_one   = parameter_one
          @parameter_two   = parameter_two
          @parameter_three = parameter_three
        end

        def to_asciimath
          first_value  = parameter_one ? parameter_one.to_asciimath : "("
          second_value = parameter_two.map(&:to_asciimath).join(",") if parameter_two
          third_value  = parameter_three ? parameter_three.to_asciimath : ")"
          "#{first_value}#{second_value}#{third_value}"
        end

        def ==(object)
          self.class == object.class &&
            object.parameter_one == parameter_one &&
            object.parameter_two == parameter_two &&
            object.parameter_three == parameter_three
        end
      end
    end
  end
end
