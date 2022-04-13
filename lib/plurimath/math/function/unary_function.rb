# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class UnaryFunction
        attr_accessor :parameter_one

        def initialize(parameter_one = nil)
          @parameter_one = parameter_one
        end

        def ==(object)
          object.class == self.class &&
            object.parameter_one == parameter_one
        end

        def to_asciimath
          "#{self.class.name.split('::').last.downcase}#{value_to_asciimath}"
        end

        def value_to_asciimath
          "(#{parameter_one.to_asciimath})" unless parameter_one.nil?
        end
      end
    end
  end
end
